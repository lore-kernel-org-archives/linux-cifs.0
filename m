Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C916F30A
	for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 20:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718052806; cv=none; b=ukCVGoBMFZ2C4b+WPTB+O4eI1EgGdPRSAQ5a03zuGnebniM8pHcqeBaiOtqHxVlqN73rS11m0oTIOKz24DQcRMO122J1IpC88s6xq6PrIQP49qqiBKSbmKoWRM1POJM0wLGbVtfJQoGBDn9eoWNtDrpqYVW6N2yJcKxLw3FPumY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718052806; c=relaxed/simple;
	bh=MxTK7lKE5gYFyjUWqpy/ittJ9GvBj4piaWBTG2RFbU8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ndM1geO8rG4RaytpP6L/zluNByM0QwCsonmgBDsbVqxNavowVkFESl7Qrp+MmJz4rfOXsSAznkapgMnT3ylsOAS1eAxh0E3cvBJoQ0aol4DawETtZmNbnyYoGJjG2EVKD3+/gf1Z78wSj1PZv+uMB8I1yHm+jnmR4hVLwxs3QOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C/cGVEoB; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C/cGVEoB"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52bc035a7ccso436653e87.2
        for <linux-cifs@vger.kernel.org>; Mon, 10 Jun 2024 13:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718052803; x=1718657603; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGkZNBMe+tUz7Boa++OVQu93eM/tUXmlbnG7GS0256k=;
        b=C/cGVEoB+wNy0D60CSxtq0NTlBRVq0zKTIYJ2i0QxFicyV0TkCB9eCUHchJHLfaxLU
         1nzARtrpMoh1P4ock3FgckbUPnGrFX0PxWy0V9bGi7ifhYJbiX5f2fA6hD2JYrTD4lrk
         tIsVgDFkStFbiCjlnFc+gJeArXmBFRjCvsQzQ19g8MRg2aAmdfXkTiVJNCqKxkXw/RrR
         mEbvqFbNvlQvW40DYnsq3lpLOQz3gZ6YQpAt/wrv0CXjKVRm4YFx1kx5IDiHmoETDE2k
         v8YGW6ghRLjmEw0l/yx6sgTsD0oSfywrv0+7dh0WitRZx4snPXacl1mnEgjawP0o9uYr
         NraA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718052803; x=1718657603;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RGkZNBMe+tUz7Boa++OVQu93eM/tUXmlbnG7GS0256k=;
        b=NzZyBBYkHQHQPT1gXP1fi4pmYS6Z66F6BxCERMh01frMgj/UgA4VEPn7Z1BYJEILtt
         kW2K1lPq7hv6JOH4OMELyr2gqGMeurtor3NTgmhzPyVX1OGdMU6lGvi1ewyGxzUYLGde
         zx1v7U79g2B66shuDCEYyJTUx/7ph152gCp0n4ZUDxkyDRFqXEMZqqomyPE9QkHErnYB
         f931jRMsollFL6Kp1rnHK9o55pJVxFE1+TnKJ8dsbarf2wY1NZZTKBUa7xy7N48hr6W4
         +x25hjgRI2QfbmaZWNglbWImRlQe5Ngc8Wfb9oYhyEg+jrnufNkXyJ7pXYB5l1yPypgg
         yMmQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR/zvCo8TMMKfuUBEQeRglx7KnOKMSTdfnWTP4bc8MwQKjyBmzGN9Y0fqALl8aiDhw13+00ld5OVs47m1FZhyerya1Ho4eta6r2A==
X-Gm-Message-State: AOJu0Yy7MSOMJUA9FmlBhDpN7s+nodqGd09i3obXWvQgB2n/pn1/eSCI
	7AgtoF4FHggg0F+xMkmSbXC2H+pYhVq2i2U71BmRmkKgSX9fu66RwnCT2UPdN0M5Ldfk50f3DDk
	3EitcQpWl6KxubdLHardujWTDdPw=
X-Google-Smtp-Source: AGHT+IF7D8/6x/ISnTId0dUyW4x2NQA83TsWbu7MzL/74d9rq02JBSLg+EabBpz3rp3A3dV6qYTVYQy5Vf27MZ7UVIM=
X-Received: by 2002:ac2:44cc:0:b0:52c:89b6:6b82 with SMTP id
 2adb3069b0e04-52c89b66c37mr2424359e87.27.1718052802802; Mon, 10 Jun 2024
 13:53:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5659539.ZASKD2KPVS@wintermute> <CAH2r5mtzzgG9-peAakYhBNdpahQ=R8wkhJxUQJ+oZtzEvuNjSg@mail.gmail.com>
 <5fad6c05eab959e06fe3518d9104376b79dcbcb9.camel@samba.org>
 <CAH2r5mu_5V1OXwiOa2csH9n_J+ZPDYNhiuYBDoONYBqewNaNkQ@mail.gmail.com> <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
In-Reply-To: <c6da3de7c205d40a41907874a0e6d26b6c8132fe.camel@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Mon, 10 Jun 2024 15:53:11 -0500
Message-ID: <CAH2r5mt-mGSzzMHuGvbvsN+N294RUHzVfLADgg1=CZ52p=ntpw@mail.gmail.com>
Subject: Re: Different behavior of POSIX file locks depending on cache mode
To: Andrew Bartlett <abartlet@samba.org>
Cc: Kevin Ottens <kevin.ottens@enioka.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 3:48=E2=80=AFPM Andrew Bartlett <abartlet@samba.org=
> wrote:
>
> On Mon, 2024-06-10 at 15:05 -0500, Steve French wrote:
>
> Yes - the reproducer helps.  The bug is easy to reproduce.
>
>
> I wanted to verify that the succeeding cases are the same that I see:
>
> - works with "cache=3Dnone"
>
> and
>
> - works with "nobrl"
>
> and
>
> - works with "vers=3D1.0"
>
>
> All other combinations fail ...
>
>
> Should be straightforward to fix in cifs.ko.  Will look at a fix for
>
> this later today.
>
>
> Awesome, thanks.
>
>
> Note that the problem with SMB3.1.1 POSIX extensions is a Samba bug -
>
> a serious regression in the server (but trivial fix).  We are waiting
>
> on someone to merge the oneline fix to the server (which we tested out
>
> ok) from David.
>
>
> Is there an MR for this?  I couldn't find it.

I was puzzled why there wasn't a fix immediately applied since it was
tested (and could add my Reviewed-by if that helped), and obvious
server bug (regression), but I think David (who wrote the fix) was
busy with other tasks.  I would have done one but I am out of date
with the Samba merge process.

There are two other fairly simple problems (with basic SMB3.1.1
behavior), e.g. ctime not being updated in a few obvious cases (which
is not really a POSIX only issue, as it also affects default mounts
from Windows to Samba)  which we hit in SMB3.1.1 POSIX - that I would
love to see fixes for so we could restart our regular test automation
to Samba from Linux (cifs.ko SMB3.1.1 POSIX mounts)



--=20
Thanks,

Steve
