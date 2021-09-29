Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BED84C433EF
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 13:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9FE406128C
	for <linux-cifs@archiver.kernel.org>; Wed, 29 Sep 2021 13:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344276AbhI2NjA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 29 Sep 2021 09:39:00 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:38465 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344245AbhI2NjA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 29 Sep 2021 09:39:00 -0400
Received: by mail-pj1-f48.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so4240254pjc.3
        for <linux-cifs@vger.kernel.org>; Wed, 29 Sep 2021 06:37:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7obAuG81Wt46NeCFiwPhY/RXz/q6JKJtSoMN2Z/6u4k=;
        b=PIr592B8cvu4Jpfd2Dqv1nZmUk+9kMFvhxdjlnOBjQFv3PR2rPwt4hFP52YmXZyTXO
         L3MSUH6Ic1PurSYp5lwGGs4h8W2YWvwZni8WnT5BP1nt240LgSi9CYsp68eLBRIibrVu
         A+KtFbYvBOZhBF2yEbFY34f+DaHpVrxqh+czEYUKHwazeDuusPh3DDBmHDiadHRfzQSn
         bnutDjInq75Lxfx99GHXtlH1kkg9TEVntCPxqkG99Fh4fL3yfF3vawmeg8piEw4Pzu8c
         /rXjcksO1BoVoEGyEmCXxobGjSU8BNG2rupO+LqmP0WromVI3o/zQf8dBEXXJLW+xsWK
         +SZg==
X-Gm-Message-State: AOAM533MIWdz3B/F3LaMQYiGr9FnCC3cp9XUOWW7KtBeEyj1miPlVL3s
        4wUbi4vp5cIvsbo8CNu8BFcPbsm29I5bXA==
X-Google-Smtp-Source: ABdhPJy/V4wuIRlUzHhKuI0tlrY1f21nhEZsV5TprzJfHv8X17TiyEoWASZcP+hlrNZeg8JfO4Tprw==
X-Received: by 2002:a17:90a:a88b:: with SMTP id h11mr94561pjq.44.1632922638976;
        Wed, 29 Sep 2021 06:37:18 -0700 (PDT)
Received: from localhost.localdomain ([61.74.27.164])
        by smtp.gmail.com with ESMTPSA id az15sm2071496pjb.42.2021.09.29.06.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 06:37:18 -0700 (PDT)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?q?Ralph=20B=C3=B6hme?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: [PATCH] ksmbd: fix transform header validation
Date:   Wed, 29 Sep 2021 22:36:57 +0900
Message-Id: <20210929133657.10553-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

OriginalMessageSize and SessionId should be used after validating
transform header in request buffer.

Cc: Tom Talpey <tom@talpey.com>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>
Cc: Ralph Böhme <slow@samba.org>
Cc: Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index ec05d9dc6436..b06361313889 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -8455,16 +8455,8 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 	unsigned int buf_data_size = pdu_length + 4 -
 		sizeof(struct smb2_transform_hdr);
 	struct smb2_transform_hdr *tr_hdr = (struct smb2_transform_hdr *)buf;
-	unsigned int orig_len = le32_to_cpu(tr_hdr->OriginalMessageSize);
 	int rc = 0;
 
-	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
-	if (!sess) {
-		pr_err("invalid session id(%llx) in transform header\n",
-		       le64_to_cpu(tr_hdr->SessionId));
-		return -ECONNABORTED;
-	}
-
 	if (pdu_length + 4 <
 	    sizeof(struct smb2_transform_hdr) + sizeof(struct smb2_hdr)) {
 		pr_err("Transform message is too small (%u)\n",
@@ -8472,11 +8464,19 @@ int smb3_decrypt_req(struct ksmbd_work *work)
 		return -ECONNABORTED;
 	}
 
-	if (pdu_length + 4 < orig_len + sizeof(struct smb2_transform_hdr)) {
+	if (pdu_length + 4 <
+	    le32_to_cpu(tr_hdr->OriginalMessageSize) + sizeof(struct smb2_transform_hdr)) {
 		pr_err("Transform message is broken\n");
 		return -ECONNABORTED;
 	}
 
+	sess = ksmbd_session_lookup_all(conn, le64_to_cpu(tr_hdr->SessionId));
+	if (!sess) {
+		pr_err("invalid session id(%llx) in transform header\n",
+		       le64_to_cpu(tr_hdr->SessionId));
+		return -ECONNABORTED;
+	}
+
 	iov[0].iov_base = buf;
 	iov[0].iov_len = sizeof(struct smb2_transform_hdr);
 	iov[1].iov_base = buf + sizeof(struct smb2_transform_hdr);
-- 
2.25.1

