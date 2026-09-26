# Wwise Gyms — локальная учебная копия

Источник: `WwiseProject (https://github.com/audiokinetic/Gyms)`. Исходный проект не изменялся.
Скопирован весь Wwise-проект с Originals и ExternalSources, без исходного кэша и пользовательских настроек. Unreal-ассеты Gyms не переносились.

Копия обновлена с Wwise 2025.1.3.8968 до установленного Wwise 2025.1.11.9262.
Unreal-проект WWISE использует UE 5.7 и интеграцию Wwise 2025.1.11.9262.4509.

## Что открыть

- Wwise: `Gyms.wproj` в этой папке.
- Unreal: `../WWISE.uproject`.
- Банки: `GeneratedSoundBanks/Windows`, сгенерированы для Windows и языка en_US (включая SFX).
- Привязка к копии записана в `Config/DefaultGame.ini` Unreal-проекта.
- В `Content/WwiseAudio` созданы 197 Unreal-ассетов, включая InitBank, события, Switch, RTPC и акустические текстуры. InitBank назначен в настройках.
- Исходный пустой Wwise-проект оставлен в `WWISE_WwiseProject`.
- Резервная копия прежнего DefaultGame.ini: `Saved/Backups/GymsImport_20260926_130127/DefaultGame.ini`.

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

В Wwise выберите Windows и en_US и сгенерируйте SoundBanks. Пути генерации в копии изменены с папки Unity на локальную GeneratedSoundBanks. External Sources выводятся в GeneratedSoundBanks/<Platform>/ExternalSources.

Для повторной генерации из PowerShell:

```powershell
& "$env:WWISEROOT\Authoring\x64\Release\bin\WwiseConsole.exe" generate-soundbank './Gyms_WwiseProject/Gyms.wproj' --platform Windows --language en_US --no-source-control --abort-on-load-issues
```

Копия полная: файл Originals/SFX/LargeMedia.wav занимает около 1 ГБ и нужен только для теста большого медиа. Он сохранён вместе с остальными зависимостями; для занятия его использовать не требуется.

При миграции WwiseConsole создал лишний некорректный пустой файл Sidechain Mixes.wwu в корне. Он перенесён в резервную папку рядом с прежним DefaultGame.ini; исходная корректная Sidechain Mixes/Default Work Unit.wwu сохранена. После этого загрузка проекта и генерация банков прошли без диагностик ошибок.

## Проверка переноса

- Все 79 WAV-файлов в Originals и ExternalSources сверены с источником по SHA-256: совпадают.
- WwiseConsole 2025.1.11 успешно загружает проект и генерирует банки Windows/en_US.
- Unreal 5.7 прочитал метаданные GeneratedSoundBanks и создал перечисленные ассеты. Все события из учебной таблицы присутствуют.
- Служебный тест TooLongPathEvent остался в Wwise, но его Unreal-ассет не создан: специально длинный путь превышает ограничение 260 символов. Остальные ассеты импортированы. Поэтому полный WwiseReconcile завершился с ненулевым кодом, несмотря на создание нужных учебных ассетов.
- Командная проверка Unreal выполнялась без звука; прослушивание в PIE ещё не проводилось. Для изолированной проверки использовался временный кэш в памяти, поскольку песочница не разрешает запись в общий пользовательский DDC; постоянные настройки DDC не изменялись.

Логи: `Saved/Logs/Gyms-SoundBank-Generation.log` и `Saved/Logs/Gyms-Reconcile.log` в Unreal-проекте.
