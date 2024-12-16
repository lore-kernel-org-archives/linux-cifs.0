Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864B21E412A
	for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 20:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734381788; cv=none; b=DNT7mK3mEG5uIDTN9BLmoOgMFMkYroz/phsV6GjcFcukpGHUyvUrI/NATlBQK4ptI3iPS1ECQ92SiQSpQegMyEMsgq5Khrw21XWfGy+T4DEtyEssqcWOTnXkcsmifN6iCpnHaNJ8+0U31u2xgg+Y8fcscOf6fYztJZzAcBCarwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734381788; c=relaxed/simple;
	bh=TVJNi5nyq5tLG1qjP8fziS3NtAysN5+4R5PQqBykDXs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PASGS4NmgKs7pc2CTpQQQYF5bZGKk2c1KTy4zQQFEJlX0AUXNkw2KJMMYNCK0MCfxTHnmzeXj14TM/K6i3s8q/2r9ADfGeppXmA20nVj9Fpk6/SLCjfOwEOY3sULMgsw+XPS844iLMcZbnV5zhxjyfYFr3tue8P/x7rzIcNe4IA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=StbyivAT; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="StbyivAT"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-53e399e3310so5444928e87.1
        for <linux-cifs@vger.kernel.org>; Mon, 16 Dec 2024 12:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734381785; x=1734986585; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGWxq/VDiU/+OeuzDwAfM9TbfhoKtUJupk3G6RL6dtw=;
        b=StbyivAT8fvB2CYfbWUCn2imZ3kWg0DEeU9hIaMav5GrPN7tBTJpOFWomVeHUuoOcY
         JC53hANBcGj+PUTIKQXRpxm7+0x0RoSfBrLzIiYJrYWOcdwP7I0DXYsC2zRgAqW/LhQL
         1M1sbzQKQqxuAL5/4EG69g8iusR169YVaqil9wSE0WNt0BjMlDNLVbCgwHMCslgvD9io
         swazWxpelXOWoUIZy2xXkHs2kWIPDBFdnZEqn7Q/RunvLAlnJZn6hsICJbJHtL6wYJoW
         AQjD2PLVgC1xwLrqqaP/A4Iqxfsfk0t1KpzcUqcmk1s1eu0NP3GzatlbW4NYW/ZTC3Vj
         UhAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734381785; x=1734986585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGWxq/VDiU/+OeuzDwAfM9TbfhoKtUJupk3G6RL6dtw=;
        b=Vt9ylrSxKUY9n3k2uKMYvZh7QTmTcGyuKKm5maf/GlbUJNGhaLO7MgUFymjj3+fXEX
         6EJJff1DKPUnXzrmxNd672abNkzUJFi4Vj3MtfWyqZvtzQK59MEVDS1G1NVvrRtOIhOR
         doVBpSv/WLrX3sXuk4Khq9kwudAXZfWagFr42YPmb2GgnVijJ0wACTJx3kKsyXjCwnLK
         0qdy92BL11Vv8ub1r3ZIK0yRyrsU+5EVaSZ8GtIyWfhf0Im6ekxZsGDrwHDXv4OEcmKS
         UI3A1SHM5dEcWBWC1STuIrXMWjCvBsJF6HhHy94sUYAVt/8RMR5Bs8qJeGZM5GluRbk5
         S0uQ==
X-Gm-Message-State: AOJu0YxjUmfdIojceiL/K5v3g20ha0XSNGTBYUsGkkx3Y3rcz73fKkHV
	KUt6ucfHtVugnjlPu/xaD337NMV9qULLXf5MlEM/upGsaIaqfdAWSt9/NIdkCFS5kmQuxg7RjhO
	X+CNRQ3U8Rr3A4HFHFJmsR6Gg4yI=
X-Gm-Gg: ASbGncv9K/2/Tq5TZVD5t8xaTO0p+gEphOzY5Af25PxQgAyqIyhbSIqYX4ZLe/B/0la
	Ts2vrHcBJRtHmsDb/PHG1GSMiNaV8q9h5lisHAz06SZGwli76LXJMiojz5JU/M3QxRwDwLb/f
X-Google-Smtp-Source: AGHT+IHE3gZptUZAC0teFklx8LqSL00Pohsp2yLOOSy1bu51Dyg9D8yWx6dtLdFuOHJyxsNAv5RjGOmVMulEavpLM/Y=
X-Received: by 2002:ac2:4c47:0:b0:53e:2bb0:4942 with SMTP id
 2adb3069b0e04-54099b6d640mr4625921e87.57.1734381784314; Mon, 16 Dec 2024
 12:43:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241216183936.5245-1-bharathsm@microsoft.com>
In-Reply-To: <20241216183936.5245-1-bharathsm@microsoft.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 16 Dec 2024 14:42:53 -0600
Message-ID: <CAH2r5mtCA-qeLmYZft8RNam5jBmDCt_9sOKTMb6-OEu0NaZSGQ@mail.gmail.com>
Subject: Re: [PATCH] smb: use macros instead of constants for leasekey size
 and default cifsattrs value
To: Bharath SM <bharathsm.hsk@gmail.com>
Cc: linux-cifs@vger.kernel.org, sfrench@samba.org, pc@manguebit.com, 
	sprasad@microsoft.com, Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Mon, Dec 16, 2024 at 12:39=E2=80=AFPM Bharath SM <bharathsm.hsk@gmail.co=
m> wrote:
>
> Replace default hardcoded value for cifsAttrs with ATTR_ARCHIVE macro
> Use SMB2_LEASE_KEY_SIZE macro for leasekey size in smb2_lease_break
>
> Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> ---
>  fs/smb/client/cifsfs.c  | 2 +-
>  fs/smb/client/smb2pdu.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cifsfs.c b/fs/smb/client/cifsfs.c
> index c9f9b6e97964..722be656f5dc 100644
> --- a/fs/smb/client/cifsfs.c
> +++ b/fs/smb/client/cifsfs.c
> @@ -398,7 +398,7 @@ cifs_alloc_inode(struct super_block *sb)
>         cifs_inode =3D alloc_inode_sb(sb, cifs_inode_cachep, GFP_KERNEL);
>         if (!cifs_inode)
>                 return NULL;
> -       cifs_inode->cifsAttrs =3D 0x20;   /* default */
> +       cifs_inode->cifsAttrs =3D ATTR_ARCHIVE;   /* default */
>         cifs_inode->time =3D 0;
>         /*
>          * Until the file is open and we have gotten oplock info back fro=
m the
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index 010eae9d6c47..c945b94318f8 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -6204,7 +6204,7 @@ SMB2_lease_break(const unsigned int xid, struct cif=
s_tcon *tcon,
>         req->StructureSize =3D cpu_to_le16(36);
>         total_len +=3D 12;
>
> -       memcpy(req->LeaseKey, lease_key, 16);
> +       memcpy(req->LeaseKey, lease_key, SMB2_LEASE_KEY_SIZE);
>         req->LeaseState =3D lease_state;
>
>         flags |=3D CIFS_NO_RSP_BUF;
> --
> 2.43.0
>
>


--=20
Thanks,

Steve
