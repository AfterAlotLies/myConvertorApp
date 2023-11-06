//
//  ViewController.swift
//  CurrencyConverter
//
//  Created by Vyacheslav on 27.10.2023.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cadLabel: UILabel!
    @IBOutlet weak var chfLabel: UILabel!
    @IBOutlet weak var gbpLabel: UILabel!
    @IBOutlet weak var usdLabel: UILabel!
    @IBOutlet weak var jpyLabel: UILabel!
    @IBOutlet weak var rubLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getRates(_ sender: Any) {
        //1) Request & session
        //2) Response & data
        //3) Parsing & JSON serialization
        //in info list creat app transport security settings
        //потом добавить в него -> Allow Arbitrary Loads,что позволит отправлять запросы по юрл на http сайт
        //это нужно только,когда работа идет с хттп сайтами
        
        //1
        let url = URL(string: "http://data.fixer.io/api/latest?access_key=62b0759a6bbf31069a3f373e64abf653")
        
        let session = URLSession.shared //объект для отправки запросов и получения ответов от сервера
        
        
        //создается задача для выполнения запроса с используемым юрл
        //в клоужере определяется, что делать после выполнения запроса
        let task = session.dataTask(with: url!) { data, response, error in
            if error != nil {
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(self, animated: true)
            } else {
                //2
                if data != nil {
                    do{
                        let jsonResponse = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, Any> //такой тип всегда т.к мы не знаем какого точного типа будет значение у ключа
                        //ASYNC
                        //здесь происходит обновление лэйблов используя асинхронность
                        //это важно тк обновления должны происходить в основном потоке
                        //чтобы не блокать пользовательский интерфейс
                        DispatchQueue.main.async {
                            //ну тут все понятно - проверка извлечения данных на правильный тип и присавивание лэйблу
                            if let response = jsonResponse["rates"] as? [String : Any] {
                                if let cad = response["CAD"] as? Double {
                                    self.cadLabel.text = "CAD: \(cad)"
                                }
                                if let chf = response["CHF"] as? Double {
                                    self.chfLabel.text = "CHF: \(chf)"
                                }
                                if let gbp = response["GBP"] as? Double {
                                    self.gbpLabel.text = "GBP: \(gbp)"
                                }
                                if let usd = response["USD"] as? Double {
                                    self.usdLabel.text = "USD: \(usd)"
                                }
                                if let jpy = response["JPY"] as? Double {
                                    self.jpyLabel.text = "JPY: \(jpy)"
                                }
                                if let rub = response["RUB"] as? Double {
                                    self.rubLabel.text = "RUB: \(rub)"
                                }
                            }
                        }
                    } catch {
                        print("error")
                    }
                }
            }
        }
        task.resume() //повторно отсылает запрос на сервер и получается все стартует по новой(офк после нажатия кнопки)
    }
    
}

