package = 'testserver'
version = 'scm-1'
source  = {
	url = '/dev/null',
}
-- Put any modules your app depends on here
dependencies = {
    'tarantool',
    'lua >= 5.1',
    'checks == 3.1.0-1',
    'cartridge == 2.5.1-1',
    'metrics == 0.6.0-1',
    'cartridge-cli-extensions == 1.1.0-1',
    'crud == 0.5.0-1',
    'migrations'
}
build = {
	type = 'none';
}
