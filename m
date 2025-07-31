Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2361917C224
	for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 16:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753978707; cv=none; b=eF360qb4r5Cm159chUi9xUNt9yMP5gokzyh9imTxBQiNbpcIGMvlF0ecwRrjhlyXwl38/hJNUHefC2DDFLY2AEXZvm1cRKjET+42AqjIZf8li6g/k0nc+stUSh97wSi2IB4hHBMumyaBzw8zD3PTK3Ws0GZggrpZn1UqiiYzmPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753978707; c=relaxed/simple;
	bh=G0qVdSywTL+lfp2NzNsyOmKHe1inY9Ubs0IiOXsNUNo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+5JFfJlJXI13P/SEqCfD8r+9Np79QsvW9QSCYgc9lSBDirb05i0nGl0XB2ldy1pAZ4h9L1yJSefi/Pi2KenHt6j9a9UJ0ba5NEfmeVpqXZPhBJoaIlXTaMCX3xuiSEjzl25OKI4aKjZ2b9CMicIfa5mbcEszjfgisuznBmQ6JI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y+uNTLcr; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y+uNTLcr"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-553dceb342fso970012e87.0
        for <linux-cifs@vger.kernel.org>; Thu, 31 Jul 2025 09:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753978704; x=1754583504; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JicYDidHVnWa+Bgz/jo2LCit/terQuQLk41zzG3pSI0=;
        b=Y+uNTLcryxLlavbCQNdemDYYq4cmQpmU8r+adTpGt9RjNp/v4MKDw2HSBvniZcRLTh
         WKxYUvRjBdP/QMQ7InckaVVEBvQ8IRPE2NlHyrLwrqieAWhiRTMq3Sy+qAYelRjIFuU3
         1YFzfIScZzIfYkYmpTx2IvWnc3Hs44BuCEXDX2ecIOUaYzuLGKS6+SZkuWf14nnjGYNN
         6S+TlMNSgA06YfLqLVUcmFygCe1HVtIqKQ8/qyq/sublAMW6HQu6x/xqh8QOnZZ+LnRH
         zudO5pW3PwKoutJjTV5fxhtdxhAeTJConXAQwHJa2aAMgIf+AuA9poxfk/RpvPd7GkRm
         5/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753978704; x=1754583504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JicYDidHVnWa+Bgz/jo2LCit/terQuQLk41zzG3pSI0=;
        b=ppeCnyaQMpFU54HiMaIrv8vERJaXBoHYDU9eKpFjKh2nWqp1epKOK9xTwtNaksQzGp
         1ih9sFsEDVgE4+whs1Y2I78oDKIpAdJyIj+h5BCLWXyR5MEjL3pi1IZ3PHJT+OFdyWQ2
         V4KZAZX/mTVrZ1XKd9y+bMsVxsZm4L2yqMd1mxJpzpnQfYRBZ0w5M2gDujORoi9HHFr9
         1nR1FRNfCYteR1YNzpepg0xSrU+mV08smVVjngRoXaUwkiRCK43NY2WtQDz4cGq16YTB
         fVlRpsF7dOJPXYt1T0sUHxAoGPkNITbJqWDXXm+8ZePF5QGzEj3Ys5iBuYVJ7S/OVjV+
         w92Q==
X-Forwarded-Encrypted: i=1; AJvYcCXopInSEFjdiF2MuGPtOtUfo/f4n7c/l7B+gu6iynrU/fCerV2nKlIFeSgfNRxcODr630bwslyuUQ2a@vger.kernel.org
X-Gm-Message-State: AOJu0Ywc2ZdfXOontnYHTkdVwJ3Ll87tWYq5esqZwk60rUyEYHqbGI/P
	ZONHjTxmz22iytUDVWXb9pJmTahcmrbI20CZmnd34+Vc+7rGhrwmby4lbIobCZBxs442LYlT+Dn
	ALrrYIZFGfJXkXFk5ZI0hjOJbC2m7SPA=
X-Gm-Gg: ASbGncuWFiZqxFm12GEivrWwElbtHBzQwApCoNyZXesnj8aOgDzymVdBt+nS/crc25J
	elGn0hHUPqfUH0XmMAI3e1Byxc66VqvBU5dYXaFzwWI0LveD6DH2Xxy7bbUHRfN1GX5RNa+J/9y
	HGomjaaMuVaz0ZpO+EqG7tCMNxLQgpDaX95hJ6zVsjpS+77xZteyK5hx4s+JBsIzu6w2zKU58lZ
	+oHrJszKK2e97qm20Hx6NuSQ/MA3WrnAPZ9+V49nw==
X-Google-Smtp-Source: AGHT+IHzzLqJEhBklcPRTua2tqlK7egq3muOS+C8l8La1E7KoJWedntVmdBw+XpN4TwJYGGvxHlid3BVgD94ocN3M38=
X-Received: by 2002:a05:6512:118e:b0:553:a740:18aa with SMTP id
 2adb3069b0e04-55b7c03107dmr2404913e87.22.1753978703997; Thu, 31 Jul 2025
 09:18:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk>
 <7082aea3-b28b-4ef5-9b5c-64d5d8b78cbc@samba.org> <a4a32c8e-3b7f-4748-8c50-48f18e8980b9@ed.ac.uk>
 <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
In-Reply-To: <45403dd0-b481-431b-8641-234978e48b1b@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Thu, 31 Jul 2025 11:18:10 -0500
X-Gm-Features: Ac12FXxCqNHRLcd0Jrr2ZkOxIgx0XN65TU-zeE0FcSU3VuzmzKRqes7qh5fVMLI
Message-ID: <CAH2r5msM-QcEk3YUOAnfaeH7w_S6tDVcFBD3VGOspVmN=eWGWQ@mail.gmail.com>
Subject: Re: [Samba] SMB3 Unix Extensions - creating special files
To: Ralph Boehme <slow@samba.org>
Cc: Matthew Richardson <m.richardson@ed.ac.uk>, samba@lists.samba.org, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I will check on this - but looks like the client was running 6.15, so
want to check if there were any fixes in current mainline, 6.16
kernel, which could relate to this.

On Thu, Jul 31, 2025 at 11:12=E2=80=AFAM Ralph Boehme <slow@samba.org> wrot=
e:
>
> ...adding linux-cifs and Steve to the loop....
>
> Looks to be a client issue: the client is checking for existence of the
> targets, the server returns ENOENT and then that's it. There no attempt
> to create either a symlink nor the fifo as reparse points.
>
> @Steve: any idea of what could be going wrong? Iirc this is supposed to
> be working in the client.
>
> -slow
>
> On 7/30/25 2:31 PM, Matthew Richardson wrote:
> > Hi,
> >
> > I've created a few network traces which will hopefully help. Each one
> > contains the initial mount command, followed by a single command.
> > They're hosted here:
> >
> > https://filebin.net/zvdx07i2m3lta129
> >
> > Working:
> >
> > samba_stat_symlink.pcap =3D stat /mnt/sym_a_local
> >
> > Not working:
> >
> > samba_ln_s.pcap =3D ln -s /mnt/a.txt /mnt/a.symlink
> >
> > samba_mkfifo.pcap =3D mkfifo /mnt/fifo_new
> >
> > Hopefully that will give some idea about what's happening  but let me
> > know if you need any other traces or debug info.
> >
> > Thanks,
> >
> > Matthew
> >
> >
> > On 29/07/2025 18:22, Ralph Boehme wrote:
> >> Hi Matthew,
> >>
> >> as a starting point: can you send us a network trace of this?
> >>
> >> Iirc the mailing list server is not particularily fond of
> >> attachements, so either put it somewhere to grab it or file a Samba
> >> bug and attach it there.
> >>
> >> Cheers!
> >> -slow
> >>
> >
>


--=20
Thanks,

Steve
