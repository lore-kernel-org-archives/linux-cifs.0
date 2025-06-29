Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6496523A9AE
	for <linux-cifs@vger.kernel.org>; Sun, 29 Jun 2025 18:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751222781; cv=none; b=irSrDT9RP19xvho9oyhu/bzZaP61xZxWXqf1RG0cCHAwmo4UokiYKSVMAAd1LMpG5oBO00zH49jKGqN+RB5A19Wb/42s1NAF5ebsfwtqwrQcHdi4Q3/soEW3RoiKg4JUeO5MBEEZzrfR9wNKvzs/axW+PQGotpxisAQZwXuz2MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751222781; c=relaxed/simple;
	bh=+CQu/cS/N57L1tSBFfMTgI16w+oJLynCVBsPCoTUhF0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imb5sEZdSs8mEmiIkdrU7C8PjvB07iwdxuXNKYYuNndkz7McBOlhpsJ7zX1eJ1vXxNaOLHC4L/uFQSsm7xkglOiN8WKYymFXBLviwXCh/fqV/6hjue0nzT7coBVXcWPdx8Oxj1bBAMprUSlE/ml0WCOA+1wP0+YtPk70ULv9HIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcNzzLwr; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcNzzLwr"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-701046cfeefso2033656d6.2
        for <linux-cifs@vger.kernel.org>; Sun, 29 Jun 2025 11:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751222778; x=1751827578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JG4hf4VtZ9dCyyi+09GYJkojzO9eOrNnBpkxJQBjZNY=;
        b=bcNzzLwr/hdS9jIBpJn+TEV+Wu1Q0i9e38P43bF3y5lce/QbjKIoXbJqKO0EsBP/hz
         quYiHTgyCoOMBePidJYvWeSjimqH8MVP+YCCoHNGS0MTiDlXW3F73lAVn+QQb4w4pHJC
         WCFVuhRTBB5B/oKKHYlZnod/FsLvWNJpxM3vK8aPUmw3pVRkFEB0tmDBRVfkUq37DkkN
         zexzpqgrcxB/b/HX+yDnecC60ZFlJIAm/g0e7ippLq72TFgrLZVjefI0pfjTKXpvvQ+m
         eqEikbYczQuoSf82wxcLl7qjr3nLn6IW+W3A9hmgn94FOZMiIJc2/x6+Xbdufj1bf6ct
         W+TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751222778; x=1751827578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JG4hf4VtZ9dCyyi+09GYJkojzO9eOrNnBpkxJQBjZNY=;
        b=fMtvBgDQOg5LMLWo8+FGdNtgAWouyLqhosE86CYZnVoaLlRTMtPxnNj/txWT1MTku8
         IBSp/NfffDzU8c7uyaWwUP9RRibu3260+wgX3rLc8q/ZxEoHemq3LLahXTZt5oY07sAm
         WVjMqGOZwWrxvaKUpgmfAIsj7AXHOCrPShbtPEZHFnKcpI4BtN5iTxs6ad3rMx3gh+k2
         tt2yzpZBennmfOrtsNUv1m9FdBn2xR/dPbonhfkR5juim5GUFx3O0R9dWoCj/uh+BVEi
         m8gJwYz47EHTBDKhjpMyB6nxZS4EFO+R08MBBFUmeCIZLjboXkrUDBPeNf6aHwnO6z8S
         qRcw==
X-Gm-Message-State: AOJu0YyhYw+pSBNgtN9cUDDw2AAqDPjqH8cXCf1Si2nMLzTCj5RVw3eK
	YON4gp9HNcmL3lMGUsdt3anO0jiProKjcXibuGG/gRMyUEz9tQkNB7QjV+gDaK3/vZaits5CBu6
	6RlgcgvynlMP569eVNktcSYoa4ASGYCDPYA==
X-Gm-Gg: ASbGncscRav5bcGozrJQ7vUR4OwzM3ZY38EF1dSnRMsuBKFmvT9cw/5q6z6HGR3qlZp
	TAKNm0pjYPsJjGA8H49l6tdigqWeVR12F4vBctp7mpQn3fq2gAnZ1i09P8xCJ51jLMQcjZk3PJ1
	15wUYX2uGhzlUoI4eOqLcaic0W/nFglxJO1b+1p9HtVQO8VeAhGj50F5CHjXc49Gomh0K+9raas
	a69CQ==
X-Google-Smtp-Source: AGHT+IFEsIy8HvvSAVyHUNxgl297RQUrjAnZGjGQ6uvScPoh/vf3Xt4UxMmjNJjik4X7sVSHMQhzL7xqiz5uKeZu7ow=
X-Received: by 2002:a05:6214:d83:b0:6fd:3a71:cf5c with SMTP id
 6a1803df08f44-70002247789mr140523336d6.24.1751222778241; Sun, 29 Jun 2025
 11:46:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250629170505.11631-1-pkerling@rx2.rx-server.de>
In-Reply-To: <20250629170505.11631-1-pkerling@rx2.rx-server.de>
From: Steve French <smfrench@gmail.com>
Date: Sun, 29 Jun 2025 13:46:06 -0500
X-Gm-Features: Ac12FXzS_NIVrxX3wkxtr14-gDEt0iiWmeQuvHlpmhXfL2ow3HSNH_qyVDp8l48
Message-ID: <CAH2r5mvzPNh41OVUub=W4=OVDNT4hGjH-kaW2BPTJk6DwP-_fg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix readdir returning wrong type with POSIX extensions
To: Philipp Kerling <pkerling@casix.org>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

good catch

Tentatively merged into cifs-2.6.git for-next and added cc:stable

On Sun, Jun 29, 2025 at 12:12=E2=80=AFPM Philipp Kerling <pkerling@casix.or=
g> wrote:
>
> When SMB 3.1.1 POSIX Extensions are negotiated, userspace applications
> using readdir() or getdents() calls without stat() on each individual fil=
e
> (such as a simple "ls" or "find") would misidentify file types and exhibi=
t
> strange behavior such as not descending into directories. The reason for
> this behavior is an oversight in the cifs_posix_to_fattr conversion
> function. Instead of extracting the entry type for cf_dtype from the
> properly converted cf_mode field, it tries to extract the type from the
> PDU. While the wire representation of the entry mode is similar in
> structure to POSIX stat(), the assignments of the entry types are
> different. Applying the S_DT macro to cf_mode instead yields the correct
> result. This is also what the equivalent function
> smb311_posix_info_to_fattr in inode.c already does for stat() etc.; which
> is why "ls -l" would give the correct file type but "ls" would not (as
> identified by the colors).
>
> Signed-off-by: Philipp Kerling <pkerling@casix.org>
> ---
>  fs/smb/client/readdir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/readdir.c b/fs/smb/client/readdir.c
> index ba0193cf9033..4e5460206397 100644
> --- a/fs/smb/client/readdir.c
> +++ b/fs/smb/client/readdir.c
> @@ -264,7 +264,7 @@ cifs_posix_to_fattr(struct cifs_fattr *fattr, struct =
smb2_posix_info *info,
>         /* The Mode field in the response can now include the file type a=
s well */
>         fattr->cf_mode =3D wire_mode_to_posix(le32_to_cpu(info->Mode),
>                                             fattr->cf_cifsattrs & ATTR_DI=
RECTORY);
> -       fattr->cf_dtype =3D S_DT(le32_to_cpu(info->Mode));
> +       fattr->cf_dtype =3D S_DT(fattr->cf_mode);
>
>         switch (fattr->cf_mode & S_IFMT) {
>         case S_IFLNK:
> --
> 2.50.0
>
>


--=20
Thanks,

Steve
