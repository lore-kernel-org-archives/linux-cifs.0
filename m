From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: switch CIFSSMBQAllEAs to use memcmp
Date: Fri, 19 Aug 2011 21:18:24 -0400
Message-ID: <1313803104-31810-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...as that's more efficient when we know that the lengths are equal.

Reported-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifssmb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index f4d0988..7bac906 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -5849,7 +5849,7 @@ QAllEAsRetry:
 
 		if (ea_name) {
 			if (ea_name_len == name_len &&
-			    strncmp(ea_name, temp_ptr, name_len) == 0) {
+			    memcmp(ea_name, temp_ptr, name_len) == 0) {
 				temp_ptr += name_len + 1;
 				rc = value_len;
 				if (buf_size == 0)
-- 
1.7.6
