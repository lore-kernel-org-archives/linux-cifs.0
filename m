Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8955F155C97
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776968595; cv=none; b=frEwrF/jvZ1o6HP/t66Ozrsjg6BlMu4nfNlkpCfWQw+SA5P3t9CHGHu9Ru0d2UE7VPTKhuGqxtFZkYnX+F4cwNdQqnxAubf9zHWZYg0VS+lms0cGmPy/mPbAEhUnThjvQ+JvAzXkTsj2EabWuseE0hjjuk67xlYKFp8SZLEBT9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776968595; c=relaxed/simple;
	bh=qDlcsTSS0i/a6koK1dHpA3wrhMr3nawQZ2fGug/ix58=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kRDYhHhi9IHuZmG/KRZYjTapwbmECxGeOt6xVY2q2VevB1Ckh5wz/QfadFFAkWDxE5/89RAzRARnV/Pd5ewO36cdS1uBDFWPcpQddHzT7/VKZf+df8bd+syADcRaFRYwdKFIUEMnier0xJ5+lAL+ilseQ7HyTNZuwJvWX7jI0KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=purplesyringa.moe; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=purplesyringa.moe
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5a3af1b7549so8791734e87.1
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 11:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776968593; x=1777573393;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBMP/ZPFjPbIZz2B5VSFwTj55rODg4vXIuq33RZC83g=;
        b=SPlq7FycQ2otVlfVMddr4u/cYf/avq4bIdOabY4BUySJHYAAg3HI71I/lC9V17o3cF
         MC3VKKjG8pGB85mdnEgEFJzKmRXRsZGUnMJzbMbwOA3YVj1zuf4JxZjhfI50yCrIT/ki
         3y74soGyz0CeWnj1h8XlEK3sqN53wJw9rIt6NdFul3gr8+Vq5W+A/mI+tZQwGxonXzGe
         Siwg5zJGIh4xbkX1NM6UcL+oUXQApOfCkmO6AaCLaNNgD0bB/5cB5eMpTCW24DIzjjm5
         OXquxId8ssSdYmsFURg6mQTSpiz6Bww1Uny4wBtlyxVCxMJbXL3QyUSRH7L+PSQdZO2t
         vXng==
X-Forwarded-Encrypted: i=1; AFNElJ820MlSbNCe+jQqe1u5sCx1I2CJKo4rHSH1rbPnwjvBBCr8/+EBHjb3Z1w1n2h4Gd28AIOQ4gZKddiF@vger.kernel.org
X-Gm-Message-State: AOJu0YxJoL8a+VnDRkbBqWLSUr1PXIliFLe/e+LUbEplpOBMwY2Qw1VT
	RTCxGXVnaaJMbGJO2ReMM6/lhdNcjv2ByGfmAOmHfP55Kkw9zrQIHdg7
X-Gm-Gg: AeBDievuuVDqv8KjiijqCELrwDL+hYb7yT4dwAiH5kbU82j2eEX8iPi2CNfbtjOb7jc
	2vsOmTWMKnrcQEvVLIDsgpZzPtgftpcyry22DpjAlFD/mrudE4Dq2Tzc8RBFsSX/Yv1VxhX1oR7
	l3YH5EgWlB8zkPY5QJKU/7o82dWG50H0F3USzE+PIoLdSo7+3xO6UTaQqRDZX0XPmpjUjs4xDub
	fky3bCiw54awSXeMrCDuK+tqxDYufS3VN7VJuHiZdtsUawiZYt5c5OBwcwt9axUkZQsD3HwxU4i
	Ekz7HfOCbts5Fty4AKBVIXQnaqe2tH5cf+B5KlGKMyjr7JrNMdenb+qI11BXnrJMFytZY0U+okv
	MxzB26FkHC7fusRC092gqTW23Ktlve4g1qr+KJfn4GP0rbCrgtBeZnGIK9QVT9Rv+yvNy1Ox6fR
	O3rv7ODMW1sdZxtw08cxkEK0N1XWigCNVUnnNTxIlBbql+KRIe8q8UVDTT6/WuhjzEDdbSCvguY
	aKr0CuDEsOuXFRkpno44bvwNx/m
X-Received: by 2002:a05:6512:3ca8:b0:5a4:10b5:6246 with SMTP id 2adb3069b0e04-5a4172cb407mr8920305e87.3.1776968592559;
        Thu, 23 Apr 2026 11:23:12 -0700 (PDT)
Received: from [192.168.1.8] (95-24-8-205.broadband.corbina.ru. [95.24.8.205])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a4187ebfd6sm5300694e87.78.2026.04.23.11.23.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2026 11:23:12 -0700 (PDT)
Message-ID: <12dda998-0e1e-419b-bac1-0863c02659d3@purplesyringa.moe>
Date: Thu, 23 Apr 2026 21:23:11 +0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] smb: client: add support for O_TMPFILE
To: Paulo Alcantara <pc@manguebit.org>, viro@zeniv.linux.org.uk,
 smfrench@gmail.com
Cc: David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260407195810.993862-1-pc@manguebit.org>
 <20260407195810.993862-2-pc@manguebit.org>
Content-Language: en-US
From: Alisa Sireneva <me@purplesyringa.moe>
In-Reply-To: <20260407195810.993862-2-pc@manguebit.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/7/26 22:58, Paulo Alcantara wrote:
> +	if (oflags & O_TMPFILE)
> +		opts |= CREATE_DELETE_ON_CLOSE;

Shouldn't this (and other similar places) have used __O_TMPFILE instead
of O_TMPFILE? O_TMPFILE is defined as `__O_TMPFILE | O_DIRECTORY`, so
`if (oflags & O_TMPFILE)` includes `oflags = O_DIRECTORY`. I don't know
my way around the kernel well, so I can't tell if this code path is
actually reachable under this condition, but the kernel uses __O_TMPFILE
for this purpose everywhere else, so it's inconsistent at best and may
be a bug at worst.
