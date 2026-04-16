Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A23DEAC1
	for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 14:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776349302; cv=pass; b=gi3k5Imizy86+q5DPKrxVzjMOCqMvvDvGjNUd5nfl0x7rnhWUIPP35Dsdj5i9FC3RlE/ngw5ivKcRuBYakU5nwLuwqvxScasq+eAGZu2mWCQPeLKlGmSVZ7/MZ8av3sC6mqWvbrxnYK0vrRo2u/Fqmemdx6Jd0O1vrcMBVQn70g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776349302; c=relaxed/simple;
	bh=MPSStrB5WQZXjuD8LVCQJRe2/QVXDyCuUjmphyPyAE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=GPqajYoGVz7/Ogw6B89TG6IBSzlzNtwkqZjowSQ4n7+9yjgPEx0ISv8RCP1i4mHSKNf2GJl0Mrd4uTzUbtJsZ1ovMM3zTWFL9UL2V4GqjOwbmThk4y2Y1Q7LDNAigfpdCTu5WeIwAO2pgr4aUVLVd1bD7WeRTZh5lhiMb5EUY44=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S+O+I06/; arc=pass smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S+O+I06/"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-953acf7ae20so459102241.0
        for <linux-cifs@vger.kernel.org>; Thu, 16 Apr 2026 07:21:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776349300; cv=none;
        d=google.com; s=arc-20240605;
        b=aeKYhFe6+o7n0T6AxpwetUzJxUl5/6H7miirLGuO4OjnE3KxAvQJnKieueBLbz1iTV
         pTQDtY/U84ecLKrGN9XsYkIZXV1nKvMIoZZKbfwhwsbR9HV/j4muK5GL4bscXl/BA5aA
         P59EZRK4/VCxLS+8dAaie7yfSxekbmYH0GWynQGqfldvKorij2USl8EcIg3TNUw9RDid
         FRzPnmLPP0AtnUQiuWH+Jn9v/WuNHgU+23Bua0mnIgVw3cAGowl1YdI5IGQWBJoAmf5V
         IgBfiyzXqqLi3Ehc071weC3oIMV1agf4UbHNfdwUzfSe3I02qi5DmL4rX+N4FkDE10ld
         5ZyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lO8+zS1qnuU0zyUegMfTKGfj9Y7WBTQIob4jJAeuR1I=;
        fh=wFMiFsgLisCd7cMpHLG1G65s9wdYw73YGXo9xtuhkoE=;
        b=IcivHRRQLN+Frd5MgB6e4s8zC3slQPWdXB4ivU19tYollSNE6hCjo8YCduPUzmc22K
         NjHJaN8vMUikGKrc/1XA2Dw0cZI+y9nEOV3XTqm4Sx9dyFMX0Ple+CGr4QxvoGh4LbqS
         7pmSWFYdzJv3CI7TqHmWfh7h8hJ3SWjU/JPEYrI1osOxLv5pIqltxHoFwvLCDijeBi0T
         3qjsuENlQ+duE8CgLiIhazLdf2Mb3YTTnsg1qrEEv1MCdAJOYg8JWMJ6t/Rg9QcSxbAa
         xO2ktC1DuP2qBFuA5ZICJZO7j1s+XRIxDOsuyjrayXe2sEYtc43QlMuT8yqq02DalCu5
         S18w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776349300; x=1776954100; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lO8+zS1qnuU0zyUegMfTKGfj9Y7WBTQIob4jJAeuR1I=;
        b=S+O+I06/bsndk1ren2sbM0LafnTLke5s/YTY8d+xK85qFvLskc9abtgZQTAAGdHXkW
         gQ8OcqsAvXDSUsE/qTNg9RdNmoee/lFXrdR4ucPesp6PxtFUHBJnk2opxD4WhF7p39fM
         JbLJG4K9nLOk1IWPQT6/9UECkqMXhPWZBwfmOtBlB/tDpW5BKsMpvE9DTyB4a3Knto5N
         O6ngJcs5AXuxkhGkB6nfrl1OMvAfh3fOP4DF0wVQe0Q8EJ96obTWMCn/Ykaj1QnqTfbR
         Y28+pO3WR3EhH13uOiaw9rJINIUVvIgJe+Bk8hsVZpSq8xjX+CnPVc9rKipwxH98+XyE
         eXyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776349300; x=1776954100;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lO8+zS1qnuU0zyUegMfTKGfj9Y7WBTQIob4jJAeuR1I=;
        b=Qg2IhfGs2BbRDjpmmhZlDkzSq2Pre0gQ1ZAaORxu17Duo8br1j4XQrwrXqNZrDFx2v
         iB8GCehVLinwmPYtr1hUBxAAsQJkBgMkJLw/+dzgltAnpKILlyZpzeaX1x9Jt1V7Viwj
         HWHVu4ubxj6dG/8Gw9OzXUr63v858mcvj6d4SFSAoMzqgQgsFFUvjyqJ4JAo522BQy5C
         4a2hbAIhseFZfYq6Mxu1YVMTpnRZzK588KI5zdn536nXMGrgAJI3JyjVGC3vVnwTIgQv
         m2pPmgiqWTMNYWb/9VU5KCYeDBDvs41yKFDFQRmjLuD4c0SYLQ2js8gwUnBPCq0WyJHe
         wE5g==
X-Forwarded-Encrypted: i=1; AFNElJ+iWvgpmHy94nAaiCtBOV18d/uj7FDLZu4cC3MkSAjHJm6lArLDn/a4o60dQynWAfMVFugzUxuJg+/X@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8fM2cnPlb05/dLNcyvGQM04cmi+IcCvwq9+9Rg8DNXYvZI1+V
	17enDbTEuNrV28Cd2Hz52KFfWQDh6o+c2QAU6ADmGTcMTU4Q+oHk3nN1+3KNfmlN4OxZ3Oi9fQm
	WCPwdt3j5JP7udAyrApJocp8ceu7WfQkPz6Y7
X-Gm-Gg: AeBDietpRTjbRDQIa/64Jt9NS+Vb7P1HaMrVJbHUT9Vc/A/homMRVbiPpYJPpfidyy/
	W4GVCcVrqENomwx1/OpoWG7zSc5OXHQazUMDh0ds6wyCKqoarTs94omVnBueCR+mknKogF7oOhc
	bCbDLLFcMrw3D1mbZcuq8AhyQI0Gm/uX6xCYeP9jRUq6qy78JgwOPlzN+F4VqVSrwSWNBUwg7L6
	A5Wy2KL0qqbRLlAXXncj7TbBF/yudNe1bMjkYPbNYKzKkdln6jlCaFa82u1hcujXo+8BAz1YHNw
	i621ey08JulkdkwLzaWslYLZ3PGBdf/xUlYRi7rVWQ==
X-Received: by 2002:a05:6122:608f:b0:56a:8f7c:49aa with SMTP id
 71dfb90a1353d-56f94725c32mr1843622e0c.4.1776349300022; Thu, 16 Apr 2026
 07:21:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
 <20260328172314.45807-2-dorjoychy111@gmail.com> <aeDpIgfDaIKEaBcL@lt-jori.localdomain>
In-Reply-To: <aeDpIgfDaIKEaBcL@lt-jori.localdomain>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Thu, 16 Apr 2026 20:21:28 +0600
X-Gm-Features: AQROBzCVSNvQ07toCtw3F1sHPLg5Z_-nre3iq90Dw0MflD8nQqdsL_RQ56rFZc0
Message-ID: <CAFfO_h6pkyX=uN5uoXda6toTtT6KsahfBNBLom9i21HdZ7JOmQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] openat2: new OPENAT2_REGULAR flag support
To: Jori Koolstra <jkoolstra@xs4all.nl>, Dorjoy Chowdhury <dorjoychy111@gmail.com>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, brauner@kernel.org, 
	jack@suse.cz, jlayton@kernel.org, chuck.lever@oracle.com, 
	alex.aring@gmail.com, arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, 
	smfrench@gmail.com, richard.henderson@linaro.org, mattst88@gmail.com, 
	linmag7@gmail.com, tsbogend@alpha.franken.de, 
	James.Bottomley@hansenpartnership.com, deller@gmx.de, davem@davemloft.net, 
	andreas@gaisler.com, idryomov@gmail.com, amarkuze@redhat.com, 
	slava@dubeyko.com, agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org, 
	sfrench@samba.org, pc@manguebit.org, ronniesahlberg@gmail.com, 
	sprasad@microsoft.com, tom@talpey.com, bharathsm@microsoft.com, 
	shuah@kernel.org, miklos@szeredi.hu, hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 16, 2026 at 7:52=E2=80=AFPM Jori Koolstra <jkoolstra@xs4all.nl>=
 wrote:
>
> On Sat, Mar 28, 2026 at 11:22:22PM +0600, Dorjoy Chowdhury wrote:
> > diff --git a/arch/alpha/include/uapi/asm/fcntl.h b/arch/alpha/include/u=
api/asm/fcntl.h
> > index 50bdc8e8a271..fe488bf7c18e 100644
> > --- a/arch/alpha/include/uapi/asm/fcntl.h
> > +++ b/arch/alpha/include/uapi/asm/fcntl.h
> > @@ -34,6 +34,7 @@
> >
> >  #define O_PATH               040000000
> >  #define __O_TMPFILE  0100000000
> > +#define OPENAT2_REGULAR      0200000000
> >
>
> I don't quite understand why we are adding OPENAT2_REGULAR inside the
> O_* flag range. Wasn't this supposed to be only supported for openat2()?
> If so, I don't see the need to waste an O_* flag bit. But maybe I am
> missing something.
>

Yes, OPENAT2_REGULAR is only supported for openat2. I am not sure if I
got a specific review to not add OPENAT2_REGULAR in the O_* flag 32
bit range. But as far as I understand, for the old open system calls
we can't easily add new O_* flags as the older codepaths don't strip
off unknown bits which openat2 does. It's not easy to add new O_*
flags for the old open system calls since that could break userspace
programs. So I guess it's okay to add OPENAT2_REGULAR in the 32 bits
range anyway? (Also lots of code paths take 32bit flags param right
now and those would need changing to take uint64_t instead but this is
of course not a reason to not add the new flag outside of the 32
bits).

Regards,
Dorjoy
