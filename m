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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32957C47088
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 20:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 141CF613BF
	for <linux-cifs@archiver.kernel.org>; Wed, 26 May 2021 20:36:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhEZUhp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 26 May 2021 16:37:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbhEZUhm (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 26 May 2021 16:37:42 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A30BC061574;
        Wed, 26 May 2021 13:36:09 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id q7so4545604lfr.6;
        Wed, 26 May 2021 13:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlfHDai4ONn60e6TNReFwPChDr2UAYYMQAwfbWWymqo=;
        b=BiinMcC1tfG7D9B/MpBArh8RezrXAapNkwzZvVu9gpy8O0veUTGhyyYdosbVKvSPkZ
         1TOxiyh9nKQ8lrkja+Vaq8SRebFOoJdYUd1YlqG6lRwe1VzbuZ6Hds2N8t8shzZX9bLL
         qwkAat3gCIKqQVJixG0svWA7Sj/43V8Xpx4chL0g3gmKvSzpuHu6yagUSruINFFcuGfw
         +GKz5n3V7wALXRcCmlt7E+e4K+kuf0veLOGj8yVUTkfjUd7MFfIhMfjL3jXRo6bxjcEr
         5Ox72GCiJm6E0YvTQ6V6eXs3ItfqidR/3Y3eIGABzJ/9FFCPDxX/FVa0Hys2jcNQUqOr
         MQgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GlfHDai4ONn60e6TNReFwPChDr2UAYYMQAwfbWWymqo=;
        b=N2AFIploHGp9ew/PEffd/5nkw1HH2FgV1zd+h89C6YVF8pyxXUoC02iKuuNIwdtXT9
         naWoFrPY0ups5LoMXSsjkAQGujalwXfu7N4mK2EacCfi9U5Tji+k4I0oWzrO6rsmHjX5
         QHm1t7kpwsJcZML6N9bsXRvN8MjKbUafo8G9J3eE48j2yLRMXD1qcRf0fumNLnosS053
         Oh+6nZ+p1z2K+dvNxk8sJ2g21ph3RxrGvy11H8+1whyqFwVr9GGax+aJCGnZRJjqmqIV
         Uh6OHeMBoY12oHVwP4K/G/G/iJ/QBgmh8VR5Ne8xwEl23TxnVcR156s0qc5jazTtCbjG
         G+mA==
X-Gm-Message-State: AOAM531rPNxUECr2P00SZqEw9NJWLo673UEdnwvXTN+NcnjJKCbcMnhu
        K1KQDTyRXDpE0ugZ/HdNWaE=
X-Google-Smtp-Source: ABdhPJwZjC/TUOd8aDc/+Ao3iaOCp7q1cSGq8xzn3GGkUc2a8mh2GEnzNZH2vXXl1rQ+iOhClTL3Lg==
X-Received: by 2002:a05:6512:ac8:: with SMTP id n8mr3324320lfu.100.1622061367812;
        Wed, 26 May 2021 13:36:07 -0700 (PDT)
Received: from localhost.localdomain (h-98-128-228-193.NA.cust.bahnhof.se. [98.128.228.193])
        by smtp.gmail.com with ESMTPSA id c4sm7721lfc.258.2021.05.26.13.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 13:36:07 -0700 (PDT)
From:   Rikard Falkeborn <rikard.falkeborn@gmail.com>
To:     Steve French <sfrench@samba.org>
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>
Subject: [PATCH] cifs: Constify static struct genl_ops
Date:   Wed, 26 May 2021 22:35:45 +0200
Message-Id: <20210526203545.13160-1-rikard.falkeborn@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The only usage of cifs_genl_ops[] is to assign its address to the ops
field in the genl_family struct, which is a pointer to const. Make it
const to allow the compiler to put it in read-only memory.

Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>
---
 fs/cifs/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/netlink.c b/fs/cifs/netlink.c
index 5aaabe4cc0a7..291cb606f149 100644
--- a/fs/cifs/netlink.c
+++ b/fs/cifs/netlink.c
@@ -30,7 +30,7 @@ static const struct nla_policy cifs_genl_policy[CIFS_GENL_ATTR_MAX + 1] = {
 	[CIFS_GENL_ATTR_SWN_RESOURCE_NAME]	= { .type = NLA_STRING},
 };
 
-static struct genl_ops cifs_genl_ops[] = {
+static const struct genl_ops cifs_genl_ops[] = {
 	{
 		.cmd = CIFS_GENL_CMD_SWN_NOTIFY,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
-- 
2.31.1

