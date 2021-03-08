Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C872DC433DB
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B91064FB8
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 23:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhCHXHx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 18:07:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:56705 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhCHXHr (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 18:07:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615244866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=LOgKLEx8udn89jzrKoGF0NPeq7tNeDwRvj1/u3Rc4Q0=;
        b=bJbkA9MyZfCfca4y5/0m/FSCp+/tO5DEg4+G8zNkvqsh/IxxSFA9y3j4NkmNA2OwIUJv26
        6sW7+0YEthRuXJJtUY6en6bFTrJUqzAE4v6Pze+V+Z+UYTCSoI1ne8Q48+s6B+pjtOoOmO
        oKT9GeD3FvjBGxI7vTRBu2pKfwDGhEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-GquZNT9RN-KO-PkirFruNw-1; Mon, 08 Mar 2021 18:07:44 -0500
X-MC-Unique: GquZNT9RN-KO-PkirFruNw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E93981823DC7;
        Mon,  8 Mar 2021 23:07:43 +0000 (UTC)
Received: from test1103.test.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 832B26085A;
        Mon,  8 Mar 2021 23:07:43 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>
Subject: [PATCH 9/9] cifs: check the timestamp for the cached dirent when deciding on revalidate
Date:   Tue,  9 Mar 2021 09:07:35 +1000
Message-Id: <20210308230735.337-10-lsahlber@redhat.com>
In-Reply-To: <20210308230735.337-1-lsahlber@redhat.com>
References: <20210308230735.337-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index 98dc6d70d4fa..95326025d77d 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2189,6 +2189,8 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cifs_i = CIFS_I(inode);
 	struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
+	struct cifs_tcon *tcon = cifs_sb_master_tcon(cifs_sb);
+	struct cached_fid *cfid = NULL;
 
 	if (cifs_i->time == 0)
 		return true;
@@ -2199,6 +2201,16 @@ cifs_dentry_needs_reval(struct dentry *dentry)
 	if (!lookupCacheEnabled)
 		return true;
 
+	if (!open_cached_dir_by_dentry(tcon, dentry->d_parent, &cfid)) {
+		mutex_lock(&cfid->fid_mutex);
+		if (cfid->time && cifs_i->time > cfid->time) {
+			mutex_unlock(&cfid->fid_mutex);
+			close_cached_dir(cfid);
+			return false;
+		}
+		mutex_unlock(&cfid->fid_mutex);
+		close_cached_dir(cfid);
+	}
 	/*
 	 * depending on inode type, check if attribute caching disabled for
 	 * files or directories
-- 
2.13.6

