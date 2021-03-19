Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA40C433DB
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 00:48:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C7A964D90
	for <linux-cifs@archiver.kernel.org>; Fri, 19 Mar 2021 00:48:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhCSAr3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 Mar 2021 20:47:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbhCSArH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 Mar 2021 20:47:07 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783DBC06174A;
        Thu, 18 Mar 2021 17:47:07 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id b184so4681851pfa.11;
        Thu, 18 Mar 2021 17:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pMjjN3dGBQb3GjpDVh58+2sh65rE4RFeTUG4XEdacoU=;
        b=Z8EwSpkZogScuwMCaJ4MsU1qLtpGhZ8NZhIU5QDrj/DtarcfWVSbWBWfJ+1HCd9zgW
         WOU8ZvADfIS88Cl7BUtuAHQiHYnATozsOrJX2ng2rKOMlUBth2V3cIsEFpiNc18y+9yW
         E3qNOGV7w2ZWYXfj6D9YklyFdhpwvsX6BEUAgW/FRZXUDS+8KcdYnkcWkYQeT/VBS/BB
         fn/jdXNZ8ZCm3DUJnwt/pT78gbp6wIagndO1cEaXmHq/JQD6mNTREamxNGYw7nuaO2P8
         glo5Mxp5sN1zEUm/Sf+kLd08jgD6hyvjbMvnI5tpTU2olxDSTKmjJmM0fMEyt/JloBRM
         BVyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pMjjN3dGBQb3GjpDVh58+2sh65rE4RFeTUG4XEdacoU=;
        b=hsLYjFO91XnVDMfODPmF+Y8dVbhUa3OdTTaRj6RpdQW3t+F4gkPqv78kIZz2jf2s74
         238Hft/yTOYZO535RybSoNUiNKvKnKeECbvxYb9SeOVIghVjEo8HoTrnCEQbyAkY2tfr
         gXSMC1oyo6SfcjKGC9bJuH3ahHEJkzHMTNGZDQNmdmZS2H7AltWsm49pPYvCIcE/WPcL
         0r5MqhWZkv/m07zPx4falZDWOjGdelDNiKzvP1PcMSqdPQ/FWVFqdIFAROxuYpJtrWkU
         Bro0KyZf7KqpZ8pulgRLwZzlZ3mZwOTv+X3+g7Ijryurie8ZW1UVT67fKZkqZZbMyQ7/
         DH5A==
X-Gm-Message-State: AOAM531WcRSFOOb0E6VBxSeKzeOs1EznES1+XWpoh8QJCslKmNbM6Nyz
        t+dJ0jLuYo097AV2iuxim2wU0JpYeNU=
X-Google-Smtp-Source: ABdhPJyYwjthzI4fYRoszLzF8Efq2LwsU5gX+tYbtd7hN33/jVGNNdyye62nPlyEQSJChLg5Rvs2aQ==
X-Received: by 2002:a63:c604:: with SMTP id w4mr3157673pgg.283.1616114823866;
        Thu, 18 Mar 2021 17:47:03 -0700 (PDT)
Received: from localhost.localdomain ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id y8sm3715645pfe.36.2021.03.18.17.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Mar 2021 17:47:03 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: liu.xuzhi@zte.com.cn
To:     linux-cifs@vger.kernel.org
Cc:     sfrench@samba.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Liu xuzhi <liu.xuzhi@zte.com.cn>
Subject: [PATCH] fs/cifs/: fix misspellings using codespell tool
Date:   Thu, 18 Mar 2021 17:46:57 -0700
Message-Id: <20210319004657.485503-1-liu.xuzhi@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Liu xuzhi <liu.xuzhi@zte.com.cn>

A typo is found out by codespell tool in 251th lines of cifs_swn.c:

$ codespell ./fs/cifs/
./cifs_swn.c:251: funciton  ==> function

Fix a typo found by codespell.

Signed-off-by: Liu xuzhi <liu.xuzhi@zte.com.cn>
---
 fs/cifs/cifs_swn.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifs_swn.c b/fs/cifs/cifs_swn.c
index f2d730fffccb..d829b8bf833e 100644
--- a/fs/cifs/cifs_swn.c
+++ b/fs/cifs/cifs_swn.c
@@ -248,7 +248,7 @@ static int cifs_swn_send_unregister_message(struct cifs_swn_reg *swnreg)
 
 /*
  * Try to find a matching registration for the tcon's server name and share name.
- * Calls to this funciton must be protected by cifs_swnreg_idr_mutex.
+ * Calls to this function must be protected by cifs_swnreg_idr_mutex.
  * TODO Try to avoid memory allocations
  */
 static struct cifs_swn_reg *cifs_find_swn_reg(struct cifs_tcon *tcon)
-- 
2.25.1

