Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B421545C6E8
	for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 16:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789921940; cv=pass; b=rbqnYuCyw7PjaTidOXrSx9p+NIjZtmWWQX+Fn1E/tUBVDZeMgNQvpZGrqNv7OByjzf2lFViustkf0Unx0HKWqB2OASSQH8d2mmSPoSoAwvE3bgoBBL7bnfIj+ztD1B1H4aM+LNpYwEDJ5nVre+tlcA/BDQXnDciZtl6NkKnmxE0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789921940; c=relaxed/simple;
	bh=+4YERuX/Tm4BEarMicY7oOWvS+xS/CmiXnLfQ+itnn8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/Azl0pfymwso8O4Wx2JlKbaSFtoljI2r0dO9P4wLb4CR8p0BtFNO2JFAmQhBet9UX36CxkiK/F3dWh/5nWS3xupDnmJR774fgok9hNxse8iu2JvoE96ayNMH6vdt1qlv1KBft1wo90rSd5qfk3IBASDR2UPIN8OmyQlbaoFNNs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IPH/UlHc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=O2Zrr29N; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IPH/UlHc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="O2Zrr29N"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789921933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6ElUqtRQzGRczK+6qtQzmlt/OBYAjwvyq42r0CytLLM=;
	b=IPH/UlHcVsUic4V9o/HJERvOAnPve1FCYhoh8rfNL4qbSj5r5Tx4RuL15d+Yz/ddw14er8
	+pUlMbhNzLMIXrG7z+Xdu5fpTWW4JhVJaGfOjj4Rv5nmrynV45u5/9vS0avhLymF+UVc3y
	VWw62VoJao+vyFAUBEDjzqcz8KybpvM=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-EvM6QFafMVqvhh74e-3AEA-1; Sun, 20 Sep 2026 12:32:12 -0400
X-MC-Unique: EvM6QFafMVqvhh74e-3AEA-1
X-Mimecast-MFC-AGG-ID: EvM6QFafMVqvhh74e-3AEA_1789921932
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-66c70fa2ba4so2341142d50.2
        for <linux-cifs@vger.kernel.org>; Sun, 20 Sep 2026 09:32:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789921932; cv=none;
        d=google.com; s=arc-20260327;
        b=cL3b2716A+puPorJ/ra/PoONsyYE5VIYh0/Uf72LTeZuP00etd78o9gL5TUh2e67bB
         C6+jATVifoMPtGLcKytGghhlIYEQhVShKNQMJwm+uswzI8EH60a3BpN7KgCeWeMl45x3
         49KZkU+FXQTT9XexrUda2XfHqztBQXZq8Ot52zWdcLwC9pRSUKRAEiDRahx9K6Fl0Sni
         w1t6PPVt8toGYGq3jkeymtIqbeN37d1kgZ63TcFNaRutRBHRi8Pjf/fgVWQwIx7QLblJ
         KL51yNMWded+t+bSGZkaAKvsexum9WRpxM/msLMGZRPyHDFQgrBWTHdqm4RpoppqIipz
         wKyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6ElUqtRQzGRczK+6qtQzmlt/OBYAjwvyq42r0CytLLM=;
        fh=kMLBKBdzF1rSM4IGoKy1W8CoD97Z5/tEgrRpEO0i9I0=;
        b=DfPj87CRcwPwzXOSOgI3bRMCCfqDQmhrulAcjtf2X7wIEjdR9LU4hiFYrrE/o0YiCM
         4a1jorAEskJmu3hE+tDtKrVXoZtuKYfgqtaJ+YEGmaUaaU1HIE98TwBBMlqeoJJ8taoH
         WUsZXuKVpCyP2w1GuHz6L/+dGs9Wi/NelzmboM+mWPCGO72Ic5mBILcbrRyMX282Sk09
         16CRZIAths3vzLmqSgSWIP1wvdfk4SBuMCM7QP6GYs8Uj15Lpy3RMg7Ozjx1jaA8807h
         36sJD43IM8JccVfDuS4sfoWIivHV+NZTXlMsXFgMPbpmTKp0qkca3Kw/pF71Qoi9t06Q
         IqOQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789921932; x=1790526732; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6ElUqtRQzGRczK+6qtQzmlt/OBYAjwvyq42r0CytLLM=;
        b=O2Zrr29NPOW53WilSxjiGi5+GUNvcBVvdOoqH73SkdEdUiROaNcUr/Dadgv5HRQK5S
         5SohqF3YNLsUhWrHOtO3hDALjesXlygri5dK03KUhIieVN3sd/R9gCZqM285mVAkkhSO
         +eCemdvwbh99xjp00OjVgcow4v3enfWfjUWx3UPKM7+p9xcABOtqk9+quAtR6yiQevRE
         Pp9/kavNr2iMDdp8J2+ssCMO+kFuzKCkCXRvpHRP1Bb80K7ygFIvx1ywjX2h1ZZ6Kvd+
         K0KmEy87O5P2mJ9RdpedP4huuujk4F2y/CyHDRTDF5v8GBCOGDpjxyjqYIsYaBPnBFSH
         YbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789921932; x=1790526732;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6ElUqtRQzGRczK+6qtQzmlt/OBYAjwvyq42r0CytLLM=;
        b=cojpJiVrvMq4ujuKq9XuyzNN66sekhgL30OpG+vHyex3Qaq6RVOJXxeOS0iqEUkKBv
         ZyG/ojYmdYLJNsOPVCK9sEn2ZvEdup7kyQpf8wEyvleJPpyZOTLPEmYzyDECfbs2rb7S
         ztNtJ9HnguGhG2gg9K08gr+i9cOie+J4t80axrvY/AfkODDMmWxt1iIP0ID3Y51Z571k
         EzCNAwfAg5fToxqFFzSwvcsS0T/iqbrlHeGh3hdATnLlx8biKRSpYjWLpcKgKW+IOTyy
         I45Bm7705Fn8T65V9MsxzLdBk3p8hwOSTxgZhLBpoBYsSsgAP8eXCny+pI9w60Wilj24
         oT9g==
X-Forwarded-Encrypted: i=1; AKwUvByQyoPawPChQbQS8FDT9YDXFyHtectBoPGZPnQ2JTj+69bhRdo+FBpV7PIZDYHftDMoCbkARgqBVsXz@vger.kernel.org
X-Gm-Message-State: AFuF++lnY0wYFkODr7Z/6Vn8bSqK9/yCZX8LQaK2i0TfVZisF0Ow8nyp
	EzxlWeLsraHSovkARVoGG2dxrM8j7VeH5UT09+CC4P/U4UVrmmCSb0GAB7uIT/5nYOG7lrOQXLP
	P5XpBLApADJ0juOHMrgXncCFKbg0Ec7n5wfw8gvyLh4LkLGoHcD0Rqk3NVRsmnFFeVKcGJodpa3
	FKWoQ79rKYzLdrfnc7TCamwiwb30xApM27Fv+isQ==
X-Gm-Gg: AYBFou2/9qL5VG82ERyRl5RnS7NggDHjiS61o2h3Kfuzifk/oovFH9xBVP/L84GyWHd
	ORK1wGIsCwrBaR8vHrxFAPjMKfuX+Tkjsk4CCvd6hi7uG1DW/PaSHcMQwrYEo1YcnZbsywtIfo1
	fMjieHw49nrAJguG1HbGmcKQCJ2C/Ov248iV4JBlOxoaITC1jw1gCX0F8LrNnbhOUwcWem1Z2qj
	H20rensGid2NGb+CFDpenzBlP0pIRbWKKlpYHbpYLzUYw==
X-Received: by 2002:a05:690e:1348:b0:671:50b8:aee4 with SMTP id 956f58d0204a3-6717fdf7f42mr2684424d50.77.1789921931914;
        Sun, 20 Sep 2026 09:32:11 -0700 (PDT)
X-Received: by 2002:a05:690e:1348:b0:671:50b8:aee4 with SMTP id
 956f58d0204a3-6717fdf7f42mr2684413d50.77.1789921931459; Sun, 20 Sep 2026
 09:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919022441.3305170-1-neilb@ownmail.net> <20260919022441.3305170-4-neilb@ownmail.net>
 <CAHc6FU4M59nodfn+NCDsr81Wdmvd1Ubw712FF56ekVWfe1+Nuw@mail.gmail.com> <178985655280.37859.6894749467886035489@noble.neil.brown.name>
In-Reply-To: <178985655280.37859.6894749467886035489@noble.neil.brown.name>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sun, 20 Sep 2026 18:31:59 +0200
X-Gm-Features: AcwNN1WDWK2kuJ9juQym02aIIB-Y-9YWAPGC_3VkH8hMthBmOzCWtJtaHEAolhI
Message-ID: <CAHc6FU4cD3fb13LE1-HOEnOoUNVdW1N3e892r7rFE9HJfztvhg@mail.gmail.com>
Subject: Re: [PATCH v2 03/14] gfs2: simplify atomic_open handling.
To: NeilBrown <neil@brown.name>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Jori Koolstra <jkoolstra@xs4all.nl>, 
	Mateusz Guzik <mjguzik@gmail.com>, Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, gfs2@lists.linux.dev, 
	Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>, 
	Viacheslav Dubeyko <slava@dubeyko.com>, ceph-devel@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 12:22=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrot=
e:
> On Sun, 20 Sep 2026, Andreas Gruenbacher wrote:
> > Neil,
> >
> > On Sat, Sep 19, 2026 at 4:31=E2=80=AFAM NeilBrown <neilb@ownmail.net> w=
rote:
> > > From: NeilBrown <neil@brown.name>
> > >
> > > gfs2 incorrectly returns -EFTYPE for any non-regular when __O_REGULAR=
 is
> > > in force.  A symlink might not be an error, and nfsd needs to know if=
 a
> > > directory was found.
> > >
> > > Neither this check, or the following check for a directory is needed.
> > > Both cases are handled correctly by instantiating the dentry and pass=
ing
> > > it to finish_no_open() - the caller will interpret the type.
> > >
> > > Signed-off-by: NeilBrown <neil@brown.name>
> > > ---
> > >  fs/gfs2/inode.c | 17 ++++-------------
> > >  1 file changed, 4 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> > > index f361876c5583..7aa92bb31cf4 100644
> > > --- a/fs/gfs2/inode.c
> > > +++ b/fs/gfs2/inode.c
> > > @@ -738,19 +738,10 @@ static int gfs2_create_inode(struct inode *dir,=
 struct dentry *dentry,
> > >         inode =3D gfs2_dir_search(dir, &dentry->d_name, !S_ISREG(mode=
) || excl);
> > >         error =3D PTR_ERR(inode);
> > >         if (!IS_ERR(inode)) {
> > > -               if (file && (file->f_flags & __O_REGULAR) &&
> > > -                   !S_ISREG(inode->i_mode)) {
> > > -                       iput(inode);
> > > -                       inode =3D NULL;
> > > -                       error =3D -EFTYPE;
> > > -                       goto fail_gunlock;
> > > -               }
> > > -               if (S_ISDIR(inode->i_mode)) {
> > > -                       iput(inode);
> > > -                       inode =3D NULL;
> > > -                       error =3D -EISDIR;
> > > -                       goto fail_gunlock;
> > > -               }
> >
> > as you note below, when the inode exists but it isn't a regular file,
> > we won't even get here (gfs2_dir_search() will have returned
> > ERR_PTR(-EEXIST)). So the above two if statements are dead code, which
> > contradicts the patch description. Could you please fix that?
>
> There are two different modes here: the "mode" that was requested and
> the "inode->i_mode" that was found.
> This branch will only be taken if "mode" is "S_IFREG", but the inode
> that is found could be anything.

Ah right, we could be looking for a regular inode non-exclusively and
get back any inode type.

> >
> > > +               /*
> > > +                * This can only happen if "S_ISREG(mode) && !excl" s=
o "file"
> > > +                * cannot be NULL.
> > > +                */
> >
> > Is that comment useful without removing the below NULL check for file?
>
> Fair point.  I'll remove the NULL check.
>
> I'd feel more comfortable if gfs2_symlink(), gfs2_mkdir(), and
> gfs2_mknod() all passed "1" (or "true") for the "excl" arg.
> Then it would be even more obvious that we don't need to test
> for NULL, as all callers that pass a NULL file, pass a true excl.
> (you could remove the "!S_ISREG(mode) ||" which would make the code
> look cleaner).
>
> But that is beyond the scope of this patch.

Yes, makes sense. I'll happily clean that up.

In fact, could just remove the two if statements in this patch queue?
We can then clean up the rest on gfs2 for-next without causing a merge
conflict.

Feel free to send a cleanup, or let me know if I should write that.

> hmm... you could even pass "!file || excl" to gfs2_dir_search() to make
> it impossible to use file if it were NULL :-)

Right.

Thanks,
Andreas

