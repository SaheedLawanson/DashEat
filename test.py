# Dynamically generates an update expression for dynamo db
def generate_update_exp(form, immutable_fields):
    attr_values = {}
    attr_keys = {}
    def immutable_exp (attr, val):
        attr_values[f":{attr}"] = val
        attr_keys[f"#{attr}"] = attr
        return f"#{attr} = if_not_exists(#{attr}, :{attr})"

    def mutable_exp(attr, val):
        attr_values[f":{attr}"] = val
        attr_keys[f"#{attr}"] = attr
        return f"#{attr} = :{attr}"

    exp = []
    for attr, value in form.items():
        if attr in immutable_fields:
            exp.append(immutable_exp(attr, value))
        else:
            exp.append(mutable_exp(attr, value))

    return {
        "update_exp": f"SET {', '.join(exp)}",
        "exp_attr_vals": attr_values,
        "exp_attr_keys": attr_keys
    }

form = {
    "status": "available"
}

imm = ["last_name", "gender", "birth_date"]

val = generate_update_exp(form, imm)
print(val)