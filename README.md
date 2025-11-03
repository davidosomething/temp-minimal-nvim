1. Clone this repo to `~/.config/minimal-nvim`
2. Start nvim with `NVIM_APPNAME=minimal-nvim nvim ~/.config/minimal-nvim/sample.json`
3. Let mason finish installing, then close its popup.
4. Delete the inner object from the json doc
5. Run `:=vim.lsp.buf.format()` to trigger efm -> prettier -> format.
6. Observe -- the deleted inner object comes back because prettier ran against
   the file on disk instead of the current buffer contents.
