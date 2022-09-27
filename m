Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F92AC07E9D
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 21:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbiI0VwF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 17:52:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiI0VwF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 17:52:05 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D5C71721
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 14:52:02 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id bh13so10579581pgb.4
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 14:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Z5cy4v0OxrGPyZev4b0GHYZ5MRtmd9AS1V0rNkydW7Y=;
        b=EYIVsGCYoap/gfIptopaDCWLUkxGqGwKPWrW+3tkG0Xte2eJReDVSuh+nFA4Tt0VNe
         fQE1z/2JEK0kMlGn6+c3FQH/Q+JdcLfbO8zVic0rbzDVQ+Gk/szUkY4sZkFZWGw+j/i0
         fassRGwAReCTZzgcDAUofEQtgfvVNSqgWs9+nM9K43xrDGwt8A2R9sML8PNMcTkICX5h
         MYzAj+hsxWRaSL4q6EFM6J99+PeSXEMnlWav9nluzCb8QVz4w9lRlSPzgtwNI/TT3aoL
         Fng+posbIBOCIhc/6PxKXegFUkQsFMvL2i1Kzk/iEAGKTvfO40w38ebLg/hfPWSv7ZiK
         h1cA==
X-Gm-Message-State: ACrzQf0NhVQ/N7Uf0l+KbkC27NJ+Y4bemYhxu+Z4RLeg27EI69ssv/kS
        51GtDUILTMTskQGHA06GI16VBUK5UzM=
X-Google-Smtp-Source: AMsMyM4xqzxbB4dvpzElNpFSGUUASGx72iO09x5C3bbCTgyLBZGQDWxjb5tokgOC+dLrfjFKaKoMXA==
X-Received: by 2002:a05:6a00:114c:b0:528:2c7a:6302 with SMTP id b12-20020a056a00114c00b005282c7a6302mr31360438pfm.37.1664315520800;
        Tue, 27 Sep 2022 14:52:00 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id c12-20020a170902d48c00b00179e1f08634sm2036291plg.222.2022.09.27.14.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 14:52:00 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: hide socket error message when ipv6 config is disable
Date:   Wed, 28 Sep 2022 06:51:51 +0900
Message-Id: <20220927215151.6931-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When ipv6 config is disable(CONFIG_IPV6 is not set), ksmbd fallback to
create ipv4 socket. User reported that this error message lead to
misunderstood some issue. Users have requested not to print this error
message that occurs even though there is no problem.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/transport_tcp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 143bba4e4db8..9b35afcdcf0d 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -399,7 +399,8 @@ static int create_socket(struct interface *iface)
 
 	ret = sock_create(PF_INET6, SOCK_STREAM, IPPROTO_TCP, &ksmbd_socket);
 	if (ret) {
-		pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
+		if (ret != -EAFNOSUPPORT)
+			pr_err("Can't create socket for ipv6, try ipv4: %d\n", ret);
 		ret = sock_create(PF_INET, SOCK_STREAM, IPPROTO_TCP,
 				  &ksmbd_socket);
 		if (ret) {
-- 
2.25.1

