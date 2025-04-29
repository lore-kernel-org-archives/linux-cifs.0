Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144978BEE
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 16:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745943630; cv=none; b=Yaba+L2bV6zp2aBsn5Q1KuI/5OQgTkYShk6N4hx15QQI2cOC1SR612t6ZT9O/IolRIPShgyK1CoiIQnCtSC47U8rxQBzBhf6cCgKylcLxnPWLJnP36gnMKy6qvP4es1drEq8Fn0YDeKhLxa+XDK9xau03iq9mS/qShwhei8CDiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745943630; c=relaxed/simple;
	bh=avDUL9osy76tEbsx8E6KS4YJn2RDPkgXuVhgj0i8qlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IAOzb9KEmRQphxPvfTaeX17SrkBmvVs81wgRx/UXteHIvGDS/KtxJkPGRgY2aPuP2yWaIdoI6airBMdbfG3L5+1UyeaUggxI0/sdFSTpSE5HYx+VqLQdrql1JYaCCO0ZkJeebhoTRHcatxUqFTM0zGWX+2BbDqFlh3Aw6ceJWuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MYitToqh; arc=none smtp.client-ip=209.85.208.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MYitToqh"
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3105ef2a08dso58676651fa.0
        for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 09:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745943627; x=1746548427; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uid5tg2WKagkoZW8ahMEAIIKaurQ/GgeHOIGBZrjfMI=;
        b=MYitToqhH/pX5qyz08LuKX4f8jhxyhJHsHMsjLBLZS4yyEb0UrfuIHd7zoE0ikmXRM
         NpdPbQjS7f6MX5V/Q/9p6LekGQmeiTTeGkU+wHuYR1LNIIclSPwPeGbRiZ/AwJnJqpeL
         aK+HBojrNT1xqG4oEQEJXGlTAAFSZXlGTgnivaCAA45z4JVWYXEq/iosW4xQhYbFgnqk
         F4VIgmo3e0hNY1gwTzEk+/cIkc6E/Wco3WzLU94Uw42jpaNcenJ5Riw7MgFzOIa/tB0/
         KJQ2sUWqo0f4j1x5J8jqtgfxMkSsVWWd4921pLHqEGmELdRLRVJ2M78MftcjY3no/8fI
         1+8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745943627; x=1746548427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uid5tg2WKagkoZW8ahMEAIIKaurQ/GgeHOIGBZrjfMI=;
        b=esTcrV08vf+pf3Cq2C5pYE5xMNEQ/YzzkV4xIyayEnrGvdoju1PffkpMZPJMz6NqAJ
         1o3fQEkEHWAgwwYq7btkfn97qPFhVK+dndnmTnteEUuKQJRZMPnivYYJxYmPj3jnKqDC
         MsrdeM27zrZfEL91YjdD8XnRkWH7Z7+HDdqCSixvdukTumqp76aAxNec8R/zRZddkvSR
         bvx2trsUhkUZ3sIHMgwa7BGa5IpKNN5IdSeml00D2ud1Lw9kHwmiQbhUUOhO01JjaflU
         cy6ZXpwtLEngNHm3dh8yLdhq/NW+ig71MnHA++JtNJEelTcbw50vgMbtVUXV2oEI+4oT
         TQUA==
X-Gm-Message-State: AOJu0Yzwnv33PF1aLVnysSd/7FFh0GYF6icGsL5RrSn4Ao75Nl0uP7Ph
	XL2/0UtpH34JGsQJz/cqS17rbnzX6TtaxcBoOaBIfRQe2LzqlW54ptsw5PjMXlEgTTxzhr7Jwd9
	4lvzFLyoEL49ZjbVfQcpz/YtI/smdIvC4
X-Gm-Gg: ASbGnctvfzmadIRayRHKUoG1xOq+eoedx1xzuSAKprHFuPAd4vuU8n7izJKlaqKxmQP
	VF+fPW7mdr7s+0pvsM8wqI3m+QFVkKWNJvlGYlR6hrVcmhch5VP4LeVWu8jclBaleWUALw2aNoB
	cJ6CzPe9Swvdw/pXuiYhhP1onFvu2kgjoZSgqLmHKY9/wbgdjU+mZvRaQi
X-Google-Smtp-Source: AGHT+IGcmzOe4ooum0VgSQDbgCwGIc6+9kCfQRumX2wBC7b8sYs0N4QmX6vP5KnX+x4vjdkQzw/VCnJ9lMzSMaHPjyM=
X-Received: by 2002:a2e:be06:0:b0:30b:d156:9e97 with SMTP id
 38308e7fff4ca-31d33ec36f6mr17449611fa.8.1745943626619; Tue, 29 Apr 2025
 09:20:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250430005915.5e1f3c82@deetop.local.jro.nz>
In-Reply-To: <20250430005915.5e1f3c82@deetop.local.jro.nz>
From: Steve French <smfrench@gmail.com>
Date: Tue, 29 Apr 2025 11:20:14 -0500
X-Gm-Features: ATxdqUFaAZeGlEEMhjAdhmuIw1kpGSjmwQ4WjCxKnWeTHLbLEGBpz-3jrYAtG7A
Message-ID: <CAH2r5mvi+N7w=EmzSgH9YxEEbDLn0HXZ8cni1PKC+3d6qaS4XA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix zero length for mkdir POSIX create context
To: Jethro Donaldson <devel@jro.nz>
Cc: linux-cifs@vger.kernel.org, pc@manguebit.com, 
	"Volker.Lendecke@sernet.de" <Volker.Lendecke@sernet.de>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.  I did verify that this fixes posix mkdir to ksmbd.  It
didn't fail to Samba with posix extensions because Samba didn't check
for the incorrect length field.   The fix also avoids another problem,
an rmmod crash.  See below.

I added Cc: stable, and added the patch to cifs-2.6.git for-next


[ 1249.919717] RIP: 0010:__slab_err+0x1d/0x30
[ 1249.919719] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 44
00 00 55 48 89 e5 e8 72 ff ff ff be 01 00 00 00 bf 05 00 00 00 e8 33
b2 1c 00 <0f> 0b 5d 31 f6 31 ff c3 cc cc cc cc 0f 1f 80 00 00 00 00 90
90 90
[ 1249.919721] RSP: 0018:ffffcf3041b0bab8 EFLAGS: 00010046
[ 1249.919723] RAX: 0000000000000000 RBX: ffffcf3041b0bb00 RCX: 00000000000=
00000
[ 1249.919724] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00000000000=
00000
[ 1249.919725] RBP: ffffcf3041b0bab8 R08: 0000000000000000 R09: 00000000000=
00000
[ 1249.919727] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8c1b664=
fed00
[ 1249.919728] R13: ffff8c1b9cda6600 R14: dead000000000122 R15: ffff8c1b9cd=
a6600
[ 1249.919729] FS:  00007d4b43e26080(0000) GS:ffff8c2312c9b000(0000)
knlGS:0000000000000000
[ 1249.919730] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1249.919732] CR2: 0000634aa6374a88 CR3: 00000002b21fe006 CR4: 00000000003=
726f0
[ 1249.919733] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000000=
00000
[ 1249.919734] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000000=
00400
[ 1249.919735] Call Trace:
[ 1249.919737]  <TASK>
[ 1249.919739]  free_partial.cold+0x137/0x191
[ 1249.919743]  __kmem_cache_shutdown+0x46/0xa0
[ 1249.919746]  kmem_cache_destroy+0x3e/0x1c0
[ 1249.919750]  cifs_destroy_request_bufs+0x39/0x50 [cifs]
[ 1249.919814]  exit_cifs+0x3a/0xcc0 [cifs]
[ 1249.919873]  __do_sys_delete_module.isra.0+0x19d/0x2e0
[ 1249.919877]  __x64_sys_delete_module+0x12/0x20

On Tue, Apr 29, 2025 at 8:17=E2=80=AFAM Jethro Donaldson <devel@jro.nz> wro=
te:
>
> smb: client: fix zero length for mkdir POSIX create context
>
> SMB create requests issued via smb311_posix_mkdir() have an incorrect
> length of zero bytes for the POSIX create context data. A ksmbd server
> rejects such requests and logs "cli req too short" causing mkdir to fail
> with "invalid argument" on the client side.
>
> Inspection of packets sent by cifs.ko using wireshark show valid data for
> the SMB2_POSIX_CREATE_CONTEXT is appended with the correct offset, but
> with an incorrect length of zero bytes. Fails with ksmbd+cifs.ko only as
> Windows server/client does not use POSIX extensions.
>
> Fix smb311_posix_mkdir() to set req->CreateContextsLength as part of
> appending the POSIX creation context to the request.
>
> Signed-off-by: Jethro Donaldson <devel@jro.nz>
> ---
>
> Tested as far as mkdir now works as expected.
>
> Patch is against stable tree at v6.14.4 tag (first patch - unsure if I've
> correctly done the base-commit thing, sorry).
>
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 163b8fea47e8..e7118501fdcc 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -2920,6 +2920,7 @@ int smb311_posix_mkdir(const unsigned int xid, stru=
ct inode *inode,
>                 req->CreateContextsOffset =3D cpu_to_le32(
>                         sizeof(struct smb2_create_req) +
>                         iov[1].iov_len);
> +               le32_add_cpu(&req->CreateContextsLength, iov[n_iov-1].iov=
_len);
>                 pc_buf =3D iov[n_iov-1].iov_base;
>         }
>
>
> base-commit: ea061bad207e1ba693b5488ba64c663f7ca03f50
> --
> 2.49.0
>


--=20
Thanks,

Steve
