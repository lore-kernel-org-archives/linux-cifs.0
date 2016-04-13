From: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/8] cifs: Check for equality with ACL_TYPE_ACCESS and ACL_TYPE_DEFAULT
Date: Thu, 14 Apr 2016 00:27:40 +0200
Message-ID: <1460586466-5518-3-git-send-email-agruenba@redhat.com>
References: <1460586466-5518-1-git-send-email-agruenba@redhat.com>
Cc: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460586466-5518-1-git-send-email-agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
References: <20160413182026.GR25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The two values ACL_TYPE_ACCESS and ACL_TYPE_DEFAULT are meant to be
enumerations, not bits in a bit mask.  Use '==' instead of '&' to check
for these values.

Signed-off-by: Andreas Gruenbacher <agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 76fcb50..f24a89c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3366,7 +3366,7 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
 	if (le16_to_cpu(cifs_acl->version) != CIFS_ACL_VERSION)
 		return -EOPNOTSUPP;
 
-	if (acl_type & ACL_TYPE_ACCESS) {
+	if (acl_type == ACL_TYPE_ACCESS) {
 		count = le16_to_cpu(cifs_acl->access_entry_count);
 		pACE = &cifs_acl->ace_array[0];
 		size = sizeof(struct cifs_posix_acl);
@@ -3377,7 +3377,7 @@ static int cifs_copy_posix_acl(char *trgt, char *src, const int buflen,
 				 size_of_data_area, size);
 			return -EINVAL;
 		}
-	} else if (acl_type & ACL_TYPE_DEFAULT) {
+	} else if (acl_type == ACL_TYPE_DEFAULT) {
 		count = le16_to_cpu(cifs_acl->access_entry_count);
 		size = sizeof(struct cifs_posix_acl);
 		size += sizeof(struct cifs_posix_ace) * count;
-- 
2.4.11
