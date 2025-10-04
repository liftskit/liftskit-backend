# Railway Migration Guide

**SIMPLIFIED:** How to run database migrations on Railway.

## The Working Solution

Your Railway service is called `liftskit-backend`. Use this command:

```bash
railway ssh "/app/bin/migrate"
```

**Note:** Since you're already linked to the project via `railway link`, you can use the simplified command above. If you need to specify the project explicitly, use:

```bash
railway ssh --project secure-art --environment production --service liftskit-backend "/app/bin/migrate"
```

## Expected Output

When successful, you'll see:
```
== Running 20251004153700 LiftskitBackend.Repo.Migrations.AddMembershipToUser.change/0 forward
alter table users
== Migrated 20251004153700 in 0.0s
```

## Troubleshooting

If the command doesn't work:

1. **First, make sure you're logged in:**
   ```bash
   railway login
   ```

2. **Make sure you're linked to the project first:**
   ```bash
   railway link --project secure-art --environment production --service liftskit-backend
   ```

3. **Important: Use the correct path with leading slash:**
   ```bash
   # ✅ CORRECT - with leading slash
   railway ssh --project secure-art --environment production --service liftskit-backend "/app/bin/migrate"
   
   # ❌ WRONG - missing leading slash  
   railway ssh --project secure-art --environment production --service liftskit-backend "app/bin/migrate"
   ```

4. **If you get "mix: not found"**, you're using the wrong command. Use `/app/bin/migrate` not `mix ecto.migrate`

5. **If you get "Project not found" errors**, try:
   - `railway logout` then `railway login`
   - Re-run the `railway link` command
   - Check your Railway dashboard to verify service details

## Key Points

- **Service Name**: Your Railway service is called "liftskit-backend"
- **Migration Command**: Use `/app/bin/migrate` (for Phoenix releases) - NOT `mix ecto.migrate`
- **Project**: secure-art
- **Environment**: production

That's it! Save this somewhere you'll remember for next time.