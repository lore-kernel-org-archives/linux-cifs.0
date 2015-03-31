From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] CIFS: session servername can't be null
Date: Mon, 30 Mar 2015 19:07:24 -0500
Message-ID: <CAH2r5mvEfJLo_zM0bYfxoHo=MLoUZUvVce-4ShiqXKr9qWOf0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

(updated incorporating a suggestion of Jeff's)

remove impossible check

Pointed out by Coverity (CID 115422)

Signed-off-by: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 fs/cifs/cifsencrypt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 4ac7445..aa0dc25 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -1,6 +1,9 @@
 /*
  *   fs/cifs/cifsencrypt.c
  *
+ *   Encryption and hashing operations relating to NTLM, NTLMv2.  See MS-NLMP
+ *   for more detailed information
+ *
  *   Copyright (C) International Business Machines  Corp., 2005,2013
  *   Author(s): Steve French (sfrench-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org)
  *
@@ -515,7 +518,8 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses,
char *ntlmv2_hash,
                  __func__);
             return rc;
         }
-    } else if (ses->serverName) {
+    } else {
+        /* We use ses->serverName if no domain name available */
         len = strlen(ses->serverName);

         server = kmalloc(2 + (len * 2), GFP_KERNEL);

-- 
Thanks,

Steve
