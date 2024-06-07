local GUI = require("GUI")
local system = require("System")
local internet = require("Internet")

local workspace, window = system.addWindow(GUI.filledWindow(1, 1, 50, 16, 0xE1E1E1))

-- Заголовок окна
window:addChild(GUI.label(1, 1, window.width, 1, 0x2D2D2D, "Клиент Russian Post")):setAlignment(GUI.ALIGNMENT_HORIZONTAL_CENTER, GUI.ALIGNMENT_VERTICAL_TOP)

-- Поле ввода для номера отслеживания
window:addChild(GUI.text(2, 3, 0x878787, "Введите номер отслеживания:"))
local trackingNumberInput = window:addChild(GUI.input(2, 4, 46, 3, 0xFFFFFF, 0x787878, 0xCCCCCC, 0x2D2D2D, 0xFFFFFF, "", "Номер отслеживания"))

-- Кнопка для отправки запроса
local trackButton = window:addChild(GUI.roundedButton(18, 8, 14, 3, 0xCCCCCC, 0x2D2D2D, 0xAAAAAA, 0x2D2D2D, "Отследить"))

-- Текстовое поле для вывода результата
local resultText = window:addChild(GUI.textBox(2, 12, 46, 3, 0xE1E1E1, 0x2D2D2D, {}, 1, 0, 0))

workspace:draw()

-- Функция для обработки запроса
local function trackPackage(trackingNumber)
    local url = "https://tracking.russianpost.ru/rtm34" .. trackingNumber -- Пример API запроса
    local response, reason = internet.request(url)

    if response then
        local result = ""
        for chunk in response do
            result = result .. chunk
        end
        return result
    else
        return "Ошибка: " .. (reason or "Не удалось выполнить запрос")
    end
end

-- Обработчик нажатия кнопки
trackButton.onTouch = function()
    local trackingNumber = trackingNumberInput.text
    if trackingNumber == "" then
        GUI.alert("Пожалуйста, введите номер отслеживания")
    else
        local result = trackPackage(trackingNumber)
        resultText.lines = { result }
        workspace:draw()
    end
end

workspace:draw()
