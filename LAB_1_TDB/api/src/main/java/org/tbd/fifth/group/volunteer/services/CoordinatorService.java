package org.tbd.fifth.group.volunteer.services;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Repository;
import org.sql2o.Connection;
import org.sql2o.Sql2o;
import org.tbd.fifth.group.volunteer.models.CoordinatorModel;
import org.tbd.fifth.group.volunteer.repositories.CoordinatorRepository;

@Repository
public class CoordinatorService implements CoordinatorRepository {

    @Autowired
    private Sql2o sql2o;

    @Override
    // coordinator_id, institution_id, user_id
    public CoordinatorModel createCoordinator(CoordinatorModel coordinator){
        try(Connection connection = sql2o.open()){
            connection.createQuery("INSERT INTO \"coordinator\" (institution_id, user_id) VALUES (:institution_id, :user_id)", true)
                    .addParameter("institution_id", coordinator.getInstitution_id())
                    .addParameter("user_id", coordinator.getUser_id())
                    .executeUpdate().getKey();
            return coordinator;
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }


    @Override
    public CoordinatorModel getCoordinator(int coordinator_id){
        try(Connection connection = sql2o.open()){
            return connection.createQuery("SELECT * FROM \"coordinator\" WHERE coordinator_id = :coordinator_id")
                    .addParameter("coordinator_id", coordinator_id)
                    .executeAndFetchFirst(CoordinatorModel.class);
        }catch(Exception e){
            System.out.println(e.getMessage());
            return null;
        }
    }


    /*SELECT coordinator_id
FROM Coordinator
WHERE user_id = 10;
*/

    @Override
    public ResponseEntity<Integer> getId_Coordinator(int user_id) {
        try (Connection connection = sql2o.open()) {
            Integer coordinator_id = connection.createQuery("SELECT coordinator_id FROM \"coordinator\" WHERE user_id = :user_id")
                    .addParameter("user_id", user_id)
                    .executeScalar(Integer.class);
            if (coordinator_id != null) {
                return ResponseEntity.ok(coordinator_id);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
            return ResponseEntity.status(500).build();
        }
    }
}
