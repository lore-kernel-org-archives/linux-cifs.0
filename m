Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ED58C433B4
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 15:02:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 173C0613C0
	for <linux-cifs@archiver.kernel.org>; Tue,  6 Apr 2021 15:02:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345380AbhDFPCw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 6 Apr 2021 11:02:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243457AbhDFPCv (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 6 Apr 2021 11:02:51 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9179BC06174A;
        Tue,  6 Apr 2021 08:02:43 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id y1so16837541ljm.10;
        Tue, 06 Apr 2021 08:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nx8rtm61zSc6YwTnf3ZbUlYy9Dq9r8tfsMgUX9qmoNo=;
        b=M5/Hkw25e2NmykvBVejl4WLe2ldNk8MxUFf0cNecBg+jUg5E2wIsxaR/8MNChCY6ki
         wf04oL8mFb9HD/FC70Ez8/cIQvi3iESXwYOOtJyHutE1uTx47P8uQTneQ5TntM0QsT3J
         MTQ9yA3cSCeT0sfS1V/lIjARD1MoA85sIlN1FakroZrdjWUc8D17cPf0AwHtB/20xtKW
         FJEILl2b33grLVyuMc+LzJ5NqtWNtT6Ha5WoREnAHiLIn+BOX7lSW3scqXui5dC0l0L0
         YpymtxuT/oHnGiboGkGOgnuJp2xC/M0RCKB+YLeW5JenVPKQJBiW4A/hDI/NYSHJW+RR
         bLnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nx8rtm61zSc6YwTnf3ZbUlYy9Dq9r8tfsMgUX9qmoNo=;
        b=e797qDRLNe8iFd6zAPYhqQX4ccVVCDw+7MnRTZuoV4xZ3sdBgyzuY23SDgePzJnVEH
         dfpWi3n7PPEABbWOqHjDdMiINfUCB0/y12yXcOhDdM/v3dkPSCuE2CHKWTr6a+brNq31
         OYJGWP9EaUY+irSWeoZ1UvNDc6B03Nc42PP266+qUiGxjsnecMybYvnz4foJprZ+8un+
         yI8F5T9O5XmtV3exgwQrucVT5m5gpUzN+squHkdI4p3wE/GtMkRWqrfd7/imTo9GrkE7
         Tm7U5h4mP+ydQySrLVDmBZUTF0Dfv9vlBLhsLRxjvqfxyv3px5cZU6hEZVQVT7oXlFGE
         Q8ig==
X-Gm-Message-State: AOAM531ebQNupIpKiouIFUhiLcYC34Hts6nTp5A5U8qXPmAh+D7R7i2j
        0zi/ue+LynKHCF7SLLCAYdeDRKgmFf7Ctg==
X-Google-Smtp-Source: ABdhPJxs7jbHcohMQzPKoVJltP/ygn8BjdzO0+cNuYqZdd2RPi+XA5muLZZhaPqRsQPtJmrioVmJbQ==
X-Received: by 2002:a2e:9758:: with SMTP id f24mr18774250ljj.404.1617721361879;
        Tue, 06 Apr 2021 08:02:41 -0700 (PDT)
Received: from galeon.lan (77-254-182-100.adsl.inetia.pl. [77.254.182.100])
        by smtp.gmail.com with ESMTPSA id h6sm2182262lfd.77.2021.04.06.08.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:02:40 -0700 (PDT)
From:   Maciek Borzecki <maciek.borzecki@gmail.com>
To:     linux-kernel@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>
Cc:     Maciek Borzecki <maciek.borzecki@gmail.com>
Subject: [PATCH] cifs: escape spaces in share names
Date:   Tue,  6 Apr 2021 17:02:29 +0200
Message-Id: <dc18955dda8844bf7b27dfd2cce50f7c62eb82e5.1617720952.git.maciek.borzecki@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Commit 653a5efb849a ("cifs: update super_operations to show_devname")
introduced the display of devname for cifs mounts. However, when mounting
a share which has a whitespace in the name, that exact share name is also
displayed in mountinfo. Make sure that all whitespace is escaped.

Signed-off-by: Maciek Borzecki <maciek.borzecki@gmail.com>
---
 fs/cifs/cifsfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 099ad9f3660bb28db1b6a9aea9538282b41c6455..3c6cb85b95e207df222248f10cc9df937cdda24e 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -476,7 +476,8 @@ static int cifs_show_devname(struct seq_file *m, struct dentry *root)
 		seq_puts(m, "none");
 	else {
 		convert_delimiter(devname, '/');
-		seq_puts(m, devname);
+		/* escape all spaces in share names */
+		seq_escape(m, devname, " ");
 		kfree(devname);
 	}
 	return 0;
-- 
2.31.1

