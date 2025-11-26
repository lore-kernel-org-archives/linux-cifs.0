Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68943625
	for <linux-cifs@vger.kernel.org>; Wed, 26 Nov 2025 00:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764115321; cv=none; b=glfKd65dyadl3umDdtwXs4rzn34A5vDZKKk3ZKVcOK/idIug8Vh/eeejSjud8fZVSrchVsxE2ejHHW4hW4q2OlFb1QA9bzYoodYAclpJQwqPCcpIrWVvNCnJyYjgovrBl3SZQRBK9yRBOpcajioSr4pBFPfYVPEARpVaFXgM77I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764115321; c=relaxed/simple;
	bh=+XDXpyBZS1sTODjc5N9yid75ggmhqCspW2eKXF8HKtM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j2MwYdW3YYW35oWvVOKe5m8sWUvKnx58ew0mi7PEH2bGihEgbZgHk0pQS3kpIIBzgLEXb9f6sRr+psfOqwLAeSFISeMypGzGwgX6jMaAeP8QRE2htDNsT4Y8IKiQH3YLIpAsNT5K9KqGJzTngv9iqvZ6gajcdF/56aKVy1kr+Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nqKmY651; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nqKmY651"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-882399d60baso50490126d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 25 Nov 2025 16:01:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764115318; x=1764720118; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YaSSSTOEdPXrwvpfE69f6cHaGVAff9hm8HrlgzHFCzY=;
        b=nqKmY651V5PrFucjB22nupw4R0cfivCSxNTWadBAU5TetTKby8zT1IfkdBXxqmGVGR
         Lk9Rx0HW7NyVkqibDvQjQMpeEveSsRTdT66VF4E7mjrBsiE1QIC7KzDvDCcZGlAZ4+hG
         O47EuliwokqYi6fItKuwAsmOPSvoqN2aBMigWLS1irXPB2MI/eKxWERsTqnUuMfPFaZW
         NfiiAzpC1mVLFTpNvKeZJCMv7NQk5xgXhZTdAfA6ke5yJ7xsEWy1ogQF65ugBNdejLqV
         L2ESwHYCYfw1OC6wnl57zudSvrkdohcwAT3OsqzBIvyNBdls8U4puO+Ax+l3gHPu0nMx
         /9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764115318; x=1764720118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YaSSSTOEdPXrwvpfE69f6cHaGVAff9hm8HrlgzHFCzY=;
        b=aMwI6t7Ly6Xr1m9IHex/Sa40X7VSSAzGnSI62oQ8dOInqOcxH0/l19UmrInKnIHIPA
         StckdCMa9Y6N4dwDsnEqGERJ1frbuC2kKH2yUuPrg1F8VPKEYYmRtFH3+GdcHSgKyiNX
         4k34+G9J8MJLO6KyazPTHV7BTilavfi+rHarzLFGDMubrVkMwy8pgqQXnDTuqF4tibht
         FVCdhIUhPmATR82H42I5B4UpAgTya98pNEkajVmqh0lSeRbtr02NuxiwiSUVv64JKuxc
         L0YDpX1Jn9C2felKDpjMawAl/l+WwHs418IDdqn0w1guSo351XzSz3WZctsEiG04rYEj
         /q/g==
X-Forwarded-Encrypted: i=1; AJvYcCWqHpt3hTkGdivCSbyljLuHbKce2NnBywsNpdG4l+l72SgGLMrlDv8LxQqHRm9kt85FtRQ6X1Udk1fx@vger.kernel.org
X-Gm-Message-State: AOJu0YyR3YI9m1Pgx7b4MQhPd/hp3HzOIqmW2E7S4/T3upPn/snBWzQX
	CVoXFjosh7Ch1mRPxy2ENAggJcRSOIChi+b6hx267pRmW7C7MtsbzgY8BqjZgSSyKB6Z8klpDvA
	HkFZYyNf0W/vU1uLRu2WW3bnZnre1DMg=
X-Gm-Gg: ASbGnct7h4qka/20RnGBYXvffgyFocy9FmW4Z2qqKo4ONGgDfVagog2K9b/rH+tDZfz
	iB+I3jgKqea8/7WkRT5yHDd/LX93KLvW5wlp1TsB8A3d3ZjG8JoOI+aP87tK0kxzrQyEmabotzN
	71zrdeqJckKDzCNcrwt4zyFco/YE6UYlk2onmBX+uRvrQ0Htl4SsaPBnwMibz1iSq7L8NMltNza
	zX6a4Ct6aHEl8eoLj9sS/KB/iyibuCJSYLmp57OzESxphJuhYwcuUB1dBIHh1WvVe4MwtPCB91b
	eRFOK6qv9+n8Ol6dlMPBum0UcnTBdBxyhWIBJm6AUkdJn7GchpR9LpI/P7bq92E8xUKFLeX3ftz
	9SFhd+7NU2PWx92/wRwDAv9i3WzTv8PtX83d2NbwkEhITTD4mVFX9O4gtSJKOPk5UAKn4mtuxS1
	tcX1neH9r76A==
X-Google-Smtp-Source: AGHT+IH51IPA7dnzkdqYSZ2c+m1BcbaD/LmQCjY7kHofERYTrCSZPA7X/dmVToNHWejPwJa3FQbJ9WQmLnwdKf1qxmQ=
X-Received: by 2002:a05:6214:4a8a:b0:880:2b54:2b91 with SMTP id
 6a1803df08f44-8863af6db9fmr78215956d6.36.1764115318151; Tue, 25 Nov 2025
 16:01:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251124200036.1582605-1-pc@manguebit.org>
In-Reply-To: <20251124200036.1582605-1-pc@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 25 Nov 2025 18:01:44 -0600
X-Gm-Features: AWmQ_bmIm9Tjjon9TNUad3lCMSQ-ZuPZ7ZMab0WfcYrr7nwCar7ff1kHCRms3Zg
Message-ID: <CAH2r5mvMrSxG+qmUz80XXDR-x0XNukdpRBP88KuG0n9mJtxrbw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix memory leak in cifs_construct_tcon()
To: Paulo Alcantara <pc@manguebit.org>
Cc: Jay Shin <jaeshin@redhat.com>, stable@vger.kernel.org, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next and added RB from David Howells

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
