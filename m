Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAD8C433E0
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 452DD6521D
	for <linux-cifs@archiver.kernel.org>; Mon,  8 Mar 2021 15:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbhCHPBe (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 10:01:34 -0500
Received: from mx.cjr.nz ([51.158.111.142]:40570 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231308AbhCHPBO (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 8 Mar 2021 10:01:14 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 477A47FD3B;
        Mon,  8 Mar 2021 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1615215673;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XxhRwS2lqW9dvjB9y+9Oogmn5VfBqOA75nuULxYo9n4=;
        b=KPVmxvUem9on4uTGK86rcPvg5isJ3Oz8vojo8dbRXM9CoBrO0ccVwNhDpwK7vKk+AMwPYa
        ASQ5UIp+rwFSL3AleiKLcKCEie60MjkdByRbnUVWAzAamIoB07npIwniu8IsuU1QPyns1D
        siUJQdu2ym7TDmy4huwqbw5bTlo4w4z5/yebvlkdQ6YXIg1twyfup9u6avjbZAsJIiYGW/
        bUrUuzznQTtxpHssstWT7MHYWessMQus/LQQWlDMwPTH30NYoh4s2wpJm7jtmMi6ACN9pp
        HR110gneinULSyiYOWlMLcU6rXv084LXLCtv8SjhIovqbxymiPqbA47lI6Bksw==
From:   Paulo Alcantara <pc@cjr.nz>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: [PATCH 3/4] cifs: return proper error code in statfs(2)
Date:   Mon,  8 Mar 2021 12:00:49 -0300
Message-Id: <20210308150050.19902-3-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-1-pc@cjr.nz>
References: <20210308150050.19902-1-pc@cjr.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In cifs_statfs(), if server->ops->queryfs is not NULL, then we should
use its return value rather than always returning 0.  Instead, use rc
variable as it is properly set to 0 in case there is no
server->ops->queryfs.

Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index d43e935d2df4..099ad9f3660b 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -290,7 +290,7 @@ cifs_statfs(struct dentry *dentry, struct kstatfs *buf)
 		rc = server->ops->queryfs(xid, tcon, cifs_sb, buf);
 
 	free_xid(xid);
-	return 0;
+	return rc;
 }
 
 static long cifs_fallocate(struct file *file, int mode, loff_t off, loff_t len)
-- 
2.30.1

