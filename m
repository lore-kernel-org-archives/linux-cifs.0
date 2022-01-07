Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46582C433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 05:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbiAGFpw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 00:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAGFpw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 00:45:52 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF2DC061245
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jan 2022 21:45:52 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id w7so4081610plp.13
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jan 2022 21:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FN0qeu++kaIcG5dPhuWCyIB9XCIg0tJCZQ8Y43FUp50=;
        b=dMCV+XWxz8Z9yHiFl0EmfWhbHplmZXYJHlwgoD4he1CKBeXlM/8M8dlyFfru84/huo
         Sg3GYAt/U4ZSz/zHkFCfqVNEbJl8quf6yfAjtlTTHwyUsprsfD8/rP19vRP0Z7vDi/y5
         arUDHQnyKSlMcg+WIyuVvoBF+nBUhlwruBaIMU81ohuoC3mH6WPCRF9hnfSW7RbZV3uh
         H4C3PzEPLJns9dZicuz313+/9/8EjPoL4xxops5CJFotlc6DczWJKIvd253cDCjkwcnx
         EAs456I8oP5F+59ddeVwuHJosMS3roZHNm2nU5UPCOgTOrbxaAZq8q99aiMSV8UPIp7Y
         83Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FN0qeu++kaIcG5dPhuWCyIB9XCIg0tJCZQ8Y43FUp50=;
        b=jDTamBRXgPu8TiE8XaUu+Lr1FXOADBZU+Ropka2Nqv5A56TJ4KYKU0q/GCPTetDd1u
         JoWYqaKOROg51QZx63ddtDE6uE7bVwaRtXx7RHyZny0K/eWN26w8N+wIRd6gNxByHiM7
         E5o2VVtkdEVVbde0po/i05MXMTk2QWunOHxiHbE7PTPkPVV8U/1Um6A3ItN7ZkBleWwP
         A1AjVsZUIjgsVLJZoN2xv30X050p/lrOgFGvq45xCw4sA5EqA17AfmpaJFvx/8WWKu4r
         3naZFIfJceuzJ9cFJUXxLYKgR+LxPC64AXt2Tsv078LPq/e/phq343RDdyTSYlCftglw
         TneA==
X-Gm-Message-State: AOAM532fMg9JXdowXcJfPbLZY44mv8cZvu2ZEXc/+vwjZu5LawrhNqK1
        /5cMOfxrj37EEit4weUaK9PTZ92v5co=
X-Google-Smtp-Source: ABdhPJzrRnFqVr7Tk/11WYC0NYeuhR/+2ERSSOL7QzECmj9OdcGH/NpgGL7x+U5LjHSLkSYzIF+EAA==
X-Received: by 2002:a17:90a:5781:: with SMTP id g1mr13892520pji.236.1641534351310;
        Thu, 06 Jan 2022 21:45:51 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id r7sm3348489pgm.15.2022.01.06.21.45.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 21:45:51 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 2/2] ksmbd: smbd: change the default maximum read/write, receive size
Date:   Fri,  7 Jan 2022 14:45:31 +0900
Message-Id: <20220107054531.619487-2-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220107054531.619487-1-hyc.lee@gmail.com>
References: <20220107054531.619487-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Due to restriction that cannot handle multiple
buffer descriptor structures, decrease the maximum
read/write size for Windows clients.

And set the maximum fragmented receive size
in consideration of the receive queue size.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index f0b17da1cac2..86fd64511512 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -80,7 +80,7 @@ static int smb_direct_max_fragmented_recv_size = 1024 * 1024;
 /*  The maximum single-message size which can be received */
 static int smb_direct_max_receive_size = 8192;
 
-static int smb_direct_max_read_write_size = 1024 * 1024;
+static int smb_direct_max_read_write_size = 1048512;
 
 static int smb_direct_max_outstanding_rw_ops = 8;
 
@@ -1908,7 +1908,9 @@ static int smb_direct_prepare(struct ksmbd_transport *t)
 	st->max_send_size = min_t(int, st->max_send_size,
 				  le32_to_cpu(req->max_receive_size));
 	st->max_fragmented_send_size =
-			le32_to_cpu(req->max_fragmented_size);
+		le32_to_cpu(req->max_fragmented_size);
+	st->max_fragmented_recv_size =
+		(st->recv_credit_max * st->max_recv_size) / 2;
 
 	ret = smb_direct_send_negotiate_response(st, ret);
 out:
-- 
2.25.1

