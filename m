Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9268AC433E3
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71E43207E8
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="mDquYK1D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgFZUG3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726206AbgFZUG2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:28 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0901DC08C5DC
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:06:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id D43718206;
        Fri, 26 Jun 2020 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201519; bh=9za62X7ei3Mtgfo4yDqoRR65ub07xw3ZUznkkqyqf0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mDquYK1DzKgycxMKHPTNVlXOc0dWJAmyzuwnYfCPKuihdwFBpd9+Kt4ahwKX5JPde
         FBP/lvGBajL+uOegw02pHMLz8oZxMDXqRuZqspm+45n1PDIfbsGXb4DjMVvA8TBNoP
         P7Dl5587APWK6XylgpN5649tscwCLLwaLxiVR9+ZOZcuQJrrvbyaQpXVqJn//Bl8Ee
         K4qdf90gRXLpfxhXUvZI/dTkJ6uXQS2EVF5CON0wqOEt00KH8RTIHXusytdGasImTc
         Sqxgp84D5Q1CuQzFc6iCgmud8BkH+kBeN5VV8AbkxaiB6v8kGFiMBCh+I0k2fqJmwZ
         kVi+jcWAIF2iw==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 4/6] SMB3: Honor lease disabling for multiuser mounts
Date:   Fri, 26 Jun 2020 12:58:07 -0700
Message-Id: <20200626195809.429507-5-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes: 3e7a02d47872 ("smb3: allow disabling requesting leases")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dc7f875d2caf..6e71a1578e34 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5306,6 +5306,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->nocase = master_tcon->nocase;
 	vol_info->nohandlecache = master_tcon->nohandlecache;
 	vol_info->local_lease = master_tcon->local_lease;
+	vol_info->no_lease = master_tcon->no_lease;
 	vol_info->resilient = master_tcon->use_resilient;
 	vol_info->persistent = master_tcon->use_persistent;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
-- 
2.27.0

