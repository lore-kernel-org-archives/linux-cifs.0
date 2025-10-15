Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D98313E3D
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 07:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760514810; cv=none; b=ZRHxeMHi58518klwsng7A5gqFujxaKy2L2cv4Sv9A6wlUjAI5lWhMPRVGLfFnuu7Ymq2nR2xZVj0SD9hZcl6/lR3nhAUe4GhUR1qxX+aLJWT4ul7Re1MwP8dsaB399usdbpyQ+IEIaU/0O9H0bSwAfZ90xGELx1vYKyqR5wXC2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760514810; c=relaxed/simple;
	bh=azwoYIU21g8hvjiPTs1jDcO9sJJI+XdPoiKYDabe2no=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V2+iwkFZouKHhqqxtt+uekXhwgu7wbA4+O8i3jk0XuhFywCoyNClkElg0tu2ArWXH4hSjlBlCwDPnoqqRl+6V/kr/eqinvNKzKyUNQIBU+P7dQ3PUGzbH+0UD+oxaR76eyPKjkefG2iOrbnGPeIJpB2/6E/foMpZlWfPnWRLNyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FLmuDTt6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FLmuDTt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A43C4CEF8
	for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 07:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760514810;
	bh=azwoYIU21g8hvjiPTs1jDcO9sJJI+XdPoiKYDabe2no=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FLmuDTt6eanTGhxnWOTbuD17u4OnaYMVqWi4rCO+qD04cdj4NDaMbh18dndI2IHPE
	 h3aOoG+OauRPLkrrlZWi7a5Wp/GiqBTZP7KWhYk6bULWtnOPMgdav6v6FcstA5YUgW
	 /w4C22ZkAVxa/RiDI29rhOJ9IHARAVinnW2KO7S6rVkpyjgQZaDx7ZUGh68T2UEyvZ
	 SQOYfyBmmC4sUDlUvmBB3I8Ho/S6d2P1a1tQxmyEStngAimkNsXlhmNIJUWaIZNRzE
	 p9gOSkt2TwoQqhfX+WEnsUK/AwL1pmTXP1Y39QpSjNsD8JVoP4v69eibPa3oEoB+q2
	 7K+4gJmBl3p/A==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b3e9d633b78so159563266b.1
        for <linux-cifs@vger.kernel.org>; Wed, 15 Oct 2025 00:53:30 -0700 (PDT)
X-Gm-Message-State: AOJu0Yyd2HMXUfiwQTSIxaxEGW0R5dOIvxXaa1N4nt3c4v9Isf9PfHk8
	kxjElZYkbd3AaX3nzYPProLGXzP+808Tmk+25AezZp1cnRy1tTYxFHbR/NUl6fAoi/Z6tjJMH+s
	WBUOSwo7abW3Wglzj6VNKp3d9cham3Tw=
X-Google-Smtp-Source: AGHT+IFBDgVpe8hpyBWF8SdbGTukNA7w4E+tjEK9VI1/yiHYo7nIFYZBgJIez1wuKao7o5IkmORZ845JLXN9LTLWP1k=
X-Received: by 2002:a17:907:6e86:b0:b04:48b5:6ea5 with SMTP id
 a640c23a62f3a-b50bedbed81mr997435066b.17.1760514808657; Wed, 15 Oct 2025
 00:53:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251015072546.3941890-1-mmakassikis@freebox.fr>
In-Reply-To: <20251015072546.3941890-1-mmakassikis@freebox.fr>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 15 Oct 2025 16:53:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9keP-3G7RTTXWn8E9uU2ij1napBZDXasSBFJHLzVgEug@mail.gmail.com>
X-Gm-Features: AS18NWDDTLE9bdZ2E9I908mC9P0gV87dW_ZtX4OAl5nrNIqMiugfKbP_NuS4v-g
Message-ID: <CAKYAXd9keP-3G7RTTXWn8E9uU2ij1napBZDXasSBFJHLzVgEug@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix recursive locking in RPC handle list access
To: Marios Makassikis <mmakassikis@freebox.fr>
Cc: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 15, 2025 at 4:36=E2=80=AFPM Marios Makassikis
<mmakassikis@freebox.fr> wrote:
>
> Since commit 305853cce3794 ("ksmbd: Fix race condition in RPC handle list
> access"), ksmbd_session_rpc_method() attempts to lock sess->rpc_lock.
>
> This causes hung connections / tasks when a client attempts to open
> a named pipe. Using Samba's rpcclient tool:
>
>  $ rpcclient //192.168.1.254 -U user%password
>  $ rpcclient $> srvinfo
>  <connection hung here>
>
> Kernel side:
>   "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messag=
e.
>   task:kworker/0:0 state:D stack:0 pid:5021 tgid:5021 ppid:2 flags:0x0020=
0000
>   Workqueue: ksmbd-io handle_ksmbd_work
>   Call trace:
>   __schedule from schedule+0x3c/0x58
>   schedule from schedule_preempt_disabled+0xc/0x10
>   schedule_preempt_disabled from rwsem_down_read_slowpath+0x1b0/0x1d8
>   rwsem_down_read_slowpath from down_read+0x28/0x30
>   down_read from ksmbd_session_rpc_method+0x18/0x3c
>   ksmbd_session_rpc_method from ksmbd_rpc_open+0x34/0x68
>   ksmbd_rpc_open from ksmbd_session_rpc_open+0x194/0x228
>   ksmbd_session_rpc_open from create_smb2_pipe+0x8c/0x2c8
>   create_smb2_pipe from smb2_open+0x10c/0x27ac
>   smb2_open from handle_ksmbd_work+0x238/0x3dc
>   handle_ksmbd_work from process_scheduled_works+0x160/0x25c
>   process_scheduled_works from worker_thread+0x16c/0x1e8
>   worker_thread from kthread+0xa8/0xb8
>   kthread from ret_from_fork+0x14/0x38
>   Exception stack(0x8529ffb0 to 0x8529fff8)
>
> The task deadlocks because the lock is already held:
>   ksmbd_session_rpc_open
>     down_write(&sess->rpc_lock)
>     ksmbd_rpc_open
>       ksmbd_session_rpc_method
>         down_read(&sess->rpc_lock)   <-- deadlock
>
> Adjust ksmbd_session_rpc_method() callers to take the lock when necessary=
.
>
> Signed-off-by: Marios Makassikis <mmakassikis@freebox.fr>
> Fixes: 305853cce3794 ("ksmbd: Fix race condition in RPC handle list acces=
s")
Applied it to #ksmbd-for-next-next.
Thanks!
