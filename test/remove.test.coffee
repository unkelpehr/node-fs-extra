crypto = require('crypto')
fs = require('../lib')
path = require('path-extra')
testutil = require('testutil')
mkdir = require('mkdirp')

DIR = ''

buildDir = ->
  buf = new Buffer(5) #small buffer for data
  bytesWritten = 0
  while bytesWritten < buf.length
    buf[bytesWritten] = Math.floor((Math.random()*256))
    bytesWritten += 1
  
  ex = Date.now()
  baseDir = path.join(path.tempdir(), "TEST_fs-extra_rmrf-#{ex}")
  fs.mkdirSync(baseDir)

  fs.writeFileSync(path.join(baseDir, Math.random() + ''), buf)
  fs.writeFileSync(path.join(baseDir, Math.random() + ''), buf)

  subDir = path.join(path.tempdir(), Math.random() + '')
  fs.mkdirSync(subDir)

  fs.writeFileSync(path.join(subDir, Math.random() + ''))
  baseDir

describe 'fs-extra', ->
  beforeEach (done) ->
    DIR = testutil.createTempDir()
    done()

  afterEach (done) ->
    if fs.existsSync(DIR)
      fs.remove DIR, done
    else
      done()
  
  describe '+ removeSync()', ->
    it 'should delete directories and files synchronously', ->
      T path.existsSync(DIR)
      fs.removeSync(DIR)
      F path.existsSync(DIR) 

    it 'should delete an empty directory synchronously', ->
      T fs.existsSync DIR
      fs.removeSync DIR
      F fs.existsSync DIR

    it 'should delete a file synchronously', ->
      file = testutil.createFileWithData(path.join(DIR, 'file'), 4)
      T fs.existsSync file
      fs.removeSync file


  describe '+ remove()', ->
    it 'should delete an empty directory', (done) ->
      T fs.existsSync DIR
      fs.remove DIR, (err) ->
        T err is null
        F fs.existsSync DIR
        done()

    it 'should delete a directory full of directories and files', (done) ->
      dir = buildDir()
      T fs.existsSync(DIR)
      fs.remove DIR, (err) ->
        T err is null
        F fs.existsSync(DIR)
        done()

    it 'should delete a file', (done) ->
      file = testutil.createFileWithData(path.join(DIR, 'file'), 4)
      T fs.existsSync file
      fs.remove file, (err) ->
        T err is null
        F fs.existsSync file
        done()
      


