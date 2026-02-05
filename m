Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285501DF254
	for <linux-cifs@vger.kernel.org>; Thu,  5 Feb 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.215.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770318245; cv=pass; b=G1FzRW8lFz704Ve2YL7oSxjlqutCXEz1Nr3Y+jsrnDMjBNX8jvTbSj7ZIzljui+11I5hRNBbrsfG9xc0EbF1LMq/vuLkQGQcuePar0MIzDI+fSIN5CQuJZoi/2tT1CbrCh3w/XZVpssR2D6crZT63re1ccBarslRudkjqP91ujg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770318245; c=relaxed/simple;
	bh=mMoJ2tLJEBg9sKf8yUPINOdmAZsdGLwl34VanWm6tos=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ql4G2PVXK5rBV4Hp9z4nW8bvP+OxJ+n3Go1AQ8rnORLIw9PWozLXfo7zDzkqbiuA5Uh+UHuboZ36gj6JGotmobHgOqw73AV+qCcl2Wpm6QMEpniVFdwh2o3/qd4ny4qnkCVi40xfO5B9BoFffx9xb2boMW6YOmZXiYUX4RhS6/8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMDa/Xk3; arc=pass smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMDa/Xk3"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-c626bd75628so415492a12.3
        for <linux-cifs@vger.kernel.org>; Thu, 05 Feb 2026 11:04:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770318244; cv=none;
        d=google.com; s=arc-20240605;
        b=MXtJ21DK5rgpHs4jBXMs9k1GtPc5QZ4dSrpR222z+W+QgZX/PVjKkmlKMryhk5BBQ0
         UfZe8eKSMb8bsDH/h2jL3g+vQMhSGXgilmIVwhutwssH1Bhgh9TO41Ecej5PMLe+a5DA
         Dj25fD4qX2BsUboYxAy/fj5l+V8VKjS/xcqNkULq4a+dI/hRPhp0p3alVXSMVwvbkANO
         aFwHBYxqjDtlc74Ovx+Ov7OIOpUMMpGhbWtRt2rOHR02UzO3szwqfeoJjDbQvMr6FcuV
         7Bc6U9ugEr2sbJoHCI3HLRiNw+7KeM5wWSHUiQc35qAtava+8WwiYX8Iy2B1iyH6qWi1
         9QOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UTcUAmNhDbXfJ1YkCH2MncVbNEMdAOiqZyjVuJUmYMI=;
        fh=ol+S2Xc9FJwO0bmLp7HmqMNUSmx69DP+tDTrlv/FMDA=;
        b=a+bgvzG84QmlgJMFXgDYOLBiX0CviXTeqqtBa083LUq+0iyy2uUXmK94stg3sF213I
         zz6lES3VJjrF/nqv5rXZmbG/f5Exf2LFL5BJSi5ML5hNWkTvHberjhUcm7mxxLD2lxLY
         WXUKG1DiAlAl59/MuuFAy25WTix1JqJ5tL6ba2pfBQ+m2P+zzdxG+MS7k/jobPu7ywZW
         qZT0Gv7/BFvSngFoSuic7N2tC6irMGH0QVtR8l7PPhGbBwqg9zxTCM70Xsa7bN5Z9eLt
         cWDZzRWugTTJox5ucdp/l9KnHfpZ44+Bo7cju0e6VhVv+sORJkrKHMI2LQsjq4tRTar2
         hxRA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770318244; x=1770923044; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UTcUAmNhDbXfJ1YkCH2MncVbNEMdAOiqZyjVuJUmYMI=;
        b=QMDa/Xk30DRKgmkdkkEslf3SM1xGEWJjjS+zzBpbP8CNWmxaRpfi5A9hzJQ/WJsL88
         eyFehtYhrd/s5V9Mz347pl9uzIbelL6799QNMsUWZS5x76AizUe4PeAm2iDDtWxB2PK4
         jOGvaCVwz1C+Le3ooI97AquLmMVt7xTIo6gPRDQ4K/8jajS1uaTSHMNHGBxfdlUasrbC
         pfZQME4OJFMTTsVlx75v6w7rFosR/KSpscSicbCia3GbHw11hFisi4ED3GLpQ8VnO9mb
         2MN/ZfD5yrA4oDeGLzTtWZzGbjJ5TtXYJXPswFXVi70hre19XUR+3nN2Vx9JL6qZpWPw
         wL1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770318244; x=1770923044;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UTcUAmNhDbXfJ1YkCH2MncVbNEMdAOiqZyjVuJUmYMI=;
        b=gPkn2FwwA7AQG8UYwKSkm2vAjY6xBZ4NRvf/92Ywe1u/d0uIfDL7WGB5pNyRSobQEi
         8keh84icNX1QZTfNqdfxn4cJgq/uKjbLrc004WCFrNH5HCqEf9eMvGfDZiwhAJ4VOWhW
         0+dZ4Baa50mOXLmvQtE8UkBX1h0pd9u17scQoWu2fBE+rUdSH++YImdANtqvilroye/a
         4ABIWDp9m8GRfASOWbFwAxzEMtBTHhYsVtUXBiaPSpD2QBzuCfGPAMsVyzMuT+DsPkmW
         Rr77AL0okZu1i4gb03scPPw89SfsfjGHIpyxrYCTwmtO+kEwQu5eYipgCHdXqC6m6RwE
         cdTQ==
X-Forwarded-Encrypted: i=1; AJvYcCWEg+kkr/Em8lt++VPoPSF2QCdtWIkiul7ufgk/kd97Hdwszrn5p/B9IFby8mw5dSL6sQnCtPbxDuaT@vger.kernel.org
X-Gm-Message-State: AOJu0YzzL58MiviQgCgr5kCCmvH2LK4syat4HftkERe3d1FFgx2mZzKc
	ZMuo9STCf6XOMprDSoTnzDsHCxSp1kUXdieHv0L0YBCTEtmkpmKp2hFAC7C3fWlnhCMzPeE/sl2
	fXwDEkh9dj2jheI4+vKwO4naM7ifZmmw=
X-Gm-Gg: AZuq6aKW4JBwyIr3tBc3bn+uGqRgk49upR7FEIKf5KGazhsLietX5WkgO8N5aRlNz1l
	iWYSD/1lDkPwWS2ZXagoO7nELX/y/x+Dbw2XrHZd/uDYdtDItbQSo9IMWTWr7YWKdM5VVGvnSDy
	dwF5X+3HBJyd9LBXo3u1uiGDzy7YrFQkk74Qsh8xaZWz4Bij4ncyLTsj6W8OX3HHf3sTWv7GBU6
	xmJSFqhtorepR5oPJP3JNGl6hQrYi/KC2ZqZ4wKTn+sb1gmud1UHmn6OgRx5v7rjJUgX1YjDu2H
	QDdtVcMwuX34DQrpkySaV6OUyF2X
X-Received: by 2002:a17:903:32c2:b0:2a8:fc90:c8b7 with SMTP id
 d9443c01a7336-2a9516299a0mr3095915ad.19.1770318244425; Thu, 05 Feb 2026
 11:04:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <28a1e36188b1a84193ef2d78f12ecbc0e43ae7f1.1770042461.git.lucien.xin@gmail.com>
 <20260205115423.2195277-1-horms@kernel.org> <e9b073b0-60b7-4a45-9b6d-85c15b51fb4f@redhat.com>
In-Reply-To: <e9b073b0-60b7-4a45-9b6d-85c15b51fb4f@redhat.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Thu, 5 Feb 2026 14:03:52 -0500
X-Gm-Features: AZwV_Qjjs7kCqix60p3yMSgDkQ3vg6ybhk9GbXkeFBD_k4Da4kanmC-HbStnhiw
Message-ID: <CADvbK_eFXJB-JqL7w-50Jb=GNzzmSFD_cRGSmRscZ2Hq0o=6ZQ@mail.gmail.com>
Subject: Re: [net-next,v9,02/15] net: build socket infrastructure for QUIC protocol
To: Paolo Abeni <pabeni@redhat.com>
Cc: Simon Horman <horms@kernel.org>, steved@redhat.com, marcelo.leitner@gmail.com, 
	aahringo@redhat.com, alibuda@linux.alibaba.com, jbaron@akamai.com, 
	hare@suse.de, kuba@kernel.org, tom@talpey.com, linux-cifs@vger.kernel.org, 
	daniel@haxx.se, quic@lists.linux.dev, jlayton@kernel.org, tfanelli@redhat.com, 
	dhowells@redhat.com, linkinjeon@kernel.org, hepengtao@xiaomi.com, 
	pc@manguebit.com, kernel-tls-handshake@lists.linux.dev, 
	illiliti@protonmail.com, xiyou.wangcong@gmail.com, 
	andrew.gospodarek@broadcom.com, mail@johnericson.me, edumazet@google.com, 
	matttbe@kernel.org, netdev@vger.kernel.org, smfrench@gmail.com, 
	metze@samba.org, mbuhl@openbsd.org, chuck.lever@oracle.com, dreibh@simula.no, 
	davem@davemloft.net, sd@queasysnail.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 5, 2026 at 7:48=E2=80=AFAM Paolo Abeni <pabeni@redhat.com> wrot=
e:
>
> On 2/5/26 12:54 PM, Simon Horman wrote:
> > This is an AI-generated review of your patch. The human sending this
> > email has considered the AI review valid, or at least plausible.
> >
> > For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-lo=
cal.html
> > ---
> > net: build socket infrastructure for QUIC protocol
> >
> > This patch lays the groundwork for QUIC socket support in the kernel.
> > It defines the core structures and protocol hooks needed to create
> > QUIC sockets, without implementing any protocol behavior at this stage.
> > Basic integration is included to allow building the module via
> > CONFIG_IP_QUIC=3Dm. This provides the scaffolding necessary for adding
> > actual QUIC socket behavior in follow-up patches.
> >
> >> diff --git a/net/quic/protocol.c b/net/quic/protocol.c
> >> new file mode 100644
> >> index 000000000000..6ab81f1c50cc
> >> --- /dev/null
> >> +++ b/net/quic/protocol.c
> >
> > [ ... ]
> >
> >> @@ -0,0 +1,369 @@
> >
> > [ ... ]
> >
> >> +static int quic_protosw_init(void)
> >> +{
> >> +    int err;
> >> +
> >> +    err =3D proto_register(&quic_prot, 1);
> >> +    if (err)
> >> +            return err;
> >> +
> >> +    err =3D proto_register(&quicv6_prot, 1);
> >> +    if (err) {
> >> +            proto_unregister(&quic_prot);
> >> +            return err;
> >> +    }
> >> +
> >> +    inet_register_protosw(&quic_stream_protosw);
> >> +    inet_register_protosw(&quic_dgram_protosw);
> >> +    inet6_register_protosw(&quicv6_stream_protosw);
> >> +    inet6_register_protosw(&quicv6_dgram_protosw);
> >> +
> >> +    return 0;
> >> +}
> >
> > Can the return values from inet6_register_protosw() be checked?
> >
> > Looking at the implementation, inet6_register_protosw() returns int and
> > can fail with -EINVAL (if p->type >=3D SOCK_MAX) or -EPERM (if trying t=
o
> > override a permanent protocol). The calls at lines 234-235 don't check
> > these return values, so if registration fails, quic_protosw_init() stil=
l
> > returns 0 (success).
> >
> > More critically, quic_protosw_exit() unconditionally calls
> > inet6_unregister_protosw() on both structures:
> >
> > static void quic_protosw_exit(void)
> > {
> >       inet_unregister_protosw(&quic_dgram_protosw);
> >       inet_unregister_protosw(&quic_stream_protosw);
> >       proto_unregister(&quic_prot);
> >
> >       inet6_unregister_protosw(&quicv6_dgram_protosw);
> >       inet6_unregister_protosw(&quicv6_stream_protosw);
> >       proto_unregister(&quicv6_prot);
> > }
> >
> > If a protosw was never successfully registered, its list field remains
> > zero-initialized (NULL pointers). inet6_unregister_protosw() calls
> > list_del_rcu(&p->list), which with NULL pointers will dereference NULL
> > in __list_del_entry() -> __list_del(NULL, NULL), causing a kernel crash=
.
> >
> > Note that inet_register_protosw() returns void (cannot fail from caller=
's
> > perspective), but inet6_register_protosw() returns int (can fail). The
> > code correctly checks errors from proto_register() but not from
> > inet6_register_protosw().
> >
> > Should the return values from inet6_register_protosw() be checked, and
> > should the cleanup path track which registrations succeeded so only tho=
se
> > are unregistered?
>
> I think it's easy to infer that that such failures are impossible, but
> since a repost is needed please drop some sentence in the commit message
> to help AI see the point.
>
Will do, thanks.
