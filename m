Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1677FBC8
	for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 13:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711631041; cv=none; b=R2JhWGR011mMzIYOLjZjT5BkmrmaBEvVOCDQr7fpw+6S1iDh0SihQ/CZAf0h/UnI6QsiCud0QDXoQm/Ki4PZo4t08n3mk8PAuGrzwkWrhpH1rAZoxwTUkYBeGkHL8OxdXMjo/W85E8H1JEtJ4JhtmpEyogfPu6dD7e/98iA9RCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711631041; c=relaxed/simple;
	bh=0V+RuvRGf3jpxS1g7uK7AxOydCxdLV5z/H6WKNFKKl8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VMUDroy4e+NwLJjeUskEv9iX3kmvGcincipBXIcYFUujd9OeiIwUTx+ToSZtWOrwAj7S5RGMKT+brMV4GDCOGh2f5kehULWHcMya6OllHNNOvH8tUWTlsFcXZs0fXu9mohVrtbl0iaS9REB6jezCLz3RlOlhawc98yKNyAY08yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=GpCbYrLk; arc=none smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="GpCbYrLk"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-5a470320194so452565eaf.3
        for <linux-cifs@vger.kernel.org>; Thu, 28 Mar 2024 06:03:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1711631039; x=1712235839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3XaX3hd7hmwSRaUGNwS3s92AS3tUn8V75RR5Xnstjxs=;
        b=GpCbYrLkOZz0PqvGumjdTSNlcachVwHWVgD+rWFYNZPKY1e0X3o4bL3imK+oDopbwP
         UgoQ7TqQ//Kt5fj0m2NqAOnnnB1qavj/eoqsrcsdY4Dx6HUYhsp3WiL8Qal+SzR/cXSZ
         r+Xi8Sl9ZHIBzGUrEAH9Fze1Z0LDT0JISegoQmJHSFMCMREAXA1NPRYHLYEfbBcoMnIl
         3izzn3pC5+kkw+bUds40yKL+iLAN9dtHoiPE86Pv2XbcBHCrHvG80MUikNDqxzVwsb34
         YTitKbnQK4SyWDhDoO+GVxwIBKYZ2U9RMGUCB1NdFRJ/xAb1t7CIndZdNK5CkRZEeMAN
         ZgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711631039; x=1712235839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3XaX3hd7hmwSRaUGNwS3s92AS3tUn8V75RR5Xnstjxs=;
        b=fD1KoHKlTfe8xfIzqtSd15fqjuGwcmRNM5Ndrqhqq71Dfm10YUDHTlDtYLqmBqZAjz
         u4v15d1Baz2o0i9d8KNH5kFTEv8lBIxSLADAIz9sUjLlkgzUKZuOVKWdJYHuzulQ21nX
         A/0GD+VinfdXKvPTDDLHX2Datsnd/7gswcW8gdyoEzOMZ9O8zFxtKmjhkQ9UgWo/i9Mt
         Eqkqigkb/JpRcMZA32dGgJw0LWnKGYSbQy5bzrtbIgsxdE+xNoLkXLwjXlTl2S4+7cEA
         WUIItDXrvbMVxUjKbFuBU9fuFA44Hm3L+mVRvoCaAmB0ubhk85jQ66Qzyk235AvpSD/5
         aG3Q==
X-Forwarded-Encrypted: i=1; AJvYcCXDUuqrAdtCA+q/d+ur8XHKDTGURgUEPzOpcrmdKHS8mMogKPCa6T6axG0EcgSShM4qqJJtPPddChHzhKLe7b6ACpEuLL9YxVQ31A==
X-Gm-Message-State: AOJu0YwMa56fVswvSpEpuv7Mzot9NMeuoR4eTfcikJ5rglXI6qflv+oy
	uhjjwgMQKtLteXJYb3wXlRsF2zMc9FLEBll9AIWOBRbXbcnU2ZXGo7FwaGwkFUiSNYjQbumxvcl
	0yu3JUdOvyOhqsTYaYxx75ccgZujJari7luj6
X-Google-Smtp-Source: AGHT+IGAwrK5RVxI1FWdhaGdJk53oz1JIu4utEj/2i2Z5bPasaIK4TuD1PGNGJfhSHVlWdkONFw134Hc6Aj0/tfXdLo=
X-Received: by 2002:a05:6359:3187:b0:183:6350:bfb7 with SMTP id
 ri7-20020a056359318700b001836350bfb7mr464536rwb.7.1711631038700; Thu, 28 Mar
 2024 06:03:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msAVzxCUHHG8VKrMPUKQHmBpE6K9_vjhgDa1uAvwx4ppw@mail.gmail.com>
 <20240324054636.GT538574@ZenIV> <3441a4a1140944f5b418b70f557bca72@huawei.com>
 <20240325-beugen-kraftvoll-1390fd52d59c@brauner> <cb267d1c7988460094dbe19d1e7bcece@huawei.com>
 <20240326-halbkreis-wegstecken-8d5886e54d28@brauner> <4a0b28ba-be57-4443-b91e-1a744a0feabf@huaweicloud.com>
 <20240328-raushalten-krass-cb040068bde9@brauner> <4ad908dc-ddc5-492e-8ed4-d304156b5810@huaweicloud.com>
 <20240328-verfrachten-geebnet-19181fb9ad65@brauner>
In-Reply-To: <20240328-verfrachten-geebnet-19181fb9ad65@brauner>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 28 Mar 2024 09:03:46 -0400
Message-ID: <CAHC9VhQ_w6uaOAKCj6mx7n7SNjk4d7vcUb3Bd6Wybx_1dA=ttQ@mail.gmail.com>
Subject: Re: kernel crash in mknod
To: Roberto Sassu <roberto.sassu@huaweicloud.com>, Christian Brauner <brauner@kernel.org>
Cc: Roberto Sassu <roberto.sassu@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Steve French <smfrench@gmail.com>, LKML <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Christian Brauner <christian@brauner.io>, 
	Mimi Zohar <zohar@linux.ibm.com>, 
	"linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 28, 2024 at 8:07=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
> On Thu, Mar 28, 2024 at 01:24:25PM +0200, Roberto Sassu wrote:
> > Also, consider that the pre hook security_path_mknod() has the dentry a=
s
> > parameter. For symmetry, we could keep it in the post hook.
>
> I think that's not that important.

It is important to me.  If you change security_path_post_mknod() to
take an inode, please also change security_path_mknod() to take an
inode ... actually, looking quickly at the code it looks like at least
AppArmor and TOMOYO make use of the dentry and not just the associated
inode.  I didn't dive deeply into either so perhaps they could be
modified to use an inode instead, but that is a decision I would leave
up to John and Tetsuo.  While Landlock does make use of the hook, it
doesn't look like it cares about anything in the dentry.

With that in mind, unless Christian has a strong argument as to why
security_path_post_mknod() must change its parameter from a dentry to
an inode, I would very much prefer to have both hooks continue to take
a dentry, unless we all decide they can be safely changed to use an
inode as a parameter.  As the previous IMA/EVM hook took a dentry for
years, and Christian originally reviewed/OK'd the LSM hook, I'm
guessing there is not any significant harm in continuing to pass a
dentry, but if that isn't the case please say so ...

Of course this doesn't change anything with respect to the necessary
bugfix and/or the hook name/bikeshedding effort; no objections from me
on either.

--=20
paul-moore.com
