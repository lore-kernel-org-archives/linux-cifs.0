Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BF1C4321E
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Nov 2022 11:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233074AbiK2LTw (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Nov 2022 06:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232955AbiK2LTo (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Nov 2022 06:19:44 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C60D5DBA0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Nov 2022 03:19:41 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m7-20020a05600c090700b003cf8a105d9eso10528080wmp.5
        for <linux-cifs@vger.kernel.org>; Tue, 29 Nov 2022 03:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=freebox-fr.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gl0GD9JnH6cpxJhbsuvz2kuf9WhGyPLw4aqUGuCfQWA=;
        b=uT/KmvVxsVHSojKFXypr0XGGPFixtwQ6mS3J6zI48Tip94Ze7B62Zdw6YesDzTSMNu
         rx7aK9WT6XqGRV6MbOa9ZJSy1tWKyp97vDdXDKGBicwY+3J5HzVc+xCcZ+mVKiRMDtt/
         stVMRIfRSfdjBstMcbvooh7UTeGNdYidYaef7E8CaXHzqJPKfxRKJbPS579gC0qoIk39
         Bz6JKpTuS5/AgXyp+tpT357+P0w5rlFZ7atpS+2flKgWlbIl0NCEx+nffslutKCNirho
         OBBPKQ1EgvecymBTHaqVmVD8p5fNF49NhpV2OARpD/igfTa/k1h+YOALG6kgzSkSNPNa
         6tIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gl0GD9JnH6cpxJhbsuvz2kuf9WhGyPLw4aqUGuCfQWA=;
        b=Ynu2non7a5UFWc0WgyyiibxvKA5kcDhF9QNdWCPTbeX5WZbODkQ1dVtXbiP2WqFLxM
         0fhu+89wmhYRdUSj/IAkOHJ1wWcBXgH7/AC568crfdxuFt2LivvHrTIG2ZO7guhil+X2
         Ixked/KuFANXahZVlHJx2onuwgIdu1GjC+Rl78Yv+2GYRDz8sqh9nbGc+I4jBYIESHjJ
         Or61LqSWr+xeWl+TqLGIpC1Ww6xLowau2PZUqKU9rF79GQvu1eUf3FlLcW6iCqMyLhsv
         3r5S2GrIaux852kuLUA6sWKrPQStlB0ACDUSmG/NK1GVSdg4nkNLhh0cJn0v/nbrc7wQ
         VGOA==
X-Gm-Message-State: ANoB5pnMYyuAS2q5e8QZyHTXssJ1rpT77c3Fmf3b8I3WkVsGBbK0soep
        9RZ55++O3zy+k1FMDpnTyWgiN4lJq/R9ZZTV
X-Google-Smtp-Source: AA0mqf6s+tPE+SgTjpPt3Sun2U4COJ9Ba0Ene9WaCmjPrBqZ09tXI4hxGh8HNxCCE1XPU5diEZIV7Q==
X-Received: by 2002:a05:600c:4e09:b0:3cf:55bd:4944 with SMTP id b9-20020a05600c4e0900b003cf55bd4944mr43665573wmq.64.1669720779498;
        Tue, 29 Nov 2022 03:19:39 -0800 (PST)
Received: from marios-t5500.iliad.local (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id dn11-20020a05600c654b00b003c701c12a17sm1693425wmb.12.2022.11.29.03.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 03:19:39 -0800 (PST)
From:   Marios Makassikis <mmakassikis@freebox.fr>
To:     linux-cifs@vger.kernel.org
Cc:     Marios Makassikis <mmakassikis@freebox.fr>
Subject: [PATCH] ksmbd: Fix resource leak in smb2_lock()
Date:   Tue, 29 Nov 2022 12:19:33 +0100
Message-Id: <20221129111933.2251777-1-mmakassikis@freebox.fr>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"flock" is leaked if an error happens before smb2_lock_init(), as the
lock is not added to the lock_list to be cleaned up.

Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
---
 fs/ksmbd/smb2pdu.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b2fc85d440d0..58da085413a6 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6855,6 +6855,7 @@ int smb2_lock(struct ksmbd_work *work)
 		if (lock_start > U64_MAX - lock_length) {
 			pr_err("Invalid lock range requested\n");
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6874,6 +6875,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
 				    flock->fl_end, flock->fl_start);
 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
+			locks_free_lock(flock);
 			goto out;
 		}
 
@@ -6885,6 +6887,7 @@ int smb2_lock(struct ksmbd_work *work)
 				    flock->fl_type != F_UNLCK) {
 					pr_err("conflict two locks in one request\n");
 					err = -EINVAL;
+					locks_free_lock(flock);
 					goto out;
 				}
 			}
@@ -6893,6 +6896,7 @@ int smb2_lock(struct ksmbd_work *work)
 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
 		if (!smb_lock) {
 			err = -EINVAL;
+			locks_free_lock(flock);
 			goto out;
 		}
 	}
-- 
2.25.1

