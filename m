Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59B83314D5;
	Mon, 18 Aug 2025 18:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755542239; cv=none; b=D8eTolGNCueEaw/j+FBmgg4+y848EMIbft/fC/p2mTBC2IAcCDYTNxAxmABazgLf73GVjIS6lCvsRSoRBl6sy7xEwqVO3VNZF4WX6p+kz/4a1YRaDva6hm8YbsgzrSEv8U8uQXbcy7Q3v+pXvJIeYKG4XzXdff/ryx5Rv1fHwMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755542239; c=relaxed/simple;
	bh=s+h/zpdcLO2sufU3UTB1WVULDoAddfqD9Pkjy5KuALY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kJ6deW49ib5iuRnkpyRZQ1HsBx1QwyTwJ3SKVceowfNglrnN4Iso8uYqZBgTRIjPXHl54kcMaal2d2qhRTkwNfdeefhdt93gsG8zKwOqEo7+y4Qoq1BUysFR8igxfB+tWjURyH6VJdHw6C6JWVVo7G4OV4qHIF0vpGqzKkLFBdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBHIRF+K; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBHIRF+K"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3e566327065so24727855ab.0;
        Mon, 18 Aug 2025 11:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755542235; x=1756147035; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l7NhKU41/8jq0SdZcC8/fNpL86G4XGs3Ymmr1MZpRjc=;
        b=aBHIRF+KkQDgdKkNEGFVrBR+XEtjjdbggkxq4ppPRLD2ElwHymh//Y2P79FfvlSo8t
         hqYgDAVPLJIDtLTYw+GXByLPzjQs2Nd6OVUWXX7xQrMa+pvsQWW2167SlKQ5ANmd3OIJ
         Bfy/IxQH7RhIbnBegG/VypgWh4mQmyHI2KWkL8E+OdSIK5QeOENzbetfXaU7TohOKII2
         JwKEJjQDF06h+n8SlUTRNql5jNl8uB30iEtv5YmTu+cLqQvQL0aTa7bhqqBBX3EV62sI
         4NFpNPTHRgPxJ/JmK5EMCQ+9xo9en1jyDb3ibpeYtghpEqbXQt2xcFRNl/eTO8vwThQx
         Vqgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755542235; x=1756147035;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l7NhKU41/8jq0SdZcC8/fNpL86G4XGs3Ymmr1MZpRjc=;
        b=TsUrbGzAiDFmtv2Ud0owrXZpvfoS1/ThK2R0t4dNQ3BBr+zfhyhUrvrkoIgvSRKg9v
         xJkh06YNFzIkU+iopwe5JdkaD10cDxBDJ/s7tzXRUXwj2Dm2zpwmRgA5hFIf7lLs2igp
         E9lBVpDp4YiNsBasQbJ/8gzPasQyVilINDVplAPUybDYP2MeS8D7JnDmkKFOV64fxI4x
         ugwMKbTaNisbfU13th3UEGX+10KNRlEnnOlEwGVAIDH/wrExlXEz+qKSNgxxVa00a1/y
         okrgKq/76bNOgXYUIBNsyYTwaIpR9lBQABOb5G8u+41R/v1OsqTqvj9O00ZInyt1MYaA
         7zWA==
X-Forwarded-Encrypted: i=1; AJvYcCU0l3VvIgaqE2hHwYb+6/oZ++CWI4EoaFPk8c2cpOhwU8/HvSsPPkOVGzw/1QC8gNsaDdRrF8BI@vger.kernel.org, AJvYcCV0ytZeRoiM8SqvP/XjWA6Y4J3bRWFMMX2dXT6/ZiX7TIeFB3vCRyUeVLMC74MNEq17bJaUHqRPod+y@vger.kernel.org
X-Gm-Message-State: AOJu0Yyjdo78YdrGhl6O4FER+3vdKF78+vXqtkeSfl5N3EDPqacAJbN7
	MqA/nQaNiGRAkO/H5gkNnerW9z41nhs1PkAT7D2+CfmsDpxAUXTMOuHK9Q+DL2zbiVgIs+iaqcL
	5AQ5XQWb9RD2dggypxv6fmzdXwl9EDuY=
X-Gm-Gg: ASbGncsUhWPI0oeoKbNjGfFE5O3Bss6FUGkagsxRK7KugrxMad9okWcjO3lQHiGZdVL
	4XfItFRREkZZ5TozPD6KEfLc7bq+Zyg/2h1jkdDlvm+fVhRbFoGr7FRHggYZ+rGgpTB79D+ro3Z
	HVbZwWg0NlhC1Oj6/g+z2IE+jF6iiV+93lUxsJHAr3pRSHj84Hh59mWFYbP4X7Jd0rc+xrvMDO3
	HE9CLkqWXUCBF6/dSb+
X-Google-Smtp-Source: AGHT+IFp/eqRpxZrpvX0+FdFTm9XYzuEaxMNWfFdXQBOq53uvPeyc2lisbJohLLKbeqhWF3vjCt8PfLqxKmdZxE8ZEs=
X-Received: by 2002:a92:cda3:0:b0:3e5:52a3:daf9 with SMTP id
 e9e14a558f8ab-3e674fc671dmr11528635ab.2.1755542234757; Mon, 18 Aug 2025
 11:37:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1755525878.git.lucien.xin@gmail.com> <50eb7a8c7f567f0a87b6e11d2ad835cdbb9546b4.1755525878.git.lucien.xin@gmail.com>
 <5d5ac074-1790-410e-acf9-0e559cb7eacb@samba.org> <e4167710-3667-497b-b12e-096fd06217d9@kernel.org>
In-Reply-To: <e4167710-3667-497b-b12e-096fd06217d9@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 18 Aug 2025 14:37:03 -0400
X-Gm-Features: Ac12FXyEgNTxVIoWpY0UM5RyDGnPhjjnR1Tzf70bDhn5xnUoI_HCY-n9PLVqlRU
Message-ID: <CADvbK_dztN+x1-M6L841X-JROxrQYh=ENQJC_E1TbcPXErkHSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 01/15] net: define IPPROTO_QUIC and SOL_QUIC constants
To: Matthieu Baerts <matttbe@kernel.org>
Cc: Stefan Metzmacher <metze@samba.org>, network dev <netdev@vger.kernel.org>, davem@davemloft.net, 
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Moritz Buhl <mbuhl@openbsd.org>, 
	Tyler Fanelli <tfanelli@redhat.com>, Pengtao He <hepengtao@xiaomi.com>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, 
	Paulo Alcantara <pc@manguebit.com>, Tom Talpey <tom@talpey.com>, kernel-tls-handshake@lists.linux.dev, 
	Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
	Benjamin Coddington <bcodding@redhat.com>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2025 at 12:20=E2=80=AFPM Matthieu Baerts <matttbe@kernel.or=
g> wrote:
>
> Hi Stefan, Xin,
>
> On 18/08/2025 16:31, Stefan Metzmacher wrote:
> > Hi,
> >
> >> diff --git a/include/linux/socket.h b/include/linux/socket.h
> >> index 3b262487ec06..a7c05b064583 100644
> >> --- a/include/linux/socket.h
> >> +++ b/include/linux/socket.h
> >> @@ -386,6 +386,7 @@ struct ucred {
> >>   #define SOL_MCTP    285
> >>   #define SOL_SMC        286
> >>   #define SOL_VSOCK    287
> >> +#define SOL_QUIC    288
> >>     /* IPX options */
> >>   #define IPX_TYPE    1
> >> diff --git a/include/uapi/linux/in.h b/include/uapi/linux/in.h
> >> index ced0fc3c3aa5..34becd90d3a6 100644
> >> --- a/include/uapi/linux/in.h
> >> +++ b/include/uapi/linux/in.h
> >> @@ -85,6 +85,8 @@ enum {
> >>   #define IPPROTO_RAW        IPPROTO_RAW
> >>     IPPROTO_SMC =3D 256,        /* Shared Memory Communications       =
 */
> >>   #define IPPROTO_SMC        IPPROTO_SMC
> >> +  IPPROTO_QUIC =3D 261,        /* A UDP-Based Multiplexed and Secure
> >> Transport    */
> >> +#define IPPROTO_QUIC        IPPROTO_QUIC
> >>     IPPROTO_MPTCP =3D 262,        /* Multipath TCP connection        *=
/
> >>   #define IPPROTO_MPTCP        IPPROTO_MPTCP
> >>     IPPROTO_MAX
> >
> > Can these constants be accepted, soon?
> >
> > Samba 4.23.0 to be released early September will ship userspace code to
> > use them. It would be good to have them correct when kernel's start to
> > support this...
> >
> > It would also mean less risk for conflicting projects with the need for
> > such numbers.
> >
> > I think it's useful to use a value lower than IPPROTO_MAX, because it m=
eans
> > the kernel module can also be build against older kernels as out of tre=
e
> > module
> > and still it would be transparent for userspace consumers like samba.
> > There are hardcoded checks for IPPROTO_MAX in inet_create, inet6_create=
,
> > inet_diag_register
> > and the value of IPPROTO_MAX is 263 starting with commit
> > d25a92ccae6bed02327b63d138e12e7806830f78 in 6.11.
>
> I would also recommend not changing IPPROTO_MAX here. When IPPROTO_MAX
> got increased to 263, this caused some (small) small issues because it
> was hardcoded in some userspace code if I remember well.
>
> It is unclear why IPPROTO_QUIC is using 261 and not 257, but it should
> not make any differences I suppose.
>
I agree, it should not.

I wasn=E2=80=99t sure if any other project was using 257, so to minimize th=
e risk
of conflicts, I=E2=80=99ve been using this large value from the beginning.

> Note that for MPTCP, we picked 262, just in case the protocol number was
> limited to 8 bits, to fallback to IPPROTO_TCP: 262 & 0xFF =3D 6. At that
> time, we thought it was important, because we were the first ones to use
> a value higher than U8_MAX. At the end, it is good for new protocols,
> not to increase IPPROTO_MAX each time :)
>
Yes, this approach saves a lot of trouble for new protocols!

Thanks.
