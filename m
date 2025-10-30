Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6088017A2FC
	for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 14:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761833635; cv=none; b=P7cmCkDEJ2Uo07HtFQnz9I3UGtS8+xmYQ2o45yf4dhSS6i/jij9DIr2bCk9qi2/y7ZTsNOkN3SR8K0jbcln1HtpoVhOCMa1UgsQWt+s9QORVT0AVHBS8PKYAQZ9D/jPyy4SlqeHIX3XGys3iIBSCt3AtTZPuY29yAG0ieggcFOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761833635; c=relaxed/simple;
	bh=/T40+ChYVbQJjlFEBDtmTJc9Zvc0liM/GgUzEfzM00E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sLPw+4quHullGr/oibPoQCLx6qYRKfdF1lWXSWPbnPMtX+dTKj4h2/ws2yiXuemay6ihgcGzbNyRBeW4Mc01LMua4ObqMljUTk4LQ8UWewlR3xIsnTjPBmtj7uxxkOHO9YqozVvT10aNldqVo3SXJw0RC//vkijyHYyZwcgpR+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eHVy2D7W; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eHVy2D7W"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6cf257f325so924704a12.2
        for <linux-cifs@vger.kernel.org>; Thu, 30 Oct 2025 07:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761833634; x=1762438434; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GwPV67fM5V5sQ6RejEBhGju2a3kknsbjfFsnKSUOpA=;
        b=eHVy2D7WRcphOaj87/QwpBl9oYE+GZn2waBmcjDWnwwimajWcNUejMXDxN/5suVs6X
         chA40DSePRmjEvUhxFdAbw90WmOPh0i3PF27gJJ30ugi1dTdSp5B/7HSg785GGfrudff
         +hvvxdTLrz+vn1XJQnDH78AodpXxGlW7kLpOY1CeVOyFnYxkAlLMG+eH9FVJOsAE4pQ4
         UkHU8SollZY+5lQGBNDe5qWxwjbMoj5I1biHIDQLXXEq65xOjB4QBy459g+lq44rYXM7
         27OrwV9TQ0LizRDYXaJuCbUNU5gTQ8bWFX8C3wf9adotrD9KChcjePyuVSqt2vdhjOJs
         ZatQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761833634; x=1762438434;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1GwPV67fM5V5sQ6RejEBhGju2a3kknsbjfFsnKSUOpA=;
        b=kCl7dCc3DcjH+SCoCSiJxdOLkV1WLZXuy+kM4TQlOzbO47ARsKdFsyugPb0qIkp+Rk
         riZs4M9qOJuQ72zW4juKFXuzoU6BxJE1acezKTL3yfWWbocVu3cwNEfntOSYSyg7fl8O
         se0VIMsoKvpkiHw4q8CD55WsTq708DpGzXFu5WwS1lcYwA4Tb5oIQmGp3sWislMlOHcs
         R1DSjKVEr59xLLO1omNACZmEk3abB7JkQOppY8YWxUTU4yt8HBbxhZ8mAimv4aqsB4M3
         yqUelOn/YL+tVbERR/hJqoB7SGOt+GTHinwxKCbHVCsTGGb2WAOCd3aCr+/KOTYTlgoO
         JEGw==
X-Forwarded-Encrypted: i=1; AJvYcCXL03GCqZlE55fMDlERnsUxWBSgRlc4cXL0cYh6pdOm6tHhI4z/qZqYUC+cX7nWtc1UxWqu2qBHGNb3@vger.kernel.org
X-Gm-Message-State: AOJu0YwIUyl9XJSjfrWZ6AzX/z8LNBSg02alw6mrEfvVTxaiH8Uwis/s
	7sHDFpbIBbeFw/br5XDw0N8GTeXJsSLgsiRn2OV6lUCcRYdMZr2mIDDZ0Ix53PZXRP9VoLc36vJ
	2kLZcKxgW2V+ijMmpxSAHS5PXrAF7yoU=
X-Gm-Gg: ASbGncv8R0ceMYO+3VdqW9F+A7qEqHLh/AHiFpbhhVSqQMs9o4VJ2V4GzBm9T9Oyf/1
	CbTtoTIwkeiPAPHPBVLTOBNcrJBfJIka09+NH1UwWtbA9KtrBBWvONN74rvGCUnpFcM9S0vOL3t
	yf2CJzHP3RzmoIuSDOwAdFZ84Erwx3fdpEnwtn73LSS+bOfp7M4DS0d8N9US+MIR2dnHlpW5T1K
	oi+cst1p2inF+FAoHKvSqmQW8rEAm2rY6I25k50CKO5WK+84AefomI8V5XX8PEehcBwBQg+ZK5S
	6sNseHOaWIl8pHABXg==
X-Google-Smtp-Source: AGHT+IGQeZf3/xDx9PN4GOOFJoj/NMC2uHC5MkG58KIcW+QZIEsnabkEgg4aAn3sUpRS5Lsc0ZRHkz4/xmiVriMCfJo=
X-Received: by 2002:a17:903:2349:b0:267:bd8d:19e with SMTP id
 d9443c01a7336-294dee35d83mr74289795ad.22.1761833633536; Thu, 30 Oct 2025
 07:13:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
 <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org> <CADvbK_f4rN-7bvvwWDVm-B+h6QiSwQbK7EKsWh5kTuHJjuGjTA@mail.gmail.com>
 <b9300291-e828-47fa-b4d1-66934636bd7b@samba.org>
In-Reply-To: <b9300291-e828-47fa-b4d1-66934636bd7b@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 30 Oct 2025 10:13:40 -0400
X-Gm-Features: AWmQ_bkH59qmzfsesvc02GCEqCTGnpE58Lv-Efw4wO4JNI_ID0XqW9PU-fQIxTI
Message-ID: <CADvbK_f=E11=dszeJos98RvBY5POXujgT0dFo-LG6QQuGW20Kg@mail.gmail.com>
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

On Thu, Oct 30, 2025 at 7:29=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Am 29.10.25 um 20:57 schrieb Xin Long:
> > On Wed, Oct 29, 2025 at 12:22=E2=80=AFPM Stefan Metzmacher <metze@samba=
.org> wrote:
> >>
> >> Hi Xin,
> >>
> >>> This patch lays the groundwork for QUIC socket support in the kernel.
> >>> It defines the core structures and protocol hooks needed to create
> >>> QUIC sockets, without implementing any protocol behavior at this stag=
e.
> >>>
> >>> Basic integration is included to allow building the module via
> >>> CONFIG_IP_QUIC=3Dm.
> >>>
> >>> This provides the scaffolding necessary for adding actual QUIC socket
> >>> behavior in follow-up patches.
> >>>
> >>> Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> >>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> >>
> >> ...
> >>
> >>> +module_init(quic_init);
> >>> +module_exit(quic_exit);
> >>> +
> >>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
> >>> +MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
> >>
> >> Shouldn't this use MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_QUIC)
> >> instead?
> >>
> > Hi, Stefan,
> >
> > If we switch to using MODULE_ALIAS_NET_PF_PROTO(), we still need to
> > keep using the numeric value 261:
> >
> >    MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261);
> >    MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 261);
> >
> > IPPROTO_QUIC is defined as an enum, not a macro. Since
> > MODULE_ALIAS_NET_PF_PROTO() relies on __stringify(proto), it can=E2=80=
=99t
> > stringify enum values correctly, and it would generate:
> >
> >    alias:          net-pf-10-proto-IPPROTO_QUIC
> >    alias:          net-pf-2-proto-IPPROTO_QUIC
>
> Yes, now I remember...
>
> Maybe we can use something like this:
>
> -  IPPROTO_QUIC =3D 261,          /* A UDP-Based Multiplexed and Secure T=
ransport */
> +#define __IPPROTO_QUIC 261     /* A UDP-Based Multiplexed and Secure Tra=
nsport */
> +  IPPROTO_QUIC =3D __IPPROTO_QUIC,
>
> and then
>
> MODULE_ALIAS_NET_PF_PROTO(PF_INET, __IPPROTO_QUIC)
>
> In order to make things clearer.
>
> What do you think?
>
That might be a good idea to make things clearer later on.

But for now, I=E2=80=99d prefer not to add something special just for QUIC =
in
include/uapi/linux/in.h.  We can revisit it later together with SCTP,
L2TP, and SMC to keep things consistent.

Thanks.
