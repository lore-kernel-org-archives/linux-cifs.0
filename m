Received: from rx2.rx-server.de (rx2.rx-server.de [176.96.139.238])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E48179BD
	for <linux-cifs@vger.kernel.org>; Sun,  8 Jun 2025 07:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=176.96.139.238
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749367643; cv=none; b=DT9IkBrQsiySV+L9jSfnwUeQlhTM3CxwdfkEki6MAu1vVRzyOpaHosH7SgYn4WatB0OgCcqQ9sHRW8LrU+CAX5YqvxPmc4yVxkMRGwrzY/Yo/WhaV5C82zogtG0OEglUG0yvVIDCq8FjpcUYOkofl34+Hb/7VwDqNF/28ZEq6Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749367643; c=relaxed/simple;
	bh=6V0DUrzm9d+K0WpCvj9AdmKSoOQO+Wk/Vi/8DvOxY1E=;
	h=Message-Id:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=TkUn257BoFVkGc3Q+swMaqskqNWvNp/ghzRwt4OHGRHsPMSVd1CQonqKwmtWq0E1/OzwebyWIptOhtQRoI6EUm8NGDCYXbZR6i4i3kS5ygDmuQNVj6URb4Mt/Q/a+Ae6kOP40ue6vpu0Uz5ZhOntwTwyGmNXQP3IABcy/SDTJc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org; spf=pass smtp.mailfrom=casix.org; dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b=ioy+CIWX; arc=none smtp.client-ip=176.96.139.238
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=casix.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=casix.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=casix.org header.i=@casix.org header.b="ioy+CIWX"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=casix.org; s=rx2;
	t=1749367212;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xEipkHLZKPlGk1PXe4qG4Rb+7eczR/qvtGRq/xYyBwk=;
	b=ioy+CIWXkib9gZ7tlGpulJTXry6O2yqL11ZJrbK3hen+gqTvcXkVRKGIW7h6iF455epiTT
	aAMA+7VjD+CIhUfeFeIoXvnZD3uGiaMeMonEL6FZYwYnvIJoz+pZd8iArEyIdoLB1uNqrq
	2yIiz3VYuBIUCwDeyGRMtVlNkCRZ62sR3MPp0K1EHP0b9JOwHUsgAitc5jafjWN+R22lHV
	8WpsLbTdMPBOPt5Watj8ogRVtoKt1KdbH/QSekH7QqeGAsHqiJXoMC3nUd7WxS5pX30i/G
	g2NbTC9JiIN6fRUjZg2VXehSZEldrg9jYOpF+A/RFECeh2OtLshys9ld4ctKxg==
Message-Id: <5891ee55f912ceab918019f59e6cd35f809132d9.camel@rx2.rx-server.de>
Subject: Re: ksmbd and special characters in file names
From: Philipp Kerling <pkerling@casix.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, Ralph
 =?ISO-8859-1?Q?B=F6hme?=
	 <slow@samba.org>
Date: Sun, 08 Jun 2025 09:20:09 +0200
In-Reply-To: <CAKYAXd9OQW9oOfjUDWSGmh+b7QtHSc7M=rHhCW6QEsFpEkVFVw@rx2.rx-server.de>
References: 
	<d0df2b2556fac975c764c0c7c914c6e3c42f16a1.camel@rx2.rx-server.de>
	 <CAKYAXd-t27uzNLdXjPRuvbaaBnA-Z8qVqd_1W7v=97vp2Sd+rw@mail.gmail.com>
	 <CAH2r5ms-v=UwFzXZpZ-5KBgiRPkvSqQyJnLBhxP5YaAuqMAG5A@mail.gmail.com>
	 <CAKYAXd8rN+RVJB8ak_SPNX07L8BeastngMhQsXVGdUW0D0QLSw@mail.gmail.com>
	 <4fb764ff-f229-4827-9f45-0f54ed3b9771@samba.org>
	 <CAKYAXd8FJcfFpGBkevgZaymcHiicJgs-time4r7fbD6n2hBg7w@mail.gmail.com>
	 <CAKYAXd9BPqg=0QKrpsOHaVDQkM8=Q6fragLmpTPve=pJdNjovw@rx2.rx-server.de>
	 <4195bb677b33d680e77549890a4f4dd3b474ceaf.camel@rx2.rx-server.de>
	 <CAKYAXd9OQW9oOfjUDWSGmh+b7QtHSc7M=rHhCW6QEsFpEkVFVw@rx2.rx-server.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

2025-06-01 (=E6=97=A5) =E3=81=AE 23:30 +0900 =E3=81=AB Namjae Jeon =E3=81=
=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> On Fri, May 30, 2025 at 6:47=E2=80=AFPM Philipp Kerling <pkerling@casix.o=
rg>
> wrote:
> >=20
> > Hi!
> >=20
> > 2025-05-27 (=E7=81=AB) =E3=81=AE 11:57 +0900 =E3=81=AB Namjae Jeon =E3=
=81=95=E3=82=93=E3=81=AF=E6=9B=B8=E3=81=8D=E3=81=BE=E3=81=97=E3=81=9F:
> > > On Mon, May 26, 2025 at 11:24=E2=80=AFPM Namjae Jeon
> > > <linkinjeon@kernel.org>
> > > wrote:
> > > >=20
> > > > > It's been part of the spec since the beginning. You can find
> > > > > it
> > > > > here:
> > > > Right, I found it.
> > > > Thanks for your reply.
> > > > >=20
> > > > > https://gitlab.com/samba-team/smb3-posix-spec/-/releases
> > > > >=20
> > > > > POSIX-SMB2 2.2.13.2.16 SMB2_CREATE_POSIX_CONTEXT
> > > Philipp,
> > >=20
> > > Can you confirm if your issue is fixed with the attached patch ?
> > >=20
> > > Thanks!
> > I can confirm the following behavior after applying the patch:
> > =C2=A0* Path with "&" is not accessible with mount.smb3 and default
> > options
> > =C2=A0* Path with "&" is not accessible with mount.smb3 and "nomapposix=
"
> > =C2=A0=C2=A0 option
> > =C2=A0* Path with "&" is not accessible with mount.smb3 and "unix"
> > option
> > =C2=A0* Path with "&" is accessible with mount.smb3 and
> > "unix,nomapposix"
> > =C2=A0=C2=A0 options
> > Perhaps "nomapposix" should be the default for the client when
> > "unix"
> > is enabled? Tough call though, might break some backwards
> > compatibility.
> I agree that "nomapposix" should be enabled along with "unix" option.
> You can try to submit a patch for this.
OK, I will try.

> > Furthermore, in the last case in which the file is accessible, I
> > can
> > only access the file as root. This is because enabling the "unix"
> > mount
> > option leads to the origin UIDs and GIDs being taken over from the
> > host, which do not correspond to anything on my client. I usually
> > set
> > "forceuid,forcegid,uid=3D...,gid=3D...,file_mode=3D0640,dir_mode=3D0750=
" on
> > the
> > mount but, for whatever reason (might be intentional? might not
> > be?),
> > these options do nothing at all when combined with "unix". I can
> > sort
> > of get around this by setting "noperm", but it does seem odd that I
> > would have to disable any and all permission checking just to get
> > special characters in my paths working.
> Please tell me the steps to reproduce it.

   1. Create a folder on the server and put a file owned by UID 1000,
      GID 1000 with mode 0640 into it.
   2. Export this folder using ksmbd. For the record, I am using "force
      user =3D <user with uid 1000>", but I don't think the options on
      the server matter much.
   3. On the client, mount using "mount -t smb3 -o
      vers=3D3.1.1,forceuid,forcegid,uid=3D1001,gid=3D1001" and list the
      folder -> file will be owned by 1001:1001
   4. Unmount and mount with ",unix" option added -> file will be owned
      by 1000:1000; most likely forceuid/forcegid is not applied with
      3.1.1 POSIX extensions (tested on Linux 6.14.6)
