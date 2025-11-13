Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E20E3587B9
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 18:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763058224; cv=none; b=iGDyP2SGe3AqTbmUODa8GnfMCUyb+sLVr9Zx/M4PXr1VF8xLVVhyleKgdwxZ1uHjrVVKhzgsWnfAId9q8OOeR6PSt5eCc93ASvgqjZTjDuys9NWZrYr2Fmi55Xaj5VbG2GjqhH9lsgcDwwWZYHn4riuCWWphCt+7dOIBYvIkN+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763058224; c=relaxed/simple;
	bh=TfyxQDPyG9RlrpfrAit8cCbYACScgPDyHiqpGiUGIuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jNOMBTepgW6Mkqby+e809ge9WZuN9ELt2y6U+LDprtXuvGokRKZUVFDRgDyzKHI6QhJ88B3RGHJ5Ed4PL9SmlOI6eCH04ARUtpOM1iv653rqGciWHUVZJIv5s9+Ye5w0neipKtlsdiyjKMQILYFb6RjC2n4ZENRTWNFPZWh5oi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DTU1DNZB; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DTU1DNZB"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4e88ed3a132so12254381cf.0
        for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 10:23:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763058222; x=1763663022; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uaIAd4e8JTxvgW3q1bwBKpq5ihy6Vs6M5hiCLjOMKdA=;
        b=DTU1DNZBtCwbb8Che51NJ5vbOELZ3En10c6+T6BWCxWYOWfom1oVOkKuMiuzW/Moeu
         XRFvlxIq/sWLyjBeAW1d5EpF/cFSnX6J96ymSC3Epj5mBw5YSwQj18yTLvLTuV2GX1uZ
         8BU119gWFrFJ1BwbnrKIEvpn8arTB9e4eQWVgVkuzdlJpKk0s7/JnB2FKP1FizkBOZKI
         VrH8oEu6+2ySEiSyQt01tcZ5+QabenW4PDKOFn7LSsK6198ccrUaWZm00vb6wE281qax
         wMUFrOlVACJeS8J4yKUSU0T53l1hRiu4fvg7pYm5Aa+kUBYZ7UIRxwufabxxP1YCReaf
         JiMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763058222; x=1763663022;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uaIAd4e8JTxvgW3q1bwBKpq5ihy6Vs6M5hiCLjOMKdA=;
        b=FnZpIUlwVm52xqUE9j3AlEii2vEAH5r1jQn+OHcMm7j3KK7dxm+IPAZelz3zHzIB4q
         WG1hYjMPqlNn3QQQ8NA5Y/KDa0CX2cU/CG6d3oUX3FOzP5lpN6C9QF4IbXiA3iyGJklq
         xKpUu1WUvI2KPqrbUb+5bA9Xak8IgzNkYb7Gc1MRn8oFkCXHbWKrEbAjAGQ7GDWb5ohU
         KkgPIHLSTq+FkU5IWpIl0U/P91nYb95hYNojozAE4zi6261tAwGqlUnPegt2yGIjUWWl
         LTVeUDAwYFrgMNPZraMuj/nHDwBALjBMIqUUX0xEfORNorz3osJneOqf6bzkVLAOtjSK
         zejA==
X-Forwarded-Encrypted: i=1; AJvYcCWi6Kcoh1nXtb7r3QdHqPFIwX1IeAW8eBbYyWoWsIDkw/WiOG2e1XIo/u544u0fhIEkYZLM2ttwgmOZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5qcZ6PmI1XIzHwWUe7JJxN+2AfjpdbYUJhjjnbgOF9dYdtpaD
	Bvk2QXygOxXkAwXzXhyVp0DUvfvLO+dc9Xo02+Gd8BepB9inyRdxh6EKHL5ZrUiv62IRWyhE3gi
	pJ01c9CPos56cV6/5YbV1HZe4CN6Snkk=
X-Gm-Gg: ASbGncuZhYnyepUd4sa+YrZNzBgryZvABuyfCosBS3ejvSyFIfGIgUtTHmwTnPt0rqC
	gi4/BeQFZ1cVgz6SzMwnED149S3AmpqMrrx1XMUFMR5xNP3UYI2u8IpsKCABKqO0LxSH+i0c2JH
	PzVACKakMkwkh5e4jQ++DW+bQoHlj2TahFhOqXAibu3gQsr7zrdI5n658uVD8bDKZy0HEifMx9v
	Im1BxSNMP7/fnnz/hEgwS4i5JM+uHYxw2yrE+Pxp6YTFoVgIpNElJY1PD+HwfkZvX6J9skbq7aE
	kmPk7qx5AB2SuQSYwIXdg/ASXO/jRYTdNtwzRNiqH0F0YgHGI91X/85L0gC6ruIVx2lPoRi4vuo
	6w1YP7cUWF/YRVSPBhotXGdC74NMDNhOWnRNiRx7noCBOvQ4qczuk/T4sYXny2a37O433qo+p6p
	U=
X-Google-Smtp-Source: AGHT+IHjLVLGClI+p6sSrzwg9hPEJpN+rMdCMeKdQeZt7jQOk39PzGCWdcj/PY/xiK7BUfOmwJQfiX3h2EBOEkIgNHc=
X-Received: by 2002:a05:622a:14a:b0:4b4:906b:d05d with SMTP id
 d75a77b69052e-4ede7095263mr54813231cf.29.1763058221917; Thu, 13 Nov 2025
 10:23:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113180913.3487809-1-henrique.carvalho@suse.com>
In-Reply-To: <20251113180913.3487809-1-henrique.carvalho@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Thu, 13 Nov 2025 12:23:30 -0600
X-Gm-Features: AWmQ_bk6Wk0Ly9MDhPCEGPVC9z7o3sh3WZ0r6OE9dDTbS3NoIRS7Zw92AwOVSxQ
Message-ID: <CAH2r5msYm6z9VdEUOqdJwd_xhK_3g2vBbw=wB9AO-EqyvrCHJw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: introduce close_cached_dir_locked()
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	ematsumiya@suse.de, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively applied to ksmbd-for-next pending additional reviews and testin=
g

On Thu, Nov 13, 2025 at 12:20=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Replace close_cached_dir() calls under cfid_list_lock with a new
> close_cached_dir_locked() variant that uses kref_put() instead of
> kref_put_lock() to avoid recursive locking when dropping references.
>
> While the existing code works if the refcount >=3D 2 invariant holds,
> this area has proven error-prone. Make deadlocks impossible and WARN
> on invariant violations.
>
> Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> ---
>  fs/smb/client/cached_dir.c | 41 +++++++++++++++++++++++++++++++++++---
>  1 file changed, 38 insertions(+), 3 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 018055fd2cdb..e3ea6fe7edb4 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -16,6 +16,7 @@ static struct cached_fid *init_cached_dir(const char *p=
ath);
>  static void free_cached_dir(struct cached_fid *cfid);
>  static void smb2_close_cached_fid(struct kref *ref);
>  static void cfids_laundromat_worker(struct work_struct *work);
> +static void close_cached_dir_locked(struct cached_fid *cfid);
>
>  struct cached_dir_dentry {
>         struct list_head entry;
> @@ -388,7 +389,7 @@ int open_cached_dir(unsigned int xid, struct cifs_tco=
n *tcon,
>                          * lease. Release one here, and the second below.
>                          */
>                         cfid->has_lease =3D false;
> -                       close_cached_dir(cfid);
> +                       close_cached_dir_locked(cfid);
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>
> @@ -480,18 +481,52 @@ void drop_cached_dir_by_name(const unsigned int xid=
, struct cifs_tcon *tcon,
>         spin_lock(&cfid->cfids->cfid_list_lock);
>         if (cfid->has_lease) {
>                 cfid->has_lease =3D false;
> -               close_cached_dir(cfid);
> +               close_cached_dir_locked(cfid);
>         }
>         spin_unlock(&cfid->cfids->cfid_list_lock);
>         close_cached_dir(cfid);
>  }
>
> -
> +/**
> + * close_cached_dir - drop a reference of a cached dir
> + *
> + * The release function will be called with cfid_list_lock held to remov=
e the
> + * cached dirs from the list before any other thread can take another @c=
fid
> + * ref. Must not be called with cfid_list_lock held; use
> + * close_cached_dir_locked() called instead.
> + *
> + * @cfid: cached dir
> + */
>  void close_cached_dir(struct cached_fid *cfid)
>  {
> +       lockdep_assert_not_held(&cfid->cfids->cfid_list_lock);
>         kref_put_lock(&cfid->refcount, smb2_close_cached_fid, &cfid->cfid=
s->cfid_list_lock);
>  }
>
> +/**
> + * close_cached_dir_locked - put a reference of a cached dir with
> + * cfid_list_lock held
> + *
> + * Calling close_cached_dir() with cfid_list_lock held has the potential=
 effect
> + * of causing a deadlock if the invariant of refcount >=3D 2 is false.
> + *
> + * This function is used in paths that hold cfid_list_lock and expect at=
 least
> + * two references. If that invariant is violated, WARNs and returns with=
out
> + * dropping a reference; the final put must still go through
> + * close_cached_dir().
> + *
> + * @cfid: cached dir
> + */
> +static void close_cached_dir_locked(struct cached_fid *cfid)
> +{
> +       lockdep_assert_held(&cfid->cfids->cfid_list_lock);
> +
> +       if (WARN_ON(kref_read(&cfid->refcount) < 2))
> +               return;
> +
> +       kref_put(&cfid->refcount, smb2_close_cached_fid);
> +}
> +
>  /*
>   * Called from cifs_kill_sb when we unmount a share
>   */
> --
> 2.50.1
>
>


--=20
Thanks,

Steve
