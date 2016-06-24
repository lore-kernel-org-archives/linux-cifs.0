From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] [SMB3] Avoid possible deadlock in previous patch
Date: Thu, 23 Jun 2016 23:30:47 -0500
Message-ID: <1466742647-9805-2-git-send-email-smfrench@gmail.com>
References: <1466742647-9805-1-git-send-email-smfrench@gmail.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466742647-9805-1-git-send-email-smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Steve French <steve.french-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 4030cbd..f2cbb28 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1831,8 +1831,11 @@ SMB2_echo(struct TCP_Server_Info *server)
 				tcon = list_entry(tmp2, struct cifs_tcon,
 						  tcon_list);
 				/* add check for persistent handle reconnect */
-				if (tcon && tcon->need_reconnect)
+				if (tcon && tcon->need_reconnect) {
+					spin_unlock(&cifs_tcp_ses_lock);
 					rc = smb2_reconnect(SMB2_ECHO, tcon);
+					spin_lock(&cifs_tcp_ses_lock);
+				}
 			}
 		}
 		spin_unlock(&cifs_tcp_ses_lock);
-- 
1.9.1
