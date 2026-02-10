Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B7B3352952
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 14:32:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770733945; cv=none; b=TmOiCp61Wf94P4NdxL9T6xhrEc1l/BM4QmZfbwvJqVlbaLJBDyKhEEgtFDP+E68Ysil5AdqqH/2tWjcOz7Ep0A6/rK51MDefZIkMUgbfT2ngJEXgDi5NAd602lmmACxVJS5HlKpsTIYb9BpDdsGf4vVE42n1PnxAM4Ve5pN711o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770733945; c=relaxed/simple;
	bh=kYUyiaPa4UAfZ3ouN77De2EsXkZL5WJyfJl+VvpJNYM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M6kfxkhNvonl+2SNmiIhPOoDR22gqcEWpRUaloP/grEGBApvvQSckigscJzzj4FqWkoc4A9cCpDUrOjhAjmwSR8XmKy/2qXGGjGAg3T4l9dAa4dKPxnYCm/UxLbNayfIsub5J3V56Xoe9C2MyrZUAx7WwrD+dqPNVMpCFSt5Agw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sH88PgQg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sH88PgQg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFE6C2BC87
	for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 14:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770733944;
	bh=kYUyiaPa4UAfZ3ouN77De2EsXkZL5WJyfJl+VvpJNYM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sH88PgQgzIRiR3rMkxodtoERCEeE2ftynfo5jo1/OHVi8pMbDIqw8kRCMb25sJ0c1
	 SUeSJd2LQ0wBZzHWRP8IY89slQO0ImyBsTZASKInFLGQ/OV4kiz8cFsIRNc0jWTEXm
	 PLcH90YJaSUBUn/eSnApJaqoousnDbbiKTXcPyzgNisN4J5cRN4ghjeuIAjXERtA5V
	 YLsU8X6MG2UAesmXersYTkBMahsVbJKHNlhsCptXizl4DHKhIAYBG/dM2SyZGY6WUH
	 F1G7AMc18rvAk611SlyOhTIyDxTwuFJA1iXTvPIjNtGZNWtVX9NaJKWCZpFX6pD51K
	 gLuGID9Pak3Qg==
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64b7318f1b0so5353936a12.2
        for <linux-cifs@vger.kernel.org>; Tue, 10 Feb 2026 06:32:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUQqr/I+m+2+ZzkN4qRUSXvGFZ4RoUDHlnKPpZfuWz/Y3oUQ7H1rjIJHBrWBD0MqCN5mjmb0xKHHFij@vger.kernel.org
X-Gm-Message-State: AOJu0YwgofSbC0Yvk9jmFOfDvICpAHvOn+N8urrilnKGka9qwv4olZ5u
	Irxn+cW1yONhpXRWtZzPLYtVP+ux5npOokTcDZjCEKBpnf0WTw+yfKacCKc+bTxQpU7EU862K/f
	wyq+/5qQ5qEhR+d+0rKSJ21Aqx3j8blI=
X-Received: by 2002:a05:6402:f17:b0:658:eca:1fa5 with SMTP id
 4fb4d7f45d1cf-65984182b99mr5664384a12.20.1770733943335; Tue, 10 Feb 2026
 06:32:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260210141219.1573869-1-arnd@kernel.org>
In-Reply-To: <20260210141219.1573869-1-arnd@kernel.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 10 Feb 2026 23:32:11 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9wt09Fwf7OKWUd1b677fybBTqiNhipoGtYVwjbGez-aQ@mail.gmail.com>
X-Gm-Features: AZwV_QgboDljQWaFfEBgJNAu5nCRhJdmsdYGprJKjq5fzvQ4UIbY3JCJvs-1AYc
Message-ID: <CAKYAXd9wt09Fwf7OKWUd1b677fybBTqiNhipoGtYVwjbGez-aQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix non-IPv6 build
To: Arnd Bergmann <arnd@kernel.org>
Cc: Steve French <smfrench@gmail.com>, Sang-Soo Lee <constant.lee@samsung.com>, 
	Bahubali B Gumaji <bahubali.bg@samsung.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Arnd Bergmann <arnd@arndb.de>, Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Stefan Metzmacher <metze@samba.org>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 10, 2026 at 11:12=E2=80=AFPM Arnd Bergmann <arnd@kernel.org> wr=
ote:
>
> From: Arnd Bergmann <arnd@arndb.de>
>
> The newly added procfs code fails to build when CONFIG_IPv6 is disabled:
>
> fs/smb/server/connection.c: In function 'proc_show_clients':
> fs/smb/server/connection.c:47:58: error: 'struct ksmbd_conn' has no membe=
r named 'inet6_addr'; did you mean 'inet_addr'?
>    47 |                         seq_printf(m, "%-20pI6c", &conn->inet6_ad=
dr);
>       |                                                          ^~~~~~~~=
~~
>       |                                                          inet_add=
r
> make[7]: *** [scripts/Makefile.build:279: fs/smb/server/connection.o] Err=
or 1
> fs/smb/server/mgmt/user_session.c: In function 'show_proc_sessions':
> fs/smb/server/mgmt/user_session.c:215:65: error: 'struct ksmbd_conn' has =
no member named 'inet6_addr'; did you mean 'inet_addr'?
>   215 |                         seq_printf(m, " %-40pI6c", &chan->conn->i=
net6_addr);
>       |                                                                 ^=
~~~~~~~~~
>       |                                                                 i=
net_addr
>
> Rearrange the condition to allow adding a simple preprocessor conditional=
.
>
> Fixes: b38f99c1217a ("ksmbd: add procfs interface for runtime monitoring =
and statistics")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Applied it to #ksmbd-for-next-next.
Thanks!
