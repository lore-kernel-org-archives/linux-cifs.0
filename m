From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] CIFS: use correct format string for size_t
Date: Thu,  2 Feb 2017 13:21:00 +0100
Message-ID: <20170202122117.1404479-1-arnd@arndb.de>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>,
        Pavel Shilovsky <pshilov-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
        Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>,
        Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This warning is harmless as size_t is always as wide as 'unsigned long':

fs/cifs/smb2ops.c:2008:245: error: format '%lu' expects argument of type 'long unsigned int', but argument 5 has type 'size_t {aka unsigned int}' [-Werror=format=]

Using %zu however is the correct format string that we don't get a warning for.

Fixes: c9d651a5a2fe ("CIFS: Decrypt and process small encrypted packets")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 fs/cifs/smb2ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 0764c32754b0..ac6e10adf000 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -2005,7 +2005,7 @@ handle_read_data(struct TCP_Server_Info *server, struct mid_q_entry *mid,
 	rdata->iov[0].iov_len = 4;
 	rdata->iov[1].iov_base = buf + 4;
 	rdata->iov[1].iov_len = server->vals->read_rsp_size - 4;
-	cifs_dbg(FYI, "0: iov_base=%p iov_len=%lu\n",
+	cifs_dbg(FYI, "0: iov_base=%p iov_len=%zu\n",
 		 rdata->iov[0].iov_base, server->vals->read_rsp_size);
 
 	length = rdata->copy_into_pages(server, rdata, &iter);
-- 
2.9.0
