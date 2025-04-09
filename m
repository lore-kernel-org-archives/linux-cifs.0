Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E38267395
	for <linux-cifs@vger.kernel.org>; Wed,  9 Apr 2025 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744212762; cv=none; b=izticfzSohtosKIpBwc6tNMr14H8zzl2y3RTnMFOKD9TMHjCmoIR4WSQu5MxegGwXsbWVYEdvsgVRiyMhM/L7Jh8XtZthlszntdbJ6nQVZ1nTICn4MNvo8ThA3u/qiWrDQLvXxU8AIpkSl4cBY08aJbyV3YI0MD5QVTzxCkVdEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744212762; c=relaxed/simple;
	bh=6bw1DIrm21FUGaoE6Eolo//R+VATT7Zw/mNXKLDPtGw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZrD39cZUTMojFJJKJwnhD+eG+1Jobw7NqEwfG0IKHVsu1sy63SDHsVzSuNjaDK6rLgcIbtwdYh332mS4dr3GfvIRnFVtmqN+L5k+2SwqzsrZDRzbzQy87tUkRZqRk2sEnpkmeb2X6O9L9066070p72WOcTGpDd3l7JVOLiR6a4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UXSaWgFH; arc=none smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UXSaWgFH"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-54acc04516fso6476533e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 09 Apr 2025 08:32:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744212759; x=1744817559; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGimXDoC7E4yKqvLuhNdE6W99WblOv9IQ6qGfQVA9Fc=;
        b=UXSaWgFH06fxIN3HbGDmFbi+QvTxv/G9ACxPNJX5R08JpSW1gU/xUOe0Psu7Rbjq64
         fcHeaWIrD+93qfj7MSkskxBUa3PQS1QStjS9q1xuAGbtu9u6juuhMOppWLkLIu/L6X/p
         6uTuMu4RAobVVcuf6BvUDaAqyzl0xkXhvXjOzyaReAN67RMvPWc6Vl0ZKfOwpx68Hw+b
         v/mJPQn0RDmVksMYgCh3cIZecU6TNG7p/k/SMZeISzEWO1YHkXGEAljI9JZW0liVy8kk
         rn6trDgUley6p1R8TvJTK1ad02CiNKtzKbjJHj0cbSTNSrV3ov4XKKAHzw1v2dOzZnbC
         1AyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744212759; x=1744817559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MGimXDoC7E4yKqvLuhNdE6W99WblOv9IQ6qGfQVA9Fc=;
        b=RSViuKQeLYNY/kalafjvdpp0ZiOgEX7TBhmJF9cthPaq1UcTwWss/sEBt5Lq0dDDvS
         8JrhnXKJ0zSUEPU+gSW8FqCKo2XkhsAxDhs840I9ZAh71p107ilbcsfAiiAVBYxP3HnP
         feitE9dpBq5NU4yVX4NRwv6XT03YojBQCDP8pKTSYDISG+bc4gqfTsOelrl2+5CKOu+3
         exqtcaGHBXzZ5ZsCdSe1vSaJ0qtBK8xnVc/6pZiJTiqRCovXjaPCMTgmYFcEyiBMNNoM
         6IazYX0yUG4OZ5yfwyosX65K7MnauKuZFn8SFaM1/ZoTCvhZX0RXnJPjvOBw+4xIB9+e
         Z4hw==
X-Gm-Message-State: AOJu0Yz0brY9a1FvZhQ/eygkWz0/Nlo9FeA4udX70HfPFZMQP1jKr1Cx
	WXOgTrOpleC/xJtGoOIIpDIe6c/dV/i+PT7bGC1zif/l3ILPd3TJu9HZCSAm6lpZf6Zhogc8SxE
	r6jvR1WlQpTwOmp1p1dv1n+zjKqiN2A==
X-Gm-Gg: ASbGncsyzovJRSzjSbB78Zaqd+WVONtxoZOztw7jwbNf2RhIImONFEUGHXLdFckHEUp
	sQ9O5HGZYUBv2Ni3QA3hDJqhWc8VBIw+x8njak/8ObK2z7os4/SDEG0Glr6keoeLLh8JglHnpR3
	2LMBlzGZL4dFR4uiLigAdoLheNqQMiwwpSm/v7Asb2yQkOwvvkfyP5KWo=
X-Google-Smtp-Source: AGHT+IHX+a6cCDQ/KcoyIsngT8ARaLTvFA+t4YtXipsq3MZjVZF9vx0HE2BnVUmf1/ta+ckc1AxoswYS1XILuh9EI5A=
X-Received: by 2002:a05:6512:2344:b0:54a:cc11:9cc6 with SMTP id
 2adb3069b0e04-54c43716899mr1181428e87.19.1744212758325; Wed, 09 Apr 2025
 08:32:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250409141421.154510-1-pc@manguebit.com>
In-Reply-To: <20250409141421.154510-1-pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 9 Apr 2025 10:32:27 -0500
X-Gm-Features: ATxdqUFnke34d3axCc_eb4Vp8fL2ZiIwq6WXzVyhTp10qjj_CwlpymQrDVFpVgc
Message-ID: <CAH2r5mv4FS+9ECRoX5MU0+9mQWH_GaN1wD9gBtzXw-G1N9dDkQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix UAF in decryption with multichannel
To: Paulo Alcantara <pc@manguebit.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending testing/review

On Wed, Apr 9, 2025 at 9:14=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> w=
rote:
>
> After commit f7025d861694 ("smb: client: allocate crypto only for
> primary server") and commit b0abcd65ec54 ("smb: client: fix UAF in
> async decryption"), the channels started reusing AEAD TFM from primary
> channel to perform synchronous decryption, but that can't done as
> there could be multiple cifsd threads (one per channel) simultaneously
> accessing it to perform decryption.
>
> This fixes the following KASAN splat when running fstest generic/249
> with 'vers=3D3.1.1,multichannel,max_channels=3D4,seal' against Windows
> Server 2022:
>
> BUG: KASAN: slab-use-after-free in gf128mul_4k_lle+0xba/0x110
> Read of size 8 at addr ffff8881046c18a0 by task cifsd/986
> CPU: 3 UID: 0 PID: 986 Comm: cifsd Not tainted 6.15.0-rc1 #1
> PREEMPT(voluntary)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-3.fc41
> 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x5d/0x80
>  print_report+0x156/0x528
>  ? gf128mul_4k_lle+0xba/0x110
>  ? __virt_addr_valid+0x145/0x300
>  ? __phys_addr+0x46/0x90
>  ? gf128mul_4k_lle+0xba/0x110
>  kasan_report+0xdf/0x1a0
>  ? gf128mul_4k_lle+0xba/0x110
>  gf128mul_4k_lle+0xba/0x110
>  ghash_update+0x189/0x210
>  shash_ahash_update+0x295/0x370
>  ? __pfx_shash_ahash_update+0x10/0x10
>  ? __pfx_shash_ahash_update+0x10/0x10
>  ? __pfx_extract_iter_to_sg+0x10/0x10
>  ? ___kmalloc_large_node+0x10e/0x180
>  ? __asan_memset+0x23/0x50
>  crypto_ahash_update+0x3c/0xc0
>  gcm_hash_assoc_remain_continue+0x93/0xc0
>  crypt_message+0xe09/0xec0 [cifs]
>  ? __pfx_crypt_message+0x10/0x10 [cifs]
>  ? _raw_spin_unlock+0x23/0x40
>  ? __pfx_cifs_readv_from_socket+0x10/0x10 [cifs]
>  decrypt_raw_data+0x229/0x380 [cifs]
>  ? __pfx_decrypt_raw_data+0x10/0x10 [cifs]
>  ? __pfx_cifs_read_iter_from_socket+0x10/0x10 [cifs]
>  smb3_receive_transform+0x837/0xc80 [cifs]
>  ? __pfx_smb3_receive_transform+0x10/0x10 [cifs]
>  ? __pfx___might_resched+0x10/0x10
>  ? __pfx_smb3_is_transform_hdr+0x10/0x10 [cifs]
>  cifs_demultiplex_thread+0x692/0x1570 [cifs]
>  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
>  ? rcu_is_watching+0x20/0x50
>  ? rcu_lockdep_current_cpu_online+0x62/0xb0
>  ? find_held_lock+0x32/0x90
>  ? kvm_sched_clock_read+0x11/0x20
>  ? local_clock_noinstr+0xd/0xd0
>  ? trace_irq_enable.constprop.0+0xa8/0xe0
>  ? __pfx_cifs_demultiplex_thread+0x10/0x10 [cifs]
>  kthread+0x1fe/0x380
>  ? kthread+0x10f/0x380
>  ? __pfx_kthread+0x10/0x10
>  ? local_clock_noinstr+0xd/0xd0
>  ? ret_from_fork+0x1b/0x60
>  ? local_clock+0x15/0x30
>  ? lock_release+0x29b/0x390
>  ? rcu_is_watching+0x20/0x50
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork+0x31/0x60
>  ? __pfx_kthread+0x10/0x10
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
> Cc: David Howells <dhowells@redhat.com>
> Reported-by: Steve French <stfrench@microsoft.com>
> Closes: https://lore.kernel.org/r/CAH2r5mu6Yc0-RJXM3kFyBYUB09XmXBrNodOiCV=
R4EDrmxq5Szg@mail.gmail.com
> Fixes: f7025d861694 ("smb: client: allocate crypto only for primary serve=
r")
> Fixes: b0abcd65ec54 ("smb: client: fix UAF in async decryption")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.com>
> ---
>  fs/smb/client/cifsencrypt.c | 16 +++++-----------
>  fs/smb/client/smb2ops.c     |  6 +++---
>  fs/smb/client/smb2pdu.c     | 11 ++---------
>  3 files changed, 10 insertions(+), 23 deletions(-)
>
> diff --git a/fs/smb/client/cifsencrypt.c b/fs/smb/client/cifsencrypt.c
> index e69968e88fe7..35892df7335c 100644
> --- a/fs/smb/client/cifsencrypt.c
> +++ b/fs/smb/client/cifsencrypt.c
> @@ -704,18 +704,12 @@ cifs_crypto_secmech_release(struct TCP_Server_Info =
*server)
>         cifs_free_hash(&server->secmech.md5);
>         cifs_free_hash(&server->secmech.sha512);
>
> -       if (!SERVER_IS_CHAN(server)) {
> -               if (server->secmech.enc) {
> -                       crypto_free_aead(server->secmech.enc);
> -                       server->secmech.enc =3D NULL;
> -               }
> -
> -               if (server->secmech.dec) {
> -                       crypto_free_aead(server->secmech.dec);
> -                       server->secmech.dec =3D NULL;
> -               }
> -       } else {
> +       if (server->secmech.enc) {
> +               crypto_free_aead(server->secmech.enc);
>                 server->secmech.enc =3D NULL;
> +       }
> +       if (server->secmech.dec) {
> +               crypto_free_aead(server->secmech.dec);
>                 server->secmech.dec =3D NULL;
>         }
>  }
> diff --git a/fs/smb/client/smb2ops.c b/fs/smb/client/smb2ops.c
> index 41d8cd20b25f..3f7fe74688a9 100644
> --- a/fs/smb/client/smb2ops.c
> +++ b/fs/smb/client/smb2ops.c
> @@ -4555,9 +4555,9 @@ decrypt_raw_data(struct TCP_Server_Info *server, ch=
ar *buf,
>                         return rc;
>                 }
>         } else {
> -               if (unlikely(!server->secmech.dec))
> -                       return -EIO;
> -
> +               rc =3D smb3_crypto_aead_allocate(server);
> +               if (unlikely(rc))
> +                       return rc;
>                 tfm =3D server->secmech.dec;
>         }
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 81e05db8e4d5..c4d52bebd37d 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -1252,15 +1252,8 @@ SMB2_negotiate(const unsigned int xid,
>                         cifs_server_dbg(VFS, "Missing expected negotiate =
contexts\n");
>         }
>
> -       if (server->cipher_type && !rc) {
> -               if (!SERVER_IS_CHAN(server)) {
> -                       rc =3D smb3_crypto_aead_allocate(server);
> -               } else {
> -                       /* For channels, just reuse the primary server cr=
ypto secmech. */
> -                       server->secmech.enc =3D server->primary_server->s=
ecmech.enc;
> -                       server->secmech.dec =3D server->primary_server->s=
ecmech.dec;
> -               }
> -       }
> +       if (server->cipher_type && !rc)
> +               rc =3D smb3_crypto_aead_allocate(server);
>  neg_exit:
>         free_rsp_buf(resp_buftype, rsp);
>         return rc;
> --
> 2.49.0
>


--=20
Thanks,

Steve
