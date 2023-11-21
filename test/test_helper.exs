Mimic.copy(HTTPoison)
ExUnit.start()
Faker.start()
HTTPMock.State.Supervisor.start_link([Swapex.Mock.State])
