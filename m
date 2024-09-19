Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A22619D07D
	for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 09:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737147; cv=none; b=I7dHV0ax9FP1jOK0sVICCphSwQeR3Bq2DweZMDN75CEZ36eCBouDWPmmNn/Yks7oG4nD1fjix0BMm7NrrBKM1rPF/x/Wk+AWDzGWBXGIrRdDtW9I9ehBaPm0vXtb7I5oLcYl8DDWFZVlkkL2Uqh35apvQIVzi4guU+RiG5WMYRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737147; c=relaxed/simple;
	bh=ci4sk1LEbnysVz/IKAlVvXTgrB6BZ41n5MN03ljpfoU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=STEEQtbg3LS49J8hNI6DGmdosAlJ+hKXRKlbp/JxyqzDTeDxdXedgrWLHslkWhQr+snCV87jBKuFYd3l4CPA5O40seZ75eg25c/rcESKQ6slkl7eWQfNAREd4Aw5+u8SrpBAbqJv68DlvFJFLYEQbQnAXA6oyol76fdaHufJlDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com; spf=none smtp.mailfrom=toblux.com; dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b=d9QeqI4F; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toblux.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=toblux.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toblux-com.20230601.gappssmtp.com header.i=@toblux-com.20230601.gappssmtp.com header.b="d9QeqI4F"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-42e6dbc8778so1001635e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 19 Sep 2024 02:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toblux-com.20230601.gappssmtp.com; s=20230601; t=1726737143; x=1727341943; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ci4sk1LEbnysVz/IKAlVvXTgrB6BZ41n5MN03ljpfoU=;
        b=d9QeqI4F9blbID7FeLB5K+9X6A2uIq5A5g/yFmP4gJSlVfB58KjNLI7ED2tfMAXkqm
         twVolBux/PL9bzQen1UXKvUQ1i/Is7WYCIGcBaz+jXzQ9X0s5qmxeJ//c98VoE/QmOx8
         Lc/aSsahsJVdfOqGdLfFmpEhE8uOqTSaRhBEan4gdSraJ0iyojifscMG6I4V9LLnz3HQ
         vgZcPo8WNP7AuhifT+FmzHcpQCakGtOgIJe/IIlt5SRWTfVHAmeJdWLYp8W5dRj9J4pI
         J2BrwWIXWnFMz8BW0cFSXAm2g00uPG0R0XKi+e86/+rPGR5fKPM52WwT9L84kib9yL4e
         3riQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726737143; x=1727341943;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ci4sk1LEbnysVz/IKAlVvXTgrB6BZ41n5MN03ljpfoU=;
        b=O47mIMcdCtJ9QCp+KPZSiXxI7Uml4b4kw2C4vqPodKq0ZYV2huVQHNI143s60Eh4n5
         VaK9j+qkQM92EgB3fZA39AajRftSZ1SQ+PuFYJgR/wonS40J4Kuya4l1CH5ZHrQWG3Wo
         R6ryNm6ren8DfIONvTq7Gbh7JxxU8isFkSGzF4OjzElDPlEmKGCmnN4twAWZjdHi1nLC
         J2PZ4Dk/fD/Q8y/xMY98A9i9sY+VNDIsD8xqLgFo9vThxTCPSPi68kOmzuN5k7Wvr+Of
         FMPBB5mvd3T16K4kvFqkctPTselooyXPQsD+AfGtFrbmoXsSN2DrOdPwO0tdSTpT1PFZ
         7GaA==
X-Forwarded-Encrypted: i=1; AJvYcCWSezMAWfsPR1xSDPU5o51G731N4PPl8g+PRF/GJvgDEDFKdme4Ilu+kapB68FhkmaGmHiZPDeeetRo@vger.kernel.org
X-Gm-Message-State: AOJu0YyfWNfEXhrVj1dgLILi7tgCWYrsJFo0xCTlxpvPOtAkXC5FipSo
	H+P6sKmp/ke4RwzcAlRcgh74HfD+xKWgZIRRVSklzYzc35l4ZnyO55g3Vzq4QjE=
X-Google-Smtp-Source: AGHT+IEkur/2TMh3nHuCwbzuDMOeSBOL2CoeT6JJvsVoc4YY3rIbNXOfhuMtLzWrvW4ipUCr8hmyQA==
X-Received: by 2002:a05:600c:3ba9:b0:42c:b995:20d2 with SMTP id 5b1f17b1804b1-42cdb538612mr85896745e9.3.1726737142780;
        Thu, 19 Sep 2024 02:12:22 -0700 (PDT)
Received: from smtpclient.apple ([2001:a61:a4f:301:6884:c2fb:6f00:dfa0])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42e754095c7sm16809875e9.2.2024.09.19.02.12.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 19 Sep 2024 02:12:22 -0700 (PDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3776.700.51\))
Subject: Re: [PATCH v2] ksmbd: Replace one-element arrays with flexible-array
 members
From: Thorsten Blum <thorsten.blum@toblux.com>
In-Reply-To: <CAKYAXd_T4JzjOVFqxSt=RQG7w0yzPX62-AihQHUepvS+80BZJQ@mail.gmail.com>
Date: Thu, 19 Sep 2024 11:12:10 +0200
Cc: sfrench@samba.org,
 senozhatsky@chromium.org,
 tom@talpey.com,
 linux-cifs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-hardening@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <4881D699-9109-47B5-927F-B048479C48B8@toblux.com>
References: <20240820191520.100224-2-thorsten.blum@toblux.com>
 <CAKYAXd_T4JzjOVFqxSt=RQG7w0yzPX62-AihQHUepvS+80BZJQ@mail.gmail.com>
To: Namjae Jeon <linkinjeon@kernel.org>
X-Mailer: Apple Mail (2.3776.700.51)

Hi Namjae,

On 22. Aug 2024, at 14:01, Namjae Jeon <linkinjeon@kernel.org> wrote:
> On Wed, Aug 21, 2024 at 4:15=E2=80=AFAM Thorsten Blum =
<thorsten.blum@toblux.com> wrote:
>>=20
>> Replace the deprecated one-element arrays with flexible-array members
>> in the structs copychunk_ioctl_req and smb2_ea_info_req.
>>=20
>> There are no binary differences after this conversion.
>>=20
>> Link: https://github.com/KSPP/linux/issues/79
>> Signed-off-by: Thorsten Blum <thorsten.blum@toblux.com>
>> ---
>> Changes in v2:
>> - Use <=3D instead of < and +1 as suggested by Namjae Jeon and Tom =
Talpey
>> - Link to v1: =
https://lore.kernel.org/linux-kernel/20240818162136.268325-2-thorsten.blum=
@toblux.com/
> Applied it to #ksmbd-for-next-next.
> Thanks!

I just noticed this patch never made it to linux-next and I can't find=20=

it anywhere else (also not in #ksmbd-for-next-next).

Maybe it got lost because it has the same subject and a very similar=20
commit message as [1] (I submitted both around the same time)?

Thanks,
Thorsten

[1] =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?id=3D7c525dddbee71880e654ad44f3917787a4f6042c=
