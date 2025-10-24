Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3035626AEC
	for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 06:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761285945; cv=none; b=mQGGiTTomG8QmqPl6UpCt0YyfkyOoe4USP6IGmEViDuslY3fKM3+TnowYN0lu3wpaaw1tKF5oXj4RY/2xMiYQCHHWAiJpW7LvqvDlEu+gp4Y43YSpn32bg6IlqoQPEUrfMIP1mQv26+Ym/EPBJcGZfgX/el9BKa6sDZIRG1TygE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761285945; c=relaxed/simple;
	bh=fUnVoLtl4k12Rvu3ZB0RIsc+o/Ge6bZ+/L3aUmzH5Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cLJkgNqYeEaoagx8NAxHQjmByteHQjFSN3oaGD8++R4kblJ6VNNHMb/UCSWxQXjUX1F5T8gxVY+7VBjAoWl+GUgKzDwQVJK6iGOPgEavlvYHPY0dEiQA0Nltla9BoKoSWVtHnL1i3n0XpgV3AZHuKYA1QX3++NF2cAYZNwgBMPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EybBECiM; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EybBECiM"
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-378e0f355b9so6696461fa.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Oct 2025 23:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761285941; x=1761890741; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fUnVoLtl4k12Rvu3ZB0RIsc+o/Ge6bZ+/L3aUmzH5Es=;
        b=EybBECiMrusU2+E/1U+Pzsbpo/Y9iMB2/xDSW2zZmQIZlCA6V9+VBSbIQfyLrdGrdH
         2RuIkHqkDQCmkmLat6cSL/vig8vmLt+JDxlSSdnBe+BzaZ2IUMWrYWorqTDGpJtQLqgy
         DV6VHCb/n4l0nCMDZCdlmeyx4jggMI7GAK2k2oH1+2KU8McI1t3qumR758ClUU738SFo
         0+yBIRzbb9ZKHxzom9omBaJYXFDxL5uhpAI4i0kJDcIKkGXLfOrURP4uuHUdw4lIIvz/
         iPcSI8fMES+HqJl4DGW8U9qhlvO0g3juwlWpY6ENADj8Onv4rK6u4JAEGnDDz1h9osqh
         cYjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761285941; x=1761890741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fUnVoLtl4k12Rvu3ZB0RIsc+o/Ge6bZ+/L3aUmzH5Es=;
        b=vQ4SLG/ZlPEPuObCQWCEbMCGQvN2i6RjID5IU3mn2g+vMvTEeWTm0jGp1uyR9OEU46
         PUwuVvHeH8Lf1roVmmm8NwmHbpMVNPsn7FtR1S2Xu9LAfOL0fsQL7S34cL2cJHSbOTKO
         FIN4tP7I+jgv/GnsnjH5mZvlYazXkLtl6XqV3JrJ11pm0/NsMTwuENRb5v0IO4PnpQOu
         Y0HR44SWqdZRSqNMUolJwtxYwwkx0iaUy6it6qp+it374Lt7ZNla4/H04VYyApT2Chch
         b4vHgP6mOPz/kgR481gWHPuV/lNqvdvkMBLwrsnxvUznIo+GHOMX23o0SjLfNJP8t9r6
         xipA==
X-Forwarded-Encrypted: i=1; AJvYcCXEF+3DYvWXEkKGRAf4ZnZ17Krd5D8hGkAYNfjCLRcq6oPT6wX8rppvy3y6T/E18Ivk9JHyRTydCwTh@vger.kernel.org
X-Gm-Message-State: AOJu0Yyc//eisYjPoL5Ba4G+Hv8uWwhGEt+pMbkI6rqV8CHHssg4x4te
	IwfaDS1KCr9q4NsaqRa8Lts56XspfNTlFHyOL40JiXEF4aiE9Z7FWoalOPfeZVd8Jqg74SAVnsT
	I2TnPnL6G8WmfX94hfYc3W+m5LHxluKS+WgxYBup1EQ==
X-Gm-Gg: ASbGncvCc0sVt4dviCvB5ep94LPkCfD5YJBwEnTmbgLt/Bb+ki5Oaz2k234wL9b1l6F
	j/SZcT0HVlB6G3Qzk/yrVPTvg3uNgvCAa02wDriKy77KHRGn7O08HI2o2KgE+G9Wqx7DrA2Ny49
	2LmwMTrF7bsbpseXGXMkh6Da9AxKRTYbOpg6LVddQeStBMJRr9MC2YsV02ijKTl35ETO9c8fa6T
	nD6riFj9+qI1t85NK4uCUifbjPm2pwf+5nJCbuz3pugMLReqy2JmPrsGWyb
X-Google-Smtp-Source: AGHT+IEJISLoZ+5SwuU8bumDCHTUI5ekT/Aadn+dawLG545sE8E2caxA3Wx2Oy6HInJBwaHJak/fBjWgppKXx8rVTrI=
X-Received: by 2002:a2e:a916:0:b0:376:4430:b545 with SMTP id
 38308e7fff4ca-378e4648542mr3698861fa.49.1761285941031; Thu, 23 Oct 2025
 23:05:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251024-ksmbd-sysfs-module-v2-1-acba8159dbe5@linaro.org> <2025102441-calculate-accustom-2023@gregkh>
In-Reply-To: <2025102441-calculate-accustom-2023@gregkh>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 24 Oct 2025 08:05:29 +0200
X-Gm-Features: AS18NWCfrjnT0sDoiNB8xJyjRgYegh5F8BmOjiWv94kWcxYx9hqv-kGz2mRexiE
Message-ID: <CACRpkdb7puCMh4VdhcwL1kkwEAsU0e6S=4ZvL-LoXav_Xvu6kg@mail.gmail.com>
Subject: Re: [PATCH v2] RFC: ksmbd: Create module_kobject if builtin
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, 
	Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 24, 2025 at 7:08=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:

> > Since I actually turn off modules and compile all my modules
> > into the kernel, I can't change the script to just check
> > cat /lib/modules/$(uname -r)/modules.builtin | grep ksmbd
> > either: no /lib/modules directory.
>
> Then do something else to determine if ksmbd is in the running kernel,
> don't rely on a modules sysfs file like that.

There really isn't a good way for a script to detect if a module is
compiled-in that I know of.

You did suggest simply create this file also for compiled-in
module, always:
https://lore.kernel.org/all/2025060254-unscathed-junior-1b43@gregkh/

It just seemed a bit cluttery, but maybe the $subject approach
is even more cluttery by creating special cases.

Yours,
Linus Walleij
