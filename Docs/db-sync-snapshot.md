## DB-Sync Snapshot

Creating a db-sync snapshot can be useful to avoid syncing from the start, which takes more time as the
chain grows. *(Count many days to reach the current block height)*

### Creating the snapshot

1. Stop db-sync container: `docker-compose stop db-sync`
2. Edit docker-compose.yaml to change the launch command script from 'start' to the 'sleep' one.
3. Recreate the container: `docker-compose up -d db-sync`
4. Enter the container and send the following command:
    ```
    PGPASSFILE=/cardano/config/pgpass-mainnet cardano-db-tool prepare-snapshot --state-dir /cardano/ledger-state/
    ```
5. Edit the paths in previous command output and launch the command:
    ```
    /cardano/scripts/postgresql-setup.sh --create-snapshot /cardano/snapshot/db-sync-snapshot-schema-13.5-block-10967396-aarch64 /cardano/ledger-state/137453146-7c9022a80e.lstate
    ```
