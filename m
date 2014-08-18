From: Raphael Geissert <geissert-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] [CIFS] Remove unneeded check for tcon in SMB2_flush
Date: Mon, 18 Aug 2014 22:23:37 +0200
Message-ID: <2036698.Wh45l6gMXh@eee>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While poking at the code I found what looks like a leftover check for
tcon in SMB2_flush.

SMB2_flush dereferences tcon->ses at the beginning of the function, but
later one it checks for ((rc != 0) && tcon).
All the code in between appears to properly check tcon for NULLness,
but the only caller I found via ops->flush also dereferences tcon on
its own.
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 240c627..c149385 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1629,7 +1629,7 @@ SMB2_flush(const unsigned int xid, struct cifs_tcon *tcon, u64 persistent_fid,

        rc = SendReceive2(xid, ses, iov, 1, &resp_buftype, 0);

-       if ((rc != 0) && tcon)
+       if (rc != 0)
                cifs_stats_fail_inc(tcon, SMB2_FLUSH_HE);

        free_rsp_buf(resp_buftype, iov[0].iov_base);
-- 
1.9.1
