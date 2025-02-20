Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA27524F;
	Thu, 20 Feb 2025 05:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740029671; cv=none; b=PHLMkAOIsYyg+roNh3Uxu8pDmupmXdr4eBktyDuGWpY1wKILTuB8w3f0RFbtCKu7lf2dKbqzqy9GBix9jd9XFuUHhXxzO1lfOf8njPWHquwfmwK3HjnZrxaJNLfyC3StCgOpB4ZnfYKRYZ4tQECf4DuAsXjfH8oLpTA0PVgKGT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740029671; c=relaxed/simple;
	bh=vO9VhWBceqZUbWpTaPCfh9EXzP9g8r5m1pPySwRzzxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rAXsvH6uV+KNySqc0jQRru8BCki5w5e7AoV4dWvvwp9Jytibx/bXiccc5PwBYp82U6qM9/LMcpPr/sf6XCp6nx5L+GgN031Cm0uF1vRF9U36iAEL1DKRJFjEat3al9o22jjuOkbpodutgj+/RfIcZUk6KRCvrcex3hErfTaYxUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TpqOWeyt; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TpqOWeyt"
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-54298ec925bso994462e87.3;
        Wed, 19 Feb 2025 21:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740029668; x=1740634468; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nxHO5xks8df2tnW/6a5XWxo3H0le3C1ZTdsmsLIpQ+c=;
        b=TpqOWeytQgI5TQ0Z3ZPlnh7CZNrQQhvGM66dTyOLneT6QPJgN1sgLE8HmMRGmNVBzB
         CpvbN38NgeezEJOF/OJ+QxFDNy4Be6pBR2gWJtDgWeCIuxkC1g8w/zLLZ3t4Gce/mC/l
         t2K+IvQXYNLxkGVxbGPR+I+sikcN67rlHHMwCf2it9Z03StVUbhFU4lo/utBJfvETCwi
         XIx5RBRsFjdqM1pSg1jZDHyvDcwF3O22XKyTZ4EJmhMkEHs9yKzsONZEV2sklBOsKkoq
         bzTrpoaWlUVZ0qCZA67zBju7wdvlwH0GYhFNn6k2uBV9NOtNUo9s3LVh20cjH3tshQ9W
         aFnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740029668; x=1740634468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nxHO5xks8df2tnW/6a5XWxo3H0le3C1ZTdsmsLIpQ+c=;
        b=CLVL6rFTTC8K+u+eqb99NLlwY9VuHgJ8G5KQBNwJSF5/7BoMalvR8VZtdeN5KUfZJI
         4wy+Puh3CudPyAtIIihcUhLYj/2WljbYGHUbXQ8VhBHGKSvi14lR55LiWQdt5BVWAcRl
         KtHT3Z8h8Ov1aVcBeXSb5lXr5BJYHdCX7GQA5tvPewNwhCvheoEbpyxShe6kMzlu5e6I
         xQwK/ahIiX77gr1Gg7+SsgPIkhn+TzmwLPr/9/Wk2WgVMsUKd5HUGrOuAQ64Otf+113O
         ZDgwThEWxoOxGnaEh9fqN1FXg9J0xBfGbzARmqXZysOH5o4YqEOL9g147UPD6JL5HdUA
         MRSg==
X-Forwarded-Encrypted: i=1; AJvYcCUaXEzqoaGQF2UupHpvtRtQK1hUkEw6nj0xTsph6y9e0X0OyABVayY2bW/E1YK/dDL0iouc6VhU@vger.kernel.org, AJvYcCUuEOciXBngMM/y7IZMsJ/cJpJhJE2WOXhSZzl/6hx60O83MB+omhX9RoA5sfmcIO0G0WNVSKsoAL3l@vger.kernel.org, AJvYcCW3OkVqQUtaUCxCa95AsMehSJbGjc9z6fXQyJ0110rGEtLnZOV15pKHuoCkGtJuADXVIeoeGCC5JRGVbmCi@vger.kernel.org
X-Gm-Message-State: AOJu0YySB/mjwQFqpp+jp6wPjhcBorRi9nCX86lKbIOS2m0BMi1psTZh
	ZFROkVCu3CB1inSz8+85sSd7jyWYEFweTHJ69rKytPyD0XCiiP2J9kFvyJtlb/wWNpeGLtdVIT3
	+3z63Are3+NYi9bkK1LhVcPMheDI=
X-Gm-Gg: ASbGncutE8F/Xke/uALo/ymFa0xRQ1sN6WUZOune5DF2tCvOZYsz3CyT3kXBHX6+vVh
	neZb/RrgyDMejjLAtS+i9Gtwg0hg+5HvxlCEJSNPoYhWKrkvP1fuyBQQNV+TIcsJEOQ/3EQ==
X-Google-Smtp-Source: AGHT+IGcwv22gm4Mb8LSCO0ab7eCHF5tc0t/ohjExzT5CdWz31S37WwgbeeCiWbF1KwTW1ILNSfNLynudHkKGUbUWr0=
X-Received: by 2002:a05:6512:2353:b0:544:ead:e1d6 with SMTP id
 2adb3069b0e04-5462ef1989fmr2398730e87.38.1740029667698; Wed, 19 Feb 2025
 21:34:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250217072038.2311858-1-haoxiang_li2024@163.com>
In-Reply-To: <20250217072038.2311858-1-haoxiang_li2024@163.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 19 Feb 2025 23:34:13 -0600
X-Gm-Features: AWEUYZkFuWr5xR08Vj1lDihLjqWdTIC-eMaZC12VdwrjG3APe4AqM6C5ntJ07xE
Message-ID: <CAH2r5mt=oHJRjB6Mo_fE46yB-bkXgc2J-cq-eWv1OKPo3z5z3g@mail.gmail.com>
Subject: Re: [PATCH] smb: client: Add check for next_buffer in receive_encrypted_standard()
To: Haoxiang Li <haoxiang_li2024@163.com>
Cc: sfrench@samba.org, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review and testing

On Mon, Feb 17, 2025 at 1:22=E2=80=AFAM Haoxiang Li <haoxiang_li2024@163.co=
m> wrote:
>
> Add check for the return value of cifs_buf_get() and cifs_small_buf_get()
> in receive_encrypted_standard() to prevent null pointer dereference.
>
> Fixes: eec04ea11969 ("smb: client: fix OOB in receive_encrypted_standard(=
)")
> Cc: stable@vger.kernel.org
> Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
> ---
>  fs/smb/client/smb2ops.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index ec36bed54b0b..2ca8fe196051 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4964,6 +4964,10 @@ receive_encrypted_standard(struct TCP_Server_Info =
*server,
>                         next_buffer =3D (char *)cifs_buf_get();
>                 else
>                         next_buffer =3D (char *)cifs_small_buf_get();
> +               if (!next_buffer) {
> +                       cifs_server_dbg(VFS, "No memory for (large) SMB r=
esponse\n");
> +                       return -1;
> +               }
>                 memcpy(next_buffer, buf + next_cmd, pdu_length - next_cmd=
);
>         }
>
> --
> 2.25.1
>
>


--=20
Thanks,

Steve
