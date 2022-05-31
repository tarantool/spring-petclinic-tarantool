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
    'cartridge == 2.7.4-1',
    'metrics == 0.13.0-1',
    'cartridge-cli-extensions == 1.1.1-1',
    'crud == 0.11.2-1',
    'migrations == 0.4.2-1',
}
build = {
	type = 'none';
}
