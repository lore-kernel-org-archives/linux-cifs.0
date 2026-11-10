Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794329881;
	b=RoPpWFJ7xGSHwK2ogmp/C7o6ecn8S58G7BgYRl+1S0BZV53BlXMRdv7y0Qn3w4vScZ/8
	 LfDxj3MBA0mh0YDaCiyuYhXvE9lKUVb2qSpWcp6VDYP2cH8WpRNcbuFGaFHGhiN8sUqBx
	 eb7SfiD3ZTe3sA9RJbkl5IW0q3Gpk7jrLcBWc/BgvfTLQzkM53ePfGQ1BD0/yNrF4y6vJ
	 OTvo0EM0NKc8CuOfZL3MpWG62S73L1simYt8d10t3UGDlpb4nTKyOCgiOG3l9uDuCogiu
	 nb18CCa38C5mex46tsAfX3cLi533WKyEde+FGY79yXo/FH/5ccbCOu4ZHsIJaSqov1g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794329881;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1HlRMg2f8VT1EI4K27T8+cqMdE7ojzLtyN9VMRiohws=;
	b=SrrJxexQkyT4qp36+MhACwcu9lCnvsQgkNf4UBUhkBVvDyCDVZbzwWd5mqgUvhOD3b0i
	 VFG4RZz+qn1Oah6rNyM9+2RZQYpOzTJOM8q0LyGaHYJ7s2VCNrElPeKC/VgKGMOnvA4cb
	 XbZXgFiVfOKvYGy/qUsd4Me6yxToFJGBPR0ABZjoQa+zQpOqQf7lbpEOcUna6UGH5RZNT
	 L/R/21VVG3gQHRRDbGPOob1sgx5zadDWPajHhnyvsTC8ie5m4jrf1oNEqiUMIOnWQ93jy
	 MwrnlW8b+hmfVV770jhMdnPE77X7Gvb6vyAcNAtVfyvTZkX5YbDaNEppp/PEPVGzBYg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8iT54ru;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.182
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43F5606A837
	for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 16:58:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C43F5606A837
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=t8iT54ru
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-cd69954c755so1590164a12.3
        for <linux-cifs@vger.kernel.org>; Tue, 10 Nov 2026 08:58:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794329880; cv=none;
        d=google.com; s=arc-20260327;
        b=juv/2NpEmrq38YBW3YqhULW5TTEQW+iOM/PLHdjnZei0ERXKtZvujDkpBYyep01LsZ
         agGdpwifrFX0kynM+kD5JeNMrCeNfHJbzO7jvOwEZma2dhJ8P03QGIZEske/EeAQ46LJ
         mQ81r2P8jITECL+h2AvfudAzHL7Kz1r3uvPcpl/VMmDOhSBEEDGHVw15P4SdbfKQD7BG
         6RNyMwqCZ2gF2TpkGmB17JFcclDFam0kEjpG7HSgsehk5v32kTyuFmngADgOioYbIDbV
         s4MEsObdG6JdBL6hfnZNupVxbt8ey8KlXWOyW3gY35Cs0eWpQHnE1zbZGJApEt7/2s0R
         htvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1HlRMg2f8VT1EI4K27T8+cqMdE7ojzLtyN9VMRiohws=;
        fh=yHOVUp3q0TByAkOdArrB55hzHBQ1VDM1hag9PG2MXig=;
        b=Lqlg/1Ji/X+fiGWSmOEuClHWcqaj4nTB4XQIJatmf/KlXvuT3a5+BH4SkicQ75BCrv
         7uItDo90Xww/6see5wIFe0EMs5HtRrqI8wsI6VfnZ/OTiDgE6ieLdjHyUzy9VlQnvsUw
         6w9PdCpULukZ2Gpq6MzUdrna0nIQMIU9KSac/smKYGf8SWNEcl9Wkzx3Nl438pcSflA3
         hvtucXeZLwpX5At+akC0pva+c9zElCa+iUhJjYaUKmyDhW7cEvKOrYvBH5u5daYaM4/d
         sRjzPIfP5B08CBlEaoxwAs8o3/DOdR8eljMDXNbAYfqbqumgSvXlyVmkwUL9Hfdiopqb
         bXgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794329880; x=1794934680; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1HlRMg2f8VT1EI4K27T8+cqMdE7ojzLtyN9VMRiohws=;
        b=t8iT54ruLSMY3csAPAgojvVYw8cwh2154xKRj95sLz8EdPdBZx8f41EcmmLGuC1F1l
         ElLJg1Coj8V/Ns9BmZZDFhRsax5ulWClrHftzpsakovCHNkHPvpuPf8qyGPMEvS+ZBpx
         /8pV8ycjMItO8GluGRwVeuxn5Niim18numJAMJCOkn2GtDYz8TXf89kGi9r++cn8vuAx
         pUhime1PYdjP5LkIeHAA3e/gHsvVtzNNo30B7FiujRhOh3tTqAzd98atJr4QoUaBJFsF
         lyo11wt0d95LzOafUNNzZOifg0sIxvglqaOuSTlWwJc5A1Bs05wNjJEnYABaNIonOyUI
         V+OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794329880; x=1794934680;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1HlRMg2f8VT1EI4K27T8+cqMdE7ojzLtyN9VMRiohws=;
        b=CneZKbUF+FOnD9yTx6ZJ8w8mT+tK13p6l6sNtJFL+hSoA7uUzRyix7cIVEP9ROr7Nv
         YQULp0h6uLGFx18PMLl5RS+asSCFPZDTb6a3ZR+lTPVrx5/NM6pHrqCxzBfqExC9+Tci
         gS+IbI8gkMKwz6VBZGXYWs0p17478fnZ1jRftgJ5r2LAB8avymS8MfW6HeU0ZfI0y44M
         kESSQaply5X3UoXaf7HxL8K5AHHuXNh2Z5d5hnopZl47/a+rCft01oCBmhsTFuCPxTST
         vhuGzq4IxO7w5aBXsmrvLEMwnmydWxSHV0UNjYp6fqVPqbeYNbGZQO3gf3PPmbs57i4O
         O4ew==
X-Forwarded-Encrypted: i=1; AL+hErH0FRmgckcfetSzRGL/55dYpRzK5noJspN8V4kDRQvqR+wkyFo9NF1wmGO4oZIvwgxtjYgVhm5/MccZ@vger.kernel.org
X-Gm-Message-State: APuU4Z936NZZO0WyKL79OvpMpGMuhB6fdphlZbPY9M5puo99QItvDLT+
	IL0I5KsMyroyjaRiI6oVbbF5el13+uT56YOc2qsmpRQ9aDuKWKxfIxjPh+fbWH8uZuya9Ddqbht
	b1cHEKYgzBD6rAxwiEp838IWM65Nzqd8=
X-Gm-Gg: AYBFou3MX2P5qcthx+WTL3Oo7BmvEdFL1tNGgE5/JE1kiVaef59Dqu7RILEa8gWKBAP
	saPoqqDVmkRDah3Ts13l46fZiqFEeYuQMdga/d3+ornSqvHcpnnMZq4ySxRikUZYHuSz3od7DLw
	dS5ZfUPekRQtrPKSlCEPAvEx/+H1/LfPQSjHVBUOQChJUx6647rAvjY9JmSvQfNSMduERn6T5zV
	VTM9HlGamH3dslYHDpi/TeyJX3jlUGaeTt5nDXsRuYgrb1NfIX8kddu6T08eYGSLNyMMnbjWs9T
	vqhaKvwWCOuggKdIPkjA5zvDWEBVFAilGoBFx1cyfBgGDUqhJQBHDJFy3CU3gvqL0qZ9xAF2Vuk
	C5g5TSwLeORh2Fchc8ziDuFwKiFqXPNqwN4uAHUI4v5fzTbD1dr5eXuTaJ2hEjlA1xLd3f4pETO
	jd9EO/bSWc9kNFGg7ATnG0a4BV4UHZluPf6p3u/w==
X-Received: by 2002:a05:6a21:4d92:b0:3eb:292d:6667 with SMTP id
 adf61e73a8af0-3f18fc7916bmr3102272637.45.1794329880120; Tue, 10 Nov 2026
 08:58:00 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <cover.1794241654.git.lucien.xin@gmail.com> <20261110074153.4b895bb6@kernel.org>
In-Reply-To: <20261110074153.4b895bb6@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 10 Nov 2026 11:57:48 -0500
X-Gm-Features: AclHuK_HpW_I6LMxVTgDVIWnA6pZgPm7vgrtWceSe67s1c1ZnBXYAOFgqXCnPVE
Message-ID: <CADvbK_e3aoDOyk3hbPtS8pk3U0QSiLtYafpH2oaoNbbR9mV9aw@mail.gmail.com>
Subject: Re: [PATCH net-next v18 00/15] net: introduce QUIC infrastructure and
 core subcomponents
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, Moritz Buhl <mbuhl@openbsd.org>, Tyler Fanelli <tfanelli@redhat.com>, 
	Pengtao He <hepengtao@xiaomi.com>, Thomas Dreibholz <dreibh@simula.no>, linux-cifs@vger.kernel.org, 
	Paulo Alcantara <pc@manguebit.org>, Namjae Jeon <linkinjeon@kernel.org>, Tom Talpey <tom@talpey.com>, 
	kernel-tls-handshake@lists.linux.dev, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, Steve Dickson <steved@redhat.com>, Hannes Reinecke <hare@suse.de>, 
	Alexander Aring <aahringo@redhat.com>, David Howells <dhowells@redhat.com>, 
	Matthieu Baerts <matttbe@kernel.org>, John Ericson <mail@johnericson.me>, 
	Cong Wang <xiyou.wangcong@gmail.com>, "D . Wythe" <alibuda@linux.alibaba.com>, 
	Jason Baron <jbaron@akamai.com>, illiliti <illiliti@protonmail.com>, 
	Sabrina Dubroca <sd@queasysnail.net>, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, 
	Daniel Stenberg <daniel@haxx.se>, Andy Gospodarek <andrew.gospodarek@broadcom.com>, 
	mef@scarletmail.rutgers.edu, paul@jakma.org, 
	Kuniyuki Iwashima <kuniyu@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 10:42=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Mon,  9 Nov 2026 11:27:21 -0500 Xin Long wrote:
> > The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transp=
ort
> > built on top of UDP. It enables low-latency connection establishment,
> > stream-based communication with flow control, and supports connection
> > migration across network paths, while ensuring confidentiality, integri=
ty,
> > and availability.
>
> coccicheck says:
>
> v:250:19-25: ERROR: invalid reference to the index variable of the iterat=
or on line 241
> net/quic/connid.c:252:16-22: ERROR: invalid reference to the index variab=
le of the iterator on line 241
> --
> pw-bot: cr

This is a code pattern concern, not a real bug though, as the use_count <=
=3D 1
check guarantees the loop always hits break.

Thanks.
