--
-- PostgreSQL database dump
--

\restrict Mss4LfYVlJUkWNHHWAFaax8Wg0UaAZmIbiLyMP6fm30f0KpjShPiVuyfhvNoC4I

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS myapp;
--
-- Name: myapp; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE myapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE myapp OWNER TO postgres;

\unrestrict Mss4LfYVlJUkWNHHWAFaax8Wg0UaAZmIbiLyMP6fm30f0KpjShPiVuyfhvNoC4I
\connect myapp
\restrict Mss4LfYVlJUkWNHHWAFaax8Wg0UaAZmIbiLyMP6fm30f0KpjShPiVuyfhvNoC4I

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: appuser
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$ BEGIN NEW.updated_at = now(); RETURN NEW; END; $$;


ALTER FUNCTION public.set_updated_at() OWNER TO appuser;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_categories; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.app_categories (
    app_id uuid NOT NULL,
    category_id uuid NOT NULL
);


ALTER TABLE public.app_categories OWNER TO appuser;

--
-- Name: app_tags; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.app_tags (
    app_id uuid NOT NULL,
    tag_id uuid NOT NULL
);


ALTER TABLE public.app_tags OWNER TO appuser;

--
-- Name: app_versions; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.app_versions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    app_id uuid NOT NULL,
    version text NOT NULL,
    changelog text,
    release_notes text,
    download_url text NOT NULL,
    file_size_bytes bigint,
    sha256 text,
    is_published boolean DEFAULT true NOT NULL,
    published_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT app_versions_file_size_bytes_check CHECK (((file_size_bytes IS NULL) OR (file_size_bytes >= 0)))
);


ALTER TABLE public.app_versions OWNER TO appuser;

--
-- Name: apps; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.apps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    owner_user_id uuid,
    name text NOT NULL,
    slug text NOT NULL,
    short_description text,
    description text,
    website_url text,
    support_url text,
    icon_url text,
    hero_image_url text,
    status text DEFAULT 'published'::text NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    average_rating numeric(3,2) DEFAULT 0 NOT NULL,
    rating_count integer DEFAULT 0 NOT NULL,
    download_count bigint DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT apps_download_count_check CHECK ((download_count >= 0)),
    CONSTRAINT apps_rating_count_check CHECK ((rating_count >= 0)),
    CONSTRAINT apps_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'unlisted'::text, 'suspended'::text])))
);


ALTER TABLE public.apps OWNER TO appuser;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.categories OWNER TO appuser;

--
-- Name: downloads; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.downloads (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    app_id uuid NOT NULL,
    app_version_id uuid,
    downloaded_at timestamp with time zone DEFAULT now() NOT NULL,
    ip inet,
    user_agent text,
    referrer text
);


ALTER TABLE public.downloads OWNER TO appuser;

--
-- Name: tags; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.tags (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tags OWNER TO appuser;

--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.user_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    last_used_at timestamp with time zone,
    revoked_at timestamp with time zone
);


ALTER TABLE public.user_sessions OWNER TO appuser;

--
-- Name: users; Type: TABLE; Schema: public; Owner: appuser
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    email text NOT NULL,
    password_hash text NOT NULL,
    display_name text,
    is_admin boolean DEFAULT false NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.users OWNER TO appuser;

--
-- Data for Name: app_categories; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.app_categories (app_id, category_id) FROM stdin;
3b356e5b-e20f-474c-9de4-7f123122f6a3	f0a61a76-a79c-4173-8a5d-ade6a65d9e01
d1f6f1cb-8bda-491b-a6f0-5984683130b1	f48bdcac-bce3-459b-98d5-9484b9d1c15b
\.


--
-- Data for Name: app_tags; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.app_tags (app_id, tag_id) FROM stdin;
3b356e5b-e20f-474c-9de4-7f123122f6a3	1c583fec-fca4-4c45-914a-5d974d605bc8
3b356e5b-e20f-474c-9de4-7f123122f6a3	5a123e52-0b47-4c85-aede-2b7b335c3d6f
d1f6f1cb-8bda-491b-a6f0-5984683130b1	6d0bae0d-ebe6-4b7d-82c2-58ff89439be2
\.


--
-- Data for Name: app_versions; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.app_versions (id, app_id, version, changelog, release_notes, download_url, file_size_bytes, sha256, is_published, published_at, created_at) FROM stdin;
2ee6f863-6dfd-4e02-a4e2-5f07d70f5165	3b356e5b-e20f-474c-9de4-7f123122f6a3	1.0.0	Initial release	\N	https://example.com/downloads/retro-notes-1.0.0.zip	\N	\N	t	2026-02-09 07:04:21.982477+00	2026-02-09 07:04:21.982477+00
e88ff05d-9103-4fd0-b3fe-b80b76af9fec	d1f6f1cb-8bda-491b-a6f0-5984683130b1	0.9.0	Beta release	\N	https://example.com/downloads/pixel-runner-0.9.0.zip	\N	\N	t	2026-02-09 07:04:25.296486+00	2026-02-09 07:04:25.296486+00
\.


--
-- Data for Name: apps; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.apps (id, owner_user_id, name, slug, short_description, description, website_url, support_url, icon_url, hero_image_url, status, is_featured, average_rating, rating_count, download_count, created_at, updated_at) FROM stdin;
3b356e5b-e20f-474c-9de4-7f123122f6a3	88d13f0a-9fea-4204-8c04-d6a2f9b82d63	Retro Notes	retro-notes	A tiny note app with retro vibes	Retro Notes is a lightweight note-taking app inspired by classic UI aesthetics.	https://example.com/retro-notes	\N	\N	\N	published	t	0.00	0	0	2026-02-09 07:03:58.82877+00	2026-02-09 07:03:58.82877+00
d1f6f1cb-8bda-491b-a6f0-5984683130b1	88d13f0a-9fea-4204-8c04-d6a2f9b82d63	Pixel Runner	pixel-runner	An endless runner in pixel art	Pixel Runner is a fast-paced endless runner game with crisp pixel graphics.	https://example.com/pixel-runner	\N	\N	\N	published	f	0.00	0	0	2026-02-09 07:04:02.635325+00	2026-02-09 07:04:02.635325+00
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.categories (id, name, slug, description, created_at) FROM stdin;
f0a61a76-a79c-4173-8a5d-ade6a65d9e01	Productivity	productivity	Tools that help you get things done	2026-02-09 07:03:38.011271+00
f48bdcac-bce3-459b-98d5-9484b9d1c15b	Games	games	Fun and casual games	2026-02-09 07:03:43.096591+00
9f8794b8-2563-4bbd-a478-2b9ad2123caf	Utilities	utilities	Handy utilities and system tools	2026-02-09 07:03:47.029189+00
\.


--
-- Data for Name: downloads; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.downloads (id, user_id, app_id, app_version_id, downloaded_at, ip, user_agent, referrer) FROM stdin;
e0642f43-5a85-4be8-b36f-9af31fc6f2b5	4fa3106f-3f82-4b6f-a6e2-e659d396921a	3b356e5b-e20f-474c-9de4-7f123122f6a3	2ee6f863-6dfd-4e02-a4e2-5f07d70f5165	2026-02-09 07:04:28.511944+00	127.0.0.1	seed-agent	seed
\.


--
-- Data for Name: tags; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.tags (id, name, slug, created_at) FROM stdin;
6d0bae0d-ebe6-4b7d-82c2-58ff89439be2	Open Source	open-source	2026-02-09 07:03:49.458459+00
5a123e52-0b47-4c85-aede-2b7b335c3d6f	Free	free	2026-02-09 07:03:51.619506+00
1c583fec-fca4-4c45-914a-5d974d605bc8	New	new	2026-02-09 07:03:55.033775+00
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.user_sessions (id, user_id, token_hash, created_at, expires_at, last_used_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: appuser
--

COPY public.users (id, email, password_hash, display_name, is_admin, is_active, created_at, updated_at) FROM stdin;
88d13f0a-9fea-4204-8c04-d6a2f9b82d63	admin@example.com	CHANGE_ME_BCRYPT_HASH	Admin	t	t	2026-02-09 07:03:29.732465+00	2026-02-09 07:03:29.732465+00
4fa3106f-3f82-4b6f-a6e2-e659d396921a	user@example.com	CHANGE_ME_BCRYPT_HASH	Demo User	f	t	2026-02-09 07:03:32.564044+00	2026-02-09 07:03:32.564044+00
\.


--
-- Name: app_categories app_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_categories
    ADD CONSTRAINT app_categories_pkey PRIMARY KEY (app_id, category_id);


--
-- Name: app_tags app_tags_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_tags
    ADD CONSTRAINT app_tags_pkey PRIMARY KEY (app_id, tag_id);


--
-- Name: app_versions app_versions_app_id_version_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_app_id_version_key UNIQUE (app_id, version);


--
-- Name: app_versions app_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_pkey PRIMARY KEY (id);


--
-- Name: apps apps_name_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_name_key UNIQUE (name);


--
-- Name: apps apps_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_pkey PRIMARY KEY (id);


--
-- Name: apps apps_slug_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_slug_key UNIQUE (slug);


--
-- Name: categories categories_name_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories categories_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: categories categories_slug_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT categories_slug_key UNIQUE (slug);


--
-- Name: downloads downloads_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_pkey PRIMARY KEY (id);


--
-- Name: tags tags_name_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_name_key UNIQUE (name);


--
-- Name: tags tags_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);


--
-- Name: tags tags_slug_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.tags
    ADD CONSTRAINT tags_slug_key UNIQUE (slug);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_token_hash_key UNIQUE (token_hash);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_app_versions_app_published; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_app_versions_app_published ON public.app_versions USING btree (app_id, is_published, published_at DESC);


--
-- Name: idx_apps_featured; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_apps_featured ON public.apps USING btree (is_featured) WHERE (is_featured = true);


--
-- Name: idx_apps_status; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_apps_status ON public.apps USING btree (status);


--
-- Name: idx_downloads_app_time; Type: INDEX; Schema: public; Owner: appuser
--

CREATE INDEX idx_downloads_app_time ON public.downloads USING btree (app_id, downloaded_at DESC);


--
-- Name: apps trg_apps_updated_at; Type: TRIGGER; Schema: public; Owner: appuser
--

CREATE TRIGGER trg_apps_updated_at BEFORE UPDATE ON public.apps FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: appuser
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: app_categories app_categories_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_categories
    ADD CONSTRAINT app_categories_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.apps(id) ON DELETE CASCADE;


--
-- Name: app_categories app_categories_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_categories
    ADD CONSTRAINT app_categories_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE RESTRICT;


--
-- Name: app_tags app_tags_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_tags
    ADD CONSTRAINT app_tags_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.apps(id) ON DELETE CASCADE;


--
-- Name: app_tags app_tags_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_tags
    ADD CONSTRAINT app_tags_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.tags(id) ON DELETE RESTRICT;


--
-- Name: app_versions app_versions_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.apps(id) ON DELETE CASCADE;


--
-- Name: apps apps_owner_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.apps
    ADD CONSTRAINT apps_owner_user_id_fkey FOREIGN KEY (owner_user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: downloads downloads_app_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_app_id_fkey FOREIGN KEY (app_id) REFERENCES public.apps(id) ON DELETE CASCADE;


--
-- Name: downloads downloads_app_version_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_app_version_id_fkey FOREIGN KEY (app_version_id) REFERENCES public.app_versions(id) ON DELETE SET NULL;


--
-- Name: downloads downloads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.downloads
    ADD CONSTRAINT downloads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_sessions user_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: appuser
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: DATABASE myapp; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE myapp TO appuser;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO appuser;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea) TO appuser;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO appuser;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.crypt(text, text) TO appuser;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.dearmor(text) TO appuser;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(bytea, text) TO appuser;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(text, text) TO appuser;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO appuser;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_uuid() TO appuser;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text) TO appuser;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO appuser;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO appuser;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TYPES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO appuser;


--
-- PostgreSQL database dump complete
--

\unrestrict Mss4LfYVlJUkWNHHWAFaax8Wg0UaAZmIbiLyMP6fm30f0KpjShPiVuyfhvNoC4I

