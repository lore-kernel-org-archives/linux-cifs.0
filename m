From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cifs: turn BCC into a static inlined function
Date: Thu, 31 Mar 2011 17:36:41 -0400
Message-ID: <1301607405-4379-2-git-send-email-jlayton@redhat.com>
References: <1301607405-4379-1-git-send-email-jlayton@redhat.com>
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1301607405-4379-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It's a bad idea to have macro functions that reference variables more
than once, as the arguments could have side effects. Turn BCC() into
a static inlined function instead.

While we're at it, make it return a void * to discourage anyone from
dereferencing it as-is.

Reported-and-acked-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 291d735..de3aa28 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -428,9 +428,12 @@ struct smb_hdr {
 	__u8 WordCount;
 } __attribute__((packed));
 
-/* given a pointer to an smb_hdr retrieve a char pointer to the byte count */
-#define BCC(smb_var) ((unsigned char *)(smb_var) + sizeof(struct smb_hdr) + \
-			 (2 * (smb_var)->WordCount))
+/* given a pointer to an smb_hdr, retrieve a void pointer to the ByteCount */
+static inline void *
+BCC(struct smb_hdr *smb)
+{
+	return (void *)smb + sizeof(*smb) + 2 * smb->WordCount;
+}
 
 /* given a pointer to an smb_hdr retrieve the pointer to the byte area */
 #define pByteArea(smb_var) (BCC(smb_var) + 2)
-- 
1.7.4
