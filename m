Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2E315D5B4
	for <linux-cifs@vger.kernel.org>; Tue,  2 Apr 2024 20:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712089706; cv=none; b=DTh9u5SaA6UtsLMr6d035+uy3eNFXoKyle0x7G3sdSvrCCNjYwxoRaV4yQ8VkvVxgYkQjGJIi3T1Skw9NwCI6F2aRf5Agsy57LzyUPiOd85L8L90A4S98Nfktf/3VgdRTH9Ou+GXIrynjabNb7yPCfnQwzYFzL2diOFITDLcQGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712089706; c=relaxed/simple;
	bh=LfVYX8aS+uGvfYiFPza5xfpJggy3wA1TMy/HX9tJed4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=txEdInPlfImtXBdK2d+fNmrphnOl7syZ1fJcGT3iWuZqnD52/pLs2I9vL6ZW8IZCwWOPfl/XVAwlOdAgjaWmN/iUqI0tDxru0iM7YVVg1tTUlwQjF/9BLK47X8iJjWLxPZlRR2wXby4UPeMsh3PuVqHywqomgnV5bjoeh7VvLmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=CW9yCGB4; arc=none smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="CW9yCGB4"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6153d85053aso7431717b3.0
        for <linux-cifs@vger.kernel.org>; Tue, 02 Apr 2024 13:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1712089702; x=1712694502; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CoSv33fHX+PiwFO/k1mr+DGe32nj0k4cYvUK0De9J/g=;
        b=CW9yCGB4NsT7Ls+jy9a6DbYdVWYC6HEPWhP+LRjpxT8xZbfmT/2MlJpXWm41hFvCdP
         zJcJJbaBAJUmVDzLx+hbesZBDJqjxEXn44gC0Jz6qf5Q1jK9t7SmMdIWQtYqGGSg6nTt
         hwsNtV1wVZp12mAgDmTDKqNY/9b/yc+RBs82dlEuWi5kyKpFqVzlmrnUqznGfzPQ/XU8
         ntcMqkXDQamfcIVrut1I+Siwehow7GjMTqsb50uULbCq0hX9vWVPwwhvE3vqZJ2UU+hZ
         wlpdv5vqjuG+5w4Tik6p1gB66uVC+iXGqaJAmKZVpCoep2DV72fT3+g61GehW+I14v7W
         F4pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712089702; x=1712694502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CoSv33fHX+PiwFO/k1mr+DGe32nj0k4cYvUK0De9J/g=;
        b=GDFjz9E04qsIcJzsl4IMhs+1A/CN/CzkToZhECOKCGEGXuPwCtphYe2kAOf81e5iOC
         9yYPI8YUzPnbO7S9wIuatZVTQtvUXidJc+zu5Ule7o7iuHlmkH4Ao8vY54GPWS6ug+N+
         yvq1IwxV8lWzAbP6VVFxbMOzyQNejgtIWSvoDvXNNoBEwTGQYrz+KTPGnU5uX0LwvL6I
         LOq8WVPf90aXX6KwVvf4IapHY+o4x+ud/sMXh3Lnh9Wiz6YrsfrKzsvFYjiQRbED0LVG
         OHX6BBYSeEWFhFgssLGQfEXoSVz8HauBBQ1xz2Jbt2p8+4W7TEyJx/o68FRBhhcI7agQ
         Y0zQ==
X-Forwarded-Encrypted: i=1; AJvYcCUxeMNhUftVUKSBZcUFjGlRxA5XSVzI/wJ0qbavp6YuBVt/E9r52Vh39YO9I5MwcNWQkpXt+YyCQi1hAxlERFTVcAiSc22SriDLUw==
X-Gm-Message-State: AOJu0YzUKl8j4X05rvnW30xSQzRYc9vXhYPH4E071OnNiSz18iwgBBd8
	689Wp4Pdf64SG6/EihlwhV1M5Rjmx5Twc+O14KSDZ73bX/8M/7zlEkxcPVLedCsbmnAc2xSDRIw
	QBiI+bqrrL5yoRdl4XE9xd8F8FUWYuTQBbm5h
X-Google-Smtp-Source: AGHT+IEVBN+nZl8MKEmvtUo5GMbK7xeKkzls5qXpx0s2OutO7Jvpps2qS6SsUR1HM2jxzRpzT7CFKW3Wf3o/srFXHhw=
X-Received: by 2002:a81:5342:0:b0:611:2eb4:2402 with SMTP id
 h63-20020a815342000000b006112eb42402mr12634897ywb.21.1712089702684; Tue, 02
 Apr 2024 13:28:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240402141145.2685631-1-roberto.sassu@huaweicloud.com>
 <CAHk-=wgepVMJCYj9s7J50_Tpb5BWq9buBoF0J5HAa1xjet6B8A@mail.gmail.com> <CAHC9VhTt71JUeef5W8LCASKoH8DvstJr+kEZn2wqOaBGSiiprw@mail.gmail.com>
In-Reply-To: <CAHC9VhTt71JUeef5W8LCASKoH8DvstJr+kEZn2wqOaBGSiiprw@mail.gmail.com>
From: Paul Moore <paul@paul-moore.com>
Date: Tue, 2 Apr 2024 16:28:12 -0400
Message-ID: <CAHC9VhSt0GkTe8ho2yyP8Bp1rbtiFbp6dNY6m93cvBXJ=aKtSQ@mail.gmail.com>
Subject: Re: [GIT PULL] security changes for v6.9-rc3
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roberto Sassu <roberto.sassu@huaweicloud.com>, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Roberto Sassu <roberto.sassu@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 2, 2024 at 4:27=E2=80=AFPM Paul Moore <paul@paul-moore.com> wro=
te:
> On Tue, Apr 2, 2024 at 3:39=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
>
> ...
>
> > But if we really want to do this ("if mknod creates a positive dentry,
> > I won't see it in lookup, so I want to appraise it now"), then we
> > should just deal with this in the generic layer with some hack like
> > this:
> >
> >   --- a/security/security.c
> >   +++ b/security/security.c
> >   @@ -1801,7 +1801,8 @@ EXPORT_SYMBOL(security_path_mknod);
> >     */
> >    void security_path_post_mknod(struct mnt_idmap *idmap, struct dentry=
 *dentry)
> >    {
> >   -     if (unlikely(IS_PRIVATE(d_backing_inode(dentry))))
> >   +     struct inode *inode =3D d_backing_inode(dentry);
> >   +     if (unlikely(!inode || IS_PRIVATE(inode)))
> >                 return;
> >         call_void_hook(path_post_mknod, idmap, dentry);
> >    }
>
> Other than your snippet wrapping both the inode/NULL and
> inode/IS_PRIVATE checks with an unlikely(), that's what Roberto
> submitted (his patch only wrapped the inode/IS_PRIVATE with unlikely).

Nevermind, I missed the obvious OR / AND diff ... sorry for the noise.

--=20
paul-moore.com
