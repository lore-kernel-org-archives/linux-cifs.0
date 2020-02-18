Return-Path: <SRS0=c9dP=4G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12D8AC34049
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 20:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D721F24125
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 20:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NwRYf3jR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728517AbgBRUBS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 18 Feb 2020 15:01:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31205 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727069AbgBRUBS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 18 Feb 2020 15:01:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582056077;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=Om7gxwOKEu5eSGKX6V0cXRstqHy0uWY9/47bTlci6r4=;
        b=NwRYf3jR1tqFlkI2GI6sbh0djomT2TYpooSEgzvMFXUENsnEu/ZCiwKA0lsECxrZiZpYS4
        6TkTjM3T7LtKPOAd4z3ngWyOQ3Fk8eiXKmgz6z3H10TBvBAes7MY30Q/BMFsfyjyGeFdcE
        nUHJWjbEpA/Ed+NkZLADisxMS24AY5I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-P2AO0BPDMOyh57tmGZyarA-1; Tue, 18 Feb 2020 15:01:13 -0500
X-MC-Unique: P2AO0BPDMOyh57tmGZyarA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 37728800D54
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 20:01:12 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD45C90773;
        Tue, 18 Feb 2020 20:01:11 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
Date:   Wed, 19 Feb 2020 06:01:03 +1000
Message-Id: <20200218200103.12574-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If from cifs_revalidate_dentry_attr() the SMB2/QUERY_INFO call fails with an
error, such as STATUS_SESSION_EXPIRED, causing the session to be reconnected
it is possible we will leak -EAGAIN back to the application even for
system calls such as stat() where this is not a valid error.

Fix this by re-trying the operation from within cifs_revalidate_dentry_attr()
if cifs_get_inode_info*() returns -EAGAIN.

This fixes stat() and possibly also other system calls that uses
cifs_revalidate_dentry*().

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/inode.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b5e6635c578e..1212ace05258 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2073,6 +2073,7 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = dentry->d_sb;
 	char *full_path = NULL;
+	int count = 0;
 
 	if (inode == NULL)
 		return -ENOENT;
@@ -2094,15 +2095,18 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 		 full_path, inode, inode->i_count.counter,
 		 dentry, cifs_get_time(dentry), jiffies);
 
+again:
 	if (cifs_sb_master_tcon(CIFS_SB(sb))->unix_ext)
 		rc = cifs_get_inode_info_unix(&inode, full_path, sb, xid);
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 					 xid, NULL);
-
+	if (is_retryable_error(rc) && count++ < 10)
+		goto again;
 out:
 	kfree(full_path);
 	free_xid(xid);
+
 	return rc;
 }
 
-- 
2.13.6

