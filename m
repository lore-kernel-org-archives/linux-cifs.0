Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4123FC4332E
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 107E8652BB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230039AbhCHXIZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:08:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhCHXH4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=K5SY4vh5dWvxmic2TwQVghVkdghisbxFUamT5maed74=;
        b=dymD37/8YymL9HllLb9DETcpjoAZBPcrp5fBfVJ1cp0rKVXoIA07tNN6VfUXaNV8EAKsKs
        KYiUkLY/S3oB5RkHy6ThwrdTGgwJs6+0Qd3XwOM0mnh3yipCRdxLcadZ0tMVovhRxhL5mm
        0qDjI3ITqOSDcBfmo2BvsnEEByN+WWY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-109-E4YX-y-5NwKAz4odAGr9CA-1; Mon, 08 Mar 2021 18:07:53 -0500
X-MC-Unique: E4YX-y-5NwKAz4odAGr9CA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D6F171005D4A;
        Mon,  8 Mar 2021 23:07:52 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 71C5C6062F;
        Mon,  8 Mar 2021 23:07:52 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 8/9] cifs: pass the dentry instead of the inode down to the revalidation check functions
Date:   Tue,  9 Mar 2021 09:07:34 +1000
Message-Id: <20210308230735.337-9-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 0b0b01ef3ecb..98dc6d70d4fa 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2184,8 +2184,9 @@ cifs_rename2(struct inode *source_dir, struct dentry *source_dentry,
 }
 
 static bool
-cifs_inode_needs_reval(struct inode *inode)
+cifs_dentry_needs_reval(struct dentry *dentry)
 {
+	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
 
@@ -2296,10 +2297,10 @@ cifs_zap_mapping(struct inode *inode)
 int cifs_revalidate_file_attr(struct file *filp)
 {
 	int rc = 0;
-	struct inode *inode = file_inode(filp);
+	struct dentry *dentry = file_dentry(filp);
 	struct cifsFileInfo *cfile = (struct cifsFileInfo *) filp->private_data;
 
-	if (!cifs_inode_needs_reval(inode))
+	if (!cifs_dentry_needs_reval(dentry))
 		return rc;
 
 	if (tlink_tcon(cfile->tlink)->unix_ext)
@@ -2322,7 +2323,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	if (inode == NULL)
 		return -ENOENT;
 
-	if (!cifs_inode_needs_reval(inode))
+	if (!cifs_dentry_needs_reval(dentry))
 		return rc;
 
 	xid = get_xid();
-- 
2.13.6

