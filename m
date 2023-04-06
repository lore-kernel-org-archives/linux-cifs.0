Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A1CC7618D
	for <linux-cifs@archiver.kernel.org>; Thu,  6 Apr 2023 08:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbjDFI4A (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 Apr 2023 04:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjDFIz7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 Apr 2023 04:55:59 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5062F526C;
        Thu,  6 Apr 2023 01:55:58 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id v6-20020a05600c470600b003f034269c96so13115877wmo.4;
        Thu, 06 Apr 2023 01:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680771357; x=1683363357;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B9/Axgxw789vjHSKYobykbKjrh7zpjCP2oBQY/iyJas=;
        b=g2Qr6/zrh6oFLeQwJDsSseiOxtP6XC12UfICsXT7C5TxfsJmqVjA5vXPfdX55N3GPn
         DAlxL19v8t0N+VL0qgHnv0J68yF5bXDL6fYpU8hVu7pFG0nF8LHfFuySXkC4pj0shrWo
         AqbL64xpw3haU35F24Rn4eng4wRzXDXoiE3gw+6JMbh+R7YyU18HxF3E3vYbsYKV3JX4
         JHKomehQAXR8Aqvz8Hl1g38JDGsnqHAm5oHTczMSzTDyjgweTN1eSeKF7108aZoOCKwX
         iBXYJVoTmUva0PG7fqGJa72oBPIsceTDgqR08my16yMl909EYZQlD+8JVDlxhw0fyVPV
         GBmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680771357; x=1683363357;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B9/Axgxw789vjHSKYobykbKjrh7zpjCP2oBQY/iyJas=;
        b=PCRvYz5/4Co58WjdluwkVvzHQiASg9dcqiGDjQAxAIEk3Ho9WR7cKphM1uKG9ptRG8
         JybCVaZtB3jVXzbpDOcwDAN2XWPaBlsGPYg0hkMVMRb9QB1M3zWZS5J15MeuAaXAuc9e
         Y1ybxVJqwWWfSjiV5MMPv8YE7/YrFmXrq99edeG9kz3lfnSZR5XDR+t83tZL432blgIU
         52hL98cE/WS0WMVKa3kh8wqpeB4+naYb0dsEfTAkjPeiF3UH6KrGTi+FiK91LQo8jIZg
         OD/ki0JOUslXRfXTATeO25jqe/oFlZqkbrniFGQuiZn+a7OvtXTJVW7q3y+tm6mUe3bv
         yfeA==
X-Gm-Message-State: AAQBX9cHXoKzyg//tOSRBUtu7Rofex5IRTf3/8IpX8lNrcfzZyoPcmGf
        bnKOWmmWa436qSRka1a2Uck=
X-Google-Smtp-Source: AKy350ZzuCVLy75YllzgUZ6DCi3WQ+PI9bLc0iV07zUhK+fXpzHZ0SEvAy6OfQcqLb2K7iCTgd4HqA==
X-Received: by 2002:a7b:c7c6:0:b0:3ef:6e1c:3ffa with SMTP id z6-20020a7bc7c6000000b003ef6e1c3ffamr6710681wmk.28.1680771356751;
        Thu, 06 Apr 2023 01:55:56 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 13-20020a05600c230d00b003ed2384566fsm975582wmo.21.2023.04.06.01.55.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 01:55:56 -0700 (PDT)
Date:   Thu, 6 Apr 2023 11:55:47 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     Paulo Alcantara <pc@cjr.nz>, Ronnie Sahlberg <lsahlber@redhat.com>,
        Shyam Prasad N <sprasad@microsoft.com>,
        Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] cifs: double lock in cifs_reconnect_tcon()
Message-ID: <ZC6JEx4dvWUvgcwW@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This lock was supposed to be an unlock.

Fixes: 6cc041e90c17 ("cifs: avoid races in parallel reconnects in smb1")
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
 fs/cifs/cifssmb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 0d30b17494e4..9d963caec35c 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -120,7 +120,7 @@ cifs_reconnect_tcon(struct cifs_tcon *tcon, int smb_command)
 	spin_lock(&server->srv_lock);
 	if (server->tcpStatus == CifsNeedReconnect) {
 		spin_unlock(&server->srv_lock);
-		mutex_lock(&ses->session_mutex);
+		mutex_unlock(&ses->session_mutex);
 
 		if (tcon->retry)
 			goto again;
-- 
2.39.1

