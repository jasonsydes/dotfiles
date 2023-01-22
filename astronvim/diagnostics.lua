-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
return {
  -- "virtual_text" is the often red or yellow text that shows up to the right side of the an error.
  --    You cannot copy virtual_text.
  --    Useful to be able to disable this.
  --    Alternative: Put cursor over line with error, then type "gl" (Hover diagnostics); that text *is* copyable.
  virtual_text = true,
  update_in_insert = true,    -- When false, will not update virtual_text / diagnostics in Insert mode (waits until returning to Normal mode).
  underline = true,
}
