Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC51DE2DC
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 01:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757985090; cv=none; b=Xa/KVDEXYXoWkjHhCqKUAsKSVuxbi2rLwtOXZjlWOML6yaG5voMES/PXICVl+SJ/voLGTl1+fhlTuUO2gimCVphzOF5MdxpOxaP2zdveIF+8ht1b5jqz+irKo5pjsz3OME2W93ILgCmHZxsvqJHB/O/JjhLOHI/SGJKvuxurm8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757985090; c=relaxed/simple;
	bh=pywoNX5Fj0ThFie7i1F+fNV/378eQvTd2KEdBeM7gXQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eLFWCieC0pxMIZAKy2XAEh7MYbUpRnK3JGCwvnXnwoFGXdXECRYYiIAtSnTRcCnz0bbkrNSQ5B4/HbStIfRIUieCQe5e2IN+m2pq9wpIfnZ3cfOwqMIte/W/0Z2jeDmXDYuPEOPVmIT8FHU8Gs12mHoWyVWxpM66Y3J0PGm4idw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uO2/3J0s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uO2/3J0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B86DC4CEFD
	for <linux-cifs@vger.kernel.org>; Tue, 16 Sep 2025 01:11:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757985089;
	bh=pywoNX5Fj0ThFie7i1F+fNV/378eQvTd2KEdBeM7gXQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uO2/3J0sejlTx7uljyYcFXBbeycir04KbUK3Wusg06qN5AW0kt90eJw4mZAAWZFVY
	 uf1lFJyU6PtI6cLUKvIruG2a+WwdjU1cAQYuHXO6uT3hwFcPYv+BKwmlww7eRBm7t6
	 IrSapVaiLbTgDAvL2pi3X181/dcsOMXafK5sqj9KV1Tbbg+E3x8nneyk4yerP2ub28
	 uJwgJy8w+FiwqA9bjb9XaiTne8Z8OfLKNiso2o9RP+SpyVYOBVmU0+VNl/8wiCC2CI
	 DHr6I1DS1RJf/u7ZU/+3Bbb5cbfkPv2hUvEBbhdTGQvQmNcUgHyeEo/bZcxaVOXYtP
	 Zejnj6qIZJbrw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-62f1987d44aso3540473a12.0
        for <linux-cifs@vger.kernel.org>; Mon, 15 Sep 2025 18:11:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxoRfhcUj9DfBF125LlbWMpP9ChLfS8iEa4OOeP5xFRbXtnuff7HLoTwmbsTkctegM/s8XaLpeO8YP@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn1U9p9NzE1WAsaK8PjbYUg8hDwLas/0a0TYoC+15epMQAFCc2
	W3VlD399IRERLAReCs5BqE+SmMdC0mu32aV+gcYvyjcYdmhQuWy+IccHgWRQePpwGhSJWLdCfG0
	yoP3tgMdC8bH19/y0BlUgHk8obNWId7o=
X-Google-Smtp-Source: AGHT+IHv/n1JN8GWUKal59MvrweGIKVpUCxC3bbV7i0oHx+AET14Dl7KMMRsAqGMDIFeX1Yo7dHDbI6e6oQsgP709IY=
X-Received: by 2002:a05:6402:2711:b0:62f:6713:1b22 with SMTP id
 4fb4d7f45d1cf-62f67131cdcmr207838a12.24.1757985087942; Mon, 15 Sep 2025
 18:11:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250915224408.1132493-2-ysk@kzalloc.com>
In-Reply-To: <20250915224408.1132493-2-ysk@kzalloc.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Tue, 16 Sep 2025 10:11:16 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_h9otb5kfixtwAgXfeFbmsvc5xmuoBsDNovmHFwGOEEQ@mail.gmail.com>
X-Gm-Features: AS18NWDcKPBMDX2P_tfLuiBXo4aQ7qWNaXQnQMmtVrPehIGjufNwmyIx6u-D74E
Message-ID: <CAKYAXd_h9otb5kfixtwAgXfeFbmsvc5xmuoBsDNovmHFwGOEEQ@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: Fix race condition in RPC handle list access
To: Yunseong Kim <ysk@kzalloc.com>
Cc: Steve French <smfrench@gmail.com>, Norbert Szetei <norbert@doyensec.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	Jinjie Ruan <ruanjinjie@huawei.com>, Dawei Li <set_pte_at@outlook.com>, 
	linux-cifs@vger.kernel.org, open list <linux-kernel@vger.kernel.org>, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2025 at 7:44=E2=80=AFAM Yunseong Kim <ysk@kzalloc.com> wrot=
e:
>
> The 'sess->rpc_handle_list' XArray manages RPC handles within a ksmbd
> session. Access to this list is intended to be protected by
> 'sess->rpc_lock' (an rw_semaphore). However, the locking implementation w=
as
> flawed, leading to potential race conditions.
>
> In ksmbd_session_rpc_open(), the code incorrectly acquired only a read lo=
ck
> before calling xa_store() and xa_erase(). Since these operations modify
> the XArray structure, a write lock is required to ensure exclusive access
> and prevent data corruption from concurrent modifications.
>
> Furthermore, ksmbd_session_rpc_method() accessed the list using xa_load()
> without holding any lock at all. This could lead to reading inconsistent
> data or a potential use-after-free if an entry is concurrently removed an=
d
> the pointer is dereferenced.
>
> Fix these issues by:
> 1. Using down_write() and up_write() in ksmbd_session_rpc_open()
>    to ensure exclusive access during XArray modification, and ensuring
>    the lock is correctly released on error paths.
> 2. Adding down_read() and up_read() in ksmbd_session_rpc_method()
>    to safely protect the lookup.
>
> Fixes: a1f46c99d9ea ("ksmbd: fix use-after-free in ksmbd_session_rpc_open=
")
> Fixes: b685757c7b08 ("ksmbd: Implements sess->rpc_handle_list as xarray")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yunseong Kim <ysk@kzalloc.com>
Applied it to #ksmbd-for-next-next.
Thanks!
