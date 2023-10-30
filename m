Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBA1C4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 30 Oct 2023 11:00:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232849AbjJ3LAy (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 30 Oct 2023 07:00:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232834AbjJ3LAw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 30 Oct 2023 07:00:52 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD5BB7
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:50 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1cc3bb32b5dso12223135ad.3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Oct 2023 04:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698663650; x=1699268450; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZpeBlQtoIatyPHt0zNGHUw+uJ9g65B52GwNHUGgaCn4=;
        b=aD8zXWXmINnOFsrb/067ViZhWdvoHYtTPeQS2fJe+vk7D0VzQbBMwsjtSfw9hQrLwM
         J38RYNNRBCc6+yXmOo6TcbWxorpxcguvVknsWt1ysOud9AOGCt6WA599Z3tvGw6U0aoK
         2wdDWTgH4LizFz/WaF+vOGOD0LwlfxIKoxIDYiBoc4pWdQ/LhOdbywQmmKCum2yUrCAc
         YiMe6QxRzNfK5rcu9tYIIKc7fttgb6al8j+2m4eYqmFZBppXAbvai2umNqlWGTiztXMM
         LVtecAyTtdS1ldoLnBdXbwVaeX9FryznNuGkH3tKHbuDjPhNM0X+5ctTPUYs34kq+hE3
         waZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698663650; x=1699268450;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZpeBlQtoIatyPHt0zNGHUw+uJ9g65B52GwNHUGgaCn4=;
        b=PrigahUIN/H/+VY0eHAYjrsJDMXt4r+WE9hbW40fK+3cqlB0q6wtb522ikiVP7Iht/
         qcv0FDGhFRfjqIqZdjxHYUeGSyHHc6eOcO/a6Xv6Pfes1DrvkM3i8d78JLzXz1LiXCnR
         o86vSVCwmP7ZZNF4LWy8p9YwwhYaXiY8L/0wT06yc8xsrdLxKtevh1mDjAY4m0akkgrp
         FV/TMRaeFH2tbHZ2twuy/3voaKhNymc/g0NH91O2P99cb3QU13QCuujrnAsQaJ9Ruttr
         V4GAoPYQ6ITczh3LT+6ZqzsIMhY4+AX6tVdu9qCxdb1Vp3loENXvdGPLMjzw6aXLP8Pw
         pHdQ==
X-Gm-Message-State: AOJu0YyTLD9F64n66G1Q5X53vM+o03fWrXUp5hkOKP1ST5iXCsouStml
        Sdt0eb9WV+zLMhcyayDYg7FxHN2Y3IHCaA==
X-Google-Smtp-Source: AGHT+IHz3/KyXzZxAoadvuozSq+FqzYKJeyd8FdzwWKpBgyRLrhNvaGSR8n8IlsKP9pxy0PuZy1ypQ==
X-Received: by 2002:a17:903:191:b0:1c6:d88:dc07 with SMTP id z17-20020a170903019100b001c60d88dc07mr11237097plg.48.1698663649709;
        Mon, 30 Oct 2023 04:00:49 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902e54300b001c9cc44eb60sm6006034plf.201.2023.10.30.04.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 04:00:49 -0700 (PDT)
From:   nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To:     smfrench@gmail.com, pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 09/14] cifs: add a back pointer to cifs_sb from tcon
Date:   Mon, 30 Oct 2023 11:00:15 +0000
Message-Id: <20231030110020.45627-9-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231030110020.45627-1-sprasad@microsoft.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Shyam Prasad N <sprasad@microsoft.com>

Today, we have no way to access the cifs_sb when we
just have pointers to struct tcon. This is very
limiting as many functions deal with cifs_sb, and
these calls do not directly originate from VFS.

This change introduces a new cifs_sb field in cifs_tcon
that points to the cifs_sb for the tcon. The assumption
here is that a tcon will always map to this cifs_sb and
will never change.

Also, refcounting should not be necessary, since cifs_sb
will never be freed before tcon.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsglob.h | 1 +
 fs/smb/client/connect.c  | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/fs/smb/client/cifsglob.h b/fs/smb/client/cifsglob.h
index 81e7a45f413d..cdbc2cd207dc 100644
--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -1134,6 +1134,7 @@ struct cifs_tcon {
 	int tc_count;
 	struct list_head rlist; /* reconnect list */
 	spinlock_t tc_lock;  /* protect anything here that is not protected */
+	struct cifs_sb_info *cifs_sb; /* back pointer to cifs super block */
 	atomic_t num_local_opens;  /* num of all opens including disconnected */
 	atomic_t num_remote_opens; /* num of all network opens on server */
 	struct list_head openFileList;
diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index 8393977e21ee..184075da5c6e 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -3355,6 +3355,7 @@ int cifs_mount_get_tcon(struct cifs_mount_ctx *mnt_ctx)
 		tcon = NULL;
 		goto out;
 	}
+	tcon->cifs_sb = cifs_sb;
 
 	/* if new SMB3.11 POSIX extensions are supported do not remap / and \ */
 	if (tcon->posix_extensions)
@@ -3986,6 +3987,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, kuid_t fsuid)
 		cifs_put_smb_ses(ses);
 		goto out;
 	}
+	tcon->cifs_sb = cifs_sb;
 
 #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 	if (cap_unix(ses))
-- 
2.34.1

