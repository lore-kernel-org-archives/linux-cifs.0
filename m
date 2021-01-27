Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 125F3C433DB
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 21:47:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BCE7F64DC4
	for <linux-cifs@archiver.kernel.org>; Wed, 27 Jan 2021 21:47:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhA0Vrj (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 27 Jan 2021 16:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhA0Vpb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 27 Jan 2021 16:45:31 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14AAC061573
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 13:44:50 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id w14so2230450pfi.2
        for <linux-cifs@vger.kernel.org>; Wed, 27 Jan 2021 13:44:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=adamharvey.name; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GWylxxniWolLjuTyr6PPGv+53DqSkPBxUk8s1BRW+R0=;
        b=HRQqk5Hmjlve6m5fZgLbel9z48UVVy43LKc+zWNJj8/IsN7j9/pgg8+9knTJsAh1IP
         7LsHnFiEfsGj9ieNyCdtzJLk4lHu/0TJAEULT5V9hRvGjM7iVBf2/oRsEqDdSQRHZWtM
         GxT6PpHDCv2VfsB5gsp1NcYQxe6irloVqxM3E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GWylxxniWolLjuTyr6PPGv+53DqSkPBxUk8s1BRW+R0=;
        b=Evyil4cPbrWdsHPG2E4ycCuJgbFWcWar1QvQpYuOLNFNr8o8Otq4LXwDkdiGl46jFq
         9BomOAzpnOW0yeFqPMVjw37A7unImWFLPLPhx3FSxtQBJdd3dMUl3zpTywUgscPoeY0x
         zsqDO1knGJc7YjJtKZAzqJXEfu53GLNj8dZpx7G1vlpxdKGHMioF6q1KXJ0euyquaIdt
         Rp4wmhCKooSzI8ZeUAuI79LuYaT66sjap9RH3GXN1tcdv/dIM3WUh0poFOfoEeaHLSlQ
         +LkB00apssBpggOb+ZXTqrCWcUvkn/eCCV0OYaD+VWRg3/OmLVG7tD6Wj+FSD9ANkurU
         OPpA==
X-Gm-Message-State: AOAM532DJPmXqJ6XDa2THdPUHZaTw1jPznFZQMnRcLoiNN+yipCzJ9vE
        XG6l4a6PM8GHGSezQ2Hl7z3VAmnk9mmZtsVJ
X-Google-Smtp-Source: ABdhPJz4yEnDfN3aYH/8pJaYQPEHg1Vm55bZViyzTR2PcCUswviDsXiEY7Nuv8Zm+OQSuxmgjQ6IZw==
X-Received: by 2002:a65:4203:: with SMTP id c3mr13270803pgq.65.1611783889654;
        Wed, 27 Jan 2021 13:44:49 -0800 (PST)
Received: from nosecam.localdomain (node-1w7jr9qw9msspx5ewy5tkdyef.ipv6.telus.net. [2001:569:7eea:3500:ca69:1f75:9176:e767])
        by smtp.gmail.com with ESMTPSA id r194sm3400383pfr.168.2021.01.27.13.44.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:44:48 -0800 (PST)
From:   Adam Harvey <adam@adamharvey.name>
To:     linux-cifs@vger.kernel.org, sfrench@samba.org
Cc:     smfrench@gmail.com, aaptel@suse.com,
        samba-technical@lists.samba.org, Adam Harvey <adam@adamharvey.name>
Subject: [PATCH] cifs: ignore auto and noauto options if given
Date:   Wed, 27 Jan 2021 13:44:35 -0800
Message-Id: <20210127214434.3882-1-adam@adamharvey.name>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
References: <CADajX4DzoNehHZGqpd+3Bh0yM2U=B6AwL6bJ2EM6t6hkvr7L4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In 24e0a1eff9e2, the noauto and auto options were missed when migrating
to the new mount API. As a result, users with noauto in their fstab
mount options are now unable to mount cifs filesystems, as they'll
receive an "Unknown parameter" error.

This restores the old behaviour of ignoring noauto and auto if they're
given.

Fixes: 24e0a1eff9e2 ("cifs: switch to new mount api")
Signed-off-by: Adam Harvey <adam@adamharvey.name>
---
 fs/cifs/fs_context.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
index 076bcadc756a..62818b142e2e 100644
--- a/fs/cifs/fs_context.c
+++ b/fs/cifs/fs_context.c
@@ -175,6 +175,7 @@ const struct fs_parameter_spec smb3_fs_parameters[] = {
 	fsparam_flag_no("exec", Opt_ignore),
 	fsparam_flag_no("dev", Opt_ignore),
 	fsparam_flag_no("mand", Opt_ignore),
+	fsparam_flag_no("auto", Opt_ignore),
 	fsparam_string("cred", Opt_ignore),
 	fsparam_string("credentials", Opt_ignore),
 	{}
-- 
2.30.0

