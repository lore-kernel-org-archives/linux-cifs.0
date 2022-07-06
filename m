Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA45BC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  6 Jul 2022 15:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233916AbiGFPe3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 6 Jul 2022 11:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbiGFPc0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 6 Jul 2022 11:32:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9C6286DF;
        Wed,  6 Jul 2022 08:31:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D5DCB81D90;
        Wed,  6 Jul 2022 15:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D747C341CA;
        Wed,  6 Jul 2022 15:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657121516;
        bh=cJ4EpiTnne1jAnseMdkgLxRJnnbD3zSSBr50r+xpmcs=;
        h=From:To:Cc:Subject:Date:From;
        b=FWTTEwoo0Ud854kQIs828GvVBVDBq2E3sePL9lcmZAGCaa1a3oZhNMHx4N98QoD5y
         Yl9lGu0W53CUzmoAHtHlUY/OL6EwD4LU06m+ifnj1M7rSg4wNnHSFg81GgVJJm8USi
         wHZ0g9AsyLBbnMQAKy7TJeBpmCh31d7ZiFImRG9PCn1aDpA28yNv4gl15b3QkJZVhe
         69nMQKKIrwdcAo9JK2JUgudea16WHko9afD4/KeADod1rkI075eT9Cn+4jZfAkiGFf
         amFaW9kBmHnMVzJW+3TKq3WOfZtfS1q11sxk/l7nNzVsVgJSKfi8SWuicWuhs+X9SK
         M5bHN6PFQx1Kw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Namjae Jeon <linkinjeon@kerne.org>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Steve French <stfrench@microsoft.com>,
        Sasha Levin <sashal@kernel.org>, sfrench@samba.org,
        linux-cifs@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 01/18] ksmbd: use SOCK_NONBLOCK type for kernel_accept()
Date:   Wed,  6 Jul 2022 11:31:36 -0400
Message-Id: <20220706153153.1598076-1-sashal@kernel.org>
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
index 82a1429bbe12..755329c295ca 100644
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

