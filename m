Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6B7EADD
	for <linux-cifs@vger.kernel.org>; Mon, 26 Feb 2024 05:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708924455; cv=none; b=HPGILadLN683ijND8mtn1IUcSFmCrNCp+qayEtAok1YyG5Bwfr9RzkgoYRj7/lSBE765Ed82QMVKT5hAjGo/LwLC/qNk0vW0FgVLBhcskP7ZBOQ8cJuByXFqYHCzowG7XgC2/UI+bw7+BwLtOEUiclzQ95crM9gp7wNHjgqTQnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708924455; c=relaxed/simple;
	bh=ewSEZzAFRNacusSYSNEl7d9XknK38Ah9+CH3SeLBlpI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmcvX+5SbQtnxBuZz/fJhkT3HfwReic2UV+x2buiT2abE4grC38goj2VYfmDIjjJuo3sfjTujao+Zvn+5kEkt1vkSZByLFkq2I/X93GkXKEp8Pdxj7K06pmFj/QMLeNksuZTY2wrxLBl6URfr81NHRIXC/9kj7ghERObNK90msM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KkTD+gZ6; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KkTD+gZ6"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-512b700c8ebso3358441e87.0
        for <linux-cifs@vger.kernel.org>; Sun, 25 Feb 2024 21:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708924452; x=1709529252; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OabW5s8KvNhiOMg5Dyvun0ZV1OXYn36recY6yBYC0mA=;
        b=KkTD+gZ6D52qF+2jRdC1EfOZ3xMyzCmvFfCMcpWl96Q76flwadzaqv8JCr9XQhvoKB
         phiUMhKAZjujBWmvzXNr5Zykeg8dZHt/05Ojj9iSKgFwQef/Z1yf0bRzf4I920Iw6gTy
         HY+wvtmZQrVz9IkyJKWsltuMQDHOUyLSTcwWt7BJCTd6hdmHpOuOoOKOO5MERjFw0ICq
         BY3UAHasFwJR00OwskD2DSW0u0A8AGWdwQ+3UdaQyJkhUODHWO7Fm7x3EsvcgV1W3Nt0
         hm+4AP1/cbuj725de9XRYqH/5ayOJisY4k1gALGH0jkAorpZ/RjDO77EsLeJe+u37vNI
         NpVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708924452; x=1709529252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OabW5s8KvNhiOMg5Dyvun0ZV1OXYn36recY6yBYC0mA=;
        b=uCm0srNHGqrO/ZLhqKvyeLTK5ViZwSshXTedFdkDBpVXEoXmAaHwirjTBgNAtY5Zav
         fbUM8wyDzXzu4M1fW0W/3jPkPdYj5+gd8WwCPcwnTznbFbgqxV8JEO7gpeKkJwacj89l
         PYrf1FOvlXtEXqpihS4KxTohZ8PEEr0Lq0+ihNaeiDuN5AZsNlNuuIbEI6/14Td6T4UJ
         1sOvDLx7wbcsaCmJyDWcAGs7bqlkSSWKNxA3Ux9Yzge4d+k9xrKb0ggi+wbFjBaVf4K8
         Yw5V2vwUd1ni/5x0NjbP4PBCPREHvQxfmHFt81sz2zhPiZeVSjtf5C8KiLzjO+dT7eER
         Bl9A==
X-Forwarded-Encrypted: i=1; AJvYcCXqWPEVMJ8cDYKQi3LxwE+880d/AsBtCrR+XFuQUHvfj5jhzdZyXda2k0Oryk742GruaCUMFdrPknGoA7LDl2W8GF08cyaQonfInA==
X-Gm-Message-State: AOJu0Yzd/V3fJ+EgZ0QdMsjBy+xvvfCMhWj5GLG/ObrpCRhghaC6NYC3
	RbBw41IwAiw9kBYBiWSQFr8aUcPeQQm2PuUvAviIl3DKJBzXLlGz49WxOn5lqAKD6Z4O+L1Eyr/
	kQ3x9ZsSfFueXUpzUGkyElMP+dMs=
X-Google-Smtp-Source: AGHT+IF3Zcyfw7cJqQuMBiuBx7ojt7Wz5K+qsqrcjgf4G2h+u7Fo567e58Zh8z7F4UIc4vLjyndCbAlsH3Q62PinLZs=
X-Received: by 2002:ac2:4344:0:b0:512:bebf:1a with SMTP id o4-20020ac24344000000b00512bebf001amr3922608lfl.57.1708924451413;
 Sun, 25 Feb 2024 21:14:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240226045010.30908-1-bharathsm@microsoft.com>
In-Reply-To: <20240226045010.30908-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Sun, 25 Feb 2024 23:13:59 -0600
Message-ID: <CAH2r5msYJncggqkeNQRceNhcnQ1_BdYiQw9mw7fLogHfm8AySw@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent updating file size from server if we have a
 read/write lease
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: pc@cjr.nz, sfrench@samba.org, nspmangalore@gmail.com, tom@talpey.com, 
	linux-cifs@vger.kernel.org, bharathsm@microsoft.com, 
	ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

My only worry is that perhaps we should make it more narrow (ie only
when called from readdir ie cifs_prime_dcache()  rather than also
never updating it on query_info calls)

On Sun, Feb 25, 2024 at 10:50=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> In cases of large directories, the readdir operation may span multiple
> round trips to retrieve contents. This introduces a potential race
> condition in case of concurrent write and readdir operations. If the
> readdir operation initiates before a write has been processed by the
> server, it may update the file size attribute to an older value.
> Address this issue by avoiding file size updates from server when a
> read/write lease.
>
> Scenario:
> 1) process1: open dir xyz
> 2) process1: readdir instance 1 on xyz
> 3) process2: create file.txt for write
> 4) process2: write x bytes to file.txt
> 5) process2: close file.txt
> 6) process2: open file.txt for read
> 7) process1: readdir 2 - overwrites file.txt inode size to 0
> 8) process2: read contents of file.txt - bug, short read with 0 bytes
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/smb/client/file.c b/fs/smb/client/file.c
> index f2db4a1f81ad..e742d0d0e579 100644
> --- a/fs/smb/client/file.c
> +++ b/fs/smb/client/file.c
> @@ -2952,7 +2952,8 @@ bool is_size_safe_to_change(struct cifsInodeInfo *c=
ifsInode, __u64 end_of_file)
>         if (!cifsInode)
>                 return true;
>
> -       if (is_inode_writable(cifsInode)) {
> +       if (is_inode_writable(cifsInode) ||
> +                       ((cifsInode->oplock & CIFS_CACHE_RW_FLG) !=3D 0))=
 {
>                 /* This inode is open for write at least once */
>                 struct cifs_sb_info *cifs_sb;
>
> --
> 2.34.1
>


--
Thanks,

Steve
