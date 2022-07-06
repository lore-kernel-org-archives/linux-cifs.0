Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5339BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jul 2022 15:30:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233578AbiGFPau (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbiGFPar (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Jul 2022 11:30:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF81C240B7;
        Wed,  6 Jul 2022 08:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1805B81D93;
        Wed,  6 Jul 2022 15:30:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B220C3411C;
        Wed,  6 Jul 2022 15:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121444;
        bh=W6YdQucwnWPTC/znTUpqgn+m+9J1rxn04314aFykl0I=;
        h=From:To:Cc:Subject:Date:From;
        b=H73t2HpCC8bHWKU+LtGvbpnpuy5XLcZC91kt6PXPA7+D7ZSJRgvZ1wqxoAAnShA2Y
         8WNMLcU+8BWgxzm8rvI9BplJ8tYlZZeeCLdne0hH7KuK1fuRSwi11bZ1rEI83hXTVH
         nA/KJpMUtH4drSQ+uiOBwQtEELlHStQrqrVVg95K5MBUG+OlBaiMdNBAhFxOWIqajp
         Ycq1HhBoRXwJtpuLiaFoRLK0pUJxUW2FAfU63YkaW5zRBVVNNSIqcVKuUJ9vDK9JU/
         273L1M3PZWYOBTPvOm0n1RFnydtVRRcgjbAcwj6K58Av+1zpNHvMXmuTkSIDHDXRJY
         2vkD2tliKxhzw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Namjae Jeon <linkinjeon@kerne.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 01/22] ksmbd: use SOCK_NONBLOCK type for kernel_accept()
Date:   Wed,  6 Jul 2022 11:30:19 -0400
Message-Id: <20220706153041.1597639-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit fe0fde09e1cb83effcf8fafa372533f438d93a1a ]

I found that normally it is O_NONBLOCK but there are different value
for some arch.

/include/linux/net.h:
#ifndef SOCK_NONBLOCK
#define SOCK_NONBLOCK   O_NONBLOCK
#endif

/arch/alpha/include/asm/socket.h:
#define SOCK_NONBLOCK   0x40000000

Use SOCK_NONBLOCK instead of O_NONBLOCK for kernel_accept().

Suggested-by: David Howells <dhowells@redhat.com>
Signed-off-by: Namjae Jeon <linkinjeon@kerne.org>
Reviewed-by: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ksmbd/transport_tcp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ksmbd/transport_tcp.c b/fs/ksmbd/transport_tcp.c
index 8fef9de787d3..143bba4e4db8 100644
--- a/fs/ksmbd/transport_tcp.c
+++ b/fs/ksmbd/transport_tcp.c
@@ -230,7 +230,7 @@ static int ksmbd_kthread_fn(void *p)
 			break;
 		}
 		ret = kernel_accept(iface->ksmbd_socket, &client_sk,
-				    O_NONBLOCK);
+				    SOCK_NONBLOCK);
 		mutex_unlock(&iface->sock_release_lock);
 		if (ret) {
 			if (ret == -EAGAIN)
-- 
2.35.1

