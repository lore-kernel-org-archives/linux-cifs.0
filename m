Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03ACF7494;
	Fri, 11 Jul 2025 21:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752268227; cv=none; b=cMQlcPlmVqC4vmce9y+yfzqMaB/NQaHWLIbeaKeIRgsLxVxO/m2ajWbMoe2LKNuRjbjJI6s/Ynd2K6qPuvoiIMw9DppwBH5Ain8499CzYna1Z3wvPNplorOYoc75J7Wq9Q6gIelByx+vC70qOlfp/bSxEso02L3k9GCmkdANtU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752268227; c=relaxed/simple;
	bh=DiUf4kF7KcPge1x0qiaAKYV0ZYqFbk+uX91OxderPZE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VPTm2B9GuO4Z7JFHc3s7kdHw60CSRaJQHwfeDbdVOFGAvh2hcDTOBGkDzktMQQOnk06tKZckHjKlD1wgfXsvREi7cNxMHUgExRVvaoGbczmGTEpSOKiBF8KgJ7pyXzqUKa4N/vAFcECPKw/3huuaSl6UyWFwT0z8eWSJnioGtzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Efq3luj+; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Efq3luj+"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6fb1be9ba89so24350636d6.2;
        Fri, 11 Jul 2025 14:10:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752268225; x=1752873025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xLDzATH4FKHBUEL/4pNBiM+c+Pl7nhhwFN3kf38HDms=;
        b=Efq3luj+neGv3Psk+ZIUn/wNfSZncS10ElvhVDyDywH+YabSRnGERYxwbNrTpG9xZY
         1Wo4nyp74d6pH16H9QhHciNoioJBMyBj3zwrvpCJ+8WwA52VfEtpfildfM3bgocMmTqM
         2OMGJUobxDiyruvnDsV8/DvVatyRLVQ3Kog48wR2CPog7BdKAY5r2zl3v0Llrescj2OC
         tX5P7UHaH5skw9r07z8Ch0FPm2wPexc36i/OjHlBRh1JBvFXaUMvKUgm1yGjv/i0AS/X
         446UFdUbXeI8nalQGNTAz8U0lItBnd9Ei5LpJHTEjp8YlhQ9l6gjvjXR76G1SRhhN6pj
         k7IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752268225; x=1752873025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xLDzATH4FKHBUEL/4pNBiM+c+Pl7nhhwFN3kf38HDms=;
        b=wwf7wiU5o64yVC9zA17Zdc/UPcbQWhaT+wbukCa5W4s6ZzDSmg4bvlcgTPRQglafU9
         4wBVOjxDdaAX2b+QctxhIUJLacNrU0gWfSxE+DcjOzb1ahDZ+jkzaRH5fAbf2gNx5D7H
         Y87G1KHHbN9IIYFVctwAJW4dMhsTXBIYDdGzbVEyHNVnY3cCC175ZdLE5xH1xb+soQhl
         bVpS1O3fpO3KSKrAK/5+8kkTPoe6P/QrrFNuHkYIfXmoeFms3SZ1TLUvadqaSRo1XCNX
         1ajv478T7okdhBsWkkDMPDDzdPXnbzzJsMNJdT800dcpZJdCezAT0SSqBY2rQMiH/Nb+
         r6xw==
X-Forwarded-Encrypted: i=1; AJvYcCU/NquLH4WuILVS0l7x9EQVorrVzNebuVvMVKWj593KRwBi+bzJ7GV/T/lOyD2yYde1zYftqUbIOy6dVqMn@vger.kernel.org, AJvYcCXDI8Hg/kE7D3RPChvaQtSBdMU2MajnGgtJ0SoAzSpkb6jmHdNcEA/D7VlMw6qrDc9vym2VMPz/nx3Z@vger.kernel.org
X-Gm-Message-State: AOJu0YyOPa4K0g6h0YhX5PUA15YyGD2d7Wjuu4rsgpHTpJQ9J/Ka1W3v
	2IHDMPeGTj1EE3naFPxCKUp7jU/1qGD31CSGmJJkiipu6PWkfTmDigtl/DV3B/gIx+CdjEtPnFJ
	t3L8NNfo7ZATxkMkviHVOVhiFiyI/oA1DEYqA
X-Gm-Gg: ASbGncuHYunv7c6YhM6pgNWecQBp+vQL4mRRP4M2PbLtAPcb/i2im+6AMj2Cqt4Bv0x
	46fEufIn1fqW8Sbl1exrURdYmwqNC4AY6qv8e+5ZLcUzDejgpdbQczqwkei7hkPrJesEBae2duB
	mQCbB9UZ0AUlxE+JRwjxRI9tAYPQ49cXBo7/0NgE4qnJkfqzkRFetMdv3WlBqaCXoO8xE+E9Yoc
	OS5gO62P3eCUCQ+gJuYGjvR4vVKqvSK6l7XtkshFWRo9+Jtbg==
X-Google-Smtp-Source: AGHT+IGaCiQ/rNrz/LTBHwnUjiK0A45Q2lEw4u3i7emCz70wt24LnSCWlVSIxry4sdILfJa0MeDniDQMMJEm/jOlAP0=
X-Received: by 2002:a05:6214:2c08:b0:704:9077:e0c8 with SMTP id
 6a1803df08f44-704a4083edemr98468236d6.3.1752268224779; Fri, 11 Jul 2025
 14:10:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250707010926.31623-1-wangzhaolong@huaweicloud.com> <aa4ecd85deb859ad32ba7f649321084b@manguebit.org>
In-Reply-To: <aa4ecd85deb859ad32ba7f649321084b@manguebit.org>
From: Steve French <smfrench@gmail.com>
Date: Fri, 11 Jul 2025 16:10:13 -0500
X-Gm-Features: Ac12FXyAPNKfVjaJoQLVk1wqbZqeW-9qtvUVFWqZQkbPbxcmN6B9JWqQFqrRpM8
Message-ID: <CAH2r5mukjH30zhxGTiJmvfRYJEFgsTd-U+CpwmYs=7aUJPS1=g@mail.gmail.com>
Subject: Re: [PATCH V2] smb: client: fix use-after-free in cifs_oplock_break
To: Paulo Alcantara <pc@manguebit.org>
Cc: Wang Zhaolong <wangzhaolong@huaweicloud.com>, sfrench@samba.org, pshilov@microsoft.com, 
	aaptel@suse.com, linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good catch.  I had missed the patch because it was tagged by gmail as 'spam=
'

Merged into cifs-2.6.git for-next


On Fri, Jul 11, 2025 at 9:50=E2=80=AFAM Paulo Alcantara <pc@manguebit.org> =
wrote:
>
> Wang Zhaolong <wangzhaolong@huaweicloud.com> writes:
>
> > A race condition can occur in cifs_oplock_break() leading to a
> > use-after-free of the cinode structure when unmounting:
> >
> >   cifs_oplock_break()
> >     _cifsFileInfo_put(cfile)
> >       cifsFileInfo_put_final()
> >         cifs_sb_deactive()
> >           [last ref, start releasing sb]
> >             kill_sb()
> >               kill_anon_super()
> >                 generic_shutdown_super()
> >                   evict_inodes()
> >                     dispose_list()
> >                       evict()
> >                         destroy_inode()
> >                           call_rcu(&inode->i_rcu, i_callback)
> >     spin_lock(&cinode->open_file_lock)  <- OK
> >                             [later] i_callback()
> >                               cifs_free_inode()
> >                                 kmem_cache_free(cinode)
> >     spin_unlock(&cinode->open_file_lock)  <- UAF
> >     cifs_done_oplock_break(cinode)       <- UAF
> >
> > The issue occurs when umount has already released its reference to the
> > superblock. When _cifsFileInfo_put() calls cifs_sb_deactive(), this
> > releases the last reference, triggering the immediate cleanup of all
> > inodes under RCU. However, cifs_oplock_break() continues to access the
> > cinode after this point, resulting in use-after-free.
> >
> > Fix this by holding an extra reference to the superblock during the
> > entire oplock break operation. This ensures that the superblock and
> > its inodes remain valid until the oplock break completes.
> >
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D220309
> > Fixes: b98749cac4a6 ("CIFS: keep FileInfo handle live during oplock bre=
ak")
> > Signed-off-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
> > ---
> >  fs/smb/client/file.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
>
> Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
>


--=20
Thanks,

Steve
