Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13B23C4FF
	for <linux-cifs@vger.kernel.org>; Mon, 12 May 2025 22:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747090043; cv=none; b=Q7OJSzO5bJffm6e4sfVse6FEZRXXR0DvjtSJ12kLbEC3CoxxtdbZtSO/yQT+3co5zN+IlENwHSodAsE8BNiLRlsgSNW9PbU65NdTsU/Z4YwxWZrCj2DrWMwDNCckz0EJLvAcbpVET+v5atpkfweY2L9AsGO5insNwqjkr4LzLwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747090043; c=relaxed/simple;
	bh=uq46DQ+cCxhshk135+UaKpH10HQCt+HMlcon1rHExRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uHw1VrX2QEJW0tazINMheeVr3d5fIck768N8jkMtDcQc9/18I4uPrZ4B9PTJnQr38+1k4gIWdQ+ThCUliaDipG0vhYSfakYJ1mG3xcI6uMlIXEtZgObkL9LV23fsibyvbr+8tWxbMolFYS0sZuy2qxNsm/fz+J5hDlHzvawMpnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hQf/X1bs; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hQf/X1bs"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54fcd7186dfso3159120e87.0
        for <linux-cifs@vger.kernel.org>; Mon, 12 May 2025 15:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747090039; x=1747694839; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uq46DQ+cCxhshk135+UaKpH10HQCt+HMlcon1rHExRs=;
        b=hQf/X1bsgD7CzqFiVxzjJzfbCe1GzV2CHaeOsc0V11+5lm3CvxtCORxGtDp4wdwxFv
         TVrCgRJ4CGQk7/F/gacVsVKWpxyiL2LetAL184oyIpM/4E8VEQP3q5EeDIl1m/EbfMwj
         5piCK+JKG2eLNmiviDIWhDB3Meh+DENP86ngvPVjizRvSXliSc6C4oLb80w1efIv+7gQ
         G8xJ+5WR45eetinhlv/I1oARZY0vvWs24Lgmt0p7/UFYnyB3cl2aVYhKfmGZDQfGxyFb
         jZRqIf3bMg8QfuT65daStwThTzmavtxCqLcLgTYL9LSSqsOsKogt3Tqwl7oMaq1tFeJz
         QPXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747090039; x=1747694839;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uq46DQ+cCxhshk135+UaKpH10HQCt+HMlcon1rHExRs=;
        b=kcuUEuRMESMlIJwnIlK+W8d5dAJeRCaGVx/sEpn8iIivfc0C3PsVhvdo90Q3pZxTJT
         PBykDffdS7Hm9hkye1hK0jGQwAG7L0UDwHs5Nec9VMRoBqKFDIXF1R52TY0Fr53gtts/
         byRMqU2rLvnMQvvTTHc9BOUpoUY3uZFWV/02fp+m8yKiTjbn8amV02w5jcTKk6GzrSmj
         TxYpViwmpptZ9RTQhWVTfsD/ZDfah8D+T7kqJwIvB5nnaBrOYn2aSBUC5l3/mtTWeYje
         BmWv8LBtAneYW2y28tivCle3zWoP72Jr+GTI+1K8xtjVew8t4Kq3RvQ1H8OcwgmjQd/T
         ntMw==
X-Forwarded-Encrypted: i=1; AJvYcCXGkUjKcIBqcKegQ6SLgA6JD+wk8JUr9xCe1KMKeohBOw4FfywYuo4FMZK0bBrhfcHYhomZX/kYLO7s@vger.kernel.org
X-Gm-Message-State: AOJu0YzNaDq2kDROXprYZvQqMcKWOJtHfWtR/P/I9VzN81z9Yo25nSBE
	aef95C2o8s///4JZo2kNZo+6WoobWEaHZKL34KLC0EtmL5f2VVkfgz6NabAo0U/dqBBf98+KhFZ
	gbg2SDsvb1FBNRcAgeCjFJxxyA+E=
X-Gm-Gg: ASbGnctQds2N1GlXqx9pG8TarJf2xgkFZH+HHKg2RDaldSqka/nIngptHSyr/CzU1Yk
	VVu48IZUPlTQi1maPDuMNAxm+MEzIPx2IwCMXRHbUlZL2YpEArvIPUCE1QNm259zyeq2S0KWane
	ddM+3nidkN+oHtTex50JbyaDd/wIz43Yb6reml8FF6aGHwNsafbLfWEr4c0YtM8aAGoDY=
X-Google-Smtp-Source: AGHT+IE4tay1yhNi2Wc4xtjQ132CkgLM2dPIj3KTIcO6pyZ+f2+JGIZ2K8aL16FA4cC5gbsmnwlUUEPfkQxUZlbVMA4=
X-Received: by 2002:a05:6512:4381:b0:54f:c0eb:c8 with SMTP id
 2adb3069b0e04-54fc67cacd1mr4256404e87.26.1747090039325; Mon, 12 May 2025
 15:47:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250428140500.1462107-1-pc@manguebit.com> <CAH2r5muGNUp9UqQZ_mPVoLiw9+xocV8OZ8hubGyQG=oTd=-BXQ@mail.gmail.com>
 <2f76f9b0b3e5ca99fce360d19b0d6218@manguebit.com> <CAGypqWx0xEJRD_7kxNAiyLB5ueSGFda1bkRXECXtUhinVgvV-A@mail.gmail.com>
 <3d7d41c055cd314342ec1f33e6332c32@manguebit.com> <CAGypqWxSgsR9WFB6q4_AbACXeDKGiNrNdbVzGms2d9fc2nfspQ@mail.gmail.com>
 <c9015c6037df3dd50be1b20c0f0ac04d@manguebit.com> <CANT5p=r2-Sm-9=jPY0YM1mV4J0H5fOG31WSZ+E_4dKqNcNJ_Kg@mail.gmail.com>
 <3d60f40bbcd3d297b860f4359bf63def@manguebit.com>
In-Reply-To: <3d60f40bbcd3d297b860f4359bf63def@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 12 May 2025 17:47:08 -0500
X-Gm-Features: AX0GCFuVvEjSk7lcGZEohNLw_z-t2MiZh_TeYOXY836tTLbOxRLYDcdriRM3LVA
Message-ID: <CAH2r5mtmcFWw6Gm4hg9Ze_1VnN-t4d5LSmEh+oObKASWNXbatw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix delay on concurrent opens
To: Paulo Alcantara <pc@manguebit.com>
Cc: Shyam Prasad N <nspmangalore@gmail.com>, Bharath SM <bharathsm.hsk@gmail.com>, 
	linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>, 
	Pierguido Lambri <plambri@redhat.com>, Bharath S M <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2025 at 8:31=E2=80=AFAM Paulo Alcantara <pc@manguebit.com> =
wrote:
>
> Shyam Prasad N <nspmangalore@gmail.com> writes:
>
> > I think this version of the patch will be more problematic, as it will
> > open up a time window between the lease break ack and the file close.
> > Which is why we moved the _cifsFileInfo_put above as it is today.
>
> Can you explain why it would be a problem sending a lease break ack
> and then closing the file?

It is a performance issue to send an extra roundtrip that is unneeded, so
key question is why was the close not sent immediately if it was
a deferred close case.

--=20
Thanks,

Steve
