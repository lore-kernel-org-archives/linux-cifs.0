Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47D0C481DD
	for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 15:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742830401; cv=none; b=ROfenaKgYmtg+9zPMvFZO8enzb+K+C/PJpo8nOzGktzgKivMTQCQr6hqCQmsW+QjdULfsbCQ9h/rVvaLuGixndS2RuYl6UiKmIlmWtoTUTNxFAitvdvst6SmjchY/bNqPkMTqVKF/77MBYdYhUxkmK2JChWVfSbJJE8ik8yWKKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742830401; c=relaxed/simple;
	bh=Vt3j/KWCa7+4C0tnFZpoktn00yRJB5+sUDIt1exozH4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mTCB2Pg25ukeMkr0SLIuAAkVj+sf3yjzgfHDusFO36oOxlUjed/5wxg0EHuLl1zkHOWXl868Z0CPoHIkAXbPZa5X4VQb+/j3kACfbgzkEwN8xyB3bcL1LoHcUqm31QUXdRHamtUkvn9IQP4St8AicoC8fO2sH7WGBI8IpiWsZe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NtiL0n//; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NtiL0n//"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3061513d353so49576061fa.2
        for <linux-cifs@vger.kernel.org>; Mon, 24 Mar 2025 08:33:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742830398; x=1743435198; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vt3j/KWCa7+4C0tnFZpoktn00yRJB5+sUDIt1exozH4=;
        b=NtiL0n//+cyI96jtK0X6x8rXJZCHichHBtJOGNP0N5uGK3kxGXQJaAQxWStejiNU//
         0LVJtcn+haY0OQxnywc4oTTs4joFWvxSNtZYhFBjtodYBFg2NbLbF8tkf9Txt9guhQ/4
         K8J/m2swkkm3U3hFCulos+YLNcXsGlBgtlkh9oF80DZbsjlSWcCz3SusBDPQRyXxXPtA
         dxeoA5w6OhnErtS1EYFGU400uksap7qaqFa98MGoPuBa9AXXdZym6OZvd0u7g2qBsjIZ
         ntQ7xn6muRAtJBbVjL3L/eeguSfhD2SOLLzGwOh212+W+C3CLPSRINDH2qFVa+IZ581U
         BBiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742830398; x=1743435198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vt3j/KWCa7+4C0tnFZpoktn00yRJB5+sUDIt1exozH4=;
        b=kPaw8OrKA7UnHBcNV4FqDGbFE520YcID40jP6Ju/HO9bSuDOvRODtM1dxj71P68QSp
         2oOg+squpx84pg3PqfLBz/Gx+g3qMLOd1gM9MTVT7ZTg0Up78aiC9RFtTHfgWPUoY7zW
         0Bfn5yftsX3Nsrin2yjY1gZfsQCta1JnOqMgWaNsrYa0lVd0ShwCibr/i1DE5ZtKbPG7
         GgUdWlnpIs8hTRhL/llGWZh9CkC9+WGr0ho/XqagW50TxtEZDMJ8KCwpyon7FagyIYvT
         /CTS5eE6VnHH7ZBVv7TxbfZ9w3JYVn0H4IYDqhFZt/S/kYK9NAPf3p/XMuGvSDVFXVB8
         YJjA==
X-Forwarded-Encrypted: i=1; AJvYcCXA8HP3JWuYN9f5gLUaJlR4xKQJnULzp61JMZJa3vUjLGgL6N9o8WDwByrufeLqOs9UApKtSrrQWo+Z@vger.kernel.org
X-Gm-Message-State: AOJu0YwF4IK56pdLrAFXkQRp7HRlcgzVHVL21kFILkfdjy/fBozGC2Z8
	wuRfdUMqrudbbu/Mp+sP9tA9iS8Ypb6cnJzoxP/20OTmow9XVO9dPIC0ZfDWV4PbGUzGbukyUYI
	V6nvCMaBeM4W55LF2/zUDrrnpbZNqCQ==
X-Gm-Gg: ASbGncu6vl5Q8LfIe8YFF4DTbOS0eLiYVC42RY0UoDpTfMuAlLagEJAOAnDVf1bcgkB
	s6N9yHhsSWkZOt/cG8wShRlPFeHXeTu9cEfDlTuNA+iY2oXkAA9E0sVsCEzC6CaF966pCxUdypX
	LYi6WzbBnoMKlL4Bso+Jx3j0YwU9cBL6fdu8Fe+bxTMcmhV5VONCiaXHEo7MbSgodp2LLMWY0=
X-Google-Smtp-Source: AGHT+IHXo9qw2N4raTmLZvZxQM/eM20EL1o3xLY+i90oqhacrvZNoYwhhX/0j+RaCle8/OfYqUYQttjCs94leFrIwRI=
X-Received: by 2002:a05:6512:31c7:b0:545:d35:6be2 with SMTP id
 2adb3069b0e04-54ad64ef3fdmr4691656e87.34.1742830398020; Mon, 24 Mar 2025
 08:33:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <2bdf635d3ebd000480226ee8568c32fb@manguebit.com>
 <20250212220743.a22f3mizkdcf53vv@pali> <92b554876923f730500a4dc734ef8e77@manguebit.com>
 <20250213184155.sqdkac7spzm437ei@pali> <CAH2r5ms5TMGrnFzb7o=cZ6h4savN2g1ru=wBfJyBHfjEDVuyEA@mail.gmail.com>
 <20250323103647.rsex63eilfdziqaj@pali> <02d5d5dccd2fa592baa2d16020d049cd@manguebit.com>
 <20250324082310.fbvnxo6cmuwv2clx@pali>
In-Reply-To: <20250324082310.fbvnxo6cmuwv2clx@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 24 Mar 2025 10:33:06 -0500
X-Gm-Features: AQ5f1JpAWl2D9HKObiGUHy519U28i-prdhxKgnFSZmyTJz6F88ogLjxAhoozz_M
Message-ID: <CAH2r5mvaM1y3xEL+yiFDMHRVZg2j48hwVaQa+BL8f+23Y7VwrQ@mail.gmail.com>
Subject: Re: Regression with getcifsacl(1) in v6.14-rc1
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2025 at 3:23=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> w=
rote:
>
> On Sunday 23 March 2025 21:36:56 Paulo Alcantara wrote:
> > Pali Roh=C3=A1r <pali@kernel.org> writes:
> >
> > > Hello, I would like to ask, how you handled this regression? Have you
> > > taken this my fix to address it? Or is it going to be addresses in ot=
her
> > > way?
> >
> > It's already fixed in cifs-utils-7.2 by commit 8b4b6e459d2a
> > ("getcifsacl: fix return code check for getting full ACL").
>
> Ok, and into kernel is not going to be addressed that regression for
> older cifs-utils?

I thought we had decided that it was risky to intentionally return the
wrong return code to
userspace, to workaround an app bug (especially since it is easier to updat=
e
cifs-utils than update the kernel, and also since cifs-utils update to
7.3 is strongly
encouraged for users due to multiple security issues fixed)

--=20
Thanks,

Steve
