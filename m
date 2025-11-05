Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0999E2EFDA2
	for <linux-cifs@vger.kernel.org>; Wed,  5 Nov 2025 22:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762381214; cv=none; b=kEAfrsFdiQHxUIrX99IIdGr0GkFOXq6t2ePRXVAxblHjrEpdomZSxzSsPzzm5ja4+s9z0BwDrOjQ7MNCVGNLKhTWTYAbMVokNkIpybD9kDhxBobUvprCz7XamqWQQcGJ9IKWzW5vwHALl0TR1eMSCdogbJKh0pynLEgPJyfXtlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762381214; c=relaxed/simple;
	bh=EYKxP/O/E3xqBmODbiboV3aBEJpx7ZMxu1D3mOtTn3M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+b5U1aZudSj1rsUNEWAvM7Goh6rZVDtpjH6Ss6E8xnaMuKxBD9tdGDrXOXIbU5+AOLZYuE9/tm+VfIYRQ3zh6vGK5n8mgK94LncXjV4ihw4Bqg7geSt0G/sdZAr4Ob9YgwCyyqYCIX6/4k5+oSRZKV3p6NFSNu7+168JF8qh04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Kg26vQ7F; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Kg26vQ7F"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6271ea3a6fso194288a12.0
        for <linux-cifs@vger.kernel.org>; Wed, 05 Nov 2025 14:20:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762381201; x=1762986001; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ui2U0Ij5vkKFB7H5IIU3rlE4C90Li/F+qZfil4Xomfo=;
        b=Kg26vQ7Fw8IrfAVf/vxnizhVNu3GwZ9LPJPCBtPPlaOr3DR5yTVp/uxlLX/VY5qdkd
         +dJ4GPNTw4TRQm2NqdPS72mnPPUI3dmqrguNSDdbojGovgfyuo6bqaM6hvqkSEURAs1g
         JH79JAMFkcRK4uA3uatwOr46o2eoZMaylGA//0wl0nJiJ7LbBc/92OGjNEuwBEiOL9/4
         KoSHB5oTRZ3L0/RxiZrL6XQUR1piFw1TcTGOJVqMd2lKO+POhVriLc84tMRqM/I0BGUo
         rmXjLCvFVXT1rpjt6UhDRnWkMOwEELE3OmGq26oNyarLGUqxzF2OdU1p/Eu84kY32SY1
         q6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762381201; x=1762986001;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ui2U0Ij5vkKFB7H5IIU3rlE4C90Li/F+qZfil4Xomfo=;
        b=X3IF525aRe3vZzFliq62jNBLL5/m5RJ6RwH3yFt+3/riJ5da3NUGZqKms6uYuvxaw4
         ftU5xo2oy5GYmHwl5GY7M7qI8gud1A1nQoF8MOk8VTBx9UU4lR2qG9o3zw3dXahW5v0m
         2OYRsWV7CV1cGHPbQm+rs/i4bAc1BzZB7awdM5EE1uYj5LU3f4eYUw4ZKS9MnIg7ZsQ8
         e7O0GmUlt6zixSFQyBy0U+2e3NlmxSW7r19M9hc2YOf1HoqYHOP4t1C9FUR8eKT60NOq
         5i62cqZR3NZKEPisxrFJhUTMOAvMgw72fRG0rZs/KZ+4fRb6jKpn2xmct8qhEx/cyhxR
         yVgQ==
X-Forwarded-Encrypted: i=1; AJvYcCVQJuJfA1vUmxSJrwyDJGDiSPK1Qia5iALSQebQszXPb2GrhQS2eSrxFVkx6d41rMNdeNKzJ7l9uAKF@vger.kernel.org
X-Gm-Message-State: AOJu0YwccylewfBhla8Xg7ijOaOsv4JAhceWjDrQmDmhYa7nyqL3Qriv
	GgJFjaefckzBboEsePu26Ak+V0YmdFknIL40mlyBIjI6NeK6tHefMmrkJci2yzsvOlhvDRCWtjX
	rbkAM6gW/Dl0rW4aWQ8QIrPHYgBqFgnQ=
X-Gm-Gg: ASbGncuV0Ija5ZrgCY5fDYhshTOyreWYen2Y8ASlWoL9cc2TjcpCjtjuv0yne5fmNXf
	AuaobpDqjg4eVNFQpDa5KDhI3xhnpFAxToGEUfsqqdbZVXFj4nXrb9/tAf/DPzukONUshJck+/H
	IPBh/c7zoyDURRaFatpxRvm+cNCXNnyM2aGFEORU+sXijPLsaFXJSUJAKX8HwxpmQd6EHEZgqNt
	wsy3k6dh6impvKVa+ZHpfUx+Xesj+M/rENp3B2FccKcI/Y6B5pGqq6ZLHBG
X-Google-Smtp-Source: AGHT+IEDvGlUuVEideahYZY+ODYUe4guvkm4F0yQbQ2rOAGZccJElktFd+64A9TEF3O1cn/fjQ78uoSBDOooxDIQsAU=
X-Received: by 2002:a17:902:db05:b0:295:6850:a389 with SMTP id
 d9443c01a7336-2962ad2b2c3mr69533935ad.20.1762381201200; Wed, 05 Nov 2025
 14:20:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <20251103184145.17b23780@kernel.org>
In-Reply-To: <20251103184145.17b23780@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 5 Nov 2025 17:19:49 -0500
X-Gm-Features: AWmQ_bk5zH6aZ8eA6Di6ajFu_oTzlSNpD7ldH11olJifIEsUkj_P9OR2FBRf4E0
Message-ID: <CADvbK_fdph6C5+nnUix2259TQb9-vBVEPOxMpzzpEy5xhR-xTA@mail.gmail.com>
Subject: Re: [PATCH net-next v4 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring <aahringo@redhat.com>, 
	David Howells <dhowells@redhat.com>, Matthieu Baerts <matttbe@kernel.org>, 
	John Ericson <mail@johnericson.me>, Cong Wang <xiyou.wangcong@gmail.com>, 
	"D . Wythe" <alibuda@linux.alibaba.com>, Jason Baron <jbaron@akamai.com>, 
	illiliti <illiliti@protonmail.com>, Sabrina Dubroca <sd@queasysnail.net>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, 
	Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 3, 2025 at 9:41=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Wed, 29 Oct 2025 10:35:42 -0400 Xin Long wrote:
> >  net/Kconfig               |    1 +
> >  net/Makefile              |    1 +
>
> Haven't gotten to reviewing yet myself, hopefully Paolo will find time
> tomorrow. But you're definitely missing a MAINTAINERS entry...

I was planning to add the MAINTAINERS entry in the second patchset,
since that patch will introduce Documentation/networking/quic.rst,
which should be listed in the entry as:

F:      Documentation/networking/quic.rst

I guess it should be fine to add the MAINTAINERS entry now without
this F: line in the current patchset, and then update it in the second
patchset once the file exists.

Thanks.
