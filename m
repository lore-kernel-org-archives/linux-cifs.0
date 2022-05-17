Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30C8C433EF
	for <linux-cifs@archiver.kernel.org>; Tue, 17 May 2022 21:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229502AbiEQVqk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 17 May 2022 17:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiEQVqj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 17 May 2022 17:46:39 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1C4C13E87
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 14:46:38 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id oe17-20020a17090b395100b001df77d29587so3775283pjb.2
        for <linux-cifs@vger.kernel.org>; Tue, 17 May 2022 14:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rwJvxyXTcQx16T2QkFUX7zw1tNcXxOOxt5H0y+RHvR8=;
        b=LHhw6d3hi5JY77ZQYvg0A9fB8h+fXDoPVpNJqjzXxfuHcDwfKKsWaC1q8N+f/9FP5J
         YkXlbyZtvFq8WvbqkxNnHbGuYh6RCjrOW8LRbqKUkdi2P6HO435CYZTu0SWFHdowf31R
         zY7VYpESODBhCdIWEPENAwEGxwrz1sNb9gfHrVmKpT2XIFNPaIA2SDOX5QnvEWjbVdX8
         cfUdoie1mC3KafDlLsY2drWIo9VP6Yf2323iSPbQba0gAh/uW5Wn4R2MfvFk9vP9eUu2
         +ZEu/JmZ8VUQR4F0rzBMTi5eziR3zEN6eCK50NPKhUtOMfcyeY4ejaEShB0c8un5Sqis
         TYXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rwJvxyXTcQx16T2QkFUX7zw1tNcXxOOxt5H0y+RHvR8=;
        b=Gy8Gh9DkAwb/TE46WySTgPT05gGAx442rDqZh5/+aAOUdNjBz1SfqR/rmhtnJfuIQg
         iex2HA3bNYPSC4OjJn1o5rPRAMAzph29wz4uZzHwKdTvrKDR4Ozc19zNa9pDoGDVZXTm
         0k0G4wenDvgqJy4eFBUqOANAuxnQY7t9YeVXLDMJbJ4lIMFmBP9usLFAlAKTVF0Hmnam
         x2SFv7Pg8DTrcNdDgSeguC2/YsUtU8i3QpbcdIgvJg3icr5voHmKzVmBe3YAQnnxcqxi
         I2aky7Bdla008VsP5AjVrALJFoKsn7qaP3WzyA8TB4NQzDl7kH9YrR5r3NCl25nrSMby
         WFiA==
X-Gm-Message-State: AOAM531QONGUYVuRcz8jXvizDzglXVJYKEwU5yKvL4fF9I6EhSnus4FX
        lSQfpasLaXpqF3zulYAjUiX2PX9FFuLrkw==
X-Google-Smtp-Source: ABdhPJxKZBqToH8YB7Qri48wPFCyLYkDRoiunjhMpzvFjoBMYt6AxBJcCUxmSR0QT4NieRUzmgVe0w==
X-Received: by 2002:a17:902:9a92:b0:161:4e50:3b80 with SMTP id w18-20020a1709029a9200b001614e503b80mr17473545plp.149.1652823997910;
        Tue, 17 May 2022 14:46:37 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id r2-20020a17090a0ac200b001cd498dc153sm2764145pje.3.2022.05.17.14.46.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 14:46:37 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>
Subject: [PATCH 2/2] ksmbd: smbd: fix connection dropped issue
Date:   Wed, 18 May 2022 06:46:08 +0900
Message-Id: <20220517214608.283538-2-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220517214608.283538-1-hyc.lee@gmail.com>
References: <20220517214608.283538-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When there are bursty connection requests,
RDMA connection event handler is deferred and
Negotiation requests are received even if
connection status is NEW.

To handle it, set the status to CONNECTED
if Negotiation requests are received.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Reported-by: Yufan Chen <wiz.chen@gmail.com>
Tested-by: Yufan Chen <wiz.chen@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 0741fd129d16..e91acc2746bc 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -576,6 +576,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;
-- 
2.25.1

