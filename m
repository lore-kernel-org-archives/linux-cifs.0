Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC92CC6FA82
	for <linux-cifs@archiver.kernel.org>; Thu, 22 Sep 2022 14:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232073AbiIVOlA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 22 Sep 2022 10:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiIVOke (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 22 Sep 2022 10:40:34 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A0DF583
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:45 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id iw17so9028495plb.0
        for <linux-cifs@vger.kernel.org>; Thu, 22 Sep 2022 07:39:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GsmH5RBerVZ0DjIsZb3I31vy3OZkqBpstPfaku68NPo=;
        b=HLwAggUXFisFxCLTJdr/SGxpTFC2Lzd2ppRdt6qbVnu7cEjFOqCJZ1XfVor2Q+zS4s
         BkLkwx/GSFKVrPRBLAJUKuhQli6YzugR/8/oQNt5FhMopvhjBk8Bj0wiv48e/3li0Cmr
         183Z5Y/lVb3IK9elhxMRNGO/MkiR6Dwo1/B1QU2zJ3yE016uGfbt/eScElaM9HsfrnV7
         BGh45Ax5ETFMNZWuB16k8oojifNCSTJcdKgS6j5alkpAdvgHbRx2frgOuEZvbOhjzKC6
         LLctfwqpsMpN48P9x0DY6xDI6xpnpNjyHcDdSJGxYjO7sSu3bVghVdpDFxDP3sYwsx4a
         +ugQ==
X-Gm-Message-State: ACrzQf3rC66sk/b7y25Dypw5vM4YeLObQlbFgld8jn4LQLccnijdxLFe
        2YACvg2MecL6QdH/zb7dAnxxWWUn6K8=
X-Google-Smtp-Source: AMsMyM77RwGz2110x7qBssdvJpbIxMw8fF2yfsbUT9FM3bWjUGAlQbLxQImGUAQsHIaxPrgl4F1VWA==
X-Received: by 2002:a17:90b:1c8c:b0:203:89fb:ba79 with SMTP id oo12-20020a17090b1c8c00b0020389fbba79mr15629549pjb.92.1663857584413;
        Thu, 22 Sep 2022 07:39:44 -0700 (PDT)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id b67-20020a621b46000000b0053e22c7f135sm4500311pfb.141.2022.09.22.07.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Sep 2022 07:39:44 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH 3/3] ksmbd: set NTLMSSP_NEGOTIATE_SEAL flag to challenge blob
Date:   Thu, 22 Sep 2022 23:39:06 +0900
Message-Id: <20220922143906.10826-3-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220922143906.10826-1-linkinjeon@kernel.org>
References: <20220922143906.10826-1-linkinjeon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

If NTLMSSP_NEGOTIATE_SEAL flags is set in negotiate blob from client,
Set NTLMSSP_NEGOTIATE_SEAL flag to challenge blob.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c    | 3 +++
 fs/ksmbd/smb2pdu.c | 2 +-
 fs/ksmbd/smb2pdu.h | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 2330d7754cf6..2a39ffb8423b 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -424,6 +424,9 @@ ksmbd_build_ntlmssp_challenge_blob(struct challenge_message *chgblob,
 				   NTLMSSP_NEGOTIATE_56);
 	}
 
+	if (cflags & NTLMSSP_NEGOTIATE_SEAL && smb3_encryption_negotiated(conn))
+		flags |= NTLMSSP_NEGOTIATE_SEAL;
+
 	if (cflags & NTLMSSP_NEGOTIATE_ALWAYS_SIGN)
 		flags |= NTLMSSP_NEGOTIATE_ALWAYS_SIGN;
 
diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 649f9b72707a..f99698ce955b 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -925,7 +925,7 @@ static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
  *
  * Return:	true if connection should be encrypted, else false
  */
-static bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
+bool smb3_encryption_negotiated(struct ksmbd_conn *conn)
 {
 	if (!conn->ops->generate_encryptionkey)
 		return false;
diff --git a/fs/ksmbd/smb2pdu.h b/fs/ksmbd/smb2pdu.h
index 2eb6b819c89d..092fdd3f8750 100644
--- a/fs/ksmbd/smb2pdu.h
+++ b/fs/ksmbd/smb2pdu.h
@@ -494,6 +494,7 @@ int smb3_decrypt_req(struct ksmbd_work *work);
 int smb3_encrypt_resp(struct ksmbd_work *work);
 bool smb3_11_final_sess_setup_resp(struct ksmbd_work *work);
 int smb2_set_rsp_credits(struct ksmbd_work *work);
+bool smb3_encryption_negotiated(struct ksmbd_conn *conn);
 
 /* smb2 misc functions */
 int ksmbd_smb2_check_message(struct ksmbd_work *work);
-- 
2.25.1

