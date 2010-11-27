From: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>
Subject: [PATCH 06/14] cifs: don't fail writepages on -EAGAIN errors
Date: Sat, 27 Nov 2010 08:01:18 -0500
Message-ID: <1290862886-2914-7-git-send-email-jlayton@redhat.com>
References: <1290862886-2914-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1290862886-2914-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

If CIFSSMBWrite2 returns -EAGAIN, then we should retry the write instead
of setting an error on the mapping and returning.

Note that I'm not 100% thrilled with this patch. If we have an
unresponsive server then we'll block in cifs_writepages for quite some
time, even in the WB_SYNC_NONE case. That said, we already block in this
function in the WB_SYNC_NONE case since CIFSSMBWrite2 is always
synchronous anyway, so I don't see this as causing any more harm than is
already done.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/file.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index b857ce5..cde1591 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -1432,6 +1432,7 @@ retry:
 				break;
 		}
 		if (n_iov) {
+retry_write:
 			open_file = find_writable_file(CIFS_I(mapping->host),
 							false);
 			if (!open_file) {
@@ -1447,6 +1448,9 @@ retry:
 				cifs_update_eof(cifsi, offset, bytes_written);
 			}
 
+			if (rc == -EAGAIN)
+				goto retry_write;
+
 			if (rc || bytes_written < bytes_to_write) {
 				cERROR(1, "Write2 ret %d, wrote %d",
 					  rc, bytes_written);
-- 
1.7.3.2
