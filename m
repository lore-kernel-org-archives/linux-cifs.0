Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83AFD27816C
	for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 21:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782853307; cv=pass; b=L9/fuiuMxHkmcDjSj++krV1cL3i4xPIC9yZFKmkdVRqMK6KObfK745oMLSiCohLp0vAXL4c+9QGBom+TQyLskh4WhbPFAn35Qv8Ox1s3kONeZlG4+/Juv5vIC5cuHjq6SJ3VTOgracQYcBP5K3J+mlc1ztVsgsScu113f2St+jg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782853307; c=relaxed/simple;
	bh=ZvxW29+NadKM7GaAw42DZuCFjnpHd8lW+eHx1b5x6ac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oMURGPhkMsqmHpVX3b6lNLBSMD67vgBgh+wpKs864SYvJI4rgaWLXaf1w4HZIXH7Bbpwfi02JfGFoUvVXhJHt+nysov+8zY1aBSpMby3WvJkGlwPzXzSykS5D0Hr4AA+TZqhpZG0NMDGQU/iP+34gWO+SF5JHtro+YGMLzAb2i4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=L0K49Apl; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L0K49Apl"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8eabb1a9378so34490226d6.1
        for <linux-cifs@vger.kernel.org>; Tue, 30 Jun 2026 14:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782853305; cv=none;
        d=google.com; s=arc-20260327;
        b=iW/mQHPrHMezZyCl4m+P5wspZEDTBV/QhxWhYRxP2CAWaGPkWuWtjzNDtE0zBXthB8
         WBDapgzrcgojeoWZpY+POcTk6gw+3vsfWISoXMIpFBi5QZtgiFZvm4Db3Oj29IOqYVgQ
         XRc5LWGeA/gDuy+QLLuq3+jKjdq+lMnWB1010k5Lm28hqCTm8/UOn0A+N6IMnc3J0usW
         JzczI0bTj7rFQCXk4ncFIyreDWfhOMU37CiEZwCWipSPgsBq1zEi3UY+oYArBFlbZPOR
         GhLtk3i4z0okel+R5IZpKXu52qJhnVby7Q/TEBFuo1vFYe9ecudmvp2KDS43VEeQtAbV
         ic8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fDgqPJ9TiYfhoCyUr4vDDHUCYFJ9XHy3O7vUIMeKeEs=;
        fh=4i/2BMMZobHtt3qUlR8rTn7gEkEPv7yKnjBjtC9IS6o=;
        b=c49M2DhVWwg+cvsCTbCFrRSACVd0Xd5V9kFeyC1LX8hjuD4iy0DHHZxOAouFeoFP+G
         Oi9pSgoVjjyVZ3VcnJs4hw2Zo5WzHj6XyzxvmxK2BodznjX3+/XJmCK5VUAGrGYkYell
         JBX4ccXhfQIb4h/+5NEUIYepUUhM6Cfj5toB6cxxl5xRdB4/48ckB1wxdzImTPXHZOew
         e2wpaIQeZcNxRQMMOE2LygGGkkeUfxBid6YaKpaVBPADowBiWfroL8K7Y8jbB7bD7lZv
         463CFUzetEwWtPvwj9Vll6LUO6vXta1dc196S6uhxYrpU2rNJJSQo1QoYp9NYkzNEVy0
         wt8A==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782853305; x=1783458105; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fDgqPJ9TiYfhoCyUr4vDDHUCYFJ9XHy3O7vUIMeKeEs=;
        b=L0K49Apl9l2MyyvnAybT85e51wRXYN27kALfuaxz7qNNiz23j4gJYtAYSqRPkW5EY8
         LffCvaNzYuIHXkfWuyWO/z64b1ut8FgT5Jy4RH3iVkcjw6qyZimsS4kYh1hYjKpXdUJm
         pu+6bqULxSgAuoKUDSvqFpJJt7+G5mxCGSH7IWa9RmfLPq2DPH6f+SVV/a8wzbNTlwyU
         UrAkDdNSsyX9dlf/z+TEx/T0rk8J5Fmg7trVwjYcCRLlXVXGNDroPxGd69Gv2F/cPeYc
         0zy6PKVP/dcd5uXf8kZXId2/etiCHFp81uuZMTcpja22P2TfuaB1RSigZMo9JSDIFuo1
         w25g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782853305; x=1783458105;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fDgqPJ9TiYfhoCyUr4vDDHUCYFJ9XHy3O7vUIMeKeEs=;
        b=YqfqhVkewPN8A6YiRmtIap/++G2WUX2zg6Vd0mkk1TV3W0Q5dh9d/psu2Xwtt9JYDx
         mz56xTKJWWUqZIO+NxbO8bpLl5uf/aHA297WNMnebvvpOi8the5tpQ2yIIjGfBb5+J8B
         7d3irHwvCqFfq1HRPmzjO9WJcdLE3P82cg33RznwaP0hVP8l54X/kAw+tUdH+pX7ROzA
         8vCcoZZyghkfoi5qRyaFV5vkDMDntbmuwrZhO3DkDHKUoREo5V1nI2lHA3lXam8fjC2L
         ueATTLmG1W+Ls4Ugy6ckOJTTbe6P5KiLjSnuJEJaE85rXwzjtvxYbCM8VDascHNjb4D/
         EUbg==
X-Forwarded-Encrypted: i=1; AHgh+Rr52bQsi8BZNsHoXCRyt5U+0x3lwtapzxuNHIRXr1172HsPzNzhzXKLQqJQFtwx+gNL0Z9w0UuYwlEh@vger.kernel.org
X-Gm-Message-State: AOJu0YxMQH1IPLKCDJLGKNv18j5TJI+mjTftMxvtg7wHLZ+YAPLD5Phk
	mUSekZtqk1MtLbAdIVUEpdke0NDHBgk/yjxn1nN7SpX1UOI5Wmcjf9tmAxcoEjl+Jzln9grRAMn
	SnhgviwzURfTi1DIjGI9e7ZwyQjGy/8o=
X-Gm-Gg: AfdE7cmX/1x6vTkKoxuM3gGlXHVQEgFw1cIkuy06Mxf2APDsSTgvG48LPpRd6FIgxxJ
	OR8FlvmLbNn8XxXFAuGBDZ4M95K2Ab163/7GtLcWZEJlAcfQIz7MzU+lUTsd50CgbK0PwUzO+Ao
	2PWvGHvMgNoxM5vl9d/AA3Uxj5cqIkUrW44v0siypum8Z1RHTGUD6kYf6vI6Vj4OzLCbNf4Dme4
	n93cQdRkrcXDtG3ZcseJGVIGgIQlj4Uu+LmrQvBwsvkUIbKjm1TeLNmVzLRwTq3frmw+X2C8Oj8
	PnlC26SMQmlhK6OnE32A59ZkaK4Uv9lmLOZVaOI63TNj+k1PT9xZyWofix9C8Hy4+on+djFHyy9
	hC+f92OkIcuzAMSsPo3QGbOw+g9DoiC4+8QmJ6oFIYwGp67CnjiDzuWxqcLB38TcQYpQETXhahE
	jCQe8NQXPdwUo7onKvMpuoaQ==
X-Received: by 2002:a05:6214:3f82:b0:8cc:d588:4523 with SMTP id
 6a1803df08f44-8f1b9dd6485mr86219166d6.13.1782853305232; Tue, 30 Jun 2026
 14:01:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260630195521.1188778-1-henrique.carvalho@suse.com> <DJMNLR4D4KSX.2GHLCM6B2NH3K@suse.com>
In-Reply-To: <DJMNLR4D4KSX.2GHLCM6B2NH3K@suse.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 30 Jun 2026 16:01:33 -0500
X-Gm-Features: AVVi8Cc8MuOVpSiGk8dRknV9zwPVS2uW1lCWfTRmkKkFo-s11L5ZEEBHdJ_LuqI
Message-ID: <CAH2r5ms-2R2Fuv=NRZdAzEqq3hL=+0Y-gc18VrO792RrgjSpSg@mail.gmail.com>
Subject: Re: [PATCH] cifs.upcall: Avoid int overflow after year 2038
To: Henrique Carvalho <henrique.carvalho@suse.com>
Cc: sfrench@samba.org, pshilovsky@samba.org, linux-cifs@vger.kernel.org, 
	"Bernhard M. Wiedemann" <bwiedemann+git@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Applied to smb3-utils for-next

On Tue, Jun 30, 2026 at 3:07=E2=80=AFPM Henrique Carvalho
<henrique.carvalho@suse.com> wrote:
>
> Reviewed-by: Henrique Carvalho <henrique.carvalho@suse.com>
>
> On Tue Jun 30, 2026 at 4:55 PM -03, Henrique Carvalho wrote:
> > See https://en.wikipedia.org/wiki/Year_2038_problem
> >
> > This patch was done while reviewing potential year-2038 issues in openS=
USE.
> >
> > https://web.mit.edu/kerberos/krb5-devel/doc/appdev/refs/types/krb5_time=
stamp.html
> >
> > Signed-off-by: Bernhard M. Wiedemann <bwiedemann+git@suse.de>
> > ---
> >  cifs.upcall.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/cifs.upcall.c b/cifs.upcall.c
> > index 01690df..1cc9767 100644
> > --- a/cifs.upcall.c
> > +++ b/cifs.upcall.c
> > @@ -247,7 +247,7 @@ static time_t get_tgt_time(krb5_ccache ccache)
> >                   !strncasecmp(name + KRB5_TGS_NAME_SIZE + 1, realm,
> >                                strlen(realm))
> >                   && creds.times.endtime > time(NULL))
> > -                     credtime =3D creds.times.endtime;
> > +                     credtime =3D (unsigned)creds.times.endtime;
> >               krb5_free_cred_contents(context, &creds);
> >               krb5_free_unparsed_name(context, name);
> >       }
>
>


--=20
Thanks,

Steve
