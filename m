Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A34E4207DE2
	for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 17:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758648633; cv=none; b=iunQXujcD71t118dDq1lx39gPvRFlPMKKisXkl57W7+QibKhXlxDpaU+D+q+MpReh+m0V3F3xdMARg8pwNb8l+CPqYAIBXCUNqIVMTfeM4Lk4QkxYCL5Oi/GuzJI1aCPYjAdOrrGjOSRQCRyn3nAavE+bxk7Jzhybz+SxNRAE2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758648633; c=relaxed/simple;
	bh=hghWyqMLEkBfQ6eizevoRvpGAa/9gRmG+OWcHoOGofk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UwWJhv8qr5P1dQab8llSKZkxdeXFAX447O8xYkWNZ6/onI7aFfU3/2a3TjmeJuq59G483g557078rwWwJ8XXJMD9v6qEZJXQuS3sl7NoiHbfZzsxjtzPpu0HNfQDXx8fOFCLfis8aO+J0P72m+/+8kh53KszTASWOeTf55U7imA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N7txsixn; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N7txsixn"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-77f2077d1c8so115537b3a.0
        for <linux-cifs@vger.kernel.org>; Tue, 23 Sep 2025 10:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758648631; x=1759253431; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otSvr9lp4hjuRht1Ui7CukSWsccNU1CrkcBBZa9JT28=;
        b=N7txsixn1hOuj81pR6oPrWvG/agfoS+y3XG/5Uw9TfrJgglBmiZm++8OoAYvKFb9IO
         ZX8iY2gUpXiAH+Xj95oFps0qBKm1eHHcTU+BY7gONfHQk+BLtGdYdb0jgSvV9Jde3pKE
         +g2gFfWAUkEkmddAnka6otlyyhDMEVDUPuy1PRU4j+Aq46PrFTINZiHfC2I9hRaoKbkI
         HQzXzAzlI/EvCasLkG0J10Y3/75d7ZJUoMb4rKZo4gu7y2d3M2+XaCViYjGFNLL5ndRF
         03qLvw4NSZAzK/y17d23D+Ti1oSpPGMzALJ12kRP4lEmMpsEs+J9yom/u3Rl3gWKmWeD
         JL7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758648631; x=1759253431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=otSvr9lp4hjuRht1Ui7CukSWsccNU1CrkcBBZa9JT28=;
        b=TY9pcpwNIMb86zmnmuzY13gHoaKow+pTLuYZjxEJzUPrkrqmH8CSlIVVNE3RXnN6EN
         t8n85Kb3HQNhalKmQJQ84FMPqeUbqFTOZ6hYDEBBdTUkrj0OHKRHHtndGDZcROniG1Cp
         RCax1A/RxMo6R+r379X/RHNHwG96+HKRYraHe85lp36Or7zRRQ+s60WIzuq6334UyNIc
         R+IHeVeOmtezVlM2bY9/B11k5wnLkRanuAvEdeisKND+6HYP2lNuzTm6+fuVrKyKpXg6
         luRmE6SxHRdCV+SUwqvBoWVMaKt9PrrRy84JbTh2JeC+2vkkTEvMCfdDHvDf11p0/f4V
         6QJw==
X-Forwarded-Encrypted: i=1; AJvYcCUL7w7PWXtXGgBuElH+MtguwNquAAg9lWvQZQMdTcB7jB7NMDLdkih9m+ik2am3DYhmeyi5Gx2aMjIl@vger.kernel.org
X-Gm-Message-State: AOJu0YzE4IT6uGRP2ifD+niY8Gxe7eSsiT6iOPZnr3P2SQWDY+x69LPB
	xdkdoDifUI9PeSH8k7cMKBdy4YdwGwFlPRTkQBGCjjSoOmhKTgZErIqN6sQ5fo+EDxskT1JSgy2
	QZLmmbh703sHBhJvv/HpdvUbYITfotSs=
X-Gm-Gg: ASbGncst1rvJeIRXhL40GGp2VYudNgqalcttDVjpR3E1w2qhHhkhZCDXrfbXraNUkIx
	xy6LpSFf7NsXRy/z7Wcb7bNAhSSpmFFUVe41d84AwMMDxTDkybRFz4pUNN+gb0DCNP0vi1KUzj7
	XQ2X1xq/7Ax+6XrD3K/3sp8D1HmUoZD0vdmLyJN1SFdIpytKEBLwCxTvXR67wprZ8YBAYZ12m5y
	661tomUKQ==
X-Google-Smtp-Source: AGHT+IHb7FTPS0aqNTQzQxRJZ7PGJRzwxQRu5Dd0GpM/MUJTuLqqFTKwQpdKNuhZ2pSdZPeFP657nduMMphE8QtkB48=
X-Received: by 2002:a17:902:fc8d:b0:26b:3cb5:a906 with SMTP id
 d9443c01a7336-27cdaa73d2amr41672395ad.16.1758648631008; Tue, 23 Sep 2025
 10:30:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1758234904.git.lucien.xin@gmail.com> <5d71a793a5f6e85160748ed30539b98d2629c5ac.1758234904.git.lucien.xin@gmail.com>
 <20250923090951.GF836419@horms.kernel.org>
In-Reply-To: <20250923090951.GF836419@horms.kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 23 Sep 2025 13:30:19 -0400
X-Gm-Features: AS18NWC9LYwbDwlF4C91L7kgoi_08hlFtRBrmqddeIKr75MWVxTZmLpz7q1S7tQ
Message-ID: <CADvbK_fCEr+oRvbtomrN8=cJc9nLFLioAXATJsU6_r24r3WOtw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 06/15] quic: add stream management
To: Simon Horman <horms@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 23, 2025 at 5:09=E2=80=AFAM Simon Horman <horms@kernel.org> wro=
te:
>
> On Thu, Sep 18, 2025 at 06:34:55PM -0400, Xin Long wrote:
>
> ...
>
> > diff --git a/net/quic/stream.c b/net/quic/stream.c
>
> ...
>
> > +/* Create and register new streams for sending. */
> > +static struct quic_stream *quic_stream_send_create(struct quic_stream_=
table *streams,
> > +                                                s64 max_stream_id, u8 =
is_serv)
> > +{
> > +     struct quic_stream *stream;
> > +     s64 stream_id;
> > +
> > +     stream_id =3D streams->send.next_bidi_stream_id;
> > +     if (quic_stream_id_uni(max_stream_id))
> > +             stream_id =3D streams->send.next_uni_stream_id;
> > +
> > +     /* rfc9000#section-2.1: A stream ID that is used out of order res=
ults in all streams
> > +      * of that type with lower-numbered stream IDs also being opened.
> > +      */
> > +     while (stream_id <=3D max_stream_id) {
> > +             stream =3D kzalloc(sizeof(*stream), GFP_KERNEL);
> > +             if (!stream)
> > +                     return NULL;
>
> ...
>
> > +     }
> > +     return stream;
>
> Hi Xin,
>
> I'm unsure if can happen - actually I doubt it can - but
> if the loop above iterates zero times then stream will be used
> uninitialised here.
This can't happen.

But it's better to initialize it to NULL. Othersize, it always looks
like a potential issue.

Thanks.



>
> Likewise in quic_stream_recv_create().
>
> Flagged by Smatch
>
> ...
