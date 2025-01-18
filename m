Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE82ABA38;
	Sat, 18 Jan 2025 19:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737228803; cv=none; b=OYt/bPT2AW/QzRgTsTJ87aiIOXQaLE1WYLcmpGhF7+ynI84o9N4kf4xOZ8MrH/NXx49e45hrlP031C4cTcwRHJoIyWgzX/T0BsykGxu8nafjwAq9zDSfRq/RKRHHe96UYDkx/6gxuVPfgcXnnlA0LYjSPcnNwL2hmJPlGgDBpeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737228803; c=relaxed/simple;
	bh=if3Vo/AO41fvcq7LdIiUh4BYn57++aZ+yERLCW84m/Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ICZKS4hdnkKWDEnKwSusMlzkAoPU/mDgg58t0b5ChIQT664TRk9l5H85dz1/v1TtbSxwCI/fa+ej+2iG1lvB+NEJaA3EUCFtEQbMOMRlICaGP5CG0zjj2WsisLId5f0cWeUsSptCwcKGRwXV5N78Tkd/C0u1F2sGmkMIpG3NBrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hoISdcwq; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hoISdcwq"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-54021daa6cbso3461069e87.0;
        Sat, 18 Jan 2025 11:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737228800; x=1737833600; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7Oyn69SMQEPAtr/12a6Ym0htpFikla3Rih6I5+rYZ0=;
        b=hoISdcwqhxoz2U2nFj1V9VFAUWIsm59D3BWbcH000Yo0OQpmX9SafgivHATkZlAPcF
         FMGsBS2OyDxZKsnHcZkPGokN8AbX1UDgT0ZgApVF22hb4jbm1ilWMqFcqvszpWYdbh71
         sPCywiuesIHD3rQUcAeebjdF94QLVy2ZhKxl2YFHFjFwJlk6ksdMyp5EYV5CLpsMiiiD
         lLKYIHwHMyypROQR0cPHfcV099nn6nKGo3DjAaWqB+BXC0Hb7R3ehExxGsOttu89t7Sy
         76lqWKbdGoaJeCvh4K8nBI9ewC/kcJ1ChhYUKtLNbE0Xi+hIRcZPqy1cYu6pOYK8wOEL
         nhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737228800; x=1737833600;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W7Oyn69SMQEPAtr/12a6Ym0htpFikla3Rih6I5+rYZ0=;
        b=JZUl7Tcpzbna9wOZJxoDEstoNA6kIgus9BNxeJnPWwkRrrFUXV+YLTDpYD02KXRnMY
         6xpIPAr1VoUiIA9I26ObRKmRgADIjL40XilukPYe6Dqxf82dIYifcRJT1c3DoPaV0O4f
         O8JUSxbx0FdpQielSHyrSwEta7no2JwKh6LmhT4kDhi6EK1g5GutGBIl2gq2brN9Ko5u
         sVHQ4YrJmu64EeR3wtaYrcXOQayZIUowH7jM3gMLPLf/Ic6NkKiRNfHmLzaWexFdx9s4
         PDpSu7wCTWe9v/SLBgUdlKwFUMDBhcU/NEf42mPJ0+b3VkfColrFyKbNUR+foVO6NtI5
         femw==
X-Forwarded-Encrypted: i=1; AJvYcCUl1Azwi56zTW/qKCbZ+CzFAe23zNc0Q5XuneZE2DzJA+xoRzClMXZfGdsUmDEOjIzqP+ZfJsI8H9ho@vger.kernel.org, AJvYcCXp5MCCfIz9E1rrRHIeNbIfdBdbev1TanaUiIfO1JzD3Di5+HoBOz1XIvxpDY7Tjtm40qf3uc/2EVEbZQik@vger.kernel.org
X-Gm-Message-State: AOJu0Yx+TeofbfLhRZwE4nBhL+/cPWhRmkyTDuYyedi9SOfnAslIcbfv
	ANYRcpeBBt6JyGx6fwMdpmgc3UPD9XSnWKA8x599uadbcwtVOC/Yzz1SVCzemGX8VHi6bL9eDFf
	Fy+zeGqDM3erIzHC0ibqgne2/LyI=
X-Gm-Gg: ASbGncvgTv9kvh3JPRRffoSvqmk6AF45Y49yIYCcvwRrORB1Ed8b+1sU/DeI00mlpaj
	wJUltIavGP5D4AR/x2Ujk5UMOQCuAeBjIKisFrVVRSdQ/JI3F2Zym+v5SGlrIB3MdkLDUHJMJBj
	9glxRWAKbPRw==
X-Google-Smtp-Source: AGHT+IHJ6JyE2OP7a6OtC0Dftnxkf2oOPfTsXgGG6YaJAXL6ZXgHC9MMSBipkVIRmXQRU5RSL+9XvXY/4Rj+DU85MBI=
X-Received: by 2002:a05:6512:b94:b0:542:7217:361a with SMTP id
 2adb3069b0e04-5439c22c3bemr2154552e87.10.1737228799599; Sat, 18 Jan 2025
 11:33:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250118123528.3342182-1-buaajxlj@163.com>
In-Reply-To: <20250118123528.3342182-1-buaajxlj@163.com>
From: Steve French <smfrench@gmail.com>
Date: Sat, 18 Jan 2025 13:33:07 -0600
X-Gm-Features: AbW1kvYHBHgsZWI7BzBH9WuuK9Af-17TbFKMiC9niwz7OStv8ibFhtcy--ryEUQ
Message-ID: <CAH2r5muQG67z3MEh2gp_Ww=yv1AAZxHORydR9x0ABCeufUjfWQ@mail.gmail.com>
Subject: Re: [PATCH v2] smb: client: correctly handle ErrorContextData as a
 flexible array
To: Liang Jie <buaajxlj@163.com>
Cc: sfrench@samba.org, tom@talpey.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, fanggeng@lixiang.com, 
	yangchen11@lixiang.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Liang Jie <liangjie@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

updated patch in for-next now


On Sat, Jan 18, 2025 at 6:37=E2=80=AFAM Liang Jie <buaajxlj@163.com> wrote:
>
> From: Liang Jie <liangjie@lixiang.com>
>
> The `smb2_symlink_err_rsp` structure was previously defined with
> `ErrorContextData` as a single `__u8` byte. However, the `ErrorContextDat=
a`
> field is intended to be a variable-length array based on `ErrorDataLength=
`.
> This mismatch leads to incorrect pointer arithmetic and potential memory
> access issues when processing error contexts.
>
> Updates the `ErrorContextData` field to be a flexible array
> (`__u8 ErrorContextData[]`). Additionally, it modifies the corresponding
> casts in the `symlink_data()` function to properly handle the flexible
> array, ensuring correct memory calculations and data handling.
>
> These changes improve the robustness of SMB2 symlink error processing.
>
> Signed-off-by: Liang Jie <liangjie@lixiang.com>
> Suggested-by: Tom Talpey <tom@talpey.com>
> ---
>
> Changes in v2:
> - Add the __counted_by_le attribute to reference the ErrorDataLength prot=
ocol field.
> - Link to v1: https://lore.kernel.org/all/20250116072948.682402-1-buaajxl=
j@163.com/
>
>  fs/smb/client/smb2file.c | 4 ++--
>  fs/smb/client/smb2pdu.h  | 2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/smb2file.c b/fs/smb/client/smb2file.c
> index e836bc2193dd..9ec44eab8dbc 100644
> --- a/fs/smb/client/smb2file.c
> +++ b/fs/smb/client/smb2file.c
> @@ -42,14 +42,14 @@ static struct smb2_symlink_err_rsp *symlink_data(cons=
t struct kvec *iov)
>                 end =3D (struct smb2_error_context_rsp *)((u8 *)err + iov=
->iov_len);
>                 do {
>                         if (le32_to_cpu(p->ErrorId) =3D=3D SMB2_ERROR_ID_=
DEFAULT) {
> -                               sym =3D (struct smb2_symlink_err_rsp *)&p=
->ErrorContextData;
> +                               sym =3D (struct smb2_symlink_err_rsp *)p-=
>ErrorContextData;
>                                 break;
>                         }
>                         cifs_dbg(FYI, "%s: skipping unhandled error conte=
xt: 0x%x\n",
>                                  __func__, le32_to_cpu(p->ErrorId));
>
>                         len =3D ALIGN(le32_to_cpu(p->ErrorDataLength), 8)=
;
> -                       p =3D (struct smb2_error_context_rsp *)((u8 *)&p-=
>ErrorContextData + len);
> +                       p =3D (struct smb2_error_context_rsp *)(p->ErrorC=
ontextData + len);
>                 } while (p < end);
>         } else if (le32_to_cpu(err->ByteCount) >=3D sizeof(*sym) &&
>                    iov->iov_len >=3D SMB2_SYMLINK_STRUCT_SIZE) {
> diff --git a/fs/smb/client/smb2pdu.h b/fs/smb/client/smb2pdu.h
> index 076d9e83e1a0..3c09a58dfd07 100644
> --- a/fs/smb/client/smb2pdu.h
> +++ b/fs/smb/client/smb2pdu.h
> @@ -79,7 +79,7 @@ struct smb2_symlink_err_rsp {
>  struct smb2_error_context_rsp {
>         __le32 ErrorDataLength;
>         __le32 ErrorId;
> -       __u8  ErrorContextData; /* ErrorDataLength long array */
> +       __u8  ErrorContextData[] __counted_by_le(ErrorDataLength);
>  } __packed;
>
>  /* ErrorId values */
> --
> 2.25.1
>
>


--
Thanks,

Steve
