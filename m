Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6551DEB64D8
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Jun 2023 18:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjFVSQU (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Jun 2023 14:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230047AbjFVSQT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Jun 2023 14:16:19 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C201FEF
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:16 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-6686708c986so5299783b3a.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Jun 2023 11:16:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687457775; x=1690049775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jJoIo3eKf/KUkaUsmxpRYsVA8vyogyaviB/pOsNHsE4=;
        b=sT5E9gk8lO1O6EQnHrSgRqui3o20QjF4RBr/GanEn2QYHlm499g0XcFniC7PLRTpXB
         QCq/zkAc+Yw8imR2wL8xgvG1q/FXYQg2wJS3ECjmZsDea22OoSsz4p6gjUAVbPpqwFMN
         wgYxV4ay5p+sos1fVvS0ZSVzpufKoYUD/EZE9Ad171PUoN0vPTK4eVz81O3QZzULIOxH
         +7G9J9SxRTj8oLXS+SCTCBPyfGKuWPJNTyS+0qC6NQ50nhpWnWiRq2jGf8m/bGNWVbyd
         K71Fgsz9DdXxDlOc9H5OLg6GjO7XO8pyT1Yfs89R1wdd3lBBhKRowoeRBSCcz4j2VHjO
         BSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687457775; x=1690049775;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jJoIo3eKf/KUkaUsmxpRYsVA8vyogyaviB/pOsNHsE4=;
        b=cv9ZFZioNAojT6ahtyU1nq5JKungAps5Mfrvzdc+ohRb2go1IfazYCcXt6JLICFb+R
         tc03EoAvEJKfO1j5+OYYuGbOYOL3b3KDAO/Ur6wNcha8rVkQn5Z0cFvyP9edwEmW2c7P
         f+QgXapSMzp1kDAKenzJ0iH8Ii5B9qUdjpWukHeYddA0VumfmWhgUDKrKNAqqJADREet
         iu2j1XpYRt8NgOVGFlHmXzIMKvt7e23nwHdBGyoeySQmvxbqiZk4YE2nF3oWnajYaVlf
         GFRMfpJAotpFAHc5zRcs/XYKVjIfSzVLx/rnoH598UQVdyQMbvAByNHM8KGFP3MQsgKF
         uXeQ==
X-Gm-Message-State: AC+VfDxwiYhJNALgdFvplEZh3YQ5X6b9+FoxE9Zk5MMHANkv85Xnyj/j
        9jZ7RqZu7dT0UC0yP1+BeuMlTpLBhOxyCcfj
X-Google-Smtp-Source: ACHHUZ6CibvVv/PNGZ1NWMt4kCtxwz6Nxq6no1s+lIcbZHJMc5vKqkK58iWs8F1JSmgdQ0tU68WwQg==
X-Received: by 2002:a05:6a00:991:b0:662:4041:30ba with SMTP id u17-20020a056a00099100b00662404130bamr25691655pfg.0.1687457774941;
        Thu, 22 Jun 2023 11:16:14 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id h4-20020aa786c4000000b0064fdf576421sm4996536pfo.142.2023.06.22.11.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jun 2023 11:16:14 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ematsumiya@suse.de, bharathsm.hsk@gmail.com
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/3] cifs: log session id when a matching ses is not found
Date:   Thu, 22 Jun 2023 18:16:02 +0000
Message-Id: <20230622181604.4788-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We do not log the session id in crypt_setup when a matching
session is not found. Printing the session id helps debugging
here. This change does just that.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/smb2ops.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
index a8bb9d00d33a..8e4900f6cd53 100644
--- a/fs/smb/client/smb2ops.c
+++ b/fs/smb/client/smb2ops.c
@@ -4439,8 +4439,8 @@ crypt_message(struct TCP_Server_Info *server, int num_rqst,
 
 	rc = smb2_get_enc_key(server, le64_to_cpu(tr_hdr->SessionId), enc, key);
 	if (rc) {
-		cifs_server_dbg(VFS, "%s: Could not get %scryption key\n", __func__,
-			 enc ? "en" : "de");
+		cifs_server_dbg(VFS, "%s: Could not get %scryption key. sid: 0x%llx\n", __func__,
+			 enc ? "en" : "de", le64_to_cpu(tr_hdr->SessionId));
 		return rc;
 	}
 
-- 
2.34.1

