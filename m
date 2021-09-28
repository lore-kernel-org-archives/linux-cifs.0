Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01C3DC433F5
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3AC16101A
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Sep 2021 06:05:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238910AbhI1GHV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Sep 2021 02:07:21 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:39775 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239594AbhI1GGH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Sep 2021 02:06:07 -0400
Received: by mail-pl1-f179.google.com with SMTP id c4so13427594pls.6
        for <linux-cifs@vger.kernel.org>; Mon, 27 Sep 2021 23:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U9ccFgVl6bmGNhtZUpDr1NBEpOTUvie5Cgr0hMxHZgQ=;
        b=uthIohNF/yV/lkRuKyK4YNvlMZjJM0p6pNvatONEt1b3rXXbBQ433LQOS9kTkDf6Y3
         ob3x+XxW5IOvyzA2VQTvctZ/YRGgd8WlwhT0LorIFFunvIpa5OALETNgQ1LFSono3sCW
         ozjrzMyyUztUdTgjkB707Qb3y9Kdp7yrULxzcayMBXy6kSC/ADW1EvpQxGhPsPp0DcG9
         83jWOiY6VOlYsF4GQpX1yF5YkpaiDJckM8GaiGkzd17SNUtI0udDulAs/QXz4pMAu3/f
         WkFp8L+lf304T7d/AzPIMO5G1RGNo4mMZPiPddKLL91WBW1kntdjLM2zn0ufQB+/ZTGi
         XdGg==
X-Gm-Message-State: AOAM533T8Dfln9Aa3VTkj0MeSqjM6eWQyzJtnVMJpP+MIQOogLV8x31F
        cESXLfl0xs5hic0OqASWhFCU/6IqY+rQgg==
X-Google-Smtp-Source: ABdhPJzRSCEptZL243ozBXIp7ObxmyEJXzx+pKMNJszY09c8RP8eqz89/LlCUQj8EvFwyUy67KjuHA==
X-Received: by 2002:a17:90a:8403:: with SMTP id j3mr3495351pjn.195.1632809068392;
        Mon, 27 Sep 2021 23:04:28 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id s2sm18646817pfe.215.2021.09.27.23.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Sep 2021 23:04:28 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] MAINTAINERS: rename cifs_common to smbfs_common in cifs and ksmbd entry
Date:   Tue, 28 Sep 2021 15:04:04 +0900
Message-Id: <20210928060404.6329-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

commit 23e91d8b7c5a("cifs: rename cifs_common to smbfs_common") cause
the following warning from get_maintainer.pl.

./scripts/get_maintainer.pl --self-test=patterns complains:
  warning: no file matches    F:    fs/cifs_common/

This patch rename cifs_common to smbfs_common in cifs and ksmbd entry.

Reported-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b33791bb8e9..8a8c0e6eb458 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4655,7 +4655,7 @@ W:	http://linux-cifs.samba.org/
 T:	git git://git.samba.org/sfrench/cifs-2.6.git
 F:	Documentation/admin-guide/cifs/
 F:	fs/cifs/
-F:	fs/cifs_common/
+F:	fs/smbfs_common/
 
 COMPACTPCI HOTPLUG CORE
 M:	Scott Murray <scott@spiteful.org>
@@ -10193,8 +10193,8 @@ M:	Hyunchul Lee <hyc.lee@gmail.com>
 L:	linux-cifs@vger.kernel.org
 S:	Maintained
 T:	git git://git.samba.org/ksmbd.git
-F:	fs/cifs_common/
 F:	fs/ksmbd/
+F:	fs/smbfs_common/
 
 KERNEL UNIT TESTING FRAMEWORK (KUnit)
 M:	Brendan Higgins <brendanhiggins@google.com>
-- 
2.25.1

