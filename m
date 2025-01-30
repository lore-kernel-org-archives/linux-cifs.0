Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09992A41
	for <linux-cifs@vger.kernel.org>; Thu, 30 Jan 2025 00:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738195236; cv=none; b=mOzzc7mBSOalzhXZoP0jyHydfXvhtOiXGqM8Pqs8Spe9UDv/AOO0QmhIs7KuCvYtrTeSnN8BqNEtgZqJvKr0BUwbxgcWOK3NcoGAFwbgnJtTqn+HDVMdjYmF0OnQ++3lMYPj0FqdRYDa1aixENcLL8+ymB3bRLOmcE98U5pdnmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738195236; c=relaxed/simple;
	bh=SSpMdnhM59j03d71e4S3emM5bY6NKjsCicBaVk0QqpE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=LYHE7kc4XaKX2p2Bf694qX3ddxHd5CwBiMzPonxH/j3T2I2gg4tqiddPU1eloWQCxB8XkLrw6dM7ONytRRYZcia3YybqbRatXdJoHKMuCNKMeitmkEhbIcByOHwXqYC3+IXRx+RtpyuCrMNZgLBFzTtzoRRfuVlWN5QNLr7mSuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h4IMqitw; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h4IMqitw"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-54287a3ba3cso1240915e87.0
        for <linux-cifs@vger.kernel.org>; Wed, 29 Jan 2025 16:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738195233; x=1738800033; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SSpMdnhM59j03d71e4S3emM5bY6NKjsCicBaVk0QqpE=;
        b=h4IMqitwE4ToR/wfSObyT3GR0t24BFuGZKIYsbNoFr2OWpemsnmtwBU3xnhuFitzq2
         Jtch0kqftxjBiYrUb5uV+K4Qzd16T7PrlxjAkVWXMrE80RbArD/kIziMR2ocCgN3UOa9
         wWdtgFempdniIjPXg1DERsBpSMIvbZgDKcQ8ci/Yqu0SYknaWyLr6gJfqjHjLIX8//s0
         LDY92FS8E+TRFfHhv7ENuk13IKFoL2qYNRoJhn0CQ8EsxMgt9sUnpWcFppFoRi/1U8pF
         w1JI9Ja5trF5ElPjWlg9LzbtelcmoS/vOXPk51U/PtDi40Tul/slAfeSz1osFc03hR/P
         3j7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738195233; x=1738800033;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SSpMdnhM59j03d71e4S3emM5bY6NKjsCicBaVk0QqpE=;
        b=ULxbT8R3+4wHVKXtDhB6jHgJ4l8uLnqH7V2NnONIcplTnldfcAy4You1U50DTDlrci
         RDb4d/lzcvs2WObeGKTp5B0H/xvD8D15Dfsuh9Z2gBVIG3rkxZbPLG2rIelKwWZZwAGf
         4aZsimB1XZNaKmVg3bSmEREGZpeUSLfLZ0fQDwEl/6o9a+aiHAEM6uMM73e6D6JwATer
         GwH1jbT+VCbqSXIlD2bY7imv61K176DaBxgjSVxt4OKQrTFkq/FEyYxQ5C0apVGmqyha
         op5jvJJTL/vIuDLr4ld0RPoL70M+0uuvKtBNVskQ+ozMtZqvl6Pg+nf/T3VtyBSQB6rT
         zxJg==
X-Forwarded-Encrypted: i=1; AJvYcCWUMjMVMAmdaCqrqPF3j3MvvB1l3wh2xUBIYGrslJ1JaMvWmgjBQhW7C3mjR+RiTSJg4ZagTH0rbW5Y@vger.kernel.org
X-Gm-Message-State: AOJu0Yy9DvAyabT3C/ur2Gk4Ng0joOmrqwsRcKxOvcfRuqU7b+RTV9pO
	pk9qvoh87P0Xle1NV2qX6TX8bkfg+o0NeWo4Y4gcLWHebqbPNwYFa7hctV0fvva4p2Sn01I5eW9
	DxEQXllQO1k22P+yOgTVtCPwLHH/WjnlG
X-Gm-Gg: ASbGncsTXe2ePB5uUh5f59HltSOSuzljfls7X1qa6rRKgRZ8VjaurGA6YIkF1of14Yt
	ggefqMKqsXMgCmMBN33QW5LCM01EeS3YhU6/Rq0MiHH/vzznu8C06TuLxDYv/rtkEGeVw8EqZdQ
	==
X-Google-Smtp-Source: AGHT+IFjFJKW97nhdcxvi7R5rJBaHV6oIC7Lhom12AX9EZaT1vzEGiRX+83Zn3uKjgogbgmsyTdoQubOJtJt5T6eAgs=
X-Received: by 2002:a05:6512:308e:b0:543:bae7:eada with SMTP id
 2adb3069b0e04-543ea3d2245mr450611e87.14.1738195232885; Wed, 29 Jan 2025
 16:00:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
In-Reply-To: <CAH2r5muXhrTc_pa-uhB62dOjQDZR5WBzz4NiVFimVQ=oTysekw@mail.gmail.com>
From: Steve French <smfrench@gmail.com>
Date: Wed, 29 Jan 2025 18:00:21 -0600
X-Gm-Features: AWEUYZlbl_tgzzemcai7kpKnwacquHOZfgsm1bBty4_d04YmGv3rRLiNKfdwcyQ
Message-ID: <CAH2r5mu49ffRd=R7KqWXvXzXysy54obBJ8egrH1fbKbyYbMWGQ@mail.gmail.com>
Subject: Re: [PATCH 18/62] cifs: Check if server supports reparse points
 before using them
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 I was thinking about the possibility that there a servers with bugs
(ie that support it but don't set the flag right) - so haven't merged
this one yet - so I want to know how bad end result is if server is
correctly behaving but doesn't advertise reparse points and you try to
create one that leaves debris (file/directory).

On Wed, Jan 29, 2025 at 5:39=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> In the patch below, do you have an example you tried where server
> without reparse point support that left a file/directory around after
> a failed attempt to create FIFO/SYMLINK or other special file via
> reparse point?
>
> [PATCH 18/62] cifs: Check if server supports reparse points before using =
them
>
> Do not attempt to query or create reparse point when server fs does not
> support it. This will prevent creating unusable empty object on the serve=
r.
>
> --
> Thanks,
>
> Steve



--=20
Thanks,

Steve
