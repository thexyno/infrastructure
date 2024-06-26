{
  apiVersion: 'postgres-operator.crunchydata.com/v1beta1',
  kind: 'PostgresCluster',
  metadata: {
    name: 'hippo',
    namespace: 'postgres-operator',
  },
  spec: {
    image: 'registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-16.2-0',
    postgresVersion: 16,
    instances: [
      {
        name: 'instance1',
        dataVolumeClaimSpec: {
          accessModes: [
            'ReadWriteOnce',
          ],
          resources: {
            requests: {
              storage: '1Gi',
            },
          },
        },
      },
    ],
    backups: {
      pgbackrest: {
        image: 'registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.49-0',
        repos: [
          {
            name: 'repo1',
            volume: {
              volumeClaimSpec: {
                accessModes: [
                  'ReadWriteOnce',
                ],
                resources: {
                  requests: {
                    storage: '1Gi',
                  },
                },
              },
            },
          },
        ],
      },
    },
  },
}
