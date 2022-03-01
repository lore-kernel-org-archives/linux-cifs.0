Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AED7C433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 11:01:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234176AbiCALCY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:02:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233502AbiCALCY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 06:02:24 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA9B8C7D4
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 03:01:43 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id ay10so2028065wrb.6
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 03:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xg3Af1twinQOVUi2sbiXaA4yLa5bgx5Q8+pd1xOOk5A=;
        b=6YEPfez15h7MzaJNjDtN53liCz5k/CEMPQMvEj17e+/CSsnp2VouW46RyHuV5jgAZe
         xcDV9YhIC9kKm+C/cs0H/A/Ts9EiXTKhvRXGegIQ58ZXcEeF173HhiKjXDzTO63TnlW+
         fYk/9/40TqkBVZTXdAvembtiNqJnCewd2iaGvULSOAUA0qbohaNypekqzzKcePUGeTyB
         aOMgXvKwY24/XyZfILO9wCD2HF4WK32rsoE3eNqED8zpcl5i9ty5SxgqSDyC2EHKvk/Z
         /7YeoxEopoSwj/5dyDu8R6Y1IhP3U0xg8XeEAlsMXmE5EM7Z+MoAERxMOaAJqU0HRCsE
         4G8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xg3Af1twinQOVUi2sbiXaA4yLa5bgx5Q8+pd1xOOk5A=;
        b=zeEg5TQxa11uZfoccg7BOZemI39rYFR3SqxLS4xKKGk16UniTRBq1/bORM7Cynu94K
         hHQ2M7fTfY96g0wEQU+JxB3SFMrqBrTPvgTdxCkiPQ7LJ95pm0xonYOLQwt9zKc7XQkB
         skgHjIFEPcaUYi+0dOuLNNpe3hja+FqNVLr96+SVgfnrzDvfy7ybo/Sf+zwazZ3qJMWo
         hqlpJ9QpTEJhqQ41ZZnz53MBAvs/0SP4d8IVy/uzi085NKIO5Tlif30D6yigwknXVId5
         4OUwd7aOydSRTZ7y1j8jsvzwAZSYeCH0VRQMxlLRm4/eXbrsSSJfYHOPZ6sa2wKRz/u0
         OCmw==
X-Gm-Message-State: AOAM531gnCa3DHh4/qarZN3M7/7mCLu68xhTWosBFd6ZTNp0ZZuEhLf5
        y4QI1EdJLkcUJ1jEGUHEqxIKRpz1OG6lAA==
X-Google-Smtp-Source: ABdhPJwAOG2k8aUoQQtuChhV1Wi9NZN4KzFJKM2IcR3X7UcsO15/KuEBU3+0605w+eYdC91tiYfOJg==
X-Received: by 2002:adf:eb11:0:b0:1ef:ca9b:7bd9 with SMTP id s17-20020adfeb11000000b001efca9b7bd9mr7347394wrn.125.1646132502075;
        Tue, 01 Mar 2022 03:01:42 -0800 (PST)
Received: from marios-t5500.iliad.local ([2a01:e0a:0:22a0:fa5e:e68e:157b:df1d])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d56c6000000b001edb64e69cdsm13306904wrw.15.2022.03.01.03.01.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:01:41 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 4/4] ksmbd-tools: Fix potential out-of-bounds write in ndr_write_*
Date:   Tue,  1 Mar 2022 12:00:10 +0100
Message-Id: <20220301110006.4033351-4-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301110006.4033351-1-mmakassikis@freebox.fr>
References: <20220301110006.4033351-1-mmakassikis@freebox.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

align_offset() may advance the offset at which the data will be written,
so it should be called before verifying that there is enough room in the
output buffer.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 mountd/rpc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mountd/rpc.c b/mountd/rpc.c
index 9d6402ba5281..20a445dea347 100644
--- a/mountd/rpc.c
+++ b/mountd/rpc.c
@@ -294,9 +294,9 @@ static __u8 noop_int8(__u8 v)
 #define NDR_WRITE_INT(name, type, be, le)				\
 int ndr_write_##name(struct ksmbd_dcerpc *dce, type value)		\
 {									\
+	align_offset(dce, sizeof(type));				\
 	if (try_realloc_payload(dce, sizeof(value)))			\
 		return -ENOMEM;						\
-	align_offset(dce, sizeof(type));				\
 	if (dce->flags & KSMBD_DCERPC_LITTLE_ENDIAN)			\
 		*(type *)PAYLOAD_HEAD(dce) = le(value);			\
 	else								\
@@ -377,10 +377,10 @@ NDR_READ_UNION(int32, __u32);
 
 int ndr_write_bytes(struct ksmbd_dcerpc *dce, void *value, size_t sz)
 {
+	align_offset(dce, 2);
 	if (try_realloc_payload(dce, sizeof(short)))
 		return -ENOMEM;
 
-	align_offset(dce, 2);
 	memcpy(PAYLOAD_HEAD(dce), value, sz);
 	dce->offset += sz;
 	return 0;
-- 
2.25.1

