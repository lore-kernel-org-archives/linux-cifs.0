Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D045DDC1
	for <linux-cifs@vger.kernel.org>; Tue, 21 Jan 2025 05:45:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737438333; cv=none; b=FjHBN/jgzLOuoDBqxtV7l2Tc5XStMwBySMcrPynEoHFZPojbz2BTINjg6/bOlQSPrEQhOqZ65nktGKE2V7LnYG6hMYeht6DIvzVlIxFnxuJn4im3HUjBwwRoI8ajwXe/8Dx1OzoD1v8++tVinUVE8DWkMbXxeJbIXNTFl/jEXrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737438333; c=relaxed/simple;
	bh=1emtGIJjsXXT4jXkcQoW5DktvPVbnE323nc2yWXIp18=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aGGt656q0L+oASUgiMArm468qvBnJ0Wa8i7XcVRkBf/JfsWuciXAvACBEJPdTOnJ1icjrjz8EKY7RymJbgOtYb6FkOm4w0hAPFPxhiPJZLiDrmXUjnk8y3fgRkd0kPeGolP057ljV6s8ZSmhI5HJNAXIKNJiSJbmHNA8ltWZFWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IW4H/JJm; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IW4H/JJm"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5401c52000dso5574773e87.3
        for <linux-cifs@vger.kernel.org>; Mon, 20 Jan 2025 21:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737438330; x=1738043130; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1emtGIJjsXXT4jXkcQoW5DktvPVbnE323nc2yWXIp18=;
        b=IW4H/JJm3AoGfynLrQnXbn7XwGHMKnQ/OmNn0aymaqvtLSLqD2V6Vwp9iRphCYsHDp
         mrB1hSfo7H4OHZpLiFwNvTSdTfp9FQNY4bYBFOxHI0+psoUAuTNZPmpVGCFPIW3OYkQJ
         GkO0PN0zIexuTSpJWsI6Aq3+m/8yxCY0VZrug9f4BHTL5Rs7gPgG2aqvuKrXKxLSXcN8
         0SY6GMIoUjWC3ZApaclF9O7tmBXfVtAL2cSYnGOsm6rE8NNA8ibRzCwufr1WvTueW0E/
         8OaBnOWXi7R33QUJE2vtZW9STdzV7pLzf/Xjh5ZFnYQQ7yTzcJTvOlI9tfsjM/T8kRyL
         Kfuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737438330; x=1738043130;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1emtGIJjsXXT4jXkcQoW5DktvPVbnE323nc2yWXIp18=;
        b=FMmpRN1CX8ekNarTu+gUyw8uU8X5r4hilWzowaYyaQll/J2cib+Hk6k4ecYkZHoU8l
         MsIq03I8UfPr80q2aAD3ABk2wPRSuyYAgEXUYnlY3m2wiFvz45AWBoikpcb4Benf64XG
         Sg0/GQQ2p9xP2aIUGPAprB/RiVkm4wEmDviZl2+C999xypzjsA9OlLUP+3FFX2Fa1mUd
         bk3kcVH+WAI2NMJO9MCL7DR10P5F7EznDY4lHwpHW0roydQxDaGedBt8ZrM4P4vp7S98
         TOf/Rh9tQZoNkZbX5IxMXlY51PEOTIhQ9uZJ21jtY8/3emZm8jAEzVwBIT3+RhYQHNqt
         twdg==
X-Gm-Message-State: AOJu0YyYqqUJN7V40ryJWF/G185VCP4mD8idI1YFsBA+nG4KGjoWPsLn
	89D1ezqIEM5ZKWPMym8YCo+ias0fz2l2C49P/aQziS+l8VhblsJ9cYMX7j08R68P7uiCBRaw1ES
	Qzpa21y5OB6DbI5G6xScl5KE+PH4wwg==
X-Gm-Gg: ASbGncvhSA/AAhTiXpbqjjw+zrHe5c7WmRI5KAYsWh8N1itN9/3dFzFmOBn83FgSkRV
	U2T7vxlaOCjGSWtHEEkY3zneutSQsbhRqFlilUeA62Hl/FqjxJrE=
X-Google-Smtp-Source: AGHT+IHzjonUFdcFdFs7Rl8BrB9pAE24eGvGf8jYAqqe6SSNXkzwA+0MojiSNZZAsrSa2p4Whub77pw2XBn4po/0euw=
X-Received: by 2002:a05:6512:24d:b0:53e:39c2:f026 with SMTP id
 2adb3069b0e04-5439c229109mr4072679e87.14.1737438329959; Mon, 20 Jan 2025
 21:45:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5msUp2xqY062MRRXkNApwekZ_CJYL3q_J0boGFPzw4W1LQ@mail.gmail.com>
 <20250120175449.5i2a3bdd7xk2xjm3@pali>
In-Reply-To: <20250120175449.5i2a3bdd7xk2xjm3@pali>
From: Steve French <smfrench@gmail.com>
Date: Mon, 20 Jan 2025 23:45:18 -0600
X-Gm-Features: AbW1kvZqljgd4pIQw24dylfsEMyMfhxrmJaTSUiETe2mIw0Wanm6vQ9uOQERsdM
Message-ID: <CAH2r5mtA4Xr-tkNgjLpGqbOn60Rms2=52AfrLG-F6RwqVJfbsg@mail.gmail.com>
Subject: Re: [PATCH] cifs: Fix printing Status code into dmesg
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 20, 2025 at 11:55=E2=80=AFAM Pali Roh=C3=A1r <pali@kernel.org> =
wrote:
>
> Just to note that I have sent this patch in series with "cifs: Add
> missing NT_STATUS_* codes from nterr.h to nterr.c" patch which is adding
> also NT_STATUS_STOPPED_ON_SYMLINK (mentioned in commit message):
>
> https://lore.kernel.org/linux-cifs/20241227173709.22892-1-pali@kernel.org=
/t/#u

Both of these are in for-next

> On Sunday 19 January 2025 19:48:39 Steve French wrote:
> > Any thoughts on the attached patch (which is tentatively in
> > cifs-2.6.git for-next)?
> >
> > NT Status code is 32-bit number, so for comparing two NT Status codes i=
s
> > needed to check all 32 bits, and not just low 24 bits.
> >
> > Before this change kernel printed message:
> > "Status code returned 0x8000002d NT_STATUS_NOT_COMMITTED"
> >
> > It was incorrect as because NT_STATUS_NOT_COMMITTED is defined as
> > 0xC000002d and 0x8000002d has defined name NT_STATUS_STOPPED_ON_SYMLINK=
.
> >
> > With this change kernel prints message:
> > "Status code returned 0x8000002d NT_STATUS_STOPPED_ON_SYMLINK"
> >
> > Signed-off-by: Pali Roh=C3=A1r <pali@kernel.org>
> >
> >
> > --
> > Thanks,
> >
> > Steve



--=20
Thanks,

Steve
