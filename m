Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792548412;
	b=lyN0pCSJbWkm7tIGkkuvwIenA7PTrrknxOnOTIeBH6drbQ+g8CqTL8ll6xTUDBNGVGyU
	 IY8uRYSlqM4hxs5J41mhyFAeESmGYRmX5KtOWHdZwsiON0XLXhcCrIZ2rSXx+OZUguTi6
	 f10997wchRCeAUEzM1c6FiDwOu4J4hKilSMurp1T1hvZU1E3jUlkXIEy03hNHFgxMR8G/
	 4GZ2K4utZgYvGdbnGKmwE7zElyAOfmjrsq3vjiJsRQY72C0cmbG8slrhdhW6RZ3KLSeX8
	 K/5KJYI/aLzolAO+RcYbLdmmMC+q4BHMDZJKXG6Bb0ZTH6l7KcQ7Ku6rFsBaV27ndWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792548412;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:References:In-Reply-To:
	 From:Date:X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:
	 Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=Hx6UElPaQ01AndWg4PbkPo3EgkBjeG9V0ErP0KNlUD8=;
	b=bJqkDZ5j0tt0vyIds5txXXQnhRGeWN35ZG03HC9PupIZ/SznEuSRKiGtwmLisC4n+XR4
	 MsA6tOvTm3qaHH82LuRbScmXZ46fCsNsth8e6wK9iCDEbT9Jsa7iDwW3xZYFwFlz7gIPV
	 Hp6R9jAoZs1KCUL8oQAohqTUVdglYwe7xuYjjd+bi+0nd1jl+ZnvS6EQIZ2OHIH/sF8/H
	 24xudQGJ1gAJaX7bAWhlHKFofmVHHxLHWSVP3FX6WIgPwbtXPg4j+DVSW5tRBawipWFrZ
	 mHyMJhMc4cgPYcxjZGf5YwaXH5DsFh/WN83tMlCf3IeUnEEYJLKWd5hgQ+F+1E3X5Dw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMTjbLSb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27971606A319
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 02:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NMTjbLSb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC8A21F000D3
	for <linux-cifs@vger.kernel.org>; Wed, 21 Oct 2026 02:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792548410;
	bh=Hx6UElPaQ01AndWg4PbkPo3EgkBjeG9V0ErP0KNlUD8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=NMTjbLSb3LXf1iVDfJKjQRMbkHf9mPDJYsyhfKhVT3/rA4BR+rO53Zw5zZ6rzGVTA
	 Y101+129P+/3zbto2OwmXjle7aT3pkWU6+RUiQfi3rNyZINXRaN4df64iXy6cXa28b
	 9FARR/Z7GIEzSU1BDJ4uVIbdDlhtnZv8iiFMsNxIbXtWSh3hz5gjLxap3qA6fD0GEq
	 aAra2PzrCbRtsZI3RInfbSI4xw49jbCOlI+hdmY5ijmuemhBWDn4xemCIVJb8jnhyj
	 kcBZqmNQVJvC7QEKqn6kUthuHwdaqIVwq+v7rXbDPN5KAoXz0uqaxbH3Cmh1oLRMTZ
	 GKrSp5ybVR5sg==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c20ce3c118aso39946366b.0
        for <linux-cifs@vger.kernel.org>; Tue, 20 Oct 2026 19:06:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxgwaIcTAl5RGyA/Kwakytya0QH51RaSAmuOpNjUvl8D4CN7EUTJfHjvfx2r83Ki+DD+6wpgXS/NM2F@vger.kernel.org
X-Gm-Message-State: AFq9FYIyanuSPebjqMJyAiRp+ZUZUjAARfWjW4/vz9/S2rsjhzkvVJzx
	dFigrgiA7FyK6WN5tBdB3rFFbzNMC4CyUtO8lbGTMIAGZhsUms3M2p1e2S2kOzMkIdUZ5ZoHW09
	HFxE7glu3eMVTWXetWNXPVg8BTMoa5UI=
X-Received: by 2002:a17:907:3e97:b0:c41:d447:8cfd with SMTP id
 a640c23a62f3a-c4603fff7cemr317952266b.14.1792548409239; Tue, 20 Oct 2026
 19:06:49 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261020175254.900284-2-bestswngs@gmail.com>
In-Reply-To: <20261020175254.900284-2-bestswngs@gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 21 Oct 2026 11:06:37 +0900
X-Gmail-Original-Message-ID: <CAKYAXd9nwp=X8AfzqTs9231i6SVoX7wuBqVvUfgBP2a8xrt+ow@mail.gmail.com>
X-Gm-Features: AclHuK8zx3LKE8QhYy0wPgoLL5ouP5Fjp4oCR73y7YVcSNDQv3hX7_G5BtFAtuM
Message-ID: <CAKYAXd9nwp=X8AfzqTs9231i6SVoX7wuBqVvUfgBP2a8xrt+ow@mail.gmail.com>
Subject: Re: [PATCH] smb/server: prevent file publication after tree disconnect
To: Weiming Shi <bestswngs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, 
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Ronnie Sahlberg <lsahlber@redhat.com>, 
	Hyunchul Lee <hyc.lee@gmail.com>, Xiang Mei <xmei5@asu.edu>, stable@vger.kernel.org, 
	co+d531129f2f9fbf88@bugs.sh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 21, 2026 at 2:53=E2=80=AFAM Weiming Shi <bestswngs@gmail.com> w=
rote:
>
> TREE_DISCONNECT closes the tree's published file handles before marking a=
nd
> removing the tree connection. A concurrent CREATE that already holds a tr=
ee
> reference can therefore publish its file after the close pass. When CREAT=
E
> drops its reference, the tree can be freed while the published file still
> points to it.
>
> Mark and remove the tree connection before closing its files, and seriali=
ze
> both new-open and durable-reconnect volatile ID publication with that sta=
te
> transition. An opener is then either published in time for the close pass
> or rejected after disconnect with STATUS_NETWORK_NAME_DELETED.
>
> Keep a tree reference while a file carries its tree pointer. This protect=
s
> asynchronous users that can defer the file's final destruction past tree
> disconnect.
>
> The close pass can race the successful FP_NEW to FP_INITED transition.
> Take the opening request's file reference atomically with that transition=
.
> This keeps the file alive until request completion even if teardown remov=
es
> the ID immediately.
>
>   BUG: KASAN: slab-use-after-free in proc_show_files (fs/smb/server/vfs_c=
ache.c:126)
>   Read of size 4 at addr ff11000101540f80 by task poc/153
>
>   Call Trace:
>     proc_show_files (fs/smb/server/vfs_cache.c:126)
>     seq_read_iter (fs/seq_file.c:231)
>     proc_reg_read_iter (fs/proc/inode.c:299)
>     vfs_read (fs/read_write.c:574)
>     ksys_read (fs/read_write.c:716)
>     do_syscall_64 (arch/x86/entry/syscall_64.c:84)
>     entry_SYSCALL_64_after_hwframe (arch/x86/entry/entry_64.S:121)
>
>   Allocated by:
>     ksmbd_tree_conn_connect (fs/smb/server/mgmt/tree_connect.c:35)
>     smb2_tree_connect (fs/smb/server/smb2pdu.c:2819)
>     handle_ksmbd_work (fs/smb/server/server.c:368)
>
>   Freed by:
>     kfree (mm/slub.c:6801)
>     handle_ksmbd_work (fs/smb/server/server.c:332)
>
> Fixes: f44158485826 ("cifsd: add file operations")
> Cc: stable@vger.kernel.org
> Reported-by: <co+d531129f2f9fbf88@bugs.sh>
> Assisted-by: LLM
> Signed-off-by: Weiming Shi <bestswngs@gmail.com>
This patch does not apply cleanly to the ksmbd-for-next branch. Could
you please rebase it onto that branch and resend it?
Thanks!
