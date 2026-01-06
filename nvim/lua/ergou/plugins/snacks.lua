--       local logo = [[
-- ⠄⠄⠄⠄⢠⣿⣿⣿⣿⣿⢻⣿⣿⣿⣿⣿⣿⣿⣿⣯⢻⣿⣿⣿⣿⣆⠄⠄⠄
-- ⠄⠄⣼⢀⣿⣿⣿⣿⣏⡏⠄⠹⣿⣿⣿⣿⣿⣿⣿⣿⣧⢻⣿⣿⣿⣿⡆⠄⠄
-- ⠄⠄⡟⣼⣿⣿⣿⣿⣿⠄⠄⠄⠈⠻⣿⣿⣿⣿⣿⣿⣿⣇⢻⣿⣿⣿⣿⠄⠄
-- ⠄⢰⠃⣿⣿⠿⣿⣿⣿⠄⠄⠄⠄⠄⠄⠙⠿⣿⣿⣿⣿⣿⠄⢿⣿⣿⣿⡄⠄
-- ⠄⢸⢠⣿⣿⣧⡙⣿⣿⡆⠄⠄⠄⠄⠄⠄⠄⠈⠛⢿⣿⣿⡇⠸⣿⡿⣸⡇⠄
-- ⠄⠈⡆⣿⣿⣿⣿⣦⡙⠳⠄⠄⠄⠄⠄⠄⢀⣠⣤⣀⣈⠙⠃⠄⠿⢇⣿⡇⠄
-- ⠄⠄⡇⢿⣿⣿⣿⣿⡇⠄⠄⠄⠄⠄⣠⣶⣿⣿⣿⣿⣿⣿⣷⣆⡀⣼⣿⡇⠄
-- ⠄⠄⢹⡘⣿⣿⣿⢿⣷⡀⠄⢀⣴⣾⣟⠉⠉⠉⠉⣽⣿⣿⣿⣿⠇⢹⣿⠃⠄
-- ⠄⠄⠄⢷⡘⢿⣿⣎⢻⣷⠰⣿⣿⣿⣿⣦⣀⣀⣴⣿⣿⣿⠟⢫⡾⢸⡟⠄.
-- ⠄⠄⠄⠄⠻⣦⡙⠿⣧⠙⢷⠙⠻⠿⢿⡿⠿⠿⠛⠋⠉⠄⠂⠘⠁⠞⠄⠄⠄
-- ⠄⠄⠄⠄⠄⠈⠙⠑⣠⣤⣴⡖⠄⠿⣋⣉⣉⡁⠄⢾⣦⠄⠄⠄⠄⠄⠄⠄⠄
--     ]]
-- local logo = [[
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣿⣶⣦⣄⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣤⣶⣾⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⠿⠿⠿⣿⣿⣿⣿⠿⠿⠿⢿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⢀⡀⣄⠀⠀⠀⠀⠀⠀⠀⣿⣿⠟⠉⠀⢀⣀⠀⠀⠈⠉⠀⠀⣀⣀⠀⠀⠙⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⣀⣶⣿⣿⣿⣾⣇⠀⠀⠀⠀⢀⣿⠃⠀⠀⠀⠀⢀⣀⡀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠹⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⣼⡏⠀⠀⠀⣀⣀⣉⠉⠩⠭⠭⠭⠥⠤⢀⣀⣀⠀⠀⠀⢻⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⣿⠷⠒⠋⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠑⠒⠼⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠳⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠈⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⢹⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⣿⣿⣿⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣧⡀⠀⠀
-- ⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣶⣤⣄⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀
-- ⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀
-- ⠀⠀⣀⠀⢸⡿⠿⣿⡿⠋⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠉⠀⠻⠿⠟⠉⢙⣿⣿⣿⣿⣿⣿⡇
-- ⠀⠀⢿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠈⠻⠿⢿⡿⣿⠳⠀
-- ⠀⠀⡞⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣇⡀⠀⠀
-- ⢀⣸⣀⡀⠀⠀⠀⠀⣠⣴⣾⣿⣷⣆⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⣰⣿⣿⣿⣿⣷⣦⠀⠀⠀⠀⢿⣿⠿⠃⠀
-- ⠘⢿⡿⠃⠀⠀⠀⣸⣿⣿⣿⣿⣿⡿⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⢻⣿⣿⣿⣿⣿⣿⠂⠀⠀⠀⡸⠁⠀⠀⠀
-- ⠀⠀⠳⣄⠀⠀⠀⠹⣿⣿⣿⡿⠛⣠⠾⠿⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠿⠿⠳⣄⠙⠛⠿⠿⠛⠉⠀⠀⣀⠜⠁⠀⠀⠀⠀
-- ⠀⠀⠀⠈⠑⠢⠤⠤⠬⠭⠥⠖⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠒⠢⠤⠤⠤⠒⠊⠁⠀⠀⠀⠀⠀⠀
-- ]]
-- local logo = [[
-- ⣿⣿⣿⣿⠟⣩⣭⡙⠿⠿⠟⢘⣛⣛⡀⠿⠿⠏⣡⣶⣌⢻⣿⣿⣿⣿
-- ⣿⣿⣿⡿⢆⣹⣿⣷⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣿⣿⣧⡺⢿⣿⣿⣿
-- ⣿⡿⢋⣴⣿⣿⣿⣿⣟⣛⣿⣿⣿⣿⣿⣟⣛⣻⣿⣿⣿⣿⣦⡈⢻⣿
-- ⡟⢠⣿⣿⣿⣿⣿⡟⠉⠍⢻⣿⣿⣿⣿⠋⠭⠙⣿⣿⣿⣿⣿⣿⡄⢻
-- ⡇⣾⣿⣿⣟⡝⣙⣹⢲⣶⣾⡿⠟⠻⢿⣶⣤⡖⡙⡛⡛⣻⣿⣿⡧⢸
-- ⣧⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣮⣵⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⣸
-- ⡿⠷⠌⠛⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢋⣐⠛
-- ⣷⣮⣭⣭⠶⣤⣂⡩⠙⡛⠿⢿⣿⣿⣿⣿⣿⣿⡿⢿⣿⡿⠛⣭⣥⣶
-- ⣿⣿⣿⣿⣧⡙⢿⣿⣿⣶⣦⣤⣄⣈⣉⠉⠛⠛⢸⣶⣶⣶⣧⡘⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣦⣍⡛⠿⢿⣿⣿⣿⣿⣿⣿⡆⠻⠿⠷⠾⢛⣡⣿⣿
-- ⣿⣿⣿⣿⣿⣿⣿⣿⣿⣀⣒⣤⣬⣭⣙⠻⠄⣶⣿⣿⣿⣿⣿⣿⣿⣿
-- ]]
-- local logo = [[
-- ⠀⠀⠀⠀⠀⠀⢀⡞⠹⣦⠰⡞⠙⣆⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⢴⠀⠀⣿⠐⡇⠀⢻⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⠀⢸⠀⠀⣿⢸⡇⠀⢸⠀⠀⠀⠀⠀⠀
-- ⠀⠀⠀⠀⠀⢀⡸⣄⠀⣿⣨⡇⠀⣟⡀⠀⠀⠀⠀⠀
-- ⠀⠀⢠⡶⠚⠉⢁⡀⠀⠀⠀⠀⠀⡈⠉⠙⠲⣤⡀⠀
-- ⢀⡶⠋⠀⢀⠔⠉⠀⠀⠀⠀⠀⠀⠈⠑⢄⠀⠈⠻⡄
-- ⣾⠁⠀⠀⠈⠀⣠⣂⡄⠀⠀⠀⣔⣢⠀⠈⠀⠀⠀⢹
-- ⡇⠀⠀⢠⣠⣠⡌⠓⠁⠀⡀⠀⠙⠊⡄⢀⣀⠀⠀⢸
-- ⢷⡀⠀⠈⠁⠁⠀⠀⠈⠓⡓⠂⠀⠀⠉⠈⠁⠀⠀⡼
-- ⠈⠳⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡞⠁
-- ⠀⠀⢾⠀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⢸⠀⠀
-- ⠀⠀⠈⢻⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡾⠊⠁⠀
-- ⠀⠀⠀⠘⣇⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⡀⣷⠀⠀⠀
-- ⠀⠀⠀⠀⢿⣼⠉⠉⠙⠛⠛⠛⠛⠉⢹⣁⠟⠀⠀⠀
-- ]]
local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⣽⣿⣳⣄⠀⠀⢠⣖⣿⣾⣭⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣰⣻⡟⠀⠈⢿⣯⣧⠀⣾⣿⡇⠀⠙⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⠁⠀⠀⢸⣿⣿⢀⣽⣿⡇⠀⠀⢸⣿⣾⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡏⠀⠰⠀⠈⣿⣿⢸⣙⣿⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣟⣿⡇⠀⠨⠀⢠⣿⣿⢨⣿⣿⠀⠀⠀⠀⣿⡿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⡆⠀⢸⣿⣿⢻⣽⣿⠀⠀⠀⠀⣿⣧⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡇⠀⢀⠀⢸⣿⣿⠸⣿⣿⠀⠀⠀⠀⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣿⠀⠸⠀⢸⣿⣿⣼⣿⣿⠀⠀⠀⢸⣿⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣴⣿⣿⣧⠀⠁⠘⣿⣿⣽⣿⡏⠀⠀⠀⣾⣿⢧⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⡤⣒⣭⡿⠿⠛⠛⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠁⠉⠛⠛⠻⠿⣯⣿⣂⢄⡀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣠⣺⣽⡿⠋⠉⠀⠀⠀⠀⠀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡀⠀⠀⠀⠀⠀⠉⠛⢷⣯⡢⡄⠀⠀⠀⠀
⠀⠀⠀⢀⣮⣾⠟⠁⠀⠀⠀⠀⢀⣠⡶⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⠳⣦⣄⠀⠀⠀⠀⠀⠙⢿⣮⣢⠀⠀⠀
⠀⠀⣠⣿⡿⠋⠀⠀⠀⠀⠀⣠⡾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡀⠀⠀⠀⠀⠀⠹⣿⣷⡀⠀
⠀⣰⣿⡿⠁⠀⠀⠀⠀⠀⢰⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⡄⠀⠀⠀⠀⠀⠹⣷⣷⠀
⢠⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠛⡛⣷⡄⠀⠀⠀⠀⠀⠀⠀⣴⡟⠛⢳⣄⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⢻⡏⡇
⢸⣾⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⡷⠟⣿⡇⠀⠀⠀⠀⠀⠀⠀⣿⣟⠚⢻⡿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣿⣷
⣿⣿⡇⠀⠀⠀⠀⠀⠀⣴⣀⣄⢀⡆⡄⠈⠙⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠛⠋⠀⡀⢠⠀⠀⢀⡀⠀⠀⠀⠀⠀⠀⣿⣿
⣿⣿⡇⠀⠀⠀⠀⠀⢸⡟⣼⠏⣾⢿⡿⠀⠀⠀⠀⠀⣀⠀⢰⣾⠃⠀⡀⠀⠀⠀⠀⣾⡟⣾⢧⣿⣾⡗⠀⠀⠀⠀⠀⢰⣿⣿
⢹⣻⣧⠀⠀⠀⠀⠀⠈⠀⠉⠀⠁⠈⠁⠀⠀⠀⠀⠀⠙⠳⠞⠛⠷⠞⠋⠀⠀⠀⠀⠉⠀⠛⠘⠁⠛⠁⠀⠀⠀⠀⠀⣼⣿⠏
⠈⢿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⠶⠄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⡟⡟⠀
⠀⠀⠻⡿⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣾⢯⠋⠀⠀
⠀⠀⠀⠘⢪⣿⣶⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⣶⠿⣿⡂⠁⠀⠀⠀
⠀⠀⠀⠀⠀⢸⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⢻⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢘⣿⣗⠀⢿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠀⢸⣿⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⣿⢿⣀⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣄⣾⣿⠁⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠈⠛⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢹⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣽⣿⠇⠸⣿⣶⣶⣤⣤⣤⣤⣀⣀⣀⣀⣀⣀⣀⣀⣠⣤⣤⣤⣴⣶⡦⠌⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻⣿⡇⢸⣿⡗⠛⠃⠙⠃⠘⠛⠟⠿⠭⠽⠿⠿⠛⠟⠃⠓⠚⢻⣿⡇⢀⣿⡿⠃⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠟⡿⣾⠽⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⢿⢷⣾⠿⠁⠀⠀⠀⠀⠀⠀⠀⠀
]]
-- With snack browse or any feature that will open a web page
-- Don't forget to link `wslopen` to `xdg-open` if using wsl
return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      notifier = {
        enabled = true,
        top_down = false, -- place notifications from top to bottom
        sort = { 'added' }, -- sort by level and time
      },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      styles = {
        notification = {
          wo = {
            winblend = 0,
            wrap = true,
          }, -- Wrap notifications
        },
        input = {
          relative = 'cursor',
          title_pos = 'left',
          width = 40,
          row = -3,
          col = 0,
        },
      },
      dashboard = {
        enabled = true,
        preset = {
          header = logo,
          pick = ergou.pick.open,
        },
      },
      dim = {
        animate = {
          enabled = false,
        },
      },
      scroll = {
        enabled = false,
        animate = {
          duration = {
            step = 10,
            total = 100,
          },
        },
      },
      image = {
        doc = {
          inline = false,
        },
        enabled = true,
      },
      indent = {
        enabled = true,
        -- Rainbow indent
        -- indent = {
        --   hl = {
        --     'SnacksIndentRed',
        --     'SnacksIndentYellow',
        --     'SnacksIndentBlue',
        --     'SnacksIndentOrange',
        --     'SnacksIndentGreen',
        --     'SnacksIndentViolet',
        --     'SnacksIndentCyan',
        --   },
        -- },
        animate = {
          enabled = false,
        },
      },
      input = {
        enabled = true,
      },
      picker = {
        previewers = {
          diff = {
            style = 'terminal', ---@type "fancy"|"syntax"|"terminal"
          },
        },
        sources = {
          select = {
            config = function(opts)
              opts.layout.layout.height = ergou.pick.select_height(#opts.items)
            end,
          },
        },
        ui_select = ergou.pick.picker.name == 'snacks',
        layout = {
          layout = {
            width = 0.9,
            height = 0.9,
          },
        },
        win = {
          input = {
            keys = {
              ['<Esc>'] = { 'close', mode = { 'n', 'i' } },
              ['<a-c>'] = {
                'toggle_cwd',
                mode = { 'n', 'i' },
              },
              ['<a-x>'] = { 'flash', mode = { 'i', 'n' } },
              ['<c-t>'] = { 'trouble_open', mode = { 'i', 'n' } },
              ['s'] = { 'flash' },
              ['<c-u>'] = { 'preview_scroll_up', mode = { 'i', 'n' } },
              ['<c-d>'] = { 'preview_scroll_down', mode = { 'i', 'n' } },
              ['<c-f>'] = { 'list_scroll_down', mode = { 'i', 'n' } },
              ['<c-b>'] = { 'list_scroll_up', mode = { 'i', 'n' } },
            },
          },
        },
        actions = {
          toggle_cwd = function(p)
            local root = ergou.root({ buf = p.input.filter.current_buf, normalize = true })
            local cwd = vim.fs.normalize((vim.uv or vim.loop).cwd() or '.')
            local current = p:cwd()
            p:set_cwd(current == root and cwd or root)
            p:find()
          end,
          flash = function(picker)
            require('flash').jump({
              pattern = '^',
              label = { after = { 0, 0 } },
              search = {
                mode = 'search',
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= 'snacks_picker_list'
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
          trouble_open = function(...)
            return require('trouble.sources.snacks').actions.trouble_open.action(...)
          end,
        },
      },
    },
    keys = {
      {
        '<leader>.',
        function()
          Snacks.scratch()
        end,
        desc = 'Toggle Scratch Buffer',
      },
      {
        '<leader>S',
        function()
          Snacks.scratch.select()
        end,
        desc = 'Select Scratch Buffer',
      },
      {
        '<leader>sN',
        function()
          Snacks.notifier.show_history()
        end,
        desc = 'Notification History',
      },
      {
        '<leader>un',
        function()
          Snacks.notifier.hide()
        end,
        desc = 'Dismiss All Notifications',
      },
      {
        '<leader>bd',
        function()
          local filename = vim.api.nvim_buf_get_name(0)
          if filename == 'kulala://ui' then
            pcall(vim.cmd, 'bdelete!')
            return
          end

          Snacks.bufdelete()
        end,
        desc = 'Delete Buffer',
      },
      {
        '<leader>bo',
        function()
          local tab_buflist = vim.fn.tabpagebuflist()
          Snacks.bufdelete(function(buf)
            return not vim.list_contains(tab_buflist, buf)
          end)
        end,
        desc = 'Delete Buffers other than the current layout',
      },
      {
        '<leader>bO',
        function()
          Snacks.bufdelete.other()
        end,
        desc = 'Delete Other Buffers',
      },
      {
        '<leader>ba',
        function()
          Snacks.bufdelete.all()
        end,
        desc = 'Delete All Buffers',
      },
      {
        '<leader>gb',
        function()
          Snacks.git.blame_line()
        end,
        desc = 'Git Blame Line',
      },
      {
        '<leader>grv',
        function()
          Snacks.gitbrowse({ what = 'branch', notify = false })
        end,
        desc = 'Git Browse Branch',
        mode = { 'n', 'v' },
      },
      {
        '<leader>grV',
        function()
          Snacks.gitbrowse({ what = 'file', notify = false })
        end,
        desc = 'Git Browse',
        mode = { 'n', 'v' },
      },
      {
        '<leader>lg',
        function()
          Snacks.lazygit()
        end,
        desc = 'Lazygit',
      },
      {
        '<leader>gl',
        function()
          Snacks.lazygit.log_file()
        end,
        desc = 'Lazygit Current File History',
      },
      {
        '<leader>gL',
        function()
          Snacks.lazygit.log()
        end,
        desc = 'Lazygit Log (cwd)',
      },
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
      },
      {
        ']]',
        function()
          Snacks.words.jump(vim.v.count1)
        end,
        desc = 'Next Reference',
        mode = { 'n', 't' },
      },
      {
        '[[',
        function()
          Snacks.words.jump(-vim.v.count1)
        end,
        desc = 'Prev Reference',
        mode = { 'n', 't' },
      },
      {
        '<leader>N',
        desc = 'Neovim News',
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file('doc/news.txt', false)[1],
            width = 0.8,
            height = 0.8,
            border = 'rounded',
            wo = {
              spell = false,
              wrap = false,
              signcolumn = 'yes',
              statuscolumn = ' ',
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command
        end,
      })
    end,
  },
  {
    'folke/snacks.nvim',
    keys = function(_, k)
      return ergou.pick.set_keymaps(k, 'snacks')
    end,
  },
  {
    'folke/todo-comments.nvim',
    keys = function(_, ks)
      local _keys = ks or {}
      if ergou.pick.picker.name == 'snacks' then
        vim.list_extend(_keys, {
          {
            '<leader>st',
            function()
              require('todo-comments.snacks').pick({ keywords = { 'TODO', 'FIX', 'FIXME' } })
            end,
            desc = 'Todo/Fix/Fixme',
          },
          {
            '<leader>sT',
            function()
              require('todo-comments.snacks').pick({})
            end,
            desc = 'Todo',
          },
        })
      end
      return _keys
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function()
      local Keys = ergou.lsp.keymap.get()

      if ergou.pick.picker.name == 'snacks' then
        vim.list_extend(Keys, {
          {
            'gd',
            function()
              Snacks.picker.lsp_definitions()
            end,
            desc = 'Goto Definition',
          },
          {
            'grr',
            function()
              Snacks.picker.lsp_references()
            end,
            desc = 'References',
          },
          {
            'gI',
            function()
              Snacks.picker.lsp_implementations()
            end,
            desc = 'Goto Implementation',
          },
          {
            'gy',
            function()
              Snacks.picker.lsp_type_definitions()
            end,
            desc = 'Goto T[y]pe Definition',
          },
        })
      end
    end,
  },
}
