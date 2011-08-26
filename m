From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] cifs: fix protocol definition for READ_RSP
Date: Fri, 26 Aug 2011 15:18:14 -0400
Message-ID: <1314386298-27424-2-git-send-email-jlayton@redhat.com>
References: <1314386298-27424-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1314386298-27424-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

There is no pad, and it simplifies the code to remove the "Data" field.

None of the existing code relies on these fields, or on the READ_RSP
being a particular length.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/cifspdu.h |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index de3aa28..3c6ef34 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -1089,9 +1089,7 @@ typedef struct smb_com_read_rsp {
 	__le16 DataLengthHigh;
 	__u64 Reserved2;
 	__u16 ByteCount;
-	__u8 Pad;		/* BB check for whether padded to DWORD
-				   boundary and optimum performance here */
-	char Data[1];
+	/* read response data immediately follows */
 } __attribute__((packed)) READ_RSP;
 
 typedef struct locking_andx_range {
-- 
1.7.6
