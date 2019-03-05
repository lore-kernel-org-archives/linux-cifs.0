Return-Path: <SRS0=9/Pd=RI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCE5C43381
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7ACFA20661
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Mar 2019 23:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oPUdTYoS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfCEXwI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Mar 2019 18:52:08 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41204 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727318AbfCEXwI (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Mar 2019 18:52:08 -0500
Received: by mail-pf1-f194.google.com with SMTP id d25so6934932pfn.8
        for <linux-cifs@vger.kernel.org>; Tue, 05 Mar 2019 15:52:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=zpoVSvMEAqaRub2/toRZFsTRKMFffDRFEP/CMONmCN0=;
        b=oPUdTYoSe7hqhKD/b/tdFYn2q9MFUA2stJIxdroFBVeJFiL3yrEtS88Oup55jJlKte
         pjXxwigZEp57SFJB/R3njm8rPwXAvaO4VCQCpTNKVT9ZmngH+VreF70vgiBY/gSAEB5l
         9SnL66kfi2JYeZsUTHOCSJzGoybsc06qsg6Yp614AE0i6wQC7sOHfSJiva9JxopYa0HF
         bOj0wPduHndBsbHIwSft38ZS3v9DfnXh8f5cFfQYtEgA/33U0O8qo71q2nI4qyoNTO+O
         Y0rd+F0nC6ZKLJx39pCfaihMsdoOTyRONBXD9fl7dRIUucysCOIglu5NOfNlsXuycFMt
         6X9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=zpoVSvMEAqaRub2/toRZFsTRKMFffDRFEP/CMONmCN0=;
        b=lYfX+JucQtiIG9L6awLVFnpH1FAF0ZZPou9LuLbW2yNs7I6+7dXK4mZHlOci06XQAh
         k9Va6LIFjjFXNItpVyTLY125M1Ss0moU5etVYvotQyEKsflhH0gCgA8KeZ5Oct/m0X0M
         6vABqf9GmZrK/QfsvjATHY+JecHe+Yzc6DOMlIvQsFd3iLIR9MW04avc6w5KDq0f27lU
         J1l45bVSCLGVX6x4IgwvRbqim8Twea1XXVZoN7AjfG2RkEEQjaLe9g4Q0ys5rUgnstAL
         5pXP4daA/yx8Sv+g4jiFWfmnB78HccQFpvRwm1+OTeqBarvlr9SkTWxANxhlJQ5k31+3
         n36A==
X-Gm-Message-State: APjAAAWqZk3XYwV/DJUBAZB5xlj8nRfTCkXHoxRJQRfAjNGKLqe48llz
        o3C0Smhz/6HShCYFRmd+2KTE8vM=
X-Google-Smtp-Source: APXvYqwk+lo3f7QGW2fLBQcaDBwCGT+4OrMHNQEwBMQsCN7mmdVT3RhuIAO1QdT5SUWmqEdHhstaMw==
X-Received: by 2002:a17:902:6804:: with SMTP id h4mr3856031plk.115.1551829927004;
        Tue, 05 Mar 2019 15:52:07 -0800 (PST)
Received: from ubuntu-vm.corp.microsoft.com ([2001:4898:80e8:1:a18d:4e9f:6b7c:507d])
        by smtp.gmail.com with ESMTPSA id l64sm50342pga.87.2019.03.05.15.52.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 05 Mar 2019 15:52:06 -0800 (PST)
From:   Pavel Shilovsky <piastryyy@gmail.com>
X-Google-Original-From: Pavel Shilovsky <pshilov@microsoft.com>
To:     linux-cifs@vger.kernel.org, smfrench@gmail.com
Subject: [PATCH 2/3] CIFS: Return -EAGAIN instead of -ENOTSOCK
Date:   Tue,  5 Mar 2019 15:51:56 -0800
Message-Id: <1551829917-48772-4-git-send-email-pshilov@microsoft.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
References: <1551829917-48772-1-git-send-email-pshilov@microsoft.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

When we attempt to send a packet while the demultiplex thread
is in the middle of cifs_reconnect() we may end up returning
-ENOTSOCK to upper layers. The intent here is to retry the request
once the TCP connection is up, so change it to return -EAGAIN
instead. The latter error code is retryable and the upper layers
will retry the request if needed.

Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
---
 fs/cifs/transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 9c3a680..9f23a45 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -301,8 +301,9 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 		rc = smbd_send(server, rqst);
 		goto smbd_done;
 	}
+
 	if (ssocket == NULL)
-		return -ENOTSOCK;
+		return -EAGAIN;
 
 	/* cork the socket */
 	kernel_setsockopt(ssocket, SOL_TCP, TCP_CORK,
-- 
2.7.4

