From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: attempt to freeze while looping on a receive attempt
Date: Thu,  1 Dec 2011 20:22:41 -0500
Message-ID: <1322788961-22590-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In the recent overhaul of the demultiplex thread receive path, I
neglected to ensure that we attempt to freeze on each pass through the
receive loop.

Reported-and-Tested-by: Woody Suwalski <terraluna977-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reported-and-Tested-by: Adam Williamson <awilliam-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index bf82f88..d166e3a 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -441,6 +441,8 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 	smb_msg.msg_controllen = 0;
 
 	for (total_read = 0; to_read; total_read += length, to_read -= length) {
+		try_to_freeze();
+
 		if (server_unresponsive(server)) {
 			total_read = -EAGAIN;
 			break;
-- 
1.7.6.4
