# Your init script
#
# Atom will evaluate this file each time a new window is opened. It is run
# after packages are loaded/activated and after the previous editor state
# has been restored.
#
# An example hack to log to the console when each text editor is saved.
#
# atom.workspace.observeTextEditors (editor) ->
#   editor.onDidSave ->
#     console.log "Saved! #{editor.getPath()}"

atom.commands.add 'atom-text-editor', 'custom:line-comment-toggle', ->
    editor = atom.workspace.getActiveTextEditor()
    editor.toggleLineCommentsInSelection()
    editor.moveDown()


atom.commands.add 'atom-text-editor', 'custom:selection-comment-toggle', ->
    editor = atom.workspace.getActiveTextEditor()
    text = editor.getSelectedText()
    if text.length == 0
        return
    else editor.insertText("/*#{text}*/")