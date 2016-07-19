module.exports =
  activate: ->
    atom.commands.add 'atom-workspace', "language-lasso:check_syntax": => @check_syntax()

  check_syntax: ->
    editor = atom.workspace.getActiveTextEditor()
    editor.buffer.save()
    fs = require 'fs'
    path = require 'path'
    lassocPath = '/usr/bin/lassoc'
    compilerOutput = '/dev/null'
    if (process.platform == 'win32')
        lassocPath = path.join(process.env.LASSO9_HOME, 'LassoExecutables', 'lassoc.exe')
        compilerOutput = path.join(process.env.TMP, 'atom-language-lasso-compiler-output')
    if !(fs.existsSync(lassocPath))
        alert('Lasso does not appear to be installed on this system; cannot validate syntax')
    else
        require("child_process").execFile(lassocPath, [editor.buffer.file.path, '-n', '-o', compilerOutput],
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
