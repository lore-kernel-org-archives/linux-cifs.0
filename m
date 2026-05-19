Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950F626299
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 12:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779195343; cv=none; b=kNdQM2Q8tSE79KDTtjUtDTV97twJ8XItECK6yqbpAkHIUhl0LcnnJKVI/dpt0wYwK2G0y0qCvUeb7DmBBd2gWVzauaIxem7+KwXht+0zhOte6KqRmMXRiB3gVPU8F5Bd+JY6VhNfZ3k/Et7ds1dxlta+Rm3Inp3daimGc+tNCH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779195343; c=relaxed/simple;
	bh=E2AvTlp9HxuXkgWVbuGdDFR+ZDkJNOmgubdpCbNDqiI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aHpzkrgAhb0CDgbMS6An8HlmC8wzukq0hJF4ThMOFds1vAqe5bAZ9CZEUNw4uBeIv0DMxzo2E5y0Y8mLdbJ3BRusy3QO60/1rZ1M28WytXoGl/3FSXIetrbiyd5hSo3j60XIUU/PscOas7KzXs9pQaLgnSqfGhmxD0nbgCqPaS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CsH1hYK3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CsH1hYK3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30799C4AF09
	for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 12:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779195343;
	bh=E2AvTlp9HxuXkgWVbuGdDFR+ZDkJNOmgubdpCbNDqiI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CsH1hYK3GcPei+B6HFmjSt87vg1DUiY5XAfKwKt+PLF+bytQTKRCSPY9N52g7/BIM
	 eSkqokfHtm6uA8f65yZvZU4yvWklwFWIzG16PjneG5aIpIpkSXIfnc4mhYPgHXxFwa
	 7scPC+Cubjmai6h4X207U8lP9ujwZ0EW6zhYfWy0Xcg6TsXX79Z+RKNnYxv9KWi34n
	 JiDeFFa0TfJMFP0EtrNUE11NvLTRIJrpNEL6Yh72M8C/aKzPP/uD4cg+qrhUPoDJfF
	 pGdeJRdy85EyPt8qxeKE/SR/sqLZFfZJR9NY8zXlTN1uAlPAMZxq+IC6ifKBxoXWu6
	 q/KSfAPjHvz2Q==
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so6107174a12.1
        for <linux-cifs@vger.kernel.org>; Tue, 19 May 2026 05:55:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+cyJCLAcwWUBGguTehNOFQHaP2ewryM0hk3G3/Itt59qBETfgKUru4JTY2LL0ubI8Cv48A/O6/oQGE@vger.kernel.org
X-Gm-Message-State: AOJu0YyZwl+tLPqeJQwhEVxN4nG2O0y4WXi11ORn68POLOKPnmr40nYJ
	tCuAz+csTsLOHciG9DHQnIrsXy+2Tsk1WQTblGfLiTKRk/4QPZqS0Nabtlp5bNKb+u8IIe02can
	R75rCDM2hSqAHC1u0OCIeIzFst0t/5YE=
X-Received: by 2002:a05:6402:11d2:b0:673:b696:8823 with SMTP id
 4fb4d7f45d1cf-683bd28aadcmr10145297a12.15.1779195341760; Tue, 19 May 2026
 05:55:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260518152322.265844-1-chenxiaosong@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 19 May 2026 21:55:29 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_JEGF8X314cR3czBkcBAj-Z6yv6twYMPNFPVNB-UVbMw@mail.gmail.com>
X-Gm-Features: AVHnY4JZHgTlOrzQIqGjpa_Ix4dLJa8mXwRqdTER8tIgegr3AMghFOQ1RUB7Sdg
Message-ID: <CAKYAXd_JEGF8X314cR3czBkcBAj-Z6yv6twYMPNFPVNB-UVbMw@mail.gmail.com>
Subject: Re: [PATCH] smb/server: promote S_DEL_ON_CLS to S_DEL_PENDING when close
To: chenxiaosong@chenxiaosong.com
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	ChenXiaoSong <chenxiaosong@kylinos.cn>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"

> +       down_write(&ci->m_lock);
> +       /* Promote S_DEL_ON_CLS to S_DEL_PENDING when close */
> +       if (ci->m_flags & S_DEL_ON_CLS) {
> +               ci->m_flags &= ~S_DEL_ON_CLS;
> +               ci->m_flags |= S_DEL_PENDING;
> +       }
> +       up_write(&ci->m_lock);
> +
Why do we need to promote S_DEL_ON_CLS to S_DEL_PENDING here?
