Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A214E17A2F6
	for <linux-cifs@vger.kernel.org>; Wed,  6 Aug 2025 20:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754511677; cv=none; b=ca5wwdRdmZ+NDhpnKNLyhf6oD2h9EUB6tU7ps+cw1KfvuutSrWAYKY78j4qKkoz8ezHI28PHZTZiZ6wVlEkSgnRi3LGJwqeV2KEdOSdTE+tMHozyaISFEzcPLWrC+Gvf8BPm0txv42yQoa0xC7VujIfNnxQQ95EoMvzxqmPvnqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754511677; c=relaxed/simple;
	bh=NCnEOM0+5At4zWpEFedTLOu1MHRKHpFFfcTf/i7KYZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gt73MZqPoiWTtynOpzmnskLQCrM11s2T8B/qud1nwXkzzg33VK1G+tpHSl9UYj4041k88LUW2pXw3Lp057DOwIUfvO3gQA12/l95c4TSk82MSTbnAeWUml98naCuRG+7ORrMqnfaMFF3yhGIe4mH/P9QHdToMI9HkUe1xFF5ePE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NuaVbVKv; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NuaVbVKv"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b0a27ebf01so629481cf.1
        for <linux-cifs@vger.kernel.org>; Wed, 06 Aug 2025 13:21:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754511674; x=1755116474; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCnEOM0+5At4zWpEFedTLOu1MHRKHpFFfcTf/i7KYZo=;
        b=NuaVbVKvOV8cJwzI2IIOxrXx08TcO8BRN0yEkxlOd4HxJw+vJiGPTqwCnQTwkMPxir
         ppDGyML/3hB6PLxaJ0KDPQYA7F6CWRDdBNRJaC3T1PtJFovme4u4O9PDb1c4jHg7O6hy
         cjljowMKL8PexvvwwHHpzzSrQINyDBDFYo4rRb0a9zgAaPOCmj/+htwDgYsxfailpI6U
         SvksVozZote4Vr8+X9MjWswWX6AbbbdY280xe3ZYs1BSa63OFdxt0ge34H35FOREx8/1
         fxJOG9ZtW9Wxr22v5SHrf1aMHSdiuBlC+GIbZ5IYFvS6lhOxFI4MSXWL8SnIdi4fXzxk
         qs2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754511674; x=1755116474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NCnEOM0+5At4zWpEFedTLOu1MHRKHpFFfcTf/i7KYZo=;
        b=BnWpLP+fATUmwCiUG7vLXFcTAaP6uVeUfI7hozagpdgLzOYYlCz2DlGkBy5IFmWnn2
         oJD8GiSaXqYw9PEfMvErD34+5VZCIYBW9gQHsAd5xFlTlA/LVjdoZCk627eTqpBS+aOj
         yYTfBc2/8hduVsxCJDHS/js2f+9irkYkKBwaPbjIFjgoXhmiTsvjmrupTS8Z9dtP13xA
         bzgEGnQEQ1MYhh5xxa/JNfE5jk5lz2BfmK2ObKOw7XJ+yduV8qVnauoaaDvcETuguA0H
         eGZ9x7WMstz3DtJysoxfZh57wuV0W79ILVO135oy2C4FjR4aKFdcSzMcWt0tsDw6l1J2
         E0yg==
X-Gm-Message-State: AOJu0YzO01Lvska7c05P7zRX6JxPMaCsBXGZF7G48S2Jy3Rqwpqbyytd
	79I5K5ivGfm4MIHiU7qit72g6xTZhxJhE5gQuAkx8eoaxLfXqnbYirxrrCCv0Brox4rhMTyReSq
	4bT0x7n4SFXwnORgmyTIylgnWWtmj0dM=
X-Gm-Gg: ASbGncuLnT9BqrneOCbjAT8pm3hS8N4ip4pX89Z1oB24BQwn9OqKyzGwtuWRaPYj0Yd
	qXO37aRngmpOx5sPm/aq0xXEGtwcOWapAVvTpr+/thHNJ995a0EXHQ4YAWVzYZ3fZUdFUYndDHO
	EyfNmVKyGak5KobQOqLi8Hdydit3S66tEbMJ39jiPHeJiLUf92LtXmfAsmxGeQiO8koyt6aMuP7
	+KCGTHxmlMFnLLfogzQXvl63nNaRcPBZNVDltHANJbXJz0dPCA=
X-Google-Smtp-Source: AGHT+IH74oSmXJN1vofJGgPM/smKCxkF5pCCuVjuK0ayvaD/rAmmqEZaUQucXDsYmV7mwckOU46nQB8cigZPNwsJWX4=
X-Received: by 2002:ac8:5a15:0:b0:4b0:80c7:ba33 with SMTP id
 d75a77b69052e-4b09258d4e2mr56214831cf.23.1754511674272; Wed, 06 Aug 2025
 13:21:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1754501401.git.metze@samba.org> <ea27f558-ab35-4607-b8a3-480c9ca4c6c3@samba.org>
In-Reply-To: <ea27f558-ab35-4607-b8a3-480c9ca4c6c3@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 6 Aug 2025 15:21:02 -0500
X-Gm-Features: Ac12FXwaSxmlyy1mfEowDl7JvrjiWa5felRtPiCuaGMIWybZymabvA0dGPYSW1g
Message-ID: <CAH2r5mvA7CWGR0cDn0DrxvMXdcmcJru1nOKPr1FD=rANPyYTHA@mail.gmail.com>
Subject: Re: [PATCH 00/18] smb: smbdirect: more use of common structures e.g. smbdirect_send_io
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org, 
	Tom Talpey <tom@talpey.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

tentatively merged those 7 additional small patches into cifs-2.6.git
for-next pending more review and testing.

On Wed, Aug 6, 2025 at 12:41=E2=80=AFPM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 06.08.25 um 19:35 schrieb Stefan Metzmacher via samba-technical:
> > Hi,
> >
> > this is the next step towards a common smbdirect layer
> > between cifs.ko and ksmbd.ko, with the aim to provide
> > a socket layer for userspace usage at the end of the road.
> >
> > This patchset focuses on the usage of a common
> > smbdirect_send_io and related structures in smbdirect_socket.send_io.
> >
> > Note only patches 01-08 are intended to be merged soon,
>
> Sorry it's just 01-07.
>
> metze



--=20
Thanks,

Steve
