Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04036ECAAA1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 02:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbiHaCuI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 30 Aug 2022 22:50:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230270AbiHaCuH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 30 Aug 2022 22:50:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C95B9FD2
        for <linux-cifs@vger.kernel.org>; Tue, 30 Aug 2022 19:50:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661914203;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z5RpT9TnzSr0iLUMVbbvF/oqT4/optj5m72it3bt+A=;
        b=ZygRmuNd0ff5qgyBCg3m0POXqLO1wAKEWpiQznQpQuQUn+wG2cVYkLx7a8jak+KpiDvpcm
        rMw6RODY9IJ6Ll4jOoR43J1HqblTsbmlrp4iTOoRf1IaexM9plGrgXxloIc2E+jfrF1ART
        uVEzSG3KT9AToLcmldwkb5RgeepAwZ4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-434-5henQJOrPyS3rgov-ej8kg-1; Tue, 30 Aug 2022 22:50:01 -0400
X-MC-Unique: 5henQJOrPyS3rgov-ej8kg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7B45A8037AA;
        Wed, 31 Aug 2022 02:50:01 +0000 (UTC)
Received: from localhost.localdomain (vpn2-52-20.bne.redhat.com [10.64.52.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE9EA400E88E;
        Wed, 31 Aug 2022 02:50:00 +0000 (UTC)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: [PATCH 2/6] cifs: cifs: handlecache, only track the dentry for the root handle
Date:   Wed, 31 Aug 2022 12:49:43 +1000
Message-Id: <20220831024947.3917507-3-lsahlber@redhat.com>
In-Reply-To: <20220831024947.3917507-1-lsahlber@redhat.com>
References: <20220831024947.3917507-1-lsahlber@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
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

