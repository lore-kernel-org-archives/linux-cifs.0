From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] SMB2: Fix share type handling
Date: Mon, 21 Nov 2016 22:53:52 +0100
Message-ID: <20161121215352.3183-1-christophe.jaillet@wanadoo.fr>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: sfrench@samba.org
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

In fs/cifs/smb2pdu.h, we have:
#define SMB2_SHARE_TYPE_DISK    0x01
#define SMB2_SHARE_TYPE_PIPE    0x02
#define SMB2_SHARE_TYPE_PRINT   0x03

Knowing that, with the current code, the SMB2_SHARE_TYPE_PRINT case can
never trigger and printer share would be interpreted as disk share.

So, test the ShareType value for equality instead.

While at it, add some { } to fix a small style issue.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
Compile-tested only.

The proposed patch changes a bit the semantic as no masking is performed
anymore. If some upper bits in 'ShareType' are set, it would now be rejected
instead of silently accepted.
---
 fs/cifs/smb2pdu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 5ca5ea4668a1..600f52994fd9 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1143,12 +1143,12 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
 		goto tcon_exit;
 	}
 
-	if (rsp->ShareType & SMB2_SHARE_TYPE_DISK)
+	if (rsp->ShareType == SMB2_SHARE_TYPE_DISK) {
 		cifs_dbg(FYI, "connection to disk share\n");
-	else if (rsp->ShareType & SMB2_SHARE_TYPE_PIPE) {
+	} else if (rsp->ShareType == SMB2_SHARE_TYPE_PIPE) {
 		tcon->ipc = true;
 		cifs_dbg(FYI, "connection to pipe share\n");
-	} else if (rsp->ShareType & SMB2_SHARE_TYPE_PRINT) {
+	} else if (rsp->ShareType == SMB2_SHARE_TYPE_PRINT) {
 		tcon->print = true;
 		cifs_dbg(FYI, "connection to printer\n");
 	} else {
-- 
2.9.3

