From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: [PATCH 5/6] cifs_readv_receive: use cifs_read_from_socket()
Date: Sat, 9 Apr 2016 21:52:36 +0100
Message-ID: <20160409205236.GK25498@ZenIV.linux.org.uk>
References: <20160409204301.GF25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160409204301.GF25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
---
 fs/cifs/cifssmb.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 76fcb50..3da077a 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -1447,10 +1447,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = min_t(unsigned int, buflen, server->vals->read_rsp_size) -
 							HEADER_SIZE(server) + 1;
 
-	rdata->iov.iov_base = buf + HEADER_SIZE(server) - 1;
-	rdata->iov.iov_len = len;
-
-	length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
+	length = cifs_read_from_socket(server,
+				       buf + HEADER_SIZE(server) - 1, len);
 	if (length < 0)
 		return length;
 	server->total_read += length;
@@ -1502,9 +1500,8 @@ cifs_readv_receive(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	len = data_offset - server->total_read;
 	if (len > 0) {
 		/* read any junk before data into the rest of smallbuf */
-		rdata->iov.iov_base = buf + server->total_read;
-		rdata->iov.iov_len = len;
-		length = cifs_readv_from_socket(server, &rdata->iov, 1, len);
+		length = cifs_read_from_socket(server,
+					       buf + server->total_read, len);
 		if (length < 0)
 			return length;
 		server->total_read += length;
-- 
2.8.0.rc3
