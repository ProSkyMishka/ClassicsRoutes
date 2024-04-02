//
//  Constants.swift
//  Class'Ways
//
//  Created by Михаил Прозорский on 13.02.2024.
//

import UIKit

struct Constants {
    static let usersKey = ""
    
    static let coef: CGFloat = 24
    static let coef1: CGFloat = 4
    static let coef2: CGFloat = 36
    static let coef3: CGFloat = 8
    static let coef4: CGFloat = 16
    static let coef5: CGFloat = 2
    static let coef6: CGFloat = 1.25
    static let coef7: CGFloat = 5
    static let coef8: CGFloat = 0.025
    static let coef9: CGFloat = 0.95
    static let coef10: CGFloat = 0.3
    static let coef11: CGFloat = 0.03
    static let coef12: CGFloat = 0.85
    static let coef13: CGFloat = 0.19
    static let coef14: CGFloat = 10
    static let coef15: CGFloat = 0.7
    static let coef16: CGFloat = 0.05
    static let coef17: CGFloat = 0.9
    static let coef18: CGFloat = 3
    static let coef19: CGFloat = 0.072
    static let coef20: CGFloat = 0.02
    static let coef21: CGFloat = 15
    static let coef22: CGFloat = 0.35
    static let coef23: CGFloat = 0.89
    static let coef24: CGFloat = -1
    static let coef25: CGFloat = 80
    static let coef26: CGFloat = 40
    static let coef27: CGFloat = 50
    static let coef28: CGFloat = 0.028
    static let coef29: CGFloat = 0.042
    static let coef30: CGFloat = 0.52
    static let coef31: CGFloat = 0.37
    static let coef32: CGFloat = 0.6
    static let coef33: CGFloat = 200000
    static let coef34: CGFloat = 0.01
    static let coef35: CGFloat = 0.4115
    static let coef36: CGFloat = 0.2
    static let coef37: CGFloat = 0.035
    static let coef38: CGFloat = 0.5
    static let coef39: CGFloat = 1.1
    static let coef40: CGFloat = 0.15
    static let coef41: CGFloat = 0.005
    static let coef42: CGFloat = 0.72
    static let coef43: CGFloat = 0.27
    static let coef44: CGFloat = 0.06
    static let coef45: CGFloat = 0.13
    static let coef46: CGFloat = 0.08
    static let coef47: CGFloat = 0.425
    static let coef48: CGFloat = 32
    
    static let avatarCoef1: CGFloat = 0.8
    static let avatarCoef2: CGFloat = 0.25
    static let avatarCoef3: CGFloat = 0.07
    
    static let messageWait: UInt64 = 10_000_000
    static let chatWait: UInt64 = 300_000_000
    
    static let one: Int = 1
    static let offset: Int = 5
    static let minutes: Int = 60
    static let shadow: CGSize = CGSize(width: 2, height: 2)
    static let value: CGFloat = 20
    static let horiz1: CGFloat = 30
    static let horiz2: CGFloat = 70
    static let height: CGFloat = 50
    static let height1: CGFloat = 150
    static let width: CGFloat = 180
    static let rowHeight: CGFloat = 100
    static let step: Int = 25
    
    static let color: UIColor = UIColor(red: 181, green: 181, blue: 181, alpha: 255)
    static let red: UIColor = UIColor(red: 0.84, green: 0.78, blue: 0.77, alpha: 1)
    static let green: UIColor = UIColor(red: 0.77, green: 0.84, blue: 0.78, alpha: 1)
    static let gold: UIColor = UIColor(red: 0.76, green: 0.7, blue: 0.56, alpha: 1)
    
    static let letters = "qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM"
    static let digits = "1234567890"
    
    static let format = DateFormatter()
    static let dateFormat = "dd.MM.yyyy HH:mm:ss"
    static let locale = "ru_RU"
    static let timeZone = "Europe/Moscow"
    
    static let routeMessage = "Пройдем?"
    static let routeEnd = "Вы уверены, что хотите завершить маршрут преждевременно?"
    static let routeLike = "Вам понравился маршрут?"
    static let passwordFormatError = "error - Пароль должен иметь длину не менее 8 символов, быть написанным на латинице и содержать как минимум одну цифру, специальные символы не допускаются"
    static let nameFormatError = "error - Имя пользователя должно содержать хотя бы одну латинскую букву, специальные символы не допускаются"
    static let nameError = "error - Пользователь с таким именем уже существует"
    static let routeNameError = "error - Маршрут с таким названием уже существует"
    static let serverError = "Возникла проблема соединения, проверьте подключение к сети и перезапустите приложение. Если не помогло, то значит проблемы со стороны сервера и мы их уже решаем, немного подождите и перезапустите приложение. Приносим свои извинения"
    static let themeError = "error - Нужно выбрать хоть одну тему"
    static let formatError = "неверный формат"
    static let nameTaken = "имя занято"
    static let routeNameTaken = "название занято"
    static let differentPasswords = "не совпадает"
    static let notCome = "не подходит"
    static let headerLocations = "Here is a list of the locations"
    static let unknownCase = "unknown case"
    
    static let min = " мин."
    static let hour = " ч."
    static let time = "Время прохождения:"
    static let startPlace = "Точка старта:\n"
    static let withOutGrades = "Нет оценок"
    static let grade = "Оценка: "
    static let fromFive = "/5"
    static let stringFormat: NSString = "%.2f"
    static let places = "Места из маршрута:"
    
    static let nameString = "Имя"
    static let userNameString = "Имя пользователя"
    static let passwordString = "Пароль"
    static let repeatPasswordString = "Повторите пароль"
    static let avatarString = "аватар"
    static let newName = "Новое имя:"
    static let inputNewName = "введите новое имя"
    static let inputOldPassword = "введите старый пароль"
    static let inputNewPassword = "введите новый пароль"
    static let repeatNewPassword = "повторите новый пароль"
    static let oldPasswordString = "Старый пароль:"
    static let newPasswordString = "Новый пароль:"
    static let repeatString = "Повторите:"
    static let inputCoordinates = "Введите координаты"
    static let coordinatesFormat = "десятичные дроби через пробел"
    static let locationDesc = "Опишите локацию"
    static let newMessageString = "Сообщение"
    static let personString = "деятель"
    static let newNameRoute = "введите название"
    static let newDescRoute = "введите описание"
    static let newTimeRoute = "введите время в минутах"
    static let newStartRoute = "введите точку старта"
    static let themeRoute = "Тема маршрута"
    static let addLocation = "Добавить локацию"
    
    static let nilString = ""
    static let space = " "
    static let nilDate = "01.01.0001 01:00:00"
    static let file = "(file:"
    static let dote = "."
    static let splash = "/"
    
    static let likeSymbol = "hand.thumbsup.circle"
    static let dislikeSymbol = "hand.thumbsdown.circle"
    static let eyeSymbol = "eye.fill"
    static let backSymbol = "chevron.left"
    static let crossSymbol = "xmark"
    static let tickSymbol = "checkmark"
    static let trashSymbol = "trash.circle"
    static let trashFillSymbol = "trash.fill"
    static let editSymbol = "square.and.pencil"
    static let arrowLeftSymbol = "arrowshape.left.fill"
    static let arrowRightSymbol = "arrowshape.right.fill"
    static let sendSymbol = "arrow.up.circle.fill"
    
    static let identityPoolId = "us-east-1:b670d5bd-1bb8-426f-88b8-432b9e78cb63"
    static let bucketName = "classicsroutesbucket"
    
    static let localhost = "http://127.0.0.1:8080"
    static let localSocketHost = "ws://127.0.0.1:8080/echo"
    static let applicationJSON = "application/json"
    static let contentType = "Content-Type"
    
    static let fon = "fon.png"
    static let pictureError = "pictureError.png"
    
    static let minus = "-"
    static let plus = "+"
    
    static let regString = "Регистрация"
    static let regedString = "Регистрация: "
    static let gone = "Пройдено маршрутов: "
    static let authString = "Авторизация"
    static let come = "Войти"
    static let signOut = "Выйти"
    static let settings = "Настройки"
    static let continueString = "Дальше"
    static let backString = "Назад"
    static let withOutAccount = "Нет аккаунта"
    static let withAccount = "Есть аккаунта"
    static let start = "Начать"
    static let denied = "Отказаться"
    static let end = "ЗАВЕРШИТЬ"
    static let add = "ДОБАВИТЬ"
    static let ready = "Готово"
    static let suggestString = "предложить маршрут"
    static let addRouteString = "добавить маршрут"
    static let choose = "Выберите"
    static let addImage = "добавить фото"
    static let chooseImage = "Выберите аватар маршрута"
    static let chooseOne = "выбрать"
    static let createString = "CОЗДАТЬ"
    static let updateString = "ИЗМЕНИТЬ"
    
    static let acceptMessage = "Я с радостью пройду с тобой маршрут "
    static let deniedMessage = "Я не смогу пройти с тобой маршрут "
    
    static let defaultConfiguration = "Default Configuration"
    
    static let themeAsk = "Что Вам ближе?"
    static let themeWriter = "Писатели"
    static let themeArtist = "Художники"
    static let themeHistorical = "Исторические лица"
    
    static let chatsString = "Чаты"
    static let ratingString = "Рейтинг"
    
    static let userRole = "user"
    static let adminRole = "admin"
    
    static let withOutAvatar = "withOutAvatar.png"
    static let boyAvatar = "boyAvatar.png"
    static let girlAvatar = "girlAvatar.png"
    
    static let profilePng = "profile.png"
    static let profileGrayPng = "profileGray.png"
    static let chatPng = "chat.png"
    static let chatGrayPng = "chatGray.png"
    static let ratingPng = "rating.png"
    static let ratingGrayPng = "ratingGray.png"
    static let routesPng = "routes.png"
    static let routesGrayPng = "routesGray.png"
}
