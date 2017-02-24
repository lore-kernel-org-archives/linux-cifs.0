From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 6/8] data_blob: Eliminate _PUBLIC_
Date: Fri, 24 Feb 2017 09:27:48 -0500
Message-ID: <20170224142750.4151-7-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's defined to nothing anyway.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 data_blob.c |  6 +++---
 data_blob.h | 10 +++-------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/data_blob.c b/data_blob.c
index a884f132bcde..07e54e2c2bcd 100644
--- a/data_blob.c
+++ b/data_blob.c
@@ -37,7 +37,7 @@ const DATA_BLOB data_blob_null = { NULL, 0 };
  construct a data blob, must be freed with data_blob_free()
  you can pass NULL for p and get a blank data blob
 **/
-_PUBLIC_ DATA_BLOB data_blob_named(const void *p, size_t length, const char *name)
+DATA_BLOB data_blob_named(const void *p, size_t length, const char *name)
 {
 	DATA_BLOB ret;
 
@@ -63,7 +63,7 @@ _PUBLIC_ DATA_BLOB data_blob_named(const void *p, size_t length, const char *nam
 /**
  construct a data blob, using supplied TALLOC_CTX
 **/
-_PUBLIC_ DATA_BLOB data_blob_talloc_named(TALLOC_CTX *mem_ctx, const void *p, size_t length, const char *name)
+DATA_BLOB data_blob_talloc_named(TALLOC_CTX *mem_ctx, const void *p, size_t length, const char *name)
 {
 	DATA_BLOB ret = data_blob_named(p, length, name);
 
@@ -76,7 +76,7 @@ _PUBLIC_ DATA_BLOB data_blob_talloc_named(TALLOC_CTX *mem_ctx, const void *p, si
 /**
 free a data blob
 **/
-_PUBLIC_ void data_blob_free(DATA_BLOB *d)
+void data_blob_free(DATA_BLOB *d)
 {
 	if (d) {
 		talloc_free(d->data);
diff --git a/data_blob.h b/data_blob.h
index ccdf30d110af..3d961475e9ff 100644
--- a/data_blob.h
+++ b/data_blob.h
@@ -23,10 +23,6 @@
 #ifndef _SAMBA_DATABLOB_H_
 #define _SAMBA_DATABLOB_H_
 
-#ifndef _PUBLIC_
-#define _PUBLIC_
-#endif
-
 #include <talloc.h>
 #include <stdint.h>
 
@@ -53,17 +49,17 @@ struct data_blob_list_item {
  construct a data blob, must be freed with data_blob_free()
  you can pass NULL for p and get a blank data blob
 **/
-_PUBLIC_ DATA_BLOB data_blob_named(const void *p, size_t length, const char *name);
+DATA_BLOB data_blob_named(const void *p, size_t length, const char *name);
 
 /**
  construct a data blob, using supplied TALLOC_CTX
 **/
-_PUBLIC_ DATA_BLOB data_blob_talloc_named(TALLOC_CTX *mem_ctx, const void *p, size_t length, const char *name);
+DATA_BLOB data_blob_talloc_named(TALLOC_CTX *mem_ctx, const void *p, size_t length, const char *name);
 
 /**
 free a data blob
 **/
-_PUBLIC_ void data_blob_free(DATA_BLOB *d);
+void data_blob_free(DATA_BLOB *d);
 
 extern const DATA_BLOB data_blob_null;
 
-- 
2.9.3
