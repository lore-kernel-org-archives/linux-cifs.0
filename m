Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CA76C7EE23
	for <linux-cifs@archiver.kernel.org>; Thu, 18 May 2023 14:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjEROKo (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 18 May 2023 10:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjEROKk (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 18 May 2023 10:10:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CA51B5
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:10:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E3B8B64EB9
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 14:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550D9C433D2
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1684419038;
        bh=ObTu/luK9+yee4YrvuVhj74kqKRUsLiPBEkTb+xefXQ=;
        h=In-Reply-To:References:From:Date:Subject:To:Cc:From;
        b=Ey8yav47aKbr2LlFaTuzLNP9Mbv8mg+78ymq/Wezek8xlofzmfWNsWbsxl7kzj7ZX
         DMETIOWPUGHuRH90fiiTv720R089d8OKAgPfXPxWn7kyyE0T7+Awo+3o+r0ldseRE9
         s4inSjta06V0/2KAX4rW8zVX+WZ0lyx0qeV+O5l+VQ3JqoQqzffuxTrosH4HM9qs85
         Hc+h5hrG4c66sYWlV1tgGuB6ZPpVAo5ULVwE8MYxg9XVvDuV5fdfG4RCz9viyH4A6m
         sKCeLUuFEdhBXKsT/Qg7EXCPUyYvPGtX8TaCOGYpaIbckzTTFnr1E4FZZAJDRMT7WO
         rRpDibxhB+idA==
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6ab0c70801dso919570a34.0
        for <linux-cifs@vger.kernel.org>; Thu, 18 May 2023 07:10:38 -0700 (PDT)
X-Gm-Message-State: AC+VfDy/8QFlx8j1jvWJG7px80EuRGQEOEoP99xgOUbBpt38uhaHsCAG
        hiXYGbkR/kRPUXeRLKkeeEgf7Tr9YC77EnVrP1k=
X-Google-Smtp-Source: ACHHUZ7nqgn8q9DkN/jEpcOwA+WKrqAchRPbzwXxGUCv01IwH53RvVWBEmhcfBXFoK6peJ6kNAHSMcbzbXtV++51PiA=
X-Received: by 2002:aca:1315:0:b0:395:1c09:1e1b with SMTP id
 e21-20020aca1315000000b003951c091e1bmr1287776oii.39.1684419037421; Thu, 18
 May 2023 07:10:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ac9:6415:0:b0:4da:311c:525d with HTTP; Thu, 18 May 2023
 07:10:36 -0700 (PDT)
In-Reply-To: <CAF3ZFeeufJ3xjrMMSX4GVYZSAUVqabqFG+4xKnz1k3RaS198aQ@mail.gmail.com>
References: <20230517185820.1264368-1-h3xrabbit@gmail.com> <CAKYAXd85JZnU9pH8a0qGqXGWn=m3j=LS_kArV9TL1+m1f3fCgA@mail.gmail.com>
 <CAF3ZFec9Osx4h1CVaWc=w5p71hwHuX-bZCghtcwbgPRX6bEhvg@mail.gmail.com>
 <CAKYAXd9Lu_NQKH5Nc8aPibNtBXj_vyLj5=bWRokZyLE6vK-Bdg@mail.gmail.com> <CAF3ZFeeufJ3xjrMMSX4GVYZSAUVqabqFG+4xKnz1k3RaS198aQ@mail.gmail.com>
From:   Namjae Jeon <linkinjeon@kernel.org>
Date:   Thu, 18 May 2023 23:10:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd91UgqOSs500ho_pP36ok=aAb3Yca3nzRaRFNQ=6_AGmg@mail.gmail.com>
Message-ID: <CAKYAXd91UgqOSs500ho_pP36ok=aAb3Yca3nzRaRFNQ=6_AGmg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix multiple out-of-bounds read during context decoding
To:     Hex Rabbit <h3xrabbit@gmail.com>
Cc:     sfrench@samba.org, senozhatsky@chromium.org, tom@talpey.com,
        linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

2023-05-18 17:11 GMT+09:00, Hex Rabbit <h3xrabbit@gmail.com>:
> I have decided to leave the modifications within the function that handle=
s
> the
> corresponding context. The reason for this is that I believe consolidatin=
g
> the
> checks together can improve readability, also, moving them out would
> require
> us to read the size of the flex-sized array again in the corresponding
> function.
>
> What do you think?
Looks okay. Please send the patch to test to the list.

Thanks.
>
> below is the modified patch:
>
> diff --git a/fs/ksmbd/smb2pdu.c b/fs/ksmbd/smb2pdu.c
> index 972176bff..0285c3f9e 100644
> --- a/fs/ksmbd/smb2pdu.c
> +++ b/fs/ksmbd/smb2pdu.c
> @@ -849,13 +849,13 @@ static void assemble_neg_contexts(struct ksmbd_conn
> *conn,
>
>  static __le32 decode_preauth_ctxt(struct ksmbd_conn *conn,
>    struct smb2_preauth_neg_context *pneg_ctxt,
> -  int len_of_ctxts)
> +  int ctxt_len)
>  {
>   /*
>   * sizeof(smb2_preauth_neg_context) assumes SMB311_SALT_SIZE Salt,
>   * which may not be present. Only check for used HashAlgorithms[1].
>   */
> - if (len_of_ctxts < MIN_PREAUTH_CTXT_DATA_LEN)
> + if (ctxt_len < MIN_PREAUTH_CTXT_DATA_LEN)
>   return STATUS_INVALID_PARAMETER;
>
>   if (pneg_ctxt->HashAlgorithms !=3D SMB2_PREAUTH_INTEGRITY_SHA512)
> @@ -867,15 +867,23 @@ static __le32 decode_preauth_ctxt(struct ksmbd_conn
> *conn,
>
>  static void decode_encrypt_ctxt(struct ksmbd_conn *conn,
>   struct smb2_encryption_neg_context *pneg_ctxt,
> - int len_of_ctxts)
> + int ctxt_len)
>  {
> - int cph_cnt =3D le16_to_cpu(pneg_ctxt->CipherCount);
> - int i, cphs_size =3D cph_cnt * sizeof(__le16);
> + int cph_cnt;
> + int i, cphs_size;
> +
> + if (sizeof(struct smb2_encryption_neg_context) > ctxt_len) {
> + pr_err("Invalid SMB2_ENCRYPTION_CAPABILITIES context size\n");
> + return;
> + }
>
>   conn->cipher_type =3D 0;
>
> + cph_cnt =3D le16_to_cpu(pneg_ctxt->CipherCount);
> + cphs_size =3D cph_cnt * sizeof(__le16);
> +
>   if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
> -    len_of_ctxts) {
> +    ctxt_len) {
>   pr_err("Invalid cipher count(%d)\n", cph_cnt);
>   return;
>   }
> @@ -923,15 +931,22 @@ static void decode_compress_ctxt(struct ksmbd_conn
> *conn,
>
>  static void decode_sign_cap_ctxt(struct ksmbd_conn *conn,
>   struct smb2_signing_capabilities *pneg_ctxt,
> - int len_of_ctxts)
> + int ctxt_len)
>  {
> - int sign_algo_cnt =3D le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
> - int i, sign_alos_size =3D sign_algo_cnt * sizeof(__le16);
> + int sign_algo_cnt;
> + int i, sign_alos_size;
> +
> + if (sizeof(struct smb2_signing_capabilities) > ctxt_len) {
> + pr_err("Invalid SMB2_SIGNING_CAPABILITIES context length\n");
> + return;
> + }
>
>   conn->signing_negotiated =3D false;
> + sign_algo_cnt =3D le16_to_cpu(pneg_ctxt->SigningAlgorithmCount);
> + sign_alos_size =3D sign_algo_cnt * sizeof(__le16);
>
>   if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
> -    len_of_ctxts) {
> +    ctxt_len) {
>   pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
>   return;
>   }
> @@ -969,18 +984,16 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>   len_of_ctxts =3D len_of_smb - offset;
>
>   while (i++ < neg_ctxt_cnt) {
> - int clen;
> -
> - /* check that offset is not beyond end of SMB */
> - if (len_of_ctxts =3D=3D 0)
> - break;
> + int clen, ctxt_len;
>
>   if (len_of_ctxts < sizeof(struct smb2_neg_context))
>   break;
>
>   pctx =3D (struct smb2_neg_context *)((char *)pctx + offset);
>   clen =3D le16_to_cpu(pctx->DataLength);
> - if (clen + sizeof(struct smb2_neg_context) > len_of_ctxts)
> + ctxt_len =3D clen + sizeof(struct smb2_neg_context);
> +
> + if (ctxt_len > len_of_ctxts)
>   break;
>
>   if (pctx->ContextType =3D=3D SMB2_PREAUTH_INTEGRITY_CAPABILITIES) {
> @@ -991,7 +1004,7 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>
>   status =3D decode_preauth_ctxt(conn,
>       (struct smb2_preauth_neg_context *)pctx,
> -     len_of_ctxts);
> +     ctxt_len);
>   if (status !=3D STATUS_SUCCESS)
>   break;
>   } else if (pctx->ContextType =3D=3D SMB2_ENCRYPTION_CAPABILITIES) {
> @@ -1002,7 +1015,7 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>
>   decode_encrypt_ctxt(conn,
>      (struct smb2_encryption_neg_context *)pctx,
> -    len_of_ctxts);
> +    ctxt_len);
>   } else if (pctx->ContextType =3D=3D SMB2_COMPRESSION_CAPABILITIES) {
>   ksmbd_debug(SMB,
>      "deassemble SMB2_COMPRESSION_CAPABILITIES context\n");
> @@ -1021,9 +1034,10 @@ static __le32 deassemble_neg_contexts(struct
> ksmbd_conn *conn,
>   } else if (pctx->ContextType =3D=3D SMB2_SIGNING_CAPABILITIES) {
>   ksmbd_debug(SMB,
>      "deassemble SMB2_SIGNING_CAPABILITIES context\n");
> +
>   decode_sign_cap_ctxt(conn,
>       (struct smb2_signing_capabilities *)pctx,
> -     len_of_ctxts);
> +     ctxt_len);
>   }
>
>   /* offsets must be 8 byte aligned */
> ---
>
> Namjae Jeon <linkinjeon@kernel.org> =E6=96=BC 2023=E5=B9=B45=E6=9C=8818=
=E6=97=A5 =E9=80=B1=E5=9B=9B =E4=B8=8B=E5=8D=882:36=E5=AF=AB=E9=81=93=EF=BC=
=9A
>>
>> 2023-05-18 15:30 GMT+09:00, Hex Rabbit <h3xrabbit@gmail.com>:
>> >> You need to consider Ciphers flex-array size to validate ctxt_len. we
>> >> can get its size using CipherCount in smb2_encryption_neg_context.
>> >
>> > I'm not checking the flex-array size since both
>> > `decode_sign_cap_ctxt()`
>> > and `decode_encrypt_ctxt()` have done it, or should I move it out?
>> Yes, We can move it out. Thanks.
>> >
>> > ```
>> > if (sizeof(struct smb2_encryption_neg_context) + cphs_size >
>> >    len_of_ctxts) {
>> >     pr_err("Invalid cipher count(%d)\n", cph_cnt);
>> >     return;
>> > }
>> > ```
>> >
>> > ```
>> > if (sizeof(struct smb2_signing_capabilities) + sign_alos_size >
>> >    len_of_ctxts) {
>> >     pr_err("Invalid signing algorithm count(%d)\n", sign_algo_cnt);
>> >     return;
>> > }
>> > ```
>> >
>
