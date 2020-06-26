Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 752C9C433E4
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55BD82075D
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="NyKHLkWA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFZUG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgFZUG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:27 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED003C03E97B
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:06:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id 638D58200;
        Fri, 26 Jun 2020 12:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201518; bh=UIV+UdMzRQng4EjZobPdEbeAatANG7mug78TIFwRy7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NyKHLkWAugTfiuSn1JrPo0uSeoTW+fnFcgNTXhiDxHsVSd94l6lBHT48eg+jawX7Z
         L1POGJOldjjRi8Wyr2Ctvsa7Me3rEY8PfUfr0rqzH+mmVhhpI+L6BMPfozh4xmHrI5
         E3Cn1i4UTfDbH57h1iTBSJfm3HzldqhyLpcuqDW8xdgZmLM78Rzadd5MWcvQo6WkrT
         Y/Im7KpvUNlC4sE2yEIg9NJUwZVNaOTk0JAbUCsevYnakuaCyL+UwSQCLLdjakbbqU
         Q0bSThVQymCLUtxvyuIlbHwr8dLE+ZR0xUkQpuEq2soLFppnppl4TbSTm3YzAhoz7T
         KU0jZcKSttDNQ==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 2/6] SMB3: Honor 'seal' flag for multiuser mounts
Date:   Fri, 26 Jun 2020 12:58:05 -0700
Message-Id: <20200626195809.429507-3-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ensure multiuser SMB3 mounts use encryption for all users' tcons if the
mount options are configured to require encryption. Without this, only
the primary tcon and IPC tcons are guaranteed to be encrypted. Per-user
tcons would only be encrypted if the server was configured to require
encryption.

Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5fac34f192af..804509f7f3a1 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5309,6 +5309,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 	vol_info->sectype = master_tcon->ses->sectype;
 	vol_info->sign = master_tcon->ses->sign;
+	vol_info->seal = master_tcon->seal;
 
 	rc = cifs_set_vol_auth(vol_info, master_tcon->ses);
 	if (rc) {
-- 
2.27.0

