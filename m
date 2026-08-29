Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746441EB19B
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 10:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787999512; cv=none; b=DemsShhRkVFcE1VKb7dH4dx5Xz0/Cnvt4N8OPapZdYEP0mvDKbHcXcuQyUhdpL+CXfjn9lg9m23obo3D7B7EVUwKVcyH9pBWn0Rp5pw0mAoHq3m5kkNhG9DaFEHbMVo9Bv2298XQjP0WWMzdY14lj+8wyhJ/qU2aF5pzgBkBIMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787999512; c=relaxed/simple;
	bh=bdhJhwQUyuzngEeBuvBjcBOU2y3uXnwYXFoSjv/f3mg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MBCdgue1yaSZCZ1oaYfbk2giTuTT+q51SBBFMrqqHj/831Nz0Npze957RCkwnNnloEUjgqczwE9WFRSlhqffzH971FioCPC7YzoQGfNSyStKH/ihkPgJ06g3MjhYCrPrMgqIXh2OGHeD6IZKadxwFcxbXUN3K7/RvViw5JCJhmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GX0Sk0Ok; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GX0Sk0Ok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146C41F000E9
	for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 10:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787999511;
	bh=vUwYv8w2zMFsqmc2boY6alyX2OhsE6T2eG6lZjMYx3Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GX0Sk0Ok5KC4fAFRZM/FZr4IcIo7LwiQ8avRIGzmMjALZOPU+O99ioFh30U+IMbo9
	 4qb2Gz0aXaXrLKTDBUaUd+DVTEvUVyEuZKVbngnXpBdZhTsip7Ux/cXiaaI0zXeLCz
	 SNd3P3ckm2OAmu6gj8H0cdruL9TFWMc63r4vUhkgx3p9k7yoExC4HRx6VJi29jJshv
	 +yuEcxt7UWagsg36FqSetqFI7QnROLUyp3obGR9jOtG4quFGYRu1Gi4nncQVpF7Bnt
	 0SkorUpyD2fUFi71GuThpa9pndb14Xk1Wd9bepSZiIeCbpcD1Wl9bIFilmH+AuIMB+
	 t97qyEWBOs+Bg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c2544ff970dso284850766b.2
        for <linux-cifs@vger.kernel.org>; Sat, 29 Aug 2026 03:31:51 -0700 (PDT)
X-Gm-Message-State: AFuF++nWCLq0w8VWSuKTIl5ydha4zirXdjA0ftkhlOHY5spy5hOZXqC/
	lOT8IzHYZArZPr6DCgwk/BmMOhxihAZNxkRrm4Ee31yfGKpOCZinV3IUfCNghnOWI/ImR+DKwof
	uAePi9MFMYhV76YkNWQKiO/wD+DsoqX8=
X-Received: by 2002:a17:907:c19:b0:c12:9b93:61fd with SMTP id
 a640c23a62f3a-c2556c2bea8mr880673366b.6.1787999509726; Sat, 29 Aug 2026
 03:31:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260826153147.4112943-1-sorenson@redhat.com> <20260826153147.4112943-3-sorenson@redhat.com>
In-Reply-To: <20260826153147.4112943-3-sorenson@redhat.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 29 Aug 2026 19:31:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_1jw417=uA-1apBR4SQfkGCJX9Amj-uJuxfPhaqdJzeQ@mail.gmail.com>
X-Gm-Features: AcwNN1VKHfpwcdxggcJn0N3BQKjTkomzYHE_zBMebPuMhQMyGJOkwcy3UPeYXw8
Message-ID: <CAKYAXd_1jw417=uA-1apBR4SQfkGCJX9Amj-uJuxfPhaqdJzeQ@mail.gmail.com>
Subject: Re: [PATCH v3 02/11] smb: client: validate PDU length before
 smb2_get_data_area_len() struct access
To: Frank Sorenson <sorenson@redhat.com>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.org
Content-Type: text/plain; charset="UTF-8"

> +/* Enforce: smb2_min_pdu_len[x] != 0 for every x where has_smb2_data_area[x]. */
> +static void __maybe_unused smb2_check_min_pdu_len_table(void)
> +{
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_NEGOTIATE_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_SESSION_SETUP_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CREATE_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_READ_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_IOCTL_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_DIRECTORY_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_CHANGE_NOTIFY_HE]);
> +       BUILD_BUG_ON(!smb2_min_pdu_len[SMB2_QUERY_INFO_HE]);
> +}
> +
I don't understand why this helper is necessary, and I don't prefer it.
