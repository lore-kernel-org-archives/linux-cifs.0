Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3DB2E62C
	for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 15:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750521305; cv=none; b=mWm5ot2S7zNqOlF2EcJSbrm1F9biQ05LYPn9N7xjoq49ntAsZg2p5Uch9Ba9SFrPdAsZZwb36GrUT+4BbOaZ9DDGLyVLydQdW/G6Qy1QMo9NAttlj1zkjwrHQv82nK6r82cHRLJ2czGzoEXd0bxburPQF8OQ8f9fmMXT19bw2p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750521305; c=relaxed/simple;
	bh=CIn4Wr9BsGwm4DDKvO6sAJbx+1WscStWd1swyiS/SOo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JFyn9YJu4YJ/wc/3FNKaCI30qvHylMuEttfQiKaQ+LFFDpT9nS0aYRjVAzhWKndbq+IAWR+bN8UuvtGFqo/hUaSZ/IYsM8DNdN47x7puEepqGDC76+B30MWgS9x2wfiqOGSOx23cNOMKpFJcK7Ayj1K4EVVOeQ6MsTjU4kREqb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ePfTn0GV; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ePfTn0GV"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-addda47ebeaso585499166b.1
        for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 08:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1750521302; x=1751126102; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s2+CEQ8KLOqllFWOyXKexOZmK5IQz1uq7JRBj/abZLs=;
        b=ePfTn0GVGc8hoGHmWbFURKrpxYFq62VFBTzRHLVKJuSHAXgB8d6DiDme2vOFVk9c0T
         EktofxK4UARB+rVGE0p90uh8vIEcQOR6KlKWy7w757uc2qcYZfgmd4/yKsUrfGcYQnlE
         iyzn0D/aA93FH/VwYscjCaK4xdF7+nP+62+zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750521302; x=1751126102;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s2+CEQ8KLOqllFWOyXKexOZmK5IQz1uq7JRBj/abZLs=;
        b=AzcTQhkWBk+DZ/BIehb81bz3eG8Q3WpRScnSTH34/HcRwVowVdY9k/UjJhtVWOOpbg
         GLr3Px034/BfspCvQYddl2Do0qAJVsjY77mTN9XKXoprAyDh4kfIrNXlHkmnQY50gtWr
         asQp+tmtz/wICZOPvxvtW3YrnxlhyHgT+RWYpkbiMBw2EwySv+UCHpBmxaxQwFZSXh2A
         76v0x7rl+ibfH3IBOgDL1wX+4FJc1Zmr11OtP1qgGR0JsTfolEifgaqK4TrWBU7+5ZO4
         MVIrwowFekFFqDUIHySmySeQwHptPyoNmMJc7mtLqtuxFx4TUFQyDxjMnMPokWgoSHBG
         b0CA==
X-Forwarded-Encrypted: i=1; AJvYcCVJtesMUt0x+GcMyydEdvK1xCPTh9OmptYqsme+Xgql50wmDsSVo62G+TXps9neF1HdN0gDCAray7vW@vger.kernel.org
X-Gm-Message-State: AOJu0YzTIlpTlvApDZWpQ1UkQM/BsC16Z3AlZfGMM9UQRTRBJ7RUH/EZ
	xSZ9oFyYQxw4Qt7s5AS8CEjWwCzv6mhmdQZlMkLZJ+QthBG0ft7RaOyK4VxnJRViFOUnVmPS0no
	a82dMCNE=
X-Gm-Gg: ASbGncufK6tYXxLm3oL7IhTy/Wlx4LVEN3PCe9WYrdFelbULgnJVHRttXzOmQ+0lNQE
	dfm7xPCK7i+WqCJYKM2eAwF6AWi5UF/puyiihh9UZO+ifSsFA5gWuP4o+9Hod6SnqiVhh7PsJqw
	K0SbD58MUVYE9ufYX+aGJcmPLgfVrsKpZ59H4SnkI6rqOyvjKeVgmhrVDWwUGLozSKJxeGkQKna
	5ApSpb7smLayxFAdsfX8TNPZWQQ8ZFaFzHqLaUTDNkPiC/BAgchOyYrgYns0MXTnzo2C4IGPU+l
	PDYPhX9VLR4VK+JkKeOFDZtQ9WCHioShWxcSHOaG34IpRUG1QD4BpORxM+8/FCdjlxZNcveEzii
	uVS2JZ6dkQ6nkQ+52FWS7k/8zdZ543IQsLbUo
X-Google-Smtp-Source: AGHT+IFJdWzTNOSQ40dOtYVk8EX/x5mdcbsTbbR7zKwsnrAQaiLUirzi2yM9aYUe3x6UdvxDN3QCbg==
X-Received: by 2002:a17:907:2d9f:b0:ae0:68a8:bd6a with SMTP id a640c23a62f3a-ae068a8bfb3mr381152766b.15.1750521301666;
        Sat, 21 Jun 2025 08:55:01 -0700 (PDT)
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com. [209.85.208.53])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae054080a98sm393949366b.90.2025.06.21.08.55.00
        for <linux-cifs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Jun 2025 08:55:01 -0700 (PDT)
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6097b404f58so4990320a12.3
        for <linux-cifs@vger.kernel.org>; Sat, 21 Jun 2025 08:55:00 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCV8FpFOJLRyU5ZSDdzidtZCLZTmmgUaBTCzfXpu2l4Wr9/IQQ66ttC88EwJp0tLxnIXzFN+sk4dXVz4@vger.kernel.org
X-Received: by 2002:a05:6402:35d4:b0:607:4500:2841 with SMTP id
 4fb4d7f45d1cf-60a1cd33098mr5862983a12.25.1750521300614; Sat, 21 Jun 2025
 08:55:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
In-Reply-To: <CAH2r5mtz1-JLM8PEZngKOd4bwESBLU+bw8T=ap5aMmJ6LOaNiA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Jun 2025 08:54:44 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com>
X-Gm-Features: AX0GCFt9mVG_2r2gp_woN01q6-UhURhH801th1fVHPSJET8cZsUmhNVPCYqf_ko
Message-ID: <CAHk-=wjZXRvTnAwO-EcheuHkjOmq2YMua9YC3sbaXYBQ+FC8og@mail.gmail.com>
Subject: Re: [GIT PULL] smb3 client fixes
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 20 Jun 2025 at 15:57, Steve French <smfrench@gmail.com> wrote:
>
> - Fix reparse points (special file handling) for SMB1

I'm not seeing this being a fix at all. This seems to be entirely new
functionality, with not even a whiff of "this fixes Xyz".

I pulled and then unpulled again. Because WTF?

If it's a real fix for a real problem, it needs to be explained as such.

And if it is what it looks like and the explanation says it is, then
it damn well shouldn't be hidden in a "fixes" pull and tried to be
sneaked in with the pull request dressing it up as anything else.

                 Linus
