Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D63F32D0EE
	for <linux-cifs@vger.kernel.org>; Sun,  7 Jun 2026 23:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780876091; cv=pass; b=OYi+3XkqV+8Wi/w1uLdPipz4MF6yRdWJi8ITuq/nEtGcP1qINvtm7jjR/BHaU/o722IG+4jrkWsG+ljChzaCzHvTjsE7Hej/opJ8vRtGNlbaoFHk5uZPDcHB3EhUMO+GLk6JHea0Z2flW5Tt63x9jLaUnpTVF55jaKaSBqSJ5/w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780876091; c=relaxed/simple;
	bh=4WNc8kfgf9HGyv/5KkcpdKc5Wf+Aj5Qxn0i3IS2Wu1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LHJ4qO9VBse7E2afnE1krS2Cpg3JoPvLjGT/JvpRUFCn/p70hY0PG50pvRBEeUokBbuzeKe2VVGwP/vZmM55w/OmJDoq2wdulEWytFqJbwk0RkLVmZWYe1ydzER0ozEyXHL3OdlCnA5arGPaiwkEwwOoQ1htzfo6aB1xdZtJPS4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HEQ1QsPY; arc=pass smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HEQ1QsPY"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51775f2473aso28689431cf.0
        for <linux-cifs@vger.kernel.org>; Sun, 07 Jun 2026 16:48:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780876089; cv=none;
        d=google.com; s=arc-20240605;
        b=ZkmMoIezkBi0QCHwES+xiBUnkzltCrbSBfm7I0yXGIfkP/yAIdmOqtD6YGdPv5avzN
         +ZOAPHX1Jqr/kHCdaUHZLPowwq5MNCRwNgRienXg3sfKqnkBHdvUBWAVlRT1TELAQzoD
         QNmPzpkqSbLuxXLjYFbr+8/AxS8jumr+Q2wVY+sYQCxRLvPHRIe84/MvLfAYyfln7TAx
         Add8D15s6XuP5byYmOupSi+9sdW4EGuDQ1eyjvqHeZuVyqEmpd84jmQLCb6XH3zLh50d
         QCSzCe0OYdgnlGSEFpqqfoaMhC6Uqjn97ODXaUp1ZOOurZHRIbRwNwSJIHC+t3qHDGpz
         8UoA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4WNc8kfgf9HGyv/5KkcpdKc5Wf+Aj5Qxn0i3IS2Wu1A=;
        fh=wg8KYmR45K2dXHlKF0VYFwUEHrNlhzY6trUCTCVJT88=;
        b=NMvUq9v4flLllgznh6ioV5G6uPtQ9oGAZozeQZZo3MbZRl3MXhkXgKHlT5R9s6v9iG
         xnGZFmTpQMwBj373/HQyuD9Qeqq5h+n+PdinjfRSLXRVPOJjDl4/ZX4gtFSGbGIpF1P/
         5nLUmagEgAUg0rCuHUEmC6pAliIVl/w5MGfsWXLY1ZOgY5v9LXQzdLzNELawGhGGqnxp
         eXfL+8/DFhVhxxjfA2YZBFLWm5pM7VsrqemX3hKYgES2emWu9z1HqFr/0Ad2OxkOl8uM
         xqIAV4V6hr5QfqakUQr8DIZRQpGfLq4WKLJvoMLjuRhLe57jQumwAje4LCKGQRNlvQIf
         7dUg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780876089; x=1781480889; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4WNc8kfgf9HGyv/5KkcpdKc5Wf+Aj5Qxn0i3IS2Wu1A=;
        b=HEQ1QsPYXRLVPkTlz6vQdwa6oQar1+HvfcZq3dc6SxTwu4v4hYIf/C3eS5zqMbN1UA
         /tZDOxolPts4OByK+ywTLxnWvicCJFwilCIIFcAfXOpafh9mp1V1stk41FpgoPRGJ150
         k5r7LUhlQ60fkWSsbwW9rsotY3rt623iBJ/ZE/BQLKWCKOigN+DwJhDqZ6Rc0pLInKwR
         qUxQEytfRhmgaVs2Wk1rQ1wCAZ2qzJGX5wwb/q1AnsPHZV1Q3z7/ZF73IzbTOxJRvqWe
         hHON8w8xjobJ9ErIGvy8QAFTY44/V1PQRVXe3KYtGu6BZKskPLhLNLO5wYqPHwHkKHdf
         BE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780876089; x=1781480889;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4WNc8kfgf9HGyv/5KkcpdKc5Wf+Aj5Qxn0i3IS2Wu1A=;
        b=alRiyVbLEG/Ubw2Zc4WsfCKo166luiDoVP/RX+cCY55dOghUQYet58bduP0DxPeknu
         X421Ym/3d1Ut6mynvAE68TpBr1myYWyWMbGZJj9F0HC1M0fm+zBZFE1rvNpDmTYrqy2k
         ytdYeItbi3hvDcWiJguecfCK+H4HLbkFz779FgadiWxoH9KtJqWOGFiBnf5TqUdOozCa
         RNSvOZ2/fUa/Retx3Eetgjf+JwJA2L1wYWWMxautXnR2PTkdXk8OcnUuF1VGIblEP9i7
         dyk8axzMkJZdJgtnbwm2JUVMi8XOC1xP7BEzx/wnZlo8EvpNVzTYeM+LrR1hYyRYt3p7
         229Q==
X-Forwarded-Encrypted: i=1; AFNElJ+2YbT+8zOKjg74aPX0I+0iooz6GDIEUpsyt2TGhw4cfXpGDsmBKte7zGJW5VONNCY60tp7Ikpi2iSz@vger.kernel.org
X-Gm-Message-State: AOJu0YxqXCJinkHE+TxRWI+0TGL5t/Og83w6AQeol0EJd/vzavUC6SSX
	sPwrzOApqakbjh/3CRBmPnC2FPrxiixBmbpUUCj/76kYAl+r0RdnCEQzBE3aeBiAW61XXNWrCoc
	0Hz//y2VCWiFN3j5RDTw3uEySRosig+Q=
X-Gm-Gg: Acq92OEO9slaTcHj4OKKU4VlSH8d6ZQGrNqKmcM1JMpQrYBA9Ku6qslwbw38j3HsfCs
	n1dx61r0QP1cSeWb33OcxmhSqUTaGpwOzPU+FDXmaz9ymIlHwYqL/72/D/BTEHyIX0PLUnWXuIf
	fQURHNOtltsf8RqrPupMo+2fMSc2RTJVNUUGqzWOHpS1oaSsbBptatfjQqVLqJ6cQ/ufLknEJxi
	hrD4+GVEW4GRByjsmzhthhTYyNEVLDP6nyhjN8W4kB92x7sZoxjrXrFx5IqyY6tqeSWhUbD2Ahd
	kVRD7CpYx9GmYNEhBhG/r3UaMYgZZx2DvG33TAZDpboGBacc0JbBvnCWjzU1LEhH4yAv+g2p9N1
	p2aIHATDJCg+hIKJN5Ne3ubF6wZT0Vktck19dHo0OIWQMuGyJF4qcU3Rq4Ld05M2QJheF98SzTV
	VxUlZshvPdrXpBdsjEanJXDjiMFcMXYi0=
X-Received: by 2002:ac8:5dd3:0:b0:516:eaf9:f6f1 with SMTP id
 d75a77b69052e-517959f9fbamr184583671cf.13.1780876089560; Sun, 07 Jun 2026
 16:48:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mv_wgjBqEsWYGxEt86tN6hJNV1VBY2YipAbeP8goxsSZA@mail.gmail.com>
 <1aa393be-4f17-4dc4-989d-77b0dc6de09d@samba.org> <01a5f813-1847-4ede-83a5-62bef4dd26ed@samba.org>
 <CAH2r5mubw0zVBO83XzOmhWSOzq6PM5OkP-18Eg+LK3tvoULzkQ@mail.gmail.com>
 <CAH2r5muePx09GkNLuQ5ww5+cPyCH=FFyCu2pA+hQ5gSPMh62UQ@mail.gmail.com> <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
In-Reply-To: <de2e9edb-c52a-4a70-8f43-30ef6a8e4041@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Sun, 7 Jun 2026 18:47:56 -0500
X-Gm-Features: AVVi8CeqUO0c9ZVlNF_SEo0eLFlqeuZ6V4mb66zWgz9GNbD9PSm4Dv8tdPZwXk8
Message-ID: <CAH2r5mumYk1bcnwwgm8ogP9gaKSZzZX_TFdv+cm9CyxCiT11zw@mail.gmail.com>
Subject: Re: [PATCH] smb: client: fix chmod and chgrp with SMB3.1.1 POSIX Extensions
To: Ralph Boehme <slow@samba.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Jeremy Allison <jrasamba@gmail.com>, Huiwen He <hehuiwen@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The modefromsid example was not mounting with posix

On Sun, Jun 7, 2026 at 12:37=E2=80=AFPM Ralph Boehme <slow@samba.org> wrote=
:
>
> On 6/7/26 6:52 PM, Steve French wrote:
> > the chmod bug (when mounting to samba with modefromsid) causes a few
> > xfstests to fail (I noticed this when testing the swapon fixes from
> > Huiwen.
> see my other mail I just sent: this is expected, modefromsid is not
> relevant in SMB3 POSIX context. If you mount with SMB3 POSIX, chmod()
> will just work.



--=20
Thanks,

Steve
