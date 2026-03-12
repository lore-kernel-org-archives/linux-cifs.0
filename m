Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D228A1CF8B
	for <linux-cifs@vger.kernel.org>; Thu, 12 Mar 2026 00:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773273628; cv=pass; b=CjMyq9hQP9f2umb/C/ntTt9cRJPFBFVjWWXqmEuKSfn/Xr0nkDf+h4D7TALYJ854jRdCRuvRFfRM1LDPHnb+O2JhQ4rKVEBoRNlYSv2ZLx/XhOnVZx4GUX/7FjDav1wZRiGm4Dirn1tksRcK2o1B1cwhX4jFPX4gzMRmFZmAuWY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773273628; c=relaxed/simple;
	bh=uVE1hv9dL4gJeNXpQVGRn5K5+idgHGwYdhao/Cu+U/I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZI8uFFhXzUD3VTnrwjDnhMIxJGwYSVlDJyiJz195PdUthY8ItViUwwgcPN8mRGcF2Xw6SQedUQNbdiN1EzsQynV4/AsvWP0pYgE+nQ756wRBGgbwf/j0z+rEJ/NACD5mtXwKB/Rs6H3AIoXP0e0T6gGJuImgXQy5PkxRg+sjKco=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UQJTBfMB; arc=pass smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQJTBfMB"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cd767d2d70so41311385a.3
        for <linux-cifs@vger.kernel.org>; Wed, 11 Mar 2026 17:00:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773273626; cv=none;
        d=google.com; s=arc-20240605;
        b=SNHX9fMiTvbAsiEmnxzfjGs59H64BpdA1X3EkPRYtBoOUnkKSXcJjD4soulqgv10zP
         cFsU67MOdMlm7Sqw0XHWeDSE8AeV5ZhmP+fXV/7njg8cO3+Rgtb/J3nFjjerVBgRfVKk
         uKfncQlWNQ2wZ3+4jPVgSjfk4b2cbR78dSX2YMArxeX9KkNRWbr5q+tvI/We/i1bQCXV
         s+PmnFNy/KhDNMi8FfWweBkFkRRWYnKwTbLDNHyo4M2HyaDUxnB46S+DKMcLIAFhzzIU
         FyEYh1fgpg+4A3EhbgDj+vjUc8hVy1pL3DWUoVTpXxD+EACqq3AdBvqYPUfHWZG09AZb
         rATw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uVE1hv9dL4gJeNXpQVGRn5K5+idgHGwYdhao/Cu+U/I=;
        fh=CpWG9uCFVk1XRglQ4INlgsEIdecx9bnrMds1jBuWrmY=;
        b=d5aLH73grqKQvEUamWDx8dKraon9AuxJaYSQRmBiN18BsYxZX/z236RBDmTzO4lWZi
         vKMdJqQaMi5SF09s3I0Qw/7CvKYjmL5xnmutuAN11dimTbzpontUh+kVGzN7+RDDwBrX
         HDzueYptT2ukprGoYVElc7SwIxLnJUKFxmxHnElyLG33d5Y1mBG8KGzHHC/VWFHgB3Du
         29DzzoVmuxSxI4r9MfvfF+vVfH3MEUEQmAEteTKKYIN6r1bYAY0QWCXqJo0k+14xcxQr
         oLv9JfOr7zWR97wDrcpDFl5BkJEqxsDYB31wqLNZF03qTi7+456o7EW1R4iNfCQsHEWW
         JaPQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773273626; x=1773878426; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uVE1hv9dL4gJeNXpQVGRn5K5+idgHGwYdhao/Cu+U/I=;
        b=UQJTBfMBw4qRoYvCIwfcnThbIdh+5dOuC1sdqzPWCKTfRkpD3mBosQuX6s+h8HYmJO
         2a1co86SSLUVQ57kUv+7IsSWiSBs8J7Uu8BSCAEbwEpaxMaPzGAFI+Ihb8Z8qpkMoz3p
         GuWGHxGbHa1RSftEatDTX4PsxflOU5qwo3NZipyDppl1mrA4xg9UFehVLbmj8m5s+1rA
         9UmMuU2C/tt9p6dzfZYh2GvUMrzUWsfQ6DbuYRzrRmEgb0+q35vFEtIfkbOXuf1X5izK
         RAVIBWIl459CPqP7fBJuFbBwO801agvAa7gwOIaAgyZTRHojnHWz6tCQmIbfLPcfNPTo
         EZHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773273626; x=1773878426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uVE1hv9dL4gJeNXpQVGRn5K5+idgHGwYdhao/Cu+U/I=;
        b=ikokaUYlRX0blXocm2QqNkkBTSpqdUfz5KX9XInYs/UzTtGDWf/3fpBqdifVY+GzJ1
         jthWybWxFyjggl1aU+CMcUboo9Yjfkyjh5OOm0WUcWjkCn8mmCdW4bVTklkEm6NRxI/s
         tvSnK5it8lteb6Gq+QF/Gs/YcoFOZ97+b5EfaDRz2ROPqgwXCjttjpe+184txjfc80NU
         Hzjxuwi4lgtXKYMHHZKYQxe0qjmpFC1qckpg1iogcXifz18eiQvOw46i7TPlfXme4o7n
         Lo4bgbyX8xbt4IdhK1j2akIOjH6EgP7sQtIAkB5eGzWjkRFOEeyaEhZIxo7GLfuVawIz
         Yyog==
X-Forwarded-Encrypted: i=1; AJvYcCUxkUuF7V72n1mu/rRzokjXoyKhxXs1aKDUlCVcx7YKNUuS/m9vSOx6bqxuP/RiG1AWKpejZEAwgTeg@vger.kernel.org
X-Gm-Message-State: AOJu0YzuBoKQGdWSAV5mNwKfIspozwFjqnpRg2vWKpIB6qkx89QhWdD0
	ENcBuTPRmq2dCNr2nfASGBGcFuqz+9GpuPXSWGyAUm8+8N2VT+IpTymMsg/S4Q7N+Fh5hphx9et
	thJ8t1vbY4yYvHht3orhMh4/BA0aouwc=
X-Gm-Gg: ATEYQzz0NjMoOlffVVUUuMFppafzXL2Gh7/HJ2gXcBcNDRTSrtwNy/rGCdCqiwCGInu
	yV28YMcaFICjhzE1xoTyHoFlI+4xngKf8mAi6iTlRKdyVmga8hSO2H0EO/+BJQhf6VAOUx4dXiS
	2zCb9a+HGeVcdQlI/YuvVzRWkYaTYxRf5LIrdrm1AHKe9HTEjdR6tOm7ICjuVHZ9yBRNqA0+88C
	pjKGQ7Z95nBTnoYWo08IkwkbrYp/DkEarSh5T41RacCdRumuRRIfvznqKNVbxZXonGinu/wXCh/
	4yObhJ3CZEyGtqyj5h+YlX+67oUddduM9SvcGBKRZkwnquNELVKhgevMEl2rx4W+F0tcmSLs9Lf
	MyrMtahykyNwezZdLGvxi0XZdxPvMN6znQDnkIAmY7RkgU+y6hN3T3w==
X-Received: by 2002:a05:6214:27e3:b0:899:f1bc:c690 with SMTP id
 6a1803df08f44-89a66b0e8e0mr63283386d6.67.1773273623601; Wed, 11 Mar 2026
 17:00:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260304122910.1612435-1-sprasad@microsoft.com>
 <aea738fc-e422-4671-9e0a-429988fe026a@samba.org> <CANT5p=p3V0Ap3EmZuh1ZYvg+-SgjyH-ZMmsakCdbzMMSL3KwJw@mail.gmail.com>
 <e3gwcmglyhifzuugqzkez7v2gkqzcn73ial3xysfvpijf5d5gj@r5rqvx23qtgq> <CANT5p=qsOxpAAva6k9RQD3TGPku2TFQsS4bKbfZPNVs-RFWONQ@mail.gmail.com>
In-Reply-To: <CANT5p=qsOxpAAva6k9RQD3TGPku2TFQsS4bKbfZPNVs-RFWONQ@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 11 Mar 2026 19:00:11 -0500
X-Gm-Features: AaiRm53wFFroMfD6EWzSiBAF86EzyeMG1ZDxef1RLyB2bw5nY68VOvgIOuaZqFo
Message-ID: <CAH2r5mtdco_kugWiyLcP9dE7uEx0waW0mvCsj8=13_=Eay_BGQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: implementation id context as negotiate context
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, Ralph Boehme <slow@samba.org>, linux-cifs@vger.kernel.org, 
	pc@manguebit.com, bharathsm@microsoft.com, dhowells@redhat.com, 
	Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 11, 2026 at 6:52=E2=80=AFPM Shyam Prasad N <nspmangalore@gmail.=
com> wrote:
>
> On Mon, Mar 9, 2026 at 11:29=E2=80=AFPM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > On 03/09, Shyam Prasad N wrote:
> > >On Mon, Mar 9, 2026 at 9:49=E2=80=AFPM Ralph Boehme <slow@samba.org> w=
rote:
> > >>
> > >> Hi!
> > >>
> > >> I wonder which servers are expected to be implementing this? I suppo=
se
> > >> this protocol extension is not proposed without a server vendor
> > >> interested in actually implementing it, otherwise the whole metrics
> > >> story doesn't make sense.
> > >
> > >Hi Ralph,
> > >
> > >This is supposed to give the server an idea of what version of cifs.ko
> > >the client is actually running.
> >
> > I agree with others on this point -- cifs.ko version is useless to matc=
h
> > to a particular behaviour or pinpoint a specific bug.
>
> Acked. Can you suggest an alternative field that will make the matching e=
asier?

Kernel version is useful (major/minor #) but I don't see a problem
with using cifs.ko version as well as we do today since we had a few
cases where it could be updated for 'full backports' but in any case
either of these will help narrow client down a lot.

--=20
Thanks,

Steve
