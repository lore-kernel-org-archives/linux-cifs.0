From: Colin King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] cifs: remove redundant check for null string pointer
Date: Mon, 25 Jan 2016 16:25:54 +0000
Message-ID: <1453739154-23796-1-git-send-email-colin.king@canonical.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

From: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

server_RFC1001_name is declared as a RFC1001_NAME_LEN_WITH_NULL sized
char array in struct TCP_Server_Info so the null pointer check on
server_RFC1001_name is redundant and can be removed.  Detected with
smatch:

fs/cifs/connect.c:2982 ip_rfc1001_connect() warn: this array is probably
  non-NULL. 'server->server_RFC1001_name'

Signed-off-by: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
---
 fs/cifs/connect.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 4fbd92d..a763cd3 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2999,8 +2999,7 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
 	if (ses_init_buf) {
 		ses_init_buf->trailer.session_req.called_len = 32;
 
-		if (server->server_RFC1001_name &&
-		    server->server_RFC1001_name[0] != 0)
+		if (server->server_RFC1001_name[0] != 0)
 			rfc1002mangle(ses_init_buf->trailer.
 				      session_req.called_name,
 				      server->server_RFC1001_name,
-- 
2.7.0.rc3
