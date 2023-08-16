Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A427C25B4F
	for <linux-cifs@archiver.kernel.org>; Wed, 16 Aug 2023 20:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjHPU20 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 16 Aug 2023 16:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346134AbjHPU2M (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 16 Aug 2023 16:28:12 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E98D2690
        for <linux-cifs@vger.kernel.org>; Wed, 16 Aug 2023 13:28:11 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id 6a1803df08f44-649c6ea6e72so994586d6.2
        for <linux-cifs@vger.kernel.org>; Wed, 16 Aug 2023 13:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692217690; x=1692822490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=VHlecla1WGbAm1Rb3/JTGS2skoyoDs3XTDTXnb5PKoA=;
        b=AIs7k7iyeHnsvZBEiDRST35qjkQBArUek0C1nQLaoXzgKjnNbAxPxUoBVgVFmexpPC
         GxmVuAmKUa+8Jtxjj+Wo7tiZr/o3WoMz5xJcLIRH0o137un/zNKCsnhnt0uCYT3yEERX
         pDxQRESx7SeRY2apX6/Njq7izCcUnLxurOw4l62uGldjUGJyHY5/6zh5gIHyZF9T3ZoE
         5LhqNjhqHBRuJ1YTSDtBdCWQPCg/B1y19afBFizXCkmhASTtRfZAiwPCrRFhTqcJ03pr
         tyvpSCzdT/etAMo6SqMn/Nxhxrb0S52snCTZXBmvRoDJB1QbsMlutk1x6lBbl7KyTykj
         r+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692217690; x=1692822490;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VHlecla1WGbAm1Rb3/JTGS2skoyoDs3XTDTXnb5PKoA=;
        b=Cy3USs0q2vYnQMDKNgBSKAsOPVNVHluwnFvTGHAm5A9Sr1XrLAdrp7Rmz8k9dFF1sO
         6YwZODWVdA+M/R32K6C/9AzGLSUq4/jtN+kSMVIEBy7u4p8Icl4VyRd9W6+M7BS2PTkS
         RBeUdn22KzNbvlqUW2tQxNOyEESg28Qt2eM4fzXCayeXfNE9zUZgE6/Nv+zyptNkcF47
         yfQzBmCNJKh4TCTXywvf9XP5299uUDbrgqUqIQRX4QuyLplpYAetuDqa2Hgg9PxfeGyo
         smWyG75+p3u3ihrtY+5pRwLGy6fvL/wVW+co6ZBCv8jcOQmP9I+tBNWlvDhEcZysuTgh
         5hTA==
X-Gm-Message-State: AOJu0YxSpdd+EtbswWylwVdspPCm9c+f6vCX+IFVDUNNaa+lyzsnTSSX
        nAqdHp9YxYrYUC+utMJS918=
X-Google-Smtp-Source: AGHT+IH+4UmlB/33iumocrECs66UcYyGYuUhyvk+CxraAtqz5c8WlwXORfSGSlpenPoIbFHKJc0FEA==
X-Received: by 2002:a0c:f48b:0:b0:62d:f806:7f80 with SMTP id i11-20020a0cf48b000000b0062df8067f80mr2911293qvm.13.1692217690556;
        Wed, 16 Aug 2023 13:28:10 -0700 (PDT)
Received: from ubuntu2004.1qqixozwsnuevircicbvxjrsib.bx.internal.cloudapp.net ([20.84.44.103])
        by smtp.googlemail.com with ESMTPSA id t20-20020a0cb394000000b0063f78bd525asm5078715qve.144.2023.08.16.13.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 13:28:09 -0700 (PDT)
From:   Bharath SM <bharathsm.hsk@gmail.com>
X-Google-Original-From: Bharath SM <bharathsm@microsoft.com>
To:     pc@manguebit.com, sfrench@samba.org, nspmangalore@gmail.com,
        sprasad@microsoft.com, tom@talpey.com, linux-cifs@vger.kernel.org,
        bharathsm@microsoft.com
Subject: [PATCH] cifs: update desired access while requesting for directory lease
Date:   Wed, 16 Aug 2023 20:26:38 +0000
Message-Id: <20230816202638.17616-1-bharathsm@microsoft.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We read and cache directory contents when we get directory
lease, so we should ask for read permission to read contents
of directory.

Signed-off-by: Bharath SM <bharathsm@microsoft.com>
---
 fs/smb/client/cached_dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
index fe483f163dbc..2d5e9a9d5b8b 100644
--- a/fs/smb/client/cached_dir.c
+++ b/fs/smb/client/cached_dir.c
@@ -218,7 +218,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tcon *tcon,
 		.tcon = tcon,
 		.path = path,
 		.create_options = cifs_create_options(cifs_sb, CREATE_NOT_FILE),
-		.desired_access = FILE_READ_ATTRIBUTES,
+		.desired_access =  FILE_READ_DATA | FILE_READ_ATTRIBUTES,
 		.disposition = FILE_OPEN,
 		.fid = pfid,
 	};
-- 
2.39.2

