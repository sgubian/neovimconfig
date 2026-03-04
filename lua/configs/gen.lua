local options = {
  model = "qwen3-coder:30b", -- or whatever model you're using with Ollama
  host = "localhost",
  port = "11434",
  display_mode = "horizontal-split",
  show_prompt = true,
  show_model = true,
  no_auto_close = true,
}

require("gen").setup(options)
