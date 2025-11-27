Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91218332ED6
	for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 16:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764259871; cv=none; b=LW9ol8ZM2EE10fbRfnhT2Jmiqz6lVkRAl6KaKlIrnR81c07TQWFwgTWRAD/LPuUCKxD14C1rg5Dy9RhHoYHBrxPrn+AqNKtrvqgi5OSoU0UlNGTrElbHSPL0IOlcNPNGZskfAqPA0AYuPC68ZGoO1zlfVjs8p/iXOgPXjUkyy60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764259871; c=relaxed/simple;
	bh=9vjHzIMca4DdqffLuqx5DHjylG7Vc5s91WHgJ+iLS+s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dDPRrI+tRrIPyXmlulMS1VRXFf6mmgSEYrVaguDWq8tZZDdiMdgGn/Z1273xBpMSnhpWtgX6dJZ2OBCxrpO6FHINiFuM0UGeRn036W6lHRZF12Vhv2mLLKOY3FgEDmVZsnvJFWMY4SKXDz1SwyiM0CEVk1/kYpS6c31rw7F0eLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e6oa5MEd; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e6oa5MEd"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-340bb1cb9ddso807095a91.2
        for <linux-cifs@vger.kernel.org>; Thu, 27 Nov 2025 08:11:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764259869; x=1764864669; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9vjHzIMca4DdqffLuqx5DHjylG7Vc5s91WHgJ+iLS+s=;
        b=e6oa5MEdZBqPGm0VEVQ+gV5fUlif7dU0Man6RR78vLEiOHaQaZ9F+pbdogeCR6BbtW
         x84PTVnAMy6LLmuxuODrJDc/LchZR83ecLaVMBaoYZN4tgClkJ3JxGkx6RMkW8nikQMm
         vVMLMfkf3pjlhEziSYA0J8bQu7vCYpKplSMe2eJnRYd0yVvJQISPJeotih1YcRqwMbj1
         dpGc7oimyAIUhLd7ARuAV4Aat5KQFXbAyyuVleuMWJKZQAmLfnx63/AummhFwwOIMFev
         V2MOOHiUoyyzFyPwgvezugl0w3mT4GO1RlXmRVzXidRevuZkLUjh9mUDru4uE5yjbjSx
         i9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764259869; x=1764864669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9vjHzIMca4DdqffLuqx5DHjylG7Vc5s91WHgJ+iLS+s=;
        b=eKnsrKcOvAKEOuYoa6HrveA/6RX/PEBVTchfEacttkVFVeaxHOGrbV8aXT5elgo82+
         Ps10A2pzjvAdsUOOv9KDClvkSYVfAnECX2arqOfMqqf+8q0FUbi1UC7WoK2gzY/Pde5m
         lBMiGzNSfKMmTO2X9t4fouvv+ZphGPIs58tx8W4ZTUybgwVVrPNa1DFArj0zfAncA0dV
         YSvZflxitMsQ38Y0PguoBFace/2XfgOWwILIPN0y0He9SF919wnMbi78d3Pfs8VfxVn/
         d7KArZn5MDNTf1wdzFobHUmC2E2pU85ZjtfRY+30Q3ZUf+/oGK0ZX8tWJUWMUWX0XG7j
         pRHg==
X-Forwarded-Encrypted: i=1; AJvYcCW1Ur+4nXaFXH9DDY6pXYkeh1ytg0mI+MvUrnCPggjqlsDu/VKYAXFMp5PaIPnTOPY98RFoFmMxu13U@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ogDjljXQR60dtNzsnsPEi75QAaHnxGPuSNtr8ll6ZxgpnKJv
	3BXTfahgeS5hFKNSsaqpFyAY/L/411WCJtAhpyR7dBI6LDyHo60PozdPA35NqxVrj1AeTWF0S4v
	kwklHF5YZs1eTeFLU5TXw6837dD2Q9H8=
X-Gm-Gg: ASbGncujOL9e54AagY0888bqAflkpo7ZYqBIMbv0xl/d1jK5mOeGSgHE8wUQI2oukMC
	ayfI2Z4UEO2HNnxSx6MEaZbQ/SSXnBiYxULq+rhltWf8GnNet+VUmXxNJB6ti9ol8x/L8kqw201
	KTigAa32GT4hmQ01cLk7NxCsuEGv95O3tXy2vHUmGrZRiBA2/vE4uoH3xfwe85coljZQ7gQUlQJ
	ul6f7eNMxnQdGybrD12qyOrgE082Bp1OpA06QA6BRBAzOov1vwUoYe85a6wkRKlkhRQrwpK69gB
X-Google-Smtp-Source: AGHT+IHwqwVIUTjCZAfmmXEk2d+gHSisxrBzmJwH7eCbdTvE6FUSwfBBHmH2R7a/9TOywFWtvE18DTpe+SZYcND1oeA=
X-Received: by 2002:a17:90b:578c:b0:340:ad5e:ca with SMTP id
 98e67ed59e1d1-34733e726ecmr25200360a91.12.1764259868810; Thu, 27 Nov 2025
 08:11:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251127150512.106552-1-nkalashnikov@astralinux.ru>
 <2025112735-vertigo-jujitsu-4647@gregkh> <CAKnNz1OYAG-cwPEU6AuKr1mmGWiEzP1-ss9v8K38xspiHFdm+g@mail.gmail.com>
In-Reply-To: <CAKnNz1OYAG-cwPEU6AuKr1mmGWiEzP1-ss9v8K38xspiHFdm+g@mail.gmail.com>
From: SIVARTIWE PROST <sivartiwe@gmail.com>
Date: Thu, 27 Nov 2025 19:11:23 +0300
X-Gm-Features: AWmQ_bmVcnpg-VfaVDMgD_dGwM3deu9dUQTGALIC98ulNFN-1HLpehGIwmv0-Os
Message-ID: <CAKnNz1O96ecFb0F=DZkN4iC_+jS-aFnXWVz-TuX0iYGxGQ5_cQ@mail.gmail.com>
Subject: Re: [PATCH 6.1] ksmbd: fix use-after-free in session logoff
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Steve French <sfrench@samba.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Tom Talpey <tom@talpey.com>, linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	lvc-project@linuxtesting.org, Sean Heelan <seanheelan@gmail.com>, 
	Steve French <stfrench@microsoft.com>
Content-Type: text/plain; charset="UTF-8"

Sorry about that! I will send the revised second version shortly
