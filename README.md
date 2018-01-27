# prog-fill - Smartly format lines to use vertical space.

[![MELPA](http://melpa.org/packages/prog-fill-badge.svg)](http://melpa.org/#/prog-fill)

Have you ever hated having really long chained method calls in heavy
OOP languages?  or just enjoy avoiding hitting the 80 column margin in
any others?

If so, this is the mode for you!

# Examples

Imagine coming across this mess - who wants to try to mentally parse
that out?

```php
$this->setBlub((Factory::get('some-thing', 'with-args'))->inner())->withChained(1, 2, 3);
```
Hit M-q on the line (after binding it of course for that mode) and it
becomes:
```php
$this
    ->setBlub(
        (Factory::get(
            'some-thing',
            'with-args'))
        ->inner())
    ->withChained(
        1,
        2,
        3);
```

Or maybe you've got a crazy javasript promise chain you're working on?

```js
superagent.get(someUrl).then(response => response.body).catch(reason => console.log(reason))
```
Again, press M-q on the line and it becomes:
```js
superagent.get(someUrl)
  .then(response => response.body)
  .catch(reason => console.log(reason))

```


# Installation

Clone the repo, then in your Emacs init file:

```lisp
(add-to-list 'load-path "/path/to/repo")
(require 'prog-fill)
M-x prog-fill ;; to run on current line (ideally, bound to M-q)
```

## Binding

After installing, you should bind the function:

```lisp
(add-hook
 'prog-mode-hook
 (lambda () (local-set-key (kbd "M-q") #'prog-fill)))
 ```

## Customization

### prog-fill-break-method-immediate-p

You may find in some modes you want to break right away on a method,
whlie others you do not, for instance in PHP it is common to use:

```php
$this->something
  ->anotherThing();
```

Whlie in JS you would usually see:
```js
object
  .something
  .anotherThing()
```

The default is nil, meaning it will only break on the second chained
call (not the first) - set to t to break on the first.

### prog-fill-floating-open-paren-p

With this set to t, it will make a parenthesis "float" by itself, such
as:

```php
$this->that(
  1,
  2
);
```

If set to nil, it will *not* float, and will appear as:

```php
$this->that(1,
            2
);
```

The default is t, floating parens.

### prog-fill-floating-close-paren-p

With this set to t, it will make a parenthesis "float" by itself, such
as:

```php
$this->that(
  1,
  2
);
```

If set to nil, it will *not* float, and will appear as:

```php
$this->that(
  1,
  2);
```

The default is t, floating parens.

### prog-fill-auto-indent-p

This controls the behavior of the auto-indent call - if you disable it
(set to nil) this package will not work well, as it will assign the
breaks without indenting them.

### prog-fill-method-separators

Controls what is considered a method break - by default it is *NOT* a
typical list, but a segment of an rx string build `'(or "->" ".")`,
which should account for PHP style, JS style, C style and C++ style
(maybe I should add `::` in there, but you can customize if you want
to break on those).

### prog-fill-arg-separators

Currently set to `'(or ",")`, this determines 'args' - in a non comma
separated language (a lisp) you may want to set this to a space for a
local mode variable, via a setq-local call in that mode's hook list.

# Todo
- Breaks with matches in comment strings will also break those - need
  to avoid that!  (or you can avoid string literals :) )

# License

GPLv3

# Copyright

Matthew Carter <m@ahungry.com>
