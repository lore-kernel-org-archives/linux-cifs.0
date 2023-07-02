Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EEDEB64D9
	for <linux-cifs@archiver.kernel.org>; Sun,  2 Jul 2023 13:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbjGBNEJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 2 Jul 2023 09:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbjGBNEJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 2 Jul 2023 09:04:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3F9135
        for <linux-cifs@vger.kernel.org>; Sun,  2 Jul 2023 06:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688302997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=BDWA0cHSXVgfvckMNf+JGKR/aUvwz+pDaTFzfeeBwos=;
        b=gVAYefHkDlf4mK4jeVFr3IbpMrjjmtQq6bARN+YYrhINGVmigAd+gXvjipDcQauEuEAg0V
        P+8F5DB2yT8zVetbYdDfgUjCRRLdvZOKNrm4B0AmCUBW8HLnpOnZe3iLjN2+TJO0pRnwwf
        +gxp358oysyei5/3jdgMuaRXr3sxSAM=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-347-7YQgl3TPPNeJ1GZB8RrlOA-1; Sun, 02 Jul 2023 09:03:16 -0400
X-MC-Unique: 7YQgl3TPPNeJ1GZB8RrlOA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-76735d5eb86so443243085a.3
        for <linux-cifs@vger.kernel.org>; Sun, 02 Jul 2023 06:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688302996; x=1690894996;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BDWA0cHSXVgfvckMNf+JGKR/aUvwz+pDaTFzfeeBwos=;
        b=UJ7/U5rL3nMjjaNIKKH9hmhUtzetnP9LRPqQME0gq2as8jttoseyB3WOZfeIyNHobJ
         6NDewpTUNn6Tt/rOjgMengEF9EeQh85o3cPboyUjTposMjgpMhEA7SvfqbAg1evuWDy1
         7qeme+z6UrPw52YjzW+RvYHSvNU5b+3131ezkFlUYzz2KJ+yMmatqR0145aieoWzhi2U
         iwSOVqJkcFeGH4JDv6hfjACT3/VVFOgfc2bk6dT+zjh7/vReB7R57Ktmm70jYzjSFwuc
         oQASBDABeQlCMcOx+KJnuBGCVIVh2odG7V/Jizb8SHBxdpQQBWe3OFP+ip7ilQEfBakM
         o9Gw==
X-Gm-Message-State: ABy/qLYd0V87SxWAujv9IawGAExHtjrwh0T6Qkgw1piNzQQpYf2zszlo
        N+wwETx1Xb2FN1v5wNyXRq/UCy0XHscC7WCzgONW1oFRkgUEcw6EC053xWOf+arlE4tnK3e3Mox
        Kj9lpCUGwlAeKfGf4ooXfzA==
X-Received: by 2002:a05:620a:454c:b0:767:5748:cae7 with SMTP id u12-20020a05620a454c00b007675748cae7mr5178668qkp.31.1688302995839;
        Sun, 02 Jul 2023 06:03:15 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEMl5GYrjxK+ozQpsNv0BW9m8jGbSKQM1C6MW3iV+1TqtfpxpQ+GkCfzCCWz1B/9SRBwwFafQ==
X-Received: by 2002:a05:620a:454c:b0:767:5748:cae7 with SMTP id u12-20020a05620a454c00b007675748cae7mr5178643qkp.31.1688302995592;
        Sun, 02 Jul 2023 06:03:15 -0700 (PDT)
Received: from dell-per740-01.7a2m.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id cx13-20020a05620a51cd00b007339c5114a9sm6142847qkb.103.2023.07.02.06.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Jul 2023 06:03:15 -0700 (PDT)
From:   Tom Rix <trix@redhat.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com
Cc:     linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] smb: client: remove unused variable 'server'
Date:   Sun,  2 Jul 2023 09:03:10 -0400
Message-Id: <20230702130310.3437437-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

gcc with W=1 reports
fs/smb/client/dfs.c: In function ‘__dfs_mount_share’:
fs/smb/client/dfs.c:146:33: error: variable ‘server
  set but not used [-Werror=unused-but-set-variable]
  146 |         struct TCP_Server_Info *server;
      |                                 ^~~~~~

This variable is not used, so remove it.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 fs/smb/client/dfs.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/smb/client/dfs.c b/fs/smb/client/dfs.c
index 26d14dd0482e..1403a2d1ab17 100644
--- a/fs/smb/client/dfs.c
+++ b/fs/smb/client/dfs.c
@@ -143,7 +143,6 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	struct smb3_fs_context *ctx = mnt_ctx->fs_ctx;
 	char *ref_path = NULL, *full_path = NULL;
 	struct dfs_cache_tgt_iterator *tit;
-	struct TCP_Server_Info *server;
 	struct cifs_tcon *tcon;
 	char *origin_fullpath = NULL;
 	char sep = CIFS_DIR_SEP(cifs_sb);
@@ -214,7 +213,6 @@ static int __dfs_mount_share(struct cifs_mount_ctx *mnt_ctx)
 	} while (rc == -EREMOTE);
 
 	if (!rc) {
-		server = mnt_ctx->server;
 		tcon = mnt_ctx->tcon;
 
 		spin_lock(&tcon->tc_lock);
-- 
2.27.0

