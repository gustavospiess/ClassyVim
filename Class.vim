
"-------------------------------------------------------------------------------

let g:Object = {'_methods' : {}, '_fields': [], '_name' : 'Object', 'Create': function('Create'), 'Init': function('Init')}
let g:Object._parents = [ g:Object ]

let g:vimClass = {}

let g:vimClass.context = []
let g:vimClass.classes = []

call add(g:vimClass.classes, 'Object')

let g:vimClass.err = {}
let g:vimClass.err.abstractMethodNotImplemented = 'Er001 - Abstract Method not implemented'
let g:vimClass.err.underFlow = 'Er002 - Under Flow Error'
let g:vimClass.err.overFlow = 'Er003 - Over Flow Error'
let g:vimClass.err.incompatibleMethod = 'Er004 - incompatible method declaration'

let g:vimClass.flgs = {}
let g:vimClass.flgs.abstractMethod = 'abstract'

"-------------------------------------------------------------------------------

function! Create(...) dict
    let obj = {}
    for meth in keys(self._methods)
        if self._methods[meth] == g:vimClass.flgs.abstractMethod
            throw g:vimClass.err.abstractMethodNotImplemented.' on class '.self._name
        endif
        let obj[meth] = self._methods[meth]
    endfor
    for fie in self._fields
        let obj[fie] = 0
    endfor
    let obj.class = self
    execute 'call obj.Init('.substitute(string(a:000), '\[\|\]', '', 'g').')'
    return obj
endfunction

function! Init(...) dict
    for i in range(len(a:000))
        let self[self.class._fields[i]] = a:000[i]
    endfor
endfunction

function! Super(method, superClass) dict
    let self._ = a:superClass._methods[a:method]
    return self._
endfunction

function! VGenerateClass(name)
    let clazz = {}
    let clazz._methods = {}
    let clazz._methods.Init = function('Init')
    let clazz._methods.Super = function('Super')
    let clazz._fields = []
    let clazz._parents = []
    let clazz._name = a:name
    let clazz.Create = function('Create')
    return clazz
endfunction

function! VClass(name)
    execute 'let g:'.a:name.' = VGenerateClass('''.a:name.''')'
    call add(g:vimClass.classes, a:name)
    execute 'call add(g:vimClass.context, g:'.a:name.')'
endfunction

command! -nargs=1 Class call VClass(<args>)

"-------------------------------------------------------------------------------

function! VEndClass()
    if len(g:vimClass.context[-1]._parents) == 0
        let g:vimClass.context[-1]._parents = [g:Object]
    endif
    unlet g:vimClass.context[-1]
endfunction

command! EndClass call VEndClass()

"-------------------------------------------------------------------------------

function! VExtends(parent)
    call add(g:vimClass.context[-1]._parents, a:parent)

    let clazz = g:vimClass.context[-1]

    for key in keys(a:parent._methods)
        let clazz._methods[key] = a:parent._methods[key]
    endfor

    for field in a:parent._fields
        if index(clazz._fields, field) == -1
            call add(clazz._fields, field)
        endif
    endfor
endfunction

comman! -nargs=1 Extends call VExtends(<args>)

"-------------------------------------------------------------------------------

function! VMethod(name, ...)
    if len(a:000) == 1  && type(a:1) == 2 && type(a:name) == 1
        let g:vimClass.context[-1]._methods[a:name] = a:1
    else
        throw g:vimClass.err.incompatibleMethod.' on class '.g:vimClass.context[-1]._name
    endif
endfunction

command! -nargs=* Method call VMethod(<args>)


"-------------------------------------------------------------------------------

function! VAbstractMethod(name)
    let g:vimClass.context[-1]._methods[a:name] = g:vimClass.flgs.abstractMethod
endfunction

command! -nargs=1 AbstractMethod call VAbstractMethod(<args>)

"-------------------------------------------------------------------------------

function! VField(name)
    call add(g:vimClass.context[-1]._fields, a:name)
endfunction

command! -nargs=1 Field call VField(<args>)

"-------------------------------------------------------------------------------

