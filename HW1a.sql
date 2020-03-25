%%sql

-- drop all tables in order of their dependencies
DROP TABLE IF EXISTS cVote;
DROP TABLE IF EXISTS qVote;
DROP TABLE IF EXISTS aVote;
DROP TABLE IF EXISTS vote;
DROP TABLE IF EXISTS qComment;
DROP TABLE IF EXISTS aComment;
DROP TABLE IF EXISTS comment;
DROP TABLE IF EXISTS stepByStepA;
DROP TABLE IF EXISTS externalA;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS question;
DROP TABLE IF EXISTS users;

-- create tables storing users, questions, answers, commentsvabd vote
CREATE TABLE users (username varchar(255) PRIMARY KEY, 
                    karma INTEGER);

CREATE TABLE question (qid SERIAL PRIMARY KEY, 
                       askedBy VARCHAR(255) NOT NULL,
                       category VARCHAR(255),
                       text VARCHAR(1023) NOT NULL,
                       FOREIGN KEY (askedBy) REFERENCES users(username));

CREATE TABLE answer (aid SERIAL PRIMARY KEY, 
                     givenBy VARCHAR(255) NOT NULL, 
                     answersQ INTEGER NOT NULL,
                     text VARCHAR(1023) NOT NULL,
                     FOREIGN KEY (givenBy) REFERENCES users(username),
                     FOREIGN KEY (answersQ) REFERENCES question(qid));
CREATE TABLE stepByStepA (aid INTEGER UNIQUE NOT NULL,
                          FOREIGN KEY (aid) REFERENCES answer(aid));
CREATE TABLE externalA (aid INTEGER UNIQUE NOT NULL, 
                        comment VARCHAR(255), 
                        link VARCHAR(255),
                        FOREIGN KEY (aid) REFERENCES answer(aid));

CREATE TABLE comment (cid SERIAL PRIMARY KEY,
                      byUser VARCHAR(255) NOT NULL,
                      text VARCHAR(1023) NOT NULL,
                      FOREIGN KEY (byUser) REFERENCES users(username));
CREATE TABLE qComment (cid INTEGER UNIQUE NOT NULL,
                       forQ INTEGER NOT NULL,
                       FOREIGN KEY (cid) REFERENCES comment(cid),
                       FOREIGN KEY (forQ) REFERENCES question(qid) ON DELETE CASCADE);
CREATE TABLE aComment (cid INTEGER UNIQUE NOT NULL,
                       forA INTEGER NOT NULL,
                       FOREIGN KEY(cid) REFERENCES comment,
                       FOREIGN KEY (forA) REFERENCES answer(aid) ON DELETE CASCADE);

CREATE TABLE vote (vid SERIAL PRIMARY KEY, 
                   by  VARCHAR(255) NOT NULL, 
                   upVote BOOLEAN NOT NULL,
                   FOREIGN KEY (by) REFERENCES users(username)); 
CREATE TABLE cVote (vid INTEGER UNIQUE NOT NULL, 
                    cid INTEGER NOT NULL,
                    FOREIGN KEY (vid) REFERENCES vote(vid),
                    FOREIGN KEY (cid) REFERENCES comment(cid));
CREATE TABLE qVote (vid INTEGER UNIQUE NOT NULL, 
                    qid INTEGER NOT NULL,
                    FOREIGN KEY (vid) REFERENCES vote(vid),
                    FOREIGN KEY (qid) REFERENCES question(qid));
CREATE TABLE aVote (vid INTEGER UNIQUE NOT NULL, 
                    aid INTEGER NOT NULL,
                    FOREIGN KEY (vid) REFERENCES vote(vid),
                    FOREIGN KEY (aid) REFERENCES answer(aid));

-------------------------------------------------------
-- insert users
INSERT INTO users VALUES ('alice', 100);
INSERT INTO users VALUES ('mirza', 50);
INSERT INTO users VALUES ('max', 50);

-- insert questions
INSERT INTO question VALUES (1, 'max', 'Hygiene', 'How do I wash my hands?');
INSERT INTO question VALUES (2, 'mirza', 'Habit', 'Do I need to stay home?');

-- insert answers
INSERT INTO answer VALUES (1, 'alice', 1, 'Use soap and water.');

INSERT INTO answer VALUES (2, 'alice', 2, 'Yes, as this website says');
INSERT INTO externalA VALUES (2, 'Link to government website', 'https://www.sozialministerium.at');

-- insert comments
INSERT INTO comment VALUES (1, 'alice', 'You dont know that?');
INSERT INTO qComment VALUES (1, 1);

INSERT INTO comment VALUES (2, 'mirza', 'Great answer!');
INSERT INTO aComment VALUES (2, 1);

INSERT INTO comment VALUES (3, 'mirza', 'Thank you');
INSERT INTO aComment VALUES (3, 2);

-- insert votes
INSERT INTO vote VALUES (1, 'alice', FALSE);
INSERT INTO qVote VALUES (1, 1);

INSERT INTO vote VALUES (2, 'mirza', TRUE);
INSERT INTO aVote VALUES (2, 1);

INSERT INTO vote VALUES (3, 'max', TRUE);
INSERT INTO cVote VALUES (3, 3);

INSERT INTO vote VALUES (4, 'alice', TRUE);
INSERT INTO cVote VALUES (4, 3);