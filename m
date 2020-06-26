Return-Path: <SRS0=5FUd=AH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361A4C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17BB320720
	for <linux-cifs@archiver.kernel.org>; Fri, 26 Jun 2020 20:06:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=darkrain42.org header.i=@darkrain42.org header.b="FwLLl7p5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726065AbgFZUG2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 26 Jun 2020 16:06:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbgFZUG1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 26 Jun 2020 16:06:27 -0400
Received: from mail.darkrain42.org (o-chul.darkrain42.org [IPv6:2600:3c01::f03c:91ff:fe96:292c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 086D2C08C5DB
        for <linux-cifs@vger.kernel.org>; Fri, 26 Jun 2020 13:06:27 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by o-chul.darkrain42.org (Postfix) with ESMTPSA id 6405A820D;
        Fri, 26 Jun 2020 12:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=darkrain42.org; s=a;
        t=1593201519; bh=U1/e4618DWBEvKVi0ZtS1tXPmfaFu/pDnqhn/OQxHzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FwLLl7p5uSgweY4K4z7gYhif3DkyJZXnpT2koY+djZnKhnenAzZmRfRlswdZs7Ouy
         vH6mEgq4dEjLr3pqql7wOC6Lh5iAg3luP4uTwa3h521ph8GFZ2ntoD9Liq8dgluG65
         2+zCjhPXRp7da6ooWMTY6N3A4V2VTKFXjfwzm0ZoKGslVO+WQOjy+MaN6QA784f5IZ
         IUUflWwy5rsefRC/9F0J0eGyx+I/JUBe4b4fZLoypZrHJYCRgOir19i+LsGFX/GC1i
         6lGx8oP27O8sBUXmV/xAe+EHgektzRs+v+8ne8jmkpJf+z8lH0vboB8LoBsAN1f6kY
         s3/5+1m/2PMqA==
From:   Paul Aurich <paul@darkrain42.org>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     paul@darkrain42.org
Subject: [PATCH 6/6] SMB3: Honor 'posix' flag for multiuser mounts
Date:   Fri, 26 Jun 2020 12:58:09 -0700
Message-Id: <20200626195809.429507-7-paul@darkrain42.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200626195809.429507-1-paul@darkrain42.org>
References: <20200626195809.429507-1-paul@darkrain42.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The flag from the primary tcon needs to be copied into the volume info
so that cifs_get_tcon will try to enable extensions on the per-user
tcon. At that point, since posix extensions must have already been
enabled on the superblock, don't try to needlessly adjust the mount
flags.

Fixes: ce558b0e17f8 ("smb3: Add posix create context for smb3.11 posix mounts")
Fixes: b326614ea215 ("smb3: allow "posix" mount option to enable new SMB311 protocol extensions")
Signed-off-by: Paul Aurich <paul@darkrain42.org>
---
 fs/cifs/connect.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index dada6d51e034..a61abde09ffe 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -5311,6 +5311,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 	vol_info->persistent = master_tcon->use_persistent;
 	vol_info->handle_timeout = master_tcon->handle_timeout;
 	vol_info->no_linux_ext = !master_tcon->unix_ext;
+	vol_info->linux_ext = master_tcon->posix_extensions;
 	vol_info->sectype = master_tcon->ses->sectype;
 	vol_info->sign = master_tcon->ses->sign;
 	vol_info->seal = master_tcon->seal;
@@ -5339,10 +5340,6 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 		goto out;
 	}
 
-	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
-	if (tcon->posix_extensions)
-		cifs_sb->mnt_cifs_flags |= CIFS_MOUNT_POSIX_PATHS;
-
 	if (cap_unix(ses))
 		reset_cifs_unix_caps(0, tcon, NULL, vol_info);
 
-- 
2.27.0

