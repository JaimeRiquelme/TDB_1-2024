package org.tbd.fifth.group.volunteer.models;

public class TypeUserModel {
    private int type_user_id;

    private String name;

    private boolean CRUD_emergencies;

    private boolean CRUD_tasks;

    private boolean CRUD_tasks_states;

    private boolean assign_volunteers;


    public TypeUserModel(int type_user_id, String name, boolean CRUD_emergencies, boolean CRUD_tasks, boolean CRUD_tasks_states, boolean assign_volunteers) {
        this.type_user_id = type_user_id;
        this.name = name;
        this.CRUD_emergencies = CRUD_emergencies;
        this.CRUD_tasks = CRUD_tasks;
        this.CRUD_tasks_states = CRUD_tasks_states;
        this.assign_volunteers = assign_volunteers;
    }

    public int getType_user_id() {
        return type_user_id;
    }

    public void setType_user_id(int type_user_id) {
        this.type_user_id = type_user_id;
    }

    public String getType_user_name() {
        return name;
    }

    public void setType_user_name(String type_user_name) {
        this.name = type_user_name;
    }

    public boolean isCRUD_emergencies() {
        return CRUD_emergencies;
    }

    public void setCRUD_emergencies(boolean CRUD_emergencies) {
        this.CRUD_emergencies = CRUD_emergencies;
    }

    public boolean isCRUD_tasks() {
        return CRUD_tasks;
    }

    public void setCRUD_tasks(boolean CRUD_tasks) {
        this.CRUD_tasks = CRUD_tasks;
    }

    public boolean isCRUD_tasks_states() {
        return CRUD_tasks_states;
    }

    public void setCRUD_tasks_states(boolean CRUD_tasks_states) {
        this.CRUD_tasks_states = CRUD_tasks_states;
    }

    public boolean isAsign_volunteers() {
        return assign_volunteers;
    }

    public void setAsign_volunteers(boolean asign_volunteers) {
        this.assign_volunteers = asign_volunteers;
    }
}
