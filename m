From: Dia Vasile <winged.flamespitter@gmail.com>
Subject: [PATCH] cifs: replaced kmalloc + memset with kzalloc
Date: Sun, 10 Mar 2013 14:29:04 +0200
Message-ID: <1362918544-31796-1-git-send-email-winged.flamespitter@gmail.com>
Cc: linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
	samba-technical@lists.samba.org,
	Dia Vasile <kill.elohim@hotmail.com>
To: sfrench@samba.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

From: Dia Vasile <kill.elohim@hotmail.com>

Signed-off-by: Diana Vasile <kill.elohim@hotmail.com>
---
 fs/cifs/smb2pdu.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 41d9d07..83ef66e 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -846,12 +846,10 @@ create_lease_buf(u8 *lease_key, u8 oplock)
 {
 	struct create_lease *buf;
 
-	buf = kmalloc(sizeof(struct create_lease), GFP_KERNEL);
+	buf = kzalloc(sizeof(struct create_lease), GFP_KERNEL);
 	if (!buf)
 		return NULL;
 
-	memset(buf, 0, sizeof(struct create_lease));
-
 	buf->lcontext.LeaseKeyLow = cpu_to_le64(*((u64 *)lease_key));
 	buf->lcontext.LeaseKeyHigh = cpu_to_le64(*((u64 *)(lease_key + 8)));
 	if (oplock == SMB2_OPLOCK_LEVEL_EXCLUSIVE)
-- 
1.7.10.4
