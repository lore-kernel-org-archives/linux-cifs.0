From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] cifs: fix broken BCC check in is_valid_oplock_break
Date: Wed, 16 Mar 2011 15:15:30 -0400
Message-ID: <1300302931-13830-2-git-send-email-jlayton@redhat.com>
References: <1300302931-13830-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300302931-13830-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The BCC is still __le16 at this point, and in any case we need to
use the get_bcc_le macro to make sure we don't hit alignment
problems.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/misc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 718268f..1640a6e 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -521,7 +521,7 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
 			(struct smb_com_transaction_change_notify_rsp *)buf;
 		struct file_notify_information *pnotify;
 		__u32 data_offset = 0;
-		if (pSMBr->ByteCount > sizeof(struct file_notify_information)) {
+		if (get_bcc_le(buf) > sizeof(struct file_notify_information)) {
 			data_offset = le32_to_cpu(pSMBr->DataOffset);
 
 			pnotify = (struct file_notify_information *)
-- 
1.7.4
