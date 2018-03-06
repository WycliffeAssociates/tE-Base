#!/bin/bash
docker run -it --rm \
    -v postgres_data:/volume  \
    -v $(pwd)/postgres_data:/backup \
    alpine \
    sh -c "rm -rf /volume/* /volume/..?* /volume/.[!.]* ; \
    tar -C /volume/ -xjf /backup/postgres_data-amd64.tar.bz2"
