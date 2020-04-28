Return-Path: <SRS0=2Jb1=6M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6E65C83004
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Apr 2020 03:27:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABB2E206D6
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Apr 2020 03:27:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FP4xowzV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgD1D11 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 27 Apr 2020 23:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbgD1D11 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 27 Apr 2020 23:27:27 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86171C03C1A9
        for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2020 20:27:26 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id x12so15706530qts.9
        for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2020 20:27:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JQR1OfNwgBtU/st8kVswtbKCK/UzrXgKI4losikiDdA=;
        b=FP4xowzVxgsRzsZFGr/9bMfh8pQFYqBUUXU3fvQ+q46oAlnth1NZOZRAvOf046alZH
         hKZq93gIWywUR/s3aog31VeSxzoEUGpoA6YGYuHdg+iHijyNFNt3B9ft+VblcuHGSniC
         PqTQcAVApkx7EtxaUzfa/HiB90tcKWi5eszCc4Yo1T7nFR+Krx/QfzQzWJBxhEEIVHqA
         9VIdKt1Xjb9V81yS2IKwFpxv/m/uR74OwnIdHXNGyCZyFZrWBnKMCKY0aiQCdrT2inZ/
         vfhYB9sLa71sJI/gK3kYncqygMga/hud3V4/PKzBoqDMt09Au6jvmH04K0FveeMS2UwC
         4jiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JQR1OfNwgBtU/st8kVswtbKCK/UzrXgKI4losikiDdA=;
        b=HoB2foRdLwdFmFy+lPX+/SauPIgXWTEHZD50kcqcIKiTj3nRpBk92zCBqWBaCbJnB7
         vAvJusA3ahuxKCuw/lAAsBiSgOkM+0p4eYmps75k/C8Nx1ZaWwW2OJhZj7t5ZQGT8jjD
         +MFnECE4bv+8PF1SpBRdVJkaQzwUAv3oJjSZE6YzWY6vqdLP57/M26p3M+G+At5m+keW
         wc3ZYmO/MWTD1eWnfq2XK0M0kNFeHLxEAHgIKtCCPHE0u+klXp27OwmrwFgTgzx5zkeX
         xTe8SFabTYo7zOe2G1MdqR/p6KfpnO8pXRBYqvOco5DSLqHcZ8tcXMtCIjNeQNRzmgRf
         /AVg==
X-Gm-Message-State: AGi0PuZXd8FG0NgVA/UsGbAzDYmipwOD5qj2rFh0MDuwND0n++x01zLS
        M3o/hDT0Fc37quKXgXHu1zRssepjb3744A==
X-Google-Smtp-Source: APiQypLa8VAn7WDUiRFDycWhNd4ytNLsYbE6ICJGAziWMvpFSLgq38LeNB3GMRV9lLHw/tnvk4F79w==
X-Received: by 2002:ac8:5302:: with SMTP id t2mr27237737qtn.124.1588044445430;
        Mon, 27 Apr 2020 20:27:25 -0700 (PDT)
Received: from ryan-xps13.lilmerv.home (50-80-22-148.client.mchsi.com. [50.80.22.148])
        by smtp.gmail.com with ESMTPSA id x194sm1307930qkb.131.2020.04.27.20.27.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2020 20:27:25 -0700 (PDT)
From:   Ryan Barnett <ryanbarnett3@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Ryan Barnett <ryanbarnett3@gmail.com>
Subject: [PATCH] Use DESTDIR when installing mount.smb3 and optionally install man page
Date:   Mon, 27 Apr 2020 22:26:47 -0500
Message-Id: <20200428032647.2420-1-ryanbarnett3@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Properly create mount.smb3 symlink by using DESTDIR. Also use
CONFIG_MAN to optionally install manpage for mount.smb3.

Signed-off-by: Ryan Barnett <ryanbarnett3@gmail.com>
---
 Makefile.am | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Makefile.am b/Makefile.am
index fe9cd34..e0587f1 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -119,11 +119,13 @@ endif
 SUBDIRS = contrib
 
 install-exec-hook:
-	(cd $(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
+	(cd $(DESTDIR)$(ROOTSBINDIR) && ln -sf mount.cifs mount.smb3)
 
+if CONFIG_MAN
 install-data-hook:
-	(cd $(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
+	(cd $(DESTDIR)$(man8dir) && ln -sf mount.cifs.8 mount.smb3.8)
+endif
 
 uninstall-hook:
-	(cd $(ROOTSBINDIR) && rm -f $(ROOTSBINDIR)/mount.smb3)
-	(cd $(man8dir) && rm -f $(man8dir)/mount.smb3.8)
+	rm -f $(DESTDIR)$(ROOTSBINDIR)/mount.smb3
+	rm -f $(DESTDIR)$(man8dir)/mount.smb3.8
-- 
2.17.1

