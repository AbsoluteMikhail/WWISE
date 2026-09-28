# Wwise Gyms — учебный проект

Источник — папка `WwiseProject` из [официального репозитория Audiokinetic Gyms](https://github.com/audiokinetic/Gyms). Здесь используется её учебная копия с исходными звуками из `Originals` и `ExternalSources`. Unreal-сцены оригинального Gyms в неё не входят.

Копия адаптирована для Wwise 2025.1.11.9262.
Unreal-проект WWISE использует UE 5.7 и интеграцию Wwise 2025.1.11.9262.4509.

## Что открыть

Пути ниже указаны относительно этой папки:

- Wwise: [Gyms.wproj](Gyms.wproj).
- Unreal: [WWISE.uproject](../WWISE.uproject).
- Банки: `GeneratedSoundBanks/Windows`; генерируются локально для Windows и языка en_US (включая SFX).
- Настройки интеграции: [DefaultGame.ini](../Config/DefaultGame.ini).
- Unreal-ассеты Wwise: `../Content/WwiseAudio`, включая InitBank, события, Switch, RTPC и акустические текстуры.

Установка и первый запуск описаны в [основном README](../README.md).

## Примеры для первого занятия

| Задача | Объекты Wwise | Что собрать вручную в Blueprint |
|---|---|---|
| Запуск звука | PostEvent_Event | AkComponent → Post Event |
| Switch | Post_Switch_Event; группа AkSwitch; LowSwitch, HighSwitch, Default | Set Switch → Post Event на том же AkComponent |
| Шаги | Footstep_Event; Footstep_Switch: Wood, Metal, Grass | Выбрать материал → установить Switch → запустить шаг |
| RTPC | Post_RTPC_Event; параметр RTPC, диапазон 0–1200, начальное значение 600 | Запустить тон один раз; изменять параметр на том же компоненте |
| Выстрел | Fire_Shotgun | Запускать при подтверждённом выстреле |
| Луп | Looping_Event | Запустить один раз; сохранить Playing ID и остановить воспроизведение |
| Пространственный звук | SpatialAudioEvent, RoomTone, RoomTone_01, RoomTone_02 | Настроить источник, Room, реверберацию и при необходимости Portal |

RTPC в существующем примере управляет высотой тона. Это не готовый параметр боезапаса.
Для упражнения с магазином создайте отдельный Game Parameter AmmoPercent (0–100) и нужную зависимость в Wwise. Fire_Shotgun — одиночный выстрел; готовая логика автоматического оружия и окончания очереди не добавлялась.

Gyms содержит технические тесты, синтетические тоны и отдельные звуковые записи. Это набор примеров интеграции. Для первых упражнений используйте таблицу выше; тесты External Sources, локализации и DLC требуют дополнительной игровой логики.

## Генерация

Запустите [GenerateSoundBanks.cmd](../GenerateSoundBanks.cmd) из корня репозитория. Скрипт использует установленный Wwise и определяет расположение проекта относительно самого скрипта.

Альтернатива — открыть `Gyms.wproj` в Wwise, выбрать Windows и en_US и сгенерировать SoundBanks. Папка вывода — `GeneratedSoundBanks`, External Sources выводятся в `GeneratedSoundBanks/<Platform>/ExternalSources`.

Банки не хранятся в Git: после клонирования и изменений звука их нужно генерировать заново.

Тестовый `Originals/SFX/LargeMedia.wav` размером около 1 ГБ исключён: для занятий он не нужен. Вместо него оставлена [пометка](Originals/SFX/LargeMedia-README.md). Две ссылки на этот WAV в Wwise перенаправлены на существующий короткий `ShortMedia_0.wav`, чтобы SoundBanks продолжали генерироваться. Проверку работы с большими медиа эта учебная копия больше не воспроизводит.

Служебный тест Gyms `TooLongPathEvent` использует специально длинный путь. Его Unreal-ассет не включён в учебный проект; для упражнений из таблицы он не требуется.
