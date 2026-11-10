Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794331233;
	b=j10EeYtMy9scygOgi7EALKKweAdWVgoKhoExang4dDOcrGtqlpkNxQeSazXuSB+M3csC
	 kIp7pCORODK1BYULx19N5GdvyIaeeSeopJm/tDq4qp1Zzmlip5P0vZkjE7tq2pfc3E9i3
	 K29nxgvT+WLMl7uk7lsgBNoDX8jI9WtjFFP76a+ckfepf4HnlerJet6kohk60YqAj8hN8
	 pakrSxNRDXiWB2Z3YyW8ykbD9CnxDFoDG+xJmUSlbz7BGk5HBnjXT9+Lv4ruk7/EeGbPg
	 +fLBT1B/z9rnY2I3oCEY4NJAZkmohcnyqxCQ1dprIzuUV/qwoeQQIccieoTbWm6Ko3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794331233;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=yHvW5njeG1MxJaBgN4O40YX1fGhfL3blpOLr1O0pWBQ=;
	b=AkPL+39sthxb984ZVjj3WqLsoSRbVgTUwDnj24SA4aDb6aTEuyH8ygiq/WleFAyp2KM7
	 CBV8RLEKed5dx6eQnWnu0tq34IDXlXTsHyQQqbLkt5HFms94JSEewJYP/W/YktIa4nNcR
	 Hl9dC9v3oPDqhoLv+e1QNNFPt0d08Uc2EbAMe/EJ1XKnep/cOr8R1CR+YcaS6Etjxgx54
	 Hgokcrc8Rh2vk0szkxl+N3hR65ztK4ac/iYWMIKUs+oe1PP7xDTt2jz8xh2wiBiu+6ENg
	 hThZ6GmOqf73DGKZVuGSWnDmJI5hCr3fTyxmcTMNqaP0Qiqi3FPO8g2OIKLdvyYUS2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jK8QudxU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837D8606A321;
	Tue, 10 Nov 2026 17:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jK8QudxU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 263771F0089F;
	Tue, 10 Nov 2026 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331233;
	bh=yHvW5njeG1MxJaBgN4O40YX1fGhfL3blpOLr1O0pWBQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=jK8QudxU4M8qY7vi+WbGn9jwZwpPtwJ6Jo9/SIDrF6AqD6AHm5+WTMw/s8hK7UCJo
	 1fCDrXGe2UqNSFtkiYyLhX+AfY8uVv6IqTZypuozdNdrOnz4RM4MzIaLkGzIYBcsQl
	 EXadyfuo/1PJfWyrGxXxp8cHT51y9j6pjexCv/yWYtwfhpjhxuGkQ1PvQOa9M4owT1
	 29DkvzCSRORubByfZLAPRjrB40n9yffMU3NKALqyIStD15C+Lu82NpipCNGS64/HZS
	 GYsVRpcHdmtw7FWgKYkz47e2ngugLNxNZeJVH2KlUMQJdPB+U9nLvrEG3aSb4awsmH
	 cu6ckGsFebROA==
Date: Tue, 10 Nov 2026 09:20:31 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev,
 davem@davemloft.net, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Stefan Metzmacher
 <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli
 <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz
 <dreibh@simula.no>, linux-cifs@vger.kernel.org, Paulo Alcantara
 <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey
 <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, Chuck Lever
 <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>, Steve Dickson
 <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, Alexander Aring
 <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, Matthieu Baerts
 <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, Cong Wang
 <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, Jason
 Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, Sabrina
 Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Daniel Stenberg <daniel@haxx.se>, Andy
 Gospodarek <andrew.gospodarek@broadcom.com>, mef@scarletmail.rutgers.edu,
 paul@jakma.org, Kuniyuki Iwashima <kuniyu@google.com>
Subject: Re: [PATCH net-next v18 00/15] net: introduce QUIC infrastructure
 and core subcomponents
Message-ID: <20261110092031.71f4e691@kernel.org>
In-Reply-To: <CADvbK_e3aoDOyk3hbPtS8pk3U0QSiLtYafpH2oaoNbbR9mV9aw@mail.gmail.com>
References: <cover.1794241654.git.lucien.xin@gmail.com>
	<20261110074153.4b895bb6@kernel.org>
	<CADvbK_e3aoDOyk3hbPtS8pk3U0QSiLtYafpH2oaoNbbR9mV9aw@mail.gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Nov 2026 11:57:48 -0500 Xin Long wrote:
> On Tue, Nov 10, 2026 at 10:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org>=
 wrote:
> >
> > On Mon,  9 Nov 2026 11:27:21 -0500 Xin Long wrote: =20
> > > The QUIC protocol, defined in RFC 9000, is a secure, multiplexed tran=
sport
> > > built on top of UDP. It enables low-latency connection establishment,
> > > stream-based communication with flow control, and supports connection
> > > migration across network paths, while ensuring confidentiality, integ=
rity,
> > > and availability. =20
> >
> > coccicheck says:
> >
> > v:250:19-25: ERROR: invalid reference to the index variable of the iter=
ator on line 241
> > net/quic/connid.c:252:16-22: ERROR: invalid reference to the index vari=
able of the iterator on line 241
> > --
> > pw-bot: cr =20
>=20
> This is a code pattern concern, not a real bug though, as the use_count <=
=3D 1
> check guarantees the loop always hits break.

AFAIU you must save the iterator to a different variable explicitly,
you can't just use the iterator variable after the loop.
