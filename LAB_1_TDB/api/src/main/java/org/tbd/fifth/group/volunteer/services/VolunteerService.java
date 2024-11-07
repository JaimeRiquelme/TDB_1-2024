package org.tbd.fifth.group.volunteer.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.tbd.fifth.group.volunteer.models.VolunteerModel;
import org.tbd.fifth.group.volunteer.repositories.VolunteerRepository;
import org.sql2o.Connection;
import org.sql2o.Sql2o;

import java.util.List;

@Repository
public class VolunteerService implements VolunteerRepository {

    @Autowired
    private Sql2o sql2o;

    @Override
    // volunteer_id, disponibility, user_id
    public VolunteerModel createVolunteer(VolunteerModel volunteer){
        try(Connection connection = sql2o.open()){
            connection.createQuery("INSERT INTO \"volunteer\" ( disponibility, user_id)"+
                    " VALUES (:disponibility, :user_id)")
                    .addParameter("disponibility", volunteer.isDisponibility())
                    .addParameter("user_id", volunteer.getUser_id())
                    .executeUpdate();

            return volunteer;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public VolunteerModel getVolunteer(int volunteer_id){
        try(Connection connection = sql2o.open()){
            return connection.createQuery("SELECT * FROM \"volunteer\" WHERE volunteer_id = :volunteer_id")
                    .addParameter("volunteer_id", volunteer_id)
                    .executeAndFetchFirst(VolunteerModel.class);
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public List<VolunteerModel> listVolunteers(){
        try(Connection connection = sql2o.open()){
            return connection.createQuery("SELECT * FROM \"volunteer\"")
                    .executeAndFetch(VolunteerModel.class);
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public VolunteerModel updateVolunteer(VolunteerModel volunteer){
        try(Connection connection = sql2o.open()){
            connection.createQuery("UPDATE \"volunteer\" SET disponibility = :disponibility, user_id = :user_id WHERE volunteer_id = :volunteer_id")
                    .addParameter("disponibility", volunteer.isDisponibility())
                    .addParameter("user_id", volunteer.getUser_id())
                    .addParameter("volunteer_id", volunteer.getVolunteer_id())
                    .executeUpdate();
            return volunteer;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }

    @Override
    public VolunteerModel deleteVolunteer(int volunteer_id){
        try(Connection connection = sql2o.open()){
            VolunteerModel volunteer = getVolunteer(volunteer_id);
            connection.createQuery("DELETE FROM \"volunteer\" WHERE volunteer_id = :volunteer_id")
                    .addParameter("volunteer_id", volunteer_id)
                    .executeUpdate();
            return volunteer;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }


    @Override
    public ResponseEntity<Integer> getVolunteerIdByUserId(int user_id) {
        try (Connection connection = sql2o.open()) {
            Integer volunteer_id = connection.createQuery("SELECT volunteer_id FROM \"volunteer\" WHERE user_id = :user_id")
                    .addParameter("user_id", user_id)
                    .executeScalar(Integer.class);
            if (volunteer_id != null) {
                return ResponseEntity.ok(volunteer_id);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(500).build();
        }
    }

}
