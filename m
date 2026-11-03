Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793742115;
	b=FYuV4+bEheIQ6o35FnLvCtdmil3AaZfusFNJ0Ngo4MXLxtI5ssp781YMHub8YRhqPLau
	 F8U+dCucNQ2R4c3iwVvAIpMPlVjRk7tOl9n+NoqPg5LCpxaP8jSx6D33P3KHor+EZJ2R7
	 OPI1s/WnGKR92pMoRimCPFHKk7yLltdd0y41jxw7kIyRTiZFx/jN/3c0wkkqvPQ3lcbde
	 i+Zz0ZhSXtYbpT9hPK+vfxsR5UKXxZgFkysGb3lA/DwutRZaUlyT/vCLSwOPJM6xmk0Dn
	 s17aSEJDqZR1k6Ubrgeu8yKX5Hal7PAfgaRe/XnLpZVfXt7Hl9cg4J6ZHrKfxuh9CMQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793742115;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=KCOOPH9EoiMG+L5AFnPDYrfGK8mdFww7XEnRsLZL6Cw=;
	b=y5xbqfIJVNK1saGu0ZjGBZlpYFcyfRK2uY/m4ft/LD8TYfb2OdZblEj+f0kKKDP8PXZc
	 OXEP82zK6Drz/kmwPEAb24J9eJCpnd4+LPahN9Y+Ngc2E8TPlK58Dfg23IEwK44l17F1b
	 tkstozvkj6Ug0poJJ6FQ6dySeNtO6agSSiz6MZv1qko+s4n1MExSGlh9lW3PbpjXhxCyX
	 jxIn9uJWgXTov3xRIb0NLVBI3Acvd9/y0TvS34iEQXzxBPpvECTyyPdKzhTq59QPj0es/
	 xcZ+qGXegiLrN2XaAfToPBc6WoutQ/3f5YIjiDI4AW5T3xtTOMYrW/7HTct/gcjSIxQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=utTW8N6h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.128.169
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3494606A326
	for <linux-cifs@vger.kernel.org>; Tue,  3 Nov 2026 21:41:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3494606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=utTW8N6h
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8b056d58f2aso639867b3.2
        for <linux-cifs@vger.kernel.org>; Tue, 03 Nov 2026 13:41:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793742114; cv=none;
        d=google.com; s=arc-20260327;
        b=ZphTVmI6trTClXSc/AX/okgPIbNJpDzD8d5TKHs9y0r5Hc4Qe54TbZhc2334Up5otH
         tKxZ/pfDEuNCVrWz+jZ4TFgzlpT93VHT/Y+xBI9SUCTkTF3gOCfOb0v7Pfck3lfYbOpp
         VjFpAYgV1VZfk4sdUCvQlsTw/JQv6g39D7L+xrKjK6tyrNNRKmL/B2cH4GyF9PY5EMKt
         wtFhaAxXF3wUk/WpI0AJsv3ho79BFC51krb/PQPPcJ8NxADljBeV1JUJS28UKAtJuHGW
         sWmr9//RSWyRleRK1DxUjmcq0UfPDKpXGVrI3CJr/2nxHV8km0sXvPVDvrjLfwtk6Dm6
         ilGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=KCOOPH9EoiMG+L5AFnPDYrfGK8mdFww7XEnRsLZL6Cw=;
        fh=xQVHv0KHf5RYsBqUml1DCQ2xSV8n9uQY+5ou6HXhAtE=;
        b=AlPNd6a1P4EQ263+etCjxqV8SmuGWYt1rWXt11nTSTOzjVVDAsewNnUC2tDtRnEkbR
         U81Kd+Nv/YYoUlD96DWcAFc80CDS/mE5lOBE38GFuaAVhLc+cl8tZplvZgEwBOyZa5Yo
         Z933hPGpWbVnOsHpiDkwAsgx2WEN982hcj6aN0mNp1FDrUV95/MMvHAqkRPQVVh4Yzfx
         OR5exhxE9MAsRPu942cFgMMedrmOQg6T9A1PWXHE/iXOii5oKAsUWqBaEH/pQtexC6eQ
         HwdXL0jp5qZgHmrW4D+9RsaLpOdTxtB3cOOZs18aCPWaxayiQUOC1I7Ii3eZZcnNL+r2
         AAqA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793742114; x=1794346914; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KCOOPH9EoiMG+L5AFnPDYrfGK8mdFww7XEnRsLZL6Cw=;
        b=utTW8N6hoLFJa3OX9Zm8ycpNLKL+FZRDww6xotWwXCKnR8AHOVJxGZ3WoXofwVHPUj
         v00EyWdbbrvmxqfYdIq/JkNGI93n5o2HtXPPjfiiZoKaIDezYrvjI1KBkQYY0Q8Is6VJ
         3IHXnGEvh4iymk5jBoDaTnBhiUT9R0+yCCvie1ouKEGf34ALqAINQLAcoHN3beWU7Dti
         dZu2opgpUW8x6v0shumPnF1nJoJP1h1b1z9sBCJY/sTJp9BnqS9yXi5odgZWerhKYDpa
         pCPCNk3nVBOVGHS2NSNIv8sG9nWt2jAdyEfkOIuYXB8J+VwKVfHaDb6MH/YDU2tXR+EP
         Qncg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793742114; x=1794346914;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=KCOOPH9EoiMG+L5AFnPDYrfGK8mdFww7XEnRsLZL6Cw=;
        b=t2dNaFL0+ciehkpqUIUWYPMHUy7Q5arIyYSSA8KGQGBxQeiu2pBjMvZzHGTXHipg4y
         uLfsjsyTsv0Hitul12Krq2U7RNQj1bj19Ur2c3jJycFHW64ZFww6/WZfcjXgbhs8j2Rp
         yDzqAxl7x3ArjQgTKgdGCdlyTQIro6hpBshVsNLdrMPU9tIlycKpqkBvglOlXMWkufYz
         fT3oFLSaDjCQyZ7F21lQ8ocBLltJRWPQ+5M+ztXQzpnhBZA7wyEmfA+PqeNpUGsmy8R6
         VJBe6Am8lhrNvMv6X9qo/uBHSi49dzhfiBDgN8VIJ/4bC7MZkgmE7Pja5qZ3J5/qRvUh
         VGWQ==
X-Forwarded-Encrypted: i=1; AKwUvBzCHADoYPdBRszRWDmXvLvKk9JK4Qr4x7FA1Agr3pPG3Hh0EJjZ38E/SCwUbvKcZwsyfQv2lA+97juF@vger.kernel.org
X-Gm-Message-State: APuU4Z93P02qhpDB+77FtruzwVoHkAFBC3N7OnAm9FlCXpUoinVEiIpV
	RJHUfqyBj/4jXC/xOspTpYXXZDW8MM0YHm1mmEbaWncj+JCofU7leOV5siZPLhfihh9dRBylCJX
	7r2yOy9dzZdnE2yvVXULoALgP0IU32C4=
X-Gm-Gg: AYBFou2wWECo2AqVeB7O6sYcT2fIk1vH58vYSzS1nfskwilc16dS198cGivVSP5J5Ef
	F1lqHY30FH07K/80GnjO+p86/lklmTZ55AYW39+UBipyRcw3oPElF01ykZQ91kKdeHBRMZsAY9i
	RIXSb84kiMwhoM2ejzyn62pfITbSCh/plQHJSej6a9x8s6TDqR1q9vxalV+7A1Y7HLBbsutMpkG
	aEiyr49TCTtqvilg11uF4pexM8FsUOLGorQfHWf2fJY5gjME5RZa0O3nMuvlEw++U6QqcULHTcK
	vk1WqqJKYxbjk4U+g1FOqsry1RB5+LQJp7hDhVP9yTlMh4BxwXca7nCuttofg7AujhICFMDlhxq
	IZ1VpiNjBQ3iD8cVOQdPiZD+ZMYnE+q2z6VnF6sq/KuVjAUgbZUqKVbB4QMuWlgdSEEoyai01zo
	D3DX1Xw5/8iT8MWM8rcIq9QDwZM5g5IjHfF7sNnrYXaw44ZNmnHFWGx8iL4wEW4HyR6zespwS3u
	TPXdtD0
X-Received: by 2002:a05:690c:f96:b0:8b3:7fd:6a03 with SMTP id
 00721157ae682-8b307fd7022mr6881287b3.17.1793742113870; Tue, 03 Nov 2026
 13:41:53 -0800 (PST)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261102201410.55089-1-sidchintamaneni@gmail.com> <2026-11-03-1-daily-reply-0011-re-smb-busy-dentry-dio@kernel.org>
In-Reply-To: <2026-11-03-1-daily-reply-0011-re-smb-busy-dentry-dio@kernel.org>
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Date: Tue, 3 Nov 2026 13:41:42 -0800
X-Gm-Features: AclHuK_01ZslCkwhHMUTU4pe2o_levuSAfGqJ69o96WTPIQVW71HhP9wSgxG42k
Message-ID: <CAE5sdEi4GOXeVDPEUk-RR7bjE8z=25f+waQNedMQd6VCum3TrQ@mail.gmail.com>
Subject: Re: [PATCH 6.6.y] smb: client: fix busy dentry warning on unmount
 after DIO
To: Sasha Levin <sashal@kernel.org>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, wozizhi@huawei.com, 
	lsahlber@redhat.com, sprasad@microsoft.com, tom@talpey.com, 
	glaming@microsoft.com, linux-cifs@vger.kernel.org, apais@microsoft.com, 
	rlmenge@gmail.com, hargar@linux.microsoft.com, pc@manguebit.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 3 Nov 2026 at 06:52, Sasha Levin <sashal@kernel.org> wrote:
>
> > commit 75f5c412fa867efa0bf9b646bffe0d912109e84a upstream.
> >
> > Kernel 6.6 predates the netfs I/O request conversion and instead splits
> > I/O across three reference-counted structures that each hold a
> > cifsFileInfo reference
>
> This is a hand-written 6.6 adaptation of 75f5c412fa86 ("smb: client: fix busy
> dentry warning on unmount after DIO") rather than a cherry-pick, so I need an
> ack from a cifs maintainer (Steve French or Paulo Alcantara) on the list before
> queueing it. 6.1 also has 340cea84f691 and the same bug; please send a 6.1
> variant too.
>

CC'ing Paulo Alcantara's correct email for review. Thanks!


> --
> Thanks,
> Sasha
