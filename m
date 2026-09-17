Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18DC327BFC
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 00:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789606616; cv=none; b=Tug01A/Z17PzE6iJ9RHKWDbP8C3H+Md/ENLXj5DPgbRyu9S9/rxVPEMD4Ff79kpSZqCgDvkjQ8RkzlkfGfHXWclVNl29MUf7mHNs4jarn4mlt6FTBOWux7ZFFeOre1xcTxxNiw7TkZg/vWy09mDAqDMgcoKxpPEEjTi/qOETMMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789606616; c=relaxed/simple;
	bh=vqe6fAH7armp1Cn8GS7ZDxha770fXgbjZoZm3p45Z0I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QeUNreJ0wTPYqbZUKXBOw3bNbA798DYN5xk9ByXm0e6/WZgVBorhCFXeXxQnhL3hyoQ++xIvfzBaVOzVZz87QTDuDCfea2rAWLJW9tpp+S+Rv64I/sEsGLq4DUxqmaU1KFVgacXKDr/S5meHi4qiF3FMAX5T7fU7QN/zeBRVMSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GOATjyKA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GOATjyKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38ED01F0089A
	for <linux-cifs@vger.kernel.org>; Thu, 17 Sep 2026 00:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789606615;
	bh=Xp2Ff0ac9Ft7a0CZ+9cNEEqKXCqGd6QMEftRp9V/P9Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GOATjyKAzCMgM+cC2wXOGTJI7T1bjn3BgBG6ePHgZABjtKjFMa5/w1q+MX6QQNGQ7
	 Gchj7PeVxRk7210pdYIMMOsj3dyxGZG1xcLaKri1lyHadfoySmVlUOA2lWE2Crrno+
	 Al+ZHW8jKdmL4Y42H27OGG5Zd/ZC5bA+9DdLP/Eo9eLqmIsxbruJPYgg/FFbRMj3Pi
	 9EdWecGF3lWAjFCnCP+16ctS8hjQI41IB5XAhzzmqgm2C5GV5HhNxKm4ad8wnIIdzX
	 8Ri5LM0qyAW4hP5HCnLvoHRvfXRzjzudW7x3pjE2meQ4Z+8vV+PB8QE+p2Oi1qgHI9
	 zrOi0eQfvA1aQ==
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f55efe7so46886966b.3
        for <linux-cifs@vger.kernel.org>; Wed, 16 Sep 2026 17:56:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBytQ1lHaiCRwSCDGjjWfo7IetUwhnHtIACDD6PPd/O/MEJJB/J4DMYgrqJZwZcCFzTBqSjdSUDhLQYL@vger.kernel.org
X-Gm-Message-State: AFuF++mltGvQ43nRjCNJcw4PSxUe4+gcetI2qOaGP8vIgH6XSeAz+ML1
	RmFticTPKkOxbNZwvkLE22LjfdMOBmefxryEtcAFmxNq+tAthr2x3NWYoFpVFgl0UYXzdDG37HM
	T/fYzVcIL7DLI83jBwNJF4qwjYMyoOEs=
X-Received: by 2002:a17:907:f447:b0:c29:659e:2fd2 with SMTP id
 a640c23a62f3a-c29e52b47ccmr328862766b.27.1789606613781; Wed, 16 Sep 2026
 17:56:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260915140834.5616-1-15815827059@163.com>
In-Reply-To: <20260915140834.5616-1-15815827059@163.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 17 Sep 2026 09:56:40 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9yRV4ysLe6k0nfq1wDRBR_OiA50_Kar7xgKg-pqfRv_g@mail.gmail.com>
X-Gm-Features: AcwNN1U6Ltzh8z58mjkMjks0KeOE6U41jMAVlvmHg_3AhdS-__u8xKVcgnRdCfE
Message-ID: <CAKYAXd9yRV4ysLe6k0nfq1wDRBR_OiA50_Kar7xgKg-pqfRv_g@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: fix iface_list use-after-free during server reset
To: huhai <15815827059@163.com>
Cc: senozhatsky@chromium.org, tom@talpey.com, chenxiaosong@chenxiaosong.com, 
	linux-cifs@vger.kernel.org, Henry Hu <huhai@kylinos.cn>, 
	Sashiko <sashiko-bot+sashiko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 15, 2026 at 11:09=E2=80=AFPM huhai <15815827059@163.com> wrote:
>
> From: Henry Hu <huhai@kylinos.cn>
>
> ksmbd_find_netdev_name_iface_list() walks iface_list for
> fsctl_query_iface_info_ioctl(), which holds RTNL. But during server
> reset, ksmbd_tcp_destroy() unlinks and frees the entries without RTNL,
> and queued SMB requests can still be running at that point. So an
> FSCTL_QUERY_NETWORK_INTERFACE_INFO request can therefore race with
> interface destruction and dereference a freed entry. With debug-only
> instrumentation to make the race deterministic, KASAN reports:
>
>    BUG: KASAN: slab-use-after-free in
>    ksmbd_find_netdev_name_iface_list
>
>    ksmbd_find_netdev_name_iface_list
>    fsctl_query_iface_info_ioctl
>    smb2_ioctl
>    handle_ksmbd_work
>
>    Freed by:
>    kfree
>    ksmbd_tcp_destroy
>    ksmbd_conn_transport_destroy
>    kill_server_store
>
> The fix is to detach iface_list to a temporary list under RTNL, then drop
> RTNL before cleanup because the following cleanup may block and hold RTNL
> for a long time.
>
> Fixes: b2d99376c5d6 ("ksmbd: browse interfaces list on FSCTL_QUERY_INTERF=
ACE_INFO IOCTL")
> Reported-by: Sashiko <sashiko-bot+sashiko@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260911163516.6403-1-15815827059%40=
163.com
> Assisted-by: LLM
> Signed-off-by: Henry Hu <huhai@kylinos.cn>
Applied it to #ksmbd-for-next.
Thanks!
