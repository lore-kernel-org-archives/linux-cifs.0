Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C7913D2B2;
	Wed, 13 Nov 2024 17:09:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731517765; cv=none; b=aCgL88HTSTTqOoW9OtW3xNLUTgTPrHg0GlaG+TuxJsOWZwFiaScEA8SL6H+ipTNdV9mKCPPOPWV13rwj3BScP03N8F2uDoz4cMr58FRfnlJK07e/FwezHI8dT6WDRt7xY0UKd8D03NrD+ErLRnFhdtMhyHY5aMFpHeDhuVY8F0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731517765; c=relaxed/simple;
	bh=cBHQbCzGz3rUEXpTSv8dbThEFcHNSstMSfFNbQisk1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ULVtmV6n5KheqT+h/JVNkTBc5tqt2qG0uKinsl8z5Vlj0+95b5OTfSWk5RE0cWCUD8sOaqp3LwMTI7fV0JNjSgMtvnSG39HpM3h8SBmGmvpP5cKdbd1fcWcP98lYAcM+p/6hrIwxKsMuyEE7ZMld3wi6n1IQS3h4ZMxePj9ThmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZtuYg9cL; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZtuYg9cL"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-539d9fffea1so7142337e87.2;
        Wed, 13 Nov 2024 09:09:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731517761; x=1732122561; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jadf3pMq6CbgWyqAcchpAE7uOT3rAXGBeVpVpylqHIU=;
        b=ZtuYg9cLmJMSWH3L2Pj4hWuiJfANfFOeyoi5i9xVn2DvTYEKD78CnAGPwWWVmPiv9l
         9vVT/yTxBYrHvdmkfWr/vR84C/vwnbH5OVnleYm5s5wEIyrN3fVqSjJ5U4dd/7GHtdp4
         tkHZT5Jng0ARWB83EnLgRElPQDAG9B91hJ835AkLQZ1K3SrU1MyCkTtm1LiB6ajdRF3v
         kMy3LzkmzuK9Kp/+aDbEPHC/39ZqymF9C6rS5sdWtXRtjZmmvZtfh2hEk9p29XY75DZH
         ZFMjrWjAXAuUlMeQ9X3et5UvqCvxooYfRANvhE4RecBYQnMVceajHzv/M6AB/aSjTdZv
         MUuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731517761; x=1732122561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jadf3pMq6CbgWyqAcchpAE7uOT3rAXGBeVpVpylqHIU=;
        b=r/CNWJzP0kLDnTKXPY+I37lV1OJWEHezvZ9ylGHpH1qko1pdR4mXlBxGMtKxH69Evl
         2/tZ2m88tXh3v19ln5D294mOaE/IEKDjd/VyktHZGscnPeDWHMvCWU2BD1011pH32hO1
         TCRRduK3jS1MaC7qLkk2ynl4df/S7o56ep0QfIa2e/J/Gvv1OLuQ1X8FU2RoeTOy0k1p
         PjxXizUKLgZnvgJEDmM75i1Up0CCEu45rMJEtljdS3rwDI3NVGBxRgipJf+QqqcYnV7S
         o3zXapdAXItLMCP6bGpfxP+/nFyI31nikf6fyuhsf1q2WqEJ8FocD0zhHvfyu2ZuNsN0
         MNFg==
X-Forwarded-Encrypted: i=1; AJvYcCW5roXcI1SLGItXpZyMUwIrvupN8jeuKybrV1ZbprPMyWalzmU135PDGKsKRCYZF8LqNp86nrJ9CZxg++V+@vger.kernel.org, AJvYcCXtGoa02lsVset9Gbbsx7B5f/iI5mQsSdm5kKpXyrohOA1bDXTFitZFOcZmTF4RmyFvyfEouVJ0Vt9v@vger.kernel.org
X-Gm-Message-State: AOJu0Yxzn8gpR8N/ebwcAxIm+pMeEvo2UcxnEA+/XeqAl43OqZc2Dd2N
	dK+jhr3bgGTLAW7Z0V2AGIODr839kAPhtA9QGHHYuJ8kbLvBhxSkrRHePkhFlX7GVYB1RhSr/ce
	omzRQg1IZXukDaEO1oc9CfkHnO/g=
X-Google-Smtp-Source: AGHT+IFq3N+nFrlBubyKiRS2dmCyiRc5NNRD3+kpAaB8nxWmiyEoSJPdUUIz88JUno2fPKzUp4W1hWS5DyMJmyb4vw0=
X-Received: by 2002:a05:6512:e99:b0:53d:a283:f298 with SMTP id
 2adb3069b0e04-53da283f5a2mr1610493e87.17.1731517761277; Wed, 13 Nov 2024
 09:09:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241007210214.102568-1-linux@treblig.org>
In-Reply-To: <20241007210214.102568-1-linux@treblig.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 13 Nov 2024 11:09:10 -0600
Message-ID: <CAH2r5msrcCqvJwvS3w5HzoO16fHNeoj=QNxd+Rs6d04aFPURiw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Remove pre-historic unused CIFSSMBCopy
To: linux@treblig.org
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Oct 7, 2024 at 4:02=E2=80=AFPM <linux@treblig.org> wrote:
>
> From: "Dr. David Alan Gilbert" <linux@treblig.org>
>
> CIFSSMBCopy() is unused, remove it.
>
> It seems to have been that way pre-git; looking in a historic
> archive, I think it landed around May 2004 in Linus'
> BKrev: 40ab7591J_OgkpHW-qhzZukvAUAw9g
> and was unused back then.
>
> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>
> ---
>  fs/smb/client/cifsproto.h |  7 -----
>  fs/smb/client/cifssmb.c   | 63 ---------------------------------------
>  2 files changed, 70 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 1d3470bca45e..8235b5a0aa2b 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -549,13 +549,6 @@ extern int generate_smb311signingkey(struct cifs_ses=
 *ses,
>                                      struct TCP_Server_Info *server);
>
>  #ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
> -extern int CIFSSMBCopy(unsigned int xid,
> -                       struct cifs_tcon *source_tcon,
> -                       const char *fromName,
> -                       const __u16 target_tid,
> -                       const char *toName, const int flags,
> -                       const struct nls_table *nls_codepage,
> -                       int remap_special_chars);
>  extern ssize_t CIFSSMBQAllEAs(const unsigned int xid, struct cifs_tcon *=
tcon,
>                         const unsigned char *searchName,
>                         const unsigned char *ea_name, char *EAData,
> diff --git a/fs/smb/client/cifssmb.c b/fs/smb/client/cifssmb.c
> index c6f15dbe860a..ca50ac652e02 100644
> --- a/fs/smb/client/cifssmb.c
> +++ b/fs/smb/client/cifssmb.c
> @@ -2339,69 +2339,6 @@ int CIFSSMBRenameOpenFile(const unsigned int xid, =
struct cifs_tcon *pTcon,
>         return rc;
>  }
>
> -int
> -CIFSSMBCopy(const unsigned int xid, struct cifs_tcon *tcon,
> -           const char *fromName, const __u16 target_tid, const char *toN=
ame,
> -           const int flags, const struct nls_table *nls_codepage, int re=
map)
> -{
> -       int rc =3D 0;
> -       COPY_REQ *pSMB =3D NULL;
> -       COPY_RSP *pSMBr =3D NULL;
> -       int bytes_returned;
> -       int name_len, name_len2;
> -       __u16 count;
> -
> -       cifs_dbg(FYI, "In CIFSSMBCopy\n");
> -copyRetry:
> -       rc =3D smb_init(SMB_COM_COPY, 1, tcon, (void **) &pSMB,
> -                       (void **) &pSMBr);
> -       if (rc)
> -               return rc;
> -
> -       pSMB->BufferFormat =3D 0x04;
> -       pSMB->Tid2 =3D target_tid;
> -
> -       pSMB->Flags =3D cpu_to_le16(flags & COPY_TREE);
> -
> -       if (pSMB->hdr.Flags2 & SMBFLG2_UNICODE) {
> -               name_len =3D cifsConvertToUTF16((__le16 *) pSMB->OldFileN=
ame,
> -                                             fromName, PATH_MAX, nls_cod=
epage,
> -                                             remap);
> -               name_len++;     /* trailing null */
> -               name_len *=3D 2;
> -               pSMB->OldFileName[name_len] =3D 0x04;     /* pad */
> -               /* protocol requires ASCII signature byte on Unicode stri=
ng */
> -               pSMB->OldFileName[name_len + 1] =3D 0x00;
> -               name_len2 =3D
> -                   cifsConvertToUTF16((__le16 *)&pSMB->OldFileName[name_=
len+2],
> -                                      toName, PATH_MAX, nls_codepage, re=
map);
> -               name_len2 +=3D 1 /* trailing null */  + 1 /* Signature wo=
rd */ ;
> -               name_len2 *=3D 2; /* convert to bytes */
> -       } else {
> -               name_len =3D copy_path_name(pSMB->OldFileName, fromName);
> -               pSMB->OldFileName[name_len] =3D 0x04;  /* 2nd buffer form=
at */
> -               name_len2 =3D copy_path_name(pSMB->OldFileName+name_len+1=
, toName);
> -               name_len2++;    /* signature byte */
> -       }
> -
> -       count =3D 1 /* 1st signature byte */  + name_len + name_len2;
> -       inc_rfc1001_len(pSMB, count);
> -       pSMB->ByteCount =3D cpu_to_le16(count);
> -
> -       rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -               (struct smb_hdr *) pSMBr, &bytes_returned, 0);
> -       if (rc) {
> -               cifs_dbg(FYI, "Send error in copy =3D %d with %d files co=
pied\n",
> -                        rc, le16_to_cpu(pSMBr->CopyCount));
> -       }
> -       cifs_buf_release(pSMB);
> -
> -       if (rc =3D=3D -EAGAIN)
> -               goto copyRetry;
> -
> -       return rc;
> -}
> -
>  int
>  CIFSUnixCreateSymLink(const unsigned int xid, struct cifs_tcon *tcon,
>                       const char *fromName, const char *toName,
> --
> 2.46.2
>
>


--=20
Thanks,

Steve
