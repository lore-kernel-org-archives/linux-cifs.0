Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6C4F3D16FC
	for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 14:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777299477; cv=pass; b=iaghiUFA5RzwspwkuoBWlr+UXR9HI2mJgaoqIOxWVPRtBe8RGZfPWv+utWlzgYFMjnHoxqiXKWKCHjKK79qq5q0BBIMu5QhTR0N7TwVgUiAEBMaBPAx3XcITJV8rQtmnwiwQ/9+5m2ayQ8RExEA/VqJjSutce+/cv7+mJnQR/eM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777299477; c=relaxed/simple;
	bh=dCas8RQKsBsKm7RPEue3wRPtJ4lneFcySX6TUqGbvVk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LqZo1as4Kb+WtIp1eWNbvsC9HwMGG6lheEIk6FGLm7hREBvv1i06DCULRfJguUyjYoxzUS3bD9Zdto+CgpsiwleORXzQ0qaDhtETCiwhCDzKdLFVcCDz/MbAuMmUr8U7HLcQkJmk1ATm6nkJ6eCfiGuKTCvYu+uBQz4+uwJcWxk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UV7XlqUV; arc=pass smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UV7XlqUV"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-56f660d9a51so6587311e0c.2
        for <linux-cifs@vger.kernel.org>; Mon, 27 Apr 2026 07:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777299475; cv=none;
        d=google.com; s=arc-20240605;
        b=b2SVO2lZ91fiLRcYCdM3l/9u7IcqBh9q7IXdODw5GlvGTRHn8me/l0yUC6KB+ukZ+Q
         NhtsoYg582GkAOMY7vyL3oSiyaETtewemP1Ru39HPkSSwA1le8hWiualmc2dsc/iOXRe
         JE3PBPSXOgBclhOGYl8OQwi61w2FWcUbBhdenJy6XWkWejQKqDAGRAlAfV1wUO+CyODw
         scufR2+lFiLA4Qe63fgwEAbFLNrS7EfiqjPajy8FcEtt4iTBKcRrsv2DcrF1GptvT9uF
         tUxJXftYX0jlrcHOmAl8GPFvu7zB7l6yzTc7xigrvGaL1mJ9BhcFBZRJ1/nxWAK9XtTe
         ua1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mZ1b/SaO6jwDwL2+8FqnCPqXNKQ2XKB8aPpu8Tl3aso=;
        fh=wKM1f/dVe52cKKIvBhTUzZSrC6X/XxnY33drDDICwm4=;
        b=OTyz96XEcDjoxQZhHxZ/dgyHLCSFwKmykXqc1s0zP0WsaIr+iWANbZboZAp4YbAQv2
         c/lorciPtsat9VMTMM0Ol86C20fQT46DeHnOU75lTQZHokXhPFcr2S5r2Kev0iklk/QA
         wTLvfPiHJxAIXE+vQqSzh/QzI7V2b34p1Utg/tnIL61grB5X6OFu9pWznE0xnTu/PTAX
         x5nnHxslvESF1RRy2pM+Tuy9BAzXlUOp5J118VDzsjH6Iqk/vjsMY5wGrTmDU2CCp3/U
         lf18MKqF1z7UID2WdFDrkr7PR/qDjEZ/HkoFXY8/cOYX+ZSJyylWh6VmAZbB4VTGDB+B
         bFPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777299475; x=1777904275; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZ1b/SaO6jwDwL2+8FqnCPqXNKQ2XKB8aPpu8Tl3aso=;
        b=UV7XlqUVvinNvlG4ozIHjmCDkWLWkXqWdHVlwKleD4e0udKlFPCyhDThue+4KCSFuf
         4PPkqV7PBmqSm85u3fIzULTAc9+wtQaK8rViECu4uoP52DqNbn15+/ac4reFdyXrn/B1
         s3/x0N6JxPqqHQ+SvjX5nH64ret3FMse3JDW0UFDRIL8eY4pp1TNXlldauyddtT20e1L
         qF3CPo8D4Y7Ek3KN8fARmEEs5LMSb+8CfKYUV0BkpMnaU5nmr2gie+0EpOmT51BfojAE
         Cr7faIb0pQuMBU6P/HjjO15sUUH7oPx7M3XGM8FLv2JB+tutyWbnxLL5ubYguDpuqSMe
         bJpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777299475; x=1777904275;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mZ1b/SaO6jwDwL2+8FqnCPqXNKQ2XKB8aPpu8Tl3aso=;
        b=i7NSZjCVJkTcvWOw9r2eFjhhC+IbnwPVeDYNq1AH4CrOUb3Skk+UWxS5OVg0SCChnA
         ZO+j0Q6p2a4LaXz3r4rVln0t12eUCr4fO2KOqsz2wYaUySJeXQoNAPAwiHOygyPB8de6
         bDkrhAijNRJWgnthWJxHJu3vg4zgR1SOVVvE/uee32FYZUMSHYrBd4lhbldEbk6xMsQ+
         tifkK7teRV3g6xaK8sayG3qu8Jr+JnTPO9gsm1NoNaNk+FaMPMyEMQHz08KfzXd2o4gH
         mtIn4/q2u78ULd2Sa3F2gZb5z6KMVMB3w1MFmgqYFVZIBEwaY2vdPd8p5usBrVk1f2Ym
         E6Fw==
X-Forwarded-Encrypted: i=1; AFNElJ/yahTv9Q/3yGF9UbPtlduVQkF5mqEVtbcApNK3fW7D+KxTdRE4puf5GCrOzJsIH4UgZW/PQcJiotmW@vger.kernel.org
X-Gm-Message-State: AOJu0Yw7SK0ouf96zBfa04T4Xxnm/wnRxyKnCJYcR0xzIgO3s4261FRL
	rjWcb4qEtvGSLY8cg/Q0Teg2N+36eRstIr/jRCQzCsxAo2iiIHgqKMtmL2afPd9Xv0rhi6hDSBb
	yFtjhvtQ0xV7JQnfx29/bWw5TcRbxzDY=
X-Gm-Gg: AeBDiesS0XTGfhYki6SrYcY9NB8Y4zw+Me3SJA2G484+eUEiMgFgQ4VbwIB6hAGVMhM
	he1u9akCPTQu49lWBdlXVdSo57KlQYk91H43Ilqv0o/JUfkZ8HTn4bEv8hQCkty2Is4ymd6EMAa
	o3PgBw73JA52KgQasGoG21XPj0pNxH8le1oFiSf5UCHeLyE9kRg++tX1tl3cwHwZXqcCMfCM7Ga
	MQ3fT97Btr82HnbJVOcPcyYaxY+ciHewcN7jEL9H1UUB+8urs2QIpzkkmbT6UR7alftQcqdRiIP
	7OPMdlJOoqMFOhHdc5oE26SWyw0eBJOSOtkJLLyFw2Z4Ez7FqIhS
X-Received: by 2002:a05:6122:8d3:b0:56c:d5cd:1e7c with SMTP id
 71dfb90a1353d-56fa58856b1mr21307327e0c.5.1777299474612; Mon, 27 Apr 2026
 07:17:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260328172314.45807-1-dorjoychy111@gmail.com>
 <20260328172314.45807-2-dorjoychy111@gmail.com> <lhuzf2oy1me.fsf@oldenburg.str.redhat.com>
In-Reply-To: <lhuzf2oy1me.fsf@oldenburg.str.redhat.com>
From: Dorjoy Chowdhury <dorjoychy111@gmail.com>
Date: Mon, 27 Apr 2026 20:17:43 +0600
X-Gm-Features: AVHnY4JD2JZaiwDyyuW_kBt_sHjEkoUZKURjGdK7nlj6KmXsjRIqpl4zFGzklnA
Message-ID: <CAFfO_h5B=Ox9S=Xc=az2vQwowffohch-mkvSggYAfNXaVuv5GA@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] openat2: new OPENAT2_REGULAR flag support
To: Florian Weimer <fweimer@redhat.com>, brauner@kernel.org, 
	Alejandro Colomar <alx@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-api@vger.kernel.org, ceph-devel@vger.kernel.org, gfs2@lists.linux.dev, 
	linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-kselftest@vger.kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	jlayton@kernel.org, chuck.lever@oracle.com, alex.aring@gmail.com, 
	arnd@arndb.de, adilger@dilger.ca, mjguzik@gmail.com, smfrench@gmail.com, 
	richard.henderson@linaro.org, mattst88@gmail.com, linmag7@gmail.com, 
	tsbogend@alpha.franken.de, James.Bottomley@hansenpartnership.com, 
	deller@gmx.de, davem@davemloft.net, andreas@gaisler.com, idryomov@gmail.com, 
	amarkuze@redhat.com, slava@dubeyko.com, agruenba@redhat.com, 
	trondmy@kernel.org, anna@kernel.org, sfrench@samba.org, pc@manguebit.org, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, shuah@kernel.org, miklos@szeredi.hu, 
	hansg@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 27, 2026 at 7:28=E2=80=AFPM Florian Weimer <fweimer@redhat.com>=
 wrote:
>
> * Dorjoy Chowdhury:
>
> > diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generi=
c/errno.h
> > index 92e7ae493ee3..bd78e69e0a43 100644
> > --- a/include/uapi/asm-generic/errno.h
> > +++ b/include/uapi/asm-generic/errno.h
> > @@ -122,4 +122,6 @@
> >
> >  #define EHWPOISON    133     /* Memory page has hardware error */
> >
> > +#define EFTYPE               134     /* Wrong file type for the intend=
ed operation */
> > +
> >  #endif
>
> This is what POSIX says about EFTYPE, in the Rationale for System
> Interfaces:
>
> =E2=80=9C
> [EFTYPE]
>     This error code was proposed in earlier proposals as "Inappropriate
>     operation for file type", meaning that the operation requested is
>     not appropriate for the file specified in the function call. This
>     code was proposed, although the same idea was covered by [ENOTTY],
>     because the connotations of the name would be misleading. It was
>     pointed out that the fcntl() function uses the error code [EINVAL]
>     for this notion, and hence all instances of [EFTYPE] were changed to
>     this code.
> =E2=80=9D
>
> So I'm not sure if reusing this name is a good idea.
>

Thanks for pointing this out. I had started out the patch series with
ENOTREGULAR and it was discussed that EFTYPE was a better and more
generic error code which is also used in BSD systems like FreeBSD[1]
and MacOS[2]. I also agree that EFTYPE makes sense. We can of course
change to something else if everyone agrees.

cc Christian Brauner who originally suggested EFTYPE for input on this.

[1]: https://man.freebsd.org/cgi/man.cgi?errno(2)
[2]: https://developer.apple.com/documentation/foundation/posixerror/eftype

Regards,
Dorjoy
