# Product page

Project stolen from Istio samples :
[productpage](https://github.com/istio/istio/tree/master/samples/bookinfo/src/productpage)

## Change made

### `DevOps`

- Project management using [`uv`](https://docs.astral.sh/uv/).
- Addition of Docker multistage building for production and development.
- Use of [`TiltFile`](https://tilt.dev/) for local development.

### `Python`

Few changes have been made to the original application. I'm not used to working with `Flask`. I
usually develop with `FastAPI`, but I didn't want to completely recode the application, so I kept
the original structure.

> This introduction is just there to explain that, this code does not reflect my skills as a Python
> developer. 🙃

Changes I have made are marked with `# Changed` in [app.py](src/productpage/app.py):

- Add password grant authentication to the Python SPA. Use of JWTs for microservice authentication.
  - Not logged in, no access.
  - Once logged in, access according to JWT role.

#### TODO

- [ ] Add [`Pydantic BaseSettings`](https://docs.pydantic.dev/latest/concepts/pydantic_settings/)
  for application configuration and environment variables.
- [ ] Add [`Ruff`](https://docs.astral.sh/ruff/), for linting and formatting
  - [x] Formatting
  - [ ] Linting
- [ ] Add [`mypy`](https://www.mypy-lang.org/), to check static typing
