Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7A0199BC
	for <linux-cifs@vger.kernel.org>; Sun,  1 Jun 2025 18:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748804066; cv=none; b=Fu0CrfWggFm3WUAmJs+QDSh7nlOd9tNzcc9SxuTO4aMkAZJKb0sp9RI74l4qWlX6OMdpfB1Kf3zIjUHUPpNP9tPQwS30uFbpFRmRgbNSblOKb9x8TmMXXfiFwlroueEch4x1zjk4eLirp/lw1EDALN0TRJ/HVMSC2w8kAefkca8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748804066; c=relaxed/simple;
	bh=g2BxiKR4sYZm9epK271ZfvrGZAhn/QsoSbgKvPENZ/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Pp8D+e16016ylgqYtKBOGY6n0HfKJkqvz1YVJXPH2MbjQ0W6TRBjR27P8rw4wxAtN0ZuTerra/Z8q7a9e12n8/MLubGUC9B2Gd+/ov/7nWHIYk5wtyibYfV6xk2XgFt0FnvL7KtTGu7YtVNposgQR0YrrudJeORJgLUvEDyfyZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sibQbJBN; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sibQbJBN"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-54b0d638e86so5688698e87.1
        for <linux-cifs@vger.kernel.org>; Sun, 01 Jun 2025 11:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748804062; x=1749408862; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQc6vmO0BC0hUo1BQ392EcyBQ5GD4LC5NIpIZutnApI=;
        b=sibQbJBNsPXKkLDAfWsC3wQQEMQRuaC/adbr/3gc767AOZOBsT9pI0X+IH+XKs+oqQ
         7tHHxAVphJFLxdScAYdlaWO417FEb7QunlLx8Du4cpP6O5HK0mxSdv94FXxTuIeLD4cD
         WC8L9RqZgJtvyoPUADWmAsQEHE6D3TnMbarF8hOugUfe626YhLYauiBLRDinSTmq+LEs
         EQT9cxWhK6XrnQYm250/gxKdJDFUVV85qiTj1S0U1Wt+gKOV2Pt++qv8San07gfxO03B
         XTZrLnY1kVISHp+mni1oqMiv5Z+FVCzYPA749ru6G4geaYt366USI9jS6AVVymh2/6jk
         tLaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748804062; x=1749408862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQc6vmO0BC0hUo1BQ392EcyBQ5GD4LC5NIpIZutnApI=;
        b=QKIVXhzpCWU1zkuUnZXyRg0ah0yxNj5v1O9YrznxjYXrczHpTa4WeFhtaxPqKN06z9
         LKpnGzhs9P9VSJqTH192IhhYuaSCgxlTBm6zwckA7kU3afaVgqVy5xlcKhATxgAH2TNm
         GRHW+q7nG0InmqYUdZMj45yizMWs1SshZoFG6dlP4FcIiTOFehdZgazZLOIpp9eka6Bp
         LXyYrHpSCvRrnN9Z9sh86+JkfVAw1+JMCMGzRjTc+CD+cjJiylx3C5f2jc/btVJM3hX3
         3VVONmj6RzvuKo3Pt8PiYMKsom487NcaA3NeA0VM46adqdkgv0mem7XfrIksZxJymyC4
         4Imw==
X-Forwarded-Encrypted: i=1; AJvYcCVED9YpEHoFpT4ynn79Sg3UHgxw9TmYB2h5F+JD40b9cLbnnHA1ihzy3d72mESiKjCulzzcpaMonvRg@vger.kernel.org
X-Gm-Message-State: AOJu0YwifSB3W7iCNXz51EWwlR7TcZLaK1ZbmptIUv+HQd98qOAMlhWy
	YbOG3GHZqteGR2sGx9NR6GUIGeRNxwqeUyOXzpeW3risjviUqKiHVkTPZs0JfXZGMLBV08YRzBD
	u4Vq3lWbEPOKZxFuk33atfr8ZfgqojoMxH0xCO2O1Aw==
X-Gm-Gg: ASbGncvdZCUKAG4S7O8F1n0YqxMFBs4qqIxrhfu7+B/MdEMznG9SelXDCGRMm4ArKpH
	iTzhXYqmcE82W9CY3EtbCk5BRKvdqrjROOOpASZKbzdytSX/hjcESXGqlal8UmUkkNXjDhWXK+N
	BdKxwIfmxpoCyIr5Bo1FOugyb05QUD9hyk
X-Google-Smtp-Source: AGHT+IGCUoma5i89qOJDa+SylyAQOCBINqmczmza4TubGWetjoITioVbRUDfP2otKGv9KXqR8EWE9XkDoxFub4qtuLQ=
X-Received: by 2002:ac2:4c45:0:b0:553:358e:72a8 with SMTP id
 2adb3069b0e04-5533d1aa8f5mr3054369e87.38.1748804061951; Sun, 01 Jun 2025
 11:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250531-ksmbd-sysfs-module-v1-1-248cf10fa87d@linaro.org>
 <CAH2r5msU-45Up+BovgpwQ2eV5o5aRz+j+zh6jZLvn=ZsmNuNeQ@mail.gmail.com>
 <088096eba2d038bce2f73e6519d11ce9@manguebit.com> <2025060107-anatomist-squander-d073@gregkh>
In-Reply-To: <2025060107-anatomist-squander-d073@gregkh>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Sun, 1 Jun 2025 20:54:10 +0200
X-Gm-Features: AX0GCFtBAdhF_4Sf_caMJDdT2bdU1Vr7ikQccVFV5Y-YqZWFw1np-OuFEttoGGo
Message-ID: <CACRpkdZ0w85ecgtjbiypG8K37eBF9hk-7oqSq8E9K6_+SE+nUQ@mail.gmail.com>
Subject: Re: [PATCH] RFC: ksmbd: provide MODULE_VERSION()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Paulo Alcantara <pc@manguebit.com>, Steve French <smfrench@gmail.com>, 
	Namjae Jeon <linkinjeon@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, Rosen Penev <rosenp@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 1, 2025 at 9:41=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Sat, May 31, 2025 at 03:49:47PM -0300, Paulo Alcantara wrote:
> >  So relying on that version becomes
> > pointless, IMO.
>
> Yes, it is pointless, which is why it really should just be removed.
> I'll do a sweep of the tree after -rc1 is out and start sending out
> patches...

In a way I'm happy with that result :D

But what do you think about the original problem of making
the dir /sys/modules/foo appear for a compiled-in module?

So as to detect "functionality of module foo is present".

Is that something we could allow (I have a patch using just
lookup_or_create_module_kobject()) or something userspace
needs to figure out another way?

Yours,
Linus Walleij
