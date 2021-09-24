Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75B48C433F5
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 04:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5517C61241
	for <linux-cifs@archiver.kernel.org>; Fri, 24 Sep 2021 04:58:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhIXE7m (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 24 Sep 2021 00:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:56122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231256AbhIXE7l (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 24 Sep 2021 00:59:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18AE16124D
        for <linux-cifs@vger.kernel.org>; Fri, 24 Sep 2021 04:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632459489;
        bh=pmCj9sfhmIHN7vGtHYK0vaWs5nXH80OsxzBzs/Yg8dw=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=JDpo7FViIt0mRAloPaRDD/V6zJ87NTqvwSHJ5HSt/DLd59mvapn+CRQml4MlV35Pk
         RCM6a3t4vtOy8rFs0BQgDNlupJU58yrXdtznCJtYh65am11R18zxZb2FegpBHgQvg0
         ryM0B31ZQpAJ1HBhgByIQbAApJ4R20qfwyq4FQg+v6BUg/Z69rLKxc2lWx8eoa87pO
         P8DY/dqQtdsIbovCRypwKct/S1kK6mcJ7PiS8M0+wi8LGn+ontW2R58jd0FGUJOv6Y
         XIQo6uz/UmQtxDtwBPZxpR/AOHeqViuOzZjitqCqZMBRuxvW7N/xrFyOh6OVAoxmuJ
         LkhN+7V1Y6Mgg==
Received: by mail-ot1-f48.google.com with SMTP id x33-20020a9d37a4000000b0054733a85462so11573615otb.10
        for <linux-cifs@vger.kernel.org>; Thu, 23 Sep 2021 21:58:09 -0700 (PDT)
X-Gm-Message-State: AOAM533ElRPT1ymEVZTwqXxI9dZxulco/A8D/sdCrbgNn6SRpcGuVYXx
        AOQtefKrAAVpBZI6A1BnEn7gGy8l1Zx2oJHCJJo=
X-Google-Smtp-Source: ABdhPJyCUz0PXtRPQNFB8arkbvzHRI03cPbVNzjl56cAAiSLwDNQzPGhE1B4Pvss0i9vcyk43n47qOMoLTCSpcZVxSE=
X-Received: by 2002:a9d:4705:: with SMTP id a5mr2194399otf.237.1632459488413;
 Thu, 23 Sep 2021 21:58:08 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:1342:0:0:0:0:0 with HTTP; Thu, 23 Sep 2021 21:58:07
 -0700 (PDT)
In-Reply-To: <20210924021254.27096-8-linkinjeon@kernel.org>
References: <20210924021254.27096-1-linkinjeon@kernel.org> <20210924021254.27096-8-linkinjeon@kernel.org>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Fri, 24 Sep 2021 13:58:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-8W6Oed-0GwH64a+3rqTOD2d8UyEsMXSYxOu8edyEtAw@mail.gmail.com>
Message-ID: <CAKYAXd-8W6Oed-0GwH64a+3rqTOD2d8UyEsMXSYxOu8edyEtAw@mail.gmail.com>
Subject: Re: [PATCH 7/7] ksmbd: add validation in smb2 negotiate
To:     linux-cifs@vger.kernel.org
Cc:     Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        =?UTF-8?B?UmFscGggQsO2aG1l?= <slow@samba.org>,
        Steve French <smfrench@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I found null dereferencing kenel oops while testing and updated this patch.
Please review the below patch, thanks!

From 85e1ce56bb0c37e8ea2083cd0e62e160f2bf6677 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 24 Sep 2021 13:07:17 +0900
Subject: [PATCH] ksmbd: add validation in smb2 negotiate

This patch add validation to check request buffer check in smb2
negotiate and fix null pointer dereferencing oops in smb3_preauth_hash_rsp()
that found from manual test.

Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/ksmbd/smb2pdu.c    | 42 +++++++++++++++++++++++++++++++++++++++++-
 fs/ksmbd/smb_common.c | 22 ++++++++++++++++++++--
 2 files changed, 61 insertions(+), 3 deletions(-)

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 4c7e7aaba525..9eb8b86ddb27 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -1081,6 +1081,7 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 	struct smb2_negotiate_req *req = work->request_buf;
 	struct smb2_negotiate_rsp *rsp = work->response_buf;
 	int rc = 0;
+	unsigned int smb2_buf_len, smb2_neg_size;
 	__le32 status;

 	ksmbd_debug(SMB, "Received negotiate request\n");
@@ -1098,6 +1099,44 @@ int smb2_handle_negotiate(struct ksmbd_work *work)
 		goto err_out;
 	}

+	smb2_buf_len = get_rfc1002_len(work->request_buf);
+	smb2_neg_size = offsetof(struct smb2_negotiate_req, Dialects) - 4;
+	if (conn->dialect == SMB311_PROT_ID) {
+		unsigned int nego_ctxt_off = le32_to_cpu(req->NegotiateContextOffset);
+
+		if (smb2_buf_len < nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size > nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    nego_ctxt_off) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+	} else {
+		if (smb2_neg_size > smb2_buf_len) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    smb2_buf_len) {
+			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
+			rc = -EINVAL;
+			goto err_out;
+		}
+	}
+
 	conn->cli_cap = le32_to_cpu(req->Capabilities);
 	switch (conn->dialect) {
 	case SMB311_PROT_ID:
@@ -8335,7 +8374,8 @@ void smb3_preauth_hash_rsp(struct ksmbd_work *work)

 	WORK_BUFFERS(work, req, rsp);

-	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE)
+	if (le16_to_cpu(req->Command) == SMB2_NEGOTIATE_HE &&
+	    conn->preauth_info)
 		ksmbd_gen_preauth_integrity_hash(conn, (char *)rsp,
 						 conn->preauth_info->Preauth_HashValue);

diff --git a/fs/ksmbd/smb_common.c b/fs/ksmbd/smb_common.c
index 20bd5b8e3c0a..85937d497dcb 100644
--- a/fs/ksmbd/smb_common.c
+++ b/fs/ksmbd/smb_common.c
@@ -234,13 +234,22 @@ int ksmbd_lookup_dialect_by_id(__le16
*cli_dialects, __le16 dialects_count)

 static int ksmbd_negotiate_smb_dialect(void *buf)
 {
-	__le32 proto;
+	int smb_buf_length = get_rfc1002_len(buf);
+	__le32 proto = ((struct smb2_hdr *)buf)->ProtocolId;

-	proto = ((struct smb2_hdr *)buf)->ProtocolId;
 	if (proto == SMB2_PROTO_NUMBER) {
 		struct smb2_negotiate_req *req;
+		int smb2_neg_size =
+			offsetof(struct smb2_negotiate_req, Dialects) - 4;

 		req = (struct smb2_negotiate_req *)buf;
+		if (smb2_neg_size > smb_buf_length)
+			goto err_out;
+
+		if (smb2_neg_size + le16_to_cpu(req->DialectCount) * sizeof(__le16) >
+		    smb_buf_length)
+			goto err_out;
+
 		return ksmbd_lookup_dialect_by_id(req->Dialects,
 						  req->DialectCount);
 	}
@@ -250,10 +259,19 @@ static int ksmbd_negotiate_smb_dialect(void *buf)
 		struct smb_negotiate_req *req;

 		req = (struct smb_negotiate_req *)buf;
+		if (le16_to_cpu(req->ByteCount) < 2)
+			goto err_out;
+
+		if (offsetof(struct smb_negotiate_req, DialectsArray) - 4 +
+			le16_to_cpu(req->ByteCount) > smb_buf_length) {
+			goto err_out;
+		}
+
 		return ksmbd_lookup_dialect_by_name(req->DialectsArray,
 						    req->ByteCount);
 	}

+err_out:
 	return BAD_PROT_ID;
 }

-- 
2.25.1
