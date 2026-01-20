Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2853445BD68
	for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 14:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768921112; cv=pass; b=KuD5P2Qh6hJbHJadRmz3dwj5LopUZEv3jwDqfpUpI3KrG8+Zw1D98lw6mGskWQXvu7pz8PNP3zLDS+7roL+J+xc5LKPL9W/fljXQKXjd8Kx7iHoZ6VV1rgKqE8BkxHkReBS/CYp4PRjEEU0q1kAkHqvYDbivRzJ6SD2t7yA1bYM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768921112; c=relaxed/simple;
	bh=AV9hAIQr5RzI8gRTr0Om3D11rvB2xShikwoc1m16OHI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jWBReB89mXXxYxIC5l18qRgaA12q3evSw/5oQYwmSpkPysiO99uYRaP91NIenxH6EC18PLbpfpoA/WCkRCrMEyWVuHzdr5ndNyyCiextePE+SEkoP30/a4Roumu9QZHgv/pmmDqXcI3G4ZSh/hsT5U5sbo3tMYZgI9nTnaV1mXE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VrT3A/XG; arc=pass smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VrT3A/XG"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-81f4e136481so2566645b3a.3
        for <linux-cifs@vger.kernel.org>; Tue, 20 Jan 2026 06:58:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768921110; cv=none;
        d=google.com; s=arc-20240605;
        b=C37Nj9XqqaMbtwJ/dvptel2JLUmqwCtQw5oolg+jG5suWRodiKOF9daz2Lu1kCTRYo
         uK+oBpHyCDjAG0wTgEI8v4W5VByxWqXfQUh+oEyGkYdwtQnR+K8pAzrvk1Dsd29fgHMC
         iIVVFA+8HrjM2WRvDFvuXOFO/qWCgIJ3EYUjl5U1BWUbJvH70ZbTiKl1fUAq5ImT2VoY
         Y0Q11ltVt2E2DbUjDDy14dKdfooKLXebemQGJvnUEw31mmDrZ/eeeTX3inT+p8ZMvjSI
         zzApbPPb+br1YdFue6o5JfnwLRhK5qQUfFUs053tXJr57liiegR1doDlTiZaGczw+I5j
         J6dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EUfRwMQV3KapT7k/eehULUSMHqVaGxUA4eRrbnoBX9U=;
        fh=lgDaE31ze+7oScZrvl+iOGYm3nGhFCxvSW+65lJZQco=;
        b=k2TFirxB+XlXG5Rv5FVlDEAQJls5SGts2AX0zNt4JgjBq/mbwAVNrNCqnyLAAtEouR
         n2zWiM+4cUAai8r1dcLFFpShEniEFd/klxot2b5PNC8XcpzGDUKBnpyEbFQR4VZogC/4
         +/2pQk298gVhcGZO7cB8D1K+zJjDewlsfC/i5gD97hu/K6kMqfzfWqGVOyhg2oHTg4y+
         Pn6uoiSC3ryluggNry5aAzRCsAV3I8P8CWxuliulpUsOxwSctKDsOJXoAwS3w3DBaJu1
         /v/jw72mEDyTphYj5ljR9tKHBBEV+APDhHC/6+K+kKTP8YbtRccNsPpm6FLNF5ifkB9I
         0p9g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768921110; x=1769525910; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EUfRwMQV3KapT7k/eehULUSMHqVaGxUA4eRrbnoBX9U=;
        b=VrT3A/XGeXGv/3EgNntOVwTUsGMRpoH6LR4CIPrz2kzgzQ9RkSGlwoi03OUqReXrWN
         /LnaVEUR8wStMnwYf6r2euogFv+e8OOaESrNnfb8SYV+tJh3NI4vcm0GrNjUBHliP48Y
         e1eniaPCJOOnbYCNWCtFIxRCajPUthpQxwj5PNqKbCJFzc3/ahONyuZLLuPfwjQioy1k
         Atfe0DVCpxvthof+93Ymty4ZdeLJ8hy5jV7+mXIyDvJP14o+vUHJ6ixUSavix3/5fnwW
         45BVqZfW+njhnvUS7eF4x34L5EBQifb4zsmWlCiAelWzLCyrTsmkG3SDRf2n0b4UCeK2
         j6vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768921110; x=1769525910;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EUfRwMQV3KapT7k/eehULUSMHqVaGxUA4eRrbnoBX9U=;
        b=ReU28o+y5WsCZVlqRpQ1fAJE9/wloNlZ1eXO1YYcbrIkrOv5+bcVgvMcHJd0vULWu1
         bIfwyZDjnXaarO5qB4xAkanLDE01tGsDnstjDm+ZSKSCcAq3920/KWhcYWnT0zpf/Xwb
         TTZIkhSVDS8BTBtl39qeh7et0sdyji7GFv03u9rJacVdfpjWc2j7sUGHEt4rqn2GEUAR
         pI0j1qqzwNDOJzTeuVpA+BSIg7qdf7WXbaCdV4EYnvRpVP5MgioBP7ZDCrWVRa14gvx/
         XRbyzMax7d8DpNRzF/1jzyi+ZzsDOGVQyjUW34Qj2TIn4J5ZQ02ppmngNpMH/jDpQ6j6
         d/jA==
X-Forwarded-Encrypted: i=1; AJvYcCVgsdN5qGL0yPEnJ7N3MW2yOYkaWCFk9SS+JOdxb988jPzPk/UyHfV5QLnGq1vMWmquRjywxrdMFDfo@vger.kernel.org
X-Gm-Message-State: AOJu0YzU6By46IB2QlexivNbj5ddVfylj8gVzGPNkhvJB7Cw2jBWjwu0
	4OZHpqdubYTc7+Bd6n5ZfVsFjSx4skW1eZKGked7l/vPk0g6mflpawmKR/a/NK7meSh8t8o3xW6
	UDQ/4m1TAuiBOZKrjs771nOuDxUzrUhM=
X-Gm-Gg: AY/fxX4HWmaKjvIV2XdwpSh4znE8fiNa+DW3xFIAJ4mD2buGmu8bHXIqNRguU0p8cxT
	f4+Uw28QHUl9IUjicQxeVPrtXuWwVQQnvPVEtnuD/7VbXM1LmYXZOABCt6B7TV4mgq94q68bKnE
	DYS5Gz+h/NIeReYdjOqBt/LzQmdMcyiRsnVNvbUXQn+3RuKkIKp7qMfzA66eue1hRSjw+BEM+wV
	jBBieuy1QSTv0nhjvawHTVGn3mXL3+bxwBX+JCl1PL/cef5yQ8gNh0PsfehWk4Kg6sS29Md0/Ug
	WwRx2iivyVqsfgGtAKxLIM7BAw/rpgs6Igx4I04=
X-Received: by 2002:a05:6a21:692:b0:38d:f0f3:b940 with SMTP id
 adf61e73a8af0-38e00d47b68mr13733048637.57.1768921110331; Tue, 20 Jan 2026
 06:58:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1768489876.git.lucien.xin@gmail.com> <e3f770ef8d9aba101e1f5dc2f2f72bb0d2a30b94.1768489876.git.lucien.xin@gmail.com>
 <6c6d5644-3354-46ba-bbc9-e76789648abf@redhat.com>
In-Reply-To: <6c6d5644-3354-46ba-bbc9-e76789648abf@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 20 Jan 2026 09:58:18 -0500
X-Gm-Features: AZwV_Qg7dfPxOkDkqOzOQW_7YKwWAViU6i2Li95CyFWjfHPIuFun67eybDn2Dd4
Message-ID: <CADvbK_dh-O9NuNE4XL2ic2WUy9ysWc1NzbsJ99kv0ZciAw7ttQ@mail.gmail.com>
Subject: Re: [PATCH net-next v7 06/16] quic: add stream management
To: Paolo Abeni <pabeni@redhat.com>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Simon Horman <horms@kernel.org>, 
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

On Tue, Jan 20, 2026 at 7:32=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wro=
te:
>
> On 1/15/26 4:11 PM, Xin Long wrote:
> > +struct quic_stream {
> > +     struct hlist_node node;
> > +     s64 id;                         /* Stream ID as defined in RFC 90=
00 Section 2.1 */
> > +     struct {
> > +             /* Sending-side stream level flow control */
> > +             u64 last_max_bytes;     /* Maximum send offset advertised=
 by peer at last update */
> > +             u64 max_bytes;          /* Current maximum offset we are =
allowed to send to */
> > +             u64 bytes;              /* Bytes already sent to peer */
> > +
> > +             u32 errcode;            /* Application error code to send=
 in RESET_STREAM */
> > +             u32 frags;              /* Number of sent STREAM frames n=
ot yet acknowledged */
> > +             u8 state;               /* Send stream state, per rfc9000=
#section-3.1 */
> > +
> > +             u8 data_blocked:1;      /* True if flow control blocks se=
nding more data */
> > +             u8 done:1;              /* True if application indicated =
end of stream (FIN sent) */
>
> Minor nit: AFAICS with the current struct layout the bitfield above does
> not save any space, compared to plain u8 and will lead to worse code.
>
Makes sense, will change to plain u8.

Thanks.
> > +     } send;
> > +     struct {
> > +             /* Receiving-side stream level flow control */
> > +             u64 max_bytes;          /* Maximum offset peer is allowed=
 to send to */
> > +             u64 window;             /* Remaining receive window befor=
e advertise a new limit */
> > +             u64 bytes;              /* Bytes consumed by application =
from the stream */
> > +
> > +             u64 highest;            /* Highest received offset */
> > +             u64 offset;             /* Offset up to which data is in =
buffer or consumed */
> > +             u64 finalsz;            /* Final size of the stream if FI=
N received */
> > +
> > +             u32 frags;              /* Number of received STREAM fram=
es pending reassembly */
> > +             u8 state;               /* Receive stream state, per rfc9=
000#section-3.2 */
> > +
> > +             u8 stop_sent:1;         /* True if STOP_SENDING has been =
sent */
> > +             u8 done:1;              /* True if FIN received and final=
 size validated */
>
> ... same here...
>
> > +     } recv;
> > +};
> > +
> > +struct quic_stream_limits {
> > +     /* Stream limit parameters defined in rfc9000#section-18.2 */
> > +     u64 max_stream_data_bidi_remote;        /* initial_max_stream_dat=
a_bidi_remote */
> > +     u64 max_stream_data_bidi_local;         /* initial_max_stream_dat=
a_bidi_local */
> > +     u64 max_stream_data_uni;                /* initial_max_stream_dat=
a_uni */
> > +     u64 max_streams_bidi;                   /* initial_max_streams_bi=
di */
> > +     u64 max_streams_uni;                    /* initial_max_streams_un=
i */
> > +
> > +     s64 next_bidi_stream_id;        /* Next bidi stream ID to open or=
 accept */
> > +     s64 next_uni_stream_id;         /* Next uni stream ID to open or =
accept */
> > +     s64 max_bidi_stream_id;         /* Highest allowed bidi stream ID=
 */
> > +     s64 max_uni_stream_id;          /* Highest allowed uni stream ID =
*/
> > +     s64 active_stream_id;           /* Most recently opened stream ID=
 */
> > +
> > +     u8 bidi_blocked:1;      /* STREAMS_BLOCKED_BIDI sent, awaiting AC=
K */
> > +     u8 uni_blocked:1;       /* STREAMS_BLOCKED_UNI sent, awaiting ACK=
 */
> > +     u8 bidi_pending:1;      /* MAX_STREAMS_BIDI needs to be sent */
> > +     u8 uni_pending:1;       /* MAX_STREAMS_UNI needs to be sent */
>
> ... and here.
>
> Other than that LGTM. With the bitfield replaced with plain u8 feel free
> to add my
>
> Acked-by: Paolo Abeni <pabeni@redhat.com>
>
