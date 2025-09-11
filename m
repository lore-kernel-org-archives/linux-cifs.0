Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0737B31E0E2
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 11:40:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757590820; cv=none; b=OvLJcfPFMgIwfStaZunHwDMjpk3m9vR+i/3QM2XI/jGehnAHLyVh0iLKRyoqwMv/lboAntr3F2dajEnRHQirKjGZwXQfSqvb87yJTGoL8RVx94GG/J/TZE/zDvJchjDy47TAi+KLfNxSlkrkkUFZYqAztah4/4ZERubGnGW7zQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757590820; c=relaxed/simple;
	bh=RPJUjO++XgKXfUhj8DwMp+x4VnfPaTlVRXPnPYhrbHs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=io4Ay9U4DjXw7SMxlMQLcPucNsv1P7j2EU+fD1ZGfFMO8JCDpdkNmY7dIjyZ2snPG3oV8N0c5ZB9/VSAp2ao86GahcxzBaO/bw+s2F7qE0T+vEJ7yO5cqWvbCJJ0bMUg5dejDlL+N47knlKfIX5wL/nhVCa4K+vubOoJcRReRqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4dLltUg; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4dLltUg"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b00a9989633so131350966b.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 04:40:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757590817; x=1758195617; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J/buQccK88AayBkZLdHTD8rL7PNnaYcuDyk+/ec5h/8=;
        b=h4dLltUgNbTPTd6aLRp6wtbVgNfkyT3q2nM5jxhl3w0YBxGoCVW1rVcsDYQ/2CSjf/
         D2176+w3Lbk97EuCBZYDNmJigb01sw1+QJIOuhQE6u/7CManG29Qf2iyNjT546AcGxN+
         1HoiGrkMM7D9eLGvg8ztimrjmi0EkWUEs3Ek3jExuw2MBlbcODtGBz2Ion4AyYWZM3Gv
         /L+P17galx/3oy3b0ti1Um6PUqx4ecXwqo8KMoX+F9T4J2zyrFteCVsz0kcARHvO2yul
         pXfeC1HcfMmnu95d/FC821aOYBvv8G9r2fQ1fcWSzdKRrRxT3f+0/5nkaOQlClw79cKD
         Od4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757590817; x=1758195617;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J/buQccK88AayBkZLdHTD8rL7PNnaYcuDyk+/ec5h/8=;
        b=H+JXM0oEaS/lmoi5LrhQVFgIW8vr8Z5441xORokOlysEcybb/e0zhdlTpGnfouEv80
         uOxQDci7Fn3FGEZY4Lb6CSrp1wHPPJfu/YBcTrap7qlByZD1Pi4gkFz7ym98709R4viR
         Q7UY0Ny9iZIKM47Yq2diw5tR02Rj/IP74YyCMVxg2TVEpB7G4ZszFTFtA+uQG2t8nmxO
         NsOpwj0fY2AsJ119Srlogx1ckjaM5XBHfiC6Jrwo3/TuhDuCOG9h1cIZbfdVhZdAWcVH
         18zuSf4/BNZLPQ+WkXAhU8wykLT7jjkW5uM7eYdhVu17aN0GEWE8OONY5w3WpK/S3Pub
         tCow==
X-Forwarded-Encrypted: i=1; AJvYcCVHqqO1XBOL0lTqkwIOHlclsnFlxE6+2Y9oyWDCVK2pA5jRpvkrAipT2qQIqhmRXb59gzaLMICFi7Z8@vger.kernel.org
X-Gm-Message-State: AOJu0YwCfxTPG1hSPMlqFQ7ze/zPJcHL7mEa9sFa97m5b2ajtG3d0ARd
	ZOg8DFFn2hy3hRTb2cGdQo48HvvdhYa3MamqvzEN4mJjj7ileo1LjSqJoex4h5WLc/iAWM1VZG+
	5jVXMzhV+sCMOcpL4w+HC9XbQ6lwlzys=
X-Gm-Gg: ASbGncsTdJVEVSwWohFqrVAFW7hUG3Y+RqT016nuVb5uGLokr0AWN7zxOkUPZQ0u6lz
	ngGkEVykicpZdripG5xcEsWPgoFzZCaJWF13CikPg2n2deGIfgUUcIMdQ1Yx8bzny+SaniVUI0R
	jJwPqng2xlDUzYY1VF1pobYVWXGcAUznNJTfWDS5JxY0Dsef50xzVrL0gWAH+CqockHM2gDSH0r
	esLzw==
X-Google-Smtp-Source: AGHT+IEAc+suiNpxsaxTVE3JcGvm1yFRs9zplv7RA6o4nBsX4YPEhrbynV7aXjNM8Ha/ZQ2Tm/hltcx7EhAS+r7vEDg=
X-Received: by 2002:a17:907:3da0:b0:b04:46df:5cb6 with SMTP id
 a640c23a62f3a-b07a62910c5mr336372566b.1.1757590817068; Thu, 11 Sep 2025
 04:40:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com> <2025091109-happiness-cussed-d869@gregkh>
 <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com> <2025091157-imply-dugout-3b39@gregkh>
 <95935128-69fa-2641-c2a7-9d9660e2f9ba@huawei.com>
In-Reply-To: <95935128-69fa-2641-c2a7-9d9660e2f9ba@huawei.com>
From: Shyam Prasad N <nspmangalore@gmail.com>
Date: Thu, 11 Sep 2025 17:10:05 +0530
X-Gm-Features: Ac12FXz3BiUAfn24EQJMYs0OoXCzIGFjpCrrcdfX5wINxcOzJGdakBPduJhBPyk
Message-ID: <CANT5p=rE+=g7KA0RKOxs2UCnMEKfr3cm2V_+mwdb1g7+yV8NtA@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
To: yangerkun <yangerkun@huawei.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, sfrench@samba.org, pc@manguebit.com, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, stable@kernel.org, ematsumiya@suse.de, 
	yangerkun@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 11, 2025 at 4:55=E2=80=AFPM yangerkun <yangerkun@huawei.com> wr=
ote:
>
>
>
> =E5=9C=A8 2025/9/11 19:17, Greg KH =E5=86=99=E9=81=93:
> > On Thu, Sep 11, 2025 at 07:09:30PM +0800, yangerkun wrote:
> >>
> >>
> >> =E5=9C=A8 2025/9/11 18:53, Greg KH =E5=86=99=E9=81=93:
> >>> On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
> >>>> Hello,
> >>>>
> >>>> In stable version 6.6, IO operations for CIFS cause system memory le=
aks
> >>>> shortly after starting; our test case triggers this issue, and other=
 users
> >>>> have reported it as well [1].
> >>>>
> >>>> This problem does not occur in the mainline kernel after commit 3ee1=
a1fc3981
> >>>> ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting th=
is fix
> >>>> to stable versions 6.6 through 6.9 is challenging. Therefore, I have=
 decided
> >>>> to address the issue with a separate patch.
> >>>>
> >>>> Hi Greg,
> >>>>
> >>>> I have reviewed [2] to understand the process for submitting patches=
 to
> >>>> stable branches. However, this patch may not fit their criteria sinc=
e it is
> >>>> not a backport from mainline. Is there anything else I should do to =
make
> >>>> this patch appear more formal?
> >>>
> >>> Yes, please include the info as to why this is not a backport from
> >>> upstream, and why it can only go into this one specific tree and get =
the
> >>> developers involved to agree with this.
> >>
> >> Alright, the reason I favor this single patch is that the mainline sol=
ution
> >> involves a major refactor [1] to change the I/O path to netfslib.
> >> Backporting it would cause many conflicts, and such a large patch set =
would
> >> introduce numerous KABI changes. Therefore, this single patch is provi=
ded
> >> here instead...
> >
> > There is no stable kernel api, sorry, that is not a valid reason.  And
> > we've taken large patch sets in the past.
> >
> > But if you can get the maintainers of the code to agree that this is th=
e
> > best solution, we'll be glad to take it.
>
> OK, Steve, can you help give a feedback for this patch?
>
> Thanks,
> Yang Erkun.
>
> >
> > thanks,
> >
> > greg k-h
> >

Hi Greg,

Steve can give you the final confirmation, but I can add some context here.

This bug was never fixed upstream since the write/read code path was
entirely refactored (with most of the folio maintenance
responsibilities offloaded to netfs).
We've recently had at least a couple of customers complaining about
this in Microsoft, following which we've been able to repro the
growing memory usage with a certain type of application workload.
We've also been able to verify that the issue does not reproduce when
cifs.ko was built with this patch against the 6.6 kernel of Azure
Linux (and that kernel is mostly equivalent to stable 6.6). If you
need a confirmation that this patch fixes the issue even on stable
6.6, we can do that check.

Additionally @Enzo Matsumiya also mentioned that SLES had to backport
this change to their v6.4 kernel to fix this folio leak.

--=20
Regards,
Shyam
