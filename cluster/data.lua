local crud = require('crud')
local vshard = require('vshard')
local uuid = require('uuid')
local function gen_simple_uuid(char)
    return uuid.fromstr((char):rep(8) .. '-' .. (char):rep(4)
        .. '-' .. (char):rep(4) .. '-' .. (char):rep(4) .. '-' .. (char):rep(12))
end
crud.insert(
    "vets", { gen_simple_uuid('1'), 'James', 'Carter', vshard.router.bucket_id_strcrc32(gen_simple_uuid('1')) }
)
crud.insert(
    "vets", { gen_simple_uuid('2'), 'Helen', 'Leary', vshard.router.bucket_id_strcrc32(gen_simple_uuid('2')) }
)
crud.insert(
    "vets", { gen_simple_uuid('3'), 'Linda', 'Douglas', vshard.router.bucket_id_strcrc32(gen_simple_uuid('3')) }
)
crud.insert(
    "vets", { gen_simple_uuid('4'), 'Rafael', 'Ortega', vshard.router.bucket_id_strcrc32(gen_simple_uuid('4')) }
)
crud.insert(
    "vets", { gen_simple_uuid('5'), 'Henry', 'Stevens', vshard.router.bucket_id_strcrc32(gen_simple_uuid('5')) }
)
crud.insert(
    "vets", { gen_simple_uuid('6'), 'Sharon', 'Jenkins', vshard.router.bucket_id_strcrc32(gen_simple_uuid('6')) }
)

crud.insert(
    "specialties", { gen_simple_uuid('1'), 'radiology', vshard.router.bucket_id_strcrc32(gen_simple_uuid('1')) }
)
crud.insert(
    "specialties", { gen_simple_uuid('2'), 'surgery', vshard.router.bucket_id_strcrc32(gen_simple_uuid('2')) }
)
crud.insert(
    "specialties", { gen_simple_uuid('3'), 'dentistry', vshard.router.bucket_id_strcrc32(gen_simple_uuid('3')) }
)

crud.insert(
    "vet_specialties", { gen_simple_uuid('2'), gen_simple_uuid('1'),
                         vshard.router.bucket_id_strcrc32(gen_simple_uuid('2')) }
)
crud.insert(
    "vet_specialties", { gen_simple_uuid('3'), gen_simple_uuid('2'),
                         vshard.router.bucket_id_strcrc32(gen_simple_uuid('3')) }
)
crud.insert(
    "vet_specialties", { gen_simple_uuid('3'), gen_simple_uuid('3'),
                         vshard.router.bucket_id_strcrc32(gen_simple_uuid('3')) }
)
crud.insert(
    "vet_specialties", { gen_simple_uuid('4'), gen_simple_uuid('2'),
                         vshard.router.bucket_id_strcrc32(gen_simple_uuid('4')) }
)
crud.insert(
    "vet_specialties", { gen_simple_uuid('5'), gen_simple_uuid('1'),
                         vshard.router.bucket_id_strcrc32(gen_simple_uuid('5')) }
)

crud.insert("owners",
    { gen_simple_uuid('1'), 'George', 'Franklin', '110 W. Liberty St.', 'Madison', '6085551023' }
)
crud.insert("owners",
    { gen_simple_uuid('2'), 'Betty', 'Davis', '638 Cardinal Ave.', 'Sun Prairie', '6085551749' }
)
crud.insert("owners",
    { gen_simple_uuid('3'), 'Eduardo', 'Rodriquez', '2693 Commerce St.', 'McFarland', '6085558763' }
)
crud.insert("owners",
    { gen_simple_uuid('4'), 'Harold', 'Davis', '563 Friendly St.', 'Windsor', '6085553198' }
)
crud.insert("owners",
    { gen_simple_uuid('5'), 'Peter', 'McTavish', '2387 S. Fair Way', 'Madison', '6085552765' }
)
crud.insert("owners",
    { gen_simple_uuid('6'), 'Jean', 'Coleman', '105 N. Lake St.', 'Monona', '6085552654' }
)
crud.insert("owners",
    { gen_simple_uuid('7'), 'Jeff', 'Black', '1450 Oak Blvd.', 'Monona', '6085555387' }
)
crud.insert("owners",
    { gen_simple_uuid('8'), 'Maria', 'Escobito', '345 Maple St.', 'Madison', '6085557683' }
)
crud.insert("owners",
    { gen_simple_uuid('9'), 'David', 'Schroeder', '2749 Blackhawk Trail', 'Madison', '6085559435' }
)
crud.insert("owners",
    { gen_simple_uuid('a'), 'Carlos', 'Estaban', '2335 Independence La.', 'Waunakee', '6085555487' }
)

local function from_string_to_timestamp(str)
    local runyear, runmonth, runday = string.match(str, "(%d+)-(%d+)-(%d+)")
    --os.date use seconds, java use milliseconds
    return os.time({ year = runyear, month = runmonth, day = runday }) * 1000
end

crud.insert(
    "pets", { gen_simple_uuid('1'), 'Leo', from_string_to_timestamp('2010-09-07'),
              gen_simple_uuid('1'), gen_simple_uuid('1') }
)
crud.insert(
    "pets", { gen_simple_uuid('2'), 'Basil', from_string_to_timestamp('2012-08-06'),
              gen_simple_uuid('6'), gen_simple_uuid('2') }
)
crud.insert(
    "pets", { gen_simple_uuid('3'), 'Rosy', from_string_to_timestamp('2011-04-17'),
              gen_simple_uuid('2'), gen_simple_uuid('3') }
)
crud.insert(
    "pets", { gen_simple_uuid('4'), 'Jewel', from_string_to_timestamp('2010-03-07'),
              gen_simple_uuid('2'), gen_simple_uuid('3') }
)
crud.insert(
    "pets", { gen_simple_uuid('5'), 'Iggy', from_string_to_timestamp('2010-11-30'),
              gen_simple_uuid('3'), gen_simple_uuid('4') }
)
crud.insert(
    "pets", { gen_simple_uuid('6'), 'George', from_string_to_timestamp('2010-01-20'),
              gen_simple_uuid('4'), gen_simple_uuid('5') }
)
crud.insert(
    "pets", { gen_simple_uuid('7'), 'Samantha', from_string_to_timestamp('2012-09-04'),
              gen_simple_uuid('1'), gen_simple_uuid('6') }
)
crud.insert(
    "pets", { gen_simple_uuid('8'), 'Max', from_string_to_timestamp('2012-09-04'),
              gen_simple_uuid('1'), gen_simple_uuid('6') }
)
crud.insert(
    "pets", { gen_simple_uuid('9'), 'Lucky', from_string_to_timestamp('2011-08-06'),
              gen_simple_uuid('5'), gen_simple_uuid('7') }
)
crud.insert(
    "pets", { gen_simple_uuid('a'), 'Mulligan', from_string_to_timestamp('2007-02-24'),
              gen_simple_uuid('2'), gen_simple_uuid('8') }
)
crud.insert(
    "pets", { gen_simple_uuid('b'), 'Freddy', from_string_to_timestamp('2010-03-09'),
              gen_simple_uuid('5'), gen_simple_uuid('9') }
)
crud.insert(
    "pets", { gen_simple_uuid('c'), 'Lucky', from_string_to_timestamp('2010-06-24'),
              gen_simple_uuid('2'), gen_simple_uuid('a') }
)
crud.insert(
    "pets", { gen_simple_uuid('d'), 'Sly', from_string_to_timestamp('2012-06-08'),
              gen_simple_uuid('1'), gen_simple_uuid('a') }
)

crud.insert(
    "visits", { gen_simple_uuid('1'), gen_simple_uuid('7'), from_string_to_timestamp('2013-01-01'), 'rabies shot' }
)
crud.insert(
    "visits", { gen_simple_uuid('2'), gen_simple_uuid('8'), from_string_to_timestamp('2013-01-02'), 'rabies shot' }
)
crud.insert(
    "visits", { gen_simple_uuid('3'), gen_simple_uuid('8'), from_string_to_timestamp('2013-01-03'), 'neutered' }
)
crud.insert(
    "visits", { gen_simple_uuid('4'), gen_simple_uuid('7'), from_string_to_timestamp('2013-01-04'), 'spayed' }
)

crud.insert(
    "types", { gen_simple_uuid('1'), 'cat' }
)
crud.insert(
    "types", { gen_simple_uuid('2'), 'dog' }
)
crud.insert(
    "types", { gen_simple_uuid('3'), 'lizard' }
)
crud.insert(
    "types", { gen_simple_uuid('4'), 'snake' }
)
crud.insert(
    "types", { gen_simple_uuid('5'), 'bird' }
)
crud.insert(
    "types", { gen_simple_uuid('6'), 'hamster' }
)
