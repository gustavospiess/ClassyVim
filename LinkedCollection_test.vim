source LinkedCollection.vim

let qu1 = LinkedQueue.Create()

call qu1.Add(6)
call qu1.Add(5)
call qu1.Add(4)
call qu1.Add(3)
call qu1.Add(2)
call qu1.Add(1)

"-------------------------------------------------------------------------------

let st1 = LinkedStack.Create()

call st1.Push(6)
call st1.Push(5)
call st1.Push(4)
call st1.Push(3)
call st1.Push(2)
call st1.Push(1)

"-------------------------------------------------------------------------------

let ls1 = LinkedList.Create()
call ls1.Add(1)
call ls1.Add(1)
call ls1.Add(2)
call ls1.Add(3)
call ls1.Add(4)
call ls1.Add(5)
call ls1.Add(5)
call ls1.Set(0, 0)
call ls1.Set(6, 6)

"-------------------------------------------------------------------------------

let set1 = LinkedSet.Create()
call set1.Add(0)
call set1.Add(1)
call set1.Add(2)
call set1.Add(3)
call set1.Add(3)
call set1.Add(4)
call set1.Add(5)
call set1.Add(6)
call set1.Add(7)
call set1.Add(8)
call set1.Add(9)
call set1.Add(9)

"-------------------------------------------------------------------------------


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
let sq1.comparator = funcref('Compare')

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

"-------------------------------------------------------------------------------

function! Echo(value)
    echo a:value
endfunction

"call sq1.ForEach(funcref('Echo'))
"echo 'SortedLinkedQueue(1-13,0,14)'
"echo '----------------------'
"call ls1.ForEach(funcref('Echo'))
"echo 'LinkedList(0-6)'
"echo '----------------------'
"call qu1.ForEach(funcref('Echo'))
"echo 'LinkedQueue(6-1)'
"echo '----------------------'
"call st1.ForEach(funcref('Echo'))
"echo 'LinkedStack(1-6)'
"echo '----------------------'
"call set1.ForEach(funcref('Echo'))
"echo 'LinkedSet(0-9)'

call assert_equal(1,  sq1.Pop())
call assert_equal(2,  sq1.Pop())
call assert_equal(3,  sq1.Pop())
call assert_equal(4,  sq1.Pop())
call assert_equal(5,  sq1.Pop())
call assert_equal(6,  sq1.Pop())
call assert_equal(7,  sq1.Pop())
call assert_equal(8,  sq1.Pop())
call assert_equal(9,  sq1.Pop())
call assert_equal(10, sq1.Pop())
call assert_equal(11, sq1.Pop())
call assert_equal(12, sq1.Pop())
call assert_equal(13, sq1.Pop())
call assert_equal(0,  sq1.Pop())
call assert_equal(14, sq1.Pop())

call assert_equal(0, ls1.Get(0))
call assert_equal(1, ls1.Get(1))
call assert_equal(2, ls1.Get(2))
call assert_equal(3, ls1.Get(3))
call assert_equal(4, ls1.Get(4))
call assert_equal(5, ls1.Get(5))
call assert_equal(6, ls1.Get(6))

call assert_equal(6, qu1.Pop())
call assert_equal(5, qu1.Pop())
call assert_equal(4, qu1.Pop())
call assert_equal(3, qu1.Pop())
call assert_equal(2, qu1.Pop())
call assert_equal(1, qu1.Pop())

call assert_equal(1, st1.Pop())
call assert_equal(2, st1.Pop())
call assert_equal(3, st1.Pop())
call assert_equal(4, st1.Pop())
call assert_equal(5, st1.Pop())
call assert_equal(6, st1.Pop())

call assert_equal(0, set1.Remove(10))
call assert_equal(1, set1.Remove(9))
call assert_equal(0, set1.Remove(9))

for msg in v:errors
    echo msg
endfor
