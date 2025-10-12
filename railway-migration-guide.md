# Railway Migration Guide

**SIMPLIFIED:** How to run database migrations on Railway.

## The Working Solution

Your Railway service is called `liftskit-backend`. Use this command:

```bash
railway run --service liftskit-backend bash -c 'export DATABASE_URL="$DATABASE_PUBLIC_URL" && mix ecto.migrate'
```

**Alternative:** If you prefer SSH (may have connection issues):

```bash
railway ssh "/app/bin/migrate"
```

**Note:** Since you're already linked to the project via `railway link`, you can use the simplified commands above. If you need to specify the project explicitly, use:

```bash
railway run --project secure-art --environment production --service liftskit-backend bash -c 'export DATABASE_URL="$DATABASE_PUBLIC_URL" && mix ecto.migrate'
```

## Expected Output

When successful, you'll see:
```
== Running 20251009234709 LiftskitBackend.Repo.Migrations.AddWeightliftingToExerciseType.change/0 forward
execute "UPDATE exercises SET _type = 'Weightlifting' WHERE _type IS NULL OR _type = ''"
execute "UPDATE exercise_performed SET _type = 'Weightlifting' WHERE _type IS NULL OR _type = ''"
== Migrated 20251009234709 in 0.1s
```

## Troubleshooting

### Database Connection Issues

If you get database connection errors like:
```
tcp connect (postgres.railway.internal:5432): non-existing domain - :nxdomain
```

**Solution:** Use the public database URL instead of the internal one:
```bash
railway run --service liftskit-backend bash -c 'export DATABASE_URL="$DATABASE_PUBLIC_URL" && mix ecto.migrate'
```

### Other Issues

If the command doesn't work:

1. **First, make sure you're logged in:**
   ```bash
   railway login
   ```

2. **Make sure you're linked to the project first:**
   ```bash
   railway link --project secure-art --environment production --service liftskit-backend
   ```

3. **If you get "Project not found" errors**, try:
   - `railway logout` then `railway login`
   - Re-run the `railway link` command
   - Check your Railway dashboard to verify service details

4. **For SSH method (if preferred):**
   ```bash
   # ✅ CORRECT - with leading slash
   railway ssh --project secure-art --environment production --service liftskit-backend "/app/bin/migrate"
   
   # ❌ WRONG - missing leading slash  
   railway ssh --project secure-art --environment production --service liftskit-backend "app/bin/migrate"
   ```

## Key Points

- **Service Name**: Your Railway service is called "liftskit-backend"
- **Primary Method**: Use `railway run` with public database URL for reliable connections
- **Database URL**: Use `DATABASE_PUBLIC_URL` instead of `DATABASE_URL` to avoid internal domain issues
- **Project**: secure-art
- **Environment**: production

## Why This Works

Railway provides two database URLs:
- `DATABASE_URL`: Uses internal domain (`postgres.railway.internal`) - may not be accessible from local machine
- `DATABASE_PUBLIC_URL`: Uses public proxy (`switchback.proxy.rlwy.net`) - accessible from anywhere

The public URL is more reliable for running migrations from your local machine.

That's it! Save this somewhere you'll remember for next time.