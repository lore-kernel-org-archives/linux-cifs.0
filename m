Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BB99221FCC
	for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 04:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764044209; cv=none; b=Au+QWWwDIktcz7Ra4i+g1RpJwMXxnj9tKYcJ/ofKm4L+U9EgOhho5qrZdRi8yTK+UyQKx67uhYCoXQECXn3XUb9J3MDODKid/picwAOljsZ95qL5CiqhufwZdEg78TPpHkjBii34ETNGOvmm0q9lJUjlisZ9Kiw4czR1gbFOGVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764044209; c=relaxed/simple;
	bh=NeGsHXXqkQBhjBRMCMNYyKEJl2UrV7eEIZSrvpIe4QA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ar+93gWbyBISJrUn7S8/MYkZeTkNT/pfGztAlGN3fWXJJD4CN2uYVeToKboXjI0m2TvzTMAmGI0n4gvfZbzb24OM6RL3B4njKwcNw48sNGEZBbI7d+kpLq923fN6m8QXzxAFUoaP52GcWF/VPKpsZQ1mySRWibR8aOvOZarMB4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ys6F+Th1; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ys6F+Th1"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8843ebf2facso70818106d6.1
        for <linux-cifs@vger.kernel.org>; Mon, 24 Nov 2025 20:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764044205; x=1764649005; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rHxT7dW0oNeC3uXtloBt3o68++L2zXJqZdUBfY79wO4=;
        b=Ys6F+Th11iSf1u9WqzWLrr3A1qMHaQtcr3NdCKF2Q2E7f907XuT/5Pj+ebtxUXB/Bj
         vGJoWjpGd/t6zOWT7GR5JK7Fa/z0/b/wQcfzMvoNyRRyL4hS5oVLxjU9jjfU26H6sscX
         n0G5Z07zJbnNRkK8pFQU82jw0aqFVLugODqXEdlwu8cng+o+p2Mib9HitRL6F5Opdgk1
         3i+tXvFMJIyoU6gsfFjLgJ4mXXdNgYypHaMUWlHb0sfW/16WLqb83sVVAw4TmiJ5aVfW
         z7AOHrB1WpSc4tH/11xm0L/i7gyRhkF8nmroCDgVF7tcIboCT9RBCvXG8T8tlLw1IALq
         dnqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764044205; x=1764649005;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rHxT7dW0oNeC3uXtloBt3o68++L2zXJqZdUBfY79wO4=;
        b=w0d7S2cMcuBXcATLZIfIjCSg/NkyE3HLvTxiaP8ICT5oQMEgXB3VUWGfF3qc56gnKq
         0I2qmnCEFKypbn9q67QluM58/A/ZQcChCYQceWd98mCUDaHpOzPo1YlJ8RW+EHP2eOeM
         h320Aew1kUqKKHmrS/OT5aCazH64ofTMM+AL0OdyEastqg0AubrPkPHSpeuxiCP+SciB
         4/MDkQS8rxPLJ9N5bvMXVvXVEFGRUj/6Lm6e+KQD02eojR3uYaEpNkS2Qc+Zd3cqpF1f
         jNNh1cvPIkdNWrNrwYa/Wpa+w8trdf15RBsS9IA0oyED43hW/nUw1mBh8ANZAroVCHTX
         Ue4g==
X-Forwarded-Encrypted: i=1; AJvYcCWDCbfFc2lZnoXsX+ioobK+l5XTp3/JJvL1WY1SB3tfq5sJUGLI6aWKb7Wmxa9zt4QpNj7pZZ4wso9c@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd/5x8M4ZMKKX0Qi0i7NO5dhoIVfaCKT43/pQKAoyINSwxUrqW
	QjeLt38DiHLbIvyJ7OwyEbHfP67mDYzzhHKLaIQDY2pQd/aj52EQ+AXg2phz2cgUfMBmCls5lyw
	AUpTq1+JfkXH34R7JTrud6NQ0ELWbMP4=
X-Gm-Gg: ASbGncsjOQpd3425NCb8cSvIAJeLPgsTc4x9kakVwWxbfzYs+bmQOs+O7nVznuV21Yf
	zhg9nCXGCk0ah9QhujMfoGTW17lj7bogZGTh++3ohk4P9Leg9fcc1ysEPMkfex46UEPSTDx8nE1
	OkMJwRhq8x4O0Xatc9KWqLSkmJJ+BM3me/s0QUeIH/WJ9bolNDs7GrNPLCemcd/OAGPMAzR9hdw
	DudfW0xrLJ5RiEZmyfm5afpzAyMvojMOnrm9X8RDao9ScuDsdpbp39VX8kK3ytt7lzSe+RsNXTg
	MeET8zXI6BtYgYoWO9zxEbW+IJzqVavq3vNGGI7bDrXFPfAsOA/iE5XagNPfQF6ME2sglado/15
	Om1tbg1bQrE+JPPpJRvIAb984RdxUGpJBNm0zZQj6x9R55hO5jr9woSS8aW/xhgLIZx8uaBh8l0
	Qhxm8mKP10
X-Google-Smtp-Source: AGHT+IFbO/6EFAorrW1zgGw6rlA4h/XKkcBaBAXDf2HlzTpoasTjL7792zKktcesPTVdmvhPTX9BVupPDrwO4lcSOnU=
X-Received: by 2002:a05:6214:3a8c:b0:882:4e18:a7bd with SMTP id
 6a1803df08f44-8847c53b629mr226318906d6.62.1764044205093; Mon, 24 Nov 2025
 20:16:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124200036.1582605-1-pc@manguebit.org>
In-Reply-To: <20251124200036.1582605-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 24 Nov 2025 22:16:33 -0600
X-Gm-Features: AWmQ_bkxZIT6q5NRZ0g4gnM85LcXBIkn7fMGtKAwa-lCe9Ns1o21md6Nwp6AddE
Message-ID: <CAH2r5mttOuyQKEDWjv6hEDeytW2GFzMtFvLO+kNNBJC1vu9m4g@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix memory leak in cifs_construct_tcon()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Jay Shin <jaeshin@redhat.com>, stable@vger.kernel.org, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next pending additional review/testing

On Mon, Nov 24, 2025 at 2:00=E2=80=AFPM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> When having a multiuser mount with domain=3D specified and using
> cifscreds, cifs_set_cifscreds() will end up setting @ctx->domainname,
> so it needs to be freed before leaving cifs_construct_tcon().
>
> This fixes the following memory leak reported by kmemleak:
>
>   mount.cifs //srv/share /mnt -o domain=3DZELDA,multiuser,...
>   su - testuser
>   cifscreds add -d ZELDA -u testuser
>   ...
>   ls /mnt/1
>   ...
>   umount /mnt
>   echo scan > /sys/kernel/debug/kmemleak
>   cat /sys/kernel/debug/kmemleak
>   unreferenced object 0xffff8881203c3f08 (size 8):
>     comm "ls", pid 5060, jiffies 4307222943
>     hex dump (first 8 bytes):
>       5a 45 4c 44 41 00 cc cc                          ZELDA...
>     backtrace (crc d109a8cf):
>       __kmalloc_node_track_caller_noprof+0x572/0x710
>       kstrdup+0x3a/0x70
>       cifs_sb_tlink+0x1209/0x1770 [cifs]
>       cifs_get_fattr+0xe1/0xf50 [cifs]
>       cifs_get_inode_info+0xb5/0x240 [cifs]
>       cifs_revalidate_dentry_attr+0x2d1/0x470 [cifs]
>       cifs_getattr+0x28e/0x450 [cifs]
>       vfs_getattr_nosec+0x126/0x180
>       vfs_statx+0xf6/0x220
>       do_statx+0xab/0x110
>       __x64_sys_statx+0xd5/0x130
>       do_syscall_64+0xbb/0x380
>       entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Fixes: f2aee329a68f ("cifs: set domainName when a domain-key is used in m=
ultiuser")
> Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Cc: Jay Shin <jaeshin@redhat.com>
> Cc: stable@vger.kernel.org
> Cc: linux-cifs@vger.kernel.org
> ---
>  fs/smb/client/connect.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index 55cb4b0cbd48..2f94d93b95e9 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -4451,6 +4451,7 @@ cifs_construct_tcon(struct cifs_sb_info *cifs_sb, k=
uid_t fsuid)
>
>  out:
>         kfree(ctx->username);
> +       kfree(ctx->domainname);
>         kfree_sensitive(ctx->password);
>         kfree(origin_fullpath);
>         kfree(ctx);
> --
> 2.51.1
>


--=20
Thanks,

Steve
