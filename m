Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5EB3C433EF
	for <linux-cifs@archiver.kernel.org>; Sun, 21 Nov 2021 11:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238150AbhKULn2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 21 Nov 2021 06:43:28 -0500
Received: from mail-pf1-f180.google.com ([209.85.210.180]:36718 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbhKULn1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 21 Nov 2021 06:43:27 -0500
Received: by mail-pf1-f180.google.com with SMTP id n26so13470014pff.3
        for <linux-cifs@vger.kernel.org>; Sun, 21 Nov 2021 03:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IpFwVOCVk5xP8Zf+CFWem/gGjY1GcJOhtsU3DGsTNfg=;
        b=ZoXKKH/wmkXctBd5jNkG8zPVelTtr25/t4uap0NrzQ0Ov2Gh6T13Bc89qCRYdO7g54
         8PyIdeAy1z5zHD5NlIIj/35lkvgaTgHmm/3XGttE9m4fqcqrBbO2+LZOFbl6P2ovFW+m
         WZ7C90a+aUuTLDuvhpTG8tpl2k4Q8M8YbaZtTGwu8fVsDEIhfRSf7dUgl0eXqwyGwkum
         wg7Q++ntsHT9bQ7K0o49mdY/SshB43LgGhHsk2RQIn3q9R21eyWDbqwxgdoPo2GsjrQ6
         jfiI53xSvqTFBCSOTawgvV1Or9kCBqaIGFlTbpGquaCzfQJsaJ3kzLNJZuzZCWiLghwt
         iXsA==
X-Gm-Message-State: AOAM532z+vAkcazvIA3Zt1HXTI0iYjM16beW8LK64enYjQn67Wz1wy8d
        7woIc+g3vUpcQclu6y5xKYIpPaWJdU0=
X-Google-Smtp-Source: ABdhPJxt6gp1vP3gOiRZYZuFNbqiONDcgI5tDT2uqWu9V1TLFb5kIB2Zv4+4ZmwOeOoMXtiqQASBhw==
X-Received: by 2002:a62:7802:0:b0:49f:d21e:1dc9 with SMTP id t2-20020a627802000000b0049fd21e1dc9mr77102099pfc.18.1637494822903;
        Sun, 21 Nov 2021 03:40:22 -0800 (PST)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id y32sm5266128pfa.145.2021.11.21.03.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 03:40:22 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        Olha Cherevyk <olha.cherevyk@gmail.com>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: [PATCH] ksmbd-tools: fix file transfer stuck at 99%
Date:   Sun, 21 Nov 2021 20:40:09 +0900
Message-Id: <20211121114009.6039-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When user set share name included upper character in smb.conf,
Windows File transfer will stuck at 99%. When copying file, windows send
SRVSVC GET_SHARE_INFO command to ksmbd server. but ksmbd store after
converting share name from smb.conf to lower cases. So ksmbd.mountd
can't not find share and return error to windows client.
This patch find share using name converted share name from client to
lower cases.

Reported-by: Olha Cherevyk <olha.cherevyk@gmail.com>
Tested-by: Oleksandr Natalenko <oleksandr@natalenko.name>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 mountd/rpc_srvsvc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mountd/rpc_srvsvc.c b/mountd/rpc_srvsvc.c
index 8608b2e..f3b4d06 100644
--- a/mountd/rpc_srvsvc.c
+++ b/mountd/rpc_srvsvc.c
@@ -169,8 +169,11 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
 {
 	struct ksmbd_share *share;
 	int ret;
+	gchar *share_name;
 
-	share = shm_lookup_share(STR_VAL(hdr->share_name));
+	share_name = g_ascii_strdown(STR_VAL(hdr->share_name),
+			strlen(STR_VAL(hdr->share_name)));
+	share = shm_lookup_share(share_name);
 	if (!share)
 		return 0;
 
@@ -188,9 +191,12 @@ static int srvsvc_share_get_info_invoke(struct ksmbd_rpc_pipe *pipe,
 	}
 
 	if (ret != 0) {
+		gchar *server_name = g_ascii_strdown(STR_VAL(hdr->server_name),
+				strlen(STR_VAL(hdr->server_name)));
+
 		ret = shm_lookup_hosts_map(share,
 					   KSMBD_SHARE_HOSTS_DENY_MAP,
-					   STR_VAL(hdr->server_name));
+					   server_name);
 		if (ret == 0) {
 			put_ksmbd_share(share);
 			return 0;
-- 
2.25.1

