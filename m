Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8968AEB64D9
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jul 2023 15:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjGGPaR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jul 2023 11:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232151AbjGGPaR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jul 2023 11:30:17 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01AC72127
        for <linux-cifs@vger.kernel.org>; Fri,  7 Jul 2023 08:30:16 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-40292285362so15453871cf.3
        for <linux-cifs@vger.kernel.org>; Fri, 07 Jul 2023 08:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1688743815; x=1691335815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=XzgubhdzF7hakvqdZb0GhKfL7qMXhOdMlFOp4J09V8s=;
        b=Erml/4q45uUKo7LASjXH4chfxmDkdK1fXhOv1nqpV3DD8ItGeL1KsIlSwjBMe8DFNu
         4vckQta720LPW+mU9X8WQzluq2uzQvMBi0Ol/U67R/P0S8oQxB16SBs76/DJCIq9Hmgq
         Uqa6m2mMlZrWaWZKrkkiikCihP8Q50M6QuaJbq7rJExlywHqc0ylcDmuaiz/1CXU2nVh
         Q28d1EkEY/S13tNlgbX/raPTgUvd3U/otThlekkwcUqeQQzm7NDzNjFfHP956t+Ax4s1
         vjaZNm8Taby/Obk6ll4zTR464zov2pt5ou1dYVvSmWLxy/Rqu1B74cOaV5yoMVWoklpy
         iyeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688743815; x=1691335815;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XzgubhdzF7hakvqdZb0GhKfL7qMXhOdMlFOp4J09V8s=;
        b=L2Ila3DDtziscgp8ShAFTf8JJyCcvFnFl02to07bKguYtNarlaoPtjOdUU9tk0zz8w
         17CoWnmgdUZxVvyoYcQQ0ABaUK9yV4c+7TzvERBMMxumNDXMg1ODNC7BOgf60kXKyJko
         2IrF9wiYFPLTChbvleSW65p01/pnKEnwtn69do9FM0BG6aRlIsigQGr8KOV59ZGQioup
         ZcVfpeQh2l/VIuD6zLhWtWdBkHPArXUyM/WIZWD6RMf3sppk+MT4vB7708IAQYBghdbw
         FUyv1BpJpV/ec0gjbH1wXkjjmIOPD003Xx9hJwTvMLu3YvOOxTq48G82QRrxV0nE/yQW
         Lkug==
X-Gm-Message-State: ABy/qLaVspy/k2PS77IKmFGXnjFHLrTKmI1CTFvbSMaClGAgdmbWMXkM
        nLCnnftDh2EdJYfGu+yAx7C6C6ukpQE=
X-Google-Smtp-Source: APBJJlFfaVY3Kv1rtQXaFF1X3su1K3amoJsItFHTAEP+gaD0leCPpNO/ONrLsVLzS+NhEe8vdzPtlA==
X-Received: by 2002:ac8:7f4c:0:b0:401:1960:34ba with SMTP id g12-20020ac87f4c000000b00401196034bamr6057701qtk.51.1688743815051;
        Fri, 07 Jul 2023 08:30:15 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id g8-20020ac842c8000000b004009f034a6csm1828352qtm.91.2023.07.07.08.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 08:30:14 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To:     sfrench@samba.org, pc@manguebit.com, lsahlber@redhat.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com, nspmangalore@gmail.com
Subject: [PATCH] cifs: if deferred close is disabled then close files immediately
Date:   Fri,  7 Jul 2023 15:29:01 +0000
Message-Id: <20230707152901.503213-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If defer close timeout value is set to 0, then there is no
need to include files in the deferred close list and utilize
the delayed worker for closing. Instead, we can close them
immediately.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/file.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
index df88b8c04d03..5a58d438e044 100644
--- a/fs/smb/client/file.c
+++ b/fs/smb/client/file.c
@@ -1080,8 +1080,8 @@ int cifs_close(struct inode *inode, struct file *file)
 		cfile = file->private_data;
 		file->private_data = NULL;
 		dclose = kmalloc(sizeof(struct cifs_deferred_close), GFP_KERNEL);
-		if ((cinode->oplock == CIFS_CACHE_RHW_FLG) &&
-		    cinode->lease_granted &&
+		if ((cifs_sb->ctx->closetimeo && cinode->oplock == CIFS_CACHE_RHW_FLG)
+		    && cinode->lease_granted &&
 		    !test_bit(CIFS_INO_CLOSE_ON_LOCK, &cinode->flags) &&
 		    dclose) {
 			if (test_and_clear_bit(CIFS_INO_MODIFIED_ATTR, &cinode->flags)) {
-- 
2.34.1

