From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 3/5] cifs-utils: convert setcifsacl to use the plugin interface
Date: Tue, 18 Dec 2012 09:10:46 -0500
Message-ID: <1355839848-24118-4-git-send-email-jlayton@samba.org>
References: <1355839848-24118-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355839848-24118-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add str_to_sid() functionality to the plugin API and have setcifsacl
use it.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    |  5 ++---
 cifsidmap.h    | 23 ++++++++++++++++---
 idmap_plugin.c | 12 ++++++++++
 idmap_plugin.h |  3 +++
 idmapwb.c      | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 setcifsacl.c   | 70 +++++++++++++---------------------------------------------
 6 files changed, 115 insertions(+), 61 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index bc5e517..acace9c 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -62,9 +62,8 @@ getcifsacl_LDADD = -ldl
 man_MANS += getcifsacl.1
 
 bin_PROGRAMS += setcifsacl
-setcifsacl_SOURCES = setcifsacl.c
-setcifsacl_LDADD = $(WBCLIENT_LIBS)
-setcifsacl_CFLAGS = $(WBCLIENT_CFLAGS)
+setcifsacl_SOURCES = setcifsacl.c idmap_plugin.c
+setcifsacl_LDADD = -ldl
 man_MANS += setcifsacl.1
 endif
 
diff --git a/cifsidmap.h b/cifsidmap.h
index c307333..f82e990 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -71,12 +71,29 @@ struct cifs_sid {
  * @name   - return pointer for the name
  *
  * This function should convert the given cifs_sid to a string
- * representation in a heap-allocated buffer. The caller of this
- * function is expected to free "name" on success. Returns 0 on
- * success and non-zero on error.
+ * representation or mapped name in a heap-allocated buffer. The caller
+ * of this function is expected to free "name" on success. Returns 0 on
+ * success and non-zero on error. On error, the errmsg pointer passed
+ * in to the init_plugin function should point to an error string.
  *
  * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
  * 				char **name);
  */
 
+/**
+ * cifs_idmap_str_to_sid - convert string to struct cifs_sid
+ * @handle - context handle
+ * @name   - pointer to name string to be converted
+ * @sid    - pointer to struct cifs_sid where result should go
+ *
+ * This function converts a name string or string representation of
+ * a SID to a struct cifs_sid. The cifs_sid should already be
+ * allocated. Returns 0 on success and non-zero on error. On error, the
+ * plugin should reset the errmsg pointer passed to the init_plugin
+ * function to an error string.
+ *
+ * int cifs_idmap_str_to_sid(void *handle, const char *name,
+ * 				struct cifs_sid *sid);
+ */
+
 #endif /* _CIFSIDMAP_H */
diff --git a/idmap_plugin.c b/idmap_plugin.c
index 4dbeca7..bef4e93 100644
--- a/idmap_plugin.c
+++ b/idmap_plugin.c
@@ -97,3 +97,15 @@ sid_to_str(void *handle, const struct cifs_sid *sid, char **name)
 
 	return (*entry)(handle, sid, name);
 }
+
+int
+str_to_sid(void *handle, const char *name, struct cifs_sid *sid)
+{
+	int (*entry)(void *, const char *, struct cifs_sid *);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_str_to_sid");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, name, sid);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
index 277bb12..51e3a76 100644
--- a/idmap_plugin.h
+++ b/idmap_plugin.h
@@ -43,4 +43,7 @@ extern void exit_plugin(void *handle);
 /* Convert cifs_sid to a string. Caller must free *name on success */
 extern int sid_to_str(void *handle, const struct cifs_sid *sid, char **name);
 
+/* Convert string to cifs_sid. */
+extern int str_to_sid(void *handle, const char *name, struct cifs_sid *csid);
+
 #endif /* _IDMAP_PLUGIN_H */
diff --git a/idmapwb.c b/idmapwb.c
index 858028f..aa53150 100644
--- a/idmapwb.c
+++ b/idmapwb.c
@@ -52,6 +52,25 @@ csid_to_wsid(struct wbcDomainSid *wsid, const struct cifs_sid *csid)
 		wsid->sub_auths[i] = le32toh(csid->sub_auth[i]);
 }
 
+/*
+ * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
+ * wsid to the csid, while converting the subauthority fields to LE.
+ */
+static void
+wsid_to_csid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
+{
+	int i;
+	uint8_t num_subauth = (wsid->num_auths <= SID_MAX_SUB_AUTHORITIES) ?
+				wsid->num_auths : SID_MAX_SUB_AUTHORITIES;
+
+	csid->revision = wsid->sid_rev_num;
+	csid->num_subauth = num_subauth;
+	for (i = 0; i < NUM_AUTHS; i++)
+		csid->authority[i] = wsid->id_auth[i];
+	for (i = 0; i < num_subauth; i++)
+		csid->sub_auth[i] = htole32(wsid->sub_auths[i]);
+}
+
 int
 cifs_idmap_sid_to_str(void *handle __attribute__ ((unused)),
 			const struct cifs_sid *csid, char **string)
@@ -97,6 +116,50 @@ out:
 	return rc;
 }
 
+int
+cifs_idmap_str_to_sid(void *handle __attribute__ ((unused)),
+			const char *orig, struct cifs_sid *csid)
+{
+	wbcErr wbcrc;
+	char *name, *domain, *sidstr;
+	enum wbcSidType type;
+	struct wbcDomainSid wsid;
+
+	sidstr = strdup(orig);
+	if (!sidstr) {
+		*plugin_errmsg = "Unable to copy string";
+		return -ENOMEM;
+	}
+
+	name = strchr(sidstr, '\\');
+	if (!name) {
+		/* might be a raw string representation of SID */
+		wbcrc = wbcStringToSid(sidstr, &wsid);
+		if (WBC_ERROR_IS_OK(wbcrc))
+			goto convert_sid;
+
+		domain = "";
+		name = sidstr;
+	} else {
+		domain = sidstr;
+		*name = '\0';
+		++name;
+	}
+
+	wbcrc = wbcLookupName(domain, name, &wsid, &type);
+	/* FIXME: map these to better POSIX error codes? */
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		free(sidstr);
+		return -EIO;
+	}
+
+convert_sid:
+	wsid_to_csid(csid, &wsid);
+	free(sidstr);
+	return 0;
+}
+
 /*
  * For the winbind plugin, we don't need to do anything special on
  * init or exit
diff --git a/setcifsacl.c b/setcifsacl.c
index e8c10a9..211c1af 100644
--- a/setcifsacl.c
+++ b/setcifsacl.c
@@ -33,10 +33,11 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <limits.h>
-#include <wbclient.h>
 #include <ctype.h>
 #include <sys/xattr.h>
+
 #include "cifsacl.h"
+#include "idmap_plugin.h"
 
 enum setcifsacl_actions {
 	ActUnknown = -1,
@@ -46,6 +47,8 @@ enum setcifsacl_actions {
 	ActSet
 };
 
+static void *plugin_handle;
+
 static void
 copy_cifs_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 {
@@ -376,58 +379,6 @@ build_fetched_aces_err:
 	return NULL;
 }
 
-/*
- * Winbind keeps wbcDomainSid fields in host-endian. Copy fields from the
- * wsid to the csid, while converting the subauthority fields to LE.
- */
-static void
-wsid_to_csid(struct cifs_sid *csid, struct wbcDomainSid *wsid)
-{
-	int i;
-
-	csid->revision = wsid->sid_rev_num;
-	csid->num_subauth = wsid->num_auths;
-	for (i = 0; i < NUM_AUTHS; i++)
-		csid->authority[i] = wsid->id_auth[i];
-	for (i = 0; i < wsid->num_auths; i++)
-		csid->sub_auth[i] = htole32(wsid->sub_auths[i]);
-}
-
-static int
-verify_ace_sid(char *sidstr, struct cifs_sid *csid)
-{
-	wbcErr rc;
-	char *name, *domain;
-	enum wbcSidType type;
-	struct wbcDomainSid wsid;
-
-	name = strchr(sidstr, '\\');
-	if (!name) {
-		/* might be a raw string representation of SID */
-		rc = wbcStringToSid(sidstr, &wsid);
-		if (WBC_ERROR_IS_OK(rc))
-			goto convert_sid;
-
-		domain = "";
-		name = sidstr;
-	} else {
-		domain = sidstr;
-		*name = '\0';
-		++name;
-	}
-
-	rc = wbcLookupName(domain, name, &wsid, &type);
-	if (!WBC_ERROR_IS_OK(rc)) {
-		printf("%s: Error converting %s\\%s to SID: %s\n",
-			__func__, domain, name, wbcErrorString(rc));
-		return rc;
-	}
-
-convert_sid:
-	wsid_to_csid(csid, &wsid);
-	return 0;
-}
-
 static int
 verify_ace_type(char *typestr, uint8_t *typeval)
 {
@@ -612,8 +563,9 @@ build_cmdline_aces(char **arrptr, int numcaces)
 			goto build_cmdline_aces_ret;
 		}
 
-		if (verify_ace_sid(acesid, &cacesptr[i]->sid)) {
-			printf("%s: Invalid SID: %s\n", __func__, arrptr[i]);
+		if (str_to_sid(plugin_handle, acesid, &cacesptr[i]->sid)) {
+			printf("%s: Invalid SID (%s): %s\n", __func__, arrptr[i],
+				plugin_errmsg);
 			goto build_cmdline_aces_ret;
 		}
 
@@ -809,6 +761,12 @@ main(const int argc, char *const argv[])
 		return -1;
 	}
 
+	if (init_plugin(&plugin_handle)) {
+		printf("ERROR: unable to initialize idmapping plugin: %s\n",
+			plugin_errmsg);
+		return -1;
+	}
+
 	numcaces = get_numcaces(ace_list);
 
 	arrptr = parse_cmdline_aces(ace_list, numcaces);
@@ -865,6 +823,7 @@ cifsacl:
 		printf("%s: setxattr error: %s\n", __func__, strerror(errno));
 	goto setcifsacl_facenum_ret;
 
+	exit_plugin(plugin_handle);
 	return 0;
 
 setcifsacl_action_ret:
@@ -887,5 +846,6 @@ setcifsacl_cmdlineparse_ret:
 	free(arrptr);
 
 setcifsacl_numcaces_ret:
+	exit_plugin(plugin_handle);
 	return -1;
 }
-- 
1.7.11.7
