Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B983C30;
	Mon, 21 Jul 2025 00:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753057207; cv=none; b=TyYuo/UiNTfrgY4UP5ZD2j28MDYdC7efOFWzuDqb7gS9i2sGe8yxrfYxYcSKZMERE0lHqIjYNL0ZoR10dL5z0ZQSk1fV5w7LZ0ZFIVrzOq1yC12UtRNn1LyTAk6v6RfuvImRaaEBxYUNvsSHoXaXSMVVczN8aMF5vLtYFO/U/LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753057207; c=relaxed/simple;
	bh=Sy4W2D1joFdCNKL9SjsHN96JgZ2zUzGxjidSLUlrEas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WSHEgNhE4rCb69TE23AU7iKAKr0/0dMwPlQdzNSTOnnWoIeIenQXOP8LRVKwnWdhrNUu/UBvNZzLswRD3wMDiWs4ruplsdun3zUtyluZT4bEJINKw3zwBNqpPo8CPlnj+bR6bikKdA3jJdK3+2zyref5EUVLQM7NMrPpLMhQGmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GiH0JmsA; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GiH0JmsA"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6facacf521eso35192246d6.3;
        Sun, 20 Jul 2025 17:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753057204; x=1753662004; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4uxtFN/g02OUd8QS+EKIJNHOPRScDGOSxVQctcJt7M=;
        b=GiH0JmsA3Ftm2vreS+UuZJpnr8hYM4aWQCbM6TJPLnd/J8xOJhtycMsxW3d7jR5E6W
         JIi1Merfw+szdzaEcVfb7xRPcL79s5Hml/4l4rHI3O0+xV4sDFAI3UAtlFjUl2xNBs3x
         l3p2REThcSat/4VfdFnY6DXqbin+HStUIOOvYgSBQENa+Xj1JKnJVmMUPLjb+tXN57Sp
         XFTpZvZDe0HIUvDcqH/l085sanpUDhD0N2qanZQEH+LowrB789albmMW+YLsYRRvoVxx
         JkgQRJt9EnQRW700LepfjD/8HXGXa6akb69Zvc2kDuGiqRfet9ZbV1rVYrOSVQ4pOcSv
         43qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753057204; x=1753662004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4uxtFN/g02OUd8QS+EKIJNHOPRScDGOSxVQctcJt7M=;
        b=P2vv5fVJq5Cj+/rj+JogkmjDtndBHWUk4BJIX26UgrNRXKSsO7/ArcAwpwKfjtna6m
         aOUkA7UtHNDxIFk0FxOlkVvCvMD0+pGG2bwNx3gtrCEpKw3LobhUmqJE3Dr23dHjTGVc
         H2+xtJyOhNdoILIQNaRn0h78PQoMKVfz8Mip35+pwdZTi4PsM8qDHqoPbib2LoalOPb9
         j6jrIr1eKabFg0dRgokXu+iVOVssHipRBgv3LiImZZ7hXe12C6ZCApe6uzTkTq+fED4X
         Jidf0gKeIwYj+kOcKqEvlmLgjskZDsV5xnw6XgidQup3P67K3S0ryeqhs8USN2rkmE6G
         u9Jg==
X-Forwarded-Encrypted: i=1; AJvYcCUZFMc17EaVjT9oop5HtpwkCLG5LuGT46LgoAa6USggHaXhpsn6G0U5EyM/bG+IzXbeZFCUs60q9chnxNqy@vger.kernel.org, AJvYcCUnIKc3hUTTlp7gPB003Hx9FvyFbo8iR6/h2j97Dfbo/CvFgv9jcmDsnrCf2Pz25M7KHF5lmuGgDALy@vger.kernel.org
X-Gm-Message-State: AOJu0YxD/8Bdl3B6UATwT2Cn7YkzJpWYrNt+fDy+MGmFG1tme9YkoU5K
	d2tuZuRBVcJZIENgEHY/zA2ihfM4xq+cxJKghQRGcDxbW4dkRQheBVQjSQ92qryakFNEtVcu3ei
	9q3XtDuR2AxvPsSwoK/XXThVwu4lOeyEmsV1o
X-Gm-Gg: ASbGncspbrPW/8MYGvkkl52BzFKKA9iHdimTJ/AQZY8trNUIOV3b4k5Yu643ddETBuu
	5dEVdowHCRL8bS9DdVk+W9mXRez3P6tWG3ljc80RRqu95UJzYW/o19Vx+HpSVgR1/7u5wNEhvwZ
	0ktELzbGS+cVHgBBHbqNThAJIvW2IY62UNRfb0lPPYX2a+AbP4LUToXxCRXmOMl9Ouk9cPv2Gt5
	uyf7g==
X-Google-Smtp-Source: AGHT+IFn9uzqm/marhuf9II1iNT1qdWq1pOhL/1LHYsteK69aMBRNzBkMlDRf31MHjqdlS2Tem+7Zm4f63g8nJ9XP/c=
X-Received: by 2002:a05:6214:ca2:b0:6fa:c31a:af20 with SMTP id
 6a1803df08f44-705071c1e69mr250739726d6.5.1753057204481; Sun, 20 Jul 2025
 17:20:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250717132926.901902-1-wangzhaolong@huaweicloud.com>
In-Reply-To: <20250717132926.901902-1-wangzhaolong@huaweicloud.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 20 Jul 2025 19:19:52 -0500
X-Gm-Features: Ac12FXwse2Ja5ZRLqiunqBUQbV3uP5osiXrdrdg89bhJZUqCkYPAqjEruuoVs_0
Message-ID: <CAH2r5mv02iZ3OWk9ZhQdFFH89rbEAuLF_yek6+v_yvyMPHugxw@mail.gmail.com>
Subject: Re: [PATCH V2] smb: client: fix netns refcount leak after net_passive changes
To: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Cc: sfrench@samba.org, kuniyu@google.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	chengzhihao1@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending more review and testing

On Thu, Jul 17, 2025 at 8:35=E2=80=AFAM Wang Zhaolong
<wangzhaolong@huaweicloud.com> wrote:
>
> After commit 5c70eb5c593d ("net: better track kernel sockets lifetime"),
> kernel sockets now use net_passive reference counting. However, commit
> 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after rmmod""=
)
> restored the manual socket refcount manipulation without adapting to this
> new mechanism, causing a memory leak.
>
> The issue can be reproduced by[1]:
> 1. Creating a network namespace
> 2. Mounting and Unmounting CIFS within the namespace
> 3. Deleting the namespace
>
> Some memory leaks may appear after a period of time following step 3.
>
> unreferenced object 0xffff9951419f6b00 (size 256):
>   comm "ip", pid 447, jiffies 4294692389 (age 14.730s)
>   hex dump (first 32 bytes):
>     1b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 80 77 c2 44 51 99 ff ff  .........w.DQ...
>   backtrace:
>     __kmem_cache_alloc_node+0x30e/0x3d0
>     __kmalloc+0x52/0x120
>     net_alloc_generic+0x1d/0x30
>     copy_net_ns+0x86/0x200
>     create_new_namespaces+0x117/0x300
>     unshare_nsproxy_namespaces+0x60/0xa0
>     ksys_unshare+0x148/0x360
>     __x64_sys_unshare+0x12/0x20
>     do_syscall_64+0x59/0x110
>     entry_SYSCALL_64_after_hwframe+0x78/0xe2
> ...
> unreferenced object 0xffff9951442e7500 (size 32):
>   comm "mount.cifs", pid 475, jiffies 4294693782 (age 13.343s)
>   hex dump (first 32 bytes):
>     40 c5 38 46 51 99 ff ff 18 01 96 42 51 99 ff ff  @.8FQ......BQ...
>     01 00 00 00 6f 00 c5 07 6f 00 d8 07 00 00 00 00  ....o...o.......
>   backtrace:
>     __kmem_cache_alloc_node+0x30e/0x3d0
>     kmalloc_trace+0x2a/0x90
>     ref_tracker_alloc+0x8e/0x1d0
>     sk_alloc+0x18c/0x1c0
>     inet_create+0xf1/0x370
>     __sock_create+0xd7/0x1e0
>     generic_ip_connect+0x1d4/0x5a0 [cifs]
>     cifs_get_tcp_session+0x5d0/0x8a0 [cifs]
>     cifs_mount_get_session+0x47/0x1b0 [cifs]
>     dfs_mount_share+0xfa/0xa10 [cifs]
>     cifs_mount+0x68/0x2b0 [cifs]
>     cifs_smb3_do_mount+0x10b/0x760 [cifs]
>     smb3_get_tree+0x112/0x2e0 [cifs]
>     vfs_get_tree+0x29/0xf0
>     path_mount+0x2d4/0xa00
>     __se_sys_mount+0x165/0x1d0
>
> Root cause:
> When creating kernel sockets, sk_alloc() calls net_passive_inc() for
> sockets with sk_net_refcnt=3D0. The CIFS code manually converts kernel
> sockets to user sockets by setting sk_net_refcnt=3D1, but doesn't call
> the corresponding net_passive_dec(). This creates an imbalance in the
> net_passive counter, which prevents the network namespace from being
> destroyed when its last user reference is dropped. As a result, the
> entire namespace and all its associated resources remain allocated.
>
> Timeline of patches leading to this issue:
> - commit ef7134c7fc48 ("smb: client: Fix use-after-free of network
>   namespace.") in v6.12 fixed the original netns UAF by manually
>   managing socket refcounts
> - commit e9f2517a3e18 ("smb: client: fix TCP timers deadlock after
>   rmmod") in v6.13 attempted to use kernel sockets but introduced
>   TCP timer issues
> - commit 5c70eb5c593d ("net: better track kernel sockets lifetime")
>   in v6.14-rc5 introduced the net_passive mechanism with
>   sk_net_refcnt_upgrade() for proper socket conversion
> - commit 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock
>   after rmmod"") in v6.15-rc3 reverted to manual refcount management
>   without adapting to the new net_passive changes
>
> Fix this by using sk_net_refcnt_upgrade() which properly handles the
> net_passive counter when converting kernel sockets to user sockets.
>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D220343 [1]
> Fixes: 95d2b9f693ff ("Revert "smb: client: fix TCP timers deadlock after =
rmmod"")
> Cc: stable@vger.kernel.org
> Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> ---
>  fs/smb/client/connect.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
>
> V1 -> V2:
> - Add a simplified description of the reproduction steps in the
>   commit message.
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 205f547ca49e..5eec8957f2a9 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -3360,22 +3360,19 @@ generic_ip_connect(struct TCP_Server_Info *server=
)
>                 socket =3D server->ssocket;
>         } else {
>                 struct net *net =3D cifs_net_ns(server);
>                 struct sock *sk;
>
> -               rc =3D __sock_create(net, sfamily, SOCK_STREAM,
> -                                  IPPROTO_TCP, &server->ssocket, 1);
> +               rc =3D sock_create_kern(net, sfamily, SOCK_STREAM,
> +                                     IPPROTO_TCP, &server->ssocket);
>                 if (rc < 0) {
>                         cifs_server_dbg(VFS, "Error %d creating socket\n"=
, rc);
>                         return rc;
>                 }
>
>                 sk =3D server->ssocket->sk;
> -               __netns_tracker_free(net, &sk->ns_tracker, false);
> -               sk->sk_net_refcnt =3D 1;
> -               get_net_track(net, &sk->ns_tracker, GFP_KERNEL);
> -               sock_inuse_add(net, 1);
> +               sk_net_refcnt_upgrade(sk);
>
>                 /* BB other socket options to set KEEPALIVE, NODELAY? */
>                 cifs_dbg(FYI, "Socket created\n");
>                 socket =3D server->ssocket;
>                 socket->sk->sk_allocation =3D GFP_NOFS;
> --
> 2.39.2
>
>


--=20
Thanks,

Steve
