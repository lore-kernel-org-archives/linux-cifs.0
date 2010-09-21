From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: allow matching of tcp sessions in CifsNew state
Date: Tue, 21 Sep 2010 08:14:46 -0700
Message-ID: <1285082086-15042-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

With commit 7332f2a6217ee6925f83ef0e725013067ed316ba, cifsd will no
longer exit when the socket abends and the tcpStatus is CifsNew. With
that change, there's no reason to avoid matching an existing session in
this state.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 435b912..271038b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -1511,15 +1511,6 @@ cifs_find_tcp_session(struct sockaddr *addr, struct smb_vol *vol)
 
 	write_lock(&cifs_tcp_ses_lock);
 	list_for_each_entry(server, &cifs_tcp_ses_list, tcp_ses_list) {
-		/*
-		 * the demux thread can exit on its own while still in CifsNew
-		 * so don't accept any sockets in that state. Since the
-		 * tcpStatus never changes back to CifsNew it's safe to check
-		 * for this without a lock.
-		 */
-		if (server->tcpStatus == CifsNew)
-			continue;
-
 		if (!match_address(server, addr,
 				   (struct sockaddr *)&vol->srcaddr))
 			continue;
-- 
1.7.3
