From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 05/13] cifs: don't reconnect server when we don't get a response
Date: Fri, 10 Dec 2010 10:44:29 -0500
Message-ID: <1291995877-2276-6-git-send-email-jlayton@redhat.com>
References: <1291995877-2276-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291995877-2276-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We only want to force a reconnect to the server under very limited and
specific circumstances. Now that we have processes waiting indefinitely
for responses, we shouldn't reach this point unless a reconnect is
already in process. Thus, there's no reason to re-mark the server for
reconnect here.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/transport.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 989674c..0c0dadd 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -367,10 +367,8 @@ handle_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
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
1.7.3.2
