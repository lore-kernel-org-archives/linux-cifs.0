Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449F317D346
	for <linux-cifs@vger.kernel.org>; Sun, 16 Feb 2025 23:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739748035; cv=none; b=M+WjnvUf8VDI5Tvm1TWgVqk4YBb90NoYG1W+XZ6wLeI9YU97lGCTty6Kr4YE0ZpfCna9mpwWasKuVy2xAksxWPb8FfpFgLS4XghCh1cSnez7WkpdvUmudeK8EM+tdK2hGyRCD+eXnGVEktcS5nM6a62s3iTlPf6Ua5weklYoXgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739748035; c=relaxed/simple;
	bh=RYGN+Rhhe0gO448j0ARsVw3Q4B+E6Su5xVmtP4/kskY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bQ9QboNHBp3dPTOeaJYEp7ZGJ7vJB0Mfkt5MrrHmarT7Y8ITdotI+V3AaxqxVWAuKbCqqisAkuXyMJ+FRLL50hCBmiuusSb9dsOAsDKdhWZnHJ9OpaBhVp6ok0drOEYZPUgpFmve9DSgXU9Gn+sWAM8BdAnDf/+1jeufdlDH3e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BMvf4VLA; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BMvf4VLA"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5453153782aso1281337e87.2
        for <linux-cifs@vger.kernel.org>; Sun, 16 Feb 2025 15:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739748031; x=1740352831; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uxt/MQdknJ3AT+Yw0Jzh3Tk33id5ktrgblf0ENA9iPA=;
        b=BMvf4VLANoG9Zwa8K1fkhXT362GQ3jpLRcYdygVQOBHpkXOdKucKO37L5ecWdnCrAz
         GM9I7/CP4gQFL0F3xNAp7YpIIinUCGTqn5FpLTyAK13TzPxFnx8x0xJ18CYfS2YlqHNA
         4c2+/HhLmD+3W+blPdnBCfv1j1m4bHHOepd4GR8Mss0AELFUTSK+uROFFLouqGkHB54I
         nV4Qg1fMls5lk6Mqgx7YCuu/HG/cuvigL6vQo1u4UtAq7PXcqBVJbncTtsivjgBmt7ix
         6ine8uV6G7DKNJ8yfwsMjgRkHpfB+Wceco1uLG4D19xBxWzi6H8T7wgbqR88coC/8GMU
         OOcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739748031; x=1740352831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uxt/MQdknJ3AT+Yw0Jzh3Tk33id5ktrgblf0ENA9iPA=;
        b=TKvYRv5u7rjCrBneKs3ft25EKoMFOeC7HS8dI4l0NSGe1i0WU0idRCc4dDiNW0fI+0
         1L4ve/iDdsVEkRvrOYNKzt5kQuNOw6fsU/tEkkwqYcnstbg/88dM26uhxHWtwl/hQF8V
         9XVPjc0zidjeoIprIy4eJ0nmCTSMXhCpg9fMfvOVx94ggIUcnSbXwAGqg48S2FIip/po
         a4MPyKpov08WXoHO71lsABt2ZzG25cDaJXRCjSBuD48S4FbP7J3nHiaLaORAYZahM57Z
         gpUkr5oWWtLyro9OpODkNgA0a2UMHx4xqJda5JukyByTmO1/NNXGuBJBAcmRKsvw0Wj3
         CYBQ==
X-Gm-Message-State: AOJu0Yy3clfs24hUI0d3oThzBkYEAfdbe9gN+sgrpgE71+zCKzoJpFA6
	nFNOFPRdJDok8M91ankfhdq5TyjSza646DSc+eAmSkrPVxvrdCkSDwHSE26yk/z9MfaR07tueHr
	prZqMvNC/zixsFhbtsxXWJ8gwovD3Ow==
X-Gm-Gg: ASbGncvupU58G1/cLQ2ZJ/60qK+yEWC7TazmA6IZ8cTsv2CZTmM9EsfurUSD5zBxwtj
	84MXz/Q19X4uOIu/rQwyRXBsg8cGX3aQhvN07kaEwh9/qCPICMZS8TIy3VmjpVOfWBz8YOj43a6
	kh2PR4p5q6fq0qCevCoaEYn+R+j+yAD0g=
X-Google-Smtp-Source: AGHT+IEWnrL4mZXcaNzujXT/n3nkRbqprJqjsW80CZsAZpbXOw6yl0Z/YzLTGPgywVqkTlytUED56ZwvXqfzPoFxID4=
X-Received: by 2002:a05:6512:ad2:b0:545:c33:40a7 with SMTP id
 2adb3069b0e04-5452fe63611mr1290732e87.26.1739748031072; Sun, 16 Feb 2025
 15:20:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250216210247.190316-1-pc@manguebit.com>
In-Reply-To: <20250216210247.190316-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 16 Feb 2025 17:20:19 -0600
X-Gm-Features: AWEUYZlIykmCqOSli1-i7Uiqt0S1KXdo9dCVFjJTA76y8WtZTfp0-ajqArC58yo
Message-ID: <CAH2r5muykjcBKmL-9sEurzzzOCBn3C9_ZAXbEFk=-FZjseDVXg@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod(2) regression with ATTR_READONLY
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, Horst Reiterer <horst.reiterer@fabasoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged into cifs-2.6.git for-next pending more testing and revi=
ew

On Sun, Feb 16, 2025 at 3:02=E2=80=AFPM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> When the user sets a file or directory as read-only (e.g. ~S_IWUGO),
> the client will set the ATTR_READONLY attribute by sending an
> SMB2_SET_INFO request to the server in cifs_setattr_{,nounix}(), but
> cifsInodeInfo::cifsAttrs will be left unchanged as the client will
> only update the new file attributes in the next call to
> {smb311_posix,cifs}_get_inode_info() with the new metadata filled in
> @data parameter.
>
> Commit a18280e7fdea ("smb: cilent: set reparse mount points as
> automounts") mistakenly removed the @data NULL check when calling
> is_inode_cache_good(), which broke the above case as the new
> ATTR_READONLY attribute would end up not being updated on files with a
> read lease.
>
> Fix this by updating the inode whenever we have cached metadata in
> @data parameter.
>
> Reported-by: Horst Reiterer <horst.reiterer@fabasoft.com>
> Closes: https://lore.kernel.org/r/85a16504e09147a195ac0aac1c801280@fabaso=
ft.com
> Fixes: a18280e7fdea ("smb: cilent: set reparse mount points as automounts=
")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/inode.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/inode.c b/fs/smb/client/inode.c
> index 214240612549..616149c7f0a5 100644
> --- a/fs/smb/client/inode.c
> +++ b/fs/smb/client/inode.c
> @@ -1421,7 +1421,7 @@ int cifs_get_inode_info(struct inode **inode,
>         struct cifs_fattr fattr =3D {};
>         int rc;
>
> -       if (is_inode_cache_good(*inode)) {
> +       if (!data && is_inode_cache_good(*inode)) {
>                 cifs_dbg(FYI, "No need to revalidate cached inode sizes\n=
");
>                 return 0;
>         }
> @@ -1520,7 +1520,7 @@ int smb311_posix_get_inode_info(struct inode **inod=
e,
>         struct cifs_fattr fattr =3D {};
>         int rc;
>
> -       if (is_inode_cache_good(*inode)) {
> +       if (!data && is_inode_cache_good(*inode)) {
>                 cifs_dbg(FYI, "No need to revalidate cached inode sizes\n=
");
>                 return 0;
>         }
> --
> 2.48.1
>


--=20
Thanks,

Steve
