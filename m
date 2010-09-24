From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] cifs: fix module refcount leak in find_domain_name
Date: Fri, 24 Sep 2010 08:58:32 -0400
Message-ID: <1285333112-9040-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

find_domain_name() uses load_nls_default which takes a module reference
on the appropriate NLS module, but doesn't put it.

Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/cifsencrypt.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index 388ebe3..ccb13e6 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -363,13 +363,16 @@ find_domain_name(struct cifsSesInfo *ses)
 			if (!attrsize)
 				break;
 			if (!ses->domainName) {
+				struct nls_table *default_nls;
 				ses->domainName =
 					kmalloc(attrsize + 1, GFP_KERNEL);
 				if (!ses->domainName)
 						return -ENOMEM;
+				default_nls = load_nls_default();
 				cifs_from_ucs2(ses->domainName,
 					(__le16 *)blobptr, attrsize, attrsize,
-					load_nls_default(), false);
+					default_nls, false);
+				unload_nls(default_nls);
 				break;
 			}
 		}
-- 
1.7.2.3
