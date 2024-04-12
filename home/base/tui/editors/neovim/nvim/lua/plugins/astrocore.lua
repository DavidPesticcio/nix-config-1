if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

require("telescope").load_extension "refactoring"
require("telescope").load_extension "yank_history"
require("telescope").load_extension "undo"

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 500, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- Show relative numberline
        signcolumn = "auto", -- Show sign column when used only
        spell = false, -- Spell checking
        swapfile = false, -- Swapfile
        smartindent = false, -- fix https://github.com/ryan4yin/nix-config/issues/4
        title = true, -- Set the title of window to `filename [+=-] (path) - NVIM`
        -- The percentage of 'columns' to use for the title
        -- When the title is longer, only the end of the path name is shown.
        titlelen = 20,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs with `H` and `L`
        L = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        H = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bD"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Pick to close",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        ["<Leader>b"] = { desc = "Buffers" },

        -- second key is the lefthand side of the map
        -- mappings seen under group name "Buffer"
        ["<leader>bn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
        -- quick save
        ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command

        -- Terminal
        -- NOTE: https://neovim.io/doc/user/builtin.html#jobstart()
        --   1. If {cmd} is a List it runs directly (no 'shell')
        --   2. If {cmd} is a String it runs in the 'shell'
        -- search and replace globally
        ["<leader>ss"] = { '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
        ["<leader>sw"] = {
          '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
          desc = "Search current word",
        },
        ["<leader>sp"] = {
          '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
          desc = "Search on current file",
        },

        -- refactoring
        ["<leader>ri"] = {
          function() require("refactoring").refactor "Inline Variable" end,
          desc = "Inverse of extract variable",
        },
        ["<leader>rb"] = { function() require("refactoring").refactor "Extract Block" end, desc = "Extract Block" },
        ["<leader>rbf"] = {
          function() require("refactoring").refactor "Extract Block To File" end,
          desc = "Extract Block To File",
        },
        ["<leader>rr"] = {
          function() require("telescope").extensions.refactoring.refactors() end,
          desc = "Prompt for a refactor to apply",
        },
        ["<leader>rp"] = {
          function() require("refactoring").debug.printf { below = false } end,
          desc = "Insert print statement to mark the calling of a function",
        },
        ["<leader>rv"] = {
          function() require("refactoring").debug.print_var() end,
          desc = "Insert print statement to print a variable",
        },
        ["<leader>rc"] = {
          function() require("refactoring").debug.cleanup {} end,
          desc = "Cleanup of all generated print statements",
        },

        -- yank_history
        ["<leader>yh"] = {
          function() require("telescope").extensions.yank_history.yank_history() end,
          desc = "Preview Yank History",
        },

        -- undo history
        ["<leader>uh"] = { "<cmd>Telescope undo<cr>", desc = "Telescope undo" },

        -- implementation/definition preview
        ["gpd"] = { "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "goto_preview_definition" },
        ["gpt"] = {
          "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
          desc = "goto_preview_type_definition",
        },
        ["gpi"] = {
          "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
          desc = "goto_preview_implementation",
        },
        ["gP"] = { "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "close_all_win" },
        ["gpr"] = { "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "goto_preview_references" },
      },
      t = {
        -- setting a mapping to false will disable it
        -- ["<esc>"] = false,
      },
      -- Visual mode
      v = {
        -- search and replace globally
        ["<leader>sw"] = { '<esc><cmd>lua require("spectre").open_visual()<CR>', desc = "Search current word" },
      },
      -- visual mode(what's the difference between v and x???)
      x = {
        -- refactoring
        ["<leader>ri"] = {
          function() require("refactoring").refactor "Inline Variable" end,
          desc = "Inverse of extract variable",
        },
        ["<leader>re"] = {
          function() require("refactoring").refactor "Extract Function" end,
          desc = "Extracts the selected code to a separate function",
        },
        ["<leader>rf"] = {
          function() require("refactoring").refactor "Extract Function To File" end,
          desc = "Extract Function To File",
        },
        ["<leader>rv"] = {
          function() require("refactoring").refactor "Extract Variable" end,
          desc = "Extracts occurrences of a selected expression to its own variable",
        },
        ["<leader>rr"] = {
          function() require("telescope").extensions.refactoring.refactors() end,
          desc = "Prompt for a refactor to apply",
        },
      },
    },
  },
}
