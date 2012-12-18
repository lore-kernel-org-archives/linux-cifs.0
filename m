From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 4/5] cifs-utils: convert cifs.idmap to use plugin interface
Date: Tue, 18 Dec 2012 09:10:47 -0500
Message-ID: <1355839848-24118-5-git-send-email-jlayton@samba.org>
References: <1355839848-24118-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1355839848-24118-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add routines for the various things that cifs.idmap needs and have it
call them.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    |  5 ++--
 cifs.idmap.c   | 93 +++++++++++++++++++++++++---------------------------------
 cifsidmap.h    | 68 ++++++++++++++++++++++++++++++++++++++++--
 idmap_plugin.c | 49 +++++++++++++++++++++++++++++++
 idmap_plugin.h | 12 ++++++++
 idmapwb.c      | 64 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 232 insertions(+), 59 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index acace9c..8836b47 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -41,9 +41,8 @@ endif
 
 if CONFIG_CIFSIDMAP
 sbin_PROGRAMS += cifs.idmap
-cifs_idmap_SOURCES = cifs.idmap.c
-cifs_idmap_LDADD = -lkeyutils $(WBCLIENT_LIBS)
-cifs_idmap_CFLAGS = $(WBCLIENT_CFLAGS)
+cifs_idmap_SOURCES = cifs.idmap.c idmap_plugin.c
+cifs_idmap_LDADD = -lkeyutils -ldl
 man_MANS += cifs.idmap.8
 
 cifs.idmap.8: cifs.idmap.8.in
diff --git a/cifs.idmap.c b/cifs.idmap.c
index 792ea58..285d87f 100644
--- a/cifs.idmap.c
+++ b/cifs.idmap.c
@@ -40,9 +40,11 @@
 #include <stdlib.h>
 #include <errno.h>
 #include <limits.h>
-#include <wbclient.h>
 
 #include "cifsacl.h"
+#include "idmap_plugin.h"
+
+static void *plugin_handle;
 
 static const char *prog = "cifs.idmap";
 
@@ -101,31 +103,14 @@ str_to_uint(const char *src, unsigned int *dst)
 	return 0;
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
 static int
 cifs_idmap(const key_serial_t key, const char *key_descr)
 {
 	uid_t uid = 0;
 	gid_t gid = 0;;
-	wbcErr rc = 1;
+	int rc = 1;
 	char *sidstr = NULL;
-	struct wbcDomainSid sid;
+	struct cifs_sid sid;
 
 	/*
 	 * Use winbind to convert received string to a SID and lookup
@@ -137,15 +122,15 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 	 */
 	sidstr = strget(key_descr, "os:");
 	if (sidstr) {
-		rc = wbcStringToSid(sidstr, &sid);
+		rc = str_to_sid(plugin_handle, sidstr, &sid);
 		if (rc)
-			syslog(LOG_DEBUG, "Invalid owner string: %s, rc: %d",
-				key_descr, rc);
+			syslog(LOG_DEBUG, "Unable to convert owner string %s "
+				"to SID: %s", key_descr, plugin_errmsg);
 		else {
-			rc = wbcSidToUid(&sid, &uid);
+			rc = sid_to_uid(plugin_handle, &sid, &uid);
 			if (rc)
-				syslog(LOG_DEBUG, "SID %s to uid wbc error: %d",
-						key_descr, rc);
+				syslog(LOG_DEBUG, "Unable to convert %s to "
+					"UID: %s", key_descr, plugin_errmsg);
 		}
 		if (!rc) { /* SID has been mapped to an uid */
 			rc = keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
@@ -159,15 +144,15 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 
 	sidstr = strget(key_descr, "gs:");
 	if (sidstr) {
-		rc = wbcStringToSid(sidstr, &sid);
+		rc = str_to_sid(plugin_handle, sidstr, &sid);
 		if (rc)
-			syslog(LOG_DEBUG, "Invalid group string: %s, rc: %d",
-					key_descr, rc);
+			syslog(LOG_DEBUG, "Unable to convert group string %s "
+				"to SID: %s", key_descr, plugin_errmsg);
 		else {
-			rc = wbcSidToGid(&sid, &gid);
+			rc = sid_to_gid(plugin_handle, &sid, &gid);
 			if (rc)
-				syslog(LOG_DEBUG, "SID %s to gid wbc error: %d",
-						key_descr, rc);
+				syslog(LOG_DEBUG, "Unable to convert %s to "
+					"GID: %s", key_descr, plugin_errmsg);
 		}
 		if (!rc) { /* SID has been mapped to a gid */
 			rc = keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
@@ -189,15 +174,12 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		}
 
 		syslog(LOG_DEBUG, "SID: %s, uid: %u", sidstr, uid);
-		rc = wbcUidToSid(uid, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "uid %u to SID  error: %d", uid, rc);
-		if (!rc) {
-			struct cifs_sid csid;
-
-			/* SID has been mapped to a uid */
-			wsid_to_csid(&csid, &sid);
-			rc = keyctl_instantiate(key, &csid,
+		rc = uid_to_sid(plugin_handle, uid, &sid);
+		if (rc) {
+			syslog(LOG_DEBUG, "uid %u to SID error: %s", uid,
+				plugin_errmsg);
+		} else {
+			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct cifs_sid), 0);
 			if (rc)
 				syslog(LOG_ERR, "%s: key inst: %s",
@@ -217,15 +199,12 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 		}
 
 		syslog(LOG_DEBUG, "SID: %s, gid: %u", sidstr, gid);
-		rc = wbcGidToSid(gid, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "gid %u to SID error: %d", gid, rc);
-		if (!rc) {
-			struct cifs_sid csid;
-
-			/* SID has been mapped to a gid */
-			wsid_to_csid(&csid, &sid);
-			rc = keyctl_instantiate(key, &csid,
+		rc = gid_to_sid(plugin_handle, gid, &sid);
+		if (rc) {
+			syslog(LOG_DEBUG, "gid %u to SID error: %s", gid,
+				plugin_errmsg);
+		} else {
+			rc = keyctl_instantiate(key, &sid,
 					sizeof(struct cifs_sid), 0);
 			if (rc)
 				syslog(LOG_ERR, "%s: key inst: %s",
@@ -294,25 +273,33 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	if (init_plugin(&plugin_handle)) {
+		plugin_handle = NULL;
+		syslog(LOG_ERR, "Unable to initialize ID mapping plugin: %s",
+			plugin_errmsg);
+		goto out;
+	}
+
 	/* set timeout on key */
 	rc = keyctl_set_timeout(key, timeout);
 	if (rc == -1) {
 		syslog(LOG_ERR, "unable to set key timeout: %s",
 			strerror(errno));
-		goto out;
+		goto out_exit_plugin;
 	}
 
 	rc = keyctl_describe_alloc(key, &buf);
 	if (rc == -1) {
 		syslog(LOG_ERR, "keyctl_describe_alloc failed: %s",
 		       strerror(errno));
-		rc = 1;
-		goto out;
+		goto out_exit_plugin;
 	}
 
 	syslog(LOG_DEBUG, "key description: %s", buf);
 
 	rc = cifs_idmap(key, buf);
+out_exit_plugin:
+	exit_plugin(plugin_handle);
 out:
 	return rc;
 }
diff --git a/cifsidmap.h b/cifsidmap.h
index f82e990..c63d0da 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -34,7 +34,9 @@ struct cifs_sid {
 	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
 } __attribute__((packed));
 
-/* Plugins should implement the following functions: */
+/*
+ * Plugins should implement the following functions:
+ */
 
 /**
  * cifs_idmap_init_plugin - Initialize the plugin interface
@@ -74,7 +76,8 @@ struct cifs_sid {
  * representation or mapped name in a heap-allocated buffer. The caller
  * of this function is expected to free "name" on success. Returns 0 on
  * success and non-zero on error. On error, the errmsg pointer passed
- * in to the init_plugin function should point to an error string.
+ * in to the init_plugin function should point to an error string. The
+ * caller will not free the error string.
  *
  * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
  * 				char **name);
@@ -90,10 +93,69 @@ struct cifs_sid {
  * a SID to a struct cifs_sid. The cifs_sid should already be
  * allocated. Returns 0 on success and non-zero on error. On error, the
  * plugin should reset the errmsg pointer passed to the init_plugin
- * function to an error string.
+ * function to an error string. The caller will not free the error string.
  *
  * int cifs_idmap_str_to_sid(void *handle, const char *name,
  * 				struct cifs_sid *sid);
  */
 
+/**
+ * cifs_idmap_sid_to_uid - convert struct cifs_sid to uid
+ * @handle - context handle
+ * @sid    - pointer to struct cifs_sid to be converted
+ * @uid    - pointer to uid_t where uid should be stored
+ *
+ * This function should map a struct cifs_sid to a uid. Returns 0 on success
+ * and non-zero on error. On error, the plugin should reset the errmsg pointer
+ * passed to the init_plugin function to an error string. The caller will not
+ * free the error string.
+ *
+ * int cifs_idmap_sid_to_uid(void *handle, const struct cifs_sid *sid,
+ * 				uid_t *uid);
+ */
+
+/**
+ * cifs_idmap_sid_to_gid - convert struct cifs_sid to gid
+ * @handle - context handle
+ * @sid    - pointer to struct cifs_sid to be converted
+ * @gid    - pointer to gid_t where gid should be stored
+ *
+ * This function should map a struct cifs_sid to a gid. Returns 0 on success
+ * and non-zero on error. On error, the plugin should reset the errmsg pointer
+ * passed to the init_plugin function to an error string. The caller will not
+ * free the error string.
+ *
+ * int cifs_idmap_sid_to_uid(void *handle, const struct cifs_sid *sid,
+ * 				gid_t *gid);
+ */
+
+/**
+ * cifs_idmap_uid_to_sid - convert uid to struct cifs_sid
+ * @handle - context handle
+ * @uid    - uid_t to be converted to a SID
+ * @sid    - pointer to struct cifs_sid where result should be stored
+ *
+ * This function should map a uid to a struct cifs_sid. Returns 0 on success
+ * and non-zero on error. On error, the plugin should reset the errmsg pointer
+ * passed to the init_plugin function to an error string. The caller will not
+ * free the error string.
+ *
+ * int cifs_idmap_uid_to_sid(void *handle, const uid_t uid,
+ * 				struct cifs_sid *sid);
+ */
+
+/**
+ * cifs_idmap_gid_to_sid - convert gid to struct cifs_sid
+ * @handle - context handle
+ * @gid    - gid_t to be converted to a SID
+ * @sid    - pointer to struct cifs_sid where result should be stored
+ *
+ * This function should map a gid to a struct cifs_sid. Returns 0 on success
+ * and non-zero on error. On error, the plugin should reset the errmsg pointer
+ * passed to the init_plugin function to an error string. The caller will not
+ * free the error string.
+ *
+ * int cifs_idmap_gid_to_sid(void *handle, const gid_t gid,
+ * 				struct cifs_sid *sid);
+ */
 #endif /* _CIFSIDMAP_H */
diff --git a/idmap_plugin.c b/idmap_plugin.c
index bef4e93..bf95aca 100644
--- a/idmap_plugin.c
+++ b/idmap_plugin.c
@@ -23,6 +23,7 @@
 #include <dlfcn.h>
 #include <errno.h>
 #include <stdint.h>
+#include <sys/types.h>
 
 #include "cifsacl.h"
 
@@ -109,3 +110,51 @@ str_to_sid(void *handle, const char *name, struct cifs_sid *sid)
 
 	return (*entry)(handle, name, sid);
 }
+
+int
+sid_to_uid(void *handle, const struct cifs_sid *sid, uid_t *uid)
+{
+	int (*entry)(void *handle, const struct cifs_sid *sid, uid_t *uid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_sid_to_uid");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, sid, uid);
+}
+
+int
+sid_to_gid(void *handle, const struct cifs_sid *sid, gid_t *gid)
+{
+	int (*entry)(void *handle, const struct cifs_sid *sid, uid_t *gid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_sid_to_gid");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, sid, gid);
+}
+
+int
+uid_to_sid(void *handle, const uid_t uid, struct cifs_sid *sid)
+{
+	int (*entry)(void *handle, const uid_t uid, struct cifs_sid *sid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_uid_to_sid");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, uid, sid);
+}
+
+int
+gid_to_sid(void *handle, const gid_t gid, struct cifs_sid *sid)
+{
+	int (*entry)(void *handle, const gid_t gid, struct cifs_sid *sid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_gid_to_sid");
+	if (!entry)
+		return -ENOSYS;
+
+	return (*entry)(handle, gid, sid);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
index 51e3a76..d149414 100644
--- a/idmap_plugin.h
+++ b/idmap_plugin.h
@@ -46,4 +46,16 @@ extern int sid_to_str(void *handle, const struct cifs_sid *sid, char **name);
 /* Convert string to cifs_sid. */
 extern int str_to_sid(void *handle, const char *name, struct cifs_sid *csid);
 
+/* Convert cifs_sid to a UID */
+extern int sid_to_uid(void *handle, const struct cifs_sid *sid, uid_t *uid);
+
+/* Convert cifs_sid to a GID */
+extern int sid_to_gid(void *handle, const struct cifs_sid *sid, gid_t *gid);
+
+/* Convert UID to cifs_sid */
+extern int uid_to_sid(void *handle, const uid_t uid, struct cifs_sid *sid);
+
+/* Convert GID to cifs_sid */
+extern int gid_to_sid(void *handle, const gid_t gid, struct cifs_sid *sid);
+
 #endif /* _IDMAP_PLUGIN_H */
diff --git a/idmapwb.c b/idmapwb.c
index aa53150..8d5e3f2 100644
--- a/idmapwb.c
+++ b/idmapwb.c
@@ -160,6 +160,70 @@ convert_sid:
 	return 0;
 }
 
+int
+cifs_idmap_sid_to_uid(void *handle __attribute__((unused)),
+			const struct cifs_sid *csid, uid_t *uid)
+{
+	wbcErr wbcrc;
+	struct wbcDomainSid wsid;
+
+	csid_to_wsid(&wsid, csid);
+	wbcrc = wbcSidToUid(&wsid, uid);
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+	return 0;
+}
+
+int
+cifs_idmap_sid_to_gid(void *handle __attribute__((unused)),
+			const struct cifs_sid *csid, gid_t *gid)
+{
+	wbcErr wbcrc;
+	struct wbcDomainSid wsid;
+
+	csid_to_wsid(&wsid, csid);
+	wbcrc = wbcSidToGid(&wsid, gid);
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+	return 0;
+}
+
+int
+cifs_idmap_uid_to_sid(void *handle __attribute__((unused)),
+			const uid_t uid, struct cifs_sid *csid)
+{
+	wbcErr wbcrc;
+	struct wbcDomainSid wsid;
+
+	wbcrc = wbcUidToSid(uid, &wsid);
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+	wsid_to_csid(csid, &wsid);
+	return 0;
+}
+
+int
+cifs_idmap_gid_to_sid(void *handle __attribute__((unused)),
+			const gid_t gid, struct cifs_sid *csid)
+{
+	wbcErr wbcrc;
+	struct wbcDomainSid wsid;
+
+	wbcrc = wbcGidToSid(gid, &wsid);
+	if (!WBC_ERROR_IS_OK(wbcrc)) {
+		*plugin_errmsg = wbcErrorString(wbcrc);
+		return -EIO;
+	}
+	wsid_to_csid(csid, &wsid);
+	return 0;
+}
+
 /*
  * For the winbind plugin, we don't need to do anything special on
  * init or exit
-- 
1.7.11.7
