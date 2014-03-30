module.exports =
  activate: ->
    atom.workspaceView.command "language-lasso:check_syntax", => @check_syntax()

  check_syntax: ->
    editor = atom.workspace.getActiveEditor()
    editor.buffer.save()
    require("child_process").execFile('/usr/bin/lassoc', [editor.buffer.file.path, '-n', '-o', '/dev/null'],
      (error, stdout, stderr) ->
        if(stderr and stderr.length > 0)
          parsed = stderr.match(/line: (\d+), col: (\d+)\s*$/)
          if(parsed)
            row    = parseInt(parsed[1]) - 1
            col    = parseInt(parsed[2]) - 1
            editor.setCursorBufferPosition([row, col])

          alert(stderr)
        else
          alert('No problems found')
    )
