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

Class 'List'
    Extends Collection
    AbstractMethod 'Add'
    AbstractMethod 'Get'
    AbstractMethod 'Set'
EndClass

Class 'Set'
    Extends Collection
    AbstractMethod 'Add'
    AbstractMethod 'Remove'
EndClass

