-- Catppuccin Config

require("catppuccin").setup {
    flavour = "mocha",
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false,
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = {},
        loops = {},
        functions = {"italic"},
        keywords = {"bold"},
        strings = {},
        variables = {},
        numbers = {},
        booleans = {"italic"},
        properties = {},
        types = {},
        operators = {},
    },
    style = {
        comments = {"italic"}
    },

    color_overrides = {
        all = {
            text = "#ffffff",
        },
        latte = {
            base = "#ff0000",
            mantle = "#242424",
            crust = "#474747",
        },
        frappe = {},
        macchiato = {},
        mocha = {
            text = "#d8dee9",
        },
    },
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = false,
    },
    highlight_overrides = {
        mocha = function(mocha)
            return {
                Keyword = {fg = mocha.sapphire},
                Macro = {fg = mocha.blue},
                Include = {fg = mocha.blue},

                ["@keyword.function"] = {fg = mocha.green},
                ["@keyword.return"] = {fg = mocha.teal}
            }
        end,
    },
}

