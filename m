Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60B81CB31D
	for <linux-cifs@vger.kernel.org>; Wed,  7 May 2025 17:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746637306; cv=none; b=YWqMay7QFvWdMq9IDeJv1DEEedBoBDSYtGG+N4ScEO0ayhhJyFfxVNTEwKClnXNbZJtCzc+25lrDr9sFNz/R81qxwSffxK4kbDjdUxzvdkvpwBV1sPjdbHZNJutHGTlkE6//pAnGaG0Qd5m2Nb+RUhACeSYOCFIfj2hMSCi2cgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746637306; c=relaxed/simple;
	bh=PUFBSfzSCJ2T15YGTiQHtIspFmhWItaWLx7rkuRhfwk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=Z19bKFyt8MQ21/TT214UU89BMnbqZAU10DnWuELRgCNlciJvpEh9B1kr5fDVTyVLveqvxc8TZA5gg6zCWp1hPPs4CqS5rHZ+bKsI5aUFB9Vr8a5Bgml6hLOHa4ow0BKQRmV92t0aHB18IW4bCnRDBaE4kkg1TPE11rg+KNZeVOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jJyZwjfo; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jJyZwjfo"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3105ef2a08dso202151fa.0
        for <linux-cifs@vger.kernel.org>; Wed, 07 May 2025 10:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746637301; x=1747242101; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRDiis1K62bhAEDManWhjXCHbpTMmQ3iaE4tjv1iIjI=;
        b=jJyZwjfo62u7xuhmv9QXE79jTWC9Ryn2yS6UsYF9chqPRLXUvFsoEeLeMoLK1pVxh8
         oszBKhsGRfOCaRzwIOoI86T0QgCT/Muf0SHb+K7prFd9E8LAzG4vP4eDZAGv7c4tc+iV
         prS/V/5gxHTgDtJRwOTt2yn43OPaKgW1vMQfbKg9jKD+pDi4/mLJj+41rXGa7D59x3R5
         r/u135GOWigzdweubD8tpTCOA2TVRUu5wRvfDuJoaVygdgW68loCcV/6Z34PQezsp5jM
         xlyupVNmmeUtST3lgyLiH7weygemAHcnWExuCUWlwGAqGTZO9EXItRPpaXOjvHmT+Dfi
         ZIoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746637301; x=1747242101;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HRDiis1K62bhAEDManWhjXCHbpTMmQ3iaE4tjv1iIjI=;
        b=BLKL1apnRribCRnuOTgPJ6h9v5cD5G/XM9JARmySEo/TVFU/aMo3ncbea5Pb8pq6Hl
         ypYB66KrZafUq8+L1BmL1bhh1fZryUz4PztZ1W6y8cmbH8IRu5VlAjqz2EcyLRGn9IvK
         UPRh2wxy0pI+smemKTZuSXst4Xgi+ZzCFTSc1VMOQzkL7Fp/Y+j1KMyRgeUmWwPoj5gP
         AqEAZr+gEo+xsfRRQsFVOaGaoOYMJLf3GEegNHWVMYgeXB+aOLcSDkWlbJYn10pzSw15
         mCCuFwpIquw/n0+LDIl5+VhSTmK+MFdotWD4xRO0BgjOz1YwAq+eju+S8mpJqIYPOy28
         1y3g==
X-Gm-Message-State: AOJu0YyBjh7fLRi62zFtTaMB6P5so9LHCEkudOkf05XlGu6OYcQI7+Q7
	2/yRXfhCzkUel87cjr2s1aSatKhwjfjAHq8985tbwg/FQy9mbQW0yxmbX65pis6Wk8zYLCuVnbH
	8AQNJFdNc6SS7pLeEcSiaOQRGyRNsqg==
X-Gm-Gg: ASbGncvTtbuJYVlL6qm4cC3Z3ZMcfVb7SmE1sL1uSh47yYmGcGYvZaB2V1GpafjbdRb
	TTvXMvrZRKMnuLv+9D21gZGhuOsKq9kc83TvbsL8cVoDDdFBJBlrPinx6Str8NKHOXhiFjXtkKO
	/8GhKGAgeyoH51Ch5FQj1ILN0=
X-Google-Smtp-Source: AGHT+IH3PJqanfvrREgmiBtfgArG9qygG4XPychz9hNMx7jKzHFPfx1YmKAVHNF+SmVS4rzpiSZZlbc5496AkrhfXQE=
X-Received: by 2002:a05:651c:1441:b0:30d:e104:9ad4 with SMTP id
 38308e7fff4ca-326ad382272mr14313151fa.41.1746637300987; Wed, 07 May 2025
 10:01:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250506223156.121141-1-henrique.carvalho@suse.com>
 <aBr6zohhW9Akuu3a@redcloak.home.arpa> <CAH2r5muyz7zY=+Fgrtc_zOA6GR1ZSGpR-Z4pFzgqmfszhnywWQ@mail.gmail.com>
In-Reply-To: <CAH2r5muyz7zY=+Fgrtc_zOA6GR1ZSGpR-Z4pFzgqmfszhnywWQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 May 2025 12:01:29 -0500
X-Gm-Features: ATxdqUHRfF5MvEdELO3F9mCHDBb3YuN06No7_9NB_HkiiglGe6BtwSg48Ljcyu8
Message-ID: <CAH2r5mvUx5-+-np_y1qqv6EOf1sBpa1b_7WvCYRVF8u4rG6ryQ@mail.gmail.com>
Subject: Fwd: [PATCH] smb: client: avoid dentry leak by not overwriting cfid->dentry
To: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

---------- Forwarded message ---------
From: Steve French <smfrench@gmail.com>
Date: Wed, May 7, 2025 at 11:31=E2=80=AFAM
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting
cfid->dentry
To: Henrique Carvalho <henrique.carvalho@suse.com>, Enzo Matsumiya
<ematsumiya@suse.de>, Steve French <smfrench@gmail.com>, Shyam Prasad
N <sprasad@microsoft.com>, Bharath S M <bharathsm@microsoft.com>,
ronnie sahlberg <ronniesahlberg@gmail.com>, CIFS
<linux-cifs@vger.kernel.org>


I can try some test runs with Paul's patch.   I wasn't clear on
whether it obsoletes Henrique's patch or if both would still be needed
though.
Is it ok to run with both patches

237d73fd2428 (HEAD -> for-next, origin/for-next, origin/HEAD) smb:
client: Avoid race in open_cached_dir with lease breaks
0b68d50bb6aa smb: client: fix delay on concurrent opens
419408103208 smb: client: avoid dentry leak by not overwriting cfid->dentry
d90b023718a1 smb3 client: warn when parse contexts returns error on
compounded operation
92a09c47464d (tag: v6.15-rc5, linus/master) Linux 6.15-rc5

With Henrique's patch there is a hang it looks like it introduces in
generic/013 to Azure with multichannel (no directory leases) which
seems strange
            http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#=
/builders/5/builds/443
but it does address the hang with directory leases after test
generic/241 with directory leases:
          http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/b=
uilders/12/builds/48
and in the main test group, the only test which fails is the expected
one (the netfs regression) in generic/349 (I need to retry David's
updated netfs fixes for this)
          http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/b=
uilders/3/builds/466

Thanks,

Steve

On Wed, May 7, 2025, 1:16=E2=80=AFAM Paul Aurich <paul@darkrain42.org> wrot=
e:
>
> On 2025-05-06 19:31:56 -0300, Henrique Carvalho wrote:
> >A race, likely between lease break and open, can cause cfid->dentry to
> >be valid when open_cached_dir() tries to set it again. This overwrites
> >the old dentry without dput(), leaking it.
> >
> >Skip assignment if cfid->dentry is already set.
> >
> >Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
> >---
> > fs/smb/client/cached_dir.c | 23 +++++++++++++++--------
> > 1 file changed, 15 insertions(+), 8 deletions(-)
> >
> >diff --git a/fs/smb/client/cached_dir.c b/fs/smb/client/cached_dir.c
> >index 43228ec2424d..8c1f00a3fc29 100644
> >--- a/fs/smb/client/cached_dir.c
> >+++ b/fs/smb/client/cached_dir.c
> >@@ -219,16 +219,23 @@ int open_cached_dir(unsigned int xid, struct cifs_=
tcon *tcon,
> >               goto out;
> >       }
> >
> >-      if (!npath[0]) {
> >-              dentry =3D dget(cifs_sb->root);
> >-      } else {
> >-              dentry =3D path_to_dentry(cifs_sb, npath);
> >-              if (IS_ERR(dentry)) {
> >-                      rc =3D -ENOENT;
> >-                      goto out;
> >+      /*
> >+       * BB: cfid->dentry should be NULL here; if not, we're likely rac=
ing with
> >+       * a lease break. This is a temporary workaround to avoid overwri=
ting
> >+       * a valid dentry. Needs proper fix.
> >+       */
>
> Ah ha. I think this is trying to address the same race as Shyam's 'cifs: =
do
> not return an invalidated cfid' [1].
>
> What about modifying open_cached_dir to hold cfid_list_lock across the ca=
ll to
> find_or_create_cached_dir through where it tests for validity, and then
> dropping the locking in find_or_create_cached_dir itself (see attached in=
 case
> my text description isn't clear)?
>
> That's the only way I can see that a pre-existing cfid could escape to th=
e
> rest of open_cached_dir. I think.
>
> ~Paul
>
> [1] https://lore.kernel.org/linux-cifs/20250502051517.10449-2-sprasad@mic=
rosoft.com/T/#u
>
> >+      if (!cfid->dentry) {
> >+              if (!npath[0]) {
> >+                      dentry =3D dget(cifs_sb->root);
> >+              } else {
> >+                      dentry =3D path_to_dentry(cifs_sb, npath);
> >+                      if (IS_ERR(dentry)) {
> >+                              rc =3D -ENOENT;
> >+                              goto out;
> >+                      }
> >               }
> >+              cfid->dentry =3D dentry;
> >       }
> >-      cfid->dentry =3D dentry;
> >       cfid->tcon =3D tcon;
> >
> >       /*
> >--
> >2.47.0



--=20
Thanks,

Steve
