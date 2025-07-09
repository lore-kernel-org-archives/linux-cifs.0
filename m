Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41E8224227;
	Wed,  9 Jul 2025 17:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752080754; cv=none; b=LIlTMDAp6ldE02CoZnMVfPrtKNXawCluSfhDH7pZjm3FN9jEqqb/JYqmKFLY5opciIzmO0/JjgAQDn6gYEVqpgIldbq6v0J0bE3VwM6PD9EvJVpPRIxXeRaJ54IxylJkAMbGcqbulbmKbJUkv1wD82pr9xayub4XYapG9mZI7Xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752080754; c=relaxed/simple;
	bh=cFmMmbNOZ2lQJhyooZRxqPMgpHehUky7qeBgN96eCfc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sNs3tRG2cP4FwP2aB2fv4KOgI5RVQ41v5LnqT06ZiXT/EMoFjyFgXvT8ozGYzyQrViMOWPoCLm4JyRz+ILGJ8KafL/WZ/A0HzOGXb7S8P2c76hHaFVuMXGs7dm6KCLJqtkIivSn5/TkaEdRsVcCg8uB19LJqovl47R6dwOXXDa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V892Zdg8; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V892Zdg8"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3e05c718bedso611565ab.0;
        Wed, 09 Jul 2025 10:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752080752; x=1752685552; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGs7uOkUqSiWd98cc20bhkdpAwjdYLKrg86sS4UNbPk=;
        b=V892Zdg8fsjyI89B0xMvGLjV18vVU9AvWE+4hFA3XhUI/+c9d6QsnUNp0fw7d3L1mb
         Ita4u48xGVkJg5UJRpZzG97DG2FIlOh1/zIIl/jziqPfHC7vnf7WyScs1aFYifAE5jCi
         +Fb251l4pCPhFJmHMdmTgsMZeREa5Z/yeeREyhhVmLKRHfDbDBEGzDdY8C/D2Q8JDjAV
         gjOC5Wi16mRe6K/T55ivuNxGtZzm5be7cGUzj1qsSG+6FcgwoTcrH2bUK/2Kxmn6ZUcj
         jTmGkI5L35GhNRKoohd/gUyYpeGgamOLWwmugmFcTLD2aC5resbE3adpS3M1Ju6UQ019
         +DqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752080752; x=1752685552;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGs7uOkUqSiWd98cc20bhkdpAwjdYLKrg86sS4UNbPk=;
        b=Mvo4vHiqIG3NsO28Kw1IPhspoeuUsXV2R5aVHJgL2zwVzblQ4XLepam3E7YdfLvp04
         dbcCdL7OY0BuZiDpxu0Fs0HjH7T1yXXtlocQeXRqujZzH0Xr4dtYe9gSAe5mhdC2pYQG
         kdDHwGV7FI07X7e1O8FdZ0fYj+YKTyhW/+l6hCf+VE4O8i0Coh4WV0rpXXJcZmHJxwOf
         7r1aj2eN1+7YHhe6eJ3RhiWALbnxRR+qcAWzmMIatpeBKOBxDS+ML+Ad4OvhQVpkfxCq
         hV2lvfuyoOkLKKYcl8T/4LxQnIkywZp+A2fY9CfrWyt2xZ/ffaU+hnU5k8/aNoJ24Fsi
         SszA==
X-Forwarded-Encrypted: i=1; AJvYcCUb1GwvxkCeYL47T9uHin8zTBF94IZ9X5JzAxVDquFPfOBm9a1KHY8+jON9yAwyEXQOqa7jjzNiLP4Z@vger.kernel.org
X-Gm-Message-State: AOJu0YxdOy+JlkMKcsRLAUgIna3ug3/mYHHEwJ4yw9OAysDgORkNLsMn
	+3Z2VbsIbyu9h4xhwtUGSKWiQVnqRItxQiwkGuFle/ezCePdRnFJnWA50VJiTKRuEh25t3Q5rE0
	uG3nnIqnbxR0IV6qGr5xf7tc82a9qqYQ=
X-Gm-Gg: ASbGncs8Wvd2kpuz6Rshxu9gJaGIybdENuzenU3UGTpYC+RQVfgd5jdiP/Hs8t/cpgx
	eK1wvly1eYriMalvM/4DaWrp7anLGMgivOby8W8qN12umpWWq+WuISrv70xrJm4hWNfy/8mVQOq
	2CUhyxtvwRwEs59yZeIQX4MmI0CHSheddtzPj0ArkLfq90y8pql+CNq/6zTDr3UhbO83yY7rleC
	t8eCQ==
X-Google-Smtp-Source: AGHT+IHkC8eqHXDge3FF4Xvot2aMbjbR7sKK8tVlJ313IzZe9U21AnU/z/HqEzLBntqyUltgr5L5GDqFvSXbBSlJJjc=
X-Received: by 2002:a05:6e02:744:b0:3d6:cbad:235c with SMTP id
 e9e14a558f8ab-3e243f93c4amr7234935ab.6.1752080751927; Wed, 09 Jul 2025
 10:05:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1751743914.git.lucien.xin@gmail.com> <74b62316e4a265bf2e5c0b3cf7061b4a6fde68b1.1751743914.git.lucien.xin@gmail.com>
 <2641256.1751992436@warthog.procyon.org.uk>
In-Reply-To: <2641256.1751992436@warthog.procyon.org.uk>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 9 Jul 2025 13:05:40 -0400
X-Gm-Features: Ac12FXw-Gy78wqwOzpg95VzRYPTCTxXs-MQSS5qJzV_rAfy_j3TuOneN8vlxOwI
Message-ID: <CADvbK_dDbzdxdfZT43M17hG6TKFfoQZ+YuZGR6q6E5s7eRUr4A@mail.gmail.com>
Subject: Re: [PATCH net-next 05/15] quic: provide quic.h header files for
 kernel and userspace
To: David Howells <dhowells@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net, kuba@kernel.org, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 8, 2025 at 12:34=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > +#ifndef __uapi_quic_h__
> > +#define __uapi_quic_h__
>
> I think capital letters are preferred for system headers, e.g.:
> _UAPI_LINUX_QUIC_H.
>
Looks better, will update.

> > +enum quic_crypto_level {
> > +     QUIC_CRYPTO_APP,
> > +     QUIC_CRYPTO_INITIAL,
> > +     QUIC_CRYPTO_HANDSHAKE,
> > +     QUIC_CRYPTO_EARLY,
> > +     QUIC_CRYPTO_MAX,
> > +};
>
> I would recommend that you assign explicit values to enums in uapi header=
s to
> avoid accidental changes if someone tries inserting in the middle of the =
list.
>
That doesn't sound like an easy mistake to make. Assigning explicit values
to zero-based, continuous enums isn=E2=80=99t commonly seen in other header=
 files
either.

But I will make such a change for QUIC_TRANSPORT_ enums, as their values
are actually defined in:
https://datatracker.ietf.org/doc/html/rfc9000#section-20.1

> > +struct quic_transport_param {
> > +     uint8_t         remote;
> > +     uint8_t         disable_active_migration;
> > +     uint8_t         grease_quic_bit;
>
> I believe use of __u8, __u16, __s32 and similar is preferred to uint8_t,
> uint16_t, int32_t, etc. in UAPI headers.
>
Make sense, will update.

Thanks for the suggestions.

> > +enum {
> > +     QUIC_TRANSPORT_ERROR_NONE,
> > +     QUIC_TRANSPORT_ERROR_INTERNAL,
> > +     QUIC_TRANSPORT_ERROR_CONNECTION_REFUSED,
>
> Again, recommend assigning actual values.
>
> David
>
