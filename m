Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2805E3644B3
	for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 19:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761767859; cv=none; b=UKEK6laOeiHDf2ZYVSVTMOTn27tfbv3y1uSL2rqlx6lOMsoqDezuheT0CeOBhz79GpxfzsvMn7L03TUwUeORqbXMppEXRv+5grjmBlmqHkILCMi3AWBXStawVXFveyxg0zREAziHwgK5foa83htCHN7KWVcWDXp+WfeJhreYxQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761767859; c=relaxed/simple;
	bh=+rNIfhn612wSnJwTsWfa3rI2oXBKL1DitnLLKvmVa24=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SyLH6B6S/vh+w70FQKLzIc/iIfjLuEYtIlZP/Z4l0d7+mCpKwyn4l32qKGNpAQvC8y73iV0XXRTEkCaTJwugzmXetnFR9k3UrEQzjxHk3xM2PTHjCbg61aSquGptRXah58mAlvUnY65QH1hMO72QbePGU3If/HgPte4Kxy8dGA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=knuFZdka; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="knuFZdka"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so304236b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 29 Oct 2025 12:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761767856; x=1762372656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5AE88Ciiu4y1L+Whuiba6HLMWI7gvS/KpyPblrUqXI=;
        b=knuFZdkavo3jbuzWz+lLMRxkQuCzsSky2G4PW0+DWx8/yWDaGZChYNV6P2mYA7AzPv
         tp9m/vIfjmCc1zte/F2y5QFwYmww0dntAFzarR7RW652V380u5DAiRBPpo1wK1dWUgqY
         43ZObmpXPXYVD5HLSa8XwJnyvgM38MTujAFadPluslaJCoqcDd5Mst+MUTTyGQCPFyVN
         XXaRmScND7qeRHvwEKeQ1Ybd3xmF0cIjb8J7FHSE59DAaF/6rT2jwbQsZD9cUL3+aYMq
         od6YQpJ5JdNlXErBJJ2U3izfTb5gxulCnKJF36/Mps50lnVL3VD/7rYubSe2ZSRbJvOY
         Mrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761767856; x=1762372656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5AE88Ciiu4y1L+Whuiba6HLMWI7gvS/KpyPblrUqXI=;
        b=UYzGouDvEK3E8Fj8qYUuWcozLnuFgWp5w1gMWlMz/XpuSK3wbSkOEMyl0at6dscMtM
         XNd2ZwGVivHjQqPHc4/AqXcw2L7f8FcFODxNek15ON7AcDZLqbZISQhHTmHmlDT9wDeR
         UxvTvhXwa0Hws991iKIYyeTAi3zWgYV7i0hP+ZSCpVJwgmETuKHVLu0fCWD3kcPxgygo
         +2KJJIQPFnljS7vhGvPoB7vNhfDNfKMHPUJlzZC7ckQLVzbwuACLgJ1Xr653t6vYyoSK
         ZT2GixMHmd+oLBLhGxjtX9eviaPlHmygw2odmkf9ZfF3ojbQi3FM5NTrNzVYm9Hpyvrb
         JHzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXsAhkn5ggIF8FAn7Iasuj57ybE6eAbSr63MTWIxZ1ERlLb7Vyh2pYl7kUYdp/28vOf3p1aRkkEJE7L@vger.kernel.org
X-Gm-Message-State: AOJu0Yzpw8WkJ7X8Gxsvjt1p4DvKP0jXtoiqCxHcOs1086Zxmv5f1+lY
	mVaeU6eQwDStqoTGWUImGTMxVVTl44IJg35RJHh2BfXBmYg6C23AVtaC45JPRqECCzntZO3MMgW
	68qAeMSn0SQkcQ7ZKVuygWUU5dio4VV4=
X-Gm-Gg: ASbGncsAXuYeb5YdRMF39fFBwjA/eFAqJukgc+rhAPA0veolNkufkmx28EasyrJ+XFm
	bsWn9bUBz2pq4rakymy+R3+SNs1p0Uy3q2CGyUbOoixP8do6N9sMZa8JQUpcceIu+Q8mh34lHxY
	PsJY/8WOu7oPMAEfkO6ndjY2XMQ5RWA1jTlVtR5ZKWeqkijON9220nBvIufC46+cqF6NzTztyDF
	LaE7Z7HNIKICxMmpID02sY+TtLXLMwTz0cYldoBzyz0cHHopVF8Ldxwj+lM+ww3LENQIahXhw==
X-Google-Smtp-Source: AGHT+IFNCX0ckOsChso5kJGqid4SLOaalcmgzvE+F5pb8cfkVkc0r3f/yGGJSksDBL4n2c6XJFS70z/v5MFaLPK0zXQ=
X-Received: by 2002:a05:6a00:3a27:b0:781:1110:f175 with SMTP id
 d2e1a72fcca58-7a61506a504mr866733b3a.14.1761767856388; Wed, 29 Oct 2025
 12:57:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1761748557.git.lucien.xin@gmail.com> <91ff36185099cd97626a7a8782d756cf3e963c82.1761748557.git.lucien.xin@gmail.com>
 <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org>
In-Reply-To: <67b38b36-b6fa-4cab-b14f-8ba271f02065@samba.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 29 Oct 2025 15:57:25 -0400
X-Gm-Features: AWmQ_bnwX6EuAJChCufrlpzg_AX6H7XB1Uf5xbfwoMjEpTiQtpfFTcbK0dDvD94
Message-ID: <CADvbK_f4rN-7bvvwWDVm-B+h6QiSwQbK7EKsWh5kTuHJjuGjTA@mail.gmail.com>
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

On Wed, Oct 29, 2025 at 12:22=E2=80=AFPM Stefan Metzmacher <metze@samba.org=
> wrote:
>
> Hi Xin,
>
> > This patch lays the groundwork for QUIC socket support in the kernel.
> > It defines the core structures and protocol hooks needed to create
> > QUIC sockets, without implementing any protocol behavior at this stage.
> >
> > Basic integration is included to allow building the module via
> > CONFIG_IP_QUIC=3Dm.
> >
> > This provides the scaffolding necessary for adding actual QUIC socket
> > behavior in follow-up patches.
> >
> > Signed-off-by: Pengtao He <hepengtao@xiaomi.com>
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> ...
>
> > +module_init(quic_init);
> > +module_exit(quic_exit);
> > +
> > +MODULE_ALIAS("net-pf-" __stringify(PF_INET) "-proto-261");
> > +MODULE_ALIAS("net-pf-" __stringify(PF_INET6) "-proto-261");
>
> Shouldn't this use MODULE_ALIAS_NET_PF_PROTO(PF_INET, IPPROTO_QUIC)
> instead?
>
Hi, Stefan,

If we switch to using MODULE_ALIAS_NET_PF_PROTO(), we still need to
keep using the numeric value 261:

  MODULE_ALIAS_NET_PF_PROTO(PF_INET, 261);
  MODULE_ALIAS_NET_PF_PROTO(PF_INET6, 261);

IPPROTO_QUIC is defined as an enum, not a macro. Since
MODULE_ALIAS_NET_PF_PROTO() relies on __stringify(proto), it can=E2=80=99t
stringify enum values correctly, and it would generate:

  alias:          net-pf-10-proto-IPPROTO_QUIC
  alias:          net-pf-2-proto-IPPROTO_QUIC

instead of:

  alias:          net-pf-10-proto-261
  alias:          net-pf-2-proto-261

Thanks.
