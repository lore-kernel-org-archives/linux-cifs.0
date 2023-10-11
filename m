Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75C87CD6E7C
	for <linux-cifs@archiver.kernel.org>; Wed, 11 Oct 2023 14:48:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbjJKOsk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 11 Oct 2023 10:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235041AbjJKOsj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 11 Oct 2023 10:48:39 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF688BA
        for <linux-cifs@vger.kernel.org>; Wed, 11 Oct 2023 07:48:37 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-57b68556d6dso3835031eaf.1
        for <linux-cifs@vger.kernel.org>; Wed, 11 Oct 2023 07:48:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697035717; x=1697640517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KWq5BS6S9RabcE2DIs2WK/cbdGqkeRiKmjdiZPxBiYI=;
        b=MxvJHrIrxuUYCq1ZDhHRpt+ABoWhOxwa4O03KoNLZpM4LxM+LKSj8QtUodp8fAhWLF
         u7TwBS7/2XQtdS3mYlTeaYh/Hnb1+pVPL0DD5tCa8BtMoyuCrOG5zwSc3dqS4CH1w0V/
         l5LV0XuLD7Kb32e3gkr5hUUqLQ/kYETjEJhs7nyHh+Wkzh5Zwacku9KjAkRVmkrltVXu
         boy1fo9ZboduFrD4TDrtbL47JvqCI7IMKM90aYF+gVwjef95fhR00572k4mB+JhF+zX4
         7ciSJdHMQHJWxRL1h7wMJ65ybLNC9xcpYjhvqgTXPokENu/DMgMmaKF1RRPtT4DejAh9
         8Ueg==
X-Gm-Message-State: AOJu0YzfSabfMagohLD8ImhKLNgiRu0oCZRJ+74vrGliA5/ynREgtXj6
        0s1V9CDwltLpjeQslnBNIutj6y7vm/4=
X-Google-Smtp-Source: AGHT+IH8i/z39sjATbkcmKdLik2AvpBxzigNcMMiQA5hKFJoWHrjRfEyc3ibC7QwfUA6ScjR8Tzy7A==
X-Received: by 2002:a05:6358:3421:b0:14d:bad5:6adf with SMTP id h33-20020a056358342100b0014dbad56adfmr24126847rwd.21.1697035716659;
        Wed, 11 Oct 2023 07:48:36 -0700 (PDT)
Received: from localhost.localdomain ([110.14.71.32])
        by smtp.gmail.com with ESMTPSA id ey5-20020a056a0038c500b0068ff6d21563sm10626059pfb.148.2023.10.11.07.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Oct 2023 07:48:36 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@linaro.org>
Subject: [PATCH 2/2] ksmbd: fix potential double free on smb2_read_pipe() error path
Date:   Wed, 11 Oct 2023 23:38:47 +0900
Message-Id: <20231011143847.9140-2-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231011143847.9140-1-linkinjeon@kernel.org>
References: <20231011143847.9140-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Fix new smatch warnings:
fs/smb/server/smb2pdu.c:6131 smb2_read_pipe() error: double free of 'rpc_resp'

Fixes: e2b76ab8b5c9 ("ksmbd: add support for read compound")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/server/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index 87c6401a6007..93262ca3f58a 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -6152,12 +6152,12 @@ static noinline int smb2_read_pipe(struct ksmbd_work *work)
 		memcpy(aux_payload_buf, rpc_resp->payload, rpc_resp->payload_sz);
 
 		nbytes = rpc_resp->payload_sz;
-		kvfree(rpc_resp);
 		err = ksmbd_iov_pin_rsp_read(work, (void *)rsp,
 					     offsetof(struct smb2_read_rsp, Buffer),
 					     aux_payload_buf, nbytes);
 		if (err)
 			goto out;
+		kvfree(rpc_resp);
 	} else {
 		err = ksmbd_iov_pin_rsp(work, (void *)rsp,
 					offsetof(struct smb2_read_rsp, Buffer));
-- 
2.25.1

