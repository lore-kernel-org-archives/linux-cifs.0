Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3519BC54EE9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Sep 2022 00:57:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbiIWA5B (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 20:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbiIWA5A (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 20:57:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E717AB443F
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 17:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663894618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CIYQeQs3CcsHZK/dUkYCVY8gYnTd9wuOK6X6fCOR3nE=;
        b=BzpQcBdMyByW2fTzFOa2yARvM6BfH9NXhW5E2bpcGEDnn2NAXB6JeTrBl0Df0vHGNJpgff
        qKscwV1UXM1HiF5emb2GOTwTFuqu+WvlOhK/RF9PVdbiW52s4pxHSYnis3as0/FJxKltKw
        P+/dKXx3Ed1scnSX5YGW06sFJ16PELQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-48-9uhDBnEOMJ2XIt1SKXp4bQ-1; Thu, 22 Sep 2022 20:56:53 -0400
X-MC-Unique: 9uhDBnEOMJ2XIt1SKXp4bQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 50C8029AA38A;
        Fri, 23 Sep 2022 00:56:53 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-22.bne.redhat.com [10.64.52.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4AF55492B04;
        Fri, 23 Sep 2022 00:56:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Steve French <stfrench@microsoft.com>
Subject: [PATCH 1/2] cifs: find and use the dentry for cached non-root directories also
Date:   Fri, 23 Sep 2022 10:56:35 +1000
Message-Id: <20220923005636.626014-2-lsahlber@redhat.com>
In-Reply-To: <20220923005636.626014-1-lsahlber@redhat.com>
References: <20220923005636.626014-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This allows us to use cached attributes for the entries in a cached
directory for as long as a lease is held on the directory itself.
Previously we have always allowed "used cached attributes for 1 second"
but this extends this to the lifetime of the lease as well as making the
caching safer.

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
---
 fs/cifs/cached_dir.c | 63 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 49 insertions(+), 14 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index 0f62e37b4251..e2f2052dbabf 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -5,6 +5,7 @@
  *  Copyright (c) 2022, Ronnie Sahlberg <lsahlber@redhat.com>
  */
 
+#include <linux/namei.h>
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -59,6 +60,44 @@ static struct cached_fid *find_or_create_cached_dir(struct cached_fids *cfids,
 	return cfid;
 }
 
+static struct dentry *
+path_to_dentry(struct cifs_sb_info *cifs_sb, const char *path)
+{
+	struct dentry *dentry;
+	const char *s, *p;
+	char sep;
+
+	sep = CIFS_DIR_SEP(cifs_sb);
+	dentry = dget(cifs_sb->root);
+	s = path;
+
+	do {
+		struct inode *dir = d_inode(dentry);
+		struct dentry *child;
+
+		if (!S_ISDIR(dir->i_mode)) {
+			dput(dentry);
+			dentry = ERR_PTR(-ENOTDIR);
+			break;
+		}
+
+		/* skip separators */
+		while (*s == sep)
+			s++;
+		if (!*s)
+			break;
+		p = s++;
+		/* next separator */
+		while (*s && *s != sep)
+			s++;
+
+		child = lookup_positive_unlocked(p, dentry, s - p);
+		dput(dentry);
+		dentry = child;
+	} while (!IS_ERR(dentry));
+	return dentry;
+}
+
 /*
  * Open the and cache a directory handle.
  * If error then *cfid is not initialized.
@@ -86,7 +125,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	struct cached_fid *cfid;
 	struct cached_fids *cfids;
 
-
 	if (tcon == NULL || tcon->cfids == NULL || tcon->nohandlecache ||
 	    is_smb1_server(tcon->ses->server))
 		return -EOPNOTSUPP;
@@ -101,13 +139,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
-	/*
-	 * TODO: for better caching we need to find and use the dentry also
-	 * for non-root directories.
-	 */
-	if (!path[0])
-		dentry = cifs_sb->root;
-
 	utf16_path = cifs_convert_path_to_utf16(path, cifs_sb);
 	if (!utf16_path)
 		return -ENOMEM;
@@ -199,12 +230,6 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	oparms.fid->mid = le64_to_cpu(o_rsp->hdr.MessageId);
 #endif /* CIFS_DEBUG2 */
 
-	cfid->tcon = tcon;
-	if (dentry) {
-		cfid->dentry = dentry;
-		dget(dentry);
-	}
-	/* BB TBD check to see if oplock level check can be removed below */
 	if (o_rsp->OplockLevel != SMB2_OPLOCK_LEVEL_LEASE) {
 		goto oshr_free;
 	}
@@ -223,6 +248,16 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 				&rsp_iov[1], sizeof(struct smb2_file_all_info),
 				(char *)&cfid->file_all_info))
 		cfid->file_all_info_is_valid = true;
+
+	if (!path[0])
+		dentry = dget(cifs_sb->root);
+	else {
+		dentry = path_to_dentry(cifs_sb, path);
+		if (IS_ERR(dentry))
+			goto oshr_free;
+	}
+	cfid->dentry = dentry;
+	cfid->tcon = tcon;
 	cfid->time = jiffies;
 	cfid->is_open = true;
 	cfid->has_lease = true;
-- 
2.35.3

