Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3CE3203B6
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785466150; cv=none; b=I4v6WnH9HS2B2NJhMUcbD/c1BhUJAvcQFsNXGhNqRDP7QEIj9LzMPoqnRdV7eNM9fGH5Rhc1GoQw4+oDvgHHpJbSYnTsCY+QplfUG1R1IyNva0pxVpVUrAM7hiMt8S2llLcAaLc8zXWO01YE7DDYTm/rfbCZAvikdJbrIdoYnvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785466150; c=relaxed/simple;
	bh=KK/hJrQcZSuF9t1dAhn8FkaPGv6S4RzGFcnZbRKjDlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bCSbxHN1ttSUINh2UFJbvVxcifWhabEYCFFJkFV6KqldELwi3G6IF225E0Q6Mrp+x6THrNhpzCgU3pUtn85w/Vo9DKSLeDIhtQruquSQZ2vHw3NVJ86xbtb+Sf7EYSaeOcHopjhSZ+9ONg3o0AJidihIixEYh3fooH8akfl2opY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g3ajHOOG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g3ajHOOG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84C7A1F00ADB
	for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 02:49:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785466149;
	bh=WwFTxVopmz6n65eo4+T7UQNvidfMo8W+Tsb89DMB0sA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=g3ajHOOGfzp7enQ0xCYIW42OoWaLlhuV21b9xF4hGiwEUlif8A8FaWmNKSBlUBUmL
	 WqYfOFj5PMpGyXb1lKGdB8+dAfoRFpg6TpRQ1Z/jVlDeDfWQNQtpydl3lyPh1DBXzj
	 z980jgJoIvWzg0XxG03Lo1MkekQGzHeE5m6iRFWTDtIcGq8qLqp/HravFgRGW5gDYr
	 OvF0hwztWh2rpwzMCgkE0ghFFbcu/7jtYW1MqBFSyQBShKfkS7AF7cZi/9UtE6XmWD
	 oI27g28e5mvDsVrY57/5rbzThVsnqduvY3D0rtrzz0P6i9TgsII9NabESyKu6UqX+9
	 FNcmhmnfJfUiA==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c160420289bso58249466b.0
        for <linux-cifs@vger.kernel.org>; Thu, 30 Jul 2026 19:49:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RprrpK36GUStsl4Sxy+AcGCWSeFbJuI2w/VGo8WKjMhX/rcBIcfRzuQWCcTJUleXbELr2yG0lT3bUny@vger.kernel.org
X-Gm-Message-State: AOJu0YyB/8xrGjeCw/32RaStMri6OVQJEEmGA5DW+c6NV85ITwEC0qg0
	m+DnPykSTOs8OnH1tyT/++v1oSVuJZmKNId68Uzk6Qyjb3gRC/TMxNDHi0s7mWmiR6DwwYGJTbD
	e2cQP+AdnLjZmQ6naCAqILtopf/4MH5g=
X-Received: by 2002:a17:906:9f92:b0:c15:e8c8:340 with SMTP id
 a640c23a62f3a-c1fd1ed56d5mr12651366b.23.1785466148067; Thu, 30 Jul 2026
 19:49:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731024253.148107-1-zhang.guodong@linux.dev>
In-Reply-To: <20260731024253.148107-1-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 31 Jul 2026 11:48:56 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9rR521h5goFmVOS4Z7Kh4LZJQXw3XTCxf1U9xnKeHUEw@mail.gmail.com>
X-Gm-Features: AUfX_mw0PP-CMKoRIgqxhf7q3uDZHfSAZr3K_gWeoPaEBRkGt_Z3GAd1tFx8Fgw
Message-ID: <CAKYAXd9rR521h5goFmVOS4Z7Kh4LZJQXw3XTCxf1U9xnKeHUEw@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb/server: fix memory leak bugs
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 11:43=E2=80=AFAM ZhangGuoDong <zhang.guodong@linux.=
dev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> ZhangGuoDong (2):
>   smb/server: fix memory leak in ksmbd_krb5_authenticate()
>   smb/server: fix memory leak in ksmbd_login_user()
Enzo previously sent the same patch, and it is currently applied to
ksmbd-for-next-next.

https://github.com/smfrench/smb3-kernel/commit/151d00564ce5b643ed8e9e9343bd=
21f1073386eb

Thanks.
>
>  fs/smb/server/auth.c             | 1 +
>  fs/smb/server/mgmt/user_config.c | 1 +
>  2 files changed, 2 insertions(+)
>
> --
> 2.43.0
>
