Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D762D2BFC60
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 16:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762447579; cv=none; b=c4GkudykZ88d2Jj6zL6f8FK6mBhcac6LMk5w3IwRTls+FayDtKgxEwrdE58zLSukbcnFoPpnBvkI5g2TKiLNQqVxDbwNexT5+enVCkBBxiHzgEcJkpAX7N2GERbUfRjX+qnbkmGrWEdG/oHjmFmJwaxuutd/Dwa24yRbndRWAHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762447579; c=relaxed/simple;
	bh=N40ebDRrHmkLc+g+l5ilDwi03mGpQc6Ol3qk2AWSVbE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nl18wSbhLGj0UlKfh+3k221cOOY/owQpswgQc4yFQQpxjst9MbN5GB/rZwEFHkCO6AdkIFws4OLMoJi15laaL3YU2CvhE1xRcJ9j86px8N4ipngrvgQvUDeMs+X3SBWk/71Bd2iHviroK1KzA5VYcjqHoAMtShDG+Pp7YJNL23c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ya1aLIO6; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ya1aLIO6"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-786a822e73aso13195427b3.3
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 08:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762447576; x=1763052376; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z4LdUw+ksYk/YntQ1Fbgent6mIei0Xy0KR+dIT0J3Es=;
        b=Ya1aLIO64mA85gFpdKTtukpEPcZ0v1/FqfU4/2XZcHEzUyO478q0ihR+fLant6igHq
         rSVbK1lCIVugygSu6/Vla1rXwOroFHCLtRe5IUTib6Fnqx3khp1YzqAWQpKKoyJGg/st
         oxqyjst2YY6lvezCJUOHqPMLW/02raQT0UqT5frsb5HjawRw/Ek78OEh7a2P0DwR+XU3
         xKbyVNd8SoTtF/8/joytODca9Hq2qBLU1eTxNJFm7SquTdCVo+/5ytfGMywODn9KxTPz
         Q7XukqPL1Wnpiz2D1DdlrXIYCrWk9zdv+PFKTjcpyC/BgkzCuw4Yb6Puz2zYML/pJuAN
         Z4Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447576; x=1763052376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z4LdUw+ksYk/YntQ1Fbgent6mIei0Xy0KR+dIT0J3Es=;
        b=SYhK9GKEy5vlbX+5YnFCL57e+ZIma2LlkgsCAv/xWJgRsb0KDe3jYvt2qBvsvO1i88
         lc03X+4B6SUbmjDZ3SpqLReFd+w8fPx5Dj6Nq/oNYFPke7i1TaTCxtWk7m3CXCGDTfcg
         yjxEG9wCNzoG7rLmraOU4ST2J4JSdNYRciEXdSVNfLTyDanDvwb586eS5OdFdYqMpmM5
         yFgiTJJyMmtHRoIyKaWv5SGASOVpREkkYRdS9iokBzGZfE4UePSu+/IXA2QKSaJw92iv
         26pLW6rdEkuvfeKWZrNMK/GugZtiW1cdlWyAbFzc69HPIUIj9uGZzL3nLxuGa0F+z+hY
         unkg==
X-Forwarded-Encrypted: i=1; AJvYcCXspyykauTkz+UWguj+lyET1fmk6Gg+iLbaTZnu5TvUam+0sUYZ9fBu6wJtgHmTS5owX/FOioGAivwt@vger.kernel.org
X-Gm-Message-State: AOJu0YxhhVjT1M7sddsr++bX7Q0XAgRXrTmuSIPmoPfPYsdSN91Prdsk
	UcWJ2zHEENWC+TNc48epTZOKuZp9WnrX6EVYMqbw10KulHS+AR9THGh4HceMHqrmauLpH0D2yZk
	2bQc4nkXwQ2noHQbpSN6vryh9vY/SuY8=
X-Gm-Gg: ASbGnctHcSdY1tLWGGfxD3/ujWoyUjt1Zx2S16BvdNBvVmTd7+ExhqjB0dqctdP+Son
	F1fjb5z1aBu/S+vljPCRP2L1TWbncKDKw8CIJDgI96ETDRP/m12N4DdtrlC0ijR6eKRxqI5D91E
	L9PoCHv6fcEdAJO8tMwIXSaoPnDT6U+4FnuE0iZ19oTAo7zAQk1ILlrgWJG7VwjiObNRUW1fcmz
	9trH1QBAeF8ZZaMYL1zylNooZISx8sKGntnfqhrrqsOxLIP+8kBYik7IYQZ/oc=
X-Google-Smtp-Source: AGHT+IEBZpW9/PaXSdZgr36KPEFaiBcZa2UOvVTtsxPUKIkZVr8qw4yiPOLdkrJ/mPzR590v4/g8t5oa8mAFLRenNi8=
X-Received: by 2002:a05:690c:6d0e:b0:786:5620:faf8 with SMTP id
 00721157ae682-786a41c8b99mr69617747b3.47.1762447575713; Thu, 06 Nov 2025
 08:46:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <10023.1762446142@warthog.procyon.org.uk>
In-Reply-To: <10023.1762446142@warthog.procyon.org.uk>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 6 Nov 2025 08:46:04 -0800
X-Gm-Features: AWmQ_bm5B5Vy_93ua0j0GKM-XFpKNyrrRMnDSdTqgB7uceKrxTzM7lgjsF--l9I
Message-ID: <CAGypqWySt7j6-zsNX+gSNgVeC1JwcO2zY-D7UNhjquDAPN_JqA@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: David Howells <dhowells@redhat.com>
Cc: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Enzo Matsumiya <ematsumiya@suse.de>, Steve French <smfrench@gmail.com>, 
	Shyam Prasad <nspmangalore@gmail.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 8:22=E2=80=AFAM David Howells <dhowells@redhat.com> =
wrote:
>
> Bharath SM <bharathsm.hsk@gmail.com> wrote:
>
> > We are noticing the similar behavior with the 6.6 kernel, can you
> > please submit a patch to the 6.6 stable kernel.
>
> What range of kernels is this patch aimed at?  Pre-netfslib conversion ci=
fs
> only?

By looking at changes I think it can be applied to Pre-netfslib conversion
as most of these functions were removed after that.
