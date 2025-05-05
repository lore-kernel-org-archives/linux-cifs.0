Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com [209.85.219.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A1341FBC8D
	for <linux-cifs@vger.kernel.org>; Mon,  5 May 2025 10:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746441694; cv=none; b=SHAuI9qqCZcGtgYcABrX/XQo+XFZFYZclZxjKRLea0mNIu8dEo3uI4/wG0umMa1IxjtNkmzkaY4kStx84XQPci7AIgTpZMDd8e7a17BMuyV1WJcYFMnM/ivDCOkpATll5VjaMnSEkIbDR1IoWwx8cs8PWp/P1gJFAXV496PLC8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746441694; c=relaxed/simple;
	bh=8FoBes3dKHIoLshq+YgvTFHDDMXE9lB4QgJ3xsKtY74=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ljAtgKVAN/vxyQGXSSR2iMyuexJg7Olii8L5upIOi6DyVvX/Ccb74OwBoYqhxHVSw86lYtvFJlouf+aW7uAJQ3SzaFLIIRZyNRN1sCt3LnWVzEinKgaOvktxk48bSC4L3zWd3lNKy6/6NcXGp2VkVkyGy8Vb3CUeD0hafnsTHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GvJjzIq2; arc=none smtp.client-ip=209.85.219.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GvJjzIq2"
Received: by mail-yb1-f172.google.com with SMTP id 3f1490d57ef6-e7297c3ce7aso3217202276.0
        for <linux-cifs@vger.kernel.org>; Mon, 05 May 2025 03:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746441691; x=1747046491; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B45eiU8dq7sea9jml7m/GV/jIGHI5T8rrRhnB4khC5M=;
        b=GvJjzIq2Ma61bLNEpoKSXCLT410kBWpk6fkn2zxr1EYOwRsEHN/9A298GDxWzmlwuI
         rqqTn0KlIC/lH0WHTrmn8EEChS1ybTAY6/+Vc9c+vi4winyYq2ptQBIyBIOKr0jdKqL6
         QYKoBZdvKZFpxy4loH/yzu7p1FOtJdWsgTc05SPrYwp/F0tZV0o/oz5K0vD9F88rYDky
         abylJsA4weQYlD19GFUBib4fnTpSyqKwYLdZzN3VYo0oKTRvvpO3QMmRrwsBeG26mji+
         q0FwwleIupwuRTCvD/ypUXS5p0lcxujSXl9GcuDYG4CvwfyjfPFSyR3DTHQWYhHWXaZS
         8qfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746441691; x=1747046491;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B45eiU8dq7sea9jml7m/GV/jIGHI5T8rrRhnB4khC5M=;
        b=MiYMIUHfRn9hWsmLGnpJrW98nD+ugHGw7PYdzlG0z+Jl124BtvT7z2ojWh27LSaMx9
         o6kEEfB94nWjSC9qrFMdaP3J5tPDyB0uNIMnebYOzepYcnSi6CCSjV3uBsFuJuvz4qfD
         c8dyUOrnf4mpadcLwCwIdcSTJoJw7vQgfaP1t23kG7rr+Ul1KCiXQ5lbLGm7F7pmADGk
         18hT3aX4YZxJVI0PJD+7/3DUkxBHa8h+NnshgeElyGsW80o9KC9F6wRM+2E+s8vILCCk
         jzpezfKM8bIB5rjtIepxmbNEIpKW2aKeNbNXEuenhgNnTQslC9Eaz6PpFu1O2/CQ2LOI
         7htw==
X-Forwarded-Encrypted: i=1; AJvYcCXbHwzXIUCwksO7v14WJFwDdSJ0a6df/0uGnYpStbEoMcgDyr1d5EGaItryx1HFt1pQhgW3c98OOdca@vger.kernel.org
X-Gm-Message-State: AOJu0YySC5W38LVos6FwHc3cwj5/L65q2adHmeBfmpGVt3KWwuSunbzD
	wY3QGLaidB+jiHl0Sfq/y3kfCdNwqDiLJMBFHPVzprBkU9fTZA0jkIWqGYaDwQ3F4rC53ddU0lk
	9WrAB8AoM9q8RuQztjbHE4J0Ji9E=
X-Gm-Gg: ASbGncuyg7KTnRRCDRqeigaQsPzhr9JZPW1i5OShBa3j9dXBti8v5M823S5CHP8/N4V
	ZYao85tmDsaydDCjv+T3IsOqNFAVa8iQLCfNQUbujuM9uhKxIj1wr1ijmB/ATkbOdVgnntN2Sqp
	SCEFcpLz+krduGyCCYMaUEdl07XOjajbXeHCKF8hPzqxuP1UXrtFSi
X-Google-Smtp-Source: AGHT+IEA7pGT3WOdovW6Pwxff9HBRZMK7nHXwB1KFT4c4V7UOrlg5o96z4JObJRf9XElFdmhBjvQXoQ8AxyKbSATzSs=
X-Received: by 2002:a05:6902:1407:b0:e72:97bc:a199 with SMTP id
 3f1490d57ef6-e757d0b87ebmr6771062276.4.1746441691157; Mon, 05 May 2025
 03:41:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428140500.1462107-1-pc@manguebit.com> <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
In-Reply-To: <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Mon, 5 May 2025 16:11:20 +0530
X-Gm-Features: ATxdqUFgW4JXEma_w3PR7yJEdLhree_2N2m_oE_HKuwmi5icNaum2bzj02BbtF0
Message-ID: <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
To: Paulo Alcantara <pc@manguebit.com>
Cc: Steve French <smfrench@gmail.com>, linux-cifs@vger.kernel.org, 
	David Howells <dhowells@redhat.com>, Pierguido Lambri <plambri@redhat.com>, 
	Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 1, 2025 at 12:44=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Steve French <smfrench@gmail.com> writes:
>
> > Did you mean
> >
> > downgraded "RWH to RW"  or downgraded from "RWH to RH"
>
> Downgraded from RWH to RW.
>
> > But it is puzzling why file would still be open if not in openfile list
>
> The server is breaking the H lease.  cifs_close_deferred_file() will put
> all cifsFileInfo references from deferred closes in the inode, meaning
> that _cifsFileInfo_put() call in cifs_oplock_break() will effectively
> put the last reference and then closing the open handle.



> The check for a non-empty list after that makes no sense as we already
> closed all open handles.  As I understand it, the implicit ACK would
> work if we have no open handles at the time we receive the lease break,
> but that couldn't work as we always get an active reference of the open
> handle before processing the lease break.
>
> What am I missing?
>

If the file has only deferred handles and a handle lease break occurs,
closing all the handles triggers an implicit acknowledgment. After the
last handle is closed, the server may release the structures
associated with the file handle. If the acknowledgment is sent after
closing all the handles, the server may ignore it or it may return an
invalid file error, as it could have already freed the handle/lease
key and related structures. Additionally, this would result in an
extra command being sent to the server. This check was added to avoid
this case to send lease break ack only when openfilelist is not empty.


> We don't know what caused it from the network traces we have.  I was
> able to reproduce the downgrade from RWH to RW against Windows Server
> 2022 by mounting a share twice with 'nosharesock' and then having one
> client writing to a file and the other client remaning the file's parent
> directory.

> For more information, see MS-SMB2 3.3.1.4.

I didn't understand why a client would break 'H' lease on a file if
"one client writing to a file and other client remained the file's
parent directory."
Can you please help sharing more details and exact repro steps.?
