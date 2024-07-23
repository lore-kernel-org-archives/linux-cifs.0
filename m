Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA6B156F5D
	for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 15:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721750227; cv=none; b=u9naPwhHDgMSGnBrJKA4NLLZ3I2350usYJNTqLJJDTnNzyISfijgaiHhajRl4KxLEJddR5Q46J8AAhPlKyPeVLRI5oHmtLZBdiMyKnqerqvXNG67jRDSR+ixZaytFdFnQokVzFIXCWabtY1CFq45p2JGGNdLFqnfpW4LShhjX/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721750227; c=relaxed/simple;
	bh=Zpb2jUNp+6n4ia2m1zlAbhH9by5nT1MbWQ1N+pAbhDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QM6ULHU+xVrwysbMkT3M192wmed59WzQCDeFxDVPhbkwz2phVNy939+zJcFyiaqgLOLDJyf2klKM4b5wmBmoONTHBsvmV1/O8janjqs8f5tcgVZYp1pkohXazvxp8D873OTyveyEseiPW4xeOkV9hGkW4NkPjj9atoqVGWcT25g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PAaM0P34; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PAaM0P34"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5c690949977so2912942eaf.1
        for <linux-cifs@vger.kernel.org>; Tue, 23 Jul 2024 08:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721750225; x=1722355025; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zayzyEF0HDNfGexwghwsG3+f51G87k4gmb/Z4N6T6t8=;
        b=PAaM0P34JxxCHKzqLnnTxMuqMFJP6PSf2bbpuSOMBtnGPygwXXgkf1zQHwKEHP65XM
         Bm9MAedHhM0agmeotpIOc7aOF/HPcBPpvVk9tR8j9wnlx5BOlETjcFs68nuNI+2Y+xv/
         rwKCLO2FgCeRs5lWJCwrQDeZsD07fmhrF/fjWId8xQRh3hsbHXECmkZNjB4G/qqQ7pT5
         Wc4cg6H9hLTj+3+Qi6XdbsFq2fiMo+DNwvx+poRImaiBx8nhAQLqQdBGq0WXcnyHbOxD
         6fbO2yF1nYt6IXA+RUwn8HbbOLe7HmgGgjqR9H4L/+B1lcVYhq+MKBJniCBzbkepecgS
         09XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721750225; x=1722355025;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zayzyEF0HDNfGexwghwsG3+f51G87k4gmb/Z4N6T6t8=;
        b=xDVKYnH//z1aduhX4dyF4SjcK+YOvBXhRkfkY1ySaffN11FTCmyN97628BnqXk6+JW
         N1pLYXUcLFoB8cR6n+ErebnAiI9OM0seL4MTB8ZqI8a5uJsATl75YOY+TXbCFFPo44i1
         V4jhtOV3d+RRlzxS7VRA4a2gzJ0uaSctxyhM2AFk8Oh6GCXmL9XnE2303+wgafg4UPSP
         f31Ow+AYo8TDNS2D/+Z6OnsTCyXIi9cyJPNoLqu+UBHk53xh5kX5w4d49gSAdzAyvhYo
         u/0H7MAe8WqSVLFdpC/k99U9WgxJfXox0rpc5EVQUd7ra88GJ0y8H7+NWKyBR5vcIjh8
         3/+g==
X-Forwarded-Encrypted: i=1; AJvYcCWRCdCG6lDSuzwkHuNisXBe5OuNTMmpZOy0GwwkgAdb9eq1k/OloQoghIPJhDbRPIChIvrG1Imzws+qConD8xjvrUG0FbaqTsES+Q==
X-Gm-Message-State: AOJu0YwPZA9NNy2QTJblVymvxoH/0ujcUhm74yrEP0t+otIx0SgXfUEX
	VCsvPiSZOzJD/gb6AyEZbLDc9A87faVowhDnxROjg7teqfH3P8h30wmUoR97TbNXeCjOP1VTUbg
	I+sQ=
X-Google-Smtp-Source: AGHT+IH9pZ1mahlmw1EqLS18v6BTEB/WObDDL2e294AqtcVG0gnOUIS2mo4PT62Ei2FilkkPhpTmCA==
X-Received: by 2002:a05:6820:20c:b0:5ce:e851:7355 with SMTP id 006d021491bc7-5d58b705b9cmr4186443eaf.1.1721750225385;
        Tue, 23 Jul 2024 08:57:05 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:eca3:bb93:d28d:1005])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5d55a832207sm1759764eaf.16.2024.07.23.08.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jul 2024 08:57:05 -0700 (PDT)
Date: Tue, 23 Jul 2024 10:57:01 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Steve French <smfrench@gmail.com>
Cc: Ritvik Budhiraja <rbudhiraja@microsoft.com>, linux-cifs@vger.kernel.org
Subject: Re: [bug report] smb3: retrying on failed server close
Message-ID: <a2ef267e-906f-4944-84ab-1b9f35f8e7ca@suswa.mountain>
References: <6487f3bc-102c-40a0-96ec-dd97dc00c49c@stanley.mountain>
 <CAH2r5muSF5S3D683evO4V6=EANqXbeC_HZ+ywPb_12aUDQ53yg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5muSF5S3D683evO4V6=EANqXbeC_HZ+ywPb_12aUDQ53yg@mail.gmail.com>

On Sun, Jul 21, 2024 at 04:00:57PM -0500, Steve French wrote:
> This should be the simpler way to fix this, which matches the unwind
> ladder.   I moved the goto label to the
> correct place so the frees are in the right order and switched the two
> gotos which were backwards.
> 
> Let me know if any objections or additional cleanup you think is important.
> 

Looks good.  Thanks!

Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>

regards,
dan carpenter

