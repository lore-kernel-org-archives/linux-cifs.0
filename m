Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88936438031
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783617651; cv=pass; b=XcTOjjeyNtesaSnyi2TJghaSaPd7MpJzNKN0zwH/j7Im1sPWX0gMCGYoEFCxOLN/Cu0aD9heZ5cIH6Vv6rZp4LCVSXuLCHm9kZMAyTUadomxcKX1U7YhZ2MCT/Y5B/oXHGWnYK1nH4pBibpBWVFSEm2YlO1Usobe34Rg+zUgQJE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783617651; c=relaxed/simple;
	bh=hZEcX9rblnHI1tsJplsNee/jZEe49yUqRXD5BZMzDas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iObnZWH0D1ERCOYa6069pTWcaLBHeYRl1uERupl0lpowwLLs1IOxO38czXtQqzU/CGXHURI1qWUR1ckdldyyWyBmFSRgnwLXxApZEoIz+0Wucv2Ccopde/Fo/jt8WUOrtB5M1FOQW3UbxjyUV7JICmsvvFVllq+dS0tqECB/0mw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hGO/Yqow; arc=pass smtp.client-ip=209.85.160.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGO/Yqow"
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c2808dbc3so147821cf.1
        for <linux-cifs@vger.kernel.org>; Thu, 09 Jul 2026 10:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783617646; cv=none;
        d=google.com; s=arc-20260327;
        b=FJ8YZMMMOSGm8omXBhZYsyCT9ehGqrQd7dV/9tf/z7CaXqCQ5AQFWMvug5MVoqoFvu
         yMHbC6GDKnkVnR9UQ69K/XQEQZRZBzzHfn3lnKfdxiThv+bT1AD5Ht3rZ+fgxpr0ebuX
         ZDY9o6QF3xZ5I0dppPkK7njxHzIFsp+924I3H6taXzVT6RA/XSezqPpUtEs3OCKf5TSV
         bxSedjU/bw7Q4ZAIWdBcpPjH2ML//RUkKpdgDPzrd85itNe3qcsNRoUfThDw7IzVctCg
         v9ROcaCsap3sWzVKbUeQj/XjCVaegN8tJCdlCO57Gh2V6g/wPMPp77GhCkye1RyTcDXh
         zKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=jQaRVb2grf2n8MZJwInN/ZiH3PD15ePDY6cdHPu1aO4=;
        fh=KST/QTVm/12g6Bb0gAS7mpWRlJ4hvYTI1hvC9FG95tE=;
        b=Q7pZnQOdr/Fr8qs/n3YWkJzFw0AFZx6P3Y7pkKr5/D9nxA9x5okNhlvaPoyo/Rlv6T
         mQOwety095A3ahNyGwWacQtf2yYucvy3YAJT1kK5L354+l9iY2iayg5J5/wiasCixcNg
         CjseHTq6nm+ZUe8g49MnQt8DtO+Ypzk/4jxkl1Z8eNnKWPRtoRyiGBRPHfotvLZEz3sw
         60sLX4L3AEIq2pJD6l9tI6GQb9dmcaCw8vsHI4NL/x2tLg1ldpT6DdH/ouYUX9zc0i0s
         eFugDXkqeMSRU9pz8SSD7C+TeerkiYxSXwaH9zf0y2F8VYcd7casbzZfOnlSMWQjRG6Z
         5EAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783617646; x=1784222446; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jQaRVb2grf2n8MZJwInN/ZiH3PD15ePDY6cdHPu1aO4=;
        b=hGO/Yqowmf+zfdOA3xkz0XnaQv9IVvY9bBvb7K1wrmz0BAb/00wVT4hLSJC3bD5xbt
         Zsgx7+nenuQdcPjghInQFPPlsC74wZsB4fW6ONEp7hKspjxomUpw6gJvzo4FEvmJ7zpA
         NVY4eXkDMcxvEVJLVNkBT44ZtLwzhGIbYrZ8TsWrfWzzO53Uf0TqyLeVYcaOL+yOJAmp
         vXacGI2LsJZkh2R2yhDc524gDPx1TOENsP5QltEcPL1O4tlHJYxqR9WhzMdIdnXQ2W8C
         p5CpAaQLsAE/rpkm5Z2Ih9nIsTnY1b3HNQJdk/XZCeD1JzePWnuEVH3XsW2ifmZM+Kxy
         xAqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783617646; x=1784222446;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jQaRVb2grf2n8MZJwInN/ZiH3PD15ePDY6cdHPu1aO4=;
        b=F/bQghKBmrjqyq5NLwV14D2Z6ttyTrZC+qypLiJZ62NcpREowcS/K/Bu6Z2cpl96ak
         aFTZAmlOL/nERvbxtieluSF/ynePQr09AOzT6eY+r06PPL+DYEVxF+i0By0/Xb5doa4R
         n4XfdGBlvtwGSjBf4e3IKJkE+0eLDXoW1899A2YzSlaniJ2n6BerT9yGq7P9pCSjei8O
         j7Cq0SGAnDy5pvJmpDBjRlNPmnowAANXolTCY3oqznbWHS2CdIhzSDxhGyHi/4WaYpYS
         hibQ/S2lqwit8nOfouvK5Iwagzzzrtiadshf+5Ubf5dwcpIGsxP6md6d9XW/c+hDehHd
         1ZLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrtlmFqR5xjO+wJ9ahnL0I1OLchOre78nE/Hhj52mXJRVNj8sKamjQiigRnSZnVtASw0GjrgARQdgNU@vger.kernel.org
X-Gm-Message-State: AOJu0Ywd8L3cVmv98VM0QD96UGw4dGoh4UGyfJ9yrlGzFFHDp3LwIKRk
	5bpiss0kfID9rCTgw5U4LuJalQqkawT00/zYe6BDxk4KbUe+k4FCbuOZwq0T4ZREfa5CVheIgkA
	9TI9zDhfkVfid8dmZDs26F0JyJG7Nfn8=
X-Gm-Gg: AfdE7cnt6FCMCI4Q8TRx657muWuS7WxIeunFwfKyBIAx2UApVjDnwit1wdSo2WaNGxh
	JtRfzfZETrRQdmQ1WB5u9W0xrSlM0Gw4Kob73YKW/wQlGaLctqchSPpXHxXEtpNdfLR0lah9i2K
	qZOPL5kQ8HDSG21lQCEY6btxmgqC8gY+xwiDoVqmcqZ3p3vK4Cc5QuadvMVi5e8fhn24j8J10SR
	IevGdhdDfWwPldGeSWYaLM+ifH6coK+k3xfpEdFVrsAi6YSQZocBzZDq40gekPiSEy729Suxmc9
	2mAckIoEFRau2enLXkXzlRZ92EO/6zJu4pHk2g65ZhvjWQc8/d74JSgwxBC0gp5VPtLz5Kp8GE2
	yjKM2OYlmaFN4M+DL01ukM3HnVKOZd+dWef5WvBo/Gv+T2nHWkD/QuG5hX52OQh5H9RxmQ+a/kU
	QHkR+lupmOcfs=
X-Received: by 2002:a05:622a:5812:b0:51c:241f:a6ee with SMTP id
 d75a77b69052e-51c8b3f5885mr82413791cf.62.1783617645460; Thu, 09 Jul 2026
 10:20:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260709155440.2132459-3-doebel@amazon.de>
In-Reply-To: <20260709155440.2132459-3-doebel@amazon.de>
From: Steve French <smfrench@gmail.com>
Date: Thu, 9 Jul 2026 12:20:33 -0500
X-Gm-Features: AUfX_mxl_KFuVChnk7HcmXkZiK3KIvyhwjAH-myKz4uegSqaarxusCibAKEfqT4
Message-ID: <CAH2r5msvEGdEJvyV5sWcZjQ0SjMOwXP_Ad4eKN7etHtXS1vwbA@mail.gmail.com>
Subject: Re: [PATCH] smb: client: set SB_I_NODEV to prevent device node injection
To: Bjoern Doebel <doebel@amazon.de>
Cc: Paulo Alcantara <pc@manguebit.org>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, samba-technical@lists.samba.org, 
	stable@vger.kernel.org, nmanthey@amazon.de, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Setting SB_I_NODEV is apparently not done for any remote filesystems,
and AI search confirmed that it probably isn't a good idea to set it
for remote fs.  It is more of a thing in pseudofilesystems and not
needed for network filesystems.

e.g.

"Is there any benefit to setting SB_I_NODEV?

Today, probably not.If you grep the kernel, you'll find SB_I_NODEV is
used in only a handful of places, and those places generally involve
pseudo-filesystems or internal VFS assumptions rather than remote
storage.  Setting it on CIFS or NFS is unlikely to change behavior,
because those filesystems have worked correctly for decades without
it. Most remote filesystems don't set s_iflags because almost none of
the SB_I_* flags are intended as generic filesystem capability flags.
They're mostly internal VFS state, and SB_I_NODEV in particular has a
very specific purpose.  SB_I_NODEV does not mean "this filesystem
contains no device nodes." It means something closer to:  This
superblock is not associated with a block device.
or more precisely: The VFS should not expect a backing struct
block_device for this superblock."

Has something changed?  How did this question about SB_I_NODEV come up?

On Thu, Jul 9, 2026 at 11:05=E2=80=AFAM Bjoern Doebel <doebel@amazon.de> wr=
ote:
>
> From: Norbert Manthey <nmanthey@amazon.de>
>
> Set SB_I_NODEV on the superblock by default for CIFS mounts. This is
> consistent with how other filesystems handle untrusted remote content
> and prevents the server side from injecting device nodes on the client.
>
> Fixes: 2e4564b31b645 ("smb3: add support for stat of WSL reparse points f=
or special file types")
> Signed-off-by: Norbert Manthey <nmanthey@amazon.de>
> Assisted-by: Kiro:claude-opus-4.6
> Cc: stable@vger.kernel.org
> ---
>  fs/smb/client/cifsfs.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index ea4fc0fa68cac..35eee2f9899d5 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -208,6 +208,9 @@ cifs_read_super(struct super_block *sb)
>         if (sbflags & CIFS_MOUNT_POSIXACL)
>                 sb->s_flags |=3D SB_POSIXACL;
>
> +       /* Prevent device node opens from remote filesystem by default */
> +       sb->s_iflags |=3D SB_I_NODEV;
> +
>         if (tcon->snapshot_time)
>                 sb->s_flags |=3D SB_RDONLY;
>
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
