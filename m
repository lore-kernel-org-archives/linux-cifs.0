Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F61A1946AA
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 23:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754608882; cv=none; b=Yw7GPtq+qb0CG0/3izheYjKJBtK9UJ15QO6I2cUguLB23wxwUOi0zgccslEDSAH1ON/oUggYF/HNba4YYEh+bI2zJUUWceiyNywH/GCuwtrvgb7wST97YVMsmaIHNfmIVbwHeOT0MfxbmlwczEWYRZ96+JBV0TcMIJjYq9lU5L8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754608882; c=relaxed/simple;
	bh=CbY4WZ+7o9lSfwvHTfItfVyp4xvraMt9Ugx5QarC7xU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M4jcEzI3ZW8aBoFewU15uCnpbf/Hh7iOXj3TqsOjCS/a8pGOD0Wr3QYk47HT3BdAYg6Y4BRoPA3SWxyvMhaNp2AFb72D2jQb+t1q+nzyP/oQ0r2GkNLrHd0B4a+q+IdsIUFeAvTqGKjB6mcjM6JaeYEBLHtsK0sDoAtLsqphDZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WbdbtJQx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WbdbtJQx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364E4C4CEF4
	for <linux-cifs@vger.kernel.org>; Thu,  7 Aug 2025 23:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754608882;
	bh=CbY4WZ+7o9lSfwvHTfItfVyp4xvraMt9Ugx5QarC7xU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WbdbtJQxPYro7btYQqtsdLT03q4AdFutNlquP3le/wUfrX2/UyC78Eywua04EcaLB
	 bM2PMbPIbqjyUqH7s8DfRpeqEgTLx6yP07VJr1GZOYUarS/yStZixTJdOMb0WHlY9l
	 DCJzrTRaR3q/5kXMJy5wTBeqN24zrfM7ojjTBAbpeLHeLpkKLrzFmhjgnfU961MLwO
	 l+uX9HrGvKtCy2rPcCkSYbDdK+qsnP95ybj749N8mc9iUSC75rAqfYKEdOWUTW2HVX
	 j0XoFThi1nnHzEn0k86ThCS2yQD9oFoDup0Oz2bR+xwgQeVq1Sc5KRVhpTzW0bC6by
	 VhFi1wTIv+85A==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-af9618282a5so304051166b.2
        for <linux-cifs@vger.kernel.org>; Thu, 07 Aug 2025 16:21:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVugfocIBKZz9yi0/q31q6iL7WV/wHNj8ieA41nFgCPLlTq986Dui1P2pNWmc0w3UK5xHn591PW4JYD@vger.kernel.org
X-Gm-Message-State: AOJu0Yw10ddTS2SjnoEIx3FOsL9A+5jgUj+u83f/c7hmBVYGwSmbILEs
	lFevVc2sX0cRg927M7e2d9rY2oEQgjbXB10l1l9IvOKR0RK4wXWRcBx3VdBY0dcmMbIOfFG1O2/
	I/nX0EOyd7tN07caGEqspP0J4gC8tNx8=
X-Google-Smtp-Source: AGHT+IG+9rdH+c8Ws1CrtllYip+mf38sZjiJ4K2/UsYa3tzgrKexpidjUlURX2/WEaS/Grpex/1kOVrIEs1aC3d3EWM=
X-Received: by 2002:a17:907:7f9e:b0:af9:5e9a:b6a with SMTP id
 a640c23a62f3a-af9c65b04eamr55544466b.42.1754608880767; Thu, 07 Aug 2025
 16:21:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754501401.git.metze@samba.org> <ea27f558-ab35-4607-b8a3-480c9ca4c6c3@samba.org>
 <CAH2r5mvA7CWGR0cDn0DrxvMXdcmcJru1nOKPr1FD=rANPyYTHA@mail.gmail.com>
In-Reply-To: <CAH2r5mvA7CWGR0cDn0DrxvMXdcmcJru1nOKPr1FD=rANPyYTHA@mail.gmail.com>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Fri, 8 Aug 2025 08:21:09 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_j475c5Njw2BQpLaKwJrgmM7QuE1tswCKJiRaRNBQUqg@mail.gmail.com>
X-Gm-Features: Ac12FXwVmJk-GeEA671vNc7xAqRnwQWlRTFBWpFyP3qI45IZ8p4txOtHogzXmfk
Message-ID: <CAKYAXd_j475c5Njw2BQpLaKwJrgmM7QuE1tswCKJiRaRNBQUqg@mail.gmail.com>
Subject: Re: [PATCH 00/18] smb: smbdirect: more use of common structures e.g. smbdirect_send_io
To: Steve French <smfrench@gmail.com>
Cc: Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 7, 2025 at 5:21=E2=80=AFAM Steve French <smfrench@gmail.com> wr=
ote:
>
> tentatively merged those 7 additional small patches into cifs-2.6.git
> for-next pending more review and testing.
Could you apply ksmbd smbdirect patches from Metze to for-next branch also =
?
Thanks.
>
> On Wed, Aug 6, 2025 at 12:41=E2=80=AFPM Stefan Metzmacher <metze@samba.or=
g> wrote:
> >
> > Am 06.08.25 um 19:35 schrieb Stefan Metzmacher via samba-technical:
> > > Hi,
> > >
> > > this is the next step towards a common smbdirect layer
> > > between cifs.ko and ksmbd.ko, with the aim to provide
> > > a socket layer for userspace usage at the end of the road.
> > >
> > > This patchset focuses on the usage of a common
> > > smbdirect_send_io and related structures in smbdirect_socket.send_io.
> > >
> > > Note only patches 01-08 are intended to be merged soon,
> >
> > Sorry it's just 01-07.
> >
> > metze
>
>
>
> --
> Thanks,
>
> Steve
