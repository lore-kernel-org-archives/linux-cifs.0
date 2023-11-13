Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E7003398E
	for <linux-cifs@vger.kernel.org>; Mon, 13 Nov 2023 22:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARwDo420"
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E5B3DC;
	Mon, 13 Nov 2023 14:23:47 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id 2adb3069b0e04-507ad511315so7145327e87.0;
        Mon, 13 Nov 2023 14:23:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699914225; x=1700519025; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z2WWxIDUsdHp0wXasuKRqlZ64Nw6Dyphc54R0vg6D9Y=;
        b=ARwDo420sn+2OTwmVzcX2EefS9c4fbP83imQbd8UkyDzpbeYmB5EgI6/yEbmvH0j4m
         wg/IMTlG68gpYbGnhe86OdP08zuZHI2eaMFCx33eOv8mXKIUy1LHm7XYJU2ix/sKfz7x
         QvKwxClZvAjWiClRwbGeln9Og5Ioz3MCVyYBu76zF6QThR+iQaFeEXFpYuZjpnqgZ3i1
         ofhfhHPAJArDWZKOpLGUNKKTFIRR2gy/8ZIxg6hwXtSHU7eMhgzCy252YWX/20jGViyn
         qTZnF2jMaFjzD8wlZTFEYrHsLpDAt+7cgF81tXDGLPA3xqydPZxZIzNxbo559HLMjOSt
         2aKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699914225; x=1700519025;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z2WWxIDUsdHp0wXasuKRqlZ64Nw6Dyphc54R0vg6D9Y=;
        b=XEQ7CGWUJaC83PkAFrn72btUUs/VcfE4UbcDSxt5REP0iUPnCDQTLzf3OhInS+ByaD
         qMGw7ZAfZeNmUZxMUJxKHw/w71GsbNYK59ZD56ouEU411IKd5akwnVOmYz3KDoqLPjoO
         9hzne5Etijk1YezLG+MPxkJQ2O1KEgWAD5/gX9yE+iH7ug8o9cQNxAtlSk29GO4VBCrO
         TE+kL8+eCNqjcPg6/um1vJhzoHWAc1EasY/7Evwxz8jBO9d9wGMoZmQhd9H2CPCX6UPF
         hPhJZccjbbNl7rLDqIlVxiF2QKVx5jEsRTPESesm1914ITrBjAjWo4aH4ZvYTzqzuSCv
         5W3Q==
X-Gm-Message-State: AOJu0YxRvh2eUsvhSShC6ZG7jDNyhrQbFDKJE0wQmTjcZCF2E/Jwkdtx
	g9wNUzPEQwCvr7JjXtpLs9+3T+32kwgW9LjMP4E=
X-Google-Smtp-Source: AGHT+IHcKruz1Vla5I9USOC6Qahqw9agqD2FOZVIx06sXye6LIqqJxk5vOu+344DzzDXRF93Ba1LsdoyD0BQJ/gVvWo=
X-Received: by 2002:a05:6512:238b:b0:50a:7575:1339 with SMTP id
 c11-20020a056512238b00b0050a75751339mr5952741lfv.18.1699914225580; Mon, 13
 Nov 2023 14:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231113145232.12448-1-abelova@astralinux.ru> <05bfafca49fbed96ea500c25a0606205.pc@manguebit.com>
In-Reply-To: <05bfafca49fbed96ea500c25a0606205.pc@manguebit.com>
From: Steve French <smfrench@gmail.com>
Date: Mon, 13 Nov 2023 16:23:34 -0600
Message-ID: <CAH2r5mv+ntKVtzx+9ooYPJna7R0=ovsZid9EghwW3pzi5G4+Xg@mail.gmail.com>
Subject: Re: [PATCH] cifs: spnego: add ';' in HOST_KEY_LEN
To: Paulo Alcantara <pc@manguebit.com>
Cc: Anastasia Belova <abelova@astralinux.ru>, Steve French <sfrench@samba.org>, 
	Ronnie Sahlberg <lsahlber@redhat.com>, Shyam Prasad N <sprasad@microsoft.com>, Tom Talpey <tom@talpey.com>, 
	Jeff Layton <jlayton@kernel.org>, linux-cifs@vger.kernel.org, 
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, Ekaterina Esina <eesina@astralinux.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tentatively merged into cifs-2.6.git for-next pending testing

On Mon, Nov 13, 2023 at 12:11=E2=80=AFPM Paulo Alcantara <pc@manguebit.com>=
 wrote:
>
> Anastasia Belova <abelova@astralinux.ru> writes:
>
> > "host=3D" should start with ';' (as in cifs_get_spnego_key)
> > So its length should be 6.
> >
> > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> >
> > Fixes: 7c9c3760b3a5 ("[CIFS] add constants for string lengths of keynam=
es in SPNEGO upcall string")
> > Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> > Co-developed-by: Ekaterina Esina <eesina@astralinux.ru>
> > Signed-off-by: Ekaterina Esina <eesina@astralinux.ru>
> > ---
> >  fs/smb/client/cifs_spnego.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
>


--=20
Thanks,

Steve
