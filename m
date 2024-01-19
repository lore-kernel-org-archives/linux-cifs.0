Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C569F469E
	for <linux-cifs@vger.kernel.org>; Fri, 19 Jan 2024 06:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705644378; cv=none; b=rAkgvpAUFqxL4gsr1o9VpPR1pk6Ho9tKzL7k+UfjMJecOM6K68DTndlz+D+hl4w6o0VBaZxxVogPTTNRySX4HnALodpNIIV8i8mXW1ZbRcNG3JmuKCrgt7Vh/O26BYxAeWgUPn0KZ4z0Pmt9WOEFWQ1NbMy0BXxMe2mo8vhceow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705644378; c=relaxed/simple;
	bh=fZAskF+A7ChaS+OZ0FC+ZONUr98ZlxKnnBH5Tc8CDkc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NDr/biWWILR0plzgOrJOEH8W0HHVewTnCI8s43gBJxWevWSk8PGxk88OvQcSe9L5VN+5Tx0ZfSugHpWj6VAtgKSQ+rEqGNmUoSPlw1HOPsyeFlS5EZhz1W5mIL7YdsrnG4/jPzZduQAb5qy62qX3TrYhNAsQd6NAO8cNn79eZuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AEcktZZ/; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AEcktZZ/"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-55790581457so448088a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 18 Jan 2024 22:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705644375; x=1706249175; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/sRfdC3VSmmrtzofy4qmnf/3GFREJOS4bzzFkI+aek=;
        b=AEcktZZ/MVhtGXAQ3pU1czrF0BnpcZiVANTLY5t9zIuQIB6pekNoix+ZBmx3ip7Y92
         M7Hg+uu4K4231fYwDkLT/Bc8zJ2LOzKgdSuuGo3d/t+nqIsO0LkufxfvogTf2mJt6jRJ
         3P/0VGVEVBeSnsMIVxq3z2pzKR3/CHsynoQc5L1y6wYhUrhoKC2JbxqPGd92u8+nltz3
         /0DQdnVHhzzzIxy01s/q3rnULcVZbfLe8MvMkC773Mr+Y6fCg7IzDgdsbRcDSYUJ5fBW
         S+VpIyygR3c7dnbCwOXoUO/+hsrVTb2bRt84lgxlVsoStqHK/tzenHZxBNYIyWuyLVL+
         3VKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705644375; x=1706249175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/sRfdC3VSmmrtzofy4qmnf/3GFREJOS4bzzFkI+aek=;
        b=l8+qha2aTPToEhPG9Xoa14bH6wUXclMxGXa2wwtFldN+DOTll1SLyb3qaT7haQe2uZ
         ktCx6y+IEjEKfEnx7JkjH2vlKunnVwGa+lHxy8S7z0hrOX6t8dixRRIF2YEr1fUZ3RfU
         iX92AAaf2qVUkaqX0S7HjBIMxnl/vcPO7CW7W/OOtpUmcY4z4yjzwcEXl6N/ws60x+Zp
         hrGAT1vgi98t4UQSxAVttG5QXLTJdbmY7W/56enaOIRwRzvfWdAN5SNbDVljcLRPZ117
         kcDJN7J9DrjiQav7mZ12ZiT0KYw9obfZjWF6THdkbEs7/SQyzGKl+NLIU7oqewL953xk
         fRIQ==
X-Gm-Message-State: AOJu0YzOPAqdxLf7yxLh6IUsM5ZuZhnMo2LbDM7THuKqV1iLVapfXsf0
	SumFNCmTuOwQ5hC9dnPnmK4na+xgjOCPMH/bDCOBw3JMGeD7DoibUoKIEDVDopg+veZGLwlvavU
	Tgyx/JJRe4aaymf8uJ+twj0K1YbBdTdY0
X-Google-Smtp-Source: AGHT+IGEcuzpH7HqduUwLQt4hxC5m5JQtDf0JsrcHxXRGxU8F+KSWY9EiCMUkO3LcyP2PW+LUTkufB9pptMVIJv1Oac=
X-Received: by 2002:a17:907:10d9:b0:a27:a99a:a5e3 with SMTP id
 rv25-20020a17090710d900b00a27a99aa5e3mr1055492ejb.138.1705644374732; Thu, 18
 Jan 2024 22:06:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mu-1g33hBOjcY4S0JBuwD3VKD1goTiQKurj+9wj+XmXpg@mail.gmail.com>
In-Reply-To: <CAH2r5mu-1g33hBOjcY4S0JBuwD3VKD1goTiQKurj+9wj+XmXpg@mail.gmail.com>
From: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Date: Fri, 19 Jan 2024 11:36:02 +0530
Message-ID: <CAFTVevUJHg-ovGjbswvwd=TgOinqS8oWAg+0ihj8=i4LNsUZ8Q@mail.gmail.com>
Subject: Re: [PATCH][SMB3 client] show beginning time for per share stats
To: Steve French <smfrench@gmail.com>
Cc: CIFS <linux-cifs@vger.kernel.org>, Shyam Prasad N <nspmangalore@gmail.com>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Looks good to me.

Thanks
Meetakshi

On Thu, Jan 18, 2024 at 3:58=E2=80=AFAM Steve French <smfrench@gmail.com> w=
rote:
>
> In analyzing problems, one missing piece of debug data is when the
> mount occurred.  A related problem is when collecting stats we don't
> know the  period of time the stats covered, ie when this set of stats
> for the tcon started to be collected.  To make debugging easier track
> the stats begin time. Set it when the mount occurred at mount time,
> and reset it to current time whenever stats are reset. For example,
>
> ...
> 1) \\localhost\test
> SMBs: 14 since 2024-01-17 22:17:30 UTC
> Bytes read: 0  Bytes written: 0
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> ...
> 2) \\localhost\scratch
> SMBs: 24 since 2024-01-17 22:16:04 UTC
> Bytes read: 0  Bytes written: 0
> Open files: 0 total (local), 0 open on server
> TreeConnects: 1 total 0 failed
> TreeDisconnects: 0 total 0 failed
> ...
>
> Note the time "since ... UTC" is now displayed in /proc/fs/cifs/Stats
> for each share that is mounted.
>
> See attached
>
> --
> Thanks,
>
> Steve
