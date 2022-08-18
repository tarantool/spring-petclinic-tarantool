package = 'testserver'
version = 'scm-1'
source  = {
	url = '/dev/null',
}
-- Put any modules your app depends on here
dependencies = {
    'tarantool >= 2.10.0',
    'lua >= 5.1',
    'checks == 3.1.0-1',
    'cartridge == 2.7.5-1',
    'metrics == 0.14.0-1',
    'cartridge-cli-extensions == 1.1.1-1',
    'crud == 0.12.1-1',
    'migrations == 0.4.2-1',
}

build = {
	type = 'none';
}
