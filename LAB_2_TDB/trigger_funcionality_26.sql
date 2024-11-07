CREATE OR REPLACE FUNCTION register_log_eme()
RETURNS TRIGGER AS $$
DECLARE
    description TEXT;
	currentDate DATE;
	currentTime TIME;
    coordinator_id_h INTEGER;
    emergency_id_h INTEGER;
BEGIN
    --Obtain time and date
    currentDate := CURRENT_DATE;
    currentTime := CURRENT_TIME;
    -- Writing of description of log
    IF TG_OP = 'INSERT' THEN
        description := 'Emergency created';
        coordinator_id_h := NEW.coordinator_id;
        emergency_id_h := NEW.emergency_id;
    ELSIF TG_OP = 'UPDATE' THEN
		coordinator_id_h := NEW.coordinator_id;
        emergency_id_h := NEW.emergency_id;
		IF NEW.emergency_state = 'In progress' THEN
			description := 'Emergency Started';
		ELSIF NEW.emergency_state = 'Canceled' THEN
			description := 'Emergency Canceled';
		ELSIF NEW.emergency_state = 'Finished' THEN
			description := 'Emergency Finished';
		ELSE
			description := 'WRONG CODE';
        
		END IF;
    ELSE
        description := 'Emergency Deleted';
        coordinator_id_h := OLD.coordinator_id;
        emergency_id_h := OLD.emergency_id;
        INSERT INTO Emergency_log (coordinator_id, emergency_id, description, date_change, hour_change)
        VALUES (coordinator_id_h, emergency_id_h, description, currentDate, currentTime);
        RETURN OLD;
    END IF;

    INSERT INTO Emergency_log (coordinator_id, emergency_id, description, date_change, hour_change)
    VALUES (coordinator_id_h, emergency_id_h, description, currentDate, currentTime);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emergency_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON Emergency
FOR EACH ROW
EXECUTE FUNCTION register_log_eme();

CREATE OR REPLACE FUNCTION register_log_task()
RETURNS TRIGGER AS $$
DECLARE
    description TEXT;
	currentDate DATE;
	currentTime TIME;
    coordinator_id_h INTEGER;
    task_id_h INTEGER;
BEGIN
    IF (SELECT u.type_user_id FROM Userm u WHERE u.user_id = NEW.user_id) = 0 THEN
        --Obtain time and date
        currentDate := CURRENT_DATE;
        currentTime := CURRENT_TIME;
        -- Writing of description of log
		SELECT c.coordinator_id INTO coordinator_id_h FROM Coordinator c WHERE c.user_id = NEW.user_id;
        SELECT t.task_id INTO task_id_h FROM Task t WHERE t.task_state_id = NEW.task_state_id;
		IF NEW.state = 'In progress' THEN
			description := 'Task Started';
		ELSIF NEW.state = 'Finished' THEN
			description := 'Task Finished';
		ELSE
			description := 'WRONG CODE';
        END IF;
        INSERT INTO Task_log (coordinator_id, task_id, description, date_change, hour_change)
        VALUES (coordinator_id_h, task_id_h, description, currentDate, currentTime);

        RETURN NEW;
    ELSE
        RETURN NEW;
    END IF;
    
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task_log_trigger
AFTER UPDATE ON Task_state
FOR EACH ROW
EXECUTE FUNCTION register_log_task();

CREATE OR REPLACE FUNCTION register_create_log_task()
RETURNS TRIGGER AS $$
DECLARE
    description TEXT;
	currentDate DATE;
	currentTime TIME;
    coordinator_id_h INTEGER;
    task_id_h INTEGER;
BEGIN
    --Obtain time and date
    currentDate := CURRENT_DATE;
    currentTime := CURRENT_TIME;
    -- Writing of description of log
    task_id_h := NEW.task_id;
	SELECT c.coordinator_id INTO coordinator_id_h FROM Task_state ts, Coordinator c WHERE ts.task_state_id = NEW.task_state_id AND ts.user_id = c.user_id;
	description := 'Task Created';
    INSERT INTO Task_log (coordinator_id, task_id, description, date_change, hour_change)
    VALUES (coordinator_id_h, task_id_h, description, currentDate, currentTime);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER task_create_log_trigger
AFTER INSERT ON Task
FOR EACH ROW
EXECUTE FUNCTION register_create_log_task();