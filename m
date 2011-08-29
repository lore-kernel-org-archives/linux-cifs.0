From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 08/16] cifs: keep a reusable kvec array for receives
Date: Mon, 29 Aug 2011 07:16:56 -0400
Message-ID: <1314616624-5362-9-git-send-email-jlayton@redhat.com>
References: <1314616624-5362-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314616624-5362-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Having to continually allocate a new kvec array is expensive. Allocate
one that's big enough, and only reallocate it as needed. Also, we need
to use GFP_NOFS here to ensure that this doesn't deadlock.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifsglob.h |    2 ++
 fs/cifs/connect.c  |   26 ++++++++++++++++++++------
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index a37452d..c3caa78 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -287,6 +287,8 @@ struct TCP_Server_Info {
 	bool	sec_kerberos;		/* supports plain Kerberos */
 	bool	sec_mskerberos;		/* supports legacy MS Kerberos */
 	struct delayed_work	echo; /* echo ping workqueue job */
+	struct kvec *iov;	/* reusable kvec array for receives */
+	unsigned int nr_iov;	/* number of kvecs in array */
 #ifdef CONFIG_CIFS_FSCACHE
 	struct fscache_cookie   *fscache; /* client index cache cookie */
 #endif
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 08c6b0e..e16c04b 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -410,6 +410,24 @@ kvec_array_init(struct kvec *new, struct kvec *iov, unsigned int nr_segs,
 	return nr_segs;
 }
 
+static struct kvec *
+get_server_iovec(struct TCP_Server_Info *server, unsigned int nr_segs)
+{
+	struct kvec *new_iov;
+
+	if (server->iov && nr_segs <= server->nr_iov)
+		return server->iov;
+
+	/* not big enough -- allocate a new one and release the old */
+	new_iov = kmalloc(sizeof(*new_iov) * nr_segs, GFP_NOFS);
+	if (new_iov) {
+		kfree(server->iov);
+		server->iov = new_iov;
+		server->nr_iov = nr_segs;
+	}
+	return new_iov;
+}
+
 static int
 readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 		  unsigned int nr_segs, unsigned int to_read)
@@ -420,11 +438,7 @@ readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 	struct msghdr smb_msg;
 	struct kvec *iov;
 
-	/*
-	 * FIXME: allocation here may cause deadlocks under memory pressure.
-	 * Switch this to use a fixed, per-socket buffer.
-	 */
-	iov = kmalloc(sizeof(*iov_orig) * nr_segs, GFP_KERNEL);
+	iov = get_server_iovec(server, nr_segs);
 	if (!iov)
 		return -ENOMEM;
 
@@ -468,7 +482,6 @@ readv_from_socket(struct TCP_Server_Info *server, struct kvec *iov_orig,
 			break;
 		}
 	}
-	kfree(iov);
 	return total_read;
 }
 
@@ -686,6 +699,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
 	}
 
 	kfree(server->hostname);
+	kfree(server->iov);
 	kfree(server);
 
 	length = atomic_dec_return(&tcpSesAllocCount);
-- 
1.7.6
