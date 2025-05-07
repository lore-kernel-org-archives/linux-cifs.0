Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 521DF215184
	for <linux-cifs@vger.kernel.org>; Wed,  7 May 2025 23:56:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746662186; cv=none; b=rrjpOemstKO/jLbhMTC7yVvbCOgprZFwotnNeb3XF/XHXL5nUxb9Q2JpCC3MkaSNqlEDvuBi5eRi0UYvZwdOK/LGLh8yOaFAP4reewO1G7vZPXJ6qv04T+oJcy8yFyu8hmsec4xP3ihYamiAgFZbr06pHqsn04VrxIqdqMrLFfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746662186; c=relaxed/simple;
	bh=74hkwNlMuxhVtmUHFpP8G9intW7onwbl3HHMVU0uh9A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=qykZJh7WWhSv5CiaVK3hybS2PgvxhgvQXv32eL27azx7nhK0svYtFZX0vWBH/IiGoRLaDFO5HtwYlw9dQDxpXLiJIZ9tmgf9TrdSC0+FAmoaqUfn0la87cmBlK/n2bXwxtdq47ZdkCiye1y1pT9KD/RSKk0xslHNgt/T//kWiio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZE5AeV6r; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZE5AeV6r"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30bfb6ab47cso3428421fa.3
        for <linux-cifs@vger.kernel.org>; Wed, 07 May 2025 16:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746662182; x=1747266982; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WELJGvgnoTL2HCdsv4BlCFHeJy86Ad/k2rHfrO8mmP4=;
        b=ZE5AeV6rVmq6yonfJ41Jybbf39Z9t35kO1aNTrxSZy5bNfLa1pmf+V4023FuJKtY7h
         bZr1VPevEcfv9BSw63WlFLXUsKUhcG9c6ge1mgMOV2cbh8brDVe2/wQks63kNypcFVIy
         5KpiJVxbNwM7h6G65OBM7YVc3JdnIxSsdGm6xD2ZaPzALvios4lprvGn2ppbKa1yojZt
         NSUQP1SU3Yh/aRAr/2ykarxnNohxT+pkpsLLtfb46q+DLdXKAZfLE/7/vUQMUWZJ87N8
         ImXP/EOnDmu4AiZmcHJqKfekxShkb0Kn7OBcm1ZTPJSruwQQT9EzeKBMlOK0T6cfi7uB
         16FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746662182; x=1747266982;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WELJGvgnoTL2HCdsv4BlCFHeJy86Ad/k2rHfrO8mmP4=;
        b=o4+NdAuUCAM7p8pxE/HJ4NV6ulQatljG6PFO8FaS6+ND/JQiTfl0wFHIQQJrKcEjRy
         6C/Yv3G1MZk2XkRop/ig3uImNGr1BxrNqVs541DB4PCAJIZIlPMZlAKIKa75gaZDP49j
         39+Hx3QCiHem3VpJhmoGLAzd2mSD8XRf63CW14+391N6dKwVmCgi5lAoX28+1BYZECGt
         nfBx5wb7GA/SOPAbGI8xIpkGw7ZaDKAX+0Cyet9Hoa5DsubSEAHYi+B9P0ycDdwQJbTw
         aHTOBHhXANMo26nJawa2phCJQ99NFOxEGwFzflSCRWeexECjC9AF/i6li/K4J7D/SLEf
         1hOw==
X-Forwarded-Encrypted: i=1; AJvYcCV53Lko7y+loBDkYZB4MOtqHxTVNAl3EdJ93w3bJPcDrFJ3fSfpVDRsIyzpm9TvntyWK0e/1H2Y5W6t@vger.kernel.org
X-Gm-Message-State: AOJu0YzXDBNCQxhr1oOP2ks3o2LycZJ2d23eGkhiPAt7lkGWpFHcNkHU
	TGJAf3Sp/r+OP1xJ7xPzVDyLmmo6I2ugJMEODZLkjn49tJUIs6X49nFZYvgO0I+TaXJ0AQh35eN
	MRcD7c+mbuXj5G6AuKS7UWdF2Gyg=
X-Gm-Gg: ASbGnctzbZ8bb8dIFjByVnaigxPT3e+XwNoXBJuTAwJOXw0JHwKvR9fGms2WI7QvlU0
	OnylpEKLzIGZxTx7MrL73tOnY7SbIn8t42zKZWvlqvVaErQA5OYlHJB2LuiuAdnkpOpYHDehEl3
	5Csv40TqtXEjw4CIbOm7ol1fk=
X-Google-Smtp-Source: AGHT+IGvdlC3hRzo5NFV9dJU079dUUEQ/1zwO5FpEmyCfsQKn5G7tiuGZgmnlWUz+a4s3sgXj4WFr3jA/cw0mX9LciY=
X-Received: by 2002:a05:651c:1602:b0:30c:12b8:fb8a with SMTP id
 38308e7fff4ca-326ad0837d2mr19486931fa.0.1746662182168; Wed, 07 May 2025
 16:56:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250506223156.121141-1-henrique.carvalho@suse.com> <aBr6zohhW9Akuu3a@redcloak.home.arpa>
In-Reply-To: <aBr6zohhW9Akuu3a@redcloak.home.arpa>
From: Steve French <smfrench@gmail.com>
Date: Wed, 7 May 2025 18:56:10 -0500
X-Gm-Features: ATxdqUHjLbeedzzCtGAXSsYuTVvTWEg1lAdV_l_dHSB5Bv5P9gZbZ-KPLz5Rrso
Message-ID: <CAH2r5mvJiaGHgG2h-9xbkXAfe6J=SP2SuVd_06JW0ekqErTMTQ@mail.gmail.com>
Subject: Re: [PATCH] smb: client: avoid dentry leak by not overwriting cfid->dentry
To: Henrique Carvalho <henrique.carvalho@suse.com>, ematsumiya@suse.de, sfrench@samba.org, 
	smfrench@gmail.com, pc@manguebit.com, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, bharathsm@microsoft.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

So far Paul's patch is working - it avoided the generic/241 crash (dir
lease related)

      http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/build=
ers/12/builds/50

 and the generic/013 multichannel hang

     http://smb311-linux-testing.southcentralus.cloudapp.azure.com/#/builde=
rs/5/builds/445

Since Paul's patch avoids the most urgent problems and is small
enough, the larger longer term locking improvements should probably
just build on this (but some may have to wait for 6.16-rc)

On Wed, May 7, 2025 at 1:16=E2=80=AFAM Paul Aurich <paul@darkrain42.org> wr=
ote:
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
