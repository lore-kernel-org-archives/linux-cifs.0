From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 8/9] cifs: set a timeout on keys in cifs.idmap cache
Date: Fri, 19 Oct 2012 08:20:49 -0400
Message-ID: <1350649250-5343-9-git-send-email-jlayton@redhat.com>
References: <1350649250-5343-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1350649250-5343-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We want to allow unused idmap keys to eventually be purged from the
cache. Implement that by simply setting a timeout on the key whenever we
use it. We use the same default timeout as the NFS idmap cache, but add
a module parm to make it tunable.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsacl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 12d70ee..0c0a594 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -26,6 +26,7 @@
 #include <linux/string.h>
 #include <linux/keyctl.h>
 #include <linux/key-type.h>
+#include <linux/moduleparam.h>
 #include <keys/user-type.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
@@ -44,6 +45,11 @@ static const struct cifs_sid sid_user = {1, 2 , {0, 0, 0, 0, 0, 5}, {} };
 
 static const struct cred *root_cred;
 
+static unsigned int cifs_idmap_cache_timeout = 600;
+module_param(cifs_idmap_cache_timeout, uint, 0644);
+MODULE_PARM_DESC(cifs_idmap_cache_timeout, "Number of seconds that ID mappings "
+			"stay in cache. (default=600)");
+
 static int
 cifs_idmap_key_instantiate(struct key *key, struct key_preparsed_payload *prep)
 {
@@ -214,6 +220,7 @@ id_to_sid(unsigned int cid, uint sidtype, struct cifs_sid *ssid)
 		goto out_key_put;
 	}
 	cifs_copy_sid(ssid, (struct cifs_sid *)sidkey->payload.data);
+	key_set_timeout(sidkey, cifs_idmap_cache_timeout);
 out_key_put:
 	key_put(sidkey);
 out_revert_creds:
@@ -272,6 +279,7 @@ sid_to_id(struct cifs_sb_info *cifs_sb, struct cifs_sid *psid,
 	else
 		fgid = (gid_t)sidkey->payload.value;
 
+	key_set_timeout(sidkey, cifs_idmap_cache_timeout);
 out_key_put:
 	key_put(sidkey);
 out_revert_creds:
-- 
1.7.11.7
