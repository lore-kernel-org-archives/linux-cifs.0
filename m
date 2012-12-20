From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v3 5/6] cifs-utils: convert cifs.idmap to use plugin interface
Date: Thu, 20 Dec 2012 07:50:32 -0500
Message-ID: <1356007833-10893-6-git-send-email-jlayton@samba.org>
References: <1356007833-10893-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1356007833-10893-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Add routines for the various things that cifs.idmap needs and have it
call them.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am    |   5 +-
 cifs.idmap.c   | 161 +++++++++++++++++++++++++++------------------------------
 cifsidmap.h    |  75 +++++++++++++++++++++++++--
 idmap_plugin.c |  33 ++++++++++++
 idmap_plugin.h |   8 +++
 idmapwb.c      | 123 +++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 315 insertions(+), 90 deletions(-)

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
index 792ea58..788d369 100644
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
 
@@ -101,31 +103,13 @@ str_to_uint(const char *src, unsigned int *dst)
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
-	uid_t uid = 0;
-	gid_t gid = 0;;
-	wbcErr rc = 1;
+	int rc = 1;
 	char *sidstr = NULL;
-	struct wbcDomainSid sid;
+	struct cifs_sid sid;
+	struct cifs_uxid cuxid;
 
 	/*
 	 * Use winbind to convert received string to a SID and lookup
@@ -137,105 +121,106 @@ cifs_idmap(const key_serial_t key, const char *key_descr)
 	 */
 	sidstr = strget(key_descr, "os:");
 	if (sidstr) {
-		rc = wbcStringToSid(sidstr, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "Invalid owner string: %s, rc: %d",
-				key_descr, rc);
-		else {
-			rc = wbcSidToUid(&sid, &uid);
-			if (rc)
-				syslog(LOG_DEBUG, "SID %s to uid wbc error: %d",
-						key_descr, rc);
+		rc = str_to_sid(plugin_handle, sidstr, &sid);
+		if (rc) {
+			syslog(LOG_DEBUG, "Unable to convert owner string %s "
+				"to SID: %s", key_descr, plugin_errmsg);
+			goto cifs_idmap_ret;
 		}
-		if (!rc) { /* SID has been mapped to an uid */
-			rc = keyctl_instantiate(key, &uid, sizeof(uid_t), 0);
-			if (rc)
-				syslog(LOG_ERR, "%s: key inst: %s",
-					__func__, strerror(errno));
+
+		rc = sids_to_ids(plugin_handle, &sid, 1, &cuxid);
+		if (rc || (cuxid.type != CIFS_UXID_TYPE_UID &&
+			   cuxid.type != CIFS_UXID_TYPE_BOTH)) {
+			syslog(LOG_DEBUG, "Unable to convert %s to "
+				"UID: %s", key_descr, plugin_errmsg);
+			rc = rc ? rc : -EINVAL;
+			goto cifs_idmap_ret;
 		}
+		rc = keyctl_instantiate(key, &cuxid.id.uid, sizeof(uid_t), 0);
+		if (rc)
+			syslog(LOG_ERR, "%s: key inst: %s", __func__,
+					strerror(errno));
 
 		goto cifs_idmap_ret;
 	}
 
 	sidstr = strget(key_descr, "gs:");
 	if (sidstr) {
-		rc = wbcStringToSid(sidstr, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "Invalid group string: %s, rc: %d",
-					key_descr, rc);
-		else {
-			rc = wbcSidToGid(&sid, &gid);
-			if (rc)
-				syslog(LOG_DEBUG, "SID %s to gid wbc error: %d",
-						key_descr, rc);
+		rc = str_to_sid(plugin_handle, sidstr, &sid);
+		if (rc) {
+			syslog(LOG_DEBUG, "Unable to convert group string %s "
+				"to SID: %s", key_descr, plugin_errmsg);
+			goto cifs_idmap_ret;
 		}
-		if (!rc) { /* SID has been mapped to a gid */
-			rc = keyctl_instantiate(key, &gid, sizeof(gid_t), 0);
-			if (rc)
-				syslog(LOG_ERR, "%s: key inst: %s",
-						__func__, strerror(errno));
+
+		rc = sids_to_ids(plugin_handle, &sid, 1, &cuxid);
+		if (rc || (cuxid.type != CIFS_UXID_TYPE_GID &&
+			   cuxid.type != CIFS_UXID_TYPE_BOTH)) {
+			syslog(LOG_DEBUG, "Unable to convert %s to "
+				"GID: %s", key_descr, plugin_errmsg);
+			rc = rc ? rc : -EINVAL;
+			goto cifs_idmap_ret;
 		}
+		rc = keyctl_instantiate(key, &cuxid.id.gid, sizeof(gid_t), 0);
+		if (rc)
+			syslog(LOG_ERR, "%s: key inst: %s", __func__,
+					strerror(errno));
 
 		goto cifs_idmap_ret;
 	}
 
 	sidstr = strget(key_descr, "oi:");
 	if (sidstr) {
-		rc = str_to_uint(sidstr, (unsigned int *)&uid);
+		rc = str_to_uint(sidstr, (unsigned int *)&cuxid.id.uid);
 		if (rc) {
 			syslog(LOG_ERR, "Unable to convert %s to uid: %s",
 				sidstr, strerror(rc));
 			goto cifs_idmap_ret;
 		}
+		cuxid.type = CIFS_UXID_TYPE_UID;
 
-		syslog(LOG_DEBUG, "SID: %s, uid: %u", sidstr, uid);
-		rc = wbcUidToSid(uid, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "uid %u to SID  error: %d", uid, rc);
-		if (!rc) {
-			struct cifs_sid csid;
-
-			/* SID has been mapped to a uid */
-			wsid_to_csid(&csid, &sid);
-			rc = keyctl_instantiate(key, &csid,
-					sizeof(struct cifs_sid), 0);
-			if (rc)
-				syslog(LOG_ERR, "%s: key inst: %s",
-					__func__, strerror(errno));
+		syslog(LOG_DEBUG, "SID: %s, uid: %u", sidstr, cuxid.id.uid);
+		rc = ids_to_sids(plugin_handle, &cuxid, 1, &sid);
+		if (rc || sid.revision == 0) {
+			syslog(LOG_DEBUG, "uid %u to SID error: %s",
+				cuxid.id.uid, plugin_errmsg);
+			goto cifs_idmap_ret;
 		}
 
+		rc = keyctl_instantiate(key, &sid, sizeof(struct cifs_sid), 0);
+		if (rc)
+			syslog(LOG_ERR, "%s: key inst: %s", __func__,
+				strerror(errno));
+
 		goto cifs_idmap_ret;
 	}
 
 	sidstr = strget(key_descr, "gi:");
 	if (sidstr) {
-		rc = str_to_uint(sidstr, (unsigned int *)&gid);
+		rc = str_to_uint(sidstr, (unsigned int *)&cuxid.id.gid);
 		if (rc) {
 			syslog(LOG_ERR, "Unable to convert %s to gid: %s",
 				sidstr, strerror(rc));
 			goto cifs_idmap_ret;
 		}
+		cuxid.type = CIFS_UXID_TYPE_GID;
 
-		syslog(LOG_DEBUG, "SID: %s, gid: %u", sidstr, gid);
-		rc = wbcGidToSid(gid, &sid);
-		if (rc)
-			syslog(LOG_DEBUG, "gid %u to SID error: %d", gid, rc);
-		if (!rc) {
-			struct cifs_sid csid;
-
-			/* SID has been mapped to a gid */
-			wsid_to_csid(&csid, &sid);
-			rc = keyctl_instantiate(key, &csid,
-					sizeof(struct cifs_sid), 0);
-			if (rc)
-				syslog(LOG_ERR, "%s: key inst: %s",
-					__func__, strerror(errno));
+		syslog(LOG_DEBUG, "SID: %s, gid: %u", sidstr, cuxid.id.gid);
+		rc = ids_to_sids(plugin_handle, &cuxid, 1, &sid);
+		if (rc || sid.revision == 0) {
+			syslog(LOG_DEBUG, "gid %u to SID error: %s",
+				cuxid.id.gid, plugin_errmsg);
+			goto cifs_idmap_ret;
 		}
 
+		rc = keyctl_instantiate(key, &sid, sizeof(struct cifs_sid), 0);
+		if (rc)
+			syslog(LOG_ERR, "%s: key inst: %s", __func__,
+				strerror(errno));
+
 		goto cifs_idmap_ret;
 	}
 
-
 	syslog(LOG_DEBUG, "Invalid key: %s", key_descr);
 
 cifs_idmap_ret:
@@ -294,25 +279,33 @@ int main(const int argc, char *const argv[])
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
index f82e990..e539719 100644
--- a/cifsidmap.h
+++ b/cifsidmap.h
@@ -34,7 +34,32 @@ struct cifs_sid {
 	uint32_t sub_auth[SID_MAX_SUB_AUTHORITIES];
 } __attribute__((packed));
 
-/* Plugins should implement the following functions: */
+
+/*
+ * The type of the ID stored within cifs_uxid. UNKNOWN generally means that
+ * the mapping failed for some reason. BOTH means that the ID is usable as
+ * either a UID or a GID -- IOW, the UID and GID namespaces are unity-mapped.
+ */
+#define	CIFS_UXID_TYPE_UNKNOWN	(0)	/* mapping type is unknown */
+#define	CIFS_UXID_TYPE_UID	(1)	/* mapping is a UID */
+#define	CIFS_UXID_TYPE_GID	(2)	/* mapping is a GID */
+#define	CIFS_UXID_TYPE_BOTH	(3)	/* usable as UID or GID */
+
+/*
+ * This struct represents both a uid or gid and its type. The type should
+ * never be set to CIFSIDMAP_BOTH.
+ */
+struct cifs_uxid {
+	union {
+		uid_t uid;
+		gid_t gid;
+	} id;
+	unsigned char type;
+} __attribute__((packed));
+
+/*
+ * Plugins should implement the following functions:
+ */
 
 /**
  * cifs_idmap_init_plugin - Initialize the plugin interface
@@ -74,7 +99,8 @@ struct cifs_sid {
  * representation or mapped name in a heap-allocated buffer. The caller
  * of this function is expected to free "name" on success. Returns 0 on
  * success and non-zero on error. On error, the errmsg pointer passed
- * in to the init_plugin function should point to an error string.
+ * in to the init_plugin function should point to an error string. The
+ * caller will not free the error string.
  *
  * int cifs_idmap_sid_to_str(void *handle, const struct cifs_sid *sid,
  * 				char **name);
@@ -90,10 +116,53 @@ struct cifs_sid {
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
+ * cifs_idmap_sids_to_ids - convert struct cifs_sids to struct cifs_uxids
+ * @handle - context handle
+ * @sid    - pointer to array of struct cifs_sids to be converted
+ * @num    - number of sids to be converted
+ * @cuxid  - pointer to preallocated array of struct cifs_uxids for return
+ *
+ * This function should map an array of struct cifs_sids to an array of
+ * struct cifs_uxids.
+ *
+ * Returns 0 if at least one conversion was successful and success and
+ * non-zero on error. Any that were not successfully converted will have a
+ * cuxid->type of CIFS_UXID_TYPE_UNKNOWN.
+ *
+ * On error, the plugin should reset the errmsg pointer passed to the
+ * init_plugin function to an error string. The caller will not free the error
+ * string.
+ *
+ * int cifs_idmap_sids_to_ids(void *handle, const struct cifs_sid *sid,
+ * 				const size_t num, struct cifs_uxid *cuxid);
+ */
+
+/**
+ * cifs_idmap_ids_to_sids - convert uid to struct cifs_sid
+ * @handle - context handle
+ * @cuxid  - pointer to array of struct cifs_uxid to be converted to SIDs
+ * @num    - number of cifs_uxids to be converted to SIDs
+ * @sid    - pointer to preallocated array of struct cifs_sid where results
+ * 	     should be stored
+ *
+ * This function should map an array of cifs_uxids an array of struct cifs_sids.
+ * Returns 0 if at least one conversion was successful and non-zero on error.
+ * Any sids that were not successfully converted will have a revision number of
+ * 0.
+ *
+ * On error, the plugin should reset the errmsg pointer passed to the
+ * init_plugin function to an error string. The caller will not free the error
+ * string.
+ *
+ * int cifs_idmap_ids_to_sids(void *handle, const struct cifs_uxid *cuxid,
+ * 				const size_t num, struct cifs_sid *sid);
+ */
+
 #endif /* _CIFSIDMAP_H */
diff --git a/idmap_plugin.c b/idmap_plugin.c
index 55c766b..19050ec 100644
--- a/idmap_plugin.c
+++ b/idmap_plugin.c
@@ -23,6 +23,7 @@
 #include <dlfcn.h>
 #include <errno.h>
 #include <stdint.h>
+#include <sys/types.h>
 
 #include "cifsidmap.h"
 
@@ -115,3 +116,35 @@ str_to_sid(void *handle, const char *name, struct cifs_sid *sid)
 
 	return (*entry)(handle, name, sid);
 }
+
+int
+sids_to_ids(void *handle, const struct cifs_sid *sid, const size_t num,
+	  struct cifs_uxid *cuxid)
+{
+	int (*entry)(void *handle, const struct cifs_sid *sids,
+			const size_t num, struct cifs_uxid *cuxid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_sids_to_ids");
+	if (!entry) {
+		plugin_errmsg = "cifs_idmap_sids_to_ids not implemented";
+		return -ENOSYS;
+	}
+
+	return (*entry)(handle, sid, num, cuxid);
+}
+
+int
+ids_to_sids(void *handle, const struct cifs_uxid *cuxid, const size_t num,
+		struct cifs_sid *sid)
+{
+	int (*entry)(void *handle, const struct cifs_uxid *cuxid,
+			const size_t num, struct cifs_sid *sid);
+
+	*(void **)(&entry) = resolve_symbol("cifs_idmap_ids_to_sids");
+	if (!entry) {
+		plugin_errmsg = "cifs_idmap_ids_to_sids not implemented";
+		return -ENOSYS;
+	}
+
+	return (*entry)(handle, cuxid, num, sid);
+}
diff --git a/idmap_plugin.h b/idmap_plugin.h
index 51e3a76..16b015b 100644
--- a/idmap_plugin.h
+++ b/idmap_plugin.h
@@ -46,4 +46,12 @@ extern int sid_to_str(void *handle, const struct cifs_sid *sid, char **name);
 /* Convert string to cifs_sid. */
 extern int str_to_sid(void *handle, const char *name, struct cifs_sid *csid);
 
+/* convert array of cifs_sids to cifs_uxids */
+extern int sids_to_ids(void *handle, const struct cifs_sid *sids,
+			const size_t num, struct cifs_uxid *ids);
+
+/* convert array of cifs_uxids to cifs_sids */
+extern int ids_to_sids(void *handle, const struct cifs_uxid *id,
+			const size_t num, struct cifs_sid *sid);
+
 #endif /* _IDMAP_PLUGIN_H */
diff --git a/idmapwb.c b/idmapwb.c
index aa53150..5e8422b 100644
--- a/idmapwb.c
+++ b/idmapwb.c
@@ -28,6 +28,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <wbclient.h>
+#include <limits.h>
 
 #include "cifsidmap.h"
 
@@ -160,6 +161,128 @@ convert_sid:
 	return 0;
 }
 
+static void
+wuxid_to_cuxid(struct cifs_uxid *cuxid, const struct wbcUnixId *wuxid)
+{
+	switch(wuxid->type) {
+	case WBC_ID_TYPE_UID:
+		cuxid->id.uid = wuxid->id.uid;
+		cuxid->type = CIFS_UXID_TYPE_UID;
+		break;
+	case WBC_ID_TYPE_GID:
+		cuxid->id.gid = wuxid->id.gid;
+		cuxid->type = CIFS_UXID_TYPE_GID;
+		break;
+#ifdef HAVE_WBC_ID_TYPE_BOTH
+	case WBC_ID_TYPE_BOTH:
+		cuxid->id.uid = wuxid->id.uid;
+		cuxid->type = CIFS_UXID_TYPE_BOTH;
+		break;
+#endif /* HAVE_WBC_ID_TYPE_BOTH */
+	default:
+		cuxid->type = CIFS_UXID_TYPE_UNKNOWN;
+	}
+}
+
+int
+cifs_idmap_sids_to_ids(void *handle __attribute__((unused)),
+			const struct cifs_sid *csid, size_t num,
+			struct cifs_uxid *cuxid)
+{
+	int ret;
+	unsigned int i;
+	wbcErr wbcret;
+	struct wbcDomainSid *wsid;
+	struct wbcUnixId *wuxid;
+
+	if (num > UINT_MAX) {
+		*plugin_errmsg = "num is too large.";
+		return -EINVAL;
+	}
+
+	wsid = calloc(num, sizeof(*wsid));
+	if (!wsid) {
+		*plugin_errmsg = "Unable to allocate memory.";
+		return -ENOMEM;
+	}
+
+	wuxid = calloc(num, sizeof(*wuxid));
+	if (!wuxid) {
+		*plugin_errmsg = "Unable to allocate memory.";
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < num; ++i)
+		csid_to_wsid(&wsid[i], &csid[i]);
+
+	/*
+	 * Winbind does not set an error message in the event that some
+	 * mappings fail. So, we preemptively do it here, just in case.
+	 */
+	*plugin_errmsg = "Some IDs could not be mapped.";
+
+	wbcret = wbcSidsToUnixIds(wsid, num, wuxid);
+	if (!WBC_ERROR_IS_OK(wbcret)) {
+		*plugin_errmsg = wbcErrorString(wbcret);
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = 0;
+	for (i = 0; i < num; ++i)
+		wuxid_to_cuxid(&cuxid[i], &wuxid[i]);
+out:
+	free(wuxid);
+	free(wsid);
+	return ret;
+}
+
+int
+cifs_idmap_ids_to_sids(void *handle __attribute__((unused)),
+			const struct cifs_uxid *cuxid, size_t num,
+			struct cifs_sid *csid)
+{
+	int ret = -EIO;
+	wbcErr wbcrc;
+	size_t i;
+	struct wbcDomainSid wsid;
+
+	for (i = 0; i < num; ++i) {
+		switch(cuxid[i].type) {
+		case CIFS_UXID_TYPE_UID:
+			wbcrc = wbcUidToSid(cuxid[i].id.uid, &wsid);
+			break;
+		case CIFS_UXID_TYPE_GID:
+			wbcrc = wbcGidToSid(cuxid[i].id.gid, &wsid);
+			break;
+		case CIFS_UXID_TYPE_BOTH:
+			/*
+			 * In the BOTH case, prefer a user type first and fall
+			 * back to a group if that doesn't map.
+			 */
+			wbcrc = wbcUidToSid(cuxid[i].id.uid, &wsid);
+			if (WBC_ERROR_IS_OK(wbcrc))
+				break;
+			wbcrc = wbcGidToSid(cuxid[i].id.gid, &wsid);
+			break;
+		default:
+			csid[i].revision = 0;
+			*plugin_errmsg = "Invalid CIFS_UXID_TYPE value";
+			continue;
+		}
+
+		if (WBC_ERROR_IS_OK(wbcrc)) {
+			ret = 0;
+			wsid_to_csid(&csid[i], &wsid);
+		} else {
+			csid[i].revision = 0;
+			*plugin_errmsg = wbcErrorString(wbcrc);
+		}
+	}
+	return ret;
+}
+
 /*
  * For the winbind plugin, we don't need to do anything special on
  * init or exit
-- 
1.7.11.7
