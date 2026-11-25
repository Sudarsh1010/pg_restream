create table restream_streams (
  stream_id text PRIMARY KEY,
  next_position bigint NOT NULL default 1 CHECK (next_position > 0)
);

create table restream_chunks (
  stream_id text references restream_streams(stream_id),
  position bigint NOT NULL CHECK (position > 0),
  payload text NOT NULL,

  PRIMARY KEY (stream_id, position)
);
