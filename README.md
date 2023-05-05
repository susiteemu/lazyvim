# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

# ra-multiplex
This config relies on `ra-multiplex` being installed on your system.

1. Install it:

    ```sh
    $ cargo install ra-multiplex
    ```
2. Run the server:
    a. Directly

        ```sh
        $ ra-multiplex-server
        ```
    b. Via Tmux

        ```sh
        $ tmux new -d ra-multiplex-server
        ```
    c. Tmux via Automator:
        i. Create a new application with Automator.
        ii. Add a _Run Shell Script_ step to it.
        iii. Add the tmux invocation from the Via Tmux step above to it.
        iv. Now you can add the newly created 'application' to your Login Items.
