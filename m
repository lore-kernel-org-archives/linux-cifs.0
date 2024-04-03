Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 971C21494C9
	for <linux-cifs@vger.kernel.org>; Wed,  3 Apr 2024 14:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712156341; cv=none; b=ceMnu/Hmyle0n5Q5ChEyDR0PkDRdUMptJ1C1CACV6Ce4EVrsemqL1Ayn6KwNFYPrzanWdKqeZRYjOtw7EvXJrCWBwMRecIM5FyQlmoKaXvFV+szEHNeCGkOcW6WeG4nES+FblcSpBgB2uVKa13tW2HG7Nk3C27UgG0rOV14XBlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712156341; c=relaxed/simple;
	bh=bA08xc5rb3BdVwkyNJ3oXMMCv+codCJF7wxqAsTEmbM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uSZgbpjNS+wPODYr6giATIPf9y4jajKAd5OZ3DGWB5jwcd8MQzWJqJiWvWYxyhU6eqjCOE1kPkwoe2GNXXXS4VEWyHoSsTM+2RloUollD3fSVmWa5EMC9pqAePiHfcXQY/GcR/aPigzkM+vYNhWhvnLD7Zy8s6PBjrZPq1FqHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=NTgGLUkm; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="NTgGLUkm"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6151d79db7bso23143457b3.1
        for <linux-cifs@vger.kernel.org>; Wed, 03 Apr 2024 07:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1712156338; x=1712761138; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6ozn8GWGaymICONfaql8z8aBGhL/vcq5PD2xm3yHTg=;
        b=NTgGLUkmp+mD862RxBHk1Uizuyvzo0bnE4KI+UdiJDaO1+vrbFUwPNSgGT5lOL/wvP
         aV2EW/WE46eGtubOBk10gQJ1m6nm0aCoQ+Btrc3bxvCS7WZr/kqsZ5CB0WcRqmvfLtoY
         8vv0D/2HFC4qr4kvXmD4aQ0qyeVEwSOQ49Kzhul3jd6F6yiz/SkGzSzPGPgkkMivA5M8
         GVYzVGzczxBfUBzjE5b83d5qJAlaVgSppSzmkzmmj9z1KWZLjI/fe9+trzKkns8IN4zt
         1foAqoJrbFc3e5+yVtOpEjVHAahVO2I3I3qJupKJGELRWPvqt9YbaEngxNgG3Co/W3W+
         0mfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712156338; x=1712761138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N6ozn8GWGaymICONfaql8z8aBGhL/vcq5PD2xm3yHTg=;
        b=MWBmwHsYBZN6v37A8j3UO6aTelmlHCYDODTxSemZXMR88MGkJ+XulnQ0GLL85wYgTv
         diks5HOcGd64FT9DiMJJg+YFY08Vxcp4aAvKZ4eHJ3zLCxoVozxWuXPFI1/5wOqirhSu
         laApY6q3jJ3gLW1tWQXf7SuQ004liTQnrRVJl82Qgw2SwqYO4D6az9cWKpg/M8AEO+7N
         PGcDLl1h+V7YFsPqf7Vpiv33G9OZiFFcyhYw/iKLHhfql1kOe7Ps3SPeIw2cAI+7HDqr
         tWKSzLZA8W1c8WdqbnEXNkgTaTKB6uLXrs9DW1O6WS/imb1E4oFrv7hdNVmgWrYi6YVz
         FkiA==
X-Forwarded-Encrypted: i=1; AJvYcCXzsBqLHEMocOouzN1SIfXMasqrF/94EaNWpspIDkBBB/Rgyowpb7NfF4zgj1VtcxwLRSLdszelGylQXVBhTqcT1N4kBMeGHF5evA==
X-Gm-Message-State: AOJu0Yzzp/gN0GkbWtjp5RO3ygZtjBZPh/CjOUlfzSvuhvcDc8r5r6ao
	J/Q8NlAdnAasoC9fBwk8fhzLwgjAckuef8YbMHdT3MCHoT46lwueimNIw+6OuYyZ/7DeR6u/fcY
	4mMl22gg8nzSweJOudN2baQaYTQNOxF9bzZM3mGxh+Y02D3g=
X-Google-Smtp-Source: AGHT+IGNgAodpsrYQT2AbEmyPbb+UGOULWYqBs8jhyUUwdxQtLywey14p1gGYRWmBh3FA7fTEozafbxC8444+PUG35M=
X-Received: by 2002:a0d:d5c1:0:b0:615:144f:1f5c with SMTP id
 x184-20020a0dd5c1000000b00615144f1f5cmr6498090ywd.47.1712156338103; Wed, 03
 Apr 2024 07:58:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403075729.2888084-1-roberto.sassu@huaweicloud.com>
In-Reply-To: <20240403075729.2888084-1-roberto.sassu@huaweicloud.com>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 3 Apr 2024 10:58:47 -0400
Message-ID: <CAHC9VhRFsvBs0ysZ1rwqaz0TvMQf9JFQTBTA1cym08nbvoTVEg@mail.gmail.com>
Subject: Re: [PATCH v3] security: Place security_path_post_mknod() where the
 original IMA call was
To: Roberto Sassu <roberto.sassu@huaweicloud.com>
Cc: viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, 
	jmorris@namei.org, serge@hallyn.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-cifs@vger.kernel.org, pc@manguebit.com, christian@brauner.io, 
	torvalds@linux-foundation.org, Roberto Sassu <roberto.sassu@huawei.com>, 
	Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 3, 2024 at 3:57=E2=80=AFAM Roberto Sassu
<roberto.sassu@huaweicloud.com> wrote:
>
> From: Roberto Sassu <roberto.sassu@huawei.com>
>
> Commit 08abce60d63f ("security: Introduce path_post_mknod hook")
> introduced security_path_post_mknod(), to replace the IMA-specific call t=
o
> ima_post_path_mknod().
>
> For symmetry with security_path_mknod(), security_path_post_mknod() was
> called after a successful mknod operation, for any file type, rather than
> only for regular files at the time there was the IMA call.
>
> However, as reported by VFS maintainers, successful mknod operation does
> not mean that the dentry always has an inode attached to it (for example,
> not for FIFOs on a SAMBA mount).
>
> If that condition happens, the kernel crashes when
> security_path_post_mknod() attempts to verify if the inode associated to
> the dentry is private.
>
> Move security_path_post_mknod() where the ima_post_path_mknod() call was,
> which is obviously correct from IMA/EVM perspective. IMA/EVM are the only
> in-kernel users, and only need to inspect regular files.
>
> Reported-by: Steve French <smfrench@gmail.com>
> Closes: https://lore.kernel.org/linux-kernel/CAH2r5msAVzxCUHHG8VKrMPUKQHm=
BpE6K9_vjhgDa1uAvwx4ppw@mail.gmail.com/
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Fixes: 08abce60d63f ("security: Introduce path_post_mknod hook")
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  fs/namei.c          | 7 ++-----
>  security/security.c | 4 ++--
>  2 files changed, 4 insertions(+), 7 deletions(-)

Acked-by: Paul Moore <paul@paul-moore.com>

--=20
paul-moore.com
