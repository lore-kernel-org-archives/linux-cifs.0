Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4206E78F20
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 17:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737825176; cv=none; b=lNTv3eID0ejlLVZNGIB9iaRyi7KnoJEI2h0pDD7X2UaBDzwJTBn4ao66qPqkapxM3RSZDC0Jlnwgnv00qoXyMHsMYD7smQscTfbpvKuQ8A3VS/rJ3W5dJ9K3ojJFd6E3a0x5OHRXB/Y2udiV5fWJlXwZbOTprm5HyLG/pMrPKAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737825176; c=relaxed/simple;
	bh=yQExf0ChefzHhkRS/mZt6ywMTvN7NgB/AReNGyZtza8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RZwFYADaaG3rEomLFxPis7OOz1M0BBfZLappd59Vyx6+r1G6siIw+pIxJpjFC71edIpwjDcpiAVgkSewS33h4mOX+KtMUPirUqY8YXlHhXTYMtUnS+osKXoBzVWLxyeWq7QpNTdVFyyyVnVRa8dRR3A4tHjoCkpwdvfboFSUvo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NS9SU/v2; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NS9SU/v2"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5d88c355e0dso6074065a12.0
        for <linux-cifs@vger.kernel.org>; Sat, 25 Jan 2025 09:12:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737825173; x=1738429973; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O7G0VkHCE838qSr1AV1qY6o/ap/yB5azhDwFu54Sdhw=;
        b=NS9SU/v2bAi08yh4fke9QOUG3pkuIdpW1hnUEnpBPOGQrkn8KfT5Wz7d9wWG19vpCH
         /M2WUSYAwnHUEWi4Lg+lOiRnVp3AYXNA8g1LNMQOZYM4TespHpEMjsQJm5J8rc0daUAZ
         kzP+zJPEGNjgtDYQdckgIH0Z9VxCF92TygNVkcOcUW27foN1LZ1ObiZ/auzGoN0mEYxB
         uKi+hBwl4QspmCkdEzGtzGe7Ay6tJnSgeCcbCjNGXyd4OyGAhGldFhb1U3IOQswhuZR1
         MafmFBde3vZWB4ebhtXm3qvCzhz8HYRAwHp/a1FKG5bHDsd9d5Q8zMHMYyuPPGaC/2HV
         uMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737825173; x=1738429973;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O7G0VkHCE838qSr1AV1qY6o/ap/yB5azhDwFu54Sdhw=;
        b=Q3rmTMRWrV9vRVnAapFBvSdlcYsyKgBthycY4Rog+VYjszUTLUEbkAHmSq4edfZmg9
         AVyEsQweYF3BTOHBSRiQncFhMOr5gEUTj9kDxCM4teHO0rw750ZYASNSERuSrUgXC3bc
         Y3lbBzZ3ndxWWoo4fYfIMglIuOy9w/OgNc0HJB8S782aWn/Zwdco80PK4Y28ZeLASvWs
         tGSwXKWdDFW+MklnC4dIjIxEL0goYI98eFwH0KmkkwzjqJcA8fUVvWPsHEIRkf0zuTN9
         XWuMxQZ+vRXv53jUk/mE9EUa5c/WzoZLKh+VZ9UhpQO04Xbu7nDI7MTsf9SpbAXy/FoN
         mAJg==
X-Forwarded-Encrypted: i=1; AJvYcCVt9uj/Mu2AareiUNxbcyC/48OQk9E0F/jOW0UuvoBWRNeEhn/869FGPOd3Teuh54Of7cgptp/jzLm8@vger.kernel.org
X-Gm-Message-State: AOJu0Yzn9NXf6CPy+BSIwmTNnWSFBFLq94Xf5MYQx6eNy8iFatk8riFq
	f+oVyoUtKt4M8FYEvwqIWZaBYfBwCJt2ca0+1D3yjkjLeyKRtd3EOpH+1L9xxnBpGhJm6w2Hq9n
	MEwaZd3co4UGe/4ZbwbG5crarn+caSQEC
X-Gm-Gg: ASbGncujmv9J86uCBnDkNtmSvAGnYmN5vJjx39G3GFHc88Q8sgvz3AUdKV5VYC6BF1c
	ZU47XWvEsBeEoV3jJ4++WZv/JbB91SJSMp54Gc4D5nKab7emVHcwCeqTBx8vm/FwxB7zoeLqIXN
	hhpL30vhlw0QYPKpz/
X-Google-Smtp-Source: AGHT+IEWORknrMyARRDOrJ/8R56vWsYoMAnQIWd39BX1f25ZCpcMH9OfdXQAJOqYMWM3PEZeqSdDwKOBpowyUlLS/kM=
X-Received: by 2002:a05:6402:5108:b0:5db:69ee:9179 with SMTP id
 4fb4d7f45d1cf-5db7db08402mr29610051a12.31.1737825173171; Sat, 25 Jan 2025
 09:12:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CANT5p=pUGYwswgXM-pniMjEWwbLK0cKXPBOJB9cG_cOrkBwQhg@mail.gmail.com>
 <CANT5p=qBwjBm-D8soFVVtswGEfmMtQXVW83=TNfUtvyHeFQZBA@mail.gmail.com>
 <505338.1733181074@warthog.procyon.org.uk> <526707.1733224486@warthog.procyon.org.uk>
 <CANT5p=pO28C+XEC44taAT-Z6W_spB-QzJb+MOXv68bDRGqJn=w@mail.gmail.com>
 <CANT5p=qc97-Ncs4E6_KfcYVxBYU5cw5LnPJoccb3gePa8OuCKg@mail.gmail.com>
 <CAN05THTXWKGDynqPLzSfT2j0vvQ9At0YKBHYWMm0KM4mCgyOxA@mail.gmail.com>
 <CANT5p=rFSLgCyZ8D1CUcSBzmyW+voAbxbOwRHH+=vPgxhLaRfw@mail.gmail.com>
 <CANT5p=rw_mewxPrp0xxQcBRY8Z7Zwg6RQMCXyc7vwWvDur5dHQ@mail.gmail.com>
 <CANT5p=peKRDJi6XHKpuDKx82sJdJKVwa-gW_KGUOcyh_rt0tWQ@mail.gmail.com> <2194785.1737650099@warthog.procyon.org.uk>
In-Reply-To: <2194785.1737650099@warthog.procyon.org.uk>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Sat, 25 Jan 2025 22:42:41 +0530
X-Gm-Features: AWEUYZm2mlJ-WB0vhl9cVOpYczZn4NKZjjUK8sM8tLqwsCnU8C9-C5A79_71mMQ
Message-ID: <CANT5p=pgD_jM6y1VRUHZRRfSkQWm3juW3oLOVpqFMzW1hMOgOQ@mail.gmail.com>
Subject: Re: null-ptr deref found in netfs code
To: David Howells <dhowells@redhat.com>
Cc: ronnie sahlberg <ronniesahlberg@gmail.com>, Steve French <smfrench@gmail.com>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 10:05=E2=80=AFPM David Howells <dhowells@redhat.com=
> wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> wrote:
>
> > I tried this again with 6.13-rc1 and the null-ptr deref seems to be
> > slightly different (same function).
>
> Note that v6.13-rc1 doesn't include my patch.  You need to be on v6.13-rc=
7 for
> that.  There are a number of other patches that went in too that might af=
fect
> what you're seeing.
>
> David
>

Hi David,

Tried this on v6.13. Same effect.
To reproduce (fairly consistently), I need to mount with an extra
mount option of rasize=3D8388608.

>> We're requesting reads of four folios, each consisting of 512 pages for =
a
>> total of 8MiB.
Based on your earlier analysis in this email thread, and based on my
reading of the code it sounds like there should be a max of 4 folios
in the folioq.

>> netfs: R=3D00005a08[a] s=3D2600000-29fffff ctl=3D200000/400000/400000 sl=
=3D5
But based on the OOPS that I attached in my last email, slot number is
5, which explains why folio at that slot is NULL.

I don't understand the donation logic well enough to understand why
slot could have overflowed like this. Maybe you can?

--=20
Regards,
Shyam
