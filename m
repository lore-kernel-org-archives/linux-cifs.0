Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com [209.85.208.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53E327D782
	for <linux-cifs@vger.kernel.org>; Thu,  8 May 2025 16:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746720575; cv=none; b=pMKK6RjGpax/tA25z0DJeska8YyAIE5/IOiPdtHQKMXzb568rQWoH65qCy1dRPfhcRMCaeiAaMH4aQ+17z74/RNWhKGtn7i4QvysXiGLpF7ysqMXnY59I6gcEnuKtLAwgE9HMcbdYMh2YAybjTRGQu5zeT4QhcGLKC85l+Vi3vE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746720575; c=relaxed/simple;
	bh=SNUAPvMsFz1GGbWVqdxIpRGM6Fu/Dn6nBEMwR98TAvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=ikfnD71zf7Lweanz/RH4wAm4ms9SiQcE9WI55BaspxsDFhx/nGQiHB0GlZRH6A7fleBC9039EExrN4zMxiZ2FcHYUN7okWqUaFHPrU/ABhd+zKcbfJYdO/beZ3HEOkhuz0IfHWcORzGZgaoKroLFYvTDeri0a1Mk7Flf9Eopjy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Va1C7LET; arc=none smtp.client-ip=209.85.208.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Va1C7LET"
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-3105ef2a08dso10055211fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 08 May 2025 09:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746720572; x=1747325372; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rcgQrNagzRdAMMrcYlGKHPUxT3Ev6IaaJmk+8xyfFl0=;
        b=Va1C7LETineyIPkDdORabF5qIiKSjghhT60SmN1CKm5YfKGinM2BdXPgh7XoJVpwxb
         7oEp/hBc2v+oX+lLgKN8v6HJPztBmqNi42Hr0s7T49sq6Ucqp3MU1bt+CKIYBV8z5/jm
         XaXYiWILEFDbbLBD2LbY7lk1zZMxl4ligalRNpPl5TrWCYsBJ+DVkkU/8CGlDbZp3gQD
         /6d33OLLZDW9ukhJjDbkuHYcm0WoWcab4QdeGmmNriTrEe6LTSNqRtPMHBPt1wrQz1Me
         y1lT1NharnGL9oPlFYJfRcPej6zDLcvJ3sYkvpaWA1JXrzvimoxPYZA8/nxXt83AZfBV
         yOgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746720572; x=1747325372;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rcgQrNagzRdAMMrcYlGKHPUxT3Ev6IaaJmk+8xyfFl0=;
        b=k/IYN7HQCPjMe7m448ITQUqzz2o8i4JLmAvbV8GVp/uzuIYvAiM9MFDunHsrldT27j
         w/ZOcAPwEOs7GDNbj6E0YlWC+iIjErOl37bmtV1nZDMu06N1/7f/WQQM2mHnoRWPQYZL
         qjgC1HRKwRCW9q2FnNm/al5VdUHVeqdWadkNsU44froAwtd+EXnfg76y6BhYovJzN5Ou
         MK+0qD3OIeih1rZcssKojpVU1dxxzez6I/mVtZPjz02H1A+YHQPePNZb911jLjGpkojK
         A2tUOnpUmFSwMfCycNmnwSsMpdT6AZMZEMe7x4HBu+NkQR2FpaPx43tO5qCVSvRcszRL
         2pBQ==
X-Forwarded-Encrypted: i=1; AJvYcCWgqWEZav3uQ74q1BjNXIZONWjc1EfdOfR4jbyzJZ8f+TlSzNMBesFvYdz9AUPkh/jSkzeqQVizM241@vger.kernel.org
X-Gm-Message-State: AOJu0YzY58XpFdbJOqkNjNcl58omj5A1NTCdjWgUPQFMrN/7LtDQKZL9
	2jcC7d0FYwv/3MC9WpUllixKuKs0z6RNw67Jko/DNr5Wa4lonoFxoPRlk8/RDWavM35X7kUO3hb
	DcaqzA0+061DcZPLjeGr8+XUM9kk=
X-Gm-Gg: ASbGncvWrQMFQm1nBOd14TxDqTR256Wrxo0U5pzo6hCwNckXY7YVem4Iu3M1GwuqLfD
	dh0MVpOsGQzKQ+XIme5btHGnreVxNZAR/++ulSSL1RULZOj9L9yFeuDAScDU4YQXD95iwP0k1Xy
	t54FsOy8iSyLqRQ7vgkwEllL0=
X-Google-Smtp-Source: AGHT+IFU+M38/okwPecBSZmOjDLCdehgAFxrSNfpmqZxvmr+wQKCEb2oKBIBDMzWKmAA8+Hpkfhmbt22lfJnewyhW7c=
X-Received: by 2002:a05:651c:154b:b0:30b:ee44:b692 with SMTP id
 38308e7fff4ca-326c468068dmr482561fa.33.1746720571305; Thu, 08 May 2025
 09:09:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
 <aBr6zohhW9Akuu3a@redcloak.home.arpa> <CANT5p=pHLh-8fDbJ2OCdNa_eHR5T=BVJAOSYy4zs_Lk6FzR9=A@mail.gmail.com>
 <aBzTdkkKDyW29M9-@redcloak.home.arpa>
In-Reply-To: <aBzTdkkKDyW29M9-@redcloak.home.arpa>
From: Steve French <smfrench@gmail.com>
Date: Thu, 8 May 2025 11:09:20 -0500
X-Gm-Features: ATxdqUFFAVuTcMm_NBVKbMz_5fMEuP2dGWBxz_A4GEWaMSss1az4AVXhARHymk4
Message-ID: <CAH2r5mtfzjCbsOaq76dR3D4safZ1516hoqrtjPnfzVeNjffJww@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting cfid->dentry
To: Shyam Prasad N <nspmangalore@gmail.com>, Henrique Carvalho <henrique.carvalho@suse.com>, 
	ematsumiya@suse.de, sfrench@samba.org, smfrench@gmail.com, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, bharathsm@microsoft.com, 
	linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 8, 2025 at 10:53=E2=80=AFAM Paul Aurich <paul@darkrain42.org> w=
rote:
>
> On 2025-05-08 20:54:34 +0530, Shyam Prasad N wrote:
> >On Wed, May 7, 2025 at 11:56=E2=80=AFAM Paul Aurich <paul@darkrain42.org=
> wrote:
> >>
> >> On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
> >> >A race, likely between lease break and open, can cause cfid->dentry t=
o
> >> >be valid when open_cached_dir() tries to set it again. This overwrite=
s
> >> >the old dentry without dput(), leaking it.
> >> >
> >> >Skip assignment if cfid->dentry is already set.
> >> >
> >> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >> >---
> >> > fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
> >> > 1 file changed, 15 insertions(+), 8 deletions(-)
> >> >
> >> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >> >index 43228ec2424d..8c1f00a3fc29 100644
> >> >--- a/fs/smb/client/cached_dir.c
> >> >+++ b/fs/smb/client/cached_dir.c
> >> >@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct ci=
fs_tcon *tcon,
> >> >               goto out;
> >> >       }
> >> >
> >> >-      if (!npath[0]) {
> >> >-              dentry =3D dget(cifs_sb->root);
> >> >-      } else {
> >> >-              dentry =3D path_to_dentry(cifs_sb, npath);
> >> >-              if (IS_ERR(dentry)) {
> >> >-                      rc =3D -ENOENT;
> >> >-                      goto out;
> >> >+      /*
> >> >+       * BB: cfid->dentry should be NULL here; if not, we're likely =
racing with
> >> >+       * a lease break. This is a temporary workaround to avoid over=
writing
> >> >+       * a valid dentry. Needs proper fix.
> >> >+       */
> >>
> >> Ah ha. I think this is trying to address the same race as Shyam's 'cif=
s: do
> >> not return an invalidated cfid' [1].
> >
> >
> >Hi Paul,
> >Yes. One of my patch did this check to avoid leaking dentry.
> >However, without serializing threads in this codepath, it is not
> >possible to rule out all such races.
> >
> >>
> >> What about modifying open_cached_dir to hold cfid_list_lock across the=
 call to
> >> find_or_create_cached_dir through where it tests for validity, and the=
n
> >> dropping the locking in find_or_create_cached_dir itself (see attached=
 in case
> >> my text description isn't clear)?
> >
> >We can do that. But holding a spinlock till the response comes back
> >from the server is not a good idea.
> >We could see high CPU utilization if response from the server takes long=
er.
> >My other patch introduced a mutex just for this purpose.
>
> I don't think my proposed patch extends locking over server-side
> communication or anything that can sleep/preempt. (To be clear about 'tes=
ts
> for validity', I just meant the 'if (cfid->has_lease && cfid->time)' test=
 that
> occurs a few lines below the call to find_or_create_cached_dir)
>
> Without my patch (i.e. before changes), find_or_create_cached_dir() holds
> cfid_list_lock over its entire execution, but drops the lock before retur=
ning.
> open_cached_dir() (the only caller of find_or_create_cached_dir) then the
> spinlock again and checks if the cfid is valid.
>
> The fix just moves the locking out of find_or_create_cached_dir() so it's
> acquired _once_ and held across both searching for (or constructing a new=
)
> cfid and then checking the results.
>
> I don't think there are any intervening operations that would sleep?

I don't remember seeing any obvious slowdowns on individual xfstests
running with Paul's patch,
but we can rescan the test runs with and without his patch to make
sure we aren't slowing down
anything (and there is some perf randomness when running tests in the
cloud) - but I didn't see
anything suspicious from a perf perspective


--=20
Thanks,

Steve
