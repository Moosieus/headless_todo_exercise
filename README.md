# Todo

## Local Dev Setup

### Prerequisites:
  * Install Erlang and Elixir if you haven't done so already. A `.tool-versions` file is provided for users of [asdf](https://asdf-vm.com/) or [mise](https://mise.jdx.dev/).
  * Run `docker compose up` (or your preferred tool) to start the Postgres. *Be mindful to stop any other running instances of Postgres before doing so.*

To start your Phoenix server:
  * Run `mix setup` to install and setup dependencies, initialize the database, and build frontend assets.
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`.

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

## Dev Usage
  * Navigate to http://localhost:4000.
  * Register an account.
  * Navigate to http://localhost:4000/dev/mailbox to get the confirmation link.
  * Retrieve the bearer token and use that to utilize the API.

## Notes
In dev mode, emails sent by the system can be viewed at http://localhost:4000/dev/mailbox. You'll need to use this to emulate the email confirmation flow.

The database can be connected to via: `psql -h 127.0.0.1 -U postgres todo_dev`.

Example requests are available in `/bruno` for the [Bruno REST client](https://www.usebruno.com/). You will need to provide a bearer token and adjust the request IDs as needed, as the database isn't seeded by default.
