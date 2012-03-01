From: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
Subject: [PATCH] cifs: don't dereference potentially NULL variable in
 match_session()
Date: Thu, 1 Mar 2012 21:45:13 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1203012143280.19443@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This bit of code:
...
		if (strncmp(ses->user_name,
			    vol->username ? vol->username : "",
			    MAX_USERNAME_SIZE))
			return 0;
...
implies that 'vol->username' may be NULL.
If it is NULL, then the 'strlen(vol->username)' that follows will
dereference a NULL pointer.

This patch should take care of that issue.

Signed-off-by: Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>
---
 fs/cifs/connect.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

 Compile tested only.

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 602f77c..2f3cf02 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2014,8 +2014,9 @@ static int match_session(struct cifs_ses *ses, struct smb_vol *vol)
 			    vol->username ? vol->username : "",
 			    MAX_USERNAME_SIZE))
 			return 0;
-		if (strlen(vol->username) != 0 &&
-		    ses->password != NULL &&
+		if (vol->username &&
+		    strlen(vol->username) != 0 &&
+		    ses->password &&
 		    strncmp(ses->password,
 			    vol->password ? vol->password : "",
 			    MAX_PASSWORD_SIZE))
-- 
1.7.9.2


-- 
Jesper Juhl <jj-IYz4IdjRLj0sV2N9l4h3zg@public.gmane.org>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.
