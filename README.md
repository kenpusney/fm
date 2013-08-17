fm.rb
=====

fast OO modeling

## examples:

```shell
ruby -I. example.rb
```

## steps

1. begin parse(if exists).
2. resolve relation.
3. begin processing.
4. generating frame body.
5. generating frame details.
6. return.

## fm-expr syntax:

> fm-expr parser is under construction.

### heading declare of class:

```ruby

# declare class or interface.
SomeClass
    or
^SomeInterface

# declare relationship (inherit or extends or implements)
SomeClass < AParentClass        #inherit from or extends AParentClass
SomeClass .AnInterface          #inherit from or implements AnInterface
SomeClass <AClass.AnInterface   #both extends AClass and implements AnInterface
```

### declare class body

class body declaring after a `>` sign and end with `;`.
```ruby
SomeClass > 
    ... ... # the end.
    ;  # the end.
```

for __each__ class, it has different internal factors:

* instance methods (both `private`/`-` and `public`/`+`)
* attributes ( __private__, but may have accessor with `read`/`write` or both access.)
* class methods(`=`)
* all methods may be virtual(`^`)
* all methods have arguments and return value (and both may be empty/null/void)
* all methods may have name alias.

e.g.:
```ruby
^AnInterface >
    +^parse(expr:string):Hash
SomeClass<AClass.AnInterface >
    
    ## attributes with access method.
    @info/rw:Hash    ## declares a private attr and generates get/set methods.
    @expr/w:string   ## declares a private attr and generates set method only.
    @@count/rw:int   ## declares a class(static) attr with get/set method. 

    ## public method
    +parse(expr:string):Hash     ## Java  : public Hash parse(String expr) { }
                                 ## C++   : public: Hash parse(string expr);
                                 ## Ruby  : def parse(expr)  # (string) -> Hash
                                 ##       :     #<body>
                                 ##       : end

    ## private method
    -internalOpetarion():void    ## Java  : private void internalOperation() { }

    ## static method with name alias
    =create/make():self          ## Java  : public static SomeClass create() { }
                                 ##       : public static SomeClass make() { return create(); }
                                 ##       :
                                 ## Ruby  : def self.@create  ## () -> SomeClass
                                 ##       : end
                                 ##       : alias_method :make,:create
```

### addtional features:

#### type modifier:
```ruby
+parseFromString(expr:string/c):hash    ## string/c means const string.
+produceResult():Object/r               ## Object/r means returns an reference of Object. (C++)
+returnAsPointer():Object/p             ## Object/p means returns an pointer of Object.
@anStructPtr/w:Struct/p                 ## same as above.
```

#### patterns:

> under designing.



## origin:

> https://gist.github.com/kenpusney/6230837
