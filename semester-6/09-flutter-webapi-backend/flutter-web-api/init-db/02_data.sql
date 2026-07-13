--
-- PostgreSQL database dump
--

\restrict T1lLUpvnsy66rfwNFq7RNfRXv2JBxw9CkhiZgD3FcNzcXkYVgOehUWfcWq7m0br

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
--SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.products VALUES (3, 'MacBook Air M5', 120000.00, 0, 'https://lmt-web.mstatic.lv/eshop/41156/1-macbook-air-13-m5-midnight.png');
INSERT INTO public.products VALUES (4, 'PlayStation 2', 1000000.00, 4, 'https://m.media-amazon.com/images/I/515Ceao0c3L.jpg');
INSERT INTO public.products VALUES (6, 'GameBoy Advance SP', 20000.00, 7, 'https://m.media-amazon.com/images/I/41ZYrAnQubL._AC_UF1000,1000_QL80_.jpg');
INSERT INTO public.products VALUES (5, 'Google Pixel', 15000.00, 10, 'https://www.euronics.lv/UserFiles/Products/Images/427911-644711-medium.jpg');
INSERT INTO public.products VALUES (2, 'iPhone 17 Pro Max', 65000.00, 5, 'https://static.insales-cdn.com/images/products/1/321/2440143169/28326.970.jpg');
INSERT INTO public.products VALUES (1, 'iPhone 17', 12000.00, 1, 'https://www.phonedo.ru/wp-content/uploads/2025/09/83.jpg');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.users VALUES (7, 'archi', 'blo123456');
INSERT INTO public.users VALUES (2, 'wait a minute', 'Archibald');


--
-- Data for Name: cartitems; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.cartitems VALUES (18, 1, 2, 2);
INSERT INTO public.cartitems VALUES (13, 4, 7, 1);
INSERT INTO public.cartitems VALUES (14, 3, 7, 2);
INSERT INTO public.cartitems VALUES (15, 6, 7, 8);


--
-- Name: cartitems_id_cartitem_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cartitems_id_cartitem_seq', 18, true);


--
-- Name: products_id_product_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.products_id_product_seq', 6, true);


--
-- Name: users_id_user_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_user_seq', 7, true);


--
-- PostgreSQL database dump complete
--

\unrestrict T1lLUpvnsy66rfwNFq7RNfRXv2JBxw9CkhiZgD3FcNzcXkYVgOehUWfcWq7m0br

