Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0ADC432BE
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:45:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D7860525
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Sep 2021 00:45:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241503AbhIAAqu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Aug 2021 20:46:50 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:45897 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238552AbhIAAqu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Aug 2021 20:46:50 -0400
Received: by mail-pf1-f180.google.com with SMTP id t42so689728pfg.12
        for <linux-cifs@vger.kernel.org>; Tue, 31 Aug 2021 17:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yjX5+UbSzLfq7oAdHONzpIohkx/PI2t8KrniOoyziKI=;
        b=haYrhX4imI+w+aV5pQEtGdG3HNfsJmc7Rfat9Ndy5/BNeYJuaGS5xKi6FkriMgqc25
         aUwvDUeQy+aMNNNZRBKicQO7cSu3eWpAqG02ZXP0XOUXJfVPto4NgoW0vBRj9uqmgmLb
         gWam7FIenYVIIuAl3PqBnfrQoZHnW63DYs+1QFRhKZjwsIjMYEUiW4xBMlXGrkq8WTym
         MOWRIlG36rn02NXD7aKP5PlGvrE4PV9+GwiKVrWTwl2vVMgezNSeVpouZ1LQuv10sv7X
         ymMjF9GVS2/d/JIoGsqTp4Hp/w2OWZp9SDnPjo4t2TbSsSOEs9fUV9QAG5LkBl6cAgL0
         9vpQ==
X-Gm-Message-State: AOAM532fFW6hFfot7Lb/ncLxMQV6lKO3hi+s+JGP3E70meX7kvTzXaS5
        TGyi4cY4mJMMNH/V7pndv4rSvnhZwaV28A==
X-Google-Smtp-Source: ABdhPJxpXQfxGBUxZuCEVmNfMOy4CrNVCV/w+Q1/rWKWY/3ux1ilegtJaIlaYicTEg8AfqN0zEg3+A==
X-Received: by 2002:a62:6447:0:b0:3fa:bce4:c78e with SMTP id y68-20020a626447000000b003fabce4c78emr19289550pfb.15.1630457154073;
        Tue, 31 Aug 2021 17:45:54 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id gg22sm3849024pjb.19.2021.08.31.17.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 17:45:53 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Hyunchul Lee <hyc.lee@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 2/4] ksmbd: smbd: fix dma mapping error in smb_direct_post_send_data
Date:   Wed,  1 Sep 2021 09:45:35 +0900
Message-Id: <20210901004537.45511-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210901004537.45511-1-linkinjeon@kernel.org>
References: <20210901004537.45511-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Hyunchul Lee <hyc.lee@gmail.com>

Becase smb direct header is mapped and msg->num_sge
already is incremented, the decrement should be
removed from the condition.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 58f530056ac0..52b2556e76b1 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1168,7 +1168,7 @@ static int smb_direct_post_send_data(struct smb_direct_transport *t,
 			pr_err("failed to map buffer\n");
 			ret = -ENOMEM;
 			goto err;
-		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES - 1) {
+		} else if (sg_cnt + msg->num_sge > SMB_DIRECT_MAX_SEND_SGES) {
 			pr_err("buffer not fitted into sges\n");
 			ret = -E2BIG;
 			ib_dma_unmap_sg(t->cm_id->device, sg, sg_cnt,
-- 
2.25.1

