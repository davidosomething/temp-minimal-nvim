local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    lazyrepo,
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "creativenull/efmls-configs-nvim",
      dependencies = {
        {
          "mason-org/mason-lspconfig.nvim",
          opts = {},
          dependencies = {
            {
              "mason-org/mason.nvim",
              opts = {},
              config = function()
                require("mason").setup()
                vim.cmd.MasonInstall("efm")
                vim.cmd.MasonInstall("prettier")
              end,
            },
            "neovim/nvim-lspconfig",
          },
        },
      },
      config = function()
        local prettier = require("efmls-configs.formatters.prettier")

        local languages = { json = { prettier } }

        local efmls_config = {
          filetypes = vim.tbl_keys(languages),
          settings = {
            rootMarkers = { ".git/" },
            languages = languages,
          },
          init_options = {
            documentFormatting = true,
            documentRangeFormatting = true,
          },
        }

        -- If using nvim >= 0.11 then use the following
        vim.lsp.config(
          "efm",
          vim.tbl_extend("force", efmls_config, {
            cmd = { "efm-langserver" },

            -- Pass your custom lsp config below like on_attach and capabilities
            --
            -- on_attach = on_attach,
            -- capabilities = capabilities,
          })
        )

        vim.print("efm running, prettier should format on vim.lsp.buf.format()")
      end,
    },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "habamax" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
