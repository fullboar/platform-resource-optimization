
BEGIN TRANSACTION;

-- 
-- database
-- 

GRANT USAGE ON SCHEMA public TO app_api_704fkrus;

-- 
-- resource_usage
-- 

CREATE TABLE IF NOT EXISTS resource_usage (
    id                          SERIAL PRIMARY KEY,
    project_set_id              VARCHAR(8) REFERENCES profile(namespace_prefix) NOT NULL,
    container_cpu_usage_sum     FLOAT DEFAULT 0.0,
    container_cpu_requests_sum  FLOAT DEFAULT 0.0,
    container_cpu_limit_sum     FLOAT DEFAULT 0.0,
    archived                    boolean DEFAULT false NOT NULL,
    created_at                  timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3),
    updated_at                  timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3)
);

CREATE INDEX IF NOT EXISTS project_set_id_idx ON resource_usage (project_set_id);

DROP TRIGGER IF EXISTS update_resource_usage_changetimestamp on resource_usage;
CREATE TRIGGER update_resource_usage_changetimestamp BEFORE UPDATE
ON resource_usage FOR EACH ROW EXECUTE PROCEDURE 
update_changetimestamp_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE resource_usage to app_api_704fkrus;
GRANT USAGE, SELECT ON SEQUENCE resource_usage_id_seq TO app_api_704fkrus;

-- 
-- project
-- 

CREATE TABLE IF NOT EXISTS project (
    id                              SERIAL PRIMARY KEY,
    project_set_id                  VARCHAR(8) NOT NULL,
    name                            VARCHAR(256),
    description                     VARCHAR(512),
    ministry                        VARCHAR(64),
    cluster                         VARCHAR(16),
    project_owner_name              VARCHAR(256),
    project_onwer_email             VARCHAR(256),
    primary_technical_lead_name     VARCHAR(256),
    primary_technical_lead_email    VARCHAR(256),
    secondary_technical_lead_name   VARCHAR(256),
    secondary_technical_lead_email  VARCHAR(256),
    archived                        boolean DEFAULT false NOT NULL,
    created_at                      timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3),
    updated_at                      timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3)
    CONSTRAINT unique_project_set_id UNIQUE(project_set_id)
);

CREATE INDEX IF NOT EXISTS project_set_id_idx ON project (project_set_id);

DROP TRIGGER IF EXISTS project_changetimestamp on project;
CREATE TRIGGER update_project_changetimestamp BEFORE UPDATE
ON project FOR EACH ROW EXECUTE PROCEDURE 
update_changetimestamp_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE project to app_api_704fkrus;
GRANT USAGE, SELECT ON SEQUENCE project_id_seq TO app_api_704fkrus;


-- 
-- requests
-- 

CREATE TABLE IF NOT EXISTS request (
    id                              SERIAL PRIMARY KEY,
    project_set_id                  VARCHAR(8) NOT NULL,
    batch_id                        smallint NOT NULL,
    request_at                      timestamp without time zone NOT NULL,
    archived                        boolean DEFAULT false NOT NULL,
    created_at                      timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3),
    updated_at                      timestamp without time zone DEFAULT CURRENT_TIMESTAMP(3),
    CONSTRAINT fk_project_set_id FOREIGN KEY(project_set_id) REFERENCES project(project_set_id)
);

CREATE INDEX IF NOT EXISTS project_set_id_idx ON request (project_set_id);

DROP TRIGGER IF EXISTS request_changetimestamp on request;
CREATE TRIGGER update_request_changetimestamp BEFORE UPDATE
ON request FOR EACH ROW EXECUTE PROCEDURE 
update_changetimestamp_column();

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE request to app_api_704fkrus;
GRANT USAGE, SELECT ON SEQUENCE request_id_seq TO app_api_704fkrus;

END TRANSACTION;
