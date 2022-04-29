Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 056A8C433EF
	for <linux-cifs@archiver.kernel.org>; Fri, 29 Apr 2022 23:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355464AbiD2Xff (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 29 Apr 2022 19:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359175AbiD2Xfd (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 29 Apr 2022 19:35:33 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC0CEE2F
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:10 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id iq2-20020a17090afb4200b001d93cf33ae9so11758500pjb.5
        for <linux-cifs@vger.kernel.org>; Fri, 29 Apr 2022 16:32:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fDlOl21l4ETrMaDspbxm5CFnTmPCRTyFYBQijp4DDoQ=;
        b=gZHATNyY+NXH5Fnd5vp0nPWhWHTNvc66LViLM1sKj2/VQ52rnxVD5qa7DbgZNKeFaL
         1i5qRNWwcZz1PaoXa+UuPx2zeSG1SlG+Bge+TW+IoWwtRcdSiTPX4AmgeX1tfkSKcTV1
         9v3T9cRHSDh4OQSqmLzleLyPHtP59Djm7HVTbl6tPyB/rABMTCr7FGodpt7wJruNTA/V
         Ggz5Lah2LsQ7OXJH0APgTs3wRyN5j50CLmMcPJicxm9y+rFRzgrXG0pJV8yZkPbZqfJL
         fXNBnJDOJTRWbgj92WhApZp8aTfUaNh02Duz6Izv2Sf12ydcH6kgkjo+2mIMlc7b58uR
         aA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fDlOl21l4ETrMaDspbxm5CFnTmPCRTyFYBQijp4DDoQ=;
        b=aNAgYFHFANz60zwvyOinL9yZ2arBRKJ4n78fVufR9w5yzOoXD+oX97yufZ7XN3LK4g
         M5FXjItjvdB3+jHUMh19hlgQx1v+UMdbzPJhyBMxjKSDSKFRh/2dHfCzGgu0v+zIsziz
         uzTsFYmQ9FPFg3DDhdKFqRFJJR6fS5VURVXXF+UtppDWWJndHB4lZXedoXVFpBWnSpCJ
         G2lUkumx6ZacsKSip2AmOhnlKzUbj+lbUveyvX/O/gYvdXYeR0SLqqbJpYbMMhOXBK4e
         ROrQ7kKkxfUVXYL2GwaUcmufn05rn1Y6m/o480B7Fd6Cp74CwYpwwb9dELc5UbCxCrzd
         iYXA==
X-Gm-Message-State: AOAM532DTjTWe7KPQorOzACNwiTejudn2Yq+Ehk6De0Mw/Gj/XrsM0sJ
        wVulFk6gHjw6wCQL6xw1VFUtoAufy8A=
X-Google-Smtp-Source: ABdhPJwbtL0/9he9u+2LFZgNF+uWJQNti9wMq+cZO9aU0NvLP9Nh9AdrT7Y1bqQ8W1/FUWP9GDIekA==
X-Received: by 2002:a17:90b:352:b0:1c6:77e:a4f7 with SMTP id fh18-20020a17090b035200b001c6077ea4f7mr6414836pjb.77.1651275129964;
        Fri, 29 Apr 2022 16:32:09 -0700 (PDT)
Received: from localhost.localdomain ([125.177.232.58])
        by smtp.googlemail.com with ESMTPSA id h9-20020a62b409000000b0050dc7628180sm230227pfn.90.2022.04.29.16.32.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 16:32:09 -0700 (PDT)
From:   Hyunchul Lee <hyc.lee@gmail.com>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Steve French <smfrench@gmail.com>,
        Yufan Chen <wiz.chen@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH v4 4/5] ksmbd: smbd: change the return value of get_sg_list
Date:   Sat, 30 Apr 2022 08:30:28 +0900
Message-Id: <20220429233029.42741-4-hyc.lee@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220429233029.42741-1-hyc.lee@gmail.com>
References: <20220429233029.42741-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Make get_sg_list return EINVAL if there aren't
mapped scatterlists.

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 fs/ksmbd/transport_rdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index 4372d631735e..696ffd2ae661 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -1079,7 +1079,7 @@ static int get_sg_list(void *buf, int size, struct scatterlist *sg_list, int nen
 	int offset, len;
 	int i = 0;
 
-	if (nentries < get_buf_page_count(buf, size))
+	if (size <= 0 || nentries < get_buf_page_count(buf, size))
 		return -EINVAL;
 
 	offset = offset_in_page(buf);
@@ -1111,7 +1111,7 @@ static int get_mapped_sg_list(struct ib_device *device, void *buf, int size,
 	int npages;
 
 	npages = get_sg_list(buf, size, sg_list, nentries);
-	if (npages <= 0)
+	if (npages < 0)
 		return -EINVAL;
 	return ib_dma_map_sg(device, sg_list, npages, dir);
 }
-- 
2.25.1

