globals = {'box'}
include_files = {'**/*.lua', '*.luacheckrc', '*.rockspec'}
exclude_files = {'.rocks/', 'tmp/'}
max_line_length = 120
redefined = false
files["app/roles/api_router.lua"] = {
    globals = {
        "get_vets_with_specialties",
        "find_owners_by_last_name",
        "find_owner_by_id",
        "find_pet_by_id",
        "save_with_generate_uuid",
        "save_pet",
        "save_owner",
        "save_visit",
        "find_visits_by_pet_id",
    },
}
files["app/roles/api_storage.lua"] = {
    globals = {
        "get_vets_with_specialties_id",
    },
}
