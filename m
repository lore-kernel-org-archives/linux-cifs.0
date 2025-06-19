Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AC8634
	for <linux-cifs@vger.kernel.org>; Thu, 19 Jun 2025 03:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750304223; cv=none; b=kfMdTTb7eMUPJkCKhczpd9ugqSJ1aVNfCILzO+EeWwW6SckPnRq3kk8oYMoFo5923wdFfw+OirCqN9Mjx5auHYYXo9TxNuZaROxWDfGh5QYfLLJHGnVKuk2IYvc+yOqhOchDWPyUMQ/vktIGH7LSZ78Xc00CTUO6CFEQTUV2zOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750304223; c=relaxed/simple;
	bh=C5eMBje9jYDRwYqJsWH7SrAV5uBdYG46z97z1y6dZfw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T8nneYrcBkWTfUpFz9ANaA/rYYj9mRdxFObFLeKFbhVX7lVIEQsn4e/r9uQ/AUxbuyfn1eGZmw0gq8YVWHW2B0s6L4oa3l/vcP6sm5EQuvNDo/UdXDes9tpw8uZ7UYMnQj5w8aD+omKvxnsu8XhBi0VtryvMkxKkmGSDm+jkoaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZT18Przm; arc=none smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZT18Przm"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-6f8aa9e6ffdso2801506d6.3
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jun 2025 20:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750304220; x=1750909020; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bBmbvA0xtke10wNQMefD1CFB0PPWLAXTf3SwAQUJOXs=;
        b=ZT18PrzmrOAAQx6GVTQ8CFxFCJU9OIXpwVWCfeAFacRLCakmWMFNXiTArrFhW1GoDr
         VzMFjUU1ocdMAH8eYz/tVaqC4B/R6ILy4KJZbfqUi5PW1zugsulGv8IORNKFw+YXqHSz
         bplZjVBUDKaOqiz0FZuPQNBwNmbGNTDdM0BLhkNDng/dD28LiDFrvxEeCH8y0PMFxf1e
         R31X2dA0h27NPDtyXw7mYvWkrux9W+wD20+RdVTvrolpfDFuxqMfHPVzO9wo78dop6C8
         YXJ55laIS0yFAuTNeX1EilYORwzk8v12rWZzlVFGklNHEVB1qIUxB9j9ulGzrCaP8dv5
         0/RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750304220; x=1750909020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bBmbvA0xtke10wNQMefD1CFB0PPWLAXTf3SwAQUJOXs=;
        b=jxmaFFoCQBn/TrXfvSZwAyhQvdQN9Id+SSia0D9YvOlXr19L96T2l3c5C6C+PremgX
         2dTSirYRMiyIs4KlWWXa3ZgIVqW42PAryWgufSsn3YA1b5e6EJMeTSnF3PqzoAI5k92L
         UKFQkTnu//EelxvIJdo5PnmnV+ru/PItYXY/90D0b9KVblBDvM+gaACiXpaYXUMd1Myb
         0wy4tk01bzRjmQRq3+gL1iM5FxfweUsgTCzANNo0HWxEx7HtZ4bPXM8BTGkpONoqQfEh
         24Ad0Dzf4dxvmujaIsNrTpqs2MR0kX35X8t2/TDSqv6ZvPLqtwIZA1+pjnrC0QYrq8jP
         Tojw==
X-Gm-Message-State: AOJu0YxTyly4Gx8eTJKXPTtNA8fOpuBwAyKC0K+87y5wrnk91E+ny+7E
	MGTcuRJCvVOMTf8rNWXoKdO8IcZxFzIj6pho7BT1B+/v8pLywg13yfnlngbtBAkJ9goSNGuKG3x
	O2nfjS6tkEdsXMubVH1fbES7R8HjykIEQJQ==
X-Gm-Gg: ASbGncv+ZU9n0UBmIfY+nGiKAxQ0ADOaB1Tk6tqSTzpQ3aJjfaE4pt7+Nb7F97GVOvy
	Kr2vQvl6U2NGPOd0Bnvl7n1H0H+upxUXyyMMWF45fus7eZJJ2acWzxi42ZUSaqkWGAJOsiNbY8g
	KuAr3IYVR3Dus4ZLWAbH0qd/J+tgau06Qlw0jSlzsboe6+zrGw9lfbZ91RMBcJ0SbPFcSxnBKyP
	2BQKg==
X-Google-Smtp-Source: AGHT+IGD9nYVL9aTMsAxvTREGKA4EswhH4EiSiqat9M73Lf3JzqtnFVoEa9KqHDwT6AqR4xuM4PpVtXW5a0Zk+WG5fM=
X-Received: by 2002:a05:6214:2024:b0:6e8:f3af:ed59 with SMTP id
 6a1803df08f44-6fb477703admr351246766d6.22.1750304220092; Wed, 18 Jun 2025
 20:37:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241120160154.1502662-1-paul@darkrain42.org>
In-Reply-To: <20241120160154.1502662-1-paul@darkrain42.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 18 Jun 2025 22:36:48 -0500
X-Gm-Features: Ac12FXxCsQU4pg3S5gVNtrcF5sLkRZqbS9Jk9RV_zg8NQX7FBDejVoI04-J47YI
Message-ID: <CAH2r5mtY8nGN_TFdGZoDAq4ks++bv1K+YhbkrmX5sS8So3+ZvQ@mail.gmail.com>
Subject: Re: [PATCH] smb: Log an error when close_all_cached_dirs fails
To: Paul Aurich <paul@darkrain42.org>
Cc: linux-cifs@vger.kernel.org, Ruben Devos <rdevos@oxya.com>, 
	Paulo Alcantara <pc@manguebit.com>, Ronnie Sahlberg <ronniesahlberg@gmail.com>, 
	Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Bharath SM <bharathsm@microsoft.com>, Henrique Carvalho <henrique.carvalho@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Was looking through old patches and noticed this dir_lease patch
wasn't merged.  Any thoughts on whether it is still valid and worth
merging?

Could be important given the recent work on dir leases


On Wed, Nov 20, 2024 at 10:02=E2=80=AFAM Paul Aurich <paul@darkrain42.org> =
wrote:
>
> Under low-memory conditions, close_all_cached_dirs() can't move the
> dentries to a separate list to dput() them once the locks are dropped.
> This will result in a "Dentry still in use" error, so add an error
> message that makes it clear this is what happened:
>
> [  495.281119] CIFS: VFS: \\otters.example.com\share Out of memory while =
dropping dentries
> [  495.281595] ------------[ cut here ]------------
> [  495.281887] BUG: Dentry ffff888115531138{i=3D78,n=3D/}  still in use (=
2) [unmount of cifs cifs]
> [  495.282391] WARNING: CPU: 1 PID: 2329 at fs/dcache.c:1536 umount_check=
+0xc8/0xf0
>
> Also, bail out of looping through all tcons as soon as a single
> allocation fails, since we're already in trouble, and kmalloc() attempts
> for subseqeuent tcons are likely to fail just like the first one did.
>
> Signed-off-by: Paul Aurich <paul@darkrain42.org>
> Suggested-by: Ruben Devos <rdevos@oxya.com>
> Cc: stable@vger.kernel.org
> ---
>
> This could also be folded directly into "smb: During unmount, ensure all
> cached dir instances drop their dentry".
>
> ---
>  fs/smb/client/cached_dir.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
>
> diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> index 004349a7ab69..8b510c858f4f 100644
> --- a/fs/smb/client/cached_dir.c
> +++ b/fs/smb/client/cached_dir.c
> @@ -488,12 +488,21 @@ void close_all_cached_dirs(struct cifs_sb_info *cif=
s_sb)
>                 if (cfids =3D=3D NULL)
>                         continue;
>                 spin_lock(&cfids->cfid_list_lock);
>                 list_for_each_entry(cfid, &cfids->entries, entry) {
>                         tmp_list =3D kmalloc(sizeof(*tmp_list), GFP_ATOMI=
C);
> -                       if (tmp_list =3D=3D NULL)
> -                               break;
> +                       if (tmp_list =3D=3D NULL) {
> +                               /*
> +                                * If the malloc() fails, we won't drop a=
ll
> +                                * dentries, and unmounting is likely to =
trigger
> +                                * a 'Dentry still in use' error.
> +                                */
> +                               cifs_tcon_dbg(VFS, "Out of memory while d=
ropping dentries\n");
> +                               spin_unlock(&cfids->cfid_list_lock);
> +                               spin_unlock(&cifs_sb->tlink_tree_lock);
> +                               goto done;
> +                       }
>                         spin_lock(&cfid->fid_lock);
>                         tmp_list->dentry =3D cfid->dentry;
>                         cfid->dentry =3D NULL;
>                         spin_unlock(&cfid->fid_lock);
>
> @@ -501,10 +510,11 @@ void close_all_cached_dirs(struct cifs_sb_info *cif=
s_sb)
>                 }
>                 spin_unlock(&cfids->cfid_list_lock);
>         }
>         spin_unlock(&cifs_sb->tlink_tree_lock);
>
> +done:
>         list_for_each_entry_safe(tmp_list, q, &entry, entry) {
>                 list_del(&tmp_list->entry);
>                 dput(tmp_list->dentry);
>                 kfree(tmp_list);
>         }
> --
> 2.45.2
>
>


--=20
Thanks,

Steve
