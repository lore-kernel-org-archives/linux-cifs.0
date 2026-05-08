Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B04F2FFDD6
	for <linux-cifs@vger.kernel.org>; Fri,  8 May 2026 16:51:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778259076; cv=pass; b=nnCX17MKEbhPK9dE8XI4STQsSQD6xsxfFeEWwISZU7kO2R+KUNr27k2Lq/nrWaikoGwOt1Fc3dbczU4HM7yZhE2flfesRt6jVlaNkNzqRo+GI+aTFIaBe8f8F6Q5YxJniHiLdLjMgUBVUkEldzJ2Y8H8Uilf0fiROUa0Vzi5E9Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778259076; c=relaxed/simple;
	bh=HpuzAuoWxyU0VMOwi8K6PwkcOrPjtCdqYAoukk4e110=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rcxQHX0uwIwYa4fAwQofR9J+Iw9AiBqPzQYvs//fN4qXA9lCpjXC3vHRK9De5UALc+AETSj1p4xqxijSfU8uCNexykDlhns9BZTiXXsmshWRi6jFi6+4NHXX71/vseJTmdiwexgYpa9ju9V6jDG24KVl/tZLM8RUC6+A2PVOPhY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ioxcfgk5; arc=pass smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ioxcfgk5"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a877510541so2272097e87.2
        for <linux-cifs@vger.kernel.org>; Fri, 08 May 2026 09:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778259073; cv=none;
        d=google.com; s=arc-20240605;
        b=A1ZzN1TJaDaPy9egCG7r6L/PNEK+JogcAW/jCOibKVbKp6r6oVYnauYhwqyFPWtShQ
         Fxs4KI8f1BwUOmN8RX4SsxqyMcS3S2V6rp6e/Mw7mR3psF0ulnDXcTjf1HX+2zIPsrs5
         fhMPizP64H/IFe0qYZSHEVBlpoCk31mc/bpTeCQ9cZA8NlMxxwOqSFlgK7xz/6Hswuvr
         veW7HpY9sHUbhGoX6L6zOCQ53ixtsEkzXA/dYaRsYhDqWeXla2FJIdFNdPTljjhSMWbj
         UXb/t3pd5+Zehuh4FNmnH/J/4LzxfYQlqFfL79bMTgUSKJwo30uU2/1WNB/kGF713I4Y
         vEwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=7M1gDeBGhxjsNeWTODUXervEBvrOsS8HT08OhOQQFmU=;
        fh=j24uJHKlpbWG017pObDHPgCloR8L9ZkT98WYoH+MNeo=;
        b=Qz0ZPm1Mwh7+Wu5qgGSRANJN8Xh0UlXCyj+jDYbtBXvlhP65Of+kt+hkTiBqScEVmq
         dVb3M/DJ6VlpA/D/0y+oydocWSIK4/ZhEQMuvc1wP1lRo+MtH0xsDivuXlXQa/ZpaLDE
         4My+jQiB8QLsngxLBs7FP/ODYsx7LhxGrPzXNKJN9wRT2N9QZTvGu6cPc+hQ5TLVnVny
         0Je7MSw6K7itYaOsAjiOyYbm7G8v6BsLOosFwATdtaKqeAhTQJWuteGQ2wC+9tJvIpCT
         qDU2YWZAAlX1THFo01vypENstzAAjiRMmglZjluvAcz14OmVqwfT+m9WoWVz00HlDNBG
         4/Fw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778259073; x=1778863873; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7M1gDeBGhxjsNeWTODUXervEBvrOsS8HT08OhOQQFmU=;
        b=Ioxcfgk5OqeUxNdyTt+FlfM30UDuDcjGUmlEZ7AD1vNnLMqBg5QCUnrAF+gCf3DkbQ
         cqbSBLvsEOhSOqlGBDu0mtz5apJu/6EFlALPgersskWpK1YHmiQ8o3z5lfyhyDZBSkDk
         EqIXMl1l4QQeyinr8eGCaPcnfVJH0yMGuUIgAd6XEzB6FBkjXcD5iFHEl+g6Mk3Z8Nlm
         eyyvmEqsH3ddQ/4D4OX1OZ6HHw4iWWXwiY/KHoYRBwJSAVach/o9iky59vRVct6cSviL
         jwoMl3Mxlb2CTs3U5M8LG4ZwcW2UzN27+UH0yn426pxC071WZtzqfHYH+M4ocVvg/rJJ
         FwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778259073; x=1778863873;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7M1gDeBGhxjsNeWTODUXervEBvrOsS8HT08OhOQQFmU=;
        b=Kl+E9LhyKibZoLX+gDHbqA+ZOAvanfK4dJF60rAq0PXEECTC86Njpfp1VPB2e83wEo
         PlC3fAvcd86YUE4Obc9L7Kd9+vargPP9w2VuX6sYRfCNnjKapoTaebBAGHTxAWMbSk2l
         +qKsrVEBvyIm2VXgWOs2AhoJJ7mr6lM4VvrjyMWr1uI6wSnKWsKtI70FDF4mATIs3dU1
         pr+1CCBKiQ59NVkPG1ZQ6wsPWON9GXp4wa3JdDIAvU97m9U+S2HsH+16CKTS1rZMYT1I
         b82SH4zPFvxM0/LX8SgZWP2jBHqCHOJOMtJvrUAi5coKXm0XPFg0dFR4qrVqdJWNHo58
         apbA==
X-Forwarded-Encrypted: i=1; AFNElJ/WYrD6FJuLLpsGulYPDU/SxjX9BIEwfMAmBLIfMSbb7HN0Ph83lUhzy88+oOQm6Y+K8O3sM0ea8E4b@vger.kernel.org
X-Gm-Message-State: AOJu0YzXmeJcnrsho2wyj/5Tb3qRhKLvr6TvigzORw4IVnVM5g7Vhdbh
	AD6Zkf7670rYdArJhR3VyNOt8vMw+Crr0sz74bm82yEZkYIU/6ChvrXeJIJ9IRjCk1363ojReMD
	ywhUlLL8Bpudx/9IFToyiAp+xIvXgnlM=
X-Gm-Gg: Acq92OHR+8WPghwYWLmuxF6UDyd1idvXAORHBhZLMOSnLyUwvECCD4pdlJ3xTexTyyR
	gd6GwMx8ZDa78exM9R52cQ2YyZrVjB07Be5YjCLcIprEDyCq9Y9h/xxyip1CpXxoH6URfhvRBXo
	rI5VVzOernheyAml5TKw1bcKDd0mzK+1LMzH3Yte8OjbGJyK+FKMGUwqkM5fyXPZfEnNpPNRdg5
	+JscsGJD0whUVmvDeJbDxmOIkC9bR69cVxlMO6iMpvSbYJbIjlocY2lqNXFk/+Xk28G8KhoCRyA
	xnftGJw5u/Oi7LYx31hZmViztotHd5340Z1hI7nRj/SZWfO/cuoNl2OGnF/nUosjvl+z+aTeSxk
	uZKnoap/k1ikk4nlCFyRFVbbdMvmf2sIWU1+G3Hi7qBjxN7IgrQC4YDYrd3QUL6/jByUk//xtJC
	3wbe659NgQ2+z28x2oVbHKog==
X-Received: by 2002:a05:6512:39cb:b0:5a8:7701:b815 with SMTP id
 2adb3069b0e04-5a887ada542mr4430249e87.8.1778259073144; Fri, 08 May 2026
 09:51:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 May 2026 11:50:59 -0500
X-Gm-Features: AVHnY4JWHxHBQYlCCJ9gN5DkR96yQeqb5EigTp3ReSqAGnyzTsWD_LLKA3Nnb7w
Message-ID: <CAH2r5mtXTpYdhU01w-GD32pDabZe6pq7=AhDnCpCGC00-JRxng@mail.gmail.com>
Subject: Re: [PATCH] smb: client: use kzalloc to zero-initialize security
 descriptor buffer
To: Bjoern Doebel <doebel@amazon.de>, CIFS <linux-cifs@vger.kernel.org>
Cc: samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

You mentioned:
    "When the reserved field happens to contain non-zero slab garbage,
    Samba rejects the security descriptor with "ndr_pull_security_descriptor
    failed: Range Error", causing chmod to fail with EINVAL."
I had also been seeing unexpected chmod failures to Samba sometimes in
a few xfstests, did you have a good repro for this?  We also have a
problem with chown to Samba that when I tried to fix  on the client
got an unexpected error back from Samba, so ideas on cleaning up
setattr_nounix() to fix chown would be appreciated too.

-- 
Thanks,

Steve
