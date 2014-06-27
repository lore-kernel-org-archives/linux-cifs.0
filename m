From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2 01/16] CIFS: Fix async reading on reconnects
Date: Fri, 27 Jun 2014 13:57:38 +0400
Message-ID: <1403863073-19526-2-git-send-email-pshilovsky@samba.org>
References: <1403863073-19526-1-git-send-email-pshilovsky@samba.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1403863073-19526-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If we get into read_into_pages() from cifs_readv_receive() and then
loose a network, we issue cifs_reconnect that moves all mids to
a private list and issue their callbacks. The callback of the async
read request sets a mid to retry, frees it and wakes up a process
that waits on the rdata completion.

After the connection is established we return from read_into_pages()
with a short read, use the mid that was freed before and try to read
the remaining data from the a newly created socket. Both actions are
not what we want to do. In reconnect cases (-EAGAIN) we should not
mask off the error with a short read but should return the error
code instead.

Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index e90a1e9..6b6df30 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -2823,7 +2823,7 @@ cifs_uncached_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 ssize_t cifs_user_readv(struct kiocb *iocb, struct iov_iter *to)
@@ -3231,7 +3231,7 @@ cifs_readpages_read_into_pages(struct TCP_Server_Info *server,
 		total_read += result;
 	}
 
-	return total_read > 0 ? total_read : result;
+	return total_read > 0 && result != -EAGAIN ? total_read : result;
 }
 
 static int cifs_readpages(struct file *file, struct address_space *mapping,
-- 
1.8.1.2
