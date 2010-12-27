From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/18] cifs: don't reconnect server when we don't get a response
Date: Sun, 26 Dec 2010 21:29:56 -0500
Message-ID: <1293417006-6417-9-git-send-email-jlayton@redhat.com>
References: <1293417006-6417-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293417006-6417-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We only want to force a reconnect to the server under very limited and
specific circumstances. Now that we have processes waiting indefinitely
for responses, we shouldn't reach this point unless a reconnect is
already in process. Thus, there's no reason to re-mark the server for
reconnect here.

Reviewed-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Reviewed-by:  Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index c41c9c4..f65cdec 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -374,10 +374,8 @@ sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
 	if (mid->midState == MID_REQUEST_SUBMITTED) {
 		if (server->tcpStatus == CifsExiting)
 			rc = -EHOSTDOWN;
-		else {
-			server->tcpStatus = CifsNeedReconnect;
+		else
 			mid->midState = MID_RETRY_NEEDED;
-		}
 	}
 
 	if (rc != -EHOSTDOWN) {
-- 
1.7.3.4
