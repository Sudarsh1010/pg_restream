BEGIN;
INSERT INTO restream_streams (stream_id) VALUES ('job-a'), ('job-b')
    RETURNING stream_id, next_position;
INSERT INTO restream_chunks (stream_id, position, payload) VALUES
    ('job-a', 1, 'queued'), ('job-b', 1, 'started');
INSERT INTO restream_chunks (stream_id, position, payload) VALUES
    ('job-a', 1, 'duplicate');
ROLLBACK;
