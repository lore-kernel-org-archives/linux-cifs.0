Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC693C433F5
	for <linux-cifs@archiver.kernel.org>; Sat, 12 Mar 2022 10:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbiCLK3X (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 12 Mar 2022 05:29:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbiCLK3W (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 12 Mar 2022 05:29:22 -0500
X-Greylist: delayed 63 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 12 Mar 2022 02:28:16 PST
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE89EEA48
        for <linux-cifs@vger.kernel.org>; Sat, 12 Mar 2022 02:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Cf3d/zYyP1qElLyGMKalfDePFpmbmiLI2TKBOV9FAj8=;
  b=r1LvOmlMPSBgD1ppTQls3Zx1NDsxNu/BY1x1IlAbU4VoDfy0tGxd7p1v
   9UDwmqUuvBCgRGtSd5UR4X6K8V1l7ZtjpMe88rbvO2r3tgx9aaHYbrPK9
   Ykws3igWEYUgiBIOhLGyjtnrOmUplk3NkoOiT9UGgxTAd3PvoI0hjW5nn
   w=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,175,1643670000"; 
   d="scan'208";a="25781347"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2022 11:27:11 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Steve French <sfrench@samba.org>
Cc:     kernel-janitors@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] cifs: use kzalloc
Date:   Sat, 12 Mar 2022 11:27:00 +0100
Message-Id: <20220312102705.71413-2-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220312102705.71413-1-Julia.Lawall@inria.fr>
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Use kzalloc instead of kmalloc + memset.

The semantic patch that makes this change is:
(https://coccinelle.gitlabpages.inria.fr/website/)

//<smpl>
@@
expression res, size, flag;
@@
- res = kmalloc(size, flag);
+ res = kzalloc(size, flag);
  ...
- memset(res, 0, size);
//</smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 fs/cifs/transport.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index eeb1a699bd6f..4ff8e165a180 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -464,13 +464,12 @@ smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		return -EIO;
 	}
 
-	tr_hdr = kmalloc(sizeof(*tr_hdr), GFP_NOFS);
+	tr_hdr = kzalloc(sizeof(*tr_hdr), GFP_NOFS);
 	if (!tr_hdr)
 		return -ENOMEM;
 
 	memset(&cur_rqst[0], 0, sizeof(cur_rqst));
 	memset(&iov, 0, sizeof(iov));
-	memset(tr_hdr, 0, sizeof(*tr_hdr));
 
 	iov.iov_base = tr_hdr;
 	iov.iov_len = sizeof(*tr_hdr);

