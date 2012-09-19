From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: [PATCH] CIFS: Fix endian conversion of IndexNumber
Date: Wed, 19 Sep 2012 12:36:52 +0400
Message-ID: <1348043812-11375-1-git-send-email-piastry@etersoft.ru>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

by making it __le64 rather than __u64 in FILE_AL_INFO structure.

Signed-off-by: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
---
 fs/cifs/cifspdu.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifspdu.h b/fs/cifs/cifspdu.h
index 3fb03e2..b9d59a9 100644
--- a/fs/cifs/cifspdu.h
+++ b/fs/cifs/cifspdu.h
@@ -2210,7 +2210,7 @@ typedef struct { /* data block encoding of response to level 263 QPathInfo */
 	__u8 DeletePending;
 	__u8 Directory;
 	__u16 Pad2;
-	__u64 IndexNumber;
+	__le64 IndexNumber;
 	__le32 EASize;
 	__le32 AccessFlags;
 	__u64 IndexNumber1;
-- 
1.7.5.4
