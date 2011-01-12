From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: add cruid= mount option
Date: Wed, 12 Jan 2011 11:21:39 -0500
Message-ID: <1294849299-3548-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In commit 3e4b3e1f we separated the "uid" mount option such that it
no longer determined the owner of the credential cache by default. When
we did this, we added a new option to cifs.upcall (--legacy-uid) to
try to make it so that it would behave the same was as it did before.

This ignored a rather important point -- the kernel has no way to know
what options are being passed to cifs.upcall, so it doesn't know what
uid it should use to determine whether to match an existing krb5 session.

The simplest solution is to simply add a new "cruid=" mount option that
only governs the uid owner of the credential cache for the mount.

Unfortunately, this means that the --legacy-uid option in cifs.upcall was
ill-considered and is now useless, but I don't see a better way to deal
with this.

A patch for the mount.cifs manpage will follow when/if this patch has
been accepted.

Reported-by: Stefan Walter <walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 60d4826..99a5f18 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1107,6 +1107,8 @@ cifs_parse_mount_options(char *options, const char *devname,
 		} else if (!strnicmp(data, "uid", 3) && value && *value) {
 			vol->linux_uid = simple_strtoul(value, &value, 0);
 			uid_specified = true;
+		} else if (!strnicmp(data, "cruid", 5) && value && *value) {
+			vol->cred_uid = simple_strtoul(value, &value, 0);
 		} else if (!strnicmp(data, "forceuid", 8)) {
 			override_uid = 1;
 		} else if (!strnicmp(data, "noforceuid", 10)) {
-- 
1.7.3.4
