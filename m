Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794189440;
	b=VoT7T/HnUZsvg/djVDA28QxeiZ3MPPSvnFcbBN0QBrKe2buqaeasVLWhMDbZN+IgMmzY
	 UKHwmetV2z9kObjXLvz/TRArjyELe/uZO9UC4wBj5Y8iUfg5JQyQyvhx7dG+yz+rRdgRn
	 oMb4YjAGRX3+br3DrSZgt+ZDd9wdNadVHHCBPDo7JX/shifV+dTHReLaDomkGtR0cJc1L
	 631K0y1ZkBcTvvG2XmxCNVboeSF4BBJHOGqiuxVcMPZYrASa9bDLRFZTTnq+BmUxIBOy8
	 njuVWkb1Eec2jx54f6aV7OqYqorUsjnvXU4FgO6yaVptppuK5QmecoaQ7CZa4LYmj2A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794189440;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=NPpBzy9rsAwjnSihJCJz8r4JLNePzNIyAaNAKyPfXSY=;
	b=2BRG6YUilgWSb3pfBR6PTD1RItunk+p8DD+2swGUXI5myJ0V83r6O6m5/rDx5fhZhVMU
	 WZUuxBdgirBl1qXPYnJf+nu58LKr581pNcDA8AhkJx+Z0tpNotRq4Th7IlnXrRqXypS0r
	 ZFEMVVEPSZwnZWVQ+xmreoCDGOjKesdDEX00o/wFCl2Ikp5bw2BWIi0mhbn4Pcb2nKNwf
	 u8ChJcVPLyOmBvv0bNE10zNPKRzOs7V7dp9bup1aufh1uhoS/mVUVMcrSNfnm2fhCVvkb
	 +mzePnwngx3yMF9XRQsBU5sKgtlgF+BqOn+3Doo7VVarLFlf6d1QJ0Wc49iU+TYhQtA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLuxsJ4I;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.52
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8DA606A320
	for <linux-cifs@vger.kernel.org>; Mon,  9 Nov 2026 01:57:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7D8DA606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HLuxsJ4I
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48dfc0421d9so301570f8f.1
        for <linux-cifs@vger.kernel.org>; Sun, 08 Nov 2026 17:57:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794189439; cv=none;
        d=google.com; s=arc-20260327;
        b=Mg67JC5bran43bkXvdaF4efSNuBRsNafRHz/VtJj9BnXNyokXfBw53BDW9DBa7F7uk
         rqW/962txpfz+anMOTR7VoY9g5iXUDPndM8xu5jfjH5w8TsPhSfYMlmLLF9nPeUrgvbG
         TsFM1n2iNDr4pDxp7829xQkt43NS5EfHozLig54nk3kz/E+80yT1KzNi1wsapoY4ijwY
         KF1hwOUQqfdsCQlcvh+i85HvMS4t6i9oQkqDjxtMshOUweTqdWIfaE7aSlCF+3kWbfwx
         mzUvSokbv9wiwfVIuJb7jIoO6r/2jJ7bZsCUCKHLry6lGFjQL0Z4+YQw0j6frweN4Beg
         Yksg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NPpBzy9rsAwjnSihJCJz8r4JLNePzNIyAaNAKyPfXSY=;
        fh=iJ0dS699nvEWcBUCEqCbLFLbiJMulH9KABWW2df2w0I=;
        b=oCtcGIlIkswKxPZlucZGbm+TMKozDZBqHsQRZvkGeMbXwraWALOrZTkD6MM+kPr1Kw
         j9hX7ofQgNWsK6qg0XYcLWGei7EHQM1swofpB9IRqgq5Q9VedcacjyvSqtpMEYue+bLx
         VFJ5kZW53mxHJu1wDOp1d/QdIiy6OcC7kquU7bTRrT5zAlbRrJa/qGwQp26Ff41kA8wt
         Y1gQl1RPu2IpzJR8TIWSQP3+/sot6wiS5IcZ+f7UoSXMWEbmK3g08rlKbl+LsWw+tV0W
         ifN0v0zea/cBkhQSptOk3UFW91Vs7GilLKC/MLjShtemNgnKrB3zojAFbOVKclbUsfvR
         9xgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794189439; x=1794794239; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NPpBzy9rsAwjnSihJCJz8r4JLNePzNIyAaNAKyPfXSY=;
        b=HLuxsJ4IP5OUkWgfPaGUApudypO9O4vX4JMcj9VVgKQP5DaSsTW8OU1dInUeenMjvo
         dLFWbWsLY1zPtI84efXesdDNOs1L8A0Ij1EzemG0ZJY4hdS+PZ601/ghCcfyL2x0zqlV
         c4zwBDgYbS4kgDGujAhVMzSe+WDfB4hQDH0DzrznKd9SuH7i/Az47FZm0FLVMG6uf8W2
         3Nh6R4WXHtYaoFrCTH6NuRLT4+gnKcCEFNfI7/Aps87SPfdpKcTpQE84yAFzL6j60cEN
         W1YOxmr3QkYZXvMgUMrhcRyyYVwwEfTGVG4pXBSc7PgSHLLH2sfC3/755Tq++sNAPVlZ
         AG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794189439; x=1794794239;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NPpBzy9rsAwjnSihJCJz8r4JLNePzNIyAaNAKyPfXSY=;
        b=LvnRBhq97AFl+ieJMUmyHz1MGL05EXEc3+aDWpTRkhCZu77FOe/QwOSzhNe9cd6FuE
         anKdXUlA6S+/KsmQ2L3OzJuZIg3ge6DCjM6OcqjuF0t9reD7uOa0d8mIRHribMc94Qd5
         GJND/QMNomJ2ZUJQWmyCbD842pHm9DDWYiwoMz9swU7cEJfNmivnBpS75Mmc050CRH1t
         gB0NeiyM998rITk9x4gGTX/tDbgaDem58GYdmRmdrt4v2zCErjKhJJlVdSTUDq1ETk2/
         9tNoeHxbV3Yl3A8J54aYMM4/tPikMhDNIIrPsBbKDGB5c9hwDugykF0hVdcgTCv/eGtM
         l4QA==
X-Forwarded-Encrypted: i=1; AL+hErGGrr5FzF/mipLTzUPVolXixfJLUHj8a5825tDjtvWhgJiGn80f+r7EmCH4AXJOohjkpZm6ft1eUUmJ@vger.kernel.org
X-Gm-Message-State: APuU4Z9B9+L6cyx+ZjObVbhvbkGkkQ8q9PfYZARd2YjunfxqYhA1zN6t
	OiodkrJ5bAAN8SkFPy5WZxlNtUddcqx9+nnh4Re3YMIemKGONGMcnDBSXX+RxJ3H8S78CYyDayD
	Uhwo6R1Gegk8cXPasxffmI3I02WHEvrE=
X-Gm-Gg: AYBFou386BikBAjNULKEN7NOJaTfsAgIApO4HtV4C+gAEvoLBhYlUHuoeBIWkhCDzy9
	ePqEDzgRcgVSfSv3TrJ8SynAe+0NgoGR2SEYrmhtUaO9/HX629I17tOTZ5i7JDvCBiXBSVHR9Ih
	GFC8/8tDkNtNl2DyQ3zhLBi13NbuYzD93wir0aqCkjYHSWMFiyK+L87cSDBq5NW3dkpfjtMQGL8
	IDLqeYYKLe8cMWLr19mEJukTcwc/xCYs/X0O79XxiUoDm+8w2W09qysSHl7ZgKDtbjGemFAeEyR
	onOiH0CBt8G4unmJ0CjCxg2ZQJEpXi9Jrqo2j5Nyz7SgZlHPBBdSsxUUT11/wijzsciprnpdKLq
	U8RZgaeLDYp5+REc3EJtz/3NehDqQbSP9mgMD3A==
X-Received: by 2002:a5d:5d06:0:b0:48e:d88:55e2 with SMTP id
 ffacd0b85a97d-4958c779a6dmr4992254f8f.42.1794189438757; Sun, 08 Nov 2026
 17:57:18 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261106104842.441067-1-pkfxxxing@gmail.com> <173fb0ba5a3b968783dde74560d10bf9@manguebit.org>
In-Reply-To: <173fb0ba5a3b968783dde74560d10bf9@manguebit.org>
From: Yong Liu <pkfxxxing@gmail.com>
Date: Mon, 9 Nov 2026 09:57:07 +0800
X-Gm-Features: AclHuK-Ge004zM02tecHDLrP6fkj9vXH2gJg1fG6dEv2LWtemSwDgssoIQ6OT-Q
Message-ID: <CAGAoTxyFLVy=BiA=VVgRAGFgectEwio5yeni3rk6DWc1emKfMA@mail.gmail.com>
Subject: Re: [PATCH 0/2] smb: client: validate ACL lengths and compare encoded SIDs
To: Paulo Alcantara <pc@manguebit.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, linux-cifs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Paulo,

> Applied with MID_SID_LEN and MIN_SEC_DESC_LEN removed as there were left
> unused after patch 1/2.

Thanks for applying the series and cleaning up the unused definitions.
Thanks also to Namjae for the review.

Regards,
liuyong

Paulo Alcantara <pc@manguebit.org> =E4=BA=8E2026=E5=B9=B411=E6=9C=889=E6=97=
=A5=E5=91=A8=E4=B8=80 02:32=E5=86=99=E9=81=93=EF=BC=9A
>
> liuyong <pkfxxxing@gmail.com> writes:
>
> > Hello,
> >
> > This series fixes two memory-safety issues in the CIFS/SMB3 client,
> > reproduced on mainline commit f66469d9905b39d2c260a15d7d6db450f4db67c1:
> >
> > 1. A zero-length security-query response can bypass the caller's minimu=
m
> >    and return ZERO_SIZE_PTR, causing an Oops during an ownership change=
.
> > 2. populate_new_aces() compares variable-length SIDs over the maximum
> >    structure size, causing a KASAN out-of-bounds read during chmod.
> > ...
>
> Applied with MID_SID_LEN and MIN_SEC_DESC_LEN removed as there were left
> unused after patch 1/2.
