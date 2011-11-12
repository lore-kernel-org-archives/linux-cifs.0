From: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
Subject: [PATCH] cifs: Use kmemdup rather than duplicating its implementation
Date: Sat, 12 Nov 2011 10:22:34 +0100
Message-ID: <1321089754.20155.128.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Use kmemdup rather than duplicating its implementation

The semantic patch that makes this change is available
in scripts/coccinelle/api/memdup.cocci.

Signed-off-by: Thomas Meyer <thomas-VsYtu1Qij5c@public.gmane.org>
---

diff -u -p a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
--- a/fs/cifs/cifs_spnego.c 2011-11-07 19:38:22.023802738 +0100
+++ b/fs/cifs/cifs_spnego.c 2011-11-08 10:34:14.586074433 +0100
@@ -37,12 +37,11 @@ cifs_spnego_key_instantiate(struct key *
 	int ret;
 
 	ret = -ENOMEM;
-	payload = kmalloc(datalen, GFP_KERNEL);
+	payload = kmemdup(data, datalen, GFP_KERNEL);
 	if (!payload)
 		goto error;
 
 	/* attach the data */
-	memcpy(payload, data, datalen);
 	key->payload.data = payload;
 	ret = 0;
 
