From: Thomas Meyer <thomas@m3y3r.de>
Subject: [PATCH] cifs: Use kcalloc instead of kzalloc to allocate array
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.344.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
--- a/fs/cifs/cifssmb.c 2011-11-13 11:07:56.343959560 +0100
+++ b/fs/cifs/cifssmb.c 2011-11-28 19:47:15.006997976 +0100
@@ -2140,7 +2140,7 @@ cifs_async_writev(struct cifs_writedata
 		goto async_writev_out;
 
 	/* 1 iov per page + 1 for header */
-	iov = kzalloc((wdata->nr_pages + 1) * sizeof(*iov), GFP_NOFS);
+	iov = kcalloc(wdata->nr_pages + 1, sizeof(*iov), GFP_NOFS);
 	if (iov == NULL) {
 		rc = -ENOMEM;
 		goto async_writev_out;
