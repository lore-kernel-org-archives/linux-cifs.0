From: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cifs: Support for an upcall to map SID to an uid and a gid
Date: Tue,  7 Dec 2010 11:11:12 -0600
Message-ID: <1291741872-22747-1-git-send-email-shirishpargaonkar@gmail.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


Use a cifs upcall to map a SID to either an uid or a gid using
winbind.

There is a corrosponding patch for the cifs.upcall binary in cifs-utils rpm 
that is being posted also.

A new type of key, cifs_acl_key_type, is used.
To map a SID, which can be either a Onwer SID or a Group SID, key
description starts with the string "os" or "gs" followed by SID converted
to a string. Without "os" or "gs", cifs.upcall does not know whether
SID needs to be mapped to either an uid or a gid.

Once a key is instantiated, get rid of it since cifs does not need to
use in any way.
winbind does the id mapping and looks up name for the newly mapped
SID/uid or SID/gid combination.

For now, cifs.upcall is only used to map a SID to an id (uid or gid) but
it would be used to obtain an SID (string) for an id.

An entry such as this 

create  cifs.cifs_acl   *       *               /usr/sbin/cifs.upcall %k

is needed in the file /etc/request-key.conf.


Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c |  117 ++++++++++++++++++++++++++++++++++++++++++++++++-----
 fs/cifs/cifsacl.h |    8 ++++
 fs/cifs/cifsfs.c  |    7 +++
 3 files changed, 122 insertions(+), 10 deletions(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index a520091..d3ac6c8 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -23,6 +23,9 @@
 
 #include <linux/fs.h>
 #include <linux/slab.h>
+#include <linux/string.h>
+#include <keys/user-type.h>
+#include <linux/key-type.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsacl.h"
@@ -52,6 +55,102 @@ static const struct cifs_sid sid_authusers = {
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
+static int
+cifs_acl_key_instantiate(struct key *key, const void *data, size_t datalen)
+{
+	char *payload;
+
+	payload = kmalloc(datalen, GFP_KERNEL);
+	if (!payload)
+		return -ENOMEM;
+
+	memcpy(payload, data, datalen);
+	key->payload.data = payload;
+	return 0;
+}
+
+static void
+cifs_acl_key_destroy(struct key *key)
+{
+	kfree(key->payload.data);
+}
+
+struct key_type cifs_acl_key_type = {
+	.name        = "cifs.cifs_acl",
+	.instantiate = cifs_acl_key_instantiate,
+	.destroy     = cifs_acl_key_destroy,
+	.describe    = user_describe,
+	.match       = user_match,
+};
+
+static void
+sid_to_str(struct cifs_sid *sidptr, char *sidstr)
+{
+	int i;
+	unsigned long saval;
+	char *strptr;
+
+	strptr = sidstr;
+
+	sprintf(strptr, "%s", "S");
+	strptr = sidstr + strlen(sidstr);
+
+	sprintf(strptr, "-%d", sidptr->revision);
+	strptr = sidstr + strlen(sidstr);
+
+	for (i = 0; i < 6; ++i) {
+		if (sidptr->authority[i]) {
+			sprintf(strptr, "-%d", sidptr->authority[i]);
+			strptr = sidstr + strlen(sidstr);
+		}
+	}
+
+	for (i = 0; i < sidptr->num_subauth; ++i) {
+		saval = le32_to_cpu(sidptr->sub_auth[i]);
+		sprintf(strptr, "-%ld", saval);
+		strptr = sidstr + strlen(sidstr);
+	}
+}
+
+static int
+sid_to_id(struct cifs_sid *psid, struct cifs_fattr *fattr, uint sidtype)
+{
+	int rc = 0;
+	char *sidstr, *strptr;
+	struct key *idkey;
+
+	sidstr = kzalloc(SIDLEN, GFP_KERNEL);
+	if (!sidstr)
+		return -ENOMEM;
+	strptr = sidstr;
+
+	if (sidtype == SIDOWNER)
+		sprintf(strptr, "%s", "os:");
+	else if (sidtype == SIDGROUP)
+		sprintf(strptr, "%s", "gs:");
+	else {
+		rc = -EINVAL;
+		goto idresolve_err;
+	}
+	strptr = sidstr + strlen(sidstr);
+
+	sid_to_str(psid, strptr);
+
+	idkey = request_key(&cifs_acl_key_type, sidstr, "");
+	if (IS_ERR(idkey))
+		cFYI(1, "%s: idkey error: %d\n", __func__, -ENOKEY);
+	else {
+		if (sidtype == SIDOWNER)
+			fattr->cf_uid = *(unsigned long *)idkey->payload.value;
+		else if (sidtype == SIDGROUP)
+			fattr->cf_gid = *(unsigned long *)idkey->payload.value;
+		key_put(idkey);
+	}
+
+idresolve_err:
+	kfree(sidstr);
+	return rc;
+}
 
 int match_sid(struct cifs_sid *ctsid)
 {
@@ -438,7 +537,6 @@ static int set_chmod_dacl(struct cifs_acl *pndacl, struct cifs_sid *pownersid,
 	return 0;
 }
 
-
 static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 {
 	/* BB need to add parm so we can store the SID BB */
@@ -476,7 +574,7 @@ static int parse_sid(struct cifs_sid *psid, char *end_of_acl)
 static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 			  struct cifs_fattr *fattr)
 {
-	int rc;
+	int rc = 0;
 	struct cifs_sid *owner_sid_ptr, *group_sid_ptr;
 	struct cifs_acl *dacl_ptr; /* no need for SACL ptr */
 	char *end_of_acl = ((char *)pntsd) + acl_len;
@@ -500,10 +598,16 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 	rc = parse_sid(owner_sid_ptr, end_of_acl);
 	if (rc)
 		return rc;
+	rc = sid_to_id(owner_sid_ptr, fattr, SIDOWNER);
+	if (rc)
+		cFYI(1, "Can't resolve SID to an uid");
 
 	rc = parse_sid(group_sid_ptr, end_of_acl);
 	if (rc)
 		return rc;
+	rc = sid_to_id(group_sid_ptr, fattr, SIDGROUP);
+	if (rc)
+		cFYI(1, "Can't resolve SID to a gid");
 
 	if (dacloffset)
 		parse_dacl(dacl_ptr, end_of_acl, owner_sid_ptr,
@@ -511,14 +615,7 @@ static int parse_sec_desc(struct cifs_ntsd *pntsd, int acl_len,
 	else
 		cFYI(1, "no ACL"); /* BB grant all or default perms? */
 
-/*	cifscred->uid = owner_sid_ptr->rid;
-	cifscred->gid = group_sid_ptr->rid;
-	memcpy((void *)(&(cifscred->osid)), (void *)owner_sid_ptr,
-			sizeof(struct cifs_sid));
-	memcpy((void *)(&(cifscred->gsid)), (void *)group_sid_ptr,
-			sizeof(struct cifs_sid)); */
-
-	return 0;
+	return rc;
 }
 
 
diff --git a/fs/cifs/cifsacl.h b/fs/cifs/cifsacl.h
index 6c8096c..74e69ca 100644
--- a/fs/cifs/cifsacl.h
+++ b/fs/cifs/cifsacl.h
@@ -39,6 +39,10 @@
 #define ACCESS_ALLOWED	0
 #define ACCESS_DENIED	1
 
+#define SIDOWNER 1
+#define SIDGROUP 2
+#define SIDLEN 150 /* S- 1 revision- 6 authorities- max 5 sub authorities */
+
 struct cifs_ntsd {
 	__le16 revision; /* revision level */
 	__le16 type;
@@ -76,6 +80,10 @@ struct cifs_wksid {
 
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 
+#ifdef __KERNEL__
+extern struct key_type cifs_acl_key_type;
+#endif /* KERNEL */
+
 extern int match_sid(struct cifs_sid *);
 extern int compare_sids(const struct cifs_sid *, const struct cifs_sid *);
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 56a4b75..2753d54 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -46,6 +46,7 @@
 #include <linux/mm.h>
 #include <linux/key-type.h>
 #include "cifs_spnego.h"
+#include "cifsacl.h"
 #include "fscache.h"
 #define CIFS_MAGIC_NUMBER 0xFF534D42	/* the first four bytes of SMB PDUs */
 
@@ -973,11 +974,16 @@ init_cifs(void)
 	rc = register_key_type(&cifs_spnego_key_type);
 	if (rc)
 		goto out_unregister_filesystem;
+	rc = register_key_type(&cifs_acl_key_type);
+	if (rc)
+		goto out_unregister_keytype;
 #endif
 
 	return 0;
 
 #ifdef CONFIG_CIFS_UPCALL
+out_unregister_keytype:
+	unregister_key_type(&cifs_spnego_key_type);
 out_unregister_filesystem:
 	unregister_filesystem(&cifs_fs_type);
 #endif
@@ -1004,6 +1010,7 @@ exit_cifs(void)
 	cifs_dfs_release_automount_timer();
 #endif
 #ifdef CONFIG_CIFS_UPCALL
+	unregister_key_type(&cifs_acl_key_type);
 	unregister_key_type(&cifs_spnego_key_type);
 #endif
 	unregister_filesystem(&cifs_fs_type);
-- 
1.6.0.2
