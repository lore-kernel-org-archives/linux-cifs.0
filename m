Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2511018C008
	for <linux-cifs@vger.kernel.org>; Fri, 16 May 2025 11:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747393594; cv=none; b=dfeMkq+vTTDJUawI5cnD+JoNcNUOQS4v5c+cYemaY14LNUpmkI86AAjBO0PK5LGlP2joVxaUmBgQDNaa6g2Aw1am6dDvnQeWpbO8JZRLMfXxephRnNFPfD860xf54WAesXmneN5COHsGtkjGBOoUYqd7oMpbj0M4t3JIsE/ydxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747393594; c=relaxed/simple;
	bh=+1XivsRl1JIa6M/n8N42RYkLJ2q7E1T28ByAMCmtGoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mMNZR/ZlC1Cvvdqc8Mw+IXoQYqYsKpfNKmnaBXJytXAIXFy5D7PXzS1v3nbcG2lJC7LVGwiQBMVzGvoIL/EZM/iOFbQ2IIrlIdrwF0lKo0yd6XzbQxbIf2Nnb1Dj0yfHFGDGLNH8MgbidVOrfAWmYxKR19p75/N+p93lodIPGMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HulBzA0h; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HulBzA0h"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-ad5273c1fd7so238489766b.1
        for <linux-cifs@vger.kernel.org>; Fri, 16 May 2025 04:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747393591; x=1747998391; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GAPtVMIAwfK1eyG3xhj0bht/aC4rQhuyI/jhs1Ah5IE=;
        b=HulBzA0hupS3GnskllygjyolHRRTp4zS2WE+p26runmnI09FjsJBVjoo6Yw3rAhuRS
         kqJzytuWz0HIH+CWv8g5OIKDIueGwfrntFziMPRxKyyd/onHUjtsm/D7TTGBTlEdyuaI
         oT7jcbikwvqJTlCwsjPG+jzOIrUwETSuT6spEbcir/GqyrdK/ysz97DdNdLw5qEflXBi
         mgB0bUoJ88l3ZB5q8ADuN29KJAdVjzKGkIVTyGGw4PTWKYbFJa8Aadh0lwtgxL95i9Yg
         DEdA31hQQmHRrH/s/1zP4zbv9uSPjuSovUEU2vONtAdhuHxIYKIANiW6293aI3vEKN5H
         ooJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747393591; x=1747998391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GAPtVMIAwfK1eyG3xhj0bht/aC4rQhuyI/jhs1Ah5IE=;
        b=Vzu5vdTExPcDQ/tRlRclG5DhrSUyttDmXxP29xg3rmHgiDlr44GoqlqkPqiXxVDFIc
         JVmfrlrnIWHTan1aEqijMFcPYrU5Qhu5PtR5g1SAABOQVZWMyBp+YGIO6lHbfGrSKu1J
         B+bd92+bumzT0Mg/opMACYbSoACtTfCmeu2A6Ff27KK5pq36pWB12qYS54kOd91z4Ds6
         ctR0Q0aB9oSDOgK2k84z6zuo5AMyymeLtX8ReSKkuAhN69QqkdeuJqjrqv0MijSZhHdC
         Lihnfh65P+Ut+JW4PdrFxQb/cPkJUQhCAeReJTkQ34m6izFZQO4Svfc7LYfVZ/7nCn4q
         7o+w==
X-Forwarded-Encrypted: i=1; AJvYcCUS2hTef4X7b9iaHZOAKWe2vQQ3Z7CTUCjwPrynYgKIsSj7WjWBN/0iiWQI+Ftjwm6Ai3q7slf/DBHv@vger.kernel.org
X-Gm-Message-State: AOJu0YwOvRI9VqIS+YxsfHKXxy6lK8Wj9XfzBeMm3dKH4mqJDX9qmbCg
	u8fnBEmNlDiTyH+u9KdJI6QMuMZm/ihnKzg4HdPV60oMlzoNeshpXbj7NmOcpSpau5Tj/eF9fII
	4fDI/s+K9LTKwj25B1cQEGzJa9ujX1JjAZg==
X-Gm-Gg: ASbGncuhupHoC7qrt6iaAyCG+EjLnP9wQeBMRBPIF83YYeZLIfnFaxk+8uCfbC+52zQ
	w/656qasgblyb+TzHX+Iu3ct+Z5aqDu94MfE0W5mBsIpip2weooMF7AdHaarPPN9vHg79E0nh4E
	gTdh1cTk7V5NikE0VN0U+d9u3Z8QQ9Qxhmb001Qk1najOnYS4h9+vNOB51TwBebeU=
X-Google-Smtp-Source: AGHT+IFSg9m/F1vGldbeuEbpAbKoJ96zw3KuTeoohiai93JcaoirljSf8Up6uW3E9goGwL3G9dpew3j6TBGst6/CcgI=
X-Received: by 2002:a17:906:6a09:b0:ad4:d00f:b4ca with SMTP id
 a640c23a62f3a-ad536fee29dmr153572966b.50.1747393591167; Fri, 16 May 2025
 04:06:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <aBjK1G1igZ0UWaRk@stanley.mountain>
In-Reply-To: <aBjK1G1igZ0UWaRk@stanley.mountain>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Fri, 16 May 2025 16:36:19 +0530
X-Gm-Features: AX0GCFvpdtSAhss7Qg0z-2SSCv0vyForORdXLtmUFWIaxiSF5eOnTitEwOjyaZw
Message-ID: <CANT5p=qEc3wcuzXTRbDogA=j0Tpe6NHhigVpY-nuWUVJXwMc4g@mail.gmail.com>
Subject: Re: [bug report] cifs: serialize initialization and cleanup of cfid
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Shyam Prasad N <sprasad@microsoft.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 5, 2025 at 7:57=E2=80=AFPM Dan Carpenter <dan.carpenter@linaro.=
org> wrote:
>
> Hello Shyam Prasad N,
>
> Commit 62adfb82c199 ("cifs: serialize initialization and cleanup of
> cfid") from Apr 29, 2025 (linux-next), leads to the following Smatch
> static checker warning:
>
>         fs/smb/client/cached_dir.c:492 drop_cached_dir_by_name()
>         warn: sleeping in atomic context
>
> fs/smb/client/cached_dir.c
>     476 void drop_cached_dir_by_name(const unsigned int xid, struct cifs_=
tcon *tcon,
>     477                              const char *name, struct cifs_sb_inf=
o *cifs_sb)
>     478 {
>     479         struct cached_fid *cfid =3D NULL;
>     480         int rc;
>     481
>     482         rc =3D open_cached_dir(xid, tcon, name, cifs_sb, true, &c=
fid);
>     483         if (rc) {
>     484                 cifs_dbg(FYI, "no cached dir found for rmdir(%s)\=
n", name);
>     485                 return;
>     486         }
>     487         spin_lock(&cfid->fid_lock);
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
>     488         if (cfid->has_lease) {
>     489                 /* mark as invalid */
>     490                 cfid->has_lease =3D false;
>     491                 kref_put(&cfid->refcount, smb2_close_cached_fid);
>                                                   ^^^^^^^^^^^^^^^^^^^^^^
> The patch adds mutex but the issue is that drop_cached_dir_by_name()
> is holding a spinlock and we can't take a mutex if we're already holding
> a spinlock.
>
> --> 492         }
>     493         spin_unlock(&cfid->fid_lock);
>     494         close_cached_dir(cfid);
>     495 }
>
> regards,
> dan carpenter
>

Hi Dan,

Good catches. I'll fix them both.

--=20
Regards,
Shyam
