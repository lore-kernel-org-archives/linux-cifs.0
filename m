Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F359C3F6B0
	for <linux-cifs@archiver.kernel.org>; Wed, 24 Aug 2022 00:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbiHXA2Q (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 23 Aug 2022 20:28:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiHXA2P (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 23 Aug 2022 20:28:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBDE6B65D
        for <linux-cifs@vger.kernel.org>; Tue, 23 Aug 2022 17:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661300894;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AlYXjvhdg2JeIdoDXLLCx610OUvyjed0OgFHqzmfLP8=;
        b=PWHVERY2rPrJwFplU54QgJ8XJYBwa9xh95ftELsxTQDDjJdhSTrmbUhcZ8hN7qTP/i+8Qh
        5Crftj4l8zU9RnNfO6u6N2dOitljJh2fdteB80G92MzCzhbOQznoj1IJVHdMoLhOaeugAO
        fQIAWHdO39lvvV6dms76CZLwSs2AS7o=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-607-p84tQ80yMm26ObIXJmevJA-1; Tue, 23 Aug 2022 20:28:10 -0400
X-MC-Unique: p84tQ80yMm26ObIXJmevJA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 73C308032FB;
        Wed, 24 Aug 2022 00:28:10 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5519C15BB3;
        Wed, 24 Aug 2022 00:28:09 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/6] cifs: cifs: handlecache, only track the dentry for the root handle
Date:   Wed, 24 Aug 2022 10:27:52 +1000
Message-Id: <20220824002756.3659568-3-lsahlber@redhat.com>
In-Reply-To: <20220824002756.3659568-1-lsahlber@redhat.com>
References: <20220824002756.3659568-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index c2f5b71a3c9f..77880470c7ea 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -47,11 +47,12 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
+	if (!strlen(path))
+		dentry = cifs_sb->root;
+
 	if (strlen(path))
 		return -ENOENT;
 
-	dentry = cifs_sb->root;
-
 	cfid = &tcon->cfids->cfid;
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->is_valid) {
@@ -177,7 +178,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	cfid->tcon = tcon;
 	cfid->is_valid = true;
 	cfid->dentry = dentry;
-	dget(dentry);
+	if (dentry)
+		dget(dentry);
 	kref_init(&cfid->refcount);
 
 	/* BB TBD check to see if oplock level check can be removed below */
-- 
2.35.3

