Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AEBC77B7F
	for <linux-cifs@archiver.kernel.org>; Sun, 14 May 2023 03:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229530AbjENDwM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 13 May 2023 23:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbjENDwL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 13 May 2023 23:52:11 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B680D2109
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:52:10 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-644d9bf05b7so6290779b3a.3
        for <linux-cifs@vger.kernel.org>; Sat, 13 May 2023 20:52:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684036330; x=1686628330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SwuVPxmPJavv/kXK/X6JFzRtmkiuvaiChv+nnYKDlpg=;
        b=Y5BJE4BahDIfoWVah50670frOpCEzQjnVBeRQXDx1QnL7HnABE63n+cgKvaOPVW1MN
         uY7tneMzU/TJaFaBOM0bEUNtGecdt5J9bXg8UC7IVPfZQEWBrdU5ojMhTEgD5ssP4fRY
         Dej1/aPlz5SOx5u/d1UepzHBzQ902J2vOaGkoDNccgPKKXi4LTWXcow7yfanMwIqsZUZ
         MbSYMPeBeSzJpRdGd2eNeQDpXxo9oEOP/eb2FQJmID+bWatpYePLk2I22bsOiAKIT9fm
         jBffHkC/AgrPYFoyk5kKCXbryIKdOahUpzyyUpphPnU9MdyrSSzLz9hl2d5f4dcJnDCf
         Yfkw==
X-Gm-Message-State: AC+VfDytoGUgeM0a5BVfKI9mRvCwuO7BOIQKnPmZoxwKZaywD9ADdmX0
        fYiXAgTWA94QTzynSuOV4WCzD22GNVI=
X-Google-Smtp-Source: ACHHUZ6FyM8pjCcX4IGBW20gjwavREiMYCwGIKl0FRIWQoQRKiHpAlOqaGN3zxIs+FzZCv6K9jCENQ==
X-Received: by 2002:a05:6a00:180f:b0:645:d02d:9a83 with SMTP id y15-20020a056a00180f00b00645d02d9a83mr33616056pfa.17.1684036329883;
        Sat, 13 May 2023 20:52:09 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id 19-20020aa79113000000b0063b79bae907sm9281837pfh.122.2023.05.13.20.52.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 20:52:09 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH] ksmbd: fix credit count leakage
Date:   Sun, 14 May 2023 12:51:42 +0900
Message-Id: <20230514035142.7653-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230514035142.7653-1-linkinjeon@kernel.org>
References: <20230514035142.7653-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This patch fix the failure from smb2.credits.single_req_credits_granted
test. When client send 8192 credit request, ksmbd return 8191 credit
granted. ksmbd should give maximum possible credits that must be granted
within the range of not exceeding the max credit to client.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 1632b2a1e516..bec885c007ce 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -326,13 +326,9 @@ int smb2_set_rsp_credits(struct ksmbd_work *work)
 	if (hdr->Command == SMB2_NEGOTIATE)
 		aux_max = 1;
 	else
-		aux_max = conn->vals->max_credits - credit_charge;
+		aux_max = conn->vals->max_credits - conn->total_credits;
 	credits_granted = min_t(unsigned short, credits_requested, aux_max);
 
-	if (conn->vals->max_credits - conn->total_credits < credits_granted)
-		credits_granted = conn->vals->max_credits -
-			conn->total_credits;
-
 	conn->total_credits += credits_granted;
 	work->credits_granted += credits_granted;
 
-- 
2.25.1

