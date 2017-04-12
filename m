From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Fix SMB3 mount without specifying a security mechanism
Date: Wed, 12 Apr 2017 13:32:07 -0700
Message-ID: <1492029127-4524-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit ef65aaede23f ("smb2: Enforce sec= mount option") changed the
behavior of a mount command to enforce a specified security mechanism
during mounting. On another hand according to the spec if SMB3 server
doesn't respond with a security context it implies that it supports
NTLMSSP. The current code doesn't keep it in mind and fails a mount
for such servers if no security mechanism is specified. Fix this by
indicating that a server supports NTLMSSP if a security context isn't
returned during negotiate phase. This allows the code to use NTLMSSP
by default for SMB3 mounts.

Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 1bd5d30..02da648 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -562,8 +562,10 @@ SMB2_negotiate(const unsigned int xid, struct cifs_ses *ses)
 	 * but for time being this is our only auth choice so doesn't matter.
 	 * We just found a server which sets blob length to zero expecting raw.
 	 */
-	if (blob_length == 0)
+	if (blob_length == 0) {
 		cifs_dbg(FYI, "missing security blob on negprot\n");
+		server->sec_ntlmssp = true;
+	}
 
 	rc = cifs_enable_signing(server, ses->sign);
 	if (rc)
-- 
2.7.4
