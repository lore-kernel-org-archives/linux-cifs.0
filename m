Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB5D254652
	for <linux-cifs@vger.kernel.org>; Fri, 30 May 2025 09:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598458; cv=none; b=PtEEnC6M1hL/ExZNTxTDOw5F4S2befi2Dmd4qjOS4KncI3RvCQoPQXTlxRJr9HW2q//5beyHpvEH31oePSgMsfmopxqOR9n3u5k57NRq0pjdlEQpqExbAprwa7HuO+UXhQxNLIuR6mlYzax7bkoL6Wp74W7OUSHkQNYbtlgDBsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598458; c=relaxed/simple;
	bh=Yi+nj61jzEXGuCyT76NCaTTzBkQxWTCsM7nPWJU9e7Q=;
	h=Message-Id:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Qwz+NOT4xaFUnp7MpDntLnees3iBJBhcUdfI1YavuQZrkc5yP8SkDPDnFcMtrObOSviCV3Y+aFaRGj1YIHaX5V2O0l7geqlLym9YBMnbHVRnnFFNoOTGAQ4y34bXsCHNfftkW1yG0H45l7tuDVI0Qfo+McR+IHDEckjTPoAnm3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=qqR1YKgg; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="qqR1YKgg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1748598442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=O1KtjHRJC3uJtzBJhVZNHoy6obntKuc4YyDaHlsW0uw=;
	b=qqR1YKggXa89jdOW9uzbFsLKYY1flg3Q+K74rwP1GGumNUzJwU+qApiThymaY7qI0SzTH4
	asf1sKABstzEFJISdUsGnr7Y2tT+xRKAxodBgauAVVg9agxv4yYBwDDMtYT1UGRTDSTOc4
	P2O2FibPZ31gC8yq3WqMb3z8PNMmp8ZT6QUf8TxkqVHYnysHj7ZZnE8yY10/rGXB6JCAAe
	NJ6I4HokkCpxw6y4iDxOSYt+dGGgz09hoGgCGjycQVX1wPO8flbkb5zL21cJix2/QeXBCV
	U1OM166IDNGLfttoKq867u6nHroAjYKkUgiW61YkTKoo2YUjzo/NmLBnKvST5A==
Message-Id: <4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de>
Subject: Re: ksmbd and special characters in file names
From: Philipp Kerling <pkerling@casix.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, Ralph
 =?ISO-8859-1?Q?B=F6hme?=
	 <slow@samba.org>
Date: Fri, 30 May 2025 11:47:21 +0200
In-Reply-To: <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
References: 
	<d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
	 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
	 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
	 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
	 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
	 <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
	 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi!

2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon <linkinjeon@kernel.o=
rg>
> wrote:
> >=20
> > > It's been part of the spec since the beginning. You can find it
> > > here:
> > Right, I found it.
> > Thanks for your reply.
> > >=20
> > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > >=20
> > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> Philipp,
>=20
> Can you confirm if your issue is fixed with the attached patch ?
>=20
> Thanks!
I can confirm the following behavior after applying the patch:
 * Path with "&" is not accessible with mount.smb3 and default options
 * Path with "&" is not accessible with mount.smb3 and "nomapposix"
   option
 * Path with "&" is not accessible with mount.smb3 and "unix" option
 * Path with "&" is accessible with mount.smb3 and "unix,nomapposix"
   options
Perhaps "nomapposix" should be the default for the client when "unix"
is enabled? Tough call though, might break some backwards
compatibility.

Furthermore, in the last case in which the file is accessible, I can
only access the file as root. This is because enabling the "unix" mount
option leads to the origin UIDs and GIDs being taken over from the
host, which do not correspond to anything on my client. I usually set
"forceuid,forcegid,uid=3D...,gid=3D...,file_mode=3D0640,dir_mode=3D0750" on=
 the
mount but, for whatever reason (might be intentional? might not be?),
these options do nothing at all when combined with "unix". I can sort
of get around this by setting "noperm", but it does seem odd that I
would have to disable any and all permission checking just to get
special characters in my paths working.

Thanks,
Philipp
