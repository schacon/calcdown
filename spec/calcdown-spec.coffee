{WorkspaceView} = require 'atom'
Calcdown = require '../lib/calcdown'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Calcdown", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('calcdown')

  describe "when the calcdown:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.calcdown')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'calcdown:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.calcdown')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'calcdown:toggle'
        expect(atom.workspaceView.find('.calcdown')).not.toExist()
