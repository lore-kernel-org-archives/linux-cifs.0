From: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: iterate over posix acl xattr entry correctly in ACL_to_cifs_posix()
Date: Sat, 22 Oct 2016 16:14:40 +0800
Message-ID: <1477124080-27230-1-git-send-email-guaneryu@gmail.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, agruenba-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 2211d5ba5c6c ("posix_acl: xattr representation cleanups")
removes the typedefs and the zero-length a_entries array in struct
posix_acl_xattr_header, and uses bare struct posix_acl_xattr_header
and struct posix_acl_xattr_entry directly.

But it failed to iterate over posix acl slots when converting posix
acls to CIFS format, which results in several test failures in
xfstests (generic/053 generic/105) when testing against a samba v1
server, starting from v4.9-rc1 kernel. e.g.

  [root@localhost xfstests]# diff -u tests/generic/105.out /root/xfstests/results//generic/105.out.bad
  --- tests/generic/105.out       2016-09-19 16:33:28.577962575 +0800
  +++ /root/xfstests/results//generic/105.out.bad 2016-10-22 15:41:15.201931110 +0800
  @@ -1,3 +1,4 @@
   QA output created by 105
   -rw-r--r-- root
  +setfacl: subdir: Invalid argument
   -rw-r--r-- root

Fix it by introducing a new "ace" var, like what
cifs_copy_posix_acl() does, and iterating posix acl xattr entries
over it in the for loop.

Signed-off-by: Eryu Guan <guaneryu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifssmb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 3f3185f..d04c21c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3453,8 +3453,8 @@ static __u16 ACL_to_cifs_posix(char *parm_data, const char *pACL,
 		return 0;
 	}
 	for (i = 0; i < count; i++) {
-		rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i],
-			(struct posix_acl_xattr_entry *)(local_acl + 1));
+		struct posix_acl_xattr_entry *ace = (void *)(local_acl + 1);
+		rc = convert_ace_to_cifs_ace(&cifs_acl->ace_array[i], &ace[i]);
 		if (rc != 0) {
 			/* ACE not converted */
 			break;
-- 
2.7.4
