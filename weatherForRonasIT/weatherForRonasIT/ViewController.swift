//
//  ViewController.swift
//  weatherForRonasIT
//
//  Created by Mac Mini on 18.02.2020.
//  Copyright © 2020 veniaminCompany. All rights reserved.
//


// Не сделал: обновлени по свайпу,определение направления ветра со сторонами света по градусам (поэтому и сам ветер не добавлял). Также не понял где параметр вероятности дождя. Горизонтальную ориентацию не добавил, местоположение тоже (я знаю как делать - нету времени: дать разрешение на получение местоположения при запуске разок, получить координаты и название города - по координатам запрашиваем погоду, а имя города (если получено) с помощью транслита выводим в лэйбл).

// Я хотел сделать красиво и сохранять параметры списка городов в памяти телефона как массив объектов  - чтобы при запуске приложения сразу отобразить данные и не делать новый запрос о погоде, если дата последнего не более 10 минут назад для каждого города в частности (таким образом не получить бан за частые запросы). Но внезапно я узнал, что UserDefaults не позволяет хранить объекты и нужно использовать Codable и сохранять в json. К сожалению, у меня нет на это времени из-за загрузки и прочего. Сделал как есть - я бы мог попозже сделать и прилепить другие бантики, описанные выше, но HR меня практически палкой гоняет, чтобы я как можно быстрее отправил тестовое задание, поэтому просить еще денек не буду - мне страшно =)



import UIKit

class ViewController: UIViewController {
    
    var choosedCity: City? // переменная выбранного города
    
    var choosedTemperatureType = typeOfTemperature.celsius // устанавливаем тип температуры по умолчнию
    
    var cityPicker = UIPickerView() // создаем pickerView
    var toolbarForPickerView = UIToolbar() // создаем тулбар для pitckerView
    
    
    // --------- изменяемы элементы инфорации погоды ---------
    
    @IBOutlet weak var cityLabel: UILabel! // лэйбл города
    
    @IBOutlet weak var weatherIcon: UIImageView! // иконка погоды
    
    
    @IBOutlet weak var tempLabel: UILabel! // лэйбл температуры
    
    
    @IBOutlet weak var weatherMainConditionLabel: UILabel! // лэйбл основного описания состояния погоды
    
    
    @IBOutlet weak var windSpeedLabel: UILabel! // лэйбл скорости ветра
    
    @IBOutlet weak var pressureLabel: UILabel! // лэйбл атмносферного давления
    
    
    @IBOutlet weak var humidityLabel: UILabel! // лэйбл влажности воздуха
    
    @IBOutlet weak var rainPossibilityLabel: UILabel!
    
    // -------------------------------------------------------
    
    
    func refreshLabelsOnScreen() { // обновляем лэйблы и картинку на экране
        
        if let choosedCityName = choosedCity?.name { // обновляем имя города
            cityLabel.text = choosedCityName
        } else {
            cityLabel.text = "Неизвестно"
        }
        
        if let icon = choosedCity?.icon { // по полученному коду картинки меняем ее
            
            switch icon {
            case "01d",
                 "01n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "sun.png")}, completion: nil) // изменение изображения с анимацией
            case "02d",
                 "02n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "partly cloudy.png")}, completion: nil) // изменение изображения с анимацией
            case "03d",
                 "03n",
                 "04d",
                 "04n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "cloud.png")}, completion: nil) // изменение изображения с анимацией


            case "09d",
                 "09n",
                 "10d",
                 "10n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "rain.png")}, completion: nil) // изменение изображения с анимацией
            case "11d",
                 "11n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "storm.png")}, completion: nil) // изменение изображения с анимацией
            case "13d",
                 "13n":
                UIView.transition(with: weatherIcon, duration: 0.2, options: .transitionCrossDissolve, animations: {self.weatherIcon.image = UIImage(named: "storm.png")}, completion: nil) // изменение изображения с анимацией
            default:
                weatherIcon.image = nil // очищаем картинку, если неизвестен полученный код
            }
            
        } else {
            weatherIcon.image = nil
        }
        
        
        if let temp = choosedCity?.temp { // обновляем значение температуры
            tempLabel.text = temp
        } else {
            tempLabel.text = nil
        }
        
        if let main = choosedCity?.main { // обновляем основное описание состояния погоды
            weatherMainConditionLabel.text = main
        } else {
            weatherMainConditionLabel.text = "Неизвестно"
        }
        
        if let wind = choosedCity?.wind { // обновляем значение скорости ветра
            windSpeedLabel.text = wind
        } else {
            windSpeedLabel.text = nil
        }
        
        if let pressure = choosedCity?.pressure { // обновляем значение атмносферного давления
            pressureLabel.text = pressure + " мм рт. ст."
        } else {
            pressureLabel.text = nil
        }
        
        if let humidity = choosedCity?.humidity { // обновляем значение влажности
            humidityLabel.text = humidity + "%"
        } else {
            humidityLabel.text = nil
        }
        
        if let rainPossibility = choosedCity?.rainPossibility { // обновляем значение вероятности дождяы®
            rainPossibilityLabel.text = rainPossibility
        } else {
            rainPossibilityLabel.text = nil
        }
        
        
    }
    
    
    
    @IBOutlet weak var imageViewOfChoosedTypeTemperature: UIImageView!  // imageView выбора типа температуры
    
    @IBOutlet weak var ChangeCity: UIButton! // кнопка "сменить город"
    
    @IBAction func ChangeCityButtonTapped(_ sender: Any) { // тап на кнопку "сменить город"
        
        ChangeCity.isEnabled = false // дизейблим кнопку, чтобы не добавлялись новые сабвью
        
        choosedCity = cities[0] // хардкодное исправление поведения, связанное с тем, что пикер без изменения совего положения не выбирает первый город
        
        cityPicker = UIPickerView.init() // инициируем pickerView (уже был создан)
        cityPicker.delegate = self // связываем с делегатом
        
        cityPicker.backgroundColor = UIColor.white
        cityPicker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300) // указываем местоположение pickerView на экране
        
        //self.view.addSubview(cityPicker) // добавляем pickerView как subview
        
        
        
        toolbarForPickerView = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50)) // инициируем toolBar (уже был создан) и указываем его местоположение
        toolbarForPickerView.sizeToFit() // устанавливаем нужный размер
        
        let chooseButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(ViewController.saveChoosedCity)) // создаем кнопку выбора города и прописываем действие
        
        toolbarForPickerView.setItems([chooseButton], animated: true) // добавляем созданную кнопку
        toolbarForPickerView.isUserInteractionEnabled = true // разрешаем взаимодействовать с пользователем
        
        
        UIView.transition(with: self.view, duration: 0.4, options: [.transitionCrossDissolve], animations: { // добавляем анимацию появления
            self.view.addSubview(self.cityPicker) // добавляем pickerView как subview
            self.view.addSubview(self.toolbarForPickerView) // добавляем тулбар как subview
        }, completion: nil)
        
        
        
    }
    
//    @objc func dismissKeyboard() { // самописная функция, которой скрываем pickerView
//        view.endEditing(true)
//    }
    
    @objc func saveChoosedCity() { // сохраняем выбор города - есть проблема, что самый первый город в списке не выбирается, если сперва не выбрать другой город пикером, а потом вернуться на первый и нажать "Выбрать". Исправил хардкодом при нажатии кнопки "Смеить город" - сразу устанавливать выбранный город первым в списке - но это не круто
        UIView.transition(with: self.view, duration: 0.25, options: [.transitionCrossDissolve], animations: { // прописываем анимацию для убирания pickerView и тулбара
            self.cityPicker.removeFromSuperview() // убираем pickerView
            self.toolbarForPickerView.removeFromSuperview() // убираем тулбар для pickerView
        }, completion: nil)
        ChangeCity.isEnabled = true // активируем кнопку возможности смены города
        requestWeatherInfoFromSever(cityId: choosedCity?.id, cityName: nil) // запрашиваем погоду
        refreshLabelsOnScreen() // обновляем лэйблы экрана в соответствии с выбранным городом
    }
    
    
    
    override func viewDidLoad() { // функция, запускающая код посде прогрузки вью
        super.viewDidLoad()
        
        let tapRecognizerOnDegrees = UITapGestureRecognizer(target: self, action: #selector(tapOnDegrees)) // добаваляем рекогнайзер тапа, при его срабатываении вызовется функция tapOnDegrees
        imageViewOfChoosedTypeTemperature.addGestureRecognizer(tapRecognizerOnDegrees) // добавялем рекоганйзер на uiView типа температуры
        imageViewOfChoosedTypeTemperature.isUserInteractionEnabled = true // прописываем, что взаимодействие юзера с изображением возможно
        
//        createCityPicker() // создаем uiPicker выбора города
//        createToolBarForPickerView() // создаем тулбар для uiPickerView
        
        choosedCity = cities[0] // записываю первый город из списка - с памятью телефона нет времени разбираться
        refreshLabelsOnScreen() // обновляю экран
        requestWeatherInfoFromSever(cityId: choosedCity?.id, cityName: nil) // запрашиваем погоду (внутри обновляем лэйблы экрана)
    }
    
    
    override func viewDidAppear(_ animated: Bool) { // функция, выполняющая код после полного появления вью
        //getSavedListOfCities() // получем сохраненные города из памяти телефона (если они есть)
    }
    
    
    @objc func tapOnDegrees() { // функция, которая вызывается рекогнайзером tapRecognizerOnDegrees
        switchTypeTemperature()
    }
    
    enum typeOfTemperature: String { // enum типа температуры - цельсий или фаренгейт
        case celsius = "metric"
        case fahrenheit = "imperial"
    }
    
    func switchTypeTemperature() { // функция, изменяющая тип выбранной температуры
        if choosedTemperatureType == typeOfTemperature.celsius {
            choosedTemperatureType = typeOfTemperature.fahrenheit
            UIView.transition(with: imageViewOfChoosedTypeTemperature, duration: 0.2, options: .transitionCrossDissolve, animations: {self.imageViewOfChoosedTypeTemperature.image = UIImage(named: "DegreesF2.png")}, completion: nil) // изменение изображения с анимацией
            //imageViewOfChoosedTypeTemperature.image = UIImage(named: "DegreesF2.png")
        } else if choosedTemperatureType != typeOfTemperature.celsius {
            choosedTemperatureType = typeOfTemperature.celsius
            UIView.transition(with: imageViewOfChoosedTypeTemperature, duration: 0.2, options: .transitionCrossDissolve, animations: {self.imageViewOfChoosedTypeTemperature.image = UIImage(named: "DegreesC2.png")}, completion: nil) // изменение изображения с анимацией
            //imageViewOfChoosedTypeTemperature.image = UIImage(named: "DegreesC2.png")
        }
    }
    
    var cities: [City] = [City(name: "Москва", id: "524894"), City(name: "Санкт-Петебург", id: "536203"), City(name: "Новосибирск", id: "1496747")]
    
    
    
//    func createCityPicker() { // функия создающая UIPickerView и связывающая pickerView с основным UI
//        let cityPicker = UIPickerView()
//        cityPicker.delegate = self
//
//    }
//
//    func createToolBarForPickerView() { // создаем тулбар для pickerView, чтобы там положить кнопочки
//        let toolbarForPickerView = UIToolbar() // создаем тулбар
//        toolbarForPickerView.sizeToFit() // устанавливаем нужный размер
//
//        let chooseButton = UIBarButtonItem(title: "Выбрать", style: .done, target: self, action: #selector(ViewController.dismissKeyboard)) // создаем кнопку выбора города и прописываем действие
//
//
//        toolbarForPickerView.setItems([chooseButton], animated: true) // добавляем созданную кнопку
//
//        toolbarForPickerView.isUserInteractionEnabled = true // разрешаем взаимодействовать с пользователем
//
//    }
    
    
//    func saveListOfCitiesToMemory() { // записываем список городов и их сохраненные значения в телефон (чтобы хранить дату последнего запроса - тем самым не "дедося" (лол, дедося) api погоды и не получить бан
//        UserDefaults.standard.set(cities, forKey: "savedListOfCities") // сохраняем список городов в памяти телефона
//    }
//
//    func getSavedListOfCities() { // получаем сохраненный список городов из памяти телефон (если он есть)
//        if let cities = UserDefaults.standard.object(forKey: "savedListOfCities") as? [City] {
//            self.cities = cities // сохраняем полученные города и их значения из памяти телефона в переменную
//        } else {
//            saveListOfCitiesToMemory()
//            print("Был первый запуск приложения - сохраняем список городов в памяти телефона")
//        }
//    }
//
//    func saveChoosedCityToMemory() { // сохраняем выбранный город в пямти телефона. Сделал его отдельно, чтобы не мудрить, к тому же выбранный город может быть определен по геолокации, так что так проще
//        //guard let choosedCity = choosedCity else {return} // делаем unwrapped choosedCity, чтобы сохранить
//        UserDefaults.standard.set(choosedCity, forKey: "savedChoosedCity") // сохраняем выбранный город
//    }
//
//    func getSavedChoosedCity() {
//        if let choosedCity = UserDefaults.standard.object(forKey: "savedChoosedCity") as? City {
//            self.choosedCity = choosedCity
//            print("Получили сохраненное значение выбранного города из памяти телефона")
//        } else {
//            print("В памяти телефона не было сохраненного выбранного города, сохраняем стандартное значение")
//            let city = cities[0] // вытаскиваем первый город из массива городов
//            self.choosedCity = city // сохраняем первый город в переменной из массива городов
//            saveChoosedCityToMemory() // сохраняем выбранный город в памяти телефона
//        }
//    }
    
    
    
    let webKey = "ce685f00b3fa995a27cf75f7f2f0e574" // личный ключ для запроса к Weather API
    
    func requestWeatherInfoFromSever(cityId: String?, cityName: String?) { // функция запроса погоды по id города или по названию
        
        var requestString = String()
        let nowDate = Date() // текущее врмемя
        
        if let cityId = cityId { // если указали id города - работаем с ним
            print("Choosed temperatureType = \(choosedTemperatureType)")
            requestString = "https://api.openweathermap.org/data/2.5/weather?id=\(cityId)&appid=\(webKey)&units=\(choosedTemperatureType.rawValue)"
            print("Делаем запрос на погоду по id города")
            
            // поскольку cityId в этом случае может быть у выбранного города - проверяем дату последнего запроса
            if let lastRequestedDate = choosedCity?.lastRequestedDate {

                if nowDate.timeIntervalSince1970 - lastRequestedDate.timeIntervalSince1970 < 600 { // если с момента последнего запросе прошло меньше 600 секунд (10 минут)
                    print("Выходим из функции getWeatherInfoFromSever(), поскольку последний запрос был менее 10 минут назад")
                    return
                }
            }
            
        } else if let cityName = cityName { // иначе, если указали имя города, но id отсутствует - работаем с именем города
            requestString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(webKey)"
            print("Делаем запрос на погоду по имени города")
        }
        

        
        choosedCity?.lastRequestedDate = nowDate // записываем текущее время последнего запроса
        
        guard let url = URL(string: requestString) else {return} // делаем url из строки
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in // создаем URLSession
            
            guard let responseData = data else { // unwrapped data
                
                if let error = error {
                    print("Ошибка при запросе погоды в функции getWeatherByCityCode(): \(error)")
                }
                return
            }
            
//            if let response = response {
//                print("код ответа при запросе погоды: \(response)")
//            }
            
            do {
                let parsedResponse = try JSONDecoder().decode(WeatherJsonResponseDecodable.structJsonWeatherResponse.self, from: responseData)
                print("Ответ распарсен успешно! parsedResponse: \(parsedResponse)")
                
                let takenWeather = parsedResponse.weather
                
                print("takenWeather: \(takenWeather)")
                self.choosedCity?.icon = takenWeather[0].icon
                self.choosedCity?.main = takenWeather[0].main
                
                self.choosedCity?.rainPossibility = "--"
                
                
                let takenMainWeather = parsedResponse.main
                
                self.choosedCity?.humidity = String(takenMainWeather.humidity)
                self.choosedCity?.pressure = String(takenMainWeather.pressure)
                self.choosedCity?.temp = String(takenMainWeather.temp)
                
            } catch let parsingJsonError {
                print("Ошибка парсинга json-ответа: \(parsingJsonError)")
            }
        }
        .resume() // для URLdataTask
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { // делаем асинхронную задержку перед выполнением, чтобы json успел пропарситься (этот парсинг жделается асинхронно, поэтому функция обновления вызывается раньше, чем нужно)
            self.refreshLabelsOnScreen() // обновляем лэйблы
        })
        
    }
    
    
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource { // расширение класса, которым создаем pickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // сколько компонентов в pickerView
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { // количество компонентов в pickerView
        return cities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // название компонента для каждой строки
        return cities[row].name // записываем имя города
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { // записываем выбранный город по выбранной строке
        choosedCity = cities[row]
    }
    
}

