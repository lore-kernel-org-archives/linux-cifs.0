From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] [CIFS] mount option sec=none not displayed properly in /proc/mounts
Date: Fri, 11 Sep 2015 19:34:39 -0500
Message-ID: <1442018079-14549-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the user specifies "sec=none" in a cifs mount, we set
sec_type as unspecified (and set a flag and the username will be
null) rather than setting sectype as "none" so
cifs_show_security was not properly displaying it in
cifs /proc/mounts entries.

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/cifsfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 6a1119e..e739950 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -325,8 +325,11 @@ cifs_show_address(struct seq_file *s, struct TCP_Server_Info *server)
 static void
 cifs_show_security(struct seq_file *s, struct cifs_ses *ses)
 {
-	if (ses->sectype == Unspecified)
+	if (ses->sectype == Unspecified) {
+		if (ses->user_name == NULL)
+			seq_puts(s, ",sec=none");
 		return;
+	}
 
 	seq_puts(s, ",sec=");
 
-- 
1.9.1
