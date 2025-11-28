Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F72C08B6
	for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764368504; cv=none; b=iLOyU+uX9yUEZiSzKsL/chsPLm5D4tuhDZwEqNgBUJon6oMe0ef75fm7G+ShaTCN1ha8BxW4ruCtEynlreADG8L/SO2Ko+MdEEDHkr5JGHT1z/hmqyTCiJYQ3gQMUy9/R57Js6yCKKwpZz7LlLHtvZ4gljkR5QopNLNhEVi9mlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764368504; c=relaxed/simple;
	bh=SQTVp2Fzpk0NoZcAVL+rErGbsCS+UUMcmvwU/jMKSLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p7ASQQOLbpy6KfITAmfdrj16icIMYqVv0GwnihiNJ8o5KX8Cya4ey4JhjIOSvpivRNnpfpu2T5Iqs6BOyCYNVwXOdkT99REcOZT0erthPhFmRn5C0mnq672XVxL6tyYWAiSOI/LUiZ91Ah1NAgvM7FzitLCKFa4vwFIgZnOWQeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEsOnfPe; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEsOnfPe"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-343806688c5so1658959a91.0
        for <linux-cifs@vger.kernel.org>; Fri, 28 Nov 2025 14:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764368502; x=1764973302; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6P18mAZ1MqIvbh3CmMm45KSEcmyyptIsJafX5Z8hVww=;
        b=mEsOnfPe1MmbaOXdCmcOe9zlD7foecT34f3cdDyjJSltfw7qWTJb5F/vW6YxZOla3M
         siLCqucECoMPj6LQOP+gpU7GzZjuilcbmAvgFag5KG59XqopR2MmjL0+L35fuhzDkKLO
         e2wOSntE1gq/Vt/zOeg4864kUcA/28pP0H3WNGh3n/MO7E54NKV6b2qVSAOL9gKThX9L
         AZg2C0C1133VK5UykZZj7eT0uxZbdWX581ExlyryucxXyGBhKh/2fd0x0yCGD66VihJr
         nbnXVJOGthSkC4QtBA6p/7rvBQ+UEYANc8jrGeEGEn1LODZm9wgHhOLGDThCxaB9SM4Q
         y9ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764368502; x=1764973302;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6P18mAZ1MqIvbh3CmMm45KSEcmyyptIsJafX5Z8hVww=;
        b=ul7WS1ed0Rrv+5voCNlZBMOdDdnA4apSq8MAXDPYmkg0m4tF+n1Nn+dCU3hF4qE8kr
         tiz5whjRYjISK7o5CDrAHNiRWUDqNiX1abjQeftSbha+yfrbpBffzJxKyGeRzkfWqbtI
         cSLSvXeB4ZncofLcSAmmuiahsg0zTjM4jvTDHoGtwKanv/BY512QmbjGujw+i5z/I/Q9
         1f5tYZLXT8uxAgki6YKhPA5b7tqskSPhwMJTZTR1Yq1XbA507N6TWBbXI7wEKr/PJu46
         vQpnkuKVdiI9v+1V1zEHCuZTB+RZJJhaxJgh1TSx5ON6+EyXiLSdib2AkjRMZDDv09sp
         Qyxw==
X-Forwarded-Encrypted: i=1; AJvYcCWkCW5d/cL0fsmRc4LAYsyu4lJM+wQNXXnJGhw+GU8AcYur0yBLyrzV+w1X8zJK8YgLhpWHOchfSAFN@vger.kernel.org
X-Gm-Message-State: AOJu0YziPxO+7iiQF2bjc4KEKhcJ7KJGDjTlyrmpCJ1TPNipXqJeIwo7
	EdEE1Ody9BWjHcyAsVYBKAdN0elLvwPkC0wRGPjgQyeLO/yyHGtT1/gEnURllZpfW2bEDH7BYO4
	2RmzBp++tZ0RaTKYRRT6ZzqnV4Itrs3T3g+4/
X-Gm-Gg: ASbGnctNZ25wVE8ZDPqHilYTxVpSeYjpWp5aAlc2y1j+V/TmVqFQEsxvZCQTeJSrlYi
	yVSy1pFhQX1y+7UILvQP63+u6gewEC5l7tCG6aX9Q9INFQi5LyPbTbLGGaFbi57/cuD2ESLT3tV
	b4XaweTcUWV+hRzy1d2o0T5HxTKJBkgRUUoP6iql7alxBLXXkUVnnaUqtgmXZxSMIR89Nmdm/hk
	FfuV5cIiqhRENGdvjWLeF/CTMdSwP85Rzh1bO8EkBPa6fs2wLVk4sLVyHprASziPPxy+UJUg4WL
	HpUNKQGZ
X-Google-Smtp-Source: AGHT+IGouVmSRU2+5FPtU7PZ4bxQ1L1TS/rzuH0An62oT/VAqyxTOEwsLF/KPWgDyeqL2eIE6oHNOz0m/r6ekRLZB7U=
X-Received: by 2002:a17:90b:3b41:b0:340:be44:dd11 with SMTP id
 98e67ed59e1d1-3475ed6944amr17150643a91.27.1764368502014; Fri, 28 Nov 2025
 14:21:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1763994509.git.lucien.xin@gmail.com> <20251127183008.5ee6757f@kernel.org>
In-Reply-To: <20251127183008.5ee6757f@kernel.org>
From: Xin Long <lucien.xin@gmail.com>
Date: Fri, 28 Nov 2025 17:21:30 -0500
X-Gm-Features: AWmQ_blWIFPPlXbZwBvgkwqvDmPpeWwfQI3WVoQuGLEtMYmvXkBsPdiaHSosH1o
Message-ID: <CADvbK_crxSB+TwDgEtjV6TUEeO9VYtsE6rqy7L_=rzoDrCfORQ@mail.gmail.com>
Subject: Re: [PATCH net-next v5 00/16] net: introduce QUIC infrastructure and
 core subcomponents
To: Jakub Kicinski <kuba@kernel.org>
Cc: network dev <netdev@vger.kernel.org>, quic@lists.linux.dev, davem@davemloft.net, 
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
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

On Thu, Nov 27, 2025 at 9:30=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Mon, 24 Nov 2025 09:28:13 -0500 Xin Long wrote:
> > The QUIC protocol, defined in RFC 9000, is a secure, multiplexed transp=
ort
> > built on top of UDP. It enables low-latency connection establishment,
> > stream-based communication with flow control, and supports connection
> > migration across network paths, while ensuring confidentiality, integri=
ty,
> > and availability.
>
> Please look thru the Claude review and address the legit complaints:
>
> https://netdev-ai.bots.linux.dev/ai-review.html?id=3D8ac157b3-6222-4e89-a=
c52-28e4ca52d6c4
>
> If the tool is confused but not in an dumb way - it may be worth adding
> a relevant comment or info in the commit message. Otherwise a note under
> --- would be appreciated to avoid maintainers having to re-check the
> comments you already considered and disproved.
Thanks for the link.

I just went through the tool=E2=80=99s report. It found one real issue in
quic_packet_backlog_work(), which I=E2=80=99ll fix. The other items aren=E2=
=80=99t
actual problems, and I=E2=80=99ll add some inline comments or --- notes to
explain them.

>
> Thanks for adding the MAINTAINERS entry, two notes on that:
>  - the entries must be sorted, so you need to move it down under Q
>    instead of putting it next to SCTP
>  - you seem to have copy/pasted the uAPI path for SCTP to the entry
>    instead of QUIC ;)
You're right, thanks!
