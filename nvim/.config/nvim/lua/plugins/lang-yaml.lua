-- SchemaStore only maps the GitLab CI schema onto `.gitlab-ci.yml` itself; job
-- files `include:`d from `.gitlab/ci/` get no completion or validation without
-- this.
local GITLAB_CI_SCHEMA =
  "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"

return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      yamlls = {
        settings = {
          yaml = {
            schemas = {
              [GITLAB_CI_SCHEMA] = { ".gitlab/ci/**/*.yml", ".gitlab/ci/**/*.yaml" },
            },
            -- Python tags mkdocs.yml (Material, pymdownx) uses; otherwise
            -- "Unresolved tag" errors on valid config. `!!x` must be spelled
            -- `tag:yaml.org,2002:x`: yamlls matches the expanded tag, so the
            -- shorthand never matches.
            customTags = {
              "!ENV scalar",
              "!ENV sequence",
              "tag:yaml.org,2002:python/name:material.extensions.emoji.twemoji scalar",
              "tag:yaml.org,2002:python/name:material.extensions.emoji.to_svg scalar",
              "tag:yaml.org,2002:python/name:pymdownx.superfences.fence_code_format scalar",
              "tag:yaml.org,2002:python/object/apply:pymdownx.slugs.slugify mapping",
            },
          },
        },
      },
    },
  },
}
