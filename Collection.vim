source Class.vim

Class 'Collection'
    AbstractMethod 'ForEach'
    AbstractMethod 'IsEmpty'
    AbstractMethod 'Contains'
EndClass

Class 'Stack'
    Extends Collection
    AbstractMethod 'Pop'
    AbstractMethod 'Push'
EndClass

Class 'Queue'
    Extends Collection
    AbstractMethod 'Add'
    AbstractMethod 'Pop'
EndClass

Class 'Set'
    Extends Collection
    AbstractMethod 'Add'
    AbstractMethod 'Get'
    AbstractMethod 'Set'
EndClass

"-------------------------------------------------------------------------------

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
    Method 'ForEach', function('ForEach')
    Method 'IsEmpty', function('IsEmpty')
    Method 'Contains', function('Contains')
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
    Method 'Add', function('LQAdd')
    Method 'Pop', function('Pop')
EndClass

let qu1 = LinkedQueue.Create()

call qu1.Add(5)
call qu1.Add(6)
call qu1.Add(4)
call qu1.Add(2)
call qu1.Add(1)
call qu1.Add(3)

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
    Method 'Push', function('Push')
    Method 'Pop', function('Pop')
EndClass

let st1 = LinkedStack.Create()

call st1.Push(5)
call st1.Push(6)
call st1.Push(4)
call st1.Push(2)
call st1.Push(1)
call st1.Push(3)

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

function! Get(index) dict
    let i = a:index
    let cur = self._first
    while i
        let i = i - 1
        let cur = cur.next
    endwhile
    return cur.value
endfunction

function! Set(index, value) dict
    let i = a:index
    let cur = self._first
    while i
        let i = i - 1
        let cur = cur.next
    endwhile
    let cur.value = a:value
endfunction

Class 'LinkedSet'
    Extends Set
    Extends LinkedStructureWhitLast
    Method 'Add', function('StAdd')
    Method 'Get', function('Get')
    Method 'Set', function('Set')
EndClass

let st = LinkedSet.Create()
call st.Add(1)
call st.Add(1)
call st.Add(2)
call st.Add(3)
call st.Add(4)
call st.Add(5)
call st.Add(5)

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
    Method 'Add', function('SQAdd')
EndClass

function! Compare(value1, value2)
    if a:value2 == a:value1
        return 0
    elseif a:value2 > a:value1
        return -1
    else
        return 1
    endif
endfunction

let sq1 = SortedLinkedQueue.Create()
let sq1.comparator = function('Compare')

function! Echo(value)
    echo a:value
endfunction

call sq1.Add(2)
call sq1.Add(1)
call sq1.Add(13)
call sq1.Add(4)
call sq1.Add(5)
call sq1.Add(7)
call sq1.Add(12)
call sq1.Add(8)
call sq1.Add(6)
call sq1.Add(9)
call sq1.Add(10)
call sq1.Add(11)
call sq1.Add(3)
call sq1.Super('Add', g:LinkedQueue)(0)
call sq1.Super('Add', g:LinkedQueue)(14)


call sq1.ForEach(function('Echo'))
echo '---'
call st.ForEach(function('Echo'))
echo '---'
call qu1.ForEach(function('Echo'))
echo '---'
call st1.ForEach(function('Echo'))
