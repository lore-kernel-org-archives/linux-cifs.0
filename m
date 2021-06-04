Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D847FC4743D
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 17:41:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF6BB613FA
	for <linux-cifs@archiver.kernel.org>; Fri,  4 Jun 2021 17:41:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhFDRmz (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 4 Jun 2021 13:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbhFDRmz (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 4 Jun 2021 13:42:55 -0400
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C42D3C061766
        for <linux-cifs@vger.kernel.org>; Fri,  4 Jun 2021 10:41:08 -0700 (PDT)
Received: by mail-qt1-x831.google.com with SMTP id k19so7610664qta.2
        for <linux-cifs@vger.kernel.org>; Fri, 04 Jun 2021 10:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=9iYgp/1wqToLbqfMR78Wid/TsRaatMV/NMkFIxUtEis=;
        b=MalPPmRmM6xZ+635Pgzsabmjl6cVHVdkP8zDqR0NGhw86cv5/ImD23Qs23fw4vfmoZ
         klIfFeJ1FepBFQrl8RoV8g6QkdRTTmaopXhb4Mo5l16ioz+GClmYls3+85piI/RHCeU+
         9DNnuB5Uq7nC28RQF0JD4AAclH9n2qfqowOw4auWj18tiffIOKbuC9wuStPFdNhWvU8y
         11YYvDIXn1FBCsn1eHOeCZf0rc2gfZsUHHIWTTgSszVQXFUYsWzYNuRh3sb0gvVIxskT
         2TW2tvVsoLYq3D4+zuEMe0bFths8JAleyJlE/TZoMhKIYpsktNDpn8XcEhmpRR4HLq3r
         PuTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9iYgp/1wqToLbqfMR78Wid/TsRaatMV/NMkFIxUtEis=;
        b=ccSCDf0r2909Kg1iqgHqQS3QYvtMXLRAac6hAd98Gvkz08QyNIr90yLs08EhgL30Lq
         9zFNm2PuoKZTXbZBLOQXtJcOMAZtMoR001RJqHzrCZSdbcV88MxyFOo30paDtMa++N8P
         5zRlzPrGlXNfwXWLKRZcQ90WK6TBUQeq4oKCRYJtDGLjHzuNIQkO3Dpyr9zQDqq8b/co
         a5Mr5UBuTuJ3DUwkHzcdGD26VZk5P8Q9zpLmw+7ivbRFnDTLvmICUnk0/eoG6Ubhkexr
         2AFRgUpZubgs01xNI+bDx0C9Wy/789sUtVtExrliZm59A6J1Jd1fdo9LBnxXQSyCWmT7
         3nIA==
X-Gm-Message-State: AOAM5327WO9Vi/tdYUvyyOHdbjBFH6tR8Bowzwh2mxB5m/Iric+RmXEd
        jqxHPuNpLYOggnG22Prn+ER4trM1E1wExUnr
X-Google-Smtp-Source: ABdhPJxYrf0TTgtNPy4ra3RZ7pNhuD1UkFRZ3nvaIsmo0ER3SVX4Slhy+GH9nnZnGCV8tcnt4K+l1Q==
X-Received: by 2002:a05:622a:4a:: with SMTP id y10mr5738142qtw.230.1622828467669;
        Fri, 04 Jun 2021 10:41:07 -0700 (PDT)
Received: from nyarly.rlyeh.local ([179.233.244.167])
        by smtp.gmail.com with ESMTPSA id 2sm3937115qtb.28.2021.06.04.10.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 10:41:07 -0700 (PDT)
Date:   Fri, 4 Jun 2021 14:41:02 -0300
From:   Thiago Rafael Becker <trbecker@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, samba-technical@lists.samba.org,
        tbecker@redhat.com, jshivers@redhat.com
Subject: [RFC PATCH] cifs: retry lookup and readdir when EAGAIN is returned.
Message-ID: <YLplrk3FQiUtVoWi@nyarly.rlyeh.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

According to the investigation performed by Jacob Shivers at Red Hat,
cifs_lookup and cifs_readdir leak EAGAIN when the user session is
deleted on the server. Fix this issue by implementing a retry with
limits, as is implemented in cifs_revalidate_dentry_attr.

Signed-off-by: Thiago Rafael Becker <trbecker@gmail.com>
---
 fs/cifs/dir.c     | 4 ++++
 fs/cifs/readdir.c | 6 ++++++
 2 files changed, 10 insertions(+)

diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index 6bcd3e8f7cda..7c641f9a3dac 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -630,6 +630,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	struct inode *newInode = NULL;
 	const char *full_path;
 	void *page;
+	int retry_count = 0;
 
 	xid = get_xid();
 
@@ -673,6 +674,7 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 	cifs_dbg(FYI, "Full path: %s inode = 0x%p\n",
 		 full_path, d_inode(direntry));
 
+again:
 	if (pTcon->posix_extensions)
 		rc = smb311_posix_get_inode_info(&newInode, full_path, parent_dir_inode->i_sb, xid);
 	else if (pTcon->unix_ext) {
@@ -687,6 +689,8 @@ cifs_lookup(struct inode *parent_dir_inode, struct dentry *direntry,
 		/* since paths are not looked up by component - the parent
 		   directories are presumed to be good here */
 		renew_parental_timestamps(direntry);
+	} else if (rc == -EAGAIN && retry_count++ < 10) {
+		goto again;
 	} else if (rc == -ENOENT) {
 		cifs_set_time(direntry, jiffies);
 		newInode = NULL;
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 63bfc533c9fb..01e6d41e387f 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -844,9 +844,15 @@ static int cifs_filldir(char *find_entry, struct file *file,
 	struct qstr name;
 	int rc = 0;
 	ino_t ino;
+	int retry_count = 0;
 
+again:
 	rc = cifs_fill_dirent(&de, find_entry, file_info->srch_inf.info_level,
 			      file_info->srch_inf.unicode);
+
+	if (rc == -EAGAIN && retry_count++ < 10)
+		goto again;
+
 	if (rc)
 		return rc;
 
-- 
2.31.1

