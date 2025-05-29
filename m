Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA8C241C89
	for <linux-cifs@vger.kernel.org>; Thu, 29 May 2025 02:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748484457; cv=none; b=sQSxXddc5D9Sk43Oi6QjQG8srDMOtjKhxT0rITBEfjqfBa+IFI0aIMGZ2Jnqmd4mJGr8bld00TdYoTq87zFaqa1iOGMHQIBwl22Phy6ISKjHQyFvSyEbh1Xg/TLe+wjTr4n+TwtiwIvbKo6NDLX3hBuUT5bV48AWJc3yvEd/UYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748484457; c=relaxed/simple;
	bh=tF5qUdOznC0Y4Br9l2V1Nq52mIfIpf0r1dYL2dbNOgg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N1jjzKfvgZwRHRM69Qt7immVA8HEDUFoygpRhsStNvsNDQae5hqu3B9XAhn/bHx3F3lXJHRyDAKokC8Qb6kN1jDn35ZRGvmRDU6m7zkSPHT77n4GmqhK5EKcubKF/H5XpkJcbjjoX1WuIvAw1OChnylgIYQK4oMKcEyz1a8mtTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OOLAqx5B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OOLAqx5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C54C4CEEF
	for <linux-cifs@vger.kernel.org>; Thu, 29 May 2025 02:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748484457;
	bh=tF5qUdOznC0Y4Br9l2V1Nq52mIfIpf0r1dYL2dbNOgg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=OOLAqx5BSffZPdrtDsfDxbfkpF9u1IYBwOynsIx6a6rBgmThd06ajMk3Zg8IfMZS1
	 evIYxgXd6iRrIX1gk+sIsZiPcnD1qdxsCSnOm6xpdoyfy6DyBlm0rOPD39jHAqKYxH
	 n+PPMNUjx/EP0lBIGTB0LmEiQ6qomU/AQFY6xQ+DTVJaRnme9xbnkZ7lNiRryfUGry
	 yThcmWinqt+Nsg8f5KgATY6RwUM4BMGJQfwL4Au/uBothD3RjBJmT6D/Qx4AM1OOZW
	 ItoNGm8LhttFCrmYq4EluHiE64NsW5j3odY80DvB31ZWcKzEfPX+KE6mjKLqzcMl7K
	 1AR2BQ9w7Y35A==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-60179d8e65fso798737a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 19:07:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXaQEym2YgYrqzUkBJp8Zz32WWrYfy5hOFdiuOMx5MR92jKFA4Q3Oy5r9ga748lirWAleVfP4gNYye+@vger.kernel.org
X-Gm-Message-State: AOJu0YzPrKtdmN4lJDPQL3BsQpDi5gh54WuVBSzakRZtHMfVK/ixwZ+W
	UflNxndpZKTKBO2ksXddGwS4MSOUTa5Hn2B/k/g9XD+GzI5nVzZPRBMqS5q/J8YcEX/ZPP15Cv1
	nn5yp1/g1zY8YuZI+n9WD0YcWsCCjsFc=
X-Google-Smtp-Source: AGHT+IEGx77rb+EPkrbPDmpe2PLtdTqipxd3bABxUfPezqCsmK+jWSc2EE0TsouaPIsPjeH/X1r646OwL2PqsIKsPqU=
X-Received: by 2002:a17:907:6ea2:b0:ad2:2e5c:89c5 with SMTP id
 a640c23a62f3a-adadee12102mr46924766b.20.1748484455552; Wed, 28 May 2025
 19:07:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <04ad8564-4a55-4308-86ad-dd6dc47fcaab@samba.org> <8691d09d-268a-4623-9f53-9f47b1d5bb73@samba.org>
In-Reply-To: <8691d09d-268a-4623-9f53-9f47b1d5bb73@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 May 2025 11:07:24 +0900
X-Gmail-Original-Message-ID: <CAKYAXd8sPWMmewB-AHMW1Ju9iAU3vtnTfEWMd+ZBjHTdv8OUZQ@mail.gmail.com>
X-Gm-Features: AX0GCFvbzp1kR8yE5r3qqu1JfKvqu4u6pT7nJHSb5Njglhqs1_sDPMp5hndhGrY
Message-ID: <CAKYAXd8sPWMmewB-AHMW1Ju9iAU3vtnTfEWMd+ZBjHTdv8OUZQ@mail.gmail.com>
Subject: Re: ksmbd uses ib_destroy_qp() instead of rdma_destroy_qp()
To: Stefan Metzmacher <metze@samba.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Tom Talpey <tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 1:21=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Using Namjae Jeon <linkinjeon@kernel.org> now...
>
> Am 28.05.25 um 18:19 schrieb Stefan Metzmacher:
> > Hi Namjae,
Hi Stefan,
> >
> > I just found that you used ib_destroy_qp instead of rdma_destroy_qp in =
ksmbd,
> > while rdma_create_qp() was used to create it.
> >
> > Is there any specific reason for that?
There doesn't seem to be any special reason.
> >
> > The only thing that is different is that rdma_create_qp() takes a mutex
> > around calling ib_destroy_qp(), which might be a reason for a potential=
 problem.
> >
> > Assuming there's no real reason I guess we should use rdma_destroy_qp
> > in order to get trace_cm_qp_destroy().
> >
> > Any comments?
We can change it if there is no problem after testing it.
Thanks!
> >
> > metze
>
>
