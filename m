Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF7919006B
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 00:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764894953; cv=none; b=s95ilFTHGT/118CNnE01L6JqLCogk4uxemJqSCdJaxjIZg6U49imKD7x5QOlC9hETi8ZVcgZL1Mtt4YgaNxpF5EEiv+TBQ1A8GO3APrqBAT1kLcge0EmhtWZJMcxbhMEjVJrN6MbD6DTAtGEKVcoQVy4HOssTqd0u2Fq5+/64GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764894953; c=relaxed/simple;
	bh=gCLzFIcI64mCMrZmUgmJKZfeCWwV31mFTHy5qOng3b0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TO01SoiqtaCDtmgQFCp885ZRLuY0NZCdOJDPsIYVmaF9/Vj/9hfJr7onCkhFuLwD7sxqClo4nV5Wla3hT+mmp8Ea/vxGS4DqmN+dggD1tj1eMzRaOoL1QM1ahRXg4J2O9l4TmeEk+ejFA3yRKLLicO1IaOHT2gmvwlG7a857S9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nf2rBgBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nf2rBgBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B167C116D0
	for <linux-cifs@vger.kernel.org>; Fri,  5 Dec 2025 00:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764894952;
	bh=gCLzFIcI64mCMrZmUgmJKZfeCWwV31mFTHy5qOng3b0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nf2rBgBbkvpRFqaUPy8R4JFmS4z2fxv3fR9abpt6EdW2kAD7lrcuYO7phRjrOgUDP
	 Qwp1pBgmU/mG/d0CrEIbYosjIlGnPZCUgUvEqZSspl8jHET3Nhmt+Jb+/dHzMiPObJ
	 Gs+2Dybhmw+BsQv/Tx/rrCc9i0vVJqQwzPagIsmm/19gi4Gyh8BfrgkgoGCGWDEET3
	 pyODCmjhwGD3cCvNPlq0nEZVUYLU2CU7N/5aAk8XKj9dO7vE5hmFh73F/r8iYNmScw
	 UtGkA7Zg7xxclw+8fTLxliak2Nqj7kmVPj3EBr+L7eRCyS/yVTpaszIVMzuyZIMaHF
	 yPkHfASUvXAWg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-641677916b5so2493148a12.0
        for <linux-cifs@vger.kernel.org>; Thu, 04 Dec 2025 16:35:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUCRQzEOhhDxxyw2GbZxlqiLpO2PeJ9Al2grEle9TbcGY0foqNrPHguuuj4dhFZNa7bqhHFUR82LGrX@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Edz6h7D3ezTlNb2cGDNQE0aE3nkLkgAw9je0IdikLVSijJ4n
	nmGvvg4YltjrImxaoTcP0+2HBbYhox79UifZR4Y+q1sq+dMRjEnV6S6SHtnUTVkQ5nW7mBm9SHu
	L+z413qjsFpAO2cKOAuMAYdnv2sxAW9A=
X-Google-Smtp-Source: AGHT+IEMmn1Rnghg7NqXiH8sCsg/zCfF5GbarsWjdNAPQGdobXgUX4+M9Ce+IsGl2Oa3L+8vaYyGQeK9LvNQ9p6t7Ck=
X-Received: by 2002:a17:907:1c21:b0:b72:7dbd:3bf with SMTP id
 a640c23a62f3a-b79dc731365mr789921266b.43.1764894951127; Thu, 04 Dec 2025
 16:35:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251204045818.2590727-1-chenxiaosong.chenxiaosong@linux.dev> <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
In-Reply-To: <20251204045818.2590727-10-chenxiaosong.chenxiaosong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 5 Dec 2025 09:35:38 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
X-Gm-Features: AQt7F2qsrytQSFn-yRrMsWjoWyH09H4q5nZV8Gnj4jiHcCeiiBhl9GcRWMYwtcY
Message-ID: <CAKYAXd_-ctfkz1E_Sqh0bJMarUE8rDrd2o7yKKa_cOFGPaYELg@mail.gmail.com>
Subject: Re: [PATCH 09/10] smb: create common/common.h and common/common.c
To: chenxiaosong.chenxiaosong@linux.dev
Cc: sfrench@samba.org, smfrench@gmail.com, linkinjeon@samba.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	chenxiaosong@chenxiaosong.com, ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 4, 2025 at 2:00=E2=80=AFPM <chenxiaosong.chenxiaosong@linux.dev=
> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Preparation for moving client/smb2maperror.c to common/.
>
> We can put cifs_md4 and smb2maperror into a single smb_common.ko,
> instead of creating two separate .ko (cifs_md4.ko and smb2maperror.ko).
Sorry, I prefer not to create new *.ko for only smb2maperror.
>
>   - rename md4.h -> common.h, and update include guard
>   - create common.c, and move module info from cifs_md4.c into common.c
ksmbd does not use md4 in smb/common, I don't prefer this either.
I would appreciate it if you could send me the patch set again except these=
.
>
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
