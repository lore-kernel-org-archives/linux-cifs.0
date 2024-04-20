Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50539205E36
	for <linux-cifs@vger.kernel.org>; Sat, 20 Apr 2024 20:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713646569; cv=none; b=YsgJHcPqPer+7O5onhJnpitFtXiSf51KR5RK2K63Z9s3mqjFdY08LUIhn50aJ+1LlkDFItzQLQZZeNXltQ+okC6YPhdDstI8RrtVLOJ9Xez5VFFBCHFg1Pb8iomk/AGksrmZtei+VI0tWbKMSpCQgtGTuKBB7+EUwoFs7jzcnjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713646569; c=relaxed/simple;
	bh=X9Lg9Dalj9GmOgzcBocU+Ai0hvYxiYQugp0+vV05CLo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=F6YcL9bT9ybvBqErJwK/ihjdZ18BgHCA5JlPtN+m2eMOQ1Qlh94Idqgqwesg13INikI/ncyQC91BKuyypzPsng97JtudB9+HkW7JbkoMoa6gq3l6w/tbnJE4gYKzu4+Sr+i6TCgdOuq/CImbu9CIPc/H0Y2QXqfDE6R0IZpQWUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cudMkR6c; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cudMkR6c"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2d88a869ce6so43876831fa.3
        for <linux-cifs@vger.kernel.org>; Sat, 20 Apr 2024 13:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713646565; x=1714251365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeIZwcZ+zB9DFscVyolg1aegOFP1W/I+KQjLIkh6gas=;
        b=cudMkR6c87p+2TwnXvUPNt1UytpZNtsnQmudUvQ5L+PPOW8eBsF7x7u3Or3LzNmG3K
         aCYgwVjh2jUlwfUGEvYTm2bItZCDUNN2rgPMzyy0VPV8Hkl36A8TgX2cEVbNQAynqnIB
         tYcyQGbOy8i4uPpE7N1jOiVqQi9aUdkoX3htCduOF9pAZlFHt6pDTBp3URDwzj2eUQBv
         wf/K0lVDsPejxXC+10NUBOmAbRj2Rj5V92cOAPYBU+OSwgEzGlMchEFyf7UHmTYZ0tC3
         R0NHroxKxBF6vJKzHw1MpSbTm29shOE0iPfVdmtupC4cWbPNAnt94x851gErpW1gAURG
         zOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713646565; x=1714251365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OeIZwcZ+zB9DFscVyolg1aegOFP1W/I+KQjLIkh6gas=;
        b=ckygo0n6oS5iijtEaKp3kp8M/5xvxP/+c2A/CbgREJfhTGlonkAnQrfCutvVxpU7wx
         R7av+oAVdIMGN3zMeMcaTE6ICt6PE2DTGR03T2OzPRRb8AMd4juIC4TBu4OR8GEpAZXv
         eog9IeZfhEBrN5fQ/n2ivE+YFlTiGvjJ0H5MHg3+n8HZJxij6KGJh7QCId8orukCoPKE
         PgiJCPiUjoDvfCpH70fqZU9m5qE/PjjEu78G60OsuamHgX2Z0BYhOBlykndnLOJ8xO/5
         4/0aYXIUUiF6DSjT53vtIuEtnvX6bmZODaz8p7/bhASx0FJ0KiDWevFy/RcoDJyBeNUr
         XX4g==
X-Forwarded-Encrypted: i=1; AJvYcCUjuNxWYCzpdA9opMzLsqWrGvJIjYNbe3kn2Qs7WxS2HiJRCj9zddAGwPYgaDKd7W3BSho1qzva+85dt+3lzxzROWxk284ya1Vs4g==
X-Gm-Message-State: AOJu0YyG3C3G7nbew1asyLvnAtVaYzufapKK0/ZbFo5fgdlIIM+GiSds
	fcf9REVm9Oisi9yPvKbUDb8wAubA6f39lzdYQBMD+Li1PPDuBm42x/6Z0sttMyzM4vu2cqR+ua9
	ZfDviLJbzu+uG3r6cee6jC/is0Q==
X-Google-Smtp-Source: AGHT+IFcRQ9tcdR9GgwlQ2hMVnWXaX7F/Kb8URPfkJsO03Zz4HFmB6bI0CYwGlmgmxJyoUyazYWij7LTwGDFITbwuLs=
X-Received: by 2002:ac2:55b9:0:b0:51a:dc60:df07 with SMTP id
 y25-20020ac255b9000000b0051adc60df07mr2146282lfg.36.1713646565125; Sat, 20
 Apr 2024 13:56:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240403052448.4290-1-david.voit@gmail.com> <20240403052448.4290-2-david.voit@gmail.com>
 <80e09054c9490c359e8534e07f924897@manguebit.com> <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
In-Reply-To: <CAPmGGo7XogXA8RppeqOtidWsgL84u+J4SUB7-st=A9a2ooPriQ@mail.gmail.com>
From: Pavel Shilovsky <piastryyy@gmail.com>
Date: Sat, 20 Apr 2024 13:55:53 -0700
Message-ID: <CAKywueRW3PoAJcfwPWANh-oJeop6VP6BXsSMVR1Xq2LcTmXKDg@mail.gmail.com>
Subject: Re: [PATCH v4 1/1] Implement CLDAP Ping to find the closest site
To: David Voit <david.voit@gmail.com>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org, 
	Jacob Shivers <jshivers@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

David,
Thanks for the patch!
Merged it to https://github.com/piastry/cifs-utils/commit/770e891a8b7ad53d4=
d700e08cf8d3154028b4588.
I removed a blank line and a style change around addr->ai_protocol !=3D
IPPROTO_TCP check in resolve_host.c. Let me know if it is ok with you.

Jacob, Paulo,
Thanks for the testing! Let me know if you want me to add
"Reviewed-and-Tested-by: " tags to the commit.

--
Best regards,
Pavel Shilovsky

=D0=B2=D1=82, 16 =D0=B0=D0=BF=D1=80. 2024=E2=80=AF=D0=B3. =D0=B2 06:09, Dav=
id Voit <david.voit@gmail.com>:
>
> Thanks for all the reviews! Please let me know If you need any changes. I=
 didn't got any other off-list feedback and in my point of view this is now=
 in a ready for merge state.
>
> Paulo Alcantara <pc@manguebit.com> schrieb am Mi., 10. Apr. 2024, 21:08:
>>
>> David Voit <david.voit@gmail.com> writes:
>>
>> > For domain based DFS we always need to contact the domain controllers.
>> > On setups, which are using bigger AD installations you could get rando=
m dc on the other side of the world,
>> > if you don't have site support. This can lead to network timeouts and =
other problems.
>> >
>> > CLDAP-Ping uses ASN.1 + UDP (CLDAP) and custom-DCE encoding including =
DName compressions without
>> > field separation. Finally after finding the sitename we now need to do=
 a DNS SRV lookups to find
>> > the correct IPs to our closest site and fill up the remaining IPs from=
 the global list.
>> >
>> > Signed-off-by: David Voit <david.voit@gmail.com>
>> > ---
>> >  Makefile.am    |  15 ++-
>> >  cldap_ping.c   | 346 ++++++++++++++++++++++++++++++++++++++++++++++++=
+
>> >  cldap_ping.h   |  14 ++
>> >  mount.cifs.c   |   5 +-
>> >  resolve_host.c | 258 +++++++++++++++++++++++++++++++-----
>> >  resolve_host.h |   6 +-
>> >  6 files changed, 606 insertions(+), 38 deletions(-)
>> >  create mode 100644 cldap_ping.c
>> >  create mode 100644 cldap_ping.h
>>
>> Great work!  I've tested it and found no issues.
>>
>> Most of the cifs-utils code seems to follow the Linux kernel coding
>> style, but I don't see it being mentioned anywhere, so the patch looks
>> good.
>>
>> Thanks!
