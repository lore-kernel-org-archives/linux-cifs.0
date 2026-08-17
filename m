Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFDF279DCC
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 06:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786949361; cv=none; b=hJBDUIAhB6oVC06HuIJoIKVCu3QzsJO3vXFU2yleIdBhreXR0PwdXOXP/s0W7q9VUZS9T9NUtnFiVtfDocmC0cNDqyBNvN7QQal3xqaHw4wu/bjFm5AnJ9leXQNHcK4vmIuz0GlKFNFtxVB7CTwGp/CCzeQ/7JUO3Jf3Z3XdWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786949361; c=relaxed/simple;
	bh=SLbdsADBHnWyy5Ygd5HqTvX6OubJJW6DZwb9f0A9ttY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hraElROXhzpyrrChN8NtnuNHT9v9kX5WNmiDHSHaZEE228eXSElMQNwGXSp+up/PG+yZw29XetuqdiuANlSpvb8NMdIJQmCiI2qG6wL8KcIKOCNzQqnBbU6FlY6UzBl2dZWIaZAthVcxndG6GDjNBTKdsfWd6dGXBmGj++gPaAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnDh7uVc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnDh7uVc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666E61F000E9
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 06:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786949360;
	bh=SLbdsADBHnWyy5Ygd5HqTvX6OubJJW6DZwb9f0A9ttY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=mnDh7uVcdiZM9Awg6hn/bZAE3VmE2efHISl62dPjD7S998fqrjWNnMYvDyc7sz1YT
	 eYBPFOdUu6ov1t2Efct+QZfyWim8eNkPkGiMHyiutl3XD1Oph2pme64O2yUJlEB7EU
	 2E6IXp7eXfrYPpVjDib6hr6OTgoc8uQZFoNBiOcqG8gHM/DoCSMfbdeoZRO/H0Ngr1
	 LY51dmU2dZx8DYbg8xtXtiXyZJ8/h5JiBegK2DeJ9Y7VL1rfXgFCo1EDuDVgMkVe/l
	 FHxwpXREXqKEjrSlGTJ0kz+3m/JltnrYIs1E0P4NpFh0LS1RzqMy/2X5JdcM27eUJT
	 +HPvQS/JiN2dA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1f758014b8so297784866b.3
        for <linux-cifs@vger.kernel.org>; Sun, 16 Aug 2026 23:49:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqG+wNrITGWy5qKNJs6QtQPm7nLimC5HhyL6xKER3Maf02iZVS238jvPK59sekLriwvU+qclRVKtGbx@vger.kernel.org
X-Gm-Message-State: AOJu0YyQvh9r3UtRimnoHplJRTzEFoW7ixjmvCXSrrlZ2B7ycKW/h2b5
	7g7hGuBwJerTH5l/Hidxp9RRmJH9RHx6csiCDVJEu3HxvK/f+amWs8ETVVd3DST104yCzlN0nJW
	1rh2BaYVsIfxJVwIE7fOnxKQHlJRACMs=
X-Received: by 2002:a17:906:6a1c:b0:c20:7457:5383 with SMTP id
 a640c23a62f3a-c21291f3e79mr905045366b.0.1786949359070; Sun, 16 Aug 2026
 23:49:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807085806.725742-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260807085806.725742-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Mon, 17 Aug 2026 15:49:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_L2RQS6yGhT1a_pQEaSTjPnJ5iV1Jv_WyA+OzWBiZgVw@mail.gmail.com>
X-Gm-Features: AcwNN1U_RK16B7p569_N764s74_ux1oxTcvM-ke14eNUnKBE4RMwgFi7AEMwFGU
Message-ID: <CAKYAXd_L2RQS6yGhT1a_pQEaSTjPnJ5iV1Jv_WyA+OzWBiZgVw@mail.gmail.com>
Subject: Re: [PATCH] smb/client: return EOPNOTSUPP for unsupported O_TMPFILE
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, tom@talpey.com, 
	senozhatsky@chromium.org, slow@samba.org, mikhail@mstefan99.com, 
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 7, 2026 at 5:59=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> From: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> Some SMB servers return STATUS_OBJECT_NAME_NOT_FOUND or
> STATUS_DELETE_PENDING when creating an O_TMPFILE.
> The SMB client maps them to ENOENT.
>
> The ENOENT error is supposed to be returned when the path
> (a target directory in this case) does not exist, while a
> lack of support of O_TMPFILE by the target file system should
> be indicated by EOPNOTSUPP.
>
> Reported-by: Mikhail Stefantsev <mikhail@mstefan99.com>
> Fixes: 3e7d63037a2b ("smb: client: add support for O_TMPFILE")
> Closes: https://lore.kernel.org/linux-cifs/75fb5359-b268-492d-8d4a-504d1a=
f60f2a@app.fastmail.com/
> Signed-off-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
Applied it to #for-next with Paulo's acked-by tag.
Thanks!
