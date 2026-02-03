Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478C7325738
	for <linux-cifs@vger.kernel.org>; Tue,  3 Feb 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770140277; cv=pass; b=f8vpP8GR2UtVyJw/rqCuu2pfzR1o+fz/IaTe6fIhQvl/1UgWFR01pxTPNO3vBDQIAtQlF/j0Ub3CJPgqWAnd5cgWQ8yUfWOsZtgOrNb2UxL+5lfkFqHYafYKV5uTNja+YT/Pg7vHNeLlZRtsv3mpKg450PXKbt9FQbYDgKp5KRs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770140277; c=relaxed/simple;
	bh=KOEfPnZTeETnF2DAaZeqI+37eY6oAZZsxEicbRAXUAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UKaAiW2h555DJoXxuPvcNE7fa0eIMouRsaSB3QkHSXTIhB3DiHYiCkIQd7u+c8hoPaAFejWnaMoB2bF6juXl50QeNloFgDiaouOF0HtRMbtWMRgLkN6DpFcIW2hAZA+TFlPUdixRDIJu2IExNLYaYS+2dcsiJxr1ZNOmmoPLrVo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewS0He+J; arc=pass smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewS0He+J"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8951c720496so6598886d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Feb 2026 09:37:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770140275; cv=none;
        d=google.com; s=arc-20240605;
        b=EaBHs+DZl/w7TqOByllx/rWb4mCTRdeqTE0/ewuvzNotmAk2ZTfB+f//0g9nP/T8bx
         xYZbtZPv6ep9rXql1JXuHhTKpcwX76Qf8RgB2rBhgJJyvNUq8DSs97tlmTqCg8PxxL6d
         zoytFssr55kFQudafuHDQ+pVmu/dRPME7l923OthWZxBlBem3r0te47l+81wgBcB01+b
         hXgRekSDmYoahCrlpPHmyvVfXdupMG8FN1b/uQ9m1RiNb5SdeToAAWJkfTy8JWstZAen
         D+P3B8HfVOr4KhwRnQMD58sASS8Wb/mS7PXy4VBzOCdxpRxUuj3s6raZxATbxrxJLI0p
         KRKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sCet8w2fzClT+BjAferTRcrOmf4nu4ygw7S0ICHDOaM=;
        fh=yYT5rha9hHq/h2cvYfn4f3r8dFL13aK+SlC60lYbd4E=;
        b=DYqNEUb3vkst1KyZOrLDuzK6EiNbw0liQBQnNIkBLGMqZ0n/HRF9kbMtiYI7Ze6Tvf
         k3b1jm5lBtuIRYdFjSSAmKk7rPh8dUO5aQeItiqp/wIMD9ZndbI4jZ1N//tUu7Vta2Kc
         Jbzo6qttSEvUt6mvratTQWZFNQZsAqYfbDrOD90Zi9wYOyjz84YbTNCh58GI4pAybxwn
         zVlsEZw0aFdKNh2yeZ13d8Q3IvB8kMBBmN1zG7v7k0FdbzGifnhXTG1d0WC8cVLQGkXq
         G3x0tmlCYAWb2HJvyDDcNHSZC3rBJ7t8EdT1u0fkNEeflKf1K4jKj0eBPht2IbooC4IX
         1X/w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770140275; x=1770745075; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCet8w2fzClT+BjAferTRcrOmf4nu4ygw7S0ICHDOaM=;
        b=ewS0He+JE/HGZkP1DkihKJJAPsyxXq4wq1wbt18YFbRA4a9Gwqru7bhY4IQKH14LfW
         01U/JQnnxgIVVQVOh57L//HTHE5mdvCa4hznAsKuvkGF8cobE0TWY1PL4+ctUHGAMDI/
         dRsfUF+uNZo5w/6pfNDA7LSqCd8yClpyZSOZAZOieF3wrERd7qmHqwaczrDFg+ASuMKJ
         ywRi6PymRjVRjMYUrDGGu8cCerN0g1Pa/iMjcDUyqlrB3vRX7ZAft9r3xEmscwKsRRzr
         qn8fsRf1W0r4A9BjGqDyfD28p2I25mHrxCFuQZo9pkVtZHq0WPS+u2O+eqM98bBsuhEt
         J6Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770140275; x=1770745075;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sCet8w2fzClT+BjAferTRcrOmf4nu4ygw7S0ICHDOaM=;
        b=JBefPnev1m9izqVIEaFVdAzc5kM/D5R9VoSrqigtc/ftp89ZojjPPlQQt8JWk1hPC6
         XHoAxsaGvyOQeQzElNDn8LoTfNi9YBbI5M/knpVl2r9ca3c5skTlLsLzwkvEltM40e3R
         4KH5gus96bAKMvTE1r+wRBTx+wDe43p96DAhhVUPPpCr5tq1Pm2B8ZQYJ/lRcQYsusEI
         48lsNaQfs0wBPMxMs03nrOKbRkDAzlDVK/o6a5n0FbxLKdiLBPIlxIDvnM/KqUHMtLcq
         e8sLYZRGj4LKM+IwwS/QsLv9siGVpJiu92YIyZFCbzaKwk+YoVD0ZkLnFfQFUNjZxsl3
         yfQw==
X-Forwarded-Encrypted: i=1; AJvYcCWjWVlD71m2O3xPj2bHQx3o40vly9msaqiVUZOAsqRYlGRm0QwZ6O50Z/M5X2BeZataBsCl8ISkcOch@vger.kernel.org
X-Gm-Message-State: AOJu0YwOe/U3bKzz74zBm9PvGfQbEhCSQcicYcXuGqBggiUdH3OsyuBq
	kD7oMzOORgrcgrgDM7zr6Qb4cuO8FXa7E5IzwsvYPxKHA/s2NAOlL/WixYyaeszUgtMU7IOQmf+
	5Eo1SyVs6NSAxJqI1av1lrAuMQ8UASzo=
X-Gm-Gg: AZuq6aJG8Hr7q91mcnO7m6LxDvCQbCNIo2vYyR6+hey0wMbc2C4L1uPrT60USuu4+hF
	kxasl+t8M0+uKNixvRByGN+G2x7lOvrTnRVmZr8/0wdaAmMzZZl8uBCEqzAbNiQuASNRWYVhVNw
	3f5zBWF27//plznGehhRkP41oSU3vbcBVMBBehfs5BHodlfF9wprSbf6wj13x3nFKTicnbcwZaW
	cYitcVCgATzsMcR0qRhzjmGr3fiI4vrHG5AFft+30Rb0csVBx+vE5op8h9t6MP17vhW/ydNFAI9
	EufBzkg91OZ8eAHDyl0VdzoqR67oY3u8mEBXBlLJBRfdvbUakNN2fEYqYYTjjGz5hCTl6HwPcOJ
	AQygsF1O4QGPCkNoW9NUAY6exPj0DTPvg6yB/S5rcA0uDCx71cmuZeNJgxVt5BZIN4LCz3/ZszC
	VKRJXVNyNpUA==
X-Received: by 2002:a05:6214:e8e:b0:892:6681:a92b with SMTP id
 6a1803df08f44-89522233f1fmr2607526d6.49.1770140274833; Tue, 03 Feb 2026
 09:37:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769025321.git.metze@samba.org> <20260128141123.GG40916@unreal>
 <1f77a9a6-9020-4d65-a6b9-fe68d4f6e46f@samba.org>
In-Reply-To: <1f77a9a6-9020-4d65-a6b9-fe68d4f6e46f@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Tue, 3 Feb 2026 11:37:42 -0600
X-Gm-Features: AZwV_Qg7No4iBiPwVQ2zXu54m187QppFn0sUrUinniPRJCmJMkuABKEBAHh9GZ4
Message-ID: <CAH2r5msoO_hY-U71_AHt5ns2Wf1y4Kry6g1gqFgzzXKNSA0i5g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] RDMA/smbdirect: introduce and use rdma_restrict_node_type()
To: Stefan Metzmacher <metze@samba.org>
Cc: Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Jason Gunthorpe <jgg@ziepe.ca>, Tom Talpey <tom@talpey.com>, 
	Long Li <longli@microsoft.com>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 3, 2026 at 9:25=E2=80=AFAM Stefan Metzmacher <metze@samba.org> =
wrote:
>
> Am 28.01.26 um 15:11 schrieb Leon Romanovsky:
> > On Wed, Jan 21, 2026 at 09:07:10PM +0100, Stefan Metzmacher wrote:
> >> Hi,
> >>
> >> for smbdirect it required to use different ports depending
> >> on the RDMA protocol. E.g. for iWarp 5445 is needed
> >> (as tcp port 445 already used by the raw tcp transport for SMB),
> >> while InfiniBand, RoCEv1 and RoCEv2 use port 445, as they
> >> use an independent port range (even for RoCEv2, which uses udp
> >> port 4791 itself).
> >>
> >> Currently ksmbd is not able to function correctly at
> >> all if the system has iWarp (RDMA_NODE_RNIC) interface(s)
> >> and any InfiniBand, RoCEv1 and/or RoCEv2 interface(s)
> >> at the same time.
> >>
> >> And cifs.ko uses 5445 with a fallback to 445, which
> >> means depending on the available interfaces, it tries
> >> 5445 in the RoCE range or may tries iWarp with 445
> >> as a fallback. This leads to strange error messages
> >> and strange network captures.
> >>
> >> To avoid these problems they will be able to
> >> use rdma_restrict_node_type(RDMA_NODE_RNIC) before
> >> trying port 5445 and rdma_restrict_node_type(RDMA_NODE_IB_CA)
> >> before trying port 445. It means we'll get early
> >> -ENODEV early from rdma_resolve_addr() without any
> >> network traffic and timeouts.
> >>
> >> This is marked as RFC as I want to get feedback
> >> if the rdma_restrict_node_type() function is acceptable
> >> for the RDMA layer. And because the current form of
> >> the smb patches are not tested, I only tested the
> >> rdma part with my branch the prepares IPPROTO_SMBDIRECT
> >> sockets.
> >>
> >> I'm not sure if this would be acceptable for 6.19
> >> in order to avoid the smb layer problems, if the
> >> RDMA layer change is only acceptable for 7.0 that's
> >> also fine.
> >>
> >> This is based on the following fix applied:
> >> smb: server: reset smb_direct_port =3D SMB_DIRECT_PORT_INFINIBAND on i=
nit
> >> https://lore.kernel.org/linux-cifs/20251208154919.934760-1-metze@samba=
.org/
> >> It's not yet in Linus' tree, so if this gets ready
> >> before it's merged we can squash it.
> >>
> >> Stefan Metzmacher (3):
> >>    RDMA/core: introduce rdma_restrict_node_type()
> >>    smb: client: make use of rdma_restrict_node_type()
> >>    smb: server: make use of rdma_restrict_node_type()
> >
> > The approach looks reasonable.
>
> Thanks!
>
> > Do you want me to take it through RDMA
> > tree?
>
> As I also have other smb patches on top changing/using
> it I guess it would be easier if Steve would take them.
>
> Steve, Leon what do you think?

I am ok with taking it via the ksmbd tree (smb3-kernel ksmbd-for-next
branch), unless it is practical to merge the RDMA changes through the
RDMA tree in the first few days of the merge window and merge the
ksmbd-for-next branch a few days later (which sounds potentially
trickier)


--=20
Thanks,

Steve
