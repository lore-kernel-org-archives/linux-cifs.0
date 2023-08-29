Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58376C83F14
	for <linux-cifs@archiver.kernel.org>; Tue, 29 Aug 2023 10:39:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbjH2KjS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 29 Aug 2023 06:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232130AbjH2KjN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 29 Aug 2023 06:39:13 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1E9519A
        for <linux-cifs@vger.kernel.org>; Tue, 29 Aug 2023 03:39:10 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1c1e780aa95so11067715ad.3
        for <linux-cifs@vger.kernel.org>; Tue, 29 Aug 2023 03:39:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693305550; x=1693910350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o9y8TmmkjUjGEkmX33Td5dfHF6JU6BTiIjy79DW+TPw=;
        b=a785O/q+tnBCtOXdoE24Hs46EhlOG8F1BBfYR96OX5oFvmxMVDN0FsTDlb5+pEsfns
         AhaLqcsnhmtfarmZ3LLhvKPIkCGsSp3vYf4qP1xrODbO813ik2Boa7cihiFqADY4Z0S2
         BcygX89jtHNJ0bBE9HcJ9HphIn6wADd7wd1uKfU63Uo/tY9h3jr7WKPHI6wwVjvtry8a
         6vJ22Rmq2yea/VqSz2xGXSt9f9Y++OE2cs2DqHfykm842EOcCNxTxUkCYk0iY7rUuuCb
         ewhdVh/nSWLZLgbJJz/Zj7foETvGuy93GFlVYiTcmeIHnGMhNzjfO+RIWfOGuOtukYMa
         0DVQ==
X-Gm-Message-State: AOJu0YzZGW/OduIzM8AfGmlIs/BbNNQJY0TXOH5I171jnj2YZ57GpY4U
        kSOBT3k0IsKPI+h0viPJWB9KIhdHuRE=
X-Google-Smtp-Source: AGHT+IHsAjsu9RQyUFfomkvmC47drkizW3CHVttzD3jeo/p6RVeXuZ/jOcOPf1RKPabx8DDouf0ufA==
X-Received: by 2002:a17:902:bf46:b0:1bd:bba1:be7b with SMTP id u6-20020a170902bf4600b001bdbba1be7bmr21769244pls.39.1693305549994;
        Tue, 29 Aug 2023 03:39:09 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id a20-20020a170903101400b001b890009634sm9080825plb.139.2023.08.29.03.39.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Aug 2023 03:39:09 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        hyc.lee@gmail.com, atteh.mailbox@gmail.com,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: add missing calling smb2_set_err_rsp() on error
Date:   Tue, 29 Aug 2023 19:38:58 +0900
Message-Id: <20230829103858.5619-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If some error happen on smb2_sess_setup(), Need to call
smb2_set_err_rsp() to set error response.
This patch add missing calling smb2_set_err_rsp() on error.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index d12d995f52d7..3dbde9fb775f 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -1904,6 +1904,7 @@ int smb2_sess_setup(struct ksmbd_work *work)
 				ksmbd_conn_set_need_negotiate(conn);
 			}
 		}
+		smb2_set_err_rsp(work);
 	} else {
 		unsigned int iov_len;
 
-- 
2.25.1

