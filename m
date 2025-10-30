Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 510F025A2AE
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 14:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761834496; cv=none; b=cG+ZUSpwinDP2Cldq6+OF/g0yUTJM8bFOo6H8SOIVsVo8J5TeVNbUa3p2Vjhrk3gn5AM+DDY4mi3kxVikhluyxKH5nFnk0dtH6i9cnoJKJcA8E8yayV8UE11Y4pgigZOmmfi9BsM2A9QPmjUvGPZX0VBPWb5We6vGM+M2U+qomE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761834496; c=relaxed/simple;
	bh=XofufYTIvVz0xFJFDMwmm6sP18q7o2xd40JtSUXhtAs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KImcYW2UWdOpVTrqwmJDFG3xhtCYsWAodGRKmX1nZCzW4DsB/ZEgNe4Fe16J9u2sFMC4B/qr5ToxIBU07PZ+7TrK7R7ZSQVvT24bxDx3zp8OM0qswxwn5FldAaP2txFXKOrd+5amywtZ20gYTZ1M9NSacP2YLwg5WKBIHfE3xJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NK23OB9F; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NK23OB9F"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-793021f348fso1147297b3a.1
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761834494; x=1762439294; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cuCA5wWQIDpUIW6qlKdvaKlw1rWMEkNLw7LaZvFkQQE=;
        b=NK23OB9FgxZdOtqx+m0mO8Ka+BauU6cPQ568eDDRm39rricI0OUOSC9+zr5TR29lKS
         0807C8r+dFj9sUmwAsnnijv4Axva4V7C0o4A5r+19L9xLQN+ocNjgXn1xqw4ziQMdk+h
         zh5Hw8gFPjYGjqcunMSXTjzVlHhL8ObvUOYEYJb7yFUqoVt+roupHnsB1Lc0+Fy2FUKG
         G+q7a+tp+ua0L8zlAlGjb8DalpteAPO0c+WSeUypblHRahcaamnyE24InTSCeCDCEnTe
         5ozYlJW+7Rs2B+AvQxMszqgjTMmdKTjRQcwn5pHDKdpKrU7BHcnKQLriXq6My9RMGZz0
         tsGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761834494; x=1762439294;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cuCA5wWQIDpUIW6qlKdvaKlw1rWMEkNLw7LaZvFkQQE=;
        b=XgzOkHldhKp4z8msQx1WzBy5kAeR9jiSRMV87WOSCXL3t78Tbq+AtdHE0gnGl73sEB
         pnLfOeqVyeAqK18hzpz9t6Qtt2EKWAkv/XfAMcDFyKCF0FKSdE4b1QPXDdlV39rqjMfs
         5oQSiX3SA9Cs6HSww/H5IQWtvpG/Z+dw2dFjDXCUMmKV+gf5+dTD7llbi2IFaQdtxgon
         NUyS5Bxwm58ZekatVJHb54YjjNLuQnsDoqIgg84/sm8QfA1aE71QFIhYo0UMfqnVkTAg
         icgrhro2CfbvNrWj/QG8LrgSULCIdgqPeUxGrZ8ROXpQL+D/1i1k0tN/n3/4n4+qzwx4
         2Xyg==
X-Forwarded-Encrypted: i=1; AJvYcCVVz5r/KelEsLJAbqagIhQMyic94IwBmDMUzozMluD1PWspzVI8LVgvZ3QT6DaWiTMBlg96xP7ChtkM@vger.kernel.org
X-Gm-Message-State: AOJu0YzjpPIGg4M3RSE/BQFj1yW7wkk0txzDNqyQx0tFjcKikMFtGLQr
	4YffzTB1oHt5fzubzRQ4OXiInRWRN65rzczjt75Tiier+nWhG4gzy1u98uzrBK/tesNaFK5R0DN
	/93a1+CDneKLg4KumNNs5I1QMDJTUFtg=
X-Gm-Gg: ASbGncszXQ/7i1y/TjGsCA5irUIYyEkfUOZrSgwxxpPycoJkojSCZXHKzq42Dpso4sb
	65+U/JGKEZIIT9ZvphW9+mG0kbNKW2ZSume/UFjxP/4CyNrYNWlDCP5TR0hGSc1U4y54LReieyJ
	0WO9DjCMSfrjQXCy9RLVEJ45wm3vo+CqMv3y0HE8xf3Oeqec8HvywyOzPjR9NWZSbwhj4EpjyrQ
	tQ/BIKwoOD1vITIYGXzz0hmgUOuZalLpJRtMhSM4/kv99GR/vHsQNFZnhioj0Y9vvli2eVgMWEx
	M4Pmh64pgEbCLhoC1CQrPFN+U478
X-Google-Smtp-Source: AGHT+IGSYvw5mArOho8Chrlid2Yf9zFIgqFqjnuZ41Vc14qeGP9OaC3SkBO5TkyH/r8UCkIM4dvPWepO1U0aCamvif4=
X-Received: by 2002:a05:6a00:181b:b0:7a3:455e:3fa5 with SMTP id
 d2e1a72fcca58-7a621813833mr5006811b3a.0.1761834493501; Thu, 30 Oct 2025
 07:28:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
 <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org> <CADvbK_f4rN-7bvvwWDVm-B+h6QiSwQbK7EKsWh5kTuHJjuGjTA@mail.gmail.com>
 <b9300291-e828-47fa-b4d1-66934636bd7b@samba.org> <CADvbK_f=E11=dszeJos98RvBY5POXujgT0dFo-LG6QQuGW20Kg@mail.gmail.com>
 <0b65e74c-71bb-494d-9b05-0ee20f27e840@samba.org>
In-Reply-To: <0b65e74c-71bb-494d-9b05-0ee20f27e840@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 30 Oct 2025 10:28:01 -0400
X-Gm-Features: AWmQ_blojTdIYKtFmYVhDD9RZMLgIE9kL3y8nlMJgL7u2g9jepaBDc3oSEs4qws
Message-ID: <CADvbK_cPEnNfcUXaHm3Aub0dkerqnwG4NB_EJ_eQZTc80c28_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v4 02/15] net: build socket infrastructure for
 QUIC protocol
To: Stefan Metzmacher <metze@samba.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, 
	Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
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

On Thu, Oct 30, 2025 at 10:17=E2=80=AFAM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Am 30.10.25 um 15:13 schrieb Xin Long:
> > On Thu, Oct 30, 2025 at 7:29=E2=80=AFAM Stefan Metzmacher <metze@samba.=
org> wrote:
> >>
> >> Am 29.10.25 um 20:57 schrieb Xin Long:
> >>> On Wed, Oct 29, 2025 at 12:22=E2=80=AFPM Stefan Metzmacher <metze@sam=
ba.org> wrote:
> >>>>
> >>>> Hi Xin,
> >>>>
> >>>>> This patch lays the groundwork for QUIC socket support in the kerne=
l.
> >>>>> It defines the core structures and protocol hooks needed to create
> >>>>> QUIC sockets, without implementing any protocol behavior at this st=
age.
> >>>>>
> >>>>> Basic integration is included to allow building the module via
> >>>>> CONFIG_IP_QUIC=3Dm.
> >>>>>
> >>>>> This provides the scaffolding necessary for adding actual QUIC sock=
et
> >>>>> behavior in follow-up patches.
> >>>>>
> >>>>> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> >>>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>>>
> >>>> ...
> >>>>
> >>>>> +module_init(quic_init);
> >>>>> +module_exit(quic_exit);
> >>>>> +
> >>>>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
> >>>>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
> >>>>
> >>>> Shouldn't this use MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_QUIC)
> >>>> instead?
> >>>>
> >>> Hi, Stefan,
> >>>
> >>> If we switch to using MODULE_ALIAS_NET_PF_PROTO(), we still need to
> >>> keep using the numeric value 261:
> >>>
> >>>     MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261);
> >>>     MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 261);
> >>>
> >>> IPPROTO_QUIC is defined as an enum, not a macro. Since
> >>> MODULE_ALIAS_NET_PF_PROTO() relies on __stringify(proto), it can=E2=
=80=99t
> >>> stringify enum values correctly, and it would generate:
> >>>
> >>>     alias:          net-pf-10-proto-IPPROTO_QUIC
> >>>     alias:          net-pf-2-proto-IPPROTO_QUIC
> >>
> >> Yes, now I remember...
> >>
> >> Maybe we can use something like this:
> >>
> >> -  IPPROTO_QUIC =3D 261,          /* A UDP-Based Multiplexed and Secur=
e Transport */
> >> +#define __IPPROTO_QUIC 261     /* A UDP-Based Multiplexed and Secure =
Transport */
> >> +  IPPROTO_QUIC =3D __IPPROTO_QUIC,
> >>
> >> and then
> >>
> >> MODULE_ALIAS_NET_PF_PROTO(PF_INET, __IPPROTO_QUIC)
> >>
> >> In order to make things clearer.
> >>
> >> What do you think?
> >>
> > That might be a good idea to make things clearer later on.
> >
> > But for now, I=E2=80=99d prefer not to add something special just for Q=
UIC in
> > include/uapi/linux/in.h.  We can revisit it later together with SCTP,
> > L2TP, and SMC to keep things consistent.
>
> Ok, maybe this would do it for now?
>
> MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261); /* IPPROTO_QUIC =3D=3D 261 */
>
Yep, fine by me. :-)

> I'll do the same for IPPROTO_SMBDIRECT...
>
> metze
