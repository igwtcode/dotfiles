return {
  "mfussenegger/nvim-lint",
  event = "BufReadPre",
  config = function()
    local lnt = require("lint")

    local cfnln = lnt.linters.cfn_lint
    -- cfnln.cmd = "cfn-lint"
    cfnln.stdin = false
    cfnln.append_fname = true
    cfnln.ignore_exitcode = true
    cfnln.args = {
      "--ignore-checks=E2531",
      "--ignore-checks=W2531",
      -- "--append-rules=cfn_lint_serverless.rules",
      "--format=parseable",
      "-",
    }

    lnt.default_severity = {
      ["error"] = vim.diagnostic.severity.ERROR,
      ["warning"] = vim.diagnostic.severity.WARN,
      ["information"] = vim.diagnostic.severity.INFO,
      ["hint"] = vim.diagnostic.severity.HINT,
    }

    lnt.linters_by_ft = {
      dockerfile = { "hadolint" },
      terraform = { "terraform_validate" },
      python = { "flake8" },
      tf = { "terraform_validate" },
      ["yaml.github"] = { "actionlint" },
      ["yaml.cfn"] = { "cfn_lint" },
      ["yaml.sam"] = { "cfn_lint" },
    }
  end,
}
