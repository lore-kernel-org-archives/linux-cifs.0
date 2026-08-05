Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCAF42F8EAC
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785908808; cv=none; b=qpMuX/+xKxDuQGWDzwmq4aDFtfu6+6ayrmhUX3dL6minrONT9jQHkEc0BNHBop96npFIIsFz9zIEcPFX8PDXxTzbPkSduCnTlP6lzyIpatmKL2D1j1CB812s6kKSOWv/BTfyjx/FUsUcvLuXJ49ASXG2M4jdopvmZofd9nhVWAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785908808; c=relaxed/simple;
	bh=4H5VBJLQBsdTyWnyI4v47Y6W/oRgxU0JadAjl3riPMM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ipzl1811D45yJ0vuO5HjoVFVOftPiQ/N+2JQl8Lve6QuZkuoABr5oX1z6tXMDp0QsjYTUvB/boTWJciTtk9eckI/h6d55GfM7O0cmqg+9WQrmHDemoIXC0u3m6UHQfEOYpu85CtLMpm8A0YzPMfJMU69aiUhRZ13Xg9YFGTf0s4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IWFGhvm3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IWFGhvm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C011F00ADF
	for <linux-cifs@vger.kernel.org>; Wed,  5 Aug 2026 05:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785908806;
	bh=zi+usB7qYUTaCRI2QGCBmue6SZeGo+XrevhYxiVkHWs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IWFGhvm3QXyUouBZUJWGup+dtlbusQ5afe95gLGbEXHjAYHzNwmqfKyXXVJhAmTMr
	 6pZtnhRC00GkoeQWzADZ3oeQG8yLJcs0sbgw/Kz5zfHeDonoJhB7XrXZHyw1cfbjHQ
	 Rpe2EpyS0YvG9ZqHVQbddrp4FAFOUNNo5Q70GAdS5ZclD4iO65B7pi9mi4F9nnR91N
	 EIc5Xyc/KUjsG+v4m7P6z6EKcEZ6OSlGAczn9fS4eg1x4B/kkgaXrC97SoRoW32wR+
	 NXu/rhKxaonYwBRw7cMg26jg5AO9PA97msO1Mfy9T+BH/zXgM/70q432Lr5l657h5C
	 azEgb1lKoPOjw==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1f5208b38dso118244966b.0
        for <linux-cifs@vger.kernel.org>; Tue, 04 Aug 2026 22:46:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rr99rJXK/AUdSwRLTgnv2NB4APkRxvKQjbLPKJ/Ol4Cg/WD7Tg3NLmOKdzNczsJspoNKuLb8K6rW24w@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4PF7KrPz/eaTtYaKvGA/fniiRh1+H4Htl2m/LDzjPz/T5SH96
	akUUAOi+vqEZCxHvdy2MU1RbjvtdjMu6yIQgpqm+SaU2dUuHwLlkMs9DFy9sshRplH2Dv5dboyv
	ztzl6oOW7tMrZyeUj/bgfNdDfWhIC5/0=
X-Received: by 2002:a17:906:9c8c:b0:c16:3074:6593 with SMTP id
 a640c23a62f3a-c2039c9f670mr196488266b.12.1785908804907; Tue, 04 Aug 2026
 22:46:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260804123301.285434-1-chenxiaosong@chenxiaosong.com>
 <20260804123301.285434-3-chenxiaosong@chenxiaosong.com> <CAKYAXd-A2hup+WnYZj+AaVTzgZ9hHQgg8zKswtw=-VqStE6VFw@mail.gmail.com>
 <2df0ad6e-fa5c-425d-9ec1-5c668f84a4bd@chenxiaosong.com>
In-Reply-To: <2df0ad6e-fa5c-425d-9ec1-5c668f84a4bd@chenxiaosong.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 5 Aug 2026 14:46:32 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9OQKQVURduu0iRL-H8rAL4coCK79w8HZiSt3f8CpdymA@mail.gmail.com>
X-Gm-Features: AUfX_mzn_uCqi-0kIvDbqsHtKeBz1-RqbGcy1FVmi0V6gKepw4mAQv7dxAMlYmg
Message-ID: <CAKYAXd9OQKQVURduu0iRL-H8rAL4coCK79w8HZiSt3f8CpdymA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] smb/server: deny overwriting targets with
 non-POSIX opens
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	slow@samba.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 5, 2026 at 12:09=E2=80=AFPM ChenXiaoSong
<chenxiaosong@chenxiaosong.com> wrote:
>
> Hi Namjae,
>
> What do you think about iterating over `global_ft.idr` instead?
Looks ok. I will apply after running my tests tonight.
Thanks!
>
> ```
> ksmbd_has_other_nonposix_open() {
>         read_lock(&global_ft.lock);
>         idr_for_each_entry(global_ft.idr, fp, id) {
>         }
>         read_unlock(&global_ft.lock);
> }
> ```
>
> On 8/5/26 10:17, Namjae Jeon wrote:
> > The new check is limited to the target dentry's
> > ksmbd_inode->m_fp_list. Therefore, it does not cover a struct
> > ksmbd_file opened through another hardlink dentry, even though
> > file_inode(fp->filp) =3D=3D d_inode(dentry). For example, if file2.link=
 is
> > a hardlink to file2 and file2.link is opened with a non-POSIX context,
> > an overwrite rename of another file to file2 can miss that open
> > handle.
> > This appears to be an existing limitation rather than a regression
> > introduced by this patch. However, since this patch is intended to
> > reject overwrites when the target has a non-POSIX ksmbd_file...
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
