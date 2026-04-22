Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD521314A6B
	for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 14:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.217.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776869393; cv=pass; b=PUcvGhkaYMuadv4JMeg1IFVj4IBuaNzEEhiH2cvGhSC85Axnj0ymMFUrawHlVrjjPeBBzkwhZi9nGy1NWomky7oBPNa+vaL8CwalkhXzMDtFsvkbVz6OWo2UD65fMKSye+z5u8SA1RsRzzohBK2dABcrlqa+sSXG4kDH4A/kuyA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776869393; c=relaxed/simple;
	bh=t2XbN8ULAb+GBwQSJq0X9aog7nk2s64iwqFA/9Fv6hQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PC/zAfWZQegsDEhwhhgDBGUX0akhwkv3240Uxuo/xERZaeTV3pu6cizGC0EpHhNeSUQOKCl2F+Qfud+cU8O0dJSufcEkUjqXWpOE6p7ukDgcwqOYN9bN5z4daEveWxR6jMVY999QRo/sGn4nwtKRIgldy58I0lCSVFTvJlYSjRY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PavkPGQS; arc=pass smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PavkPGQS"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-6121f20650dso1804803137.1
        for <linux-cifs@vger.kernel.org>; Wed, 22 Apr 2026 07:49:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776869386; cv=none;
        d=google.com; s=arc-20240605;
        b=emDNvRwpXSN3FHsnrFLRMGIDdgB+s/TpV+4aFDC7gRE5vI4xwG2Le1pJgwHO3KdWkg
         7lPi7SVq5kF029tEO+0+5BcGtn1MtLfOtv/81KGo4LblpR9H1X7MFP5C5Wco2qfS8v5S
         w0wk8XGLrj5V4Q69YxrSsQUnTV8AiIoDYuV1DjkbLPulaQdYIvv2PA2Iw4dkqdAjJztB
         mthwUK1BWwIAQFmOjEyvcuvycR8fGV8WyXTZdNtgGz6wtxUMIakO3s+uOYRnwMoIXT67
         i7An3q4BA8Pgy/kPNkFpwwgZNpugWvP+ytrtpw8HlLCN0bNG6LFtLNZ9XM7BgQjWLaGN
         fd0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eAJBfQ8yKFwcszC8n4aL6C6Ym0YtNvc5vil4gI8HbLY=;
        fh=nF+EWMsiNiu1MANMTQMhM2c7kgA9CPVXJ7SvhM2OXQI=;
        b=FBvSMnK6SHoyOc8Zc+b6lsV6B+T3qcvkJLsTkNfyHWZX8xcBQ0/z9Nacxu6/YN3Une
         NYmoydrKib3DBepXXvGm6yscezu/wobpcRR8dlXHslh+ZlZZvONEAElNOg7nRAkjl6wX
         zGOsvp1RSPdTaR58yHlTNEy20pBcof9LOXB/N8Jx5rKHP7DWlngVby4J6AhEOVsPKf0P
         45x5iTIoIdStx03EkNjtN0Z0a60el4NbNED6xy4fcYYDbfDkGfQztE7j73oT6zSiqYtI
         duWGdU7OixqKFUxsLfg++5V9l4nreY06Ya776MLriQXnVcQs1v0PeYlmGt+L2vSm7+sb
         XEXA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776869386; x=1777474186; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eAJBfQ8yKFwcszC8n4aL6C6Ym0YtNvc5vil4gI8HbLY=;
        b=PavkPGQSrm67SCvoEkjxKqeVDJpf87RFHgfX70qWMonI948KR8OsAH7peaRSXa8N+L
         clc2DKRMIdfjY2XyIyoovf2ofRdwHCZ5y5NJYsr+C4WnHuHnQs/DmjKNr0717mv6OtDL
         eDhOhVyxmznoBpY3u/Zelpd/x+URfxzyaIOIEaz91AKnJ40VVprx/zWn1mppEIkJCAMH
         RFhR7QvyetudXIjwmL7Wsjzw8sK33F47c454cRWbjiTwnaCDEEX3LIVJnlK3fsCoECvZ
         v8rEN3PimrpQEMPV+zRVqXo41bwkX8sthSULAVb3wEBlBbpat72q8JFGIN5+UAFZBXd+
         IK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776869386; x=1777474186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eAJBfQ8yKFwcszC8n4aL6C6Ym0YtNvc5vil4gI8HbLY=;
        b=O2JHNPOuvRYTYZd8ZZx03yD3fbDOulQ23DN1kRqsqlif1Pg39YCqn2vwKf705oDzV6
         GSDxBOpFPWd5SA3KbuGGt9K9CVniLknF5UKaR4JIO0bhA/+ZuD+f9mc9Pt77WUgBzn9o
         INT3XD7wSqRs86su3gsBrhGd6069xmiT3rDN/DK+AcEDW/ByN4YIOw+NR5z02geWzVIa
         PEJdpU3y5/e+2YVcXdmxqWPkBAwwh8JaYsIMcLFwSh7Hf6KE5JEV0y5aWPaa0Qudw9x0
         BBpt1ecYGtFA14PfHbnVVxvUSD4bf6KHwoSk5jabyrbvtouvn9S7xGGOPC9wpVIS4SWy
         X9Yw==
X-Forwarded-Encrypted: i=1; AFNElJ8Dug1oxqTVrFpPmes+9H5r+rl+A+hAEUsi8nab6nv8f4/MgZGLlp6sCkOyYE8VkUQ5gwXk/xWPxz3Z@vger.kernel.org
X-Gm-Message-State: AOJu0YzvhIVElBP6rdhCxueNcj9q6madTiTzxoiP5e0Kd2JIKd37hf8I
	rsmkZOx6oin8E3OLHiYJYyyiLZoeNepRKBzSTFor+TmWV6ua6T2eI8Dt8urQaR+dMrpMpcpkckQ
	v40cOYvgrJXLlAFZPOMDzqlN77K6s8xStdQ==
X-Gm-Gg: AeBDietiQyYoqiaA+w+YHLbz5q0o0+kINP7Ayyp73KWCszLmJgjQcSO9GIjDv4pIdEl
	/Wo5FOD+BVDAliSq+gvfRPgbcRIkhfO1NPN69ocun055PwKBU37Rkdjqnk+iJ7ofS8KCO+QJIaa
	k2LctkGCY57xuEk5+jQ2ESlr9Q+F2bCvzn8QJc/7r0+gElm4IX8Ll51qXWE61Yhlx2Jp5hXlaZS
	A9DUpDoLUHt6plLn8D0Qd12v2Vzv1Sd3D5y+erkuV5HcywkYWGh6Hdu4qGNZGIA6Iosjh4uEUQP
	uHYKAbO5XItaOFKbhq5mKJWXgIvoJ7SJOrMW1T9uXiLOZj1Zym4R4zXO002pyngcU6cADNkP2hG
	/W+/PwyfgMrJIRmGFzE2hsRu/ljwu6DKOB/W2WXU9hUuj6cZz+iTorVz23f6QFnNorPpYwsBJYA
	==
X-Received: by 2002:a67:e718:0:b0:5f5:4055:4558 with SMTP id
 ada2fe7eead31-616f4546fd5mr11177594137.2.1776869386083; Wed, 22 Apr 2026
 07:49:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260419192018.3046449-1-metze@samba.org> <aehrPuY60VMcYGU8@infradead.org>
 <9cb0901c-18c5-4858-941c-3b37ee112af9@samba.org>
In-Reply-To: <9cb0901c-18c5-4858-941c-3b37ee112af9@samba.org>
From: Steve French <smfrench@gmail.com>
Date: Wed, 22 Apr 2026 09:49:34 -0500
X-Gm-Features: AQROBzCYzdLfMWSd1uFLJ8XC1YCZMAbk3sG8ZrbfCGB_aYlDD1y44LjlIIB4UJs
Message-ID: <CAH2r5msb3-HiPSv+HgBknEwDXGsv0xU=TGCxHdmc-VCLKzYCmw@mail.gmail.com>
Subject: Re: [PATCH] smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/
To: Stefan Metzmacher <metze@samba.org>
Cc: Christoph Hellwig <hch@infradead.org>, linux-cifs@vger.kernel.org, 
	linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	samba-technical@lists.samba.org, Tom Talpey <tom@talpey.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 22, 2026 at 3:16=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> Hi Christoph,
>
> >> diff --git a/fs/smb/Makefile b/fs/smb/Makefile
> >> index 9a1bf59a1a65..353b1c2eefc4 100644
> >> --- a/fs/smb/Makefile
> >> +++ b/fs/smb/Makefile
> >> @@ -1,5 +1,6 @@
> >>   # SPDX-License-Identifier: GPL-2.0
> >>
> >>   obj-$(CONFIG_SMBFS)                +=3D common/
> >> +obj-$(CONFIG_SMBDIRECT)             +=3D smbdirect/
> >
> > Why is this not in net/smbdirect/ or driver/infiniband/ulp/smdirect?
>
> Yes, I also thought about net/smbdirect.

I would prefer to leave it in fs/smb for the time being, since it makes it
easier to track since fs/smb/server and fs/smb/client have dependencies
on it.   In the long run, I don't mind moving it, if it starts being
used outside
of smb client and server.


> As IPPROTO_SMBDIRECT or PF_SMBDIRECT will be the next step,
> see the open discussion here:
> https://lore.kernel.org/linux-cifs/cover.1775571957.git.metze@samba.org/
> (I'll follow with that discussion soon)
>
> I was just unsure about the consequences, e.g. would
> the maintainer/pull request flow have to change in that case?
> Or would Steve be able to take the changes via his trees?
> Any I also didn't want to offend anybody, so I just took
> what Linus proposed.
>
> Using driver/infiniband/ulp/smdirect would also work,
> if everybody prefer that.
>
> > As far as I can tell there is zero file system logic in this code.
> >
> >> -#include "../common/smbdirect/smbdirect_public.h"
> >> +#include "../smbdirect/public.h"
> >
> > And all these relative includes suggest you really want a
> > include/linux/smdirect/ instead.
>
> Yes, that's my also my goal in the next steps.
>
> > While we're at it: __SMBDIRECT_EXPORT_SYMBOL__ is really odd.
> > One thing is the __ pre- and postfix that make it look weird.
>
> Yes, the __SMBDIRECT_EXPORT_SYMBOL__ was mainly a temporary
> thing, now it's useless and I'll remove it.
>
> > The other is that EXPORT_SYMBOL_FOR_MODULES is for very specific
> > symbols that really should not exported.  What this warrants instead
> > is a normal EXPORT_SYMBOL_NS_GPL.
>
> I want the exported functions be minimal, as most of
> of should go via the socket layer instead.
>
> If EXPORT_SYMBOL_NS_GPL(func, "smbdirect") is better than
> EXPORT_SYMBOL_FOR_MODULES() I can change that.
>
> It means cifs.ko and ksmbd.ko would need MODULE_IMPORT_NS("smbdirect"), c=
orrect?
>
> Thanks!
> metze



--=20
Thanks,

Steve
