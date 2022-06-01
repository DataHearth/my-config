local installer = require("nvim-lsp-installer")

installer.setup({
    ensure_installed = { "rust_analyzer", "sumneko_lua", "pyright", "tsserver", "gopls" },
})
