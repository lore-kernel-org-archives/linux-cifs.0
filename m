Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356091FDA92
	for <linux-cifs@vger.kernel.org>; Wed, 11 Feb 2026 14:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770821008; cv=pass; b=F5J4m1F2Z7LyRRfkuqBM/+tvxu5Dta535JbkR9Xh2XzCJJXhYfDQ4BuTSt0LYtW9hsND6hUCeO8VKGkDu2igG0Reu9XHVhKNFkFmWaiXKx5+uUZO8jS8wfY1s/4HtgNrti+83WTYOzwoL+3BZMPzNo6bsMoMt6wIDLNSw5T0GJ8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770821008; c=relaxed/simple;
	bh=W+BWDkNVdGCa058zxH3Hho16NJGkDEYDKgSXmAwxa+I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D1RwaVub5G/oHloy4kJnKtb/u5z8iwq83abiJ7QJnPlK27L5luR+p4wOJ9/+NPBF34+WIu27gv6i+X6y9VJltvBgMAxPF1muVSqtI/u4EByBOMD7PrtpssxSK4Gh8+uVxM/Ta5jmTq/4+taFejFFa1Nnq/wfrD3ICfJn5/kaPKU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Q/OasHEw; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Q/OasHEw"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c531473fdcso736261585a.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Feb 2026 06:43:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770821006; cv=none;
        d=google.com; s=arc-20240605;
        b=EdUQdBLdK4jkYCxnABrrlUVRxMNmDeNKrg/hlaJQWKmRNUAVScHq9r5q7rOk++3ICz
         TX+RCJGmmPcAHPAv9rjKoirHvjN99RdLVxj+vbhEJE6UCweI7u/5I3aAdnuVkHUjOuUw
         CfngN9jzBdBP6OPGZeh+jfc7BE8Emn0mG8AQP8+3Bq6tEzaEpSh9hEgVFlUx/1hwzjnK
         mk27IDr6DlrV5AGLycmzD1IoHTiPHk61mKCbunU9bJGQStfbjBVapaT3t8U/Esw9AFHs
         ex1P8dkESOzOXZZC/So3YT5R0CAngOtZnJ4YiyERvWJM+9hANWl9qPdZdyF7d9RbDDcV
         0L6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tYrB0YZOkicazcAAtzwQbMtJNoVmUfS7HTy6R9REB+k=;
        fh=n4mrRyiDKJky7vITGEY/YUmsmlUUNeo1p5y56JEJQwM=;
        b=M+24hQQDUPyEQOh3w+sGfshROfgVjaG/OBccJhxXLwkyL/Br9aIe/8qJjhZkHAvDEH
         6iW6NGZPHgp/4kBfiAKL6BVZ1irlRp9gX1cse9CodUK28eLMVnKzMBg3gpccDK9h0Sc7
         Tt4fOyvg7lfP8hbZqEamYEVB6ywJuoOd45/lMGkKl1kmgw7/cAS/i1PMb8jmBxQDB49i
         SXVuFo6fwRY1wi3dtUuAVWkyyUnXmXnJ8XbFwz6gqI7GJAmYxvaMrMOh8244ExsUHxEk
         g1oYDYMczmonuqmDkbQrMNkT/zhAoJMgwqVSfzVqX8/WYafmGZiyLnuiYhp+IFAgL3xu
         0H7A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770821006; x=1771425806; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYrB0YZOkicazcAAtzwQbMtJNoVmUfS7HTy6R9REB+k=;
        b=Q/OasHEwNUsj/kFWVu7MeXx/fwfnsGCymt6JDWg4eUWDzW5RJOcrnk9YKv350ZpTtk
         94ckDn1DI3wyMdcYj6W8C2YpYFydEXy2slfROHUpuIbtBWPspFhzI/N77bVsXLNTiOjL
         5kp057Icsv8IkuXnE/Q7uJuuQQOIgQx2RQqER3a1EFzD2Q8WVWWV6F2k2/cR7YTJvdEs
         mhytLR2HV6Ao3GqWnpctXQErdzYlUtvGaL0JTdbXINzFC28wqF/lvlWsRpWuTC4wiVXz
         Ry3kF13BSJnsRQZaGaMPMdfQhPtXzmKJ7QvDazh1/Mf//BBqWyv8UWEisOXjN762uiS3
         Xuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770821006; x=1771425806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tYrB0YZOkicazcAAtzwQbMtJNoVmUfS7HTy6R9REB+k=;
        b=N09UhjamqvM4GyyGrEyfNUMk+JBFOMVyhXmEI9ISlLOTg09/0U1cVzxgSpbpzFf0sc
         ZuPPgwS+hhTgl7mneyw+Iw8UxCDTyCVnShreDMIKBVI1aHLuj/zEK9hCfoOfvgQR24XA
         sa+lyKj8ba9jnD+4lytjJbeDtZz4DOLgWWzZvnevEjDDK7EvX1sSmZSEwX/lJV0wMJ0W
         lf39jnNA3vHY8922wrhx8AFhHRi/FaDh46gIj7lOi0QMDk37S+KZ6dOj6AAjftiJgRJ/
         q+1e1C96hFfJpUfPH4dqXF/78jlQRWKOpVNCCg0LkmTE0bS0IB01IlgbQ5Mefz21xTL0
         XB+A==
X-Forwarded-Encrypted: i=1; AJvYcCWPguXnYpCXEnLHPY3cLujq0dvihyzuTSNyQ5Tn9sjba4MRZ7wPu39CiN422iT3hcyMX5qoRTb7AErx@vger.kernel.org
X-Gm-Message-State: AOJu0Yxv/rTHuS1ReQagKBwFV9I3Mz6VpF80t86ocP0pQ6Qob6+uAgGr
	kQKdwSX7ksCxi2wZ+RRqS9xFM3Wex5gFxTNoa6YjJOfTEMkdH70qletEzRTWgP6H/8qv9yzZ3/u
	v8HgwYbtSE2cT39t6Ga/rbYBP+vPP9GI=
X-Gm-Gg: AZuq6aIcVr8oOUEjBIqfS1sVUktCRVldiXt9dCLeWX+w5/H/4B2cG66yphI5uLo2WPH
	VNlby9wS8Edg1wYsH25dqQAKaAuPUQ85Y//UtxwYCOzfKzzyWa8i3UiFSQGTuPF7AL4bfJ56PL6
	E7Fi1iJnQvDU41XrSxScKcAHjx1Si8nCxgnQdIzrnoWbIaSe8pfCTPzOqQAvQ26ViqQzNPjM3aE
	lYNv+VUA1ApnTdZDySfpJ1YiYKfbzuGrbxp9xapulI5ozMf0c/EwgL7Q3/fBczFb7OGCk2j2Vz9
	+fpGmHDGCplHtp7a8Vi368pMYiQCMG+w9ZvLRilA4tqmd5rvi7EK2rI6gFcIZxzet9rRnFy9HXw
	Yaho9J4NFPlGrOmscvHPAcDzrutTmlAVGwb1CtH1+U0O+Yx8p7bDBnxtk5eD178w=
X-Received: by 2002:a05:620a:191d:b0:8b0:f04c:9f0f with SMTP id
 af79cd13be357-8cb28072dd6mr348197485a.63.1770821006091; Wed, 11 Feb 2026
 06:43:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260211041007.324919-1-pc@manguebit.org>
In-Reply-To: <20260211041007.324919-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Feb 2026 08:43:14 -0600
X-Gm-Features: AZwV_QhF8Px3hPDlbTOHx0Y0nzzmwwBNQzya9t-OYErX8mNzBP6nF11cvONJriI
Message-ID: <CAH2r5mv6Nm7qDJEtNUJy-aAxE=_u503a7XAgAAVsswLd2DebGA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix regression with mount options parsing
To: Paulo Alcantara <pc@manguebit.org>
Cc: Xiaoli Feng <xifeng@redhat.com>, David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Feb 10, 2026 at 10:10=E2=80=AFPM Paulo Alcantara <pc@manguebit.org>=
 wrote:
>
> After commit 1ef15fbe6771 ("cifs: client: enforce consistent handling
> of multichannel and max_channels"), invalid mount options started to
> be ignored, allowing cifs.ko to proceed with the mount instead of
> baling out.
>
> The problem was related to smb3_handle_conflicting_options() being
> called even when an invalid parameter had been parsed, overwriting the
> return value of vfs_parse_fs_string() in
> smb3_fs_context_parse_monolithic().
>
> Fix this by calling smb3_handle_conflicting_options() only when a
> valid mount option has been passed.
>
> Reproducer:
>
> $ mount.cifs //srv/share /mnt -o ${opts}
> $ mount -o remount,foo,${opts} /mnt # must fail
>
> Fixes: 1ef15fbe6771 ("cifs: client: enforce consistent handling of multic=
hannel and max_channels")
> Reported-by: Xiaoli Feng <xifeng@redhat.com>
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/fs_context.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/fs_context.c b/fs/smb/client/fs_context.c
> index ec84204aee18..412c5b534791 100644
> --- a/fs/smb/client/fs_context.c
> +++ b/fs/smb/client/fs_context.c
> @@ -825,9 +825,7 @@ static int smb3_fs_context_parse_monolithic(struct fs=
_context *fc,
>                 if (ret < 0)
>                         break;
>         }
> -       ret =3D smb3_handle_conflicting_options(fc);
> -
> -       return ret;
> +       return ret ?: smb3_handle_conflicting_options(fc);
>  }
>
>  /*
> --
> 2.53.0
>


--=20
Thanks,

Steve
