From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] cifs: remove unneeded variable initialization in cifs_reconnect_tcon
Date: Thu, 31 Mar 2011 17:36:42 -0400
Message-ID: <1301607405-4379-3-git-send-email-jlayton@redhat.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607405-4379-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 1622978..4f5c6d0 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -106,7 +106,7 @@ static void mark_open_files_invalid(struct cifs_tcon *pTcon)
 static int
 cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 {
-	int rc = 0;
+	int rc;
 	struct cifs_ses *ses;
 	struct TCP_Server_Info *server;
 	struct nls_table *nls_codepage;
-- 
1.7.4
