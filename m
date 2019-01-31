From: Aurelien Aptel <aaptel@suse.com>
Subject: [PATCH] CIFS: fix use-after-free of the lease keys
Date: Thu, 31 Jan 2019 13:46:07 +0100
Message-ID: <20190131124607.2458-1-aaptel@suse.com>
Cc: smfrench@gmail.com, Aurelien Aptel <aaptel@suse.com>,
        stable@vger.kernel.org
To: linux-cifs@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The request buffers are freed right before copying the pointers.
Use the func args instead which are identical and still valid.

Simple reproducer (requires KASAN enabled) on a cifs mount:

echo foo > foo ; tail -f foo & rm foo

Cc: <stable@vger.kernel.org> # 4.20
Fixes: 179e44d49c2f ("smb3: add tracepoint for sending lease break responses to server")
Signed-off-by: Aurelien Aptel <aaptel@suse.com>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 846e605175bf..54181387a770 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -4435,8 +4435,8 @@ SMB2_lease_break(const unsigned int xid, struct cifs_tcon *tcon,
 	rc = cifs_send_recv(xid, ses, &rqst, &resp_buf_type, flags, &rsp_iov);
 	cifs_small_buf_release(req);
 
-	please_key_low = (__u64 *)req->LeaseKey;
-	please_key_high = (__u64 *)(req->LeaseKey+8);
+	please_key_low = (__u64 *)lease_key;
+	please_key_high = (__u64 *)(lease_key+8);
 	if (rc) {
 		cifs_stats_fail_inc(tcon, SMB2_OPLOCK_BREAK_HE);
 		trace_smb3_lease_err(le32_to_cpu(lease_state), tcon->tid,
-- 
2.16.4
