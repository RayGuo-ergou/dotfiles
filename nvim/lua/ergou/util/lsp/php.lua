---@class ergou.util.lsp.php
local M = {}
M.servers = { 'intelephense', 'phpactor' }
---@type 'intelephense' | 'phpactor'
M.server_to_use = 'intelephense'

return M
