# Railway Migration Guide

**SIMPLIFIED:** How to run database migrations on Railway.

## The Working Solution

Your Railway service is called `liftskit-backend`. Use this command:

```bash
railway ssh --project secure-art --environment production --service liftskit-backend "/app/bin/migrate"
```

## Expected Output

When successful, you'll see:
```
== Running 20251003000333 LiftskitBackend.Repo.Migrations.AddDarkmodeToAccount.change/0 forward
alter table users
== Migrated 20251003000333 in 0.0s
```

## Troubleshooting

If the command doesn't work:

1. **Make sure you're linked to the project first:**
   ```bash
   railway link --project secure-art --environment production --service liftskit-backend
   ```

2. **If you get "mix: not found"**, you're using the wrong command. Use `/app/bin/migrate` not `mix ecto.migrate`

3. **If you get service not found errors**, check your Railway dashboard to see the exact service name

## Key Points

- **Service Name**: Your Railway service is called "liftskit-backend"
- **Migration Command**: Use `/app/bin/migrate` (for Phoenix releases) - NOT `mix ecto.migrate`
- **Project**: secure-art
- **Environment**: production

That's it! Save this somewhere you'll remember for next time.