Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B55A7C77B7D
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 08:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjERILu (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 04:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbjERILt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 04:11:49 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4429718F
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 01:11:48 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id a640c23a62f3a-9660af2499dso336950966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 01:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684397507; x=1686989507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMnSNuHdkM5YIGMfhC9sKo3BzQ52DPKg1A2yv+KzG9k=;
        b=gZxecK0PsWuub/Nk8krM75wB4/0mdtI5QhX9iWlrwVEJ5XCyHrAu61A01oM8GnGSXO
         YCKn6caeRZlx5+KCGaSzSOWh2RBmLJG7TtQ31Xf20Loti79K4UKF3zt6c/NiaM9H6OyX
         l3Bz0bVyOL6BMUw7MWpYsVabdUFi0vOKXqhjCuj7geEPADxB4IWsK/4a2l3hgjUuA5SN
         zIK79TgOtEN+QpHQxCpDrWENwWoaHpdcTcqRwJG3BR4HpkwZ03/kz0JwrfuLwn0ajxaI
         WbDBhwQgRzfQVXYVHYV4c/rzNB3tdv7P4gpvuELN9KxnbnH75u/3ATf3Sf19jJVb2W/h
         tiDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684397507; x=1686989507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMnSNuHdkM5YIGMfhC9sKo3BzQ52DPKg1A2yv+KzG9k=;
        b=fpqQkISAU2ZqL8niev2jYRnzLDPGAj8ITCbry5NnAHL5ItIqev1dwOQg7NCbjERSji
         +LP4F0xOPIT9PoiD9nZfNNvdE+kmOH53MUFjv7+HqC/NKsYV00q9ssZ0q1R6ZOVISOQh
         SSzMpslrFwC0Wgu+CYjMkXP76yhWW66JqH2DJIGDQsEr1xKr4gWXDv8knNAml3HZyARt
         kEhdr5jSuBV2EFOEFepbITzPT1JhqMZBDFOw+DJEEj1gyMCnmQfm/ymUKawIafcxS72y
         9iLIeZvhAynciSpIROslAsRSAEoRYoTFipufXcQ/Kqecwor8CPe4j2ZAGJ6CP4zvJIo3
         yrZA==
X-Gm-Message-State: AC+VfDzomqIldpTnGAyrBzBz0WFVn0SbyGcHzeiRCtytA1iD0TwTmhXv
        EDlVavUt1Gewaf4Qf9eBRXoa0b4ASWTpjHJ9Z2A=
X-Google-Smtp-Source: ACHHUZ4KRIK1DkYyss2Y1ntGP4rkLhPQFEfUh6Dv8cZWnSPRe+eFa5UyOS/fiMHnP4KK9Hwqp6QmibqhQt4Y4TY4XWg=
X-Received: by 2002:a17:907:7d87:b0:96a:e022:6486 with SMTP id
 oz7-20020a1709077d8700b0096ae0226486mr16636073ejc.2.1684397506350; Thu, 18
 May 2023 01:11:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230517185820.1264368-1-h3xrabbit@gmail.com> <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
 <CAF3ZFec9Osx4h1CVaWc=w5p71hwHuX-bZCghtcwbgPRX6bEhvg@mail.gmail.com> <CAKYAXd9Lu_NQKH5Nc8aPibNtBXj_vyLj5=bWRokZyLE6vK-Bdg@mail.gmail.com>
In-Reply-To: <CAKYAXd9Lu_NQKH5Nc8aPibNtBXj_vyLj5=bWRokZyLE6vK-Bdg@mail.gmail.com>
From:   Hex Rabbit <h3xrabbit@gmail.com>
Date:   Thu, 18 May 2023 16:11:34 +0800
Message-ID: <CAF3ZFeeufJ3xjrMMSX4GVYZSAUVqabqFG+4xKnz1k3RaS198aQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Namjae Jeon <linkinjeon@kernel.org>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I have decided to leave the modifications within the function that handles =
the
corresponding context. The reason for this is that I believe consolidating =
the
checks together can improve readability, also, moving them out would requir=
e
us to read the size of the flex-sized array again in the corresponding func=
tion.

What do you think?

below is the modified patch:

diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
index 972176bff..0285c3f9e 100644
--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -849,13 +849,13 @@ static void assemble_neg_contexts(struct ksmbd_conn *=
conn,

 static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
   struct smb2_preauth_neg_context *pneg_ctxt,
-  int len_of_ctxts)
+  int ctxt_len)
 {
  /*
  * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
  * which may not be present. Only check for used HashAlgorithms[1].
  */
- if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
+ if (ctxt_len < MIN_PREAUTH_CTXT_DATA_LEN)
  return STATUS_INVALID_PARAMETER;

  if (pneg_ctxt->HashAlgorithms !=3D SMB2_PREAUTH_INTEGRITY_SHA512)
@@ -867,15 +867,23 @@ static __le32 decode_preauth_ctxt(struct ksmbd_conn *=
conn,

 static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
  struct smb2_encryption_neg_context *pneg_ctxt,
- int len_of_ctxts)
+ int ctxt_len)
 {
- int cph_cnt =3D le16_to_cpu(pneg_ctxt->CipherCount);
- int i, cphs_size =3D cph_cnt * sizeof(__le16);
+ int cph_cnt;
+ int i, cphs_size;
+
+ if (sizeof(struct smb2_encryption_neg_context) > ctxt_len) {
+ pr_err("Invalid SMB2_ENCRYPTION_CAPABILITIES context size\n");
+ return;
+ }

  conn->cipher_type =3D 0;

+ cph_cnt =3D le16_to_cpu(pneg_ctxt->CipherCount);
+ cphs_size =3D cph_cnt * sizeof(__le16);
+
  if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
-    len_of_ctxts) {
+    ctxt_len) {
  pr_err("Invalid cipher count(%d)\n", cph_cnt);
  return;
  }
@@ -923,15 +931,22 @@ static void decode_compress_ctxt(struct ksmbd_conn *c=
onn,

 static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
  struct smb2_signing_capabilities *pneg_ctxt,
- int len_of_ctxts)
+ int ctxt_len)
 {
- int sign_algo_cnt =3D le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
- int i, sign_alos_size =3D sign_algo_cnt * sizeof(__le16);
+ int sign_algo_cnt;
+ int i, sign_alos_size;
+
+ if (sizeof(struct smb2_signing_capabilities) > ctxt_len) {
+ pr_err("Invalid SMB2_SIGNING_CAPABILITIES context length\n");
+ return;
+ }

  conn->signing_negotiated =3D false;
+ sign_algo_cnt =3D le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
+ sign_alos_size =3D sign_algo_cnt * sizeof(__le16);

  if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
-    len_of_ctxts) {
+    ctxt_len) {
  pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
  return;
  }
@@ -969,18 +984,16 @@ static __le32 deassemble_neg_contexts(struct
ksmbd_conn *conn,
  len_of_ctxts =3D len_of_smb - offset;

  while (i++ < neg_ctxt_cnt) {
- int clen;
-
- /* check that offset is not beyond end of SMB */
- if (len_of_ctxts =3D=3D 0)
- break;
+ int clen, ctxt_len;

  if (len_of_ctxts < sizeof(struct smb2_neg_context))
  break;

  pctx =3D (struct smb2_neg_context *)((char *)pctx + offset);
  clen =3D le16_to_cpu(pctx->DataLength);
- if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
+ ctxt_len =3D clen + sizeof(struct smb2_neg_context);
+
+ if (ctxt_len > len_of_ctxts)
  break;

  if (pctx->ContextType =3D=3D SMB2_PREAUTH_INTEGRITY_CAPABILITIES) {
@@ -991,7 +1004,7 @@ static __le32 deassemble_neg_contexts(struct
ksmbd_conn *conn,

  status =3D decode_preauth_ctxt(conn,
      (struct smb2_preauth_neg_context *)pctx,
-     len_of_ctxts);
+     ctxt_len);
  if (status !=3D STATUS_SUCCESS)
  break;
  } else if (pctx->ContextType =3D=3D SMB2_ENCRYPTION_CAPABILITIES) {
@@ -1002,7 +1015,7 @@ static __le32 deassemble_neg_contexts(struct
ksmbd_conn *conn,

  decode_encrypt_ctxt(conn,
     (struct smb2_encryption_neg_context *)pctx,
-    len_of_ctxts);
+    ctxt_len);
  } else if (pctx->ContextType =3D=3D SMB2_COMPRESSION_CAPABILITIES) {
  ksmbd_debug(SMB,
     "deassemble SMB2_COMPRESSION_CAPABILITIES context\n");
@@ -1021,9 +1034,10 @@ static __le32 deassemble_neg_contexts(struct
ksmbd_conn *conn,
  } else if (pctx->ContextType =3D=3D SMB2_SIGNING_CAPABILITIES) {
  ksmbd_debug(SMB,
     "deassemble SMB2_SIGNING_CAPABILITIES context\n");
+
  decode_sign_cap_ctxt(conn,
      (struct smb2_signing_capabilities *)pctx,
-     len_of_ctxts);
+     ctxt_len);
  }

  /* offsets must be 8 byte aligned */
---

Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=8818=E6=
=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=882:36=E5=AF=AB=E9=81=93=EF=BC=9A
>
> 2023-05-18 15:30 GMT+09:00, Hex Rabbit <h3xrabbit@gmail.com>:
> >> You need to consider Ciphers flex-array size to validate ctxt_len. we
> >> can get its size using CipherCount in smb2_encryption_neg_context.
> >
> > I'm not checking the flex-array size since both `decode_sign_cap_ctxt()=
`
> > and `decode_encrypt_ctxt()` have done it, or should I move it out?
> Yes, We can move it out. Thanks.
> >
> > ```
> > if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
> >    len_of_ctxts) {
> >     pr_err("Invalid cipher count(%d)\n", cph_cnt);
> >     return;
> > }
> > ```
> >
> > ```
> > if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
> >    len_of_ctxts) {
> >     pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
> >     return;
> > }
> > ```
> >
