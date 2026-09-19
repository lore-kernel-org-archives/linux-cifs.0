Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A092137E300
	for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 16:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789836608; cv=pass; b=RAJe6Uz0hrZIgK1G6wRSzIpNWYwneK+0GZLrfkiYy1+PWNUGg2aDTGDzqytIButHvxJ8sTKvvlN7R6HC0rM/qteSeCBxb+xOg5jtif9CPEX+Fkh0D9jva7MNgi3ea2MR6eDrsPsIYNN3IyzY5WCP5XOp9m4toQUWHVrTKRGea6M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789836608; c=relaxed/simple;
	bh=1oY3+giPHWz0CdoUqh5D52C+UH9EYo6twKyaCtg0Fhk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hmlgqaseH2zqvUDg88Vh4MyLKDkflIfc7iEK6oq4pCISo3/HE2uv7CDxlBxykSqjNa/X571481kXG5QiF+yBESrCJlmm+tl+rHuQ6HndaKUMlBbLB7C+F3IMCKfO9GdvPWw1NtXON1zn1Y9BtvQUFa30gcod6QK4YXUh3eyIYi4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWti0NO7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DOlsh8sf; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWti0NO7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DOlsh8sf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789836603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sw2O3A+XY8Iwe+GQb7YOsi3YCIQxb8QR4CEhrrgc/KM=;
	b=DWti0NO7M5GOzv/mHpgKY7UUb1RPOxRK5G127tf2lGulceXlG6XYU69GMR7w/OPZ9+T+KO
	kzW6H8FIgbITCEo+v0MjlobWJnxdmRumGfH/AyDFxDWu5aVRLuoWk4YryYdNLvAJRkkE0C
	YML6lGp5qXAAAph75VxXcxwzrPsIiEc=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-4W4WiNIzNhKbbSJ5-jhs6w-1; Sat, 19 Sep 2026 12:50:01 -0400
X-MC-Unique: 4W4WiNIzNhKbbSJ5-jhs6w-1
X-Mimecast-MFC-AGG-ID: 4W4WiNIzNhKbbSJ5-jhs6w_1789836601
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-66fb71198e9so2860598d50.0
        for <linux-cifs@vger.kernel.org>; Sat, 19 Sep 2026 09:50:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789836601; cv=none;
        d=google.com; s=arc-20260327;
        b=AgqQzbuyLiFZZ0KfSSrq7fDLGaWVUCoUMQu8zTs3DS2o6P1BgWrn8vTCS4VP/kv4Hk
         vKCukGpaH4JXsu2hB8qn3PHtixQuO4DLtFbtv20ADrlDg8xhs2boyuk0jclrVA1zzvCu
         dWSRdOsE+nOBifLarbkHmqP/T+tswP2Grxw/TW8qrMcgkec+wvjI8Ysl8ZOOeQFUr92t
         q9xfq+4uYTtbkk9Rw9XElET+Cg5zg+2pOy16WTMSkfVfuSN32YKe7dBFAIOeh+N2+JbM
         ryjdPF3qWZa6roe4Dzl5jiDLas0J1b7EIwnDgXvhyEHh84scDro5FluBRGrQoqyebZRd
         sckA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sw2O3A+XY8Iwe+GQb7YOsi3YCIQxb8QR4CEhrrgc/KM=;
        fh=OpVb6vlCrGJGVxd+DHzC0guRHTDjS+lP+dIxeSyUUYg=;
        b=Va4PoAgUZyo3GDlmeJ6cAoLkA7pb47wkbFD8TcQZ9z8tZEFWuFHVqwPpHfFF7rY2fA
         yUHWwnZR9IoSiqUTk+edF5M0Qe7nge9vVXLoic7aY/zOFrIAr4zeNDjG+aeBv0muwzfj
         Tbm1UdiVEAqTmgMqfsj4hdXQ6VAPw5C7OzyTPCWz5+BTWvnS6Bv0XKDR+7USuQ68msGS
         mLIPuQ+6V4oQljnsPPS+y8khBdTN1vdTDdurs8Gsj4ZUqll71h4lJ+ixf9zP9QzA4SFB
         ie/xkJ2CqeSwixwS34UhhFDhOJ3iyVX2+DSTfym3CpsGoEg4telKr69xizk/NGg/dq5n
         HPGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1789836601; x=1790441401; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sw2O3A+XY8Iwe+GQb7YOsi3YCIQxb8QR4CEhrrgc/KM=;
        b=DOlsh8sf0D+rrt+7UyCzUPdYC7BMH+oM+23q306qKZXtI7Nfv1mGPjyFaBvudVWFum
         uJ0tIxPtSudxVkrKoE3C0Q4YKlzQESbumFk/0jGlg18Ezu0S3dGI1N0j8I+xpVCV1PUR
         HgPsr/aC//nPdKWGMEejG+ve1o16krxaPV0oGlnUxGLRF1V4/e90xgaDm6g8gBl7OZH1
         OhMuVgoiie0dRLBMNHyn9w1RmR7TBTsZJ9y2CO47tXyfC+cfT9GPkYe+Dbhg9puFZ22d
         37/+HXlnon8cp/rAUzQpLD/04EuOW35vF4Uq/T5y78jGcaD9pnzmSdn1OW/NQ1UVzHIR
         CItg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789836601; x=1790441401;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sw2O3A+XY8Iwe+GQb7YOsi3YCIQxb8QR4CEhrrgc/KM=;
        b=mfyuWd7715JEySonNEmdFuJFZCzM99rr3GZP6AV9LWv7YmIgJEZjiPGKmLnMnBrfNc
         8XoJ28TUVycLY1djB1QaJEzD+AXvRFB+YBsF/6OV+JAF51MgJSFTB1h6bmWP1YbjOpMG
         n46SgiWnVAUbZiV/NzeMaPQ2Rk19WpOGrZp9muZHm/tfy4c1MbZ86HXXbt09mkxGIxIP
         sii1G40DpOkfY6d6hv8nWLTOxLYkjQlkiKwihAxoS/SMoSEOqPfBVkizHX5HYP72ctcG
         rfBTTLGQHgAofMJNppkP6s1bwlwXo9bAfEiEUl2JNQ4bKEyB5/Uzer75e+qxy4Ri3JFG
         lp4A==
X-Forwarded-Encrypted: i=1; AKwUvBw7DKH3X3e8EYlO26a0lYBGyiog4XySx7thfDEiIJrJ6cqXoXIRE95kjXHFBHMi0gEXj39jMY9lr5ik@vger.kernel.org
X-Gm-Message-State: AFuF++mYOen1efLThr8fRapSfGXLgxYsmRT+YAaBj1zA6KyQcVJvt8GY
	JzQrXNWk9RJ2cPFSYKNX+3mKy+0Khb3w4ZrDmpSiJD+JW8HPSXM8+lfZJmCPjaucj762L2i4zEP
	dTVUqHsNhQ6+R1ul8Gu6Z6ooeN7IoOTVt1uOcaq/BmJH6WgZtp90Q+jxnBH2W4gflc51jszh2dL
	Lmsk+sfAuLtF6Zi+htSpD2Uel1j0jpu0oNBjyWJQ==
X-Gm-Gg: AYBFou1WB41KaxbasTMmnhTLfsIZsmln3jVGZz93m88r8LuHEICF3ys4GFLj2AFCm7h
	+4IMR5j0V2fB+5zjfmo25CatxYR5wa/ZnE7a6dhR5t0v+qCH4i9I5OrYf+WqRBhB2fH7W4gtIqh
	CVTnAltULaIvq4l81d4fQ8lRogvzd566ndynTgHyevftQBI43hPEbqx6YR/kLD0hxaw041MJNIi
	pYJMpkG3CXU+7jwsu/biPTv2L2WiBOoN3bOyZhl4UWtZg==
X-Received: by 2002:a05:690e:e8a:b0:66e:5f08:82c0 with SMTP id 956f58d0204a3-67170436567mr2947650d50.26.1789836600949;
        Sat, 19 Sep 2026 09:50:00 -0700 (PDT)
X-Received: by 2002:a05:690e:e8a:b0:66e:5f08:82c0 with SMTP id
 956f58d0204a3-67170436567mr2947628d50.26.1789836600531; Sat, 19 Sep 2026
 09:50:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260919022441.3305170-1-neilb@ownmail.net> <20260919022441.3305170-4-neilb@ownmail.net>
In-Reply-To: <20260919022441.3305170-4-neilb@ownmail.net>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sat, 19 Sep 2026 18:49:49 +0200
X-Gm-Features: AcwNN1Wzd3VwqVBZ8pDu1K46iGkfuTMoHWQj0DdBgADN8jcfrMQo_vnTAv0UsKA
Message-ID: <CAHc6FU4M59nodfn+NCDsr81Wdmvd1Ubw712FF56ekVWfe1+Nuw@mail.gmail.com>
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

Neil,

On Sat, Sep 19, 2026 at 4:31=E2=80=AFAM NeilBrown <neilb@ownmail.net> wrote=
:
> From: NeilBrown <neil@brown.name>
>
> gfs2 incorrectly returns -EFTYPE for any non-regular when __O_REGULAR is
> in force.  A symlink might not be an error, and nfsd needs to know if a
> directory was found.
>
> Neither this check, or the following check for a directory is needed.
> Both cases are handled correctly by instantiating the dentry and passing
> it to finish_no_open() - the caller will interpret the type.
>
> Signed-off-by: NeilBrown <neil@brown.name>
> ---
>  fs/gfs2/inode.c | 17 ++++-------------
>  1 file changed, 4 insertions(+), 13 deletions(-)
>
> diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
> index f361876c5583..7aa92bb31cf4 100644
> --- a/fs/gfs2/inode.c
> +++ b/fs/gfs2/inode.c
> @@ -738,19 +738,10 @@ static int gfs2_create_inode(struct inode *dir, str=
uct dentry *dentry,
>         inode =3D gfs2_dir_search(dir, &dentry->d_name, !S_ISREG(mode) ||=
 excl);
>         error =3D PTR_ERR(inode);
>         if (!IS_ERR(inode)) {
> -               if (file && (file->f_flags & __O_REGULAR) &&
> -                   !S_ISREG(inode->i_mode)) {
> -                       iput(inode);
> -                       inode =3D NULL;
> -                       error =3D -EFTYPE;
> -                       goto fail_gunlock;
> -               }
> -               if (S_ISDIR(inode->i_mode)) {
> -                       iput(inode);
> -                       inode =3D NULL;
> -                       error =3D -EISDIR;
> -                       goto fail_gunlock;
> -               }

as you note below, when the inode exists but it isn't a regular file,
we won't even get here (gfs2_dir_search() will have returned
ERR_PTR(-EEXIST)). So the above two if statements are dead code, which
contradicts the patch description. Could you please fix that?

> +               /*
> +                * This can only happen if "S_ISREG(mode) && !excl" so "f=
ile"
> +                * cannot be NULL.
> +                */

Is that comment useful without removing the below NULL check for file?

>                 d_instantiate(dentry, inode);
>                 error =3D 0;
>                 if (file) {
> --
> 2.50.0.107.gf914562f5916.dirty
>

Thanks,
Andreas

