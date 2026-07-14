Received: from mail-qv1-f49.google.com (mail-qv1-f49.google.com [209.85.219.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4218E42BC4F
	for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 22:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784066562; cv=pass; b=g7hWwgiTSvO0rD3LpYexHMqsdu/T7KAThiGEx2+Rgn5iwMIolOigbjY3KnSsn1aAglJxrhuBR10NvC1Td+BWoekCZ8E5aK5uvAYKR6kSfTqd6fBr9BSUM7KGo9+jxhKJqn63ZgGozV+EkVwE42+ykSSB7q98lL8iC/83x9CzkDI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784066562; c=relaxed/simple;
	bh=s2NMO01f+U+VuXw1DWKroiHAOOn2fndEfN+PdDeg4kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kIQ2Fn17P0EetfKYGAkSw8XMIsSLEjq1n8RJyuGmuP4XoZUQ+dYO38rzg6zTqndNzoS4FFFpUhCilDE/0bUSSbayib8wl25kWjyEV6JerPrc8Q4WM0Wt/bXiEP9K2ucmoc2Djm33ELiRlklloVyQpRupO5Y0ezhzgL6BOjzNIZw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FmIbRRk8; arc=pass smtp.client-ip=209.85.219.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FmIbRRk8"
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8eeb4508f29so48846756d6.0
        for <linux-cifs@vger.kernel.org>; Tue, 14 Jul 2026 15:02:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784066559; cv=none;
        d=google.com; s=arc-20260327;
        b=GUDoETy86SgwyncFk4hJOThHAiAqEwBqVmY+HojqTczEi+qqry10L/mexTYK08P96T
         XVgtA1HG9BnJE6VYqhqkkBQVncFxB78niN434ndAe9VSN96wP6TvoUAPGS31axPQpZEb
         rXZsQPLYRc89AgbopRnH3Dx/jh2SVJQGTqD7WEb/PEALxW4aysEiOAO9KSIOwXjUJrjl
         PluGGVDfPVAypc4LIEjktqobfEi6CQCULUAjeOarxh6896yJjQuShbWoW6uLg8+QHJ99
         q7qxwE98CBtK60ODYagAhxc/e1xMSxN+OjFo4qhbVokP7JMcY8pOpZDyqB1xFk6p0AvV
         UqmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/ikoJBiZBLYxmU/Kg9j2nbqMDjaV4djVH2AeLg4FmOc=;
        fh=OXecSOWe7ahS9RkTowC9huQaFW17MpU2My2VLNp/ZtQ=;
        b=Tnd655FQ6KIxKh+Y8y9IUWiOPcNoR65PxYSSpaaULDjHjPxgwNDWWF+vcjksooP8f0
         cBH+CLUwNCTmFk/ujtVoi3wdCZw6YozXOWqrIy9vEmmZLTOIxcaNhPKdlGKscphoN+VP
         VQOfRzlwjMwzmWa7oNRvS/Sh35IbO7ZwUZ2W7e6R+BD+d6B+4MrDdJCoMaH3B0Yhm17/
         zgSsnwp89XiJULmf+dM2zbBKN5yWSdtVymmPpcLyeg2uGeCm4fiH7HAQakhGN8It9gIQ
         xek/2fCGI9yWiqQj4C/POoxze0KeeE8NWhge+zA+36ExJQkm2H2tTKtj/q2GkXeFs0QC
         Q0bw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784066559; x=1784671359; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/ikoJBiZBLYxmU/Kg9j2nbqMDjaV4djVH2AeLg4FmOc=;
        b=FmIbRRk8rv9ad8LG5/xkpfhv946nyDiHbX+inZTWEy0gnaeb61I8SAalyjVx9HKqjt
         zVLUksZFu0Ztrc1jHVAtG6SXpKF5aGmXTcOIga7H5GPPeIxjZXxnfp3uNNInBsyTckMR
         hXAgyVYwG/maXk3VbP2MQztO4O+PAtmvryMj2g15pl/YDE+RRhfmMzCqoddDBihcMAj7
         xuQtoTtgsoiVwezH3FoG7WgGcCAOYH/f2y3y9YOHQEuXOCg+3o9o0DqZw1v1TQmp+wVe
         oA3KoeTV3OK8VqLDFUaM0xk4yCnkiOWS/Da3EbJcLaMg0vhF0K2/ZeXXYt1oW1tN+64n
         PM6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784066559; x=1784671359;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ikoJBiZBLYxmU/Kg9j2nbqMDjaV4djVH2AeLg4FmOc=;
        b=nhOCxr7BONiWxp1XoEOeIaT2BNt+qLe8ql9J2ZtXMIb0HQYeCu8xVibSmnbo+SYnZi
         ms3E94EEg/1eQ/YU1RBJH6ujwnKGZNiEOfmfN2CpTdm0huW/G0nplrIiLXa4Y+Dgh5Mp
         /dOxYVlrCOatwJwtOuM7wjeX40nz9L9tWzs/g2Y6HQYNJFhI/QeBcFiw86g3//zsGyrl
         TiiUQdpCV/e8aTyaeR7S2+3PjXdF5S5cWWhZmFbVsnBvO8yGVvxGtSaiZiqUC+2Q7WW0
         IwYffT4YahqzKn+jH+sk1zaeuFdor6cd6S9GpTQvidsROmZHLXxi28jvCiHFBSBuMZZR
         Ho5Q==
X-Forwarded-Encrypted: i=1; AHgh+RoShhcsReMzEAV5wL30LS+Jk8WTwur+B+rxXnrGqu63HZKT2syFB9z1mEqs/fcT+DT8kuMUMRFZCLHd@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc9ci/SzXBZFziUoDj/DcUTHVMOt0wLYtzgPR3AGTFgYeBiBCY
	2axWcUYom7j8cPjzoZst8oWhSxlp5w9GfO1H2gLmocmnYGFcVkhm5bwCG2mqc981Gu4czkmkdjl
	Tf8M0PLP4qvUGK5dPxRYf+EV/V9VshXM=
X-Gm-Gg: AfdE7clqTsm3PCjIdV1k0FnrM7goM/4RirD+lVPa8uMsEt9f6JeiAZ4iK1lPM0VSjSz
	XIMboGDxgSAl5V7M16RoXoNTQY8qy7ZUmvrMEVS/5prZ5eiO3FJXuMbjT5IzlMeM38DAaurUPPm
	mu305lsOQywShVZKssdIQ59xlitxgq+0RJBTLKwsN3vL4Gpo0AygJKbpSejLO+3m6yuWk4nVIbT
	CIkNDdqQWY+NlSneF65c/cS/TkfJj1FVrBxvQ7MPGFFXwtgRSmpQVYqrRNB8b0WVkyMvTuKeDLC
	BF1qZ6SWNqHQNlAA/foqPSU139oIMlFC6MRrvnXEz50UnemOqORuvJG2fuMu8LROBGEM18F01CX
	iNo0bJZezCGVra3KR9gHliOktI/WQ6nGKwOCbWyl11KVnmp07zySfPPX5pjDji2Ci5L5EfZbWLx
	hOGOeCys8Y
X-Received: by 2002:a05:6214:3210:b0:8f0:367c:eb80 with SMTP id
 6a1803df08f44-90758d0d294mr4557116d6.25.1784066558928; Tue, 14 Jul 2026
 15:02:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260714135333.813314-1-andriy.shevchenko@linux.intel.com> <d9053c4a-e7a3-48a6-a806-56d6c05290ab@chenxiaosong.com>
In-Reply-To: <d9053c4a-e7a3-48a6-a806-56d6c05290ab@chenxiaosong.com>
From: Steve French <smfrench@gmail.com>
Date: Tue, 14 Jul 2026 17:02:26 -0500
X-Gm-Features: AUfX_my8HNIjglX4Dn-7IAfopVyMH0GoeMZk7rTfaX14MgwFuchE7wuD_3mAohA
Message-ID: <CAH2r5mvv0+q9wFDbuChWYfMzj-3tqK__XbbSk2fsdPfNbD_ASQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/1] smb/client: Use EXPORT_SYMBOL_IF_KUNIT() to export
 symbols in SMB2
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, 
	Steve French <stfrench@microsoft.com>, ChenXiaoSong <chenxiaosong@kylinos.cn>, 
	David Howells <dhowells@redhat.com>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	Tom Talpey <tom@talpey.com>, Shyam Prasad N <sprasad@microsoft.com>, 
	Paulo Alcantara <pc@manguebit.org>, Steve French <sfrench@samba.org>, 
	Bharath SM <bharathsm@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

merged into cifs-2.6.git for-next

On Tue, Jul 14, 2026 at 9:22=E2=80=AFAM ChenXiaoSong via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Reviewed-by: ChenXiaoSong <chenxiaosong@kylinos.cn>
>
> =E5=9C=A8 2026/7/14 21:53, Andy Shevchenko =E5=86=99=E9=81=93:
> > Replace EXPORT_SYMBOL_FOR_MODULES() with EXPORT_SYMBOL_IF_KUNIT()
> > to mark the symbols as visible only if CONFIG_KUNIT is enabled.
> >
> > Kunit test should import the namespace EXPORTED_FOR_KUNIT_TESTING to
> > use these marked symbols. This is the standard way for all KUnit
> > tests.
> >
> > Signed-off-by: Andy Shevchenko<andriy.shevchenko@linux.intel.com>
> > ---
> >   fs/smb/client/smb2maperror.c      | 12 ++++++------
> >   fs/smb/client/smb2maperror_test.c |  1 +
> >   2 files changed, 7 insertions(+), 6 deletions(-)
>
> --
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
>
>


--=20
Thanks,

Steve
