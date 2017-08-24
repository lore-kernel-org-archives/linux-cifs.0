From: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
Subject: [PATCH] CIFS: Fix maximum SMB2 header size
Date: Thu, 24 Aug 2017 15:16:40 -0700
Message-ID: <1503613000-2319-1-git-send-email-pshilov@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
        Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Currently the maximum size of SMB2/3 header is set incorrectly which
leads to hanging of directory listing operations on encrypted SMB3
connections. Fix this by setting the maximum size to 170 bytes that
is calculated as RFC1002 length field size (4) + transform header
size (52) + SMB2 header size (64) + create response size (56).

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Signed-off-by: Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>
---
 fs/cifs/smb2pdu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
index 18700fd..2826882 100644
--- a/fs/cifs/smb2pdu.h
+++ b/fs/cifs/smb2pdu.h
@@ -84,8 +84,8 @@
 
 #define NUMBER_OF_SMB2_COMMANDS	0x0013
 
-/* BB FIXME - analyze following length BB */
-#define MAX_SMB2_HDR_SIZE 0x78 /* 4 len + 64 hdr + (2*24 wct) + 2 bct + 2 pad */
+/* 4 len + 52 transform hdr + 64 hdr + 56 create rsp */
+#define MAX_SMB2_HDR_SIZE 0x00b0
 
 #define SMB2_PROTO_NUMBER cpu_to_le32(0x424d53fe)
 #define SMB2_TRANSFORM_PROTO_NUM cpu_to_le32(0x424d53fd)
-- 
2.7.4
