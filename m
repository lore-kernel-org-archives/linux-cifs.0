Return-Path: <SRS0=S2CZ=4U=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A981FC3F2D1
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 15:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7289020866
	for <linux-cifs@archiver.kernel.org>; Tue,  3 Mar 2020 15:43:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u63NjWYt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgCCPnX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 3 Mar 2020 10:43:23 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44928 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727725AbgCCPnX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 3 Mar 2020 10:43:23 -0500
Received: by mail-pg1-f194.google.com with SMTP id a14so1692031pgb.11;
        Tue, 03 Mar 2020 07:43:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yVsYqPYn8VlY/Xr0vLshTuy/KHxsb6yKrL/whDXq2nQ=;
        b=u63NjWYtBbIKnMGnZA3qD99y4hm4ZM8DTS/EiXtc/ljVUruQ6mlWYwg55/jqXlGhMn
         ECDBhgWH7Wou0JHw6NPNSocMxuA4QPqWJsgGQhhD5IkxY4ETICeRgOl1CacgswX5vsTU
         10pzH2cDLtN3ROnRS9DHqUGR8yubxIkbaMC0x4dklbWBGxbyf+k4hFox+D9B+ex6d0qw
         C4I+Dshd6QFpOU63RwpD8ZFCN5Xq/v3glPJ7gPyc3G5NFtzaqwJH3MXanOtJ6EDAEzQF
         2uGCMUqmqG1ViBixVSPucooxJvmI7XFuQQV2BFdt7SFX5RgGQqqohVi+RmU4Pv/DcAR/
         dbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yVsYqPYn8VlY/Xr0vLshTuy/KHxsb6yKrL/whDXq2nQ=;
        b=HIsXFqUQtaWyCX3eVpifkguju1D7rebFr53Cyh6zAv0gZe+RIQG5RcX8BlhtTydxhY
         +pHQJ30IODAp8LeMr+oJ36lPBMLmu1FvqTBG3nXBvjp9cmttPgrn4FFMQWdrUWWoz5Fa
         LPWtSk7l6uRPDZqawaKnVLdXjBMoTc+C7ggQg9msKtRSobmxFzgvMl/W8yqP97bdrzZE
         BP2hDDVHS16ylaICPW0MJnvmq5x0WbXNNtVyjMHEh1+9kzisD9TwYmGo7VLa8rIIkQBv
         cAoquImN+XYW+TzcC7Y8BD0marmBXDaH6MsUXE6WKrESEr3EVvLKRcUdjneVa9diLgzZ
         fFdA==
X-Gm-Message-State: ANhLgQ1h2b1Ggz9SfSq9jqAeL23NuZbwsONs/2e4It4sxrCA93PTfefQ
        3AwwOx29AFfj7o3bOjjyiZkPhTER
X-Google-Smtp-Source: ADFU+vuJPRqrMCk9b+dLAyaEyEFqSgz/Cqgg6gIaP3mcIKUZJf49QtdQtiws0cnndIqyrZYwLQsE8Q==
X-Received: by 2002:a63:7a1a:: with SMTP id v26mr4604508pgc.152.1583250202039;
        Tue, 03 Mar 2020 07:43:22 -0800 (PST)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id 64sm25131037pfd.48.2020.03.03.07.43.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Mar 2020 07:43:21 -0800 (PST)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] fs/cifs/cifsacl: fix sid_to_id
Date:   Tue,  3 Mar 2020 23:43:17 +0800
Message-Id: <1583250197-10786-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fix it to return the errcode.

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 fs/cifs/cifsacl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsacl.c b/fs/cifs/cifsacl.c
index 716574a..a8d2aa8 100644
--- a/fs/cifs/cifsacl.c
+++ b/fs/cifs/cifsacl.c
@@ -400,6 +400,7 @@
 	if (!sidstr)
 		return -ENOMEM;
 
+	rc = 0;
 	saved_cred = override_creds(root_cred);
 	sidkey = request_key(&cifs_idmap_key_type, sidstr, "");
 	if (IS_ERR(sidkey)) {
@@ -454,7 +455,7 @@
 		fattr->cf_uid = fuid;
 	else
 		fattr->cf_gid = fgid;
-	return 0;
+	return rc;
 }
 
 int
-- 
1.8.3.1

