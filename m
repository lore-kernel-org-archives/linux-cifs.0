Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5619C433DB
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:01:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8926D64E3E
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Feb 2021 18:01:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237949AbhBBSBE (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Feb 2021 13:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbhBBR7K (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Feb 2021 12:59:10 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33C5FC061788
        for <linux-cifs@vger.kernel.org>; Tue,  2 Feb 2021 09:58:30 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id d2so23959335edz.3
        for <linux-cifs@vger.kernel.org>; Tue, 02 Feb 2021 09:58:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1Fg9Cg1bRF7U4QfGthw1dSAbOWbWjadgBrlqJMHuQ4c=;
        b=PXU4JXGpfeGWjz162LIQsTXmR2OsYh2/MmdUeccD0188PH2b17KeX7HyA2NigrJsYL
         Gkz9f1ggvNujtu0fDo9fqmFcMH4arcDAlBQ+ryuWk8ykqgVvmt132MJ+/u/+lAKq3m5i
         Zfbg+s3rXC6E7/Ugb3mI7ejFpf9lNz82SjBjCkqg+94yiKmz03LdMCRvbHanYZh3t0VL
         eGTnxYo0xjm6E3wyCws4IptTALeaKQWLnJV0UK0RfPQ6QE6kHBk2+0aiZqxVpidDzZBC
         ZSAu4wbc1UroiESAT+IsnD4uGFUP14sNh8664dxBtfoTie/oe/vqSpoS4NcEMQ2aesPJ
         38hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1Fg9Cg1bRF7U4QfGthw1dSAbOWbWjadgBrlqJMHuQ4c=;
        b=aahe5xKsJGUV+kp+PAFcCl4dwehlilcpm+VTcnYOmpltcaOLSBGCSGQc7DIX+/9oWC
         xLnMQeVf7TakAIp7U4bYy3Sc5yEwIFOHH+tU/cF4FJBBia0fGBKsTy8YACC7IJXuhGXL
         R2ZMGC8Ge/MXAEfnrihI65i/uya8zuPJd8ucZK1QZK/UD/bePAn2b3mUz2pbfvjFCb4h
         ukWT7HZMCEyPvGIuFVcM969iiOLSEC31BfBkUGcfKTwPkQ21/H8o85PWTgOIjAk1l8lC
         SWCGkjpdwW4mCOIT2reu6F5Yuxj6AMpjdZxupo1RU2j54fFDpX+L+UknpwMfDxfHC0SF
         lSDQ==
X-Gm-Message-State: AOAM531tazc/Pof12JQmuFiGwi8013CGA4/bKoV5LtO1zj0W13KayvBd
        hNDioXiE5nemAqtjVdEf2mYnAL6yKk5mVh4pzA==
X-Google-Smtp-Source: ABdhPJwIWMLIu7JcHLqXSP830Fx9KJmkrjVxo72YzV1O7VRhIUX/bwn867Ns6cQjQQlzHJViGkw2HPAaBnAwpgtkoXk=
X-Received: by 2002:a50:8b66:: with SMTP id l93mr123387edl.384.1612288708881;
 Tue, 02 Feb 2021 09:58:28 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5mt7Z2wJTLFp1T0qtsrJb95FPKoffBN9WBM=JAi=HcyiOg@mail.gmail.com>
In-Reply-To: <CAH2r5mt7Z2wJTLFp1T0qtsrJb95FPKoffBN9WBM=JAi=HcyiOg@mail.gmail.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Tue, 2 Feb 2021 09:58:17 -0800
Message-ID: <CAKywueTvFL7GA3he21XjX8fig73iT5OCAd=JjBq6OOwOavcehA@mail.gmail.com>
Subject: Re: PATCH] smb3: include current dialect (SMB3.1.1) when version 3 or
 greater requested on mount
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D0=BD, 1 =D1=84=D0=B5=D0=B2=D1=80. 2021 =D0=B3. =D0=B2 22:15, Steve =
French <smfrench@gmail.com>:
>
> SMB3.1.1 is the newest, and preferred dialect, and is included in
> the requested dialect list by default (ie if no vers=3D is specified
> on mount) but it should also be requested if SMB3 or later is requested
> (vers=3D3 instead of a specific dialect: vers=3D2.1, vers=3D3.02 or vers=
=3D3.0).
>
> Currently specifying "vers=3D3" only requests smb3.0 and smb3.02 but this
> patch fixes it to also request smb3.1.1 dialect, as it is the newest
> and most secure dialect and is a "version 3 or later" dialect (the intent
> of "vers=3D3").
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Suggested-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/fs_context.c |  2 +-
>  fs/cifs/smb2pdu.c    | 19 +++++++++++++------
>  2 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/cifs/fs_context.c b/fs/cifs/fs_context.c
> index 5111aadfdb6b..479c24695281 100644
> --- a/fs/cifs/fs_context.c
> +++ b/fs/cifs/fs_context.c
> @@ -391,7 +391,7 @@ cifs_parse_smb_version(char *value, struct
> smb3_fs_context *ctx, bool is_smb3)
>   ctx->vals =3D &smb3any_values;
>   break;
>   case Smb_default:
> - ctx->ops =3D &smb30_operations; /* currently identical with 3.0 */
> + ctx->ops =3D &smb30_operations;
>   ctx->vals =3D &smbdefault_values;
>   break;
>   default:
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 794fc3b68b4f..52625549c3b5 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -814,8 +814,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_se=
s *ses)
>      SMB3ANY_VERSION_STRING) =3D=3D 0) {
>   req->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
>   req->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> - req->DialectCount =3D cpu_to_le16(2);
> - total_len +=3D 4;
> + req->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> + req->DialectCount =3D cpu_to_le16(3);
> + total_len +=3D 6;
>   } else if (strcmp(server->vals->version_string,
>      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
>   req->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> @@ -848,6 +849,8 @@ SMB2_negotiate(const unsigned int xid, struct cifs_se=
s *ses)
>   memcpy(req->ClientGUID, server->client_guid,
>   SMB2_CLIENT_GUID_SIZE);
>   if ((server->vals->protocol_id =3D=3D SMB311_PROT_ID) ||
> +     (strcmp(server->vals->version_string,
> +      SMB3ANY_VERSION_STRING) =3D=3D 0) ||
>       (strcmp(server->vals->version_string,
>        SMBDEFAULT_VERSION_STRING) =3D=3D 0))
>   assemble_neg_contexts(req, server, &total_len);
> @@ -883,6 +886,9 @@ SMB2_negotiate(const unsigned int xid, struct cifs_se=
s *ses)
>   cifs_server_dbg(VFS,
>   "SMB2.1 dialect returned but not requested\n");
>   return -EIO;
> + } else if (rsp->DialectRevision =3D=3D cpu_to_le16(SMB311_PROT_ID)) {

I think we should include comment "/* ops set to 3.0 by default for
default so update */" as in smbdefault case to improve readability.

> + server->ops =3D &smb311_operations;
> + server->vals =3D &smb311_values;
>   }
>   } else if (strcmp(server->vals->version_string,
>      SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
> @@ -1042,10 +1048,11 @@ int smb3_validate_negotiate(const unsigned int
> xid, struct cifs_tcon *tcon)
>   SMB3ANY_VERSION_STRING) =3D=3D 0) {
>   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB30_PROT_ID);
>   pneg_inbuf->Dialects[1] =3D cpu_to_le16(SMB302_PROT_ID);
> - pneg_inbuf->DialectCount =3D cpu_to_le16(2);
> - /* structure is big enough for 3 dialects, sending only 2 */
> + pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB311_PROT_ID);
> + pneg_inbuf->DialectCount =3D cpu_to_le16(3);
> + /* SMB 2.1 not included so subtract one dialect from len */
>   inbuflen =3D sizeof(*pneg_inbuf) -
> - (2 * sizeof(pneg_inbuf->Dialects[0]));
> + (sizeof(pneg_inbuf->Dialects[0]));
>   } else if (strcmp(server->vals->version_string,
>   SMBDEFAULT_VERSION_STRING) =3D=3D 0) {
>   pneg_inbuf->Dialects[0] =3D cpu_to_le16(SMB21_PROT_ID);
> @@ -1053,7 +1060,7 @@ int smb3_validate_negotiate(const unsigned int
> xid, struct cifs_tcon *tcon)
>   pneg_inbuf->Dialects[2] =3D cpu_to_le16(SMB302_PROT_ID);
>   pneg_inbuf->Dialects[3] =3D cpu_to_le16(SMB311_PROT_ID);
>   pneg_inbuf->DialectCount =3D cpu_to_le16(4);
> - /* structure is big enough for 3 dialects */
> + /* structure is big enough for 4 dialects */
>   inbuflen =3D sizeof(*pneg_inbuf);
>   } else {
>   /* otherwise specific dialect was requested */
>
> --
> Thanks,
>
> Steve

Looks good overall.

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>
--
Best regards,
Pavel Shilovsky
