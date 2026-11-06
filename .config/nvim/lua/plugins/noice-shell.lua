-- Show output of :!cmd as a popup.
-- Neovim 0.11+ tags shell output with the kinds below, and noice drops any
-- message that matches none of its routes, so :!ls showed nothing.
return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    table.insert(opts.routes, {
      filter = { event = "msg_show", kind = { "shell_out", "shell_err", "shell_ret" } },
      view = "popup",
    })
  end,
}
