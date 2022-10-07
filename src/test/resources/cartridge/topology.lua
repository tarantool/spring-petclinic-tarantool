cartridge = require('cartridge')
replicasets = { {
        alias = 'router',
        roles = { 'vshard-router', 'crud-router', 'app.roles.api_router' },
        join_servers = { { uri = '0.0.0.0:3301' } }
    }, {
        alias = 's1-storage',
        roles = { 'vshard-storage', 'crud-storage', 'app.roles.api_storage' },
        join_servers = { { uri = '0.0.0.0:3302' }, { uri = '0.0.0.0:3303' } }
    }, {
        alias = 's2-storage',
        roles = { 'vshard-storage', 'crud-storage', 'app.roles.api_storage' },
        join_servers = { { uri = '0.0.0.0:3304' }, { uri = '0.0.0.0:3305' } }
    } }
return cartridge.admin_edit_topology({ replicasets = replicasets })
