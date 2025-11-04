Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A56330D2F
	for <linux-cifs@vger.kernel.org>; Tue,  4 Nov 2025 14:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762268330; cv=none; b=YEhwh+Zkk+Go0uiv73WIDUPMZwgyPqUFEeA4xDG2wc8VgX+Fk4mLlpsX5JzrtFGhcTTwlPDxG4J37Zoj5Rb4amk+KcpXZoew6fCJGdkng5vQS/BdhUBIFIr4bdBsG1V6SghZVlDtxVn+usnBZEH7Y+rGjGAVrUpjK/Gwe5qjl8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762268330; c=relaxed/simple;
	bh=94UsKBB7bqSUV43m5gD8DJDmQkw9RXyDajmLn9ufiFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kbCWDC6u7rK+xOJeqvRPl10Nu8j/i4TgwW72MQ3P1AItBhuJ8k4OVOmXTY0KamSeaOg/HdxdhcSUmDFsXn9k2C12M72bhwNGwV8GiZysBIBuWGHsrfdVMgjonuEjHuj8ZyttBfW2NIxgxqpgcdyDlmUTQVCYG47/Gu0nZm2dVGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZEfVFMD; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZEfVFMD"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-880499b2bc7so27980076d6.3
        for <linux-cifs@vger.kernel.org>; Tue, 04 Nov 2025 06:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762268327; x=1762873127; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w6+pl9mXIXMDyMC70AAiyPBz/Tpkb7DtSZ3NwKSsSlU=;
        b=CZEfVFMDlFCTsl0kNRy6Sb9DBAcuUYRYVQw99IlNbh7cjdiiD9UhokzyNrTncXEtPv
         HyO1ZjMBH7SHOownHEnCjGuwpZ29yIr+/rTvz92BpPXWLt69vGmrkXkX4WNcP3pUTsKk
         qI5iSWmyCjQpdElUxqj8IEvSplPuQYDO/PyhLUjH8ox5qSNNDeyBIpS0TdmYTWGICvbE
         imlcy7fjtGeEjseWaWI9a/9e5ue9HclaJpI33+8HSSwYbsNM0VvY9lkbJbKW++csiWfT
         HR1QZBhXyb8Ske4xZiz7YG6Rvr6F/EVYll6IL4wYgAZ4sGxDI4tL19jqWPGAl0pwXQhQ
         8iqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762268327; x=1762873127;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6+pl9mXIXMDyMC70AAiyPBz/Tpkb7DtSZ3NwKSsSlU=;
        b=whVh0ebVH2F5yprev7PsK0NUHwxgl8RWHFudVIXlZdpDoZdYyisgjZu71oXqgIs1GH
         wi/A16eGbVos2v4AamNO5xENMT1FVKhdzM4jDBX+kR6q4vQzdRPeo/YhYD+AGQlZAAiU
         Gsrn2ojyEOLGv5LpR+2VzrAl8z2wwrEHPb3OxhITgaNXmKtp+SuO4J9JVAkv+CkZCxZZ
         nifjhj6hWVni27ajyHs9YVhaJYAfIhSKO4755vL9RhAioIqdpU3aqIB7COiu2lWXsdf+
         0kfcVmEnAg1HKgcheFqAQPJwcE3/z++Y5s4i0rsAGSyy2hRD1FSkArLX0nSArpoQt6Te
         9KGA==
X-Forwarded-Encrypted: i=1; AJvYcCX60D9u4p0Vklej+/KNfVLgDHWy9k//GWGTCWumjkhZNm9VL37Rj3u4uvkz9JuwFwZGaH0daBG63pyE@vger.kernel.org
X-Gm-Message-State: AOJu0Yz2QrXrqIKTG3BDWNqtx3PrIdvpoZYX90Cx3XlKPUpQ65MY+YoR
	jChiCVJSFOOFBzuyj1kOhuUjyzgRyDbr66MyzQ5lhxVr+7Ern15K2u5nOWWUAES2GFle2L2ecUA
	pX5pwS3lUStNRhb8biQTXbpuHPBsWjDo=
X-Gm-Gg: ASbGncvvhFyF4NbbNbwPcModFG2HsQNOb4ib6w5OvdFL/Rbqq3v7XC5voRhYHw4Ljqu
	WQN9TIq1/2l45lUjR9hP5u6F4CU2VzLHhERqMNIsdJGxWF+oYriJCwWcQfw2OVE3ewsvLi9U/31
	dDAbng1ukAVBKaG7s/CpHF76ojSlqzb4zgvaOxsB5QgIP68Px/QR0faelq/u2G9zBTdYO9pp9a6
	nqUMIj/qoyLp+1DTAIgrJDJiEAML65B7O6b8knnA9Eh7LGBTa8yKttTuo5MQPt/HxE8MUhO7sTL
	qoe3/mC6Yq5SoG8xHKuFxYk2z5gurCuWLdp7t1GE6AnH4Hhs0RDSJHlz6RR3WgEFsOj3Fk6nwYv
	Nf39W0ariWh8Ks5vD6ojqoQOW32f4Y2QlNIpN4HQHY9C3HgOWzJl6eEgBHFvb0ViwWIGfLmusPi
	0=
X-Google-Smtp-Source: AGHT+IE26lQc/ssMxiJh+g85ieX8DpjbFGe3JavpmPdg5zXKwA+xMGsTmHbajpceQTuz5YT/Fta+pHLPQ5lzLeAu6tw=
X-Received: by 2002:a05:6214:5093:b0:87c:262a:726e with SMTP id
 6a1803df08f44-8802f4ea4efmr190651056d6.51.1762268326745; Tue, 04 Nov 2025
 06:58:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103225255.908859-1-henrique.carvalho@suse.com>
In-Reply-To: <20251103225255.908859-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 4 Nov 2025 08:58:34 -0600
X-Gm-Features: AWmQ_bn6_xwuA56u3GINAJXJ0E4AkFCU91DJjiWgzRKFFvaBk5r3e4ueE51lfLw
Message-ID: <CAH2r5mtyiFnGTSppK3Yc66OTU8KO+p_OGf+KH0MsAD0JWpUMxQ@mail.gmail.com>
Subject: Re: [PATCH v4] smb: client: fix potential UAF in smb2_close_cached_fid()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: pc@manguebit.org, ronniesahlberg@gmail.com, sprasad@microsoft.com, 
	tom@talpey.com, bharathsm@microsoft.com, ematsumiya@suse.de, 
	jaeshin@redhat.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Added to for-next . thx

On Mon, Nov 3, 2025 at 5:00=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> find_or_create_cached_dir() could grab a new reference after kref_put()
> had seen the refcount drop to zero but before cfid_list_lock is acquired
> in smb2_close_cached_fid(), leading to use-after-free.
>
> Switch to kref_put_lock() so cfid_release() is called with
> cfid_list_lock held, closing that gap.
>
> Fixes: ebe98f1447bb ("cifs: enable caching of directories for which a lea=
se is held")
> Cc: stable@vger.kernel.org
> Reported-by: Jay Shin <jaeshin@redhat.com>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
> V3 -> V4: rebase, added Reviewed-by and Reported-by, add
> lockdep_assert_held in smb2_close_cached_fid, change commit subject (was
> "smb: client: fix race in smb2_close_cached_fid()") to clearly state the
> bug class (UAF)
> V2 -> V3: rebase, remove unneeded comments, modify commit subject
> V1 -> V2: kept the original function names and added __releases annotatio=
n
> to silence sparse warning
> ---
>  fs/smb/client/cached_dir.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index b8ac7b7faf61..018055fd2cdb 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -388,11 +388,11 @@ int open_cached_dir(unsigned int xid, struct cifs_t=
con *tcon,
>                          * lease. Release one here, and the second below.
>                          */
>                         cfid->has_lease =3D false;
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       close_cached_dir(cfid);
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         } else {
>                 *ret_cfid =3D cfid;
>                 atomic_inc(&tcon->num_remote_opens);
> @@ -438,12 +438,14 @@ int open_cached_dir_by_dentry(struct cifs_tcon *tco=
n,
>
>  static void
>  smb2_close_cached_fid(struct kref *ref)
> +__releases(&cfid->cfids->cfid_list_lock)
>  {
>         struct cached_fid *cfid =3D container_of(ref, struct cached_fid,
>                                                refcount);
>         int rc;
>
> -       spin_lock(&cfid->cfids->cfid_list_lock);
> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> +
>         if (cfid->on_list) {
>                 list_del(&cfid->entry);
>                 cfid->on_list =3D false;
> @@ -478,7 +480,7 @@ void drop_cached_dir_by_name(const unsigned int xid, =
struct cifs_tcon *tcon,
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->has_lease) {
>                 cfid->has_lease =3D false;
> -               kref_put(&cfid->refcount, smb2_close_cached_fid);
> +               close_cached_dir(cfid);
>         }
>         spin_unlock(&cfid->cfids->cfid_list_lock);
>         close_cached_dir(cfid);
> @@ -487,7 +489,7 @@ void drop_cached_dir_by_name(const unsigned int xid, =
struct cifs_tcon *tcon,
>
>  void close_cached_dir(struct cached_fid *cfid)
>  {
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfid=
s->cfid_list_lock);
>  }
>
>  /*
> @@ -596,7 +598,7 @@ cached_dir_offload_close(struct work_struct *work)
>
>         WARN_ON(cfid->on_list);
>
> -       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +       close_cached_dir(cfid);
>         cifs_put_tcon(tcon, netfs_trace_tcon_ref_put_cached_close);
>  }
>
> @@ -762,7 +764,7 @@ static void cfids_laundromat_worker(struct work_struc=
t *work)
>                          * Drop the ref-count from above, either the leas=
e-ref (if there
>                          * was one) or the extra one acquired.
>                          */
> -                       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +                       close_cached_dir(cfid);
>         }
>         queue_delayed_work(cfid_put_wq, &cfids->laundromat_work,
>                            dir_cache_timeout * HZ);
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
