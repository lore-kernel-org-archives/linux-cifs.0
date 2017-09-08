From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: check rsp for NULL before dereferencing in SMB2_open
Date: Fri,  8 Sep 2017 10:37:35 +1000
Message-ID: <20170908003735.14789-1-lsahlber@redhat.com>
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In SMB2_open there are several paths where the SendReceive2
call will return an error before it sets rsp_iov.iov_base
thus leaving iov_base uninitialized.

Thus we need to check rsp before we dereference it in
the call to get_rfc1002_length().

A report of this issue was previously reported in
http://www.spinics.net/lists/linux-cifs/msg12846.html

RH-bugzilla : 1476151

Version 2 :
* Lets properly initialize rsp_iov before we use it.

Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/smb2pdu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 97edb4d376cd..6e7d145d8b2f 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -1617,7 +1617,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 	struct cifs_tcon *tcon = oparms->tcon;
 	struct cifs_ses *ses = tcon->ses;
 	struct kvec iov[4];
-	struct kvec rsp_iov;
+	struct kvec rsp_iov = {NULL, 0};
 	int resp_buftype;
 	int uni_path_len;
 	__le16 *copy_path = NULL;
@@ -1746,7 +1746,7 @@ SMB2_open(const unsigned int xid, struct cifs_open_parms *oparms, __le16 *path,
 
 	if (rc != 0) {
 		cifs_stats_fail_inc(tcon, SMB2_CREATE_HE);
-		if (err_buf)
+		if (err_buf && rsp)
 			*err_buf = kmemdup(rsp, get_rfc1002_length(rsp) + 4,
 					   GFP_KERNEL);
 		goto creat_exit;
-- 
2.13.3
