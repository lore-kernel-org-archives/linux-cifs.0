Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BC2EEC0
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 01:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771118270; cv=none; b=Uved5iZvqcJZ00NKVgh8d+4/7yynK70UyvBD5nm+2qsV6mIUUqMeSipLHmZRbDJB9Ks/3gcUlGz/k7f1IuAD9JhQY0ah5mtSmm64ZqJ8ftI6G+uT3kqLn5rBh+yt8T/9Pz5vg9fEsDuMsf34hnNVF8D3/gG7Aro8JY6grMI8xFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771118270; c=relaxed/simple;
	bh=iz4IPCYgmd0zxp2pmO3hhfxlqapGe6gDT73zq9bGoQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dLAPjFCj3EsTqUAuMA/l3qlUNoE2Stag78pIhexeJwWdXTZMKbchd6eZWbN4hp5xWYii81uPfZSWXy60qt7DtjZLC6zaXi93a7pEqlHfBtRdtg9k/3zBO/sUr/KzQ/I4TKebiRo/MxI8ClmaJ9xS3wjJIMI1/gv79LbxQnCj074=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cCh4NLTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cCh4NLTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AFCC2BC9E
	for <linux-cifs@vger.kernel.org>; Sun, 15 Feb 2026 01:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771118269;
	bh=iz4IPCYgmd0zxp2pmO3hhfxlqapGe6gDT73zq9bGoQc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cCh4NLTXCsDANssG5VDcUy6t7wMpUn18rhpDfWgC9k5JjDEmaViDukOs0W//982jn
	 tkbH+f9/K1AE0iMWgDGH5yZEKdcVSEUIKBvnVCBnb09WDQM6+SkRZK3Qx6zn/ZKvDQ
	 R+piSU2IOe+P+PdXG2MRleXZfDUL/PBMAJZQLhEtg9cVJy0ouTA7fuqHkFGwF8UElB
	 M1JSwBALCjWFoBNt4Btq1sPWeinrvZJIIxHOW4heDbVoUiH12HkSMYlEPNhFVSz/5I
	 TV8PshPpdTg9MEiX96f4Efh4Xo1nM8IkVMze+NvO6AWE9zTjOjKUGaX8m7w4YrLeay
	 1tVzr1t57FEfg==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b883c8dfb00so384333266b.1
        for <linux-cifs@vger.kernel.org>; Sat, 14 Feb 2026 17:17:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUtXYUEO7virSrWeR98W0dI330EqyUu3vFfL6Zjyrs69z6OijtwcEcqjFVWxW7NcRS1S0mbFvK8VS3u@vger.kernel.org
X-Gm-Message-State: AOJu0YwUpcIxCIaJbzRCa+rBD2OWAx8Hde4XSHc84C5snXoJhzInzozl
	nia/yBzeBl7WW627wdzLxkJaSOag3w+5PyGF6kEGak2zJR9I8uqEcm2RyFXkJ0EKMajCQIWjm/7
	5CzEIiYbMLOgbqglkiGaBO0tuGDJKZBw=
X-Received: by 2002:a17:907:2dac:b0:b83:95ca:589b with SMTP id
 a640c23a62f3a-b8fb414bc9bmr367211566b.10.1771118268235; Sat, 14 Feb 2026
 17:17:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260214154515.1229565-1-pchelkin@ispras.ru>
In-Reply-To: <20260214154515.1229565-1-pchelkin@ispras.ru>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sun, 15 Feb 2026 10:17:36 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8mQH2-oNRGA_OyUU=P9nnC1xHjZ_aFCVw3cWoMV4FMDg@mail.gmail.com>
X-Gm-Features: AaiRm53LscNWOEOSlouq28oNORInmE7eOEhK2K3ouXn1BcY4kTYGjCCdINSPOm0
Message-ID: <CAKYAXd8mQH2-oNRGA_OyUU=P9nnC1xHjZ_aFCVw3cWoMV4FMDg@mail.gmail.com>
Subject: Re: [PATCH] ksmbd: call ksmbd_vfs_kern_path_end_removing() on some
 error paths
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Steve French <smfrench@gmail.com>, NeilBrown <neil@brown.name>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 15, 2026 at 12:45=E2=80=AFAM Fedor Pchelkin <pchelkin@ispras.ru=
> wrote:
>
> There are two places where ksmbd_vfs_kern_path_end_removing() needs to be
> called in order to balance what the corresponding successful call to
> ksmbd_vfs_kern_path_start_removing() has done, i.e. drop inode locks and
> put the taken references.  Otherwise there might be potential deadlocks
> and unbalanced locks which are caught like:
>
> BUG: workqueue leaked lock or atomic: kworker/5:21/0x00000000/7596
>      last function: handle_ksmbd_work
> 2 locks held by kworker/5:21/7596:
>  #0: ffff8881051ae448 (sb_writers#3){.+.+}-{0:0}, at: ksmbd_vfs_kern_path=
_locked+0x142/0x660
>  #1: ffff888130e966c0 (&type->i_mutex_dir_key#3/1){+.+.}-{4:4}, at: ksmbd=
_vfs_kern_path_locked+0x17d/0x660
> CPU: 5 PID: 7596 Comm: kworker/5:21 Not tainted 6.1.162-00456-gc29b353f38=
3b #138
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.17.0-debian=
-1.17.0-1 04/01/2014
> Workqueue: ksmbd-io handle_ksmbd_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x44/0x5b
>  process_one_work.cold+0x57/0x5c
>  worker_thread+0x82/0x600
>  kthread+0x153/0x190
>  ret_from_fork+0x22/0x30
>  </TASK>
>
> Found by Linux Verification Center (linuxtesting.org).
>
> Fixes: d5fc1400a34b ("smb/server: avoid deadlock when linking with Replac=
eIfExists")
> Cc: stable@vger.kernel.org
> Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Applied it to #ksmbd-for-next-next.
Thanks!
