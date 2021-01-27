Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99A48C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 07:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A71620729
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 07:19:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231737AbhA0HS2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 02:18:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232728AbhA0HMS (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 02:12:18 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112B3C061573
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 23:11:38 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id gx1so777083pjb.1
        for <linux-cifs@vger.kernel.org>; Tue, 26 Jan 2021 23:11:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adamharvey.name; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qzgNAxWAFXQXQLx4F173JnptpMxwPuWoS6nBfBndQi0=;
        b=cUOpYY4H2KllHu8VHdOnH5ELBn6cHINbSscnoJwKBypU1anFHuvOIRc5fvKyVz7K2d
         IpC08hR7j3JA0k5svYN7t4G7KNgykWALtcBCBux7Yca1K9FL9qiKxBkSrglP50vCnj3o
         XgrXcwsxjS+Ng2W3ypyBf/BY9ccZWqLCL7aVY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qzgNAxWAFXQXQLx4F173JnptpMxwPuWoS6nBfBndQi0=;
        b=fCVxVQ4I5QdfL/tBeE+HAeXX8JQyfbnrZJz50GctKtYs4XHl2nC4DMmTepgvxoudaa
         lIX2IBAOTnu0bn4zMAo50MczWgU4vPqe6cm+ScYA2umYCNdpodZqozzWc7to0rH4B3V3
         zuhGbl2gKY/5sO6O3/66a093XJjRSC0lG6TFAfRoT9dPFCFmdX90dkbVmkyJ+ieqohRO
         Xkj9N++D7JtNmM+0beib+wouyJ6Sc44qBbQ7hIkfZdc1QqH2RhgQUhXc8ji9oP7ncnu2
         z6MGGCMvTtyIeBj4QU9GjmKamq1GPKnjSseamzLLx0qbk7UOBynYU99EXa1V2b3wKdtK
         SNEg==
X-Gm-Message-State: AOAM532mrpiC30tR8Na9YuviSQCKEIDLevhUFIw3Liz0ciIK0RRWqgHh
        43H+TYczWzMvIH8oE7zHKPbTdk2RwU51opMv
X-Google-Smtp-Source: ABdhPJw8qxW9upFZ9YKxNakjYpgW3nrOxoJVUz7kb4c7bM8aO0PuJEAX0Gm1ozFSMs997yXV8g1I7g==
X-Received: by 2002:a17:90a:7891:: with SMTP id x17mr4159318pjk.91.1611731497541;
        Tue, 26 Jan 2021 23:11:37 -0800 (PST)
Received: from nosecam.localdomain (node-1w7jr9qw9msspx5ewy5tkdyef.ipv6.telus.net. [2001:569:7eea:3500:ca69:1f75:9176:e767])
        by smtp.gmail.com with ESMTPSA id t6sm1148757pfc.64.2021.01.26.23.11.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 23:11:36 -0800 (PST)
From:   Adam Harvey <adam@adamharvey.name>
To:     sfrench@samba.org, linux-cifs@vger.kernel.org
Cc:     samba-technical@lists.samba.org, Adam Harvey <adam@adamharvey.name>
Subject: [PATCH] cifs: ignore the noauto option if it is provided
Date:   Tue, 26 Jan 2021 23:10:21 -0800
Message-Id: <20210127071020.18052-1-adam@adamharvey.name>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In 24e0a1eff9e2, the noauto option was missed when migrating to the new
mount API. As a result, users with noauto in their fstab mount options
are now unable to mount cifs filesystems, as they'll receive an "Unknown
parameter" error.

This restores the old behaviour of ignoring noauto if it's given.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Adam Harvey <adam@adamharvey.name>
---
 fs/cifs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 076bcadc756a..0edde5c66985 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -171,6 +171,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag("noatime", Opt_ignore),
 	fsparam_flag("relatime", Opt_ignore),
 	fsparam_flag("_netdev", Opt_ignore),
+	fsparam_flag("noauto", Opt_ignore),
 	fsparam_flag_no("suid", Opt_ignore),
 	fsparam_flag_no("exec", Opt_ignore),
 	fsparam_flag_no("dev", Opt_ignore),
-- 
2.30.0

