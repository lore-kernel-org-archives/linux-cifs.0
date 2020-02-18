Return-Path: <SRS0=c9dP=4G=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB979C34033
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 04:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA87E20836
	for <linux-cifs@archiver.kernel.org>; Tue, 18 Feb 2020 04:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GwLpwA52"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726353AbgBRES4 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 17 Feb 2020 23:18:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22804 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726352AbgBRES4 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 17 Feb 2020 23:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581999535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=rIGcArXNiX6wlYPmDN0JYysFkr2vRaX4uiHzWC7G308=;
        b=GwLpwA52RcpW3krhkvFWnkvf7llo/XNXDrVO8P2DTMItTQMUFeSnUmwEq8MjM6VAYaaUx8
        3GKvWioA8rGRvRJHzOkECEZsOCRPbAeq4mWh1P8JQU/IqEPpC57i4ETXsNhThSrAptd9rf
        MvFu9pFgCA9rCDgr/wMyMXu93wq4Wq0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-292-qm6Hy9_IP0OgX3pGzH7j7w-1; Mon, 17 Feb 2020 23:18:53 -0500
X-MC-Unique: qm6Hy9_IP0OgX3pGzH7j7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 54837800D48
        for <linux-cifs@vger.kernel.org>; Tue, 18 Feb 2020 04:18:52 +0000 (UTC)
Received: from test1135.test.redhat.com (vpn2-54-132.bne.redhat.com [10.64.54.132])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DF8405C1B0;
        Tue, 18 Feb 2020 04:18:51 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH] cifs: don't leak -EAGAIN for stat() during reconnect
Date:   Tue, 18 Feb 2020 14:18:42 +1000
Message-Id: <20200218041842.13986-2-lsahlber@redhat.com>
In-Reply-To: <20200218041842.13986-1-lsahlber@redhat.com>
References: <20200218041842.13986-1-lsahlber@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
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
 fs/cifs/inode.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/cifs/inode.c b/fs/cifs/inode.c
index b5e6635c578e..cf36dcd9dafd 100644
--- a/fs/cifs/inode.c
+++ b/fs/cifs/inode.c
@@ -2073,7 +2073,9 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	struct inode *inode = d_inode(dentry);
 	struct super_block *sb = dentry->d_sb;
 	char *full_path = NULL;
+	int count = 0;
 
+again:
 	if (inode == NULL)
 		return -ENOENT;
 
@@ -2099,6 +2101,8 @@ int cifs_revalidate_dentry_attr(struct dentry *dentry)
 	else
 		rc = cifs_get_inode_info(&inode, full_path, NULL, sb,
 					 xid, NULL);
+	if (rc == -EAGAIN && count++ < 10)
+		goto again;
 
 out:
 	kfree(full_path);
-- 
2.13.6

