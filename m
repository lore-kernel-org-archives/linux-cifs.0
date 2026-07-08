Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B7B23AA187
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 01:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783473705; cv=none; b=NUDwhQdVJL/HsbvHir75GyVZztsI35dnahYBPCatSKhjfQXTpjJ7sNcIe+auUtCbEjVh4Up63/4A8r6vlv2VVQT+vFBPFam/19gjffP4iZ+ghJ8hnwEfk7ASPCmwK8ekTqSqI1YnCuq1S5uWvvPp5vgIBP1YYKxczgTAuGJBDGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783473705; c=relaxed/simple;
	bh=93wnEYlHVYLkk41G012SaKRibMxHVIHa3NuI5o9h34c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ni5IiQllHFhx2r7aN6wY95xOCpQNNiVWuNf0xALTvn6Zm99S/bvEBtVKz1vqt+uHAJRY9slBjj3VJZ74cbq/RXeU/FYw0U0WNQRfDGDrvsVbqIGiEf+5rBFV28ztLrLVewpU71YK0QCq5Lh/kMG11cevPELo9C51mZ4XKTcpvu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oqQZbtrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oqQZbtrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 298B21F00A3D
	for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2026 01:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783473704;
	bh=MMopPrNgwxXUrDbg4DW1/ozQIPWjwncmFWSw9aggzUk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=oqQZbtrRtgxNwFcYDXPkFL16VudLFYcnfQbTTvR65n/4M1jghugx2PByq0c4xx3j3
	 2o69O4JOOln1wgJLyGeR4mxpZlw+JCsfgEQvVHIYTCfWn6jX/N6mTimSuDbqpjUwkS
	 /P5Pd9mvZyYFWuvVnwzYdiAVFtcrLJRrz+J3Mx8UgmHrKiG68YgLI2Ip9na70XTvbO
	 czG7tKVJyzoKK2+xLkZ1i7K/UxVOIHyKfe7Hppf4XCrk3pbmX6Vc82QYxdIUX552Mw
	 SOOqtMQKaGh/iOYZbgeh3KCJ3OyMyzTMirKH0vR8CJ5+4CwOIzPQIq55zYXQGfa5FV
	 Dv7fFUxkCWVjQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1297f37073so11623166b.2
        for <linux-cifs@vger.kernel.org>; Tue, 07 Jul 2026 18:21:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YzIqi8ZTVhiv2NPj/dBJeupiqD/COkIL1UvJfjW9QxL5VyAoS90
	TIpL5Pj5AVc3gu7u8H5nmRD2mnQhKPtfa6wb16oDrh60jCM17Ec5O7uZuoI9yhgXik8YQt2wz7E
	wwr2/Zc8R6PH7pdxjv8aHWhtau15EOUw=
X-Received: by 2002:a17:907:a70b:b0:c15:ce72:935b with SMTP id
 a640c23a62f3a-c15ce729429mr16621566b.14.1783473702744; Tue, 07 Jul 2026
 18:21:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260707203334.1164183-1-ematsumiya@suse.de>
In-Reply-To: <20260707203334.1164183-1-ematsumiya@suse.de>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 8 Jul 2026 10:21:30 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_OdUbuZ_OP2vAJJPO3SCJCSt-uh2rxbsibeMYgzuDHDQ@mail.gmail.com>
X-Gm-Features: AVVi8CceDSGHzh_DjmjlNm4LNHPbYEIS21NY4cwy9368OERJaqrEJUnPYISMdOk
Message-ID: <CAKYAXd_OdUbuZ_OP2vAJJPO3SCJCSt-uh2rxbsibeMYgzuDHDQ@mail.gmail.com>
Subject: Re: [PATCH] smb: server: fix leak of ksmbd_ipc_login_request_ext()
 returned buffer
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: linux-cifs@vger.kernel.org, smfrench@gmail.com, tom@talpey.com, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 5:33=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> Free it in ksmbd_alloc_user() (the only function that uses it).
>
> kmemleak splat:
>   unreferenced object 0xffff888103b83540 (size 192):
>     comm "pool-0", pid 16970, jiffies 4377290937
>     hex dump (first 32 bytes):
>       00 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>       00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     backtrace (crc 408ccc66):
>       __kvmalloc_node_noprof+0x730/0x920
>       handle_generic_event+0xec/0x1a0 [ksmbd]
>       genl_family_rcv_msg_doit+0xe0/0x130
>       genl_rcv_msg+0x181/0x290
>       netlink_rcv_skb+0x4f/0x100
>       genl_rcv+0x28/0x40
>       netlink_unicast+0x1e6/0x2c0
>       netlink_sendmsg+0x20a/0x450
>       ____sys_sendmsg+0x2e8/0x310
>       ___sys_sendmsg+0x78/0xc0
>       __sys_sendmsg+0x63/0xc0
>       do_syscall_64+0xa1/0x670
>       entry_SYSCALL_64_after_hwframe+0x76/0x7e
>
> Fixes: a77e0e02af1c ("ksmbd: add support for supplementary groups")
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>  fs/smb/server/mgmt/user_config.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_c=
onfig.c
> index cf45841d9d1b..2319c6cc67da 100644
> --- a/fs/smb/server/mgmt/user_config.c
> +++ b/fs/smb/server/mgmt/user_config.c
> @@ -66,12 +66,14 @@ struct ksmbd_user *ksmbd_alloc_user(struct ksmbd_logi=
n_response *resp,
>                 ksmbd_debug(SMB, "supplementary groups : %d\n", user->ngr=
oups);
>         }
>
> +       kfree(resp_ext);
>         return user;
>
>  err_free:
>         kfree(user->name);
>         kfree(user->passkey);
>         kfree(user);
> +       kfree(resp_ext);
>         return NULL;
>  }
Please use kvfree() and free it from the caller.

diff --git a/fs/smb/server/mgmt/user_config.c b/fs/smb/server/mgmt/user_con=
fig.c
index cf45841d9d1b..03184a3303b9 100644
--- a/fs/smb/server/mgmt/user_config.c
+++ b/fs/smb/server/mgmt/user_config.c
@@ -26,6 +26,7 @@ struct ksmbd_user *ksmbd_login_user(const char *account)
                resp_ext =3D ksmbd_ipc_login_request_ext(account);

        user =3D ksmbd_alloc_user(resp, resp_ext);
+       kvfree(resp_ext);
 out:
        kvfree(resp);
        return user;
>
> --
> 2.54.0
>
