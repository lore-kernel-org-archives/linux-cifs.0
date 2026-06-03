Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C99A43E9FD
	for <linux-cifs@vger.kernel.org>; Wed,  3 Jun 2026 14:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780496080; cv=pass; b=q2bw/MagTt9Ss3/DHkeqyG49oVVM+xRoi3i7M/xNLwZCP9Qz+jtH84IFcI3qDL8EkLrucPcTKGaxamAXs6aK1+kwAjCRFsBbExj7/x+L7xAAdY3oBNl9/5fAfSXyb/oBiB66wxagorfgrSwMVss9A90RAyQuKFZQxPBW2XhoY28=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780496080; c=relaxed/simple;
	bh=GVn5Lv9HKRp9C9WqvkbPPVBvO9kfeaXDD5rNKVVFxPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Zy6PZZ7QI/5OryUrKtcCxnEax58flU+JhfugwxBBoeihbgCtJbr+SjChC7V3/a7/tUmU/KqEHQmsHZEk6jg4uRpj7fx0mTwez7JUpcrAiGIM65rMy0O1czdjfDPk2cfRHKF9dd5DIBUHZ032SiDcHg6iTekNFSxl6rTpXhDs+JU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ChEbDLU+; arc=pass smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ChEbDLU+"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-842319576d5so2081820b3a.1
        for <linux-cifs@vger.kernel.org>; Wed, 03 Jun 2026 07:14:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780496077; cv=none;
        d=google.com; s=arc-20240605;
        b=jPxI0H83G2lHPxmkBuGEHHe7WiUcVVz0I+bjzj9hF+WGFanzHYQ38EvY51Yz9hXvSc
         buxgDy4sbEcDJ3rrp+RL5h3Yim1BXAx1hbNhxSSC8/t4BGhEtfMWtuYxN9zdlcoz1V7V
         Iz/VrLl8l3Z6VopalSRFLJ1dSz4b3fMOgO8n872vwNK597Lwpkfjy6ZCYM9O11YoPl33
         NJgw19hGdEricA79Vv/jJ3flwuX9KRYOA8E+BXMZfZmiKWFH2UvJuEflaJjqRtgDOjVR
         OQmoDRV3JCSVEVkWThhKwArN6Kacrv+SjZDvbWFIPDZ1oUci7I7yWOl14jCIf69FaKdR
         bzLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=g99l8PDbJRSNZV5R5cNDHmMYBg+Zr6LEVHFcaCRVgy4=;
        fh=OOLtf8TwBrEMg3CMVH+w4suAdJTA7FdSIJ0lEG6qRhA=;
        b=TtAWulaIvC8KaRpT2hQY/ETsSzvYlNfLmCgAHWbNjfxLvskl61gC/XyjpM7eX4kSq0
         15YJQ75AVzU1mcNo4CjdHZCZMD0opmOvpL7ADVMvVgXeUc5K3BNSnzjAWBTk4AtVUpAN
         QZ8Q9oY377dw9ngCs68OZDifPC6YUhg9wTj+njfpoOaqHu1BNa2AbWKjtQXUN+n0E03o
         d5AOWICE+wMcXFplRtmDDfOq4qkbruRU/aEDSxyVRMxPAUOlecSJsbH4SdxdvuGvffSj
         C7p2yDNseRFhkVrMYZgTo+gnXovnDfUBYEfDQIEkTg/RwLjHUpymrjRpb6s5YE7FDQ5m
         pvsg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780496077; x=1781100877; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g99l8PDbJRSNZV5R5cNDHmMYBg+Zr6LEVHFcaCRVgy4=;
        b=ChEbDLU+Gbhog2WyQkkdBzqDo/wKb/dfJ60DPFTd/dxmv+UtYSTnxjC1TK6WeYXxuT
         aeqDQ/G3V/eHm5azlhzqxhB5KRJJv5VGm4ypxBDxICkmts6kgE7ws95F3XvG4BLRVEDw
         /01FhU4vUEc1RaPrsQObQ6vRZL2lWztlZESwdoE7tm/nbSFbEu+6XyiZ5I84Qz/a5/3Z
         dcRyzt7tRkxH/8XfeAJH9UNlWgFjcNI35MOGXDwaAW1McZqwEVmml7iL7NVOt260tnXO
         Y3+KDn4RJVpG8NUrHtY1YDHDc4T2ioyu129BycXQMjzif4GTi1ZZn69SzoX+VERMhLKe
         6/EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780496077; x=1781100877;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=g99l8PDbJRSNZV5R5cNDHmMYBg+Zr6LEVHFcaCRVgy4=;
        b=dglpdZbJxeuFBtoV9GC1FPIljT+wQQuTy+ckXBG/CKsJUZ3hSW+8i7Wb14OWBSwL70
         jp4y04DktL09bKxoEOdH9WHYu9mZJqaYx5PWGDw8J9F6Vo2EBI/NZaGKGP9AjRlNLKx/
         Y1lkSNalc8mY/hgQyITDEGA2JfOTnZN7sN2XSngnF1uTHCsHpHHwewbCQGIivbtPj05h
         SGer93yY69tJ+92jg/zhbqppzxQAmWx/XfaGtMjWb8zc5EQakSgdkuExhmyTaT96xgr/
         gNP5QG7ODGf7MG6v+UeMDbTMuPSf+3prOphatLZBXp/ACLUT7ZjeyO+5WSSBlPkIMdL3
         qYtg==
X-Forwarded-Encrypted: i=1; AFNElJ8jeRDIcIZ4KhrjrVOq0fCxaklIFiXIirov+1Z+DZMPKfDtifnqkw42WQBTrpLcgSkLFAiIrd3yBZNg@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/dS0yXm5wGemSga2/SrWiZ3+pN1Bi4zgnnwfdOJOImkZND+R/
	Jtul8n6biLzdlJJbDaL69VbZ0g8sgNOsHnSTbjgwiMtzTe0VWhcImwWZTL4cnlRcoAfiGBDZXZN
	c4JtjeGuzW/GSC45NE+rJlNE21gxToTQ=
X-Gm-Gg: Acq92OGgCVCF2PnXyC1Wg6fI2jQTbhQQ97Jl8jGuOfLmsgIhbm/v/V6JErXEpN0vB0y
	4p37upyoe4F4BLJdxkybsPB+Bx1hjvCCcatKq5l6Fix/p6KeqYfNOpe+dTPJE5Z1sWlh5wNWcuc
	UaJmYMPy/qBTEL4UIU6hLsGMvZQZ+2iv5YNTPUVak5Wz7dixbSuJ/TxHVla9eEGofDjFLZBlRNK
	CChBPK2tW8ZtQUy5q77x+JunhsFNU3qoZkarvOMuMgQK8W3KilfwuHLd6oJnAwrZSVjYTFkYXEL
	xFXqUxw8D/QYOdoLD95gsRtrDSZUdfr+r8hApok+vzoZRgsKbZ2tiQ9i96mitR72YUgGE1ef3yS
	mc7i7gLU7tVBhQ3Ip3WH8GLn3S1v0jyIWFll+MfYH1jNsTGAR
X-Received: by 2002:a05:6a00:1491:b0:835:366f:5da2 with SMTP id
 d2e1a72fcca58-84284f3f96dmr3416839b3a.37.1780496077086; Wed, 03 Jun 2026
 07:14:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1780232930.git.lucien.xin@gmail.com> <CADvbK_fBbLCwY61HXsNeGCA8MhiBKcbvE0BvSZppohJgtXO+2g@mail.gmail.com>
 <20260602111823.0b1129d6@kernel.org>
In-Reply-To: <20260602111823.0b1129d6@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 3 Jun 2026 10:14:24 -0400
X-Gm-Features: AVHnY4LQ8snWAMk7idEx52eDDVjzE-lgA4L_Uyr30iAlUILJ8Ee2UHGsNH5YNQ4
Message-ID: <CADvbK_e7T=Yfb800TbO+BcpDEp=Sf6rbtiy2daLaskFAjeg=Ww@mail.gmail.com>
Subject: Re: [PATCH net-next v12 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <chuck.lever@oracle.com>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 2:18=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Tue, 2 Jun 2026 09:12:30 -0400 Xin Long wrote:
> > Note: I've run Sashiko on this patchset many times locally over the pas=
t
> > month and addressed all the real issues it found. I don't see any new r=
eal
> > issues being reported on:
>
> Coccinelle had a report tho:
>
> The NIPA CI coccicheck run flagged a new Coccinelle warning introduced by
> this patch:
>
>   net/quic/crypto.c:1164:13-20: WARNING opportunity for kmemdup
>
> At line 1164 of the newly introduced net/quic/crypto.c, there is a
> kmalloc() call immediately followed by a memcpy() into the allocated
> buffer.  Coccinelle's memdup checker suggests replacing this two-step
> pattern with a single kmemdup() call, which is the preferred kernel idiom=
.
>
> The fix is straightforward - replacing:
>
>   p =3D kmalloc(len, gfp);
>   if (!p)
>       return -ENOMEM;
>   memcpy(p, src, len);
>
> with:
>
>   p =3D kmemdup(src, len, gfp);
>   if (!p)
>       return -ENOMEM;
>
> Please update the patch to use kmemdup() at that location.

Will address it in v13.

BTW, is there a public link to the Coccinelle check results?
I don't see them showing up on Patchwork.

Thanks.
