; extends

; Highlight the text around the template tags as the language the file renders
; to: `mount_share.sql.j2` -> sql, `service_spec.yaml.j2` -> yaml. The
; `set-j2-host!` directive (lua/config/project.lua) reads it from the filename.
; Combined, so the host parser sees one document rather than one per fragment.
((content) @injection.content
  (#set-j2-host! @injection.content)
  (#set! injection.combined))
