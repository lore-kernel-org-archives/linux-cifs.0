Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EC2EECAAD8
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 04:35:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbiINEfd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 00:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbiINEfa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 00:35:30 -0400
Received: from mx.cjr.nz (unknown [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AF62ED75
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 21:35:13 -0700 (PDT)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id C43E1808BF;
        Wed, 14 Sep 2022 04:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1663130096;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=CN2EUBcMyX1nfsVRThk56pVChowvIVkzk6cr+aTmTio=;
        b=NJYc8ThZMJNnqEH/dWbY0TiafuwROpnbpRo5QVc0k2g0ZKw8ipBAw61je2mRHQDiwEkDTZ
        YxAB8h9Zr8b24cM4J3MO8SA3IzX2szznR4+QWFhtR/FJ3R17GMwWDVbKQcoOmACxGTd6H+
        SsrE3l9ZoIjdGhN4Iaf4dN1uZZ/v5571CrzHCh7o2vNK+CPImjpZ7002EIHS2ImBM3jaZZ
        11+aw1Ztf01vEzr5pQ0bo4Q6jxkv2Nmdimo4k8hpQQAmUQDA8ORRre7cGdX4UWIdJby7jJ
        IeOn4fxeQ1SbQcETuveQy2rk6UrAWGjoK5pdJEaOCQgJEvny66PhvNBrHSv1/Q==
From:   Paulo Alcantara <pc@cjr.nz>
To:     smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH] cifs: add missing spinlock around tcon refcount
Date:   Tue, 13 Sep 2022 21:34:51 -0700
Message-Id: <20220914043451.18797-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Add missing spinlock to protect updates on tcon refcount in
cifs_put_tcon().

Fixes: d7d7a66aacd6 ("cifs: avoid use of global locks for high contention data")
Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/connect.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 251753d0a54b..23fc48aa2ed6 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2350,7 +2350,9 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	ses = tcon->ses;
 	cifs_dbg(FYI, "%s: tc_count=%d\n", __func__, tcon->tc_count);
 	spin_lock(&cifs_tcp_ses_lock);
+	spin_lock(&tcon->tc_lock);
 	if (--tcon->tc_count > 0) {
+		spin_unlock(&tcon->tc_lock);
 		spin_unlock(&cifs_tcp_ses_lock);
 		return;
 	}
@@ -2359,6 +2361,7 @@ cifs_put_tcon(struct cifs_tcon *tcon)
 	WARN_ON(tcon->tc_count < 0);
 
 	list_del_init(&tcon->tcon_list);
+	spin_unlock(&tcon->tc_lock);
 	spin_unlock(&cifs_tcp_ses_lock);
 
 	/* cancel polling of interfaces */
-- 
2.37.3

