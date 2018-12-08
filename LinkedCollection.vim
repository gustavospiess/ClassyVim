source Collection.vim

Class 'Node'
    Field 'next'
    Field 'value'
EndClass

function! IsEmpty() dict
    return empty(self._first)
endfunction

function! ForEach(callBack) dict
    let cur = self._first
    while !empty(cur)
        call a:callBack(cur.value)
        let cur = cur.next
    endwhile
endfunction

function! Contains(value) dict
    let cur = self._first
    while !empty(cur)
        if cur.value == a:value
            return 1
        endif
        let cur = cur.next
    endwhile
endfunction

Class 'LinkedStructure'
    Extends Collection
    Method 'ForEach', funcref('ForEach')
    Method 'IsEmpty', funcref('IsEmpty')
    Method 'Contains', funcref('Contains')
    Field '_first'
EndClass

Class 'LinkedStructureWhitLast'
    Extends LinkedStructure
    Field '_last'
EndClass

"---------------------------------------

function! LQAdd(value) dict
    if empty(self._first)
        let self._first = g:Node.Create()
        let self._first.value = a:value
        let self._last = self._first
    else
        let self._last.next = g:Node.Create()
        let self._last = self._last.next
        let self._last.value = a:value
    endif
endfunction

function! Pop() dict
    let temp = self._first
    let self._first = self._first.next
    return temp.value
endfunction

Class 'LinkedQueue'
    Extends Queue
    Extends LinkedStructureWhitLast
    Method 'Add', funcref('LQAdd')
    Method 'Pop', funcref('Pop')
EndClass

"---------------------------------------

function! Push(value) dict
    let temp = g:Node.Create()
    let temp.value = a:value
    let temp.next = self._first
    let self._first = temp
endfunction

Class 'LinkedStack'
    Extends Stack
    Extends LinkedStructure
    Method 'Push', funcref('Push')
    Method 'Pop', funcref('Pop')
EndClass

"---------------------------------------

function! LsAdd(value) dict
    if empty(self._first)
        let self._first = g:Node.Create()
        let self._first.value = a:value
        let self._last = self._first
    else
        let self._last.next = g:Node.Create()
        let self._last = self._last.next
        let self._last.value = a:value
    endif
endfunction

function! LsGet(index) dict
    let i = a:index
    let cur = self._first
    while i
        let i = i - 1
        let cur = cur.next
    endwhile
    return cur.value
endfunction

function! LsSet(index, value) dict
    let i = a:index
    let cur = self._first
    while i
        let i = i - 1
        let cur = cur.next
    endwhile
    let cur.value = a:value
endfunction

Class 'LinkedList'
    Extends List
    Extends LinkedStructureWhitLast
    Method 'Add', funcref('LsAdd')
    Method 'Get', funcref('LsGet')
    Method 'Set', funcref('LsSet')
EndClass

"---------------------------------------

function! SQAdd(value) dict
    if empty(self._first)
        let self._first = g:Node.Create()
        let self._first.value = a:value
        let self._last = self._first
    elseif (self.comparator(a:value, self._first.value) < 0)
        let temp = g:Node.Create()
        let temp.value = a:value
        let temp.next = self._first
        let self._first = temp
    else
        let cur = self._first.next
        let last = self._first
        while !empty(cur)
            if self.comparator(a:value, cur.value) < 0
                break
            endif
            let last = cur
            let cur = cur.next
        endwhile
        if !empty(cur)
            let temp = g:Node.Create()
            let temp.value = a:value
            let temp.next = cur
            let last.next = temp
        else
            let self._last.next = g:Node.Create()
            let self._last = self._last.next
            let self._last.value = a:value
        endif
    endif
endfunction

Class 'SortedLinkedQueue'
    Extends LinkedQueue
    Field 'comparator'
    Method 'Add', funcref('SQAdd')
EndClass

"---------------------------------------

function! StAdd(value) dict
    if self.Contains(a:value)
        return 0
    endif
    if empty(self._first)
        let self._first = g:Node.Create()
        let self._first.value = a:value
        let self._last = self._first
    else
        let self._last.next = g:Node.Create()
        let self._last = self._last.next
        let self._last.value = a:value
    endif
endfunction

function! StRemove(value) dict
    if a:value == self._first.value
        let self._first = self._first.next
        return 1
    else
        let ac = self._first.next
        let lt = self._first
        while !empty(ac)
            if ac.value == a:value
                let lt.next = ac.next
                return 1
            endif
            let lt = ac
            let ac = ac.next
        endwhile
        return 0
    endif
endfunction

Class 'LinkedSet'
    Extends Set
    Extends LinkedStructure
    Method 'Add', funcref('StAdd')
    Method 'Remove', funcref('StRemove')
EndClass

