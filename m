Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AE2BC433E0
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9BCC20720
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="qh80C2aq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgFZUG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbgFZUG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:27 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2496C03E97A
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:06:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id 222138207;
        Fri, 26 Jun 2020 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201519; bh=9V4rwJWmYz2iTiPLcvwCDcy3IMYn7Hmx+L5mzVszO1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qh80C2aqoSPLjP6dPFQVddQ8tz7qnPe+n7hXOedViK9EIBfKbdS2V+Yrc1rz2ICV/
         67T4aXFiHjg3/W2VpH13J6jfDVhHlnJmgeJM4129wWeJ2dg8v3WL3feQ0Q/qFSqV2P
         q1N1OwkqpH8RksgUgmsFYBJ/IdSRBPGW/Yt9qv1EYOfG7uAK8p5kRfuUbt3taILr6q
         JHqyWPfqmv9qCQcZKCQUr/xUxyegaha3OOf30Yy0x7dj5Q2dD6LotP3rcSq70Yklvv
         e+6UjbeiYJRLR1Wmx3LQevJZv2p5uLD3Dg8jR8Ehps9gg51PHdMesjve3HvjgX3ofO
         QRUEIg9pDv2YQ==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 5/6] SMB3: Honor 'handletimeout' flag for multiuser mounts
Date:   Fri, 26 Jun 2020 12:58:08 -0700
Message-Id: <20200626195809.429507-6-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fixes: ca567eb2b3f0 ("SMB3: Allow persistent handle timeout to be configurable on mount")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
CC: Stable <stable@vger.kernel.org>
---
 fs/cifs/connect.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 6e71a1578e34..dada6d51e034 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5309,6 +5309,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->no_lease = master_tcon->no_lease;
 	vol_info->resilient = master_tcon->use_resilient;
 	vol_info->persistent = master_tcon->use_persistent;
+	vol_info->handle_timeout = master_tcon->handle_timeout;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
 	vol_info->sectype = master_tcon->ses->sectype;
 	vol_info->sign = master_tcon->ses->sign;
-- 
2.27.0

