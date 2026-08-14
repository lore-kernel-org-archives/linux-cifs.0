Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8DF2F7F07
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 06:40:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786689650; cv=none; b=O9AsFHbgxjonQ4ONWJRHI3TvBVW2tj81WVqBET5VXBTYZywUizRrhOEPF7BkdHZxJpwymvrIkzd8Hh1p3IosDfjU0t0FARE3FL2uSpP1foLwHMcKB6lo7D6KtiKrtmMfcp3wmgr0Aj7HUKgXvjmUVGaptTbGVqvgExuaxQnPzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786689650; c=relaxed/simple;
	bh=QWQM94T817SlWwl6/q3hBnT5L0J3kbv8/nOD1edqEJ8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bm1bJ4gdesCu2Kk8BOJB2VO+nJsgGGGUR3PhyMGi0xtcfyZ+pfrZwJyfqgpY+alTCxWJbVTlspBLHd5a4BSAvb+vUL/nqREVJOfnG62sogeyPjoXkQdbaod0yPQBZfRTKah6Uqv4C69YqUKn7THgT+1XTm+OCy+bRiwruLEWJBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IG6ZkN97; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IG6ZkN97"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C331C1F00A3A
	for <linux-cifs@vger.kernel.org>; Fri, 14 Aug 2026 06:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786689649;
	bh=QWQM94T817SlWwl6/q3hBnT5L0J3kbv8/nOD1edqEJ8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IG6ZkN97hyctmVkBlneXRbf9whA6pYKHF14+A7Oi9Ang4pewjxrbe9UA6ON8qc95j
	 Bm9QVxOklw/hzAMCdnzASqFjE4SqJmvB59YMlQKpKy9Y9KusahFSfuT4jufdQN/tef
	 HnlbUHkkuAC1UX2z1xrwNstdC7QkGhufUz60inAUYjIYHohqjpxGVwNRmQ6xKSpAdQ
	 0GSwGvxnFGfkrbSIw3A3HUk7SS8YQZNXgsJp58usVuRA0X4LzVFC02oqodv5tjPrsT
	 Rx1T+RE5W/NnWZjKUWkTTXuO8/RxJzDd+RwCbXVel5uSKHDvJRHPNYRKwvuumQLnHe
	 kWuPl+UJDmYtg==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2020421077so122630466b.3
        for <linux-cifs@vger.kernel.org>; Thu, 13 Aug 2026 23:40:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqsrDeEKlzfDFSvNXD5J1VVk5jVcUtTWceFBmG1fJQ1S/b3iATcTy10CLt9aiBoDvIvgOjQZfMWzAKm@vger.kernel.org
X-Gm-Message-State: AOJu0YwAePcF6TLgmo3G6YWEk5pOys9Yc5wJeGvPVfM3fq0tnxquOWXq
	8A7iNjzT8bgfGfa7z8PQEOn38qcvXrlNjgR/Ysy0N0JgJSGZBkIXFVHI8rciXs1Ne+jnU2T20td
	0RB+axDAtuL3OM1i7GrMo/IL5ALrTiks=
X-Received: by 2002:a17:907:c10:b0:c20:899:b8bc with SMTP id
 a640c23a62f3a-c2129ac0d66mr169520666b.6.1786689648450; Thu, 13 Aug 2026
 23:40:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1786674373.git.tanze@kylinos.cn> <82181632662a23ecc9a3b8b2321982071037a288.1786674373.git.tanze@kylinos.cn>
 <CAKYAXd9-mkdArzM573FPUo0cS8ZuuY21OgMMQ5d9kLOknzy26w@mail.gmail.com> <d7cb5234-fd5c-49cf-82ab-590b5a1e902c@chenxiaosong.com>
In-Reply-To: <d7cb5234-fd5c-49cf-82ab-590b5a1e902c@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 14 Aug 2026 15:40:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_tBUao9wk-hkayPpNxVPbJzPRTDRVH4PvmSUu_UxL=Ew@mail.gmail.com>
X-Gm-Features: AUfX_mwE5LZuA86IzNKJfLC9RONkVk-BSV_FgkAqUS19tFFyyUjsGLKyt4NSiR0
Message-ID: <CAKYAXd_tBUao9wk-hkayPpNxVPbJzPRTDRVH4PvmSUu_UxL=Ew@mail.gmail.com>
Subject: Re: [PATCH 3/3] smb/server: check create_proc_shares() failure
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Ze Tan <tanze@kylinos.cn>, sfrench@samba.org, senozhatsky@chromium.org, 
	constant.lee@samsung.com, tom@talpey.comm, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 14, 2026 at 3:27=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> These two procfs monitoring entries are indeed optional, if their
> creation fails, we should at least print an error message with `pr_err()`=
.
>
> However, initialization does not happen frequently, would it be better
> to make sure all features are available when initialization completes?
I think it would be sufficient to just print error message using pr_warn().

>
> On 8/14/26 13:44, Namjae Jeon wrote:
> > Do you think we should abort ksmbd
> > initialization when create_proc_sessions() or create_proc_shares()
> > fail ?
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
