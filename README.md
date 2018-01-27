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
M-x prog-fill ;; to run on current line (ideally, bind to M-q)
```

# todo
- Breaks with matches in comment strings will also break those - need
  to avoid that!  (or you can avoid string literals :) )

# License

GPLv3

# Copyright

Matthew Carter <m@ahungry.com>
