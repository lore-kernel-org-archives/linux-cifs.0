Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B5B8C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Jun 2022 01:13:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbiFBBNc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Jun 2022 21:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232994AbiFBBNb (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 1 Jun 2022 21:13:31 -0400
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADB8228539F
        for <linux-cifs@vger.kernel.org>; Wed,  1 Jun 2022 18:13:30 -0700 (PDT)
Received: by mail-pg1-f176.google.com with SMTP id q123so3413222pgq.6
        for <linux-cifs@vger.kernel.org>; Wed, 01 Jun 2022 18:13:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5FKYB/uafDr/WcN+eisRYxdwTLdWLD/Bm7+ncB95258=;
        b=VO4q3pGSNm4GSiRlRRyzMfCPbzbZ+GnvSJKWoaIOOvEepXpq+/HOHgsrPGu+PQ5uNr
         pwZZrhbi+TAbkjrK7+kVlJ4QWupQ3n2EaZxoOAOfomXD9leDesaW/GboIEpq2k6SYE+O
         /vFtVtPqQFF6KTDHtH3KT5HW3jbrfzL0uBmL43IAcZnh+AB3Y40qU55ueDV20vvAmNeY
         fA+DxBgihM+EvheC3JTDL+wJkDKwyrSEQ9ie7NidIx+E2ES06PS6M6JzLD9m9VujETCi
         lZ8p8+HXF8m6Wt5kpbtERjbSc8e0JYanGQTad3T090A/Ugdv0BP/ZSNZUq0H8Oe9miYr
         vHXg==
X-Gm-Message-State: AOAM5323F0HAbuVpYFRz2sMG+Y7tVXSGOFC4sAMlcGz5+IsdMTnTJnAU
        53mKxSIa13sd77BC1hlskMb8hDIblj/Oog==
X-Google-Smtp-Source: ABdhPJw2oIVqv+0F2lXgDwNwi2SY6Uy7Nkci7Ak92Xh4i67sA1nmrGeSs/zvh93wiaVQ/EzuVbTptQ==
X-Received: by 2002:a63:5506:0:b0:3fc:3706:5505 with SMTP id j6-20020a635506000000b003fc37065505mr1852804pgb.383.1654132409780;
        Wed, 01 Jun 2022 18:13:29 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id j189-20020a6380c6000000b003fc32f8e030sm1958961pgd.79.2022.06.01.18.13.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 18:13:29 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     hyc.lee@gmail.com, sfrench@samba.org, senozhatsky@chromium.org,
        smfrench@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH] ksmbd: use SOCK_NONBLOCK type for kernel_accept()
Date:   Thu,  2 Jun 2022 10:13:13 +0900
Message-Id: <20220602011313.56110-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

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
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
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
2.25.1

