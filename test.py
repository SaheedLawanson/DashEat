from jsonschema import validate, exceptions

# Define the accepted schema
schemas = {
    "dasher": {
        "type": "object",
        "properties": {
            # "first_name": "string", # Should be immutable
            "last_name": {"type": "string"}, # Should be immutable
            "gender": {"type": "string"}, # Should be immutable
            "birth_date": {"type": "string"}, # Should be immutable
            "address": {"type": "string"},
            "contact_no": {
                "type": "number",
                "pattern": "^\d{11}$"
            },
            # "email": "string", # Should be immutable
            # "wallet": "string", # Should be immutable
            "profile_img":  {"type": "string"},
            # "registration_date": "string", # Should be immutable
            "status":  {"type": "string"}, # Should be immutable
            # "rating": "number"
        },
        "additionalProperties": False
    },
    "user": {
        "type": "object",
        "properties": {
            # "first_name": "string", # Should be immutable
            "last_name":  {"type": "string"}, # Should be immutable
            "gender":  {"type": "string"}, # Should be immutable
            "birth_date":  {"type": "string"}, # Should be immutable
            "address":  {"type": "string"},
            "contact_no": {
                "type": "string",
                "pattern": "^\d{11}$"
            },
            "profile_img":  {"type": "string"},
            "lat":  {"type": "number"},
            "long":  {"type": "number"},
        },
        "additionalProperties": False
    },
    "vendor": {
        "type": "object",
        "properties": {
            "vendor_name":  {"type": "string"},
            "category":  {"type": "string"},
            "contact": {"type": "string"},
            "schedule_ID":  {"type": "string"},
            "menu":  {"type": "array"},
            "email":  {"type": "string"},
            # "rating": "number" # Should be immutable
        },
        "additionalProperties": False
    }
}

def validator(schema, form):
    try:
        # Eliminate null values and validate
        form = { field: val for field, val in form.items() if val }
        validate(form, schemas["dasher"]) # jsonschema ~> imports
        return {
            "message": "Validated successfully"
        }

    except exceptions.ValidationError as err:
        return {
            "message": err.__str__().split("\n")[0]
        }
    except exceptions.SchemaError:
        return {
            "message": "Invalid schema"
        }
    except Exception as err:
        return {
            "message": err.__str__()
        }

form = {
  "wallet": "200"
}

print(validator(schemas["vendor"], form))