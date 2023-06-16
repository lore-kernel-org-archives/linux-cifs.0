Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95E1CEB64D7
	for <linux-cifs@archiver.kernel.org>; Fri, 16 Jun 2023 10:46:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345215AbjFPKqh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 16 Jun 2023 06:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345248AbjFPKqU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 16 Jun 2023 06:46:20 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A4F22B8B
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 03:38:44 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id d9443c01a7336-1b51488ad67so3700105ad.3
        for <linux-cifs@vger.kernel.org>; Fri, 16 Jun 2023 03:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686911875; x=1689503875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Jg0fIqgRm3Hj6aRZQCO4c4zMC4DQ1b32OPEHruanOY=;
        b=dHhOaY74dUH3AiQIALun69hBIQFDRaMDql9hB3nrmIcFrqEpEAsM+aVeuSOxJIA9qS
         e96ryxF60T6no83/MpVzbT6BSDRR/OM818ccaRUrzL0F4speDcWh2fVkIWVkDS6uTSz/
         QFBFxkSKIJpveBppY6yjXUK4tp/g2HmC+63bUOze4fU/Wa/UR1eI4vIFPqdZoix0L7Mu
         BDd7zv7KeTK/DkkG3vS11SzXEnTXYMw8zXRvEWVTgQI8aAhEBNEl7GAthRM+ir7TUWg1
         xsg6A4gjTtEG52Ip3ptGb/gmx8k0EjLE1tqFABWqgoqMM26fJe6IXdmEb8vcsvhXVZsF
         16zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686911875; x=1689503875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Jg0fIqgRm3Hj6aRZQCO4c4zMC4DQ1b32OPEHruanOY=;
        b=a5Iaom62IcxyRh8sjfySNIGlbtsyRkXoQIowEPTz/mxtV0AICxLkcbG6WBk9M2/Zvi
         cogvDAqwM75iu1fBxBFO6HEfV503SEmqIuqxl/K+ftsEZERUuEIljn1hqPNncuMgt9B+
         Mb8i3wb9/o34bJIzLuwiKLwcqy8Aga4DcQIIq3llYrmzQQ8nFcww6LgBZR9J0XSZWBSe
         vCaz6x+yx6JPyf/8JqlsTzG0aOJVoXubGvTydgxtcFJjalRtSHF3TaIpCYwJGStR5h0k
         MbAz69xuxkstoxvRyJGjVRwZB/QfUpfcZL8VFU25rpdB9aCx+k+zRn9sVEy1KVkBqXp7
         MZmQ==
X-Gm-Message-State: AC+VfDx0Id7GYWfM0o8FiS2QPfS8gmnFpSo4zd7YpF6+Beh/p+ljGLV8
        2PAephJyKiAAG9kmVq8/il3Q1F/ZVaTHhg==
X-Google-Smtp-Source: ACHHUZ7yrh4MBzpIQ3jAhRZaICPc1tkK+oIKP15zJyMBQDpyhVLN98h6hdZvt49E948aF0QIXyhccA==
X-Received: by 2002:a17:903:2348:b0:1ac:921c:87fc with SMTP id c8-20020a170903234800b001ac921c87fcmr1406792plh.32.1686911875165;
        Fri, 16 Jun 2023 03:37:55 -0700 (PDT)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:1:7e0e:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id t15-20020a1709027fcf00b001b3d4d74749sm8958129plb.7.2023.06.16.03.37.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 03:37:54 -0700 (PDT)
From:   Shyam Prasad N <nspmangalore@gmail.com>
X-Google-Original-From: Shyam Prasad N <sprasad@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com,
        bharathsm.hsk@gmail.com, pc@cjr.nz, ematsumiya@suse.de
Cc:     Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 1/2] cifs: print nosharesock value while dumping mount options
Date:   Fri, 16 Jun 2023 10:37:45 +0000
Message-Id: <20230616103746.87142-1-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

We print most other mount options for a mount when dumping
the mount entries. But miss out the nosharesock value.
This change will print that in addition to the other options.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/cifsfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
index 43a4d8603db3..86ac620a9615 100644
--- a/fs/smb/client/cifsfs.c
+++ b/fs/smb/client/cifsfs.c
@@ -688,6 +688,8 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 		seq_puts(s, ",noautotune");
 	if (tcon->ses->server->noblocksnd)
 		seq_puts(s, ",noblocksend");
+	if (tcon->ses->server->nosharesock)
+		seq_puts(s, ",nosharesock");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
-- 
2.34.1

