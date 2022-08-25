Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00A76C04AA5
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Aug 2022 04:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiHYElj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Aug 2022 00:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiHYEli (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Aug 2022 00:41:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C8EC2CDD7
        for <linux-cifs@vger.kernel.org>; Wed, 24 Aug 2022 21:41:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661402493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z5RpT9TnzSr0iLUMVbbvF/oqT4/optj5m72it3bt+A=;
        b=hw+gCoDM4O1WVb+OuP8Ysfec/qy9x6N08K8BoHtGj5uTdzKEIM+UsVBtY5OScFlQVynjvS
        50sL4iNGhF3SFc9l3c0bXqrEDjlH17vpWK5+KrHmBGXW6EiNDMp5RkOvpfvCa08TqgWiAL
        2b+AGuQ/RJ30XIr2KrGQlCt3g5hoVBg=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-168-BjLhP2KyPqC2JBw8iFP35Q-1; Thu, 25 Aug 2022 00:41:31 -0400
X-MC-Unique: BjLhP2KyPqC2JBw8iFP35Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D15D1818CBA;
        Thu, 25 Aug 2022 04:41:31 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E8B912026D4C;
        Thu, 25 Aug 2022 04:41:30 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/5] cifs: cifs: handlecache, only track the dentry for the root handle
Date:   Thu, 25 Aug 2022 14:41:04 +1000
Message-Id: <20220825044107.3703811-3-lsahlber@redhat.com>
In-Reply-To: <20220825044107.3703811-1-lsahlber@redhat.com>
References: <20220825044107.3703811-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
---
 fs/cifs/cached_dir.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/cached_dir.c b/fs/cifs/cached_dir.c
index c2f5b71a3c9f..4f3d88f3351b 100644
--- a/fs/cifs/cached_dir.c
+++ b/fs/cifs/cached_dir.c
@@ -47,11 +47,11 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 	if (cifs_sb->root == NULL)
 		return -ENOENT;
 
-	if (strlen(path))
+	if (!path[0])
+		dentry = cifs_sb->root;
+	else
 		return -ENOENT;
 
-	dentry = cifs_sb->root;
-
 	cfid = &tcon->cfids->cfid;
 	mutex_lock(&cfid->fid_mutex);
 	if (cfid->is_valid) {
@@ -177,7 +177,8 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
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

