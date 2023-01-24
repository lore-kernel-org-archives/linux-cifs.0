Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65587C25B4E
	for <linux-cifs@archiver.kernel.org>; Tue, 24 Jan 2023 15:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232966AbjAXPQ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 24 Jan 2023 10:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233986AbjAXPQ0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 24 Jan 2023 10:16:26 -0500
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8D481F496
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 07:16:24 -0800 (PST)
Received: by mail-pj1-f43.google.com with SMTP id e10-20020a17090a630a00b0022bedd66e6dso2317969pjj.1
        for <linux-cifs@vger.kernel.org>; Tue, 24 Jan 2023 07:16:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uus59ZAl6XXERceEJDN08SI6eMDc/sWl6+ShzOLEHDc=;
        b=G0k32YWTbFQOSOarUAgn81RttBq+kh9FAr9dgPXQz9FNhh9T+/7whbzvR3XPguKOTC
         hTpcce/hTTOqtDkmrUm5LVUm46ULyRbpVM3vatWjhVrA+84Vb04mgrBN5yicgPtIYLXF
         nGndmsU4B2+g+G//e9yVUQmZyDhjs/OPMNPgbKF1N77p9b8BL1D4kVmdqjAuQ+0nl8X5
         jl7aYfdVl0UnH8SUenbccgfAl1SxAkvy4N1W4HyI8ieT6ucjvbnqwT1XB1O2Wm6TNDxA
         rqjBGE/9/e6CiBmS9uIkBqpOqBb79a7mfQlYMmAzOUhRltcsHHe7FDzBAj2qGIMH5oK2
         pUYg==
X-Gm-Message-State: AFqh2konR75jCyEvL6NoMfxwNWsowBBT7RfZ5bq2JejDAkAyJxghm6Ic
        99hQwCT3ovi785651ReS6zAtouelVjk=
X-Google-Smtp-Source: AMrXdXvfJGJIYz91LjF4i5XZ3SrExnQF4Mruhh0lGf/wrlJfOiN45VCDopOekQ0piuEvwrGu7ygvPw==
X-Received: by 2002:a17:902:8688:b0:194:77d3:627f with SMTP id g8-20020a170902868800b0019477d3627fmr26111747plo.69.1674573384034;
        Tue, 24 Jan 2023 07:16:24 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902780300b0019612221a98sm1706647pll.293.2023.01.24.07.16.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Jan 2023 07:16:23 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 1/2] ksmbd: downgrade ndr version error message to debug
Date:   Wed, 25 Jan 2023 00:16:02 +0900
Message-Id: <20230124151603.18398-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When user switch samba to ksmbd, The following message flood is coming
when accessing files. Samba seems to changs dos attribute version to v5.
This patch downgrade ndr version error message to debug.

$ dmesg
...
[68971.766914] ksmbd: v5 version is not supported
[68971.779808] ksmbd: v5 version is not supported
[68971.871544] ksmbd: v5 version is not supported
[68971.910135] ksmbd: v5 version is not supported
...

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/ndr.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/ksmbd/ndr.c b/fs/ksmbd/ndr.c
index 0ae8d08d85a8..4d9e0b54e3db 100644
--- a/fs/ksmbd/ndr.c
+++ b/fs/ksmbd/ndr.c
@@ -242,7 +242,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return ret;
 
 	if (da->version != 3 && da->version != 4) {
-		pr_err("v%d version is not supported\n", da->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", da->version);
 		return -EINVAL;
 	}
 
@@ -251,7 +251,7 @@ int ndr_decode_dos_attr(struct ndr *n, struct xattr_dos_attrib *da)
 		return ret;
 
 	if (da->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       da->version, version2);
 		return -EINVAL;
 	}
@@ -457,7 +457,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	if (ret)
 		return ret;
 	if (acl->version != 4) {
-		pr_err("v%d version is not supported\n", acl->version);
+		ksmbd_debug(VFS, "v%d version is not supported\n", acl->version);
 		return -EINVAL;
 	}
 
@@ -465,7 +465,7 @@ int ndr_decode_v4_ntacl(struct ndr *n, struct xattr_ntacl *acl)
 	if (ret)
 		return ret;
 	if (acl->version != version2) {
-		pr_err("ndr version mismatched(version: %d, version2: %d)\n",
+		ksmbd_debug(VFS, "ndr version mismatched(version: %d, version2: %d)\n",
 		       acl->version, version2);
 		return -EINVAL;
 	}
-- 
2.25.1

