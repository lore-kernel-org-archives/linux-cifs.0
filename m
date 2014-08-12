From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write response
Date: Tue, 12 Aug 2014 09:19:42 -0500
Message-ID: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Writes fail to Mac servers with SMB2.1 mounts (works with cifs though) due
to them sending an incorrect RFC1001 length. Workaround this problem.
MacOS server sends a write response with 3 bytes of pad beyond the end
of the SMB itself.  The RFC1001 length is 3 bytes more than
the sum of the SMB2.1 header length + the write reponse.

Since we have seen a few other examples where servers have
padded responses strangely (oplock break and create),
allow servers to send a padded SMB2/SMB3 response to allow
for rounding (up to 15 bytes).

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/smb2misc.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
index f2e6ac2..da05beb 100644
--- a/fs/cifs/smb2misc.c
+++ b/fs/cifs/smb2misc.c
@@ -181,6 +181,12 @@ smb2_check_message(char *buf, unsigned int length)
         /* server can return one byte more */
         if (clc_len == 4 + len + 1)
             return 0;
+
+        /* MacOS server pads after SMB2.1 write response with 3 bytes */
+        /* of junk. Allow server to pad up to 15 bytes of junk at end */
+        if ((clc_len < 4 + len) && (clc_len > 4 + len - 16))
+            return 0;
+
         return 1;
     }
     return 0;

-- 
Thanks,

Steve
