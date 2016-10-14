From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] Retrieve uid and gid from special sid if enabled
Date: Fri, 14 Oct 2016 10:10:07 -0500
Message-ID: <1476457807-22055-2-git-send-email-smfrench@gmail.com>
References: <1476457807-22055-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476457807-22055-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

New mount option "idsfromsid" indicates to cifs.ko that
it should try to retrieve the uid and gid owner fields
from special sids.  This patch adds the code to parse the owner
sids in the ACL to see if they match, and if so populate the
uid and/or gid from them.  This is faster than upcalling for
them and asking winbind, and is a fairly common case, and is
also helpful when cifs.upcall and idmapping is not configured.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Reviewed-by:  Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsacl.c | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 71e8a56..15bac39 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -42,6 +42,35 @@
 /* group users */
 static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
+/* S-1-22-1 Unmapped Unix users */
+static const struct cifs_sid sid_unix_users = {1, 1, {0, 0, 0, 0, 0, 22},
+		{cpu_to_le32(1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
+
+/* S-1-22-2 Unmapped Unix groups */
+static const struct cifs_sid sid_unix_groups = { 1, 1, {0, 0, 0, 0, 0, 22},
+		{cpu_to_le32(2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
+
+/*
+ * See http://technet.microsoft.com/en-us/library/hh509017(v=ws.10).aspx
+ */
+
+/* S-1-5-88 MS NFS and Apple style UID/GID/mode */
+
+/* S-1-5-88-1 Unix uid */
+static const struct cifs_sid sid_unix_NFS_users = { 1, 2, {0, 0, 0, 0, 0, 5},
+	{cpu_to_le32(88),
+	 cpu_to_le32(1), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
+
+/* S-1-5-88-2 Unix gid */
+static const struct cifs_sid sid_unix_NFS_groups = { 1, 2, {0, 0, 0, 0, 0, 5},
+	{cpu_to_le32(88),
+	 cpu_to_le32(2), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
+
+/* S-1-5-88-3 Unix mode */
+static const struct cifs_sid sid_unix_NFS_mode = { 1, 2, {0, 0, 0, 0, 0, 5},
+	{cpu_to_le32(88),
+	 cpu_to_le32(3), 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0} };
+
 static const struct cred *root_cred;
 
 static int
@@ -183,6 +212,62 @@
 	return 0; /* sids compare/match */
 }
 
+static bool
+is_well_known_sid(const struct cifs_sid *psid, uint32_t *puid, bool is_group)
+{
+	int i;
+	int num_subauth;
+	const struct cifs_sid *pwell_known_sid;
+
+	if (!psid || (puid == NULL))
+		return false;
+
+	num_subauth = psid->num_subauth;
+
+	/* check if Mac (or Windows NFS) vs. Samba format for Unix owner SID */
+	if (num_subauth == 2) {
+		if (is_group)
+			pwell_known_sid = &sid_unix_groups;
+		else
+			pwell_known_sid = &sid_unix_users;
+	} else if (num_subauth == 3) {
+		if (is_group)
+			pwell_known_sid = &sid_unix_NFS_groups;
+		else
+			pwell_known_sid = &sid_unix_NFS_users;
+	} else
+		return false;
+
+	/* compare the revision */
+	if (psid->revision != pwell_known_sid->revision)
+		return false;
+
+	/* compare all of the six auth values */
+	for (i = 0; i < NUM_AUTHS; ++i) {
+		if (psid->authority[i] != pwell_known_sid->authority[i]) {
+			cifs_dbg(FYI, "auth %d did not match\n", i);
+			return false;
+		}
+	}
+
+	if (num_subauth == 2) {
+		if (psid->sub_auth[0] != pwell_known_sid->sub_auth[0])
+			return false;
+
+		*puid = le32_to_cpu(psid->sub_auth[1]);
+	} else /* 3 subauths, ie Windows/Mac style */ {
+		*puid = le32_to_cpu(psid->sub_auth[0]);
+		if ((psid->sub_auth[0] != pwell_known_sid->sub_auth[0]) ||
+		    (psid->sub_auth[1] != pwell_known_sid->sub_auth[1]))
+			return false;
+
+		*puid = le32_to_cpu(psid->sub_auth[2]);
+	}
+
+	cifs_dbg(FYI, "Unix UID %d returned from SID\n", *puid);
+	return true; /* well known sid found, uid returned */
+}
+
 static void
 cifs_copy_sid(struct cifs_sid *dst, const struct cifs_sid *src)
 {
@@ -276,6 +361,43 @@
 		return -EIO;
 	}
 
+	if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_UID_FROM_ACL) {
+		uint32_t unix_id;
+		bool is_group;
+
+		if (sidtype != SIDOWNER)
+			is_group = true;
+		else
+			is_group = false;
+
+		if (is_well_known_sid(psid, &unix_id, is_group) == false)
+			goto try_upcall_to_get_id;
+
+		if (is_group) {
+			kgid_t gid;
+			gid_t id;
+
+			id = (gid_t)unix_id;
+			gid = make_kgid(&init_user_ns, id);
+			if (gid_valid(gid)) {
+				fgid = gid;
+				goto got_valid_id;
+			}
+		} else {
+			kuid_t uid;
+			uid_t id;
+
+			id = (uid_t)unix_id;
+			uid = make_kuid(&init_user_ns, id);
+			if (uid_valid(uid)) {
+				fuid = uid;
+				goto got_valid_id;
+			}
+		}
+		/* If unable to find uid/gid easily from SID try via upcall */
+	}
+
+try_upcall_to_get_id:
 	sidstr = sid_to_key_str(psid, sidtype);
 	if (!sidstr)
 		return -ENOMEM;
@@ -329,6 +451,7 @@
 	 * Note that we return 0 here unconditionally. If the mapping
 	 * fails then we just fall back to using the mnt_uid/mnt_gid.
 	 */
+got_valid_id:
 	if (sidtype == SIDOWNER)
 		fattr->cf_uid = fuid;
 	else
-- 
1.9.1
