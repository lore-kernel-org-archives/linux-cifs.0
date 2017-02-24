From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 3/8] cifs.upcall: remove need for replace.h
Date: Fri, 24 Feb 2017 09:27:45 -0500
Message-ID: <20170224142750.4151-4-jlayton@samba.org>
References: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224142750.4151-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Take just what we need from replace.h and move it to cifs.upcall.c.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c | 22 +++++++++++++++++++---
 1 file changed, 19 insertions(+), 3 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index f766a8b5799e..cfc926cd9d09 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -49,8 +49,9 @@
 #include <ctype.h>
 #include <pwd.h>
 #include <grp.h>
+#include <stdbool.h>
+#include <errno.h>
 
-#include "replace.h"
 #include "data_blob.h"
 #include "spnego.h"
 #include "cifs_spnego.h"
@@ -68,6 +69,21 @@ typedef enum _sectype {
 	MS_KRB5
 } sectype_t;
 
+/* These macros unify the keyblock handling of Heimdal and MIT somewhat */
+#ifdef HAVE_KRB5_KEYBLOCK_KEYVALUE /* Heimdal */
+#define KRB5_KEY_TYPE(k)        ((k)->keytype)
+#define KRB5_KEY_LENGTH(k)      ((k)->keyvalue.length)
+#define KRB5_KEY_DATA(k)        ((k)->keyvalue.data)
+#define KRB5_KEY_DATA_CAST      void
+#else /* MIT */
+#define KRB5_KEY_TYPE(k)        ((k)->enctype)
+#define KRB5_KEY_LENGTH(k)      ((k)->length)
+#define KRB5_KEY_DATA(k)        ((k)->contents)
+#define KRB5_KEY_DATA_CAST      krb5_octet
+#endif
+
+#define SAFE_FREE(x) do { if ((x) != NULL) {free(x); x = NULL; } } while (0)
+
 #ifdef HAVE_LIBCAP_NG
 static int
 trim_capabilities(bool need_environ)
@@ -434,7 +450,7 @@ cifs_krb5_get_req(const char *host, krb5_ccache ccache,
 	krb5_data apreq_pkt, in_data;
 	krb5_auth_context auth_context = NULL;
 #if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
-	static const uint8_t gss_cksum[24] = { 0x10, 0x00, /* ... */};
+	static char gss_cksum[24] = { 0x10, 0x00, /* ... */};
 #endif
 	memset(&in_creds, 0, sizeof(in_creds));
 
@@ -498,7 +514,7 @@ cifs_krb5_get_req(const char *host, krb5_ccache ccache,
 	 *
 	 * See https://bugzilla.samba.org/show_bug.cgi?id=7890
 	 */
-	in_data.data = discard_const_p(char, gss_cksum);
+	in_data.data = gss_cksum;
 	in_data.length = 24;
 
 	/* MIT krb5 < 1.7 is missing the prototype, but still has the symbol */
-- 
2.9.3
