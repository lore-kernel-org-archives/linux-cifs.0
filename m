Return-Path: <SRS0=foj0=DW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3833AC433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 08:49:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D565E218AC
	for <linux-cifs@archiver.kernel.org>; Thu, 15 Oct 2020 08:49:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="J9DqBIcE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388297AbgJOItX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 15 Oct 2020 04:49:23 -0400
Received: from mx2.suse.de ([195.135.220.15]:54874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388282AbgJOItW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 15 Oct 2020 04:49:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602751761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6Mp6AN/mQn8I3/lOKadTPpPQZD84cpZKP7zgTme/VE=;
        b=J9DqBIcE880umWHruO0XJHZrfoexQGHZvnDvSsXXis1bhmlvQy7bL64OxYkBLamtN4sMTE
        XmQtkweXVgTOAH48SqZmCo/1PnQgrqkFAZ14/5tYwCSSqOANMsTnJlcE9Mkiub/3tYA3uC
        lxmNegPgyNFFMDFDovGAU6Lg+aYwwMs=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2DE2FAD03;
        Thu, 15 Oct 2020 08:49:21 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Add support for GCM256 encryption
In-Reply-To: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
References: <CAH2r5mtAOxF=PCndMTXxj_dZVLc-NQJfoawOvMeS3FbxiCU6xw@mail.gmail.com>
Date:   Thu, 15 Oct 2020 10:49:20 +0200
Message-ID: <87eelzho1b.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

Patch 2:

> From 3897b440fd14dfc7b2ad2b0a922302ea7705b5d9 Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Wed, 14 Oct 2020 20:24:09 -0500
> Subject: [PATCH 2/5] smb3.1.1: add new module load parm enable_gcm_256
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -361,8 +361,9 @@ struct smb2_encryption_neg_context {
>  	__le16	ContextType; /* 2 */
>  	__le16	DataLength;
>  	__le32	Reserved;
> -	__le16	CipherCount; /* AES-128-GCM and AES-128-CCM */
> -	__le16	Ciphers[2];
> +	/* CipherCount usally 2, but can be 3 when AES256-GCM enabled */
> +	__le16	CipherCount; /* AES128-GCM and AES128-CCM by defalt */

Typo defalt =3D> default

> +	__le16	Ciphers[3];
>  } __packed;
>=20=20
>  /* See MS-SMB2 2.2.3.1.3 */
> --=20
> 2.25.1
>

Patch 5:

> From 314d7476e404c37acb77c3f9ecc142122e7afbfd Mon Sep 17 00:00:00 2001
> From: Steve French <stfrench@microsoft.com>
> Date: Fri, 11 Sep 2020 16:47:09 -0500
> Subject: [PATCH 5/5] smb3.1.1: set gcm256 when requested
>
> update code to set 32 byte key length and to set gcm256 when requested
> on mount.
>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>  fs/cifs/smb2glob.h      |  1 +
>  fs/cifs/smb2ops.c       | 20 ++++++++++++--------
>  fs/cifs/smb2transport.c | 16 ++++++++--------
>  3 files changed, 21 insertions(+), 16 deletions(-)
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index dd1edabec328..d8e74954d101 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3954,7 +3954,12 @@ crypt_message(struct TCP_Server_Info *server, int =
num_rqst,
>=20=20
>  	tfm =3D enc ? server->secmech.ccmaesencrypt :
>  						server->secmech.ccmaesdecrypt;
> -	rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> +
> +	if (require_gcm_256)
> +		rc =3D crypto_aead_setkey(tfm, key, SMB3_GCM256_CRYPTKEY_SIZE);

Shouldn't the check be on server->cipher_type?

> +	else
> +		rc =3D crypto_aead_setkey(tfm, key, SMB3_SIGN_KEY_SIZE);
> +
>  	if (rc) {
>  		cifs_server_dbg(VFS, "%s: Failed to set aead key %d\n", __func__, rc);
>  		return rc;

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
