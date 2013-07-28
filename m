From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] cifs: arrays are never NULL
Date: Sun, 28 Jul 2013 23:26:09 +0300
Message-ID: <20130728202609.GB8684@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	kernel-janitors@vger.kernel.org
To: Steve French <sfrench@samba.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

It causes a static analysis warning when check to see if an array is
NULL.  I have removed the check.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Or perhaps the intent was to check

	} else if (strlen(ses->serverName)) {

I am not very familiar with this code.

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index bb84d7c..16f4908 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -514,7 +514,7 @@ static int calc_ntlmv2_hash(struct cifs_ses *ses, char *ntlmv2_hash,
 				 __func__);
 			return rc;
 		}
-	} else if (ses->serverName) {
+	} else {
 		len = strlen(ses->serverName);
 
 		server = kmalloc(2 + (len * 2), GFP_KERNEL);
