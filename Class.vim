
"-------------------------------------------------------------------------------

let g:Object = {'_methods' : {}, '_fields': [], '_name' : 'Object', 'Create': funcref('Create'), 'Init': funcref('Init')}
let g:Object._parents = [ g:Object ]

let g:vimClass = {}

let g:vimClass.context = []
let g:vimClass.classes = []

call add(g:vimClass.classes, 'Object')

let g:vimClass.err = {}
let g:vimClass.err.abstractMethodNotImplemented = 'Er001 - Abstract Method not implemented'
let g:vimClass.err.underFlow = 'Er002 - Under Flow Error'
let g:vimClass.err.overFlow = 'Er003 - Over Flow Error'
let g:vimClass.err.incompatibleMethod = 'Er004 - Incompatible method declaration'
let g:vimClass.err.invalidClassName = 'Er005 - Invalid Class name'
let g:vimClass.err.invalidMethodName = 'Er006 - Invalid Method name'
let g:vimClass.err.SpyError = 'Er007 - Spy Error'
let g:vimClass.err.invalidParent = 'Er008 - Invalid Parent'
let g:vimClass.err.invalidFieldName = 'Er006 - Invalid field name'

let g:vimClass.flgs = {}
let g:vimClass.flgs.abstractMethod = 'abstract'

"-------------------------------------------------------------------------------

function! ValidateClassName(name)
    if a:name !~# '\v^[A-Z]\w*$'
        throw g:vimClass.err.invalidClassName.': '.a:name
    endif
endfunction

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

    call ValidateClassName(a:name)

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

    let parent = ''
    if (type(a:parent) == 1)
        execute 'let parent = g:'.a:parent
    elseif (type(a:parent) == 4)
        let parent = a:parent
    else
        throw g:vimClass.err.invalidParent.' on class '.g:vimClass.context[-1]._name
    endif

    call add(g:vimClass.context[-1]._parents, parent)

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

function! ValidateMethodName(name)
    if a:name !~# '\v^_?_?[A-Z]\w*$'
        throw g:vimClass.err.invalidMethodName.' on class '.g:vimClass.context[-1]._name
    endif
endfunction

function! VMethod(name, ...)

    call ValidateMethodName(a:name)

    let FuncReference = 0
    if type(a:1) == 2
        let FuncReference = a:1
    elseif type(a:1) == 1
        try
            let FuncReference = funcref(a:1)
        catch /E700.*/
            let FuncReference = function(a:1)
        endtry
    endif
    if len(a:000) == 1  && type(FuncReference) == 2 && type(a:name) == 1
        let g:vimClass.context[-1]._methods[a:name] = a:1
    else
        throw g:vimClass.err.incompatibleMethod.' on class '.g:vimClass.context[-1]._name
    endif
endfunction

command! -nargs=* Method call VMethod(<args>)


"-------------------------------------------------------------------------------

function! VAbstractMethod(name)

    call ValidateMethodName(a:name)

    let g:vimClass.context[-1]._methods[a:name] = g:vimClass.flgs.abstractMethod
endfunction

command! -nargs=1 AbstractMethod call VAbstractMethod(<args>)

"-------------------------------------------------------------------------------

function! ValidateFieldName(name)
    if a:name !~# '\v^_?_?[a-z]\w*$'
        throw g:vimClass.err.invalidFieldName.': '.a:name
    endif
endfunction

function! VField(name)

    call ValidateFieldName(a:name)

    call add(g:vimClass.context[-1]._fields, a:name)
endfunction

command! -nargs=1 Field call VField(<args>)

"-------------------------------------------------------------------------------

