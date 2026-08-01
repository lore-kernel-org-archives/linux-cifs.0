Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68AE357CE8
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 02:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785550255; cv=none; b=tzyzcBIbFSMONaqPZF6cli/NpnYUP+tkUO1AboIiNe/leXZqqDe4nj5iHUVOPKGkcnBB/j9DXCMKsr4UmIXPYCVaYWpBxUwxBJxDGAvYMTd3n/Ob96uy0GQwxBMF/SJjNDzw8Pxh9vqf9Pb3QG6qhHWGwebJcmZRXmRGLRgBLyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785550255; c=relaxed/simple;
	bh=fcNceUDRIPMoi0XfaH7iKUDoF7iCf7n3wgtaxAI5WOY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1rAH44X+ptRCTG1hxp2CuYdtE2CJ+3lJJ7b6bk93TXZnws3tGFQAEF4wOjXRkA5ZWr6Q3TqcRuyBvU2YLsu2+Q/g+Cx1cRau2S4JdSYEy8oqaBq4EgMmjjMGef/DyyCbC427S/oVsXaQU4N0F+DAqHmDp5rzKWci638yFnEFag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtTAfJOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtTAfJOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571611F00ACF
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 02:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785550254;
	bh=JE7jSqSeMQQTlwoqlei7xCzxWeHuKOf7RPocJHchT6g=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=DtTAfJOjdqKQmGa/bAAra4LG6kJMnVLTQxZYeXzVtmuqz81EiO/HZ/V43uf9cUp/I
	 dH7sHUAYz2qUAhNFxcZ10cMuZwbuKnm2U7Sf4mr0F7A9UbNvt82B6rKvpSbSaJPXaK
	 MiGBs3qYUxY4oQFyj/qlSMYhZNY6lGo8NBaji9IuURlQ0rvcZjQFHfMDARliDK70DP
	 h9X1Xld2Vvhrc0+ITOj25E6prDjjGU+ArYcVK2uX9qVaBlPZPAE0EOY85uxtx1fHnH
	 SiCMpZDJF+/apGGS0F3qoOSoReEU/j/M/ymhNJ8wiOemtuO7ukauvSab0bLwy9oW9w
	 zY2kzgkOh7f4A==
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1671ec8692so204502266b.0
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 19:10:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpO2RiijFA8dcS556+V/JDLfVR8sZlUqAceVQxs7me7cyiZxlQqHQC5mLjXSV+IcSfC9AB6Q2i9a4Xl@vger.kernel.org
X-Gm-Message-State: AOJu0YxrOzkGt+6Fa0xKKfcswZGM4FJZGV1uYWXRQ3m49g2h0UHKXmdG
	0G+Aud0h72quhYleaYHbugwcahVi7K4KIEX69fh72iZgXpm9NUDETXTaH0vFCZG/hi7KInjwKhw
	ryNEm44f7KF0wHjxFfdYjQcJjyYtZoDA=
X-Received: by 2002:a17:906:fe46:b0:c15:f6b6:18f4 with SMTP id
 a640c23a62f3a-c1fe80c7aaamr112571266b.24.1785550252971; Fri, 31 Jul 2026
 19:10:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731115008.111211-1-zhang.guodong@linux.dev>
In-Reply-To: <20260731115008.111211-1-zhang.guodong@linux.dev>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 1 Aug 2026 11:10:39 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_pYNPxB4L5=9bckRzVrYYEEFrgVHn-8As4yM0NX9JCuw@mail.gmail.com>
X-Gm-Features: AUfX_myDSY2_vOs9IXtsT4dnqyCYitq7foGeMr0k6KGJgLPr1zIC_1ZWetnhus0
Message-ID: <CAKYAXd_pYNPxB4L5=9bckRzVrYYEEFrgVHn-8As4yM0NX9JCuw@mail.gmail.com>
Subject: Re: [PATCH 0/6] ksmbd: fix some bugs
To: ZhangGuoDong <zhang.guodong@linux.dev>
Cc: smfrench@gmail.com, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	senozhatsky@chromium.org, dhowells@redhat.com, metze@samba.org, 
	linux-cifs@vger.kernel.org, ZhangGuoDong <zhangguodong@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 31, 2026 at 8:56=E2=80=AFPM ZhangGuoDong <zhang.guodong@linux.d=
ev> wrote:
>
> From: ZhangGuoDong <zhangguodong@kylinos.cn>
>
> ZhangGuoDong (6):
>   smb/server: fix null-ptr-deref in ksmbd_ipc_tree_connect_request()
>   smb/server: fix memory leak in ksmbd_vfs_set_durable_owner()
>   smb/server: fix invalid pointer dereference in
>     ksmbd_stop_durable_scavenger()
>   smb/server: abort initialization when proc setup fails
>   smb/server: call ksmbd_proc_cleanup() on module init failure
>   smb/server: preserve error status in smb2_handle_negotiate()
Applied them to #ksmbd-for-next-next.
Thanks!
