Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122141D54F7
	for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 09:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750412662; cv=none; b=irE8bT3REwNVqpjURMamO19eQliK4BlUpDXbUkZXvvJmAi3iWSAQLMm8Ru7UyPbGa5crYFY/oxr1zmYYmfMP4v1rMVjsZHeSAEQbvEQ6xec9Tv7D0yL6NpxNZzYiFectaigxSyd7+5YgWNXXiXGXvqel9rZyQa/dmzVKL5Q/PhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750412662; c=relaxed/simple;
	bh=UC6bvqEe99vw42+lQe4lJG9sfbhTYibFLmLfW/ugj4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JinrxBO6Od9tJMGhBqKfhv/6Qisyl3AQssKNE+dCLnmH2Rtm7SwQ/5zvTlWy+Ri0MfmnjurN5ETJKKM0OZhCy562+1JXa5d7cbEaIbdatnM97z4FH9Mhlwhpgej1QYhwjTYBE3nFenx4QUF3jspwgrtexACKYlUuXsjOtGhI+wU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=evX5F/D3; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="evX5F/D3"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6099d89a19cso3556501a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 20 Jun 2025 02:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750412659; x=1751017459; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BvBR7TTsUl7FUM5/LZW9FWhNcr7fDwKfEJm+FBxJabg=;
        b=evX5F/D3lqKSEY/mNx+Ek8UkSczYl0twXTCWP2vtcqUQhaPTmz/uvXtcmJTjzc5qbQ
         Q/TkQOaX9Y5ZDoFZT1xwdv0DWl2F2gge+pQmqvDsDmxnY2HtrJW/8QUpY241515/d6Vi
         /xdwDfu2Zf1jdSCuDNDR0LERb1SCAj8/8B97e1DrpVVUhJP/KK/CRhXW0JJcOafe+Loj
         4DupZ+gFu8yMJKFu5CGD4nHlgmSbxY7iWGkrOy7hjLXn+Sj1DZuDPns67kDJ7kENh4+H
         Pjdk/GledgHYq3FBDNvghs2U+BMcajypyjJ73eqzvTHqGevpOYWBMtBCTgkX+2uesr4r
         mnXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750412659; x=1751017459;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BvBR7TTsUl7FUM5/LZW9FWhNcr7fDwKfEJm+FBxJabg=;
        b=KYgPif+B6K9opVaYsVzcST3x8JEPR7cuwwWF9F9+jVSebyvHoMWuOuPgVdYf//EWUk
         9xd3ovT4mAP92O+Qc4uo25iHVbyvWPe1x+aQM0Rwt9XcGxEk8muLKJCADFrHqHG0ECxn
         7954+f6IX7LvbFr9nyOo+A2PzQvIUFx9qGGIQ483sEbXToyr0Bz10KdweHwgy4UsRpzA
         P5aDhs08dh8pgoWhicmw8tERw6vMwD6L+fK1WtVEZJeM/pfMmQ/Kk6l26qmGR3vqRNGG
         2B9NYhAJLI3VWUF4ErTOBsriEMjczyNxKdpx4cpe38iq32HEmzcWVMuaaLQQW3gVptT2
         iJzg==
X-Gm-Message-State: AOJu0YyCJBpFmqEcWWhS2YdY4yU5qmqdjHhD0GM4P1+ANjnuzB/Oq/S6
	Apcdu86c5WNdy5fcrVYV3zZx7Wv+VOvQ8ug3zVqyUNZiB/Q42f8dir4nEbvA+5rNN2Ocmm4NKEP
	VDULyBlKWfTO13yF7q0iZEAPNUy6cStM=
X-Gm-Gg: ASbGnctFvzm5bxSI28t3BwztqomcuQiDWPuETxJnHHYi4A7q9SyE2qlYwqW3N8yLqE6
	iOPGQCQtrKxivg50xkoIQlANHnFN1uXTTyscYgQGVapn9h8cV09FzLRR/p5A9ufS3hguHDKUay5
	56ZL3cidxGmZncdYBdSN++Bin4dbuoEZ0SPqOJbAivIQ==
X-Google-Smtp-Source: AGHT+IGAgVuUKCz49yUcUKmqMHnrHjCMPVCk5RqjF+GwFMphUUjxPTv4BdRsDrZKJLv747C/BjgvotvcGr3X2PuZA3I=
X-Received: by 2002:a05:6402:270e:b0:5fd:1c90:e5cd with SMTP id
 4fb4d7f45d1cf-60a1d1675f3mr1743022a12.20.1750412659271; Fri, 20 Jun 2025
 02:44:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250619153538.1600500-1-bharathsm@microsoft.com> <20250619153538.1600500-3-bharathsm@microsoft.com>
In-Reply-To: <20250619153538.1600500-3-bharathsm@microsoft.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 20 Jun 2025 15:14:06 +0530
X-Gm-Features: Ac12FXzv8KK4-DhHL6dgxFIR1DlH1oM3adzHBGiyfkH7Lq3hbpwl4Co-lVuOcSY
Message-ID: <CANT5p=pn0EcWkON7tHq+pf09PCH6-4hNT5Gyz3PyH0oSQ557-A@mail.gmail.com>
Subject: Re: [PATCH 3/7] smb: minor fix to use SMB2_NTLMV2_SESSKEY_SIZE for
 auth_key size
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 19, 2025 at 9:09=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.com=
> wrote:
>
> Replaced hardcoded value 16 with SMB2_NTLMV2_SESSKEY_SIZE
> in the auth_key definition and memcpy call.
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifs_ioctl.h | 2 +-
>  fs/smb/client/ioctl.c      | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifs_ioctl.h b/fs/smb/client/cifs_ioctl.h
> index 26327442e383..b51ce64fcccf 100644
> --- a/fs/smb/client/cifs_ioctl.h
> +++ b/fs/smb/client/cifs_ioctl.h
> @@ -61,7 +61,7 @@ struct smb_query_info {
>  struct smb3_key_debug_info {
>         __u64   Suid;
>         __u16   cipher_type;
> -       __u8    auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */
> +       __u8    auth_key[SMB2_NTLMV2_SESSKEY_SIZE];
>         __u8    smb3encryptionkey[SMB3_SIGN_KEY_SIZE];
>         __u8    smb3decryptionkey[SMB3_SIGN_KEY_SIZE];
>  } __packed;
> diff --git a/fs/smb/client/ioctl.c b/fs/smb/client/ioctl.c
> index 56439da4f119..0a9935ce05a5 100644
> --- a/fs/smb/client/ioctl.c
> +++ b/fs/smb/client/ioctl.c
> @@ -506,7 +506,7 @@ long cifs_ioctl(struct file *filep, unsigned int comm=
and, unsigned long arg)
>                                 le16_to_cpu(tcon->ses->server->cipher_typ=
e);
>                         pkey_inf.Suid =3D tcon->ses->Suid;
>                         memcpy(pkey_inf.auth_key, tcon->ses->auth_key.res=
ponse,
> -                                       16 /* SMB2_NTLMV2_SESSKEY_SIZE */=
);
> +                                 SMB2_NTLMV2_SESSKEY_SIZE);
>                         memcpy(pkey_inf.smb3decryptionkey,
>                               tcon->ses->smb3decryptionkey, SMB3_SIGN_KEY=
_SIZE);
>                         memcpy(pkey_inf.smb3encryptionkey,
> --
> 2.43.0
>
>
Looks good to me.

--=20
Regards,
Shyam
