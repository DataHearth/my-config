local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup {
  ensure_installed = { "go", "rust", "javascript" },
  sync_install = false,
  ignore_install = { "" },
  autopairs = {
    enable = true,
  },
  highlight = {
    enable = true,
    disable = { "" },
    additional_vim_regex_highlighting = true,
  },
   context_commentstring = {
    enable = true,
    enable_autocmd = false,
  }, 
  indent = true,
}

