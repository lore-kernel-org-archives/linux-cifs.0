Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C1AAC64EC7
	for <linux-cifs@archiver.kernel.org>; Tue, 28 Feb 2023 23:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjB1X5H (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 28 Feb 2023 18:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjB1X5G (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 28 Feb 2023 18:57:06 -0500
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F37417CDA
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:57:06 -0800 (PST)
Received: by mail-pg1-f173.google.com with SMTP id d6so6733860pgu.2
        for <linux-cifs@vger.kernel.org>; Tue, 28 Feb 2023 15:57:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677628625;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iEmB5nn9YCTAqp6/n4P0FuyZi4obVrQxtsX0k0vks3E=;
        b=3Gtf+KDzwvEb1PPOrdchCEfNbcRLMdOAeL66YXlcqGSVZKVNeWi3Z2J+WOvlHBh6uL
         UnDtbmiI+9WzaA+BHxOa3uIoMy5uQ/svoxHQLo0tWRbHZNFx3boFaGrIpnMzoDgGvNTX
         2C4lc1HHuHzxcZadaoglSJetFjV6Ue7kGGAXneMDgcDRczF9ZnoKlKTEtXl1VN1IATvm
         2gOIskOcVdZueql0LL2M4VBKAhi6q7Grz9h2LWprWgbJLv0jsROhjpcVHk5HtDtTkjod
         04Yt67a18HtfIJy8kGg5IgKU04GbkJ/nJBAcljb5O/A9U3fsP78ZbDGTKMYbscuMmcJb
         Fokw==
X-Gm-Message-State: AO0yUKUBJg6SrTV/LR8W6z9LwrV5bu5Orx+i6DFZ6DanLHPZdc7EGBCk
        USjGURAQyCwYovuFTqbTIZDUJad2VgU=
X-Google-Smtp-Source: AK7set+yvIxJOkDLQ4h7pXBMBnT1fF9BJ2Xn0mnbY8eai6dn75+vq8EBnlK26Hc6oeQkdNLIhg6Q+Q==
X-Received: by 2002:a62:64cc:0:b0:5aa:6597:507b with SMTP id y195-20020a6264cc000000b005aa6597507bmr3942564pfb.12.1677628625322;
        Tue, 28 Feb 2023 15:57:05 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id q23-20020a62e117000000b005a8de0f4c64sm6568525pfh.82.2023.02.28.15.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 15:57:05 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        Namjae Jeon <linkinjeon@kernel.org>,
        Miao Lihua <441884205@qq.com>
Subject: [PATCH] ksmbd: fix wrong signingkey creation when encryption is AES256
Date:   Wed,  1 Mar 2023 08:56:23 +0900
Message-Id: <20230228235624.5451-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

MacOS and Win11 support AES256 encrytion and it is included in the cipher
array of encryption context. Especially on macOS, The most preferred
cipher is AES256. Connecting to ksmbd fails on newer MacOS clients that
support AES256 encryption. MacOS send disconnect request after receiving
final session setup response from ksmbd. Because final session setup is
signed with signing key was generated incorrectly.
For signging key, 'L' value should be initialized to 128 if key size is
16bytes.

Reported-by: Miao Lihua <441884205@qq.com>
Tested-by: Miao Lihua <441884205@qq.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/auth.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/auth.c b/fs/ksmbd/auth.c
index 6e61b5bc7d86..cead696b656a 100644
--- a/fs/ksmbd/auth.c
+++ b/fs/ksmbd/auth.c
@@ -727,8 +727,9 @@ static int generate_key(struct ksmbd_conn *conn, struct ksmbd_session *sess,
 		goto smb3signkey_ret;
 	}
 
-	if (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
-	    conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM)
+	if (key_size == SMB3_ENC_DEC_KEY_SIZE &&
+	    (conn->cipher_type == SMB2_ENCRYPTION_AES256_CCM ||
+	     conn->cipher_type == SMB2_ENCRYPTION_AES256_GCM))
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L256, 4);
 	else
 		rc = crypto_shash_update(CRYPTO_HMACSHA256(ctx), L128, 4);
-- 
2.25.1

