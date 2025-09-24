Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D30D30C62A
	for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758726972; cv=none; b=tCKxlxmJA2+QKxoEgWKiRAzgUyGI+BahLN7PMKYyOcCuPbqAQ74dipHcNchLJGy7nlAdHccBVVRcisuqkeYhf380v+itovXvn9/P+oHZvzzBSPQB8Nl0o37Yr9ipxkvnt8GHAJjhI/noQURYmJuBc8k+qOzpEgPDERj6DD5Si18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758726972; c=relaxed/simple;
	bh=JMqcFCV0eFNi69vVUwQqYUuqU4/n7ubP8MQ2Mb6BQ3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rVwdKO4Av11cKhLhAg5E6QdRE8/RYlaG7q5RDhc4xZGGbCAevGvUVGEBiaMrUw5tjn7eMRdiW+RThjMwK10IYRGZqK46/+MfBStURkWuuizgWNsjBWMLxD7djuofMG0sOh7eP6xg9IYq+a9Pfg0XyuPOZ/gtzxgCSiIGBemFZv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HXAr/UXA; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HXAr/UXA"
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-8599c274188so43482285a.1
        for <linux-cifs@vger.kernel.org>; Wed, 24 Sep 2025 08:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758726968; x=1759331768; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FFc/AQGktz/VWzJOt8eeF6JUxZCHD9FnZinkgvKOZ0w=;
        b=HXAr/UXApNJF3StEr0efvzJe9sWZfrdBy6E+RGXwcjqmndLMhFjDTUgD35Fhtnl5/j
         A78OKoG8vnhzXEnBuWWjAmRZlxshdz7BXDRDNnCSAWcSlXFu4R0/d1WEEqq0Os20dOtA
         GvBBCsE9Pn6BALUqE18Oxpg9VYAixZ0LhjYWDMXz7DIhWr/F2zjKkteezvFUs8MBDE5J
         aH2hGHZGoy/JivfS0hL2yR8RJYKM+/YpyRw4V1r5jKWdPfkvZPrNR/WdeVNfBIfZeyBv
         MdicyHl/FfaA1nQtLbNbF+BSjwpOrH+VdrSFoGHX+qqTQTBY9jatxytFdocP3T5JAnQh
         JSGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726968; x=1759331768;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FFc/AQGktz/VWzJOt8eeF6JUxZCHD9FnZinkgvKOZ0w=;
        b=IS9Rfqcj0oHB2/buw4CpNgOI5YUt+j/TMfqSbbEgkv32ttyIv9xrLKulHPzcYHeHZi
         QUhnJKpfdZr1Mw5xCgm2marqciCZAo6g/28Nfr5XmIGqLNuOeK5WXC0SE0i6pUPUeesv
         CAusactPivEay0xgztliXWMY4eatg2UFbbHLjeAAFh+WA3mZH+HFo3HHONOomHik1Hra
         vl5zUNu4Xl0qaP+lTt1Sjfrw0niX5CxH8Sn9pIlXLbDnM5Qh8/b3E2UK1fXWe/xZLjRZ
         Ji+JYzcFKAZrfURhYIV3aZcBSkw1k5JWWPe2AMZoDMwN60+Gha/aVqFeBVd4rDtApK8A
         59ng==
X-Gm-Message-State: AOJu0YwM+oZX5Z2lxxoeY5qUfhXlcsVj6ozKdzlzWjsJpa3s2q/Qm23b
	GhPRwVdR4K5s4+NXvI89FZapKsxWjTwxWhe3I4dow/CufFviWdvbgrieNizzblCAeIi9aLWL3Px
	dTjfanUugeH+MdFcVhO4YUP0Byg5YqHypPw==
X-Gm-Gg: ASbGncs50SU/Q1IMpVQM29M7hXBvcl6xmor9RjPjXp+sdU093oVdVQ13Dwzx5mXbhe+
	27wVrzx/5EjDtmH3+VDKdkftFNIbfZ3s2d9R99HiJIXwX4EhZ6H9wIPTNMMIEGFiAM+/UpljZL2
	AHsGNplbyRjyovRZE/Bll8UdF6a+KJ4A+T6ZgOXQgsyBCuB/Vb+y5RW+GwPFvSW08nUxElV5FDC
	b7WaWDRjjLW7q1MI1/kVmL1N0IhiAOGoWefQFHFCfKGYp2RgZuDL3UFOszvxUvK1JHBEvgWIbgG
	GLh84b1ZGNQBDNdyGC+xa35aXPY0aDlVAfGZGiHdLpbsJDMpVgWf6ffff636jSFYzua1t07B8JN
	aHPsisjHt+fbVNPzM0r2c+Qgs6CIhmy6i
X-Google-Smtp-Source: AGHT+IEPcAwBMxYkrloKW7mozSL3usACkNzbDrWRggAjEr3N4CjzW9F6VoipEEwoaLOUI3aLJJSxYCsX75tfgqJikzw=
X-Received: by 2002:ad4:5f0e:0:b0:7e6:6834:e2f7 with SMTP id
 6a1803df08f44-7fc2d51fc41mr5796516d6.22.1758726968269; Wed, 24 Sep 2025
 08:16:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muDbZTXitjyMP3LWnAHvZwdLKk5OigR8_fH849jz2ukQg@mail.gmail.com>
 <CAH2r5mteYtF_Fq1dWi7k2DSLoQdk7gMsicvJpU+FjZbv+FgGZw@mail.gmail.com>
In-Reply-To: <CAH2r5mteYtF_Fq1dWi7k2DSLoQdk7gMsicvJpU+FjZbv+FgGZw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 24 Sep 2025 10:15:56 -0500
X-Gm-Features: AS18NWDWTFDlxkOUhkH8LlhduyrQOgH99bUMXMhVJUqDeKyO3IoltwZSxXnT58M
Message-ID: <CAH2r5muO=HXkxAuEMt8LZgfr=9i=rd_mG3Hobapf8rVGgWLxSA@mail.gmail.com>
Subject: Re: Fix for xfstest generic/637 (dir lease not updating for newly
 created file on same client)
To: CIFS <linux-cifs@vger.kernel.org>, 
	Henrique Carvalho <henrique.carvalho@suse.com>
Cc: Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The patch (which is in for-next/linux-next) does pass all of the
'expected buildbot' groups.

Testing looks fine but if anyone sees a problem let me know

On Mon, Sep 22, 2025 at 10:25=E2=80=AFPM Steve French <smfrench@gmail.com> =
wrote:
>
> Sorry about confusion - sent the wrong patch in the attachment.
> Correct patch for this important problem is attached
>
>
> On Mon, Sep 22, 2025 at 7:50=E2=80=AFPM Steve French <smfrench@gmail.com>=
 wrote:
> >
> > Am testing this potential fix for the dir lease caching issue now.
> > See attached fix.  Additional testing and review would be very
> > helpful.
> >
> >    smb client: fix dir lease bug with newly created file in cached dir
> >
> >     Test generic/637 spotted a problem with create of a new file in a
> >     cached directory (by the same client) could cause cases where the
> >     new file does not show up properly in ls on that client until the
> >     lease times out.
> >
> >     Fixes: 037e1bae588e ("smb: client: use ParentLeaseKey in cifs_do_cr=
eate")
> >     Cc: stable@vger.kernel.org
> >     Signed-off-by: Bharath SM <bharathsm@microsoft.com>
> >
> >
> > --
> > Thanks,
> >
> > Steve
>
>
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
