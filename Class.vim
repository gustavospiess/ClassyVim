
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

let g:vimClass.flgs = {}
let g:vimClass.flgs.abstractMethod = 'abstract'

"-------------------------------------------------------------------------------

function! Create(...) dict
    let obj = {}
    for meth in keys(self._methods)
        if self._methods[meth] == g:vimClass.flgs.abstractMethod
            throw g:vimClass.err.abstractMethodNotImplemented
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

function! VGenerateClass(name)
    let clazz = {}
    let clazz._methods = {}
    let clazz._methods.Init = function('Init')
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

command! -nargs=1 Class call VClass('<args>')

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
    execute 'call add(g:vimClass.context[-1]._parents, g:'.a:parent.')'

    execute 'let super = g:'.a:parent
    let clazz = g:vimClass.context[-1]

    for key in keys(super._methods)
        let clazz._methods[key] = super._methods[key]
    endfor

    for field in super._fields
        if index(clazz._fields, field) == -1
            call add(clazz._fields, field)
        endif
    endfor
endfunction

comman! -nargs=1 Extends call VExtends('<args>')

"-------------------------------------------------------------------------------

function! VMethod(name)
    let g:vimClass.context[-1]._methods[a:name] = function(a:name)
endfunction

command! -nargs=1 Method call VMethod('<args>')


"-------------------------------------------------------------------------------

function! VAbstractMethod(name)
    let g:vimClass.context[-1]._methods[a:name] = g:vimClass.flgs.abstractMethod
endfunction

command! -nargs=1 AbstractMethod call VAbstractMethod('<args>')

"-------------------------------------------------------------------------------

function! VField(name)
    call add(g:vimClass.context[-1]._fields, a:name)
endfunction

command! -nargs=1 Field call VField('<args>')

"-------------------------------------------------------------------------------

function! MultiClass(parents, methods, fields)
    let clazz = {'_methods' : {}, '_fields': [], '_parents': a:parents}

    for super in a:parents
        for key in keys(super._methods)
            let clazz._methods[key] = super._methods[key]
        endfor
        for field in super._fields
            if index(clazz._fields, field) == -1
                call add(clazz._fields, field)
            endif
        endfor
    endfor
        
    for key in keys(a:methods)
        let clazz._methods[key] = a:methods[key]
    endfor
    for field in a:fields
        if index(clazz._fields, field) == -1
            call add(clazz._fields, field)
        endif
    endfor
    let clazz['Create'] = function('Create')
    return clazz
endfunction
