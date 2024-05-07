local phpactor = function()
  vim.ui.select({
    'class_inflect',
    'context_menu',
    'expand_class',
    'generate_accessor',
    'change_visibility',
    'copy_class',
    'import_class',
    'import_missing_classes',
    'move_class',
    'navigate',
    'new_class',
    'transform',
    'update',
    'config',
    'status',
    'cache_clear',
  }, {
    prompt = 'Phpactor Action',
  }, function(choice)
    if choice == nil or choice == '' then
      return
    end

    -- TODO: add option for new class in same directory
    if choice == 'new_class' then
      return vim.ui.input({
        prompt = 'New Class',
      }, function(value)
        if value == nil then
          return
        end
        -- TODO: check filename generation to validate the path
        require('phpactor').rpc('new_class', { text_value = vim.fn.getcwd() .. '/' .. value .. '.php' })
      end)
    end

    require('phpactor').rpc(choice, {})
  end)
end

return {
  'adalessa/phpactor.nvim',
  enabled = false,
  cmd = { 'PhpActor' },
  keys = {
    { '<leader>pa', phpactor, desc = 'PhpActor options' },
    { '<leader>pc', ':PhpActor context_menu<cr>', desc = 'PhpActor context menu' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    install = {
      -- bin = '~/.local/bin/phpactor',
      -- bin = 'phpactor',
      bin = '/nix/store/86ypxhfya7k0pkfnw1rmzdf1s57ydnqs-user-environment/bin/phpactor',
    },
    lspconfig = {
      enabled = false,
    },
  },
  {
    'adalessa/laravel.nvim',
    enabled = false,
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'tpope/vim-dotenv',
      'MunifTanjim/nui.nvim',
      'nvimtools/none-ls.nvim',
    },
    cmd = { 'Sail', 'Artisan', 'Composer', 'Npm', 'Yarn', 'Laravel' },
    keys = {
      { '<leader>la', ':Laravel artisan<cr>' },
      { '<leader>lr', ':Laravel routes<cr>' },
      { '<leader>lm', ':Laravel related<cr>' },
    },
    event = { 'VeryLazy' },
    config = true,
  },
  {
    'praem90/nvim-phpcsf',
    -- aplicar el plugin cada que se guarda el buffer
    config = function()
      vim.cmd [[
      augroup PHBSCF
      autocmd!
      autocmd BufWritePost,BufReadPost,InsertLeave *.php :lua require'phpcs'.cs()
      autocmd BufWritePost *.php :lua require'phpcs'.cbf()
      augroup END
      let g:nvim_phpcs_config_phpcs_path = 'phpcs'
      let g:nvim_phpcs_config_phpcbf_path = 'phpcbf'
      let g:nvim_phpcs_config_phpcs_standard = 'PSR2' " or path to your ruleset phpcs.xml
      ]]
    end,
  },
}
