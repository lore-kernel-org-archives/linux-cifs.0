Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D0ECC433EF
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 05:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbiAGFpn (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 00:45:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiAGFpn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 7 Jan 2022 00:45:43 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 169FBC061245
        for <linux-cifs@vger.kernel.org>; Thu,  6 Jan 2022 21:45:43 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id pj2so3121710pjb.2
        for <linux-cifs@vger.kernel.org>; Thu, 06 Jan 2022 21:45:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LMhifQH3ZbEN9d1BRKxxkhbvNjQcnk2TfLCQkcY7FZs=;
        b=ThxWc0yu3SaM0CH+GF2opj89ITmagLRYBA5YsupXMiqMhrhi2oZnO53vXSk6fyrxJV
         R45+kmG5TcNc6fSUjiiFW6VEUYHtiNOdu84ZuuHbgaiLQkVuqQpEC4ue9RTcCzAKSzyJ
         auYG8TcVzidWzG83BIKJiayhGDPZf1u7mI1Z/pUJKmJZYy12SExrSoweESuObtbjHcs3
         HI/MbnUX395LYf9zd5rFHQKzPLzD3wXndZVT3t9tbQaXXuKJjXz9Nccuq9ENDbC1vOub
         XkGs1jFs4uVqglkzsqGxbkIh4MkY84tlB+2qC8DKqGKDEcXyxH7wPhFkW0C1U+NwxZJJ
         Asiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LMhifQH3ZbEN9d1BRKxxkhbvNjQcnk2TfLCQkcY7FZs=;
        b=nNqaMggHEwLiXedZan+CJvib67imDhIN36KM4EkI1/4ox3QwtPJpIvZ+J8Vpr4FkJG
         2swi+oGn3p4joii0W0TP+mUSBo4XC71EApZ0nLu0CFh+QU5j5Oxwsy+7ixeKcjVN8aCd
         +kSNSMKPaAYrWe3homoSNhwe+9o1XBH3gfh5gQDiOY/rWzEvjwzUXEWOj0sEcBuCjxo3
         3aKCmxj2WQYKsKvaS6yM5sgN+k7yKn3DI7jCbPJSYQIYAx2P+234Dys/ttQaHk9Bs0HF
         nQ0twHFjLozfTfQUvJB3sqJ/uRHS4S5eQSnItWLDOrLvN+VxTZZuvD3Nq/SmC/g+z0Z0
         JLww==
X-Gm-Message-State: AOAM533UwNjX0z03h6YvpEayoV3SsUcdbBMg+RcweLVizVieEqfm9aYF
        8X7z+/5vJ1Cin8D+1cMYAFIlATiPjhY=
X-Google-Smtp-Source: ABdhPJw3I5vVFT1Sa9qOExjY+RkaBbMq4D19rxtqyCn/ndEeTyyl6MhPb1Lbg6YbaIk5L/StWMm2Yw==
X-Received: by 2002:a17:902:9887:b0:14a:199:bc51 with SMTP id s7-20020a170902988700b0014a0199bc51mr3188048plp.39.1641534342381;
        Thu, 06 Jan 2022 21:45:42 -0800 (PST)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id r7sm3348489pgm.15.2022.01.06.21.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 21:45:42 -0800 (PST)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH 1/2] ksmbd: smbd: create MR pool
Date:   Fri,  7 Jan 2022 14:45:30 +0900
Message-Id: <20220107054531.619487-1-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create a memory region pool because rdma_rw_ctx_init()
uses memory registration if memory registration yields
better performance than using multiple SGE entries.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 0fd706d01790..f0b17da1cac2 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -428,6 +428,7 @@ static void free_transport(struct smb_direct_transport *t)
 
 	if (t->qp) {
 		ib_drain_qp(t->qp);
+		ib_mr_pool_destroy(t->qp, &t->qp->rdma_mrs);
 		ib_destroy_qp(t->qp);
 	}
 
@@ -1708,7 +1709,9 @@ static int smb_direct_init_params(struct smb_direct_transport *t,
 	cap->max_send_sge = SMB_DIRECT_MAX_SEND_SGES;
 	cap->max_recv_sge = SMB_DIRECT_MAX_RECV_SGES;
 	cap->max_inline_data = 0;
-	cap->max_rdma_ctxs = 0;
+	cap->max_rdma_ctxs =
+		rdma_rw_mr_factor(device, t->cm_id->port_num, max_pages) *
+		smb_direct_max_outstanding_rw_ops;
 	return 0;
 }
 
@@ -1790,6 +1793,7 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 {
 	int ret;
 	struct ib_qp_init_attr qp_attr;
+	int pages_per_rw;
 
 	t->pd = ib_alloc_pd(t->cm_id->device, 0);
 	if (IS_ERR(t->pd)) {
@@ -1837,6 +1841,23 @@ static int smb_direct_create_qpair(struct smb_direct_transport *t,
 	t->qp = t->cm_id->qp;
 	t->cm_id->event_handler = smb_direct_cm_handler;
 
+	pages_per_rw = DIV_ROUND_UP(t->max_rdma_rw_size, PAGE_SIZE) + 1;
+	if (pages_per_rw > t->cm_id->device->attrs.max_sgl_rd) {
+		int pages_per_mr, mr_count;
+
+		pages_per_mr = min_t(int, pages_per_rw,
+				     t->cm_id->device->attrs.max_fast_reg_page_list_len);
+		mr_count = DIV_ROUND_UP(pages_per_rw, pages_per_mr) *
+			atomic_read(&t->rw_avail_ops);
+		ret = ib_mr_pool_init(t->qp, &t->qp->rdma_mrs, mr_count,
+				      IB_MR_TYPE_MEM_REG, pages_per_mr, 0);
+		if (ret) {
+			pr_err("failed to init mr pool count %d pages %d\n",
+			       mr_count, pages_per_mr);
+			goto err;
+		}
+	}
+
 	return 0;
 err:
 	if (t->qp) {
-- 
2.25.1

