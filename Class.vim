let AbstractMethodNotImplemented = 'Er001 - Abstract Method not implemented'

function! Create() dict
    let obj = {}
    for meth in keys(self._methods)
        if self._methods[meth] == 'asbtract'
            throw AbstractMethodNotImplemented
        endif
        let obj[meth] = self._methods[meth]
    endfor
    for fie in self._fields
        let obj[fie] = 0
    endfor
    let obj.class = self
    return obj
endfunction

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
    let clazz['create'] = function('Create')
    return clazz
endfunction

function! Class(parent, methods, fields)
    return MultiClass([a:parent], a:methods, a:fields)
endfunction

let Object = {'_methods' : {}, '_fields': [], 'create': function('Create')}
let Object._parents = [ Object ]
