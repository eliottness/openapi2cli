# openapi2cli
Create a portable binary from an OpenAPI Specification

## Usage

Generate a binary `cli` from the yaml openAPI file

```sh
$ openapi2cli openapi.yaml --out-bin cli
```

## Samples of pairs: spec + how to use it as cli

### Simple example

```yml
paths:
  /batch:
    get:
      operationId: get-batches
      description: "Return a list of batches"
      tags:
      - Batch Resource
      responses:
        "200":
          description: OK
```

```sh
$ ./cli get-batches # Print the response if return code is 200
```

### Path argument

```yml
paths:
  /batch/{batchId}:
    get:
      operationId: get-batch
      tags:
      - Batch Resource
      parameters:
      - name: batchId
        in: path
        required: true
        schema:
          $ref: '#/components/schemas/UUID'
      responses:
        "200":
          description: OK
```

```sh
$ ./cli get-batch --batchId XXXX-XXXX-XXXX-XXXX # Print the response
```

Here we need to check that the param exists for the command `get-batch`
and then we need to check it is the good format of parameter.
And finally if the parameter is set to `required: true` the cli must throw
and error and ask the user to specify.


### Request Body

```yml
paths:
  /batch/publish:
    put:
      operationId: put-batch-publish
      tags:
      - Batch Resource
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/Request3'
      responses:
        "200":
          description: OK
```

```sh
$ ./cli put-batch-publish --body-file file.json # Get the request body from the file: file.json
$ ./cli put-batch-publish --body-stdin          # Get the request body from stdin
$ ./cli put-batch-publish --body {}             # Get the request body from the argument
```

Here we must check if the input body is a good json
and add the proper header `Content-Type` header in the request
and if the command put-batch-publish takes a body
