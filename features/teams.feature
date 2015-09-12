Feature: Teams

  Scenario: You can view a team
    Given the BadCeleb League seeds have been run
    When I go to a team
    Then I should see that team's players

  Scenario: You can view a league's teams
    Given the BadCeleb League seeds have been run
    When I go to view that league's teams
    Then I should see all the league's teams

  Scenario: You can navigate to a team from the league's teams
    Given the BadCeleb League seeds have been run
    When I go to view that league's teams
    And I click on a team name
    Then I should be on the team show page

  Scenario: You can edit a team's roster
    Given the BadCeleb League seeds have been run
    When I go to a team
    And I edit that team
    And I setup a valid player change
    Then my team is updated

  Scenario: You see an error message when a team is updated incorrectly
    Given the BadCeleb League seeds have been run
    When I go to a team
    And I edit that team
    And I setup an invalid player change
    Then I see why the change was invalid
    And I see the invalid player change I had submitted

  Scenario: You can add a new player to your roster
    Given the BadCeleb League seeds have been run
    And there is an extra "Politician" in the league
    When I go to a team
    And I edit that team
    And I drop a "Politician"
    And I add that new player
    Then my team is updated
    And I should see that new player

  Scenario: Can see a roster history
    Given the BadCeleb League seeds have been run
    When I go to a team
    Then I should see that team's roster history
