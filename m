Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79D0EC433F5
	for <linux-cifs@archiver.kernel.org>; Tue,  1 Mar 2022 11:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiCALBi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 1 Mar 2022 06:01:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233728AbiCALBh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 1 Mar 2022 06:01:37 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD7890FC1
        for <linux-cifs@vger.kernel.org>; Tue,  1 Mar 2022 03:00:56 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id p9so19830127wra.12
        for <linux-cifs@vger.kernel.org>; Tue, 01 Mar 2022 03:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=At0PtalEwHx15xTj/YS/qxuHepU5RcQbEfTeG40kIgg=;
        b=eN0q+e+cISpJ0L2u/PM9JgofF4YltRLTSXgBD5LJUShFO/kd26U/KM7TGufFbALOPs
         RBF9UaeWGwETc+fQy8LOttyMMbgoVwaDuJmR0flOh25uasxzKX2WvtpGxRbKjHttZB7h
         zHuD4WxLoULXTT6hQssrd3pxsyve8Q5+0ISJr2wBUDyiyFtZHbRgoR+bfnEZWO250eAY
         SFO77T9mvOH/Ew4PQT5vIPAPXQH6qrb8Y+53P1NOypk/R2W76PPq3yhMWz7wNwdJxfuH
         HdIhQoRwcTHkD9Hhup4XGHw0B70Uz4L+zzZmpBi0wOCd/ep2vaGi56q8uqQ3Cr/85QjJ
         fgfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=At0PtalEwHx15xTj/YS/qxuHepU5RcQbEfTeG40kIgg=;
        b=fmvqUZMSbnull7L8irkgafIykWhAhUvKUmLIfBDXS6eaQRP7bmBOdcAIgCmk08pXLM
         IV0K4Nw7x1Rb5VChbd4mTuWAZoa423hO9HLbu+Wa0nDKE244pwXZjlb3rK1BRCBuyELi
         zkSnjmXJUnIQ3xD1yxL3vRx9RYIm3w5pj5P/lNTEe292XFJGNjC4pKPdVpb6T26ny3+G
         zG3DGJAB5p6qim0vNb8gtQcvOdolH2rEiHKZpNmyZqS0ybphCNrDjiSkn2A/GiE/YANS
         oU8+2pL45eJJGQ+DZX+rctFu7mFUoSp/8NYFYyOoPyFnx4htRjDvYGC9tzLImwvrYvX0
         GVFw==
X-Gm-Message-State: AOAM533EF/o+FyWH1xWv1ICnW/JqxNnKs7dAdRshEKz0iHDo7j5kZecB
        xOHv1GCem2pQpW9dejH8jZ7nxl8XtGXm+Q==
X-Google-Smtp-Source: ABdhPJz3+EZ7I8k3bukPZZuY5gP0U2PUgvwPAp2QUF88jpt4o16lmoYPioijQEwVo8siYWK1qqTfQA==
X-Received: by 2002:adf:9d84:0:b0:1ed:f546:bd8b with SMTP id p4-20020adf9d84000000b001edf546bd8bmr18640147wre.375.1646132454883;
        Tue, 01 Mar 2022 03:00:54 -0800 (PST)
Received: from marios-t5500.iliad.local ([2a01:e0a:0:22a0:fa5e:e68e:157b:df1d])
        by smtp.gmail.com with ESMTPSA id m6-20020a5d56c6000000b001edb64e69cdsm13306904wrw.15.2022.03.01.03.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:00:54 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH 2/4] ksmbd-tools: Fix memory leak in lsarpc_lookup_names3_invoke
Date:   Tue,  1 Mar 2022 12:00:06 +0100
Message-Id: <20220301110006.4033351-2-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301110006.4033351-1-mmakassikis@freebox.fr>
References: <20220301110006.4033351-1-mmakassikis@freebox.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If usm_lookup_user() fails, the "ni" struct is leaked.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 mountd/rpc_lsarpc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mountd/rpc_lsarpc.c b/mountd/rpc_lsarpc.c
index cc99a147b239..b9088950c46e 100644
--- a/mountd/rpc_lsarpc.c
+++ b/mountd/rpc_lsarpc.c
@@ -357,8 +357,10 @@ static int lsarpc_lookup_names3_invoke(struct ksmbd_rpc_pipe *pipe)
 		}
 
 		ni->user = usm_lookup_user(name);
-		if (!ni->user)
+		if (!ni->user) {
+			free(ni);
 			break;
+		}
 		pipe->entries = g_array_append_val(pipe->entries, ni);
 		pipe->num_entries++;
 		smb_init_domain_sid(&ni->sid);
-- 
2.25.1

