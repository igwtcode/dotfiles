-- helpers.lua
local M = {}

-- Bind a keymap to a specific mode
local function bind_key(op, outer_opts)
  outer_opts = vim.tbl_extend("force", { noremap = true, silent = true }, outer_opts or {})

  return function(lhs, rhs, opts)
    opts = vim.tbl_extend("force", outer_opts, opts or {})
    vim.keymap.set(op, lhs, rhs, opts)
  end
end

M.map = bind_key("")
M.nmap = bind_key("n", { noremap = false })
M.nnoremap = bind_key("n")
M.vnoremap = bind_key("v")
M.xnoremap = bind_key("x")
M.inoremap = bind_key("i")
M.tnoremap = bind_key("t")

-- Check if the file is an aws CloudFormation template
function M.is_cloudformation_template(filepath)
  local lines = {}
  local file = io.open(filepath, "r")
  if file then
    for i = 1, 20 do
      local line = file:read("*line")
      if not line then
        break
      end
      table.insert(lines, line)
    end
    file:close()
  end

  for _, line in ipairs(lines) do
    if line:match("^AWSTemplateFormatVersion") or line:match("^ *Resources:") then
      return true
    end
  end
  return false
end

-- Check if the file is an aws Serverless Framework template
function M.is_serverless_template(filepath)
  local lines = {}
  local file = io.open(filepath, "r")
  if file then
    for i = 1, 20 do
      local line = file:read("*line")
      if not line then
        break
      end
      table.insert(lines, line)
    end
    file:close()
  end

  for _, line in ipairs(lines) do
    if line:match("^Transform: .*::Serverless.*") then
      return true
    end
  end
  return false
end

-- Set the filetype based on the detected template
-- Detects Serverless Framework and CloudFormation templates (yaml)
function M.set_aws_cloudformation_fileTypes(event)
  local filepath = vim.api.nvim_buf_get_name(event.buf)
  if M.is_serverless_template(filepath) then
    vim.bo[event.buf].filetype = "yaml.sam"
  elseif M.is_cloudformation_template(filepath) then
    vim.bo[event.buf].filetype = "yaml.cfn"
  end
end

-- Set the yamlls config based on the detected template
function M.set_aws_cloudformation_schemas(event)
  local client = vim.lsp.get_client_by_id(event.data.client_id)

  if not client or client.name ~= "yamlls" then
    return
  end

  local yamlls_config = client.config.settings.yaml
  local filepath = vim.api.nvim_buf_get_name(event.buf)
  local filetype = vim.bo[event.buf].filetype
  local is_cfn = filetype == "yaml.cfn"
  local is_sam = filetype == "yaml.sam"

  if is_sam then
    yamlls_config.schemas = {
      ["https://raw.githubusercontent.com/aws/serverless-application-model/main/samtranslator/schema/schema.json"] = {
        filepath,
      },
    }
  elseif is_cfn then
    yamlls_config.schemas = {
      ["https://raw.githubusercontent.com/awslabs/goformation/master/schema/cloudformation.schema.json"] = {
        filepath,
      },
    }
  end

  if is_cfn or is_sam then
    yamlls_config.customTags = {
      "!And scalar",
      "!And mapping",
      "!And sequence",
      "!If scalar",
      "!If mapping",
      "!If sequence",
      "!Not scalar",
      "!Not mapping",
      "!Not sequence",
      "!Equals scalar",
      "!Equals mapping",
      "!Equals sequence",
      "!Or scalar",
      "!Or mapping",
      "!Or sequence",
      "!FindInMap scalar",
      "!FindInMap mappping",
      "!FindInMap sequence",
      "!Base64 scalar",
      "!Base64 mapping",
      "!Base64 sequence",
      "!Cidr scalar",
      "!Cidr mapping",
      "!Cidr sequence",
      "!Ref scalar",
      "!Ref mapping",
      "!Ref sequence",
      "!Sub scalar",
      "!Sub mapping",
      "!Sub sequence",
      "!GetAtt scalar",
      "!GetAtt mapping",
      "!GetAtt sequence",
      "!GetAZs scalar",
      "!GetAZs mapping",
      "!GetAZs sequence",
      "!ImportValue scalar",
      "!ImportValue mapping",
      "!ImportValue sequence",
      "!Select scalar",
      "!Select mapping",
      "!Select sequence",
      "!Split scalar",
      "!Split mapping",
      "!Split sequence",
      "!Join scalar",
      "!Join mapping",
      "!Join sequence",
      "!Condition scalar",
      "!Condition mapping",
      "!Condition sequence",
    }
    client.notify("workspace/didChangeConfiguration", { settings = yamlls_config })
  end
end

function M.toLowerKebabCase(str)
  local result = str:gsub("%s+", "-"):gsub("%u", function(c)
    return "-" .. c:lower()
  end)
  return result:gsub("^-+", ""):gsub("%-+", "-"):lower()
end

function M.toTitleCase(str)
  return str:gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

return M
