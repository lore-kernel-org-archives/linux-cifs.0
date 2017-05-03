From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 2/2] cifs: fix leak in FSCTL_ENUM_SNAPS response handling
Date: Wed,  3 May 2017 17:39:09 +0200
Message-ID: <20170503153909.5783-3-ddiss@suse.de>
References: <20170503153909.5783-1-ddiss@suse.de>
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170503153909.5783-1-ddiss-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The server may respond with success, and an output buffer less than
sizeof(struct smb_snapshot_array) in length. Do not leak the output
buffer in this case.

Fixes: 834170c85978 ("Enable previous version support")
Signed-off-by: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
---
 fs/cifs/smb2ops.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 152e37f2ad92..c58691834eb2 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -942,6 +942,7 @@ smb3_enum_snapshots(const unsigned int xid, struct cifs_tcon *tcon,
 		}
 		if (snapshot_in.snapshot_array_size < sizeof(struct smb_snapshot_array)) {
 			rc = -ERANGE;
+			kfree(retbuf);
 			return rc;
 		}
 
-- 
2.12.0
