require("leaf").setup({
    underlineStyle = "undercurl",
    commentStyle = "italic",
    functionStyle = "NONE",
    keywordStyle = "italic",
    statementStyle = "bold",
    typeStyle = "NONE",
    variablebuiltinStyle = "italic",
    transparent = false,
    colors = {},
    overrides = {
	MatchParen = {bg="#2e2c2fff", fg="#76d0ff"}, --a4dfad
	Boolean =  {bg="#2e2c2fff", fg="#ccaa6c"},
	Keyword =  {bg="#2e2c2fff", fg="#62d2e1"}
    },
    theme = "dark", -- default, based on vim.o.background, alternatives: "light", "dark"
    contrast = "medium", -- default, alternatives: "medium", "high"
})


function ColorMyPencils(color)
	color = color or "leaf"
	vim.cmd.colorscheme(color)

	--vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
	--vim.api.nvim_set_hl(0, "NormalFloat", {bg = "none"})
end

ColorMyPencils()
