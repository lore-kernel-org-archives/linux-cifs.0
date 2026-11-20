Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795185854;
	b=zEbEGE2YyaaOpJaYA/ia8SOjtRprVGpe/FVCihIOI7JW+XbHu9Ygo3yKeKCX4Rf9HjvA
	 a9ugXHejJE53wgWiKJNyXN9B1IvIAnIKYCYSVw8rNLmkjc0NpllXzKxGHtW6MP55XBBP3
	 oq5dmThlqFy5ZF/P03bac5U1gyopKz8y1ODJ0m1u5QYXDwVfU/8KuE8M4G+iCvHL1kD5h
	 /oZQyuJhrW5QH8Carkgh89G0AU72l4qcIBFCGM4UU7wrXH9hyqfe5ud8v46FJTu4PwnLI
	 G62iUe1mMDRyjmCNlOZqzdAoO9u0AohyQJ7Acap7QEICDz6c3jLXGlayZa/zGRUM+lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795185854;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:X-Mailer:
	 References:In-Reply-To;
	bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
	b=UpQevXx2exZYK2285rN23QzzEfdBBj6fuVuehTHoXtNWwlf0eW8BH06Ou9qCJHxLrnXA
	 Tt9K6b/C3uLVq+1mJW3rDKcEo0gCRRMSZvp1SebbOpKmFTtUEvU2mdopxQ7jBLiRwY2pK
	 aX/ztLpPjI1XO5YSpe4AGbWZ6YM9e+P1L7Vu5KudsgaWxTnPEARJljWqK/UZu0s/6QDzw
	 lTElAOuEEPbJv0Upr56JSvzp5brGYz0cH9+u53400DYtMczxPuS5v9PjN15uNQ4waydIq
	 KeIstnrjqi6Dbq5TT8gCxjUxF7AK1YWb6DBG+FJsWC6V0rSwEJHvQIrLThbcOnNutEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw;
	arc=none smtp.remote-ip=209.85.221.49
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22E7606A320
	for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 14:44:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C22E7606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=UCx2E0Sw
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-4a34ffd3e39so534917f8f.0
        for <linux-cifs@vger.kernel.org>; Fri, 20 Nov 2026 06:44:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795185852; x=1795790652; darn=vger.kernel.org;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=UCx2E0SwKcK/oqyYNLOz686VusYmii+3mMDSe2hm1s34x/9j7y81gtRcvRwLvYBz3L
         8OWonxeJ7ONGBIAdCYN28kX+LRG6+zE1qzjaKqtJdHF3MJBPWqGI5u3OnZMZ4nUYhE9m
         PEaUWEoqsvQP3IAgHgg36VjHmqvLstmO20zMnptGeWfnBQnfV8Xwbcf2i+5+HPE/je1g
         UffyYR0okyEW/XxdVXBfUQ2+CTA3+deWuJyIBQP4+m3bQJNmt6Az6/sbA917Q6G5mzbK
         Rj5vUQAl8Up+44D/OFiKqlCYJFj+9wTD4uBgXkGE6VmgSc/N2pGJihXdIl+6jSPw+Tjd
         ggNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795185852; x=1795790652;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :content-type:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=aeb62NrfYX2nWbFpQ3h7rH0au2pU37+u990yshAdsq8=;
        b=cIs8pqRSdzis6tisC0RPJoqMbYpUPMBls7yzBOiRplH6UlLCoobQVWH7kYP4D75yEf
         rAD7gGXTj/UchOTp0tWBkY3gfY7X2kNzz1jgfm2nFk4Lm9F226hvJoGj/pQvzlW7BaB1
         zQxZ91wJEYzPN0npZrch1/d1XEMkRPzentmBW10xtrIlVS/daw0QN2AGpAfGOkSNv9mX
         QoVz/gzFhR2c220n3BFLQ0S7WnsDcNJgLE64pttK4Emd8Bh/zM0amkTqrLZfb2yKkbHR
         4fzj9wgH3fxMqrjL+S7d9GJ2IpU+QXVfH/hbtDcyqpxV8ACMIZ5xkhHOtrm70Wwzfsrg
         IrcQ==
X-Forwarded-Encrypted: i=1; AL+hErGkUi4A0XmX4afOiWr22tnJbzD2aYta302Cm1OMV47qVkKEQ4gT0jNXmdBQ72aMgTgZRJ/EyLp31puV@vger.kernel.org
X-Gm-Message-State: APuU4Z/MvtDAKig2DMPNVaAxdrFN7dggIlHFQgARgQBjgQGptqzh53gX
	repGwzBLA84wQyVM4DNn0G7yZjLpPhWyIFq8gFICIY1o9mvHOMz6Br56
X-Gm-Gg: AZFdTZeAwUIwELmiRJJU2ozdWdnwbbTRaBCEqwYFgsTA6nM2cQTsMGrwm6YmS2j413b
	WfB2F/9AX82J4HFRuZjd2Uq60mzpZHPCK6jLXY5r3pbuE90HFZ+NYKQ4JWpVM2HRjcJKFj4xUOP
	AGwHI1pi+wdVhrQisjF7TCoxl4YsDKxkT7dkOHlWRY1OYrOfAfIdon2Q+c6RRrxC6zB8zzmqAQf
	iNs9rfmGe810k2KEepwNXdYinb3dZBa0aQg6IlUl0dz/bKNSCDQhQEOEioo0Ysl1tI7v1Snc/Wn
	6g7Zey2E3vm/ggsEnj1fy/nkE54lx4YhAGZwvBYxsMBfkScWCMBr9aEEM4Zk3rBIE6vDANyTul9
	Hb1Sft80k4Bt5Uh54uQ/Ixo0GsPXemzB62+XiqQN/JaDYjX4cK7sIk/rbcrOjziJCbuQ910pcFH
	SpMYJ1r4vVPXiRz20Qfgof2hKI28cEPDJZ6Cf0rHto6wuA3gyGl31bf5LcuUuy3zro0g3qF6AlM
	B/jNw7iUQgatT2ISSlhNuG9I/OhaCdJQNQfGmiLuyLpXuNzBiwanqteX6c18eJ0Zye+p4GWFLcA
	NjtLAy8G8H8n64HswNLlqw2Z0dlPjaQJYxYIP8qM5vBVovQB
X-Received: by 2002:adf:e014:0:20b0:491:8462:20cc with SMTP id ffacd0b85a97d-4abb400c0cbmr5198457f8f.37.1795185852061;
        Fri, 20 Nov 2026 06:44:12 -0800 (PST)
Received: from localhost ([130.192.98.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab69bf62f7sm6426849f8f.13.2026.11.20.06.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 06:44:11 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Fri, 20 Nov 2026 15:44:07 +0100
Message-Id: <DN049T7Y67NZ.10CIWW8DE6PP5@gmail.com>
Cc: "Lauri Gates" <lauri.gates@gmail.com>, "Dave Chinner" <dgc@kernel.org>,
 "Christian Brauner" <brauner@kernel.org>, "Christoph Hellwig"
 <hch@infradead.org>, <linux-xfs@vger.kernel.org>, "Carlos Maiolino"
 <cem@kernel.org>, "Christian Brauner" <christian@brauner.io>, "Darrick J.
 Wong" <djwong@kernel.org>, <linux-api@vger.kernel.org>,
 <linux-fsdevel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
 <ocfs2-devel@lists.linux.dev>, <linux-nfs@vger.kernel.org>,
 <linux-cifs@vger.kernel.org>, "Theodore Tso" <tytso@mit.edu>
Subject: Re: Concurrent FIEMAP on reflinked files serialises on the AGF
 buffer lock
From: "koraynilay" <koray.fra@gmail.com>
To: "Amir Goldstein" <amir73il@gmail.com>, "koraynilay"
 <koray.fra@gmail.com>
X-Mailer: aerc 0.22.0-0-gc2f86b7abde3
References: <av4Hn9u80fs8iHZ6@dread>
 <20261119095943.85048-1-lauri.gates@gmail.com>
 <DMZ4VQ7SZ07T.29WMPQ0BQZGSS@gmail.com>
 <CAOQ4uximow25oc=3XEN1ATgQvonQaTXtDPmQufxo75tJ=e355A@mail.gmail.com>
 <DMZJDGMJ1RVF.32ES391JKNFGP@gmail.com>
 <CAOQ4uxjVQ9cjV=_jBjQtNg9zCuWUEJT9KNYMKV+1jwBkHen5OA@mail.gmail.com>
 <DN03LWNSDYP5.11FTQ5KCWU2X7@gmail.com>
 <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxg0oq7VjhSQ0h8dBucdPfON2Q6tJQQqUy05sCaE10QRoQ@mail.gmail.com>

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

On Fri Nov 20, 2026 at 3:35 PM CET, Amir Goldstein wrote:
> On Fri, Nov 20, 2026 at 3:12=E2=80=AFPM koraynilay <koray.fra@gmail.com> =
wrote:
>> > With non-zero xflags_mask, internal contact masks
>> > can be used for -EINVAL not for silent ignoring.
>>
>> What do you mean by "internal contact masks"?
>>
>
> I mean that users do file_setattr() with a bunch of flags
> some of them are just ignored randomly without any any way
> for user to know about it, because this logic is some internal kernel con=
stant,
> which cannot and should not be documented in the API.

Ah ok.

Thanks,
koraynilay

> Thanks,
> Amir.



--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRJ2XvJtXGwULYEerQ0bnTtJTDoOAUCawBctwAKCRA0bnTtJTDo
OG67AP99DCLnFsLMHCsRAeUitR3pAiNRglGbALKnTbw7U718dAD/Rbb718IIJvnz
/T8g9StMlY2VrgWntvlMz+RabJ8OUgY=
=dJIP
-----END PGP SIGNATURE-----

--8a2bc4e8bd35bb6d32db85e9ae6f5058abdd79d3019902d3de598560ffbd--
