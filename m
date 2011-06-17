From: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [patch] cifs: update limit for snprintf() in cifs_construct_tcon()
Date: Fri, 17 Jun 2011 13:31:01 +0300
Message-ID: <20110617103059.GE2520@shale.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "open list:COMMON INTERNET F..." <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	"open list:COMMON INTERNET F..." <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In 34c87901e113 "Shrink stack space usage in cifs_construct_tcon" we
change the size of the username name buffer from MAX_USERNAME_SIZE
(256) to 28.  This call to snprintf() needs to be updated as well.

Signed-off-by: Dan Carpenter <error27-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
I know that everyone is going to complain about using a literal but
it's local to this function and it's commented in the lines above.
I'm not opposed to using a define, I suppose, if you give me a good
one, but really I'd just as soon leave it as is.  *eye roll in
advance*.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 12cf72d..efd1c7a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3451,7 +3451,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, uid_t fsuid)
 		goto out;
 	}
 
-	snprintf(username, MAX_USERNAME_SIZE, "krb50x%x", fsuid);
+	snprintf(username, 28, "krb50x%x", fsuid);
 	vol_info->username = username;
 	vol_info->local_nls = cifs_sb->local_nls;
 	vol_info->linux_uid = fsuid;
