Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED694353346
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 16:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757608821; cv=none; b=AoIurLhD5MuPrul/37RrpuhH3BIah1pUmlXJ8pZ7m/BICvTvyqicKwHXekQBxqJvsk6IOebRuGLMqs873WoLbN74r/+JuchcGztUCEXKHq3ZDtiiEn9qJw4OYN3AKNk9CrmbXnqqY93gfk7t4g3xbbiaN0WPQfPDhuEgPscUoKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757608821; c=relaxed/simple;
	bh=4ptE1HdEYZJ87Rnaz0ymcyIVVGf1FGSlsP1ngz6xHrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=V8f6s0hhjCR60gGAFDkc7lmKY9vXejTAkrbVU0MWRx22IObJkJqgGq/GFq0dlZwqve0nhfO6wVtEB6gS66FQpYt4fVz0yyIxPECod1pBnSPNdFhpk4uHcu8HwWPetor/uuck3qYjXV1BO+L2bVZFhgd2gHTqDDypJCSxmgEUzxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGCyeDaW; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGCyeDaW"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-71b9d805f2fso8744866d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 09:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757608819; x=1758213619; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8CEuhmT2TGRh90Y0SMjWcHVE+X24aGylacLLctg9AQs=;
        b=dGCyeDaWgdPIt8lb8C3Xgadpx1Ky0Hf7AlWVyuqHAq3wSPiuiUuoCALXjcJoAylLk3
         GUwS9XFsypR+yOMsvdFa8gmvkS6eoM3lmGYpYR7+eVvenjhZwTz9APW1EBl4nMdk2LJJ
         Tg6u/Gozqy3IZ2IZ0pSD8tWbYHGBPpKlCWz1DJSrEz+9CHMLXRGczG2B+ZZHeomq2shd
         N28F2bTnIus2ppCI3VuDVa0O98PdofMY4lCZNDhn/cezVEZBBLW6ScgRaX+1WGrZs5Ur
         CTI/gtt34ofWcJOGSl/vancoAPV7j7/xEIC4Y22LnC0fetSrDTVaXztZl62bDki/2TuD
         HwqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757608819; x=1758213619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8CEuhmT2TGRh90Y0SMjWcHVE+X24aGylacLLctg9AQs=;
        b=T9ox1MbNXB6plJuv2AC0tqT00YMtTpF35SCQEdSfOnGmKtiNExOdk7R+k4Yb5nxsRv
         WATlpUdWxSkjAecOO8Ap9LWcUMXf2zP7DMkjBYo70EmptsP4yI1I4n0zwZT4w8s5Vpjm
         hWp4rmMPV+dTAIRSCTej6K6ZHnxQz36gM7mjSgtVnq9HJc+Ancu+CuhkAKm+sKQ+E2l0
         Rf9zR/e8HKI3KxhRGgtZJdX5ioJavzReq96lReIuBwU0wWlNO8r/vg+58Q+4a3507O5h
         6J18LAt87TRhLZ1EwDUarssrq7ABOk7S1Pl5/jeTOEN9Ox6wivODlTuk4u1/v+ybn5BU
         xiUA==
X-Forwarded-Encrypted: i=1; AJvYcCU7FtT7vOwI/kaaMWR8XgvKxWiRju1xLC4a9lnDRbyY9Zab+ZKhPN26+tnpZNn9U0z4P/j+8nJ9xUQ3@vger.kernel.org
X-Gm-Message-State: AOJu0YxZRgB+E0YeOpWm69UIvE9B+dHFy637kULziuk/owNrxc8yFsvk
	TL+JZpBwKCRM2MIRQc5PLoxLp403De7lj7ZzX8VqtRg33xkGji1aAe+MIbxpX2R+MTD+JLexsg8
	k7cIEMUPAcV/U1OuZQqWsW5qtaA+cjnE=
X-Gm-Gg: ASbGnctVeFCIjTxNkLa4l3IDGtgBSPyydKhCFMBVO0eCbjVXDj8yjm/zuBZoVb61Sxm
	Nknc20gL8K5Z6RXpk14aP0X/lf4iGhppJ0r7RrmGQ8G5GKuQYfimoZbANDdD/5kDjQOJNM7lzck
	bHuhDUL/mhL+76sCWg/2715/xRIm6fxDCHBYcF40F6DgAjH++MSY7r3S8SzBuxCU4eFrcywJu98
	IHk0jhbn/0OnNV+d4SvsprUaL2U97qypNHW6zrWTvgZAFA2sz/fJGZCSmh0hbJjlGTTTjSpFPcN
	myz2/lVmW4obbjjOcs00mfh+MTy038jOz9TNam1lfFCQQ/5wat8r5gi9/7gsaH9j8ywu3tLc/PM
	y
X-Google-Smtp-Source: AGHT+IEAtsGZFrgDNY+c9vGU+p/qVoy7EW/SoKlNux3P9BX3cE2kZ3I7YEdflt0WDHN8qbekyDOqEe2WxwQwtiTvn1E=
X-Received: by 2002:a05:6214:2a4b:b0:70f:a780:4f0c with SMTP id
 6a1803df08f44-767ba27936dmr287596d6.5.1757608818669; Thu, 11 Sep 2025
 09:40:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911030120.1076413-1-yangerkun@huawei.com>
 <2780505c-b531-7731-3c3d-910a22bf0802@huawei.com> <2025091109-happiness-cussed-d869@gregkh>
 <ff670765-d3e2-bc0a-5cef-c18757fe3ee0@huawei.com> <2025091157-imply-dugout-3b39@gregkh>
In-Reply-To: <2025091157-imply-dugout-3b39@gregkh>
From: Steve French <smfrench@gmail.com>
Date: Thu, 11 Sep 2025 11:40:08 -0500
X-Gm-Features: AS18NWCewpWCSHfzBtSTHTp1RP1-tK66_C66H-R8_RBjpUv1KeGAJtEDwSkTTDk
Message-ID: <CAH2r5msDcEnbkGT3y7--Dbk5pWWyTnDg2PLO_R4WderLfC9Nnw@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: fix pagecache leak when do writepages
To: Greg KH <gregkh@linuxfoundation.org>
Cc: yangerkun <yangerkun@huawei.com>, sfrench@samba.org, pc@manguebit.com, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	dhowells@redhat.com, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, stable@kernel.org, nspmangalore@gmail.com, 
	ematsumiya@suse.de, yangerkun@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

David and I discussed this today and this patch is MUCH safer than
backporting the later (6.10) netfs changes which would be much larger
and riskier to include (and presumably could affect code outside
cifs.ko as well where this patch is narrowly targeted).

I am fine with this patch.from Yang for 6.6 stable


On Thu, Sep 11, 2025 at 6:45=E2=80=AFAM Greg KH <gregkh@linuxfoundation.org=
> wrote:
>
> On Thu, Sep 11, 2025 at 07:09:30PM +0800, yangerkun wrote:
> >
> >
> > =E5=9C=A8 2025/9/11 18:53, Greg KH =E5=86=99=E9=81=93:
> > > On Thu, Sep 11, 2025 at 11:22:57AM +0800, yangerkun wrote:
> > > > Hello,
> > > >
> > > > In stable version 6.6, IO operations for CIFS cause system memory l=
eaks
> > > > shortly after starting; our test case triggers this issue, and othe=
r users
> > > > have reported it as well [1].
> > > >
> > > > This problem does not occur in the mainline kernel after commit 3ee=
1a1fc3981
> > > > ("cifs: Cut over to using netfslib") (v6.10-rc1), but backporting t=
his fix
> > > > to stable versions 6.6 through 6.9 is challenging. Therefore, I hav=
e decided
> > > > to address the issue with a separate patch.
> > > >
> > > > Hi Greg,
> > > >
> > > > I have reviewed [2] to understand the process for submitting patche=
s to
> > > > stable branches. However, this patch may not fit their criteria sin=
ce it is
> > > > not a backport from mainline. Is there anything else I should do to=
 make
> > > > this patch appear more formal?
> > >
> > > Yes, please include the info as to why this is not a backport from
> > > upstream, and why it can only go into this one specific tree and get =
the
> > > developers involved to agree with this.
> >
> > Alright, the reason I favor this single patch is that the mainline solu=
tion
> > involves a major refactor [1] to change the I/O path to netfslib.
> > Backporting it would cause many conflicts, and such a large patch set w=
ould
> > introduce numerous KABI changes. Therefore, this single patch is provid=
ed
> > here instead...
>
> There is no stable kernel api, sorry, that is not a valid reason.  And
> we've taken large patch sets in the past.
>
> But if you can get the maintainers of the code to agree that this is the
> best solution, we'll be glad to take it.
>
> thanks,
>
> greg k-h
>


--=20
Thanks,

Steve
