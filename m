Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C76E5C678D5
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Mar 2023 13:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCGNC7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Mar 2023 08:02:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjCGNCa (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Mar 2023 08:02:30 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE9CA7B48C
        for <linux-cifs@vger.kernel.org>; Tue,  7 Mar 2023 05:02:06 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so11763624pjg.4
        for <linux-cifs@vger.kernel.org>; Tue, 07 Mar 2023 05:02:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678194126;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L+dohYht/QDFyzLvJVfAIjvNtiHJ0rP9NNADlugz2vg=;
        b=shjqsKULdsQzlV7ECTL69kDFEfeAbvQ9dPBUDsdzTQCn1WYcT8cZAZGz5WQze35RIq
         9nIqwMKF4QnrboWSePj1ejK7522FXrNX8siyXIDuahQNPsYoek/f0abrqIl6ogen17Ph
         vHZ5nJhLlStbn7Oo6iuOD+mC1xj1W2Ei1jpi24PTzoAehPPaiZdMTTO7hTNilsBrYsW0
         sv4RyFG3r78hJtlEAafsYnU07sftj+KlAFaGwvYJgUC6oCHqo+OXS4ILQ8CbBtuDefDj
         Ur1EvG7mrhvnKBRFoiiMDjcnv5Pv3Qs5LmEuqDF20+KxKZuT7FrXNZrPqDAI3+rL7HX5
         9s4A==
X-Gm-Message-State: AO0yUKXlXRa8uzR0W6Ug3ZNMio80+EF7QkQkvFauHJ+NHc1V8bkPKRVR
        1NTCePvghn/kneXNIApCR74hqBJ8jPs=
X-Google-Smtp-Source: AK7set+Ma5ZcaN6qoVqnz1qE2ZOWuA8eFrBovZN4PUJNaYkqKWIftKiuWyl1/1K94poWHrt+FSXR9A==
X-Received: by 2002:a17:90b:3c49:b0:237:5a3c:e86c with SMTP id pm9-20020a17090b3c4900b002375a3ce86cmr14924297pjb.24.1678194125823;
        Tue, 07 Mar 2023 05:02:05 -0800 (PST)
Received: from localhost.localdomain ([211.49.23.9])
        by smtp.gmail.com with ESMTPSA id b3-20020a17090acc0300b00232cc61e16bsm9140216pju.35.2023.03.07.05.02.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 05:02:05 -0800 (PST)
From:   Namjae Jeon <linkinjeon@kernel.org>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, senozhatsky@chromium.org, tom@talpey.com,
        atteh.mailbox@gmail.com, Namjae Jeon <linkinjeon@kernel.org>,
        Dan Carpenter <error27@gmail.com>
Subject: [PATCH v2] ksmbd: add low bound validation to FSCTL_QUERY_ALLOCATED_RANGES
Date:   Tue,  7 Mar 2023 22:01:50 +0900
Message-Id: <20230307130150.5188-1-linkinjeon@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Smatch static checker warning:
 fs/ksmbd/vfs.c:1040 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'length'
 fs/ksmbd/vfs.c:1041 ksmbd_vfs_fqar_lseek() warn: no lower bound on 'start'

Fix unexpected result that could caused from negative start and length.

Fixes: f44158485826 ("cifsd: add file operations")
Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 v2:
  - Move sanity check before ksmbd_lookup_fd_fast().

 fs/ksmbd/smb2pdu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index b7a420e0fcc4..540c24d7cf67 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -7450,13 +7450,16 @@ static int fsctl_query_allocated_ranges(struct ksmbd_work *work, u64 id,
 	if (in_count == 0)
 		return -EINVAL;
 
+	start = le64_to_cpu(qar_req->file_offset);
+	length = le64_to_cpu(qar_req->length);
+
+	if (start < 0 || length < 0)
+		return -EINVAL;
+
 	fp = ksmbd_lookup_fd_fast(work, id);
 	if (!fp)
 		return -ENOENT;
 
-	start = le64_to_cpu(qar_req->file_offset);
-	length = le64_to_cpu(qar_req->length);
-
 	ret = ksmbd_vfs_fqar_lseek(fp, start, length,
 				   qar_rsp, in_count, out_count);
 	if (ret && ret != -E2BIG)
-- 
2.25.1

