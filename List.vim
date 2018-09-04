source Class.vim

let Node = Class(Object, {}, ['next', 'value'])

function! ListAdd(value) dict
    if empty(self._first)
        let self._first = g:Node.create()
        let self._first.value = a:value
        let self._last = self._first
    else
        let self._last.next = g:Node.create()
        let self._last = self._last.next
        let self._last.value = a:value
    endif
endfunction

function! ListPush(value) dict
    let temp = g:Node.create()
    let temp.value = a:value
    let temp.next = self._first
    let self._first = temp
endfunction

function! ListPop() dict
    let temp = self._first
    let self._first = self._first.next
    return temp.value
endfunction

let List = Class(Object, {'add': function('ListAdd'), 'push': function('ListPush'), 'pop': function('ListPop')}, ['_first', '_last'])

let l1 = List.create()
call l1.add(1)
call l1.add(2)
call l1.add(3)
call l1.add(4)
call l1.add(5)
call l1.add(6)
call l1.add(7)
call l1.add(8)
call l1.add(9)
call l1.push(0)
