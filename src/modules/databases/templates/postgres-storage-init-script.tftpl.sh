for cm_type in sql data; do
  mkdir -p /migrations/$cm_type
  cd /postgres-storage-migrations-$cm_type-tar
  tar -xvf postgres-storage-migrations-$cm_type.tar \
    --directory /migrations/$cm_type
done

echo "/migrations content:"
ls -al /migrations

PGPASSWORD=${postgres_password} \
  psql \
  -U ${postgres_username} \
  -d ${default_database} \
  -c '\i /migrations/sql/init.sql;'

PGPASSWORD=${postgres_password} \
  psql \
  -U ${postgres_username} <<EOT
  CREATE GROUP ${vault_manager_group_name} 
    NOCREATEDB 
    NOLOGIN 
    NOSUPERUSER;
EOT

PGPASSWORD=${postgres_password} \
  psql \
  -d ai_education \
  -U ${postgres_username} <<EOT
  CREATE ROLE ${vault_manager_ai_education_username} 
    WITH LOGIN
    CREATEROLE
    IN GROUP ${vault_manager_group_name}
    ENCRYPTED PASSWORD '${vault_manager_ai_education_password}' 
    CONNECTION LIMIT 5;

  GRANT ${vault_manager_group_name} 
    TO ${vault_manager_ai_education_username}
    WITH ADMIN OPTION;

  GRANT ALL ON DATABASE ai_education 
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
  GRANT ALL ON SCHEMA public 
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
  GRANT ALL ON SCHEMA restricted 
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL TABLES
    IN SCHEMA public, restricted
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL FUNCTIONS
    IN SCHEMA public, restricted
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL PROCEDURES
    IN SCHEMA public, restricted
    TO ${vault_manager_ai_education_username}
    WITH GRANT OPTION;
EOT

PGPASSWORD=${postgres_password} \
  psql \
  -d inflation \
  -U ${postgres_username} <<EOT
  CREATE ROLE ${vault_manager_inflation_username}
    WITH LOGIN
    CREATEROLE
    IN GROUP ${vault_manager_group_name}
    ENCRYPTED PASSWORD '${vault_manager_inflation_password}'
    CONNECTION LIMIT 5;

  GRANT ${vault_manager_group_name} 
    TO ${vault_manager_inflation_username}
    WITH ADMIN OPTION;

  GRANT ALL ON DATABASE inflation 
    TO ${vault_manager_inflation_username}
    WITH GRANT OPTION;
  GRANT ALL ON SCHEMA inflation 
    TO ${vault_manager_inflation_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL TABLES
    IN SCHEMA public, inflation
    TO ${vault_manager_inflation_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL FUNCTIONS
    IN SCHEMA public, inflation
    TO ${vault_manager_inflation_username}
    WITH GRANT OPTION;
  GRANT ALL ON ALL PROCEDURES
    IN SCHEMA public, inflation
    TO ${vault_manager_inflation_username}
    WITH GRANT OPTION;
EOT
