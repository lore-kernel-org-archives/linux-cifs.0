Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327C637DEAD
	for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 20:22:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779826945; cv=pass; b=tzFB22ucRzYC5a8DsBXGBYcWGKkPF2eSdAQ/TuQJrpzJ5YW8BxEvv/mLoiCCqGwjHF9VFVyuRy2h17Rc8XYEtumh60nkg2SoQit0stCElVEgi536/52U4emJlgYAq9RNIh3GEvAxiQumHRx0p3RkVVxYMTAuOWJ1rlnXVz8lBDw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779826945; c=relaxed/simple;
	bh=EJxi0LYnVHGU89X9/Le8D3Gxtg9JbiIeGttw3jVYowk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=KxXwNlm5uF/IQpkLLfR34gx4InLlE4a3HzgWIs0wHUZ8FuhhJbo9ywqNBQ5V8xhP//H/BT9HuQD40EOt/0MoRots8nYwJYTqgSxIxSVY7mF8vGu0NA6yocDN+qxWnWu+K+Jh/RUWoeMAHDYVWspK6zxNGoSPduMyVaHQCYNhCCk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GSIfLp62; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GSIfLp62"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8cbe69b122bso62341866d6.2
        for <linux-cifs@vger.kernel.org>; Tue, 26 May 2026 13:22:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779826943; cv=none;
        d=google.com; s=arc-20240605;
        b=bhDyX4Q2jjThkqhyoCJYzDpTQud/hW4atJ57aC3I+4HHc9xYz3eLFyh69ZmQDe0tIX
         3MuRpD+/Vvt14b0tV+tZzFVz/s8GzGPrvbiVGk4/yNrt0Vnn4DdqPXD4pPHtMwQhXyv8
         mv+mu3h26IE7nVzFRdF4BiCC8rVhAGQ6lDgAJdzvBBceCFS2GIkpaV35HJxB0yjZV9vP
         u2x1LHBQECt/znKIPMyU0+9RDOb+Ox8ugos/mnhFBWLk7BMZxzszJY9OLoGF7Mzj8tf9
         ga5BdINuS/XPDrqKvslEdokQoYjrGOq55Q7qL3NXk5Bx2oe9WU2iPF9y4mFwGGA7psIn
         rRbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=O3khOo62AnXpi3t5fdjIOuCLZoe5BAvt8jokgOAAWUI=;
        fh=jxNNffwlnklz5ejqtoMSwyIXYqUpoaE9SJaOuGx70DE=;
        b=G8Xp9+YaUJ+jyuJ/D9UHiaTQdTUIf0DAiAcnIgFhLj/AtW1b9if4Q/n7PdTIz6Ko33
         9nLjMl2x4Ak9uDbkJEi4vcYUm3uOleY41nVsA6kyBAN0Or2B6a6KEdrZ9lz26fRfUl8n
         CrhR+c4r8kH3yXCYZq5ep6m7oNORf6pdiumaGcFhYmn/T3H2GXKHJSg8CHov7XvUN3uh
         mu5xse1bqSoRzxR9wsRz5VQs/+zYGkCDB7npI8k4eOts8IAf3dIzhMKW03zmt6jGRWuM
         EBMm0l4b6lDZP0YwIgxzaD2XOm08D2i+2uZt0wdVEuex9Kt3Q3phIc+ZHamuODJ+ABv0
         8Rqw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779826943; x=1780431743; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=O3khOo62AnXpi3t5fdjIOuCLZoe5BAvt8jokgOAAWUI=;
        b=GSIfLp62sNvUm+T29L1cA7PaYNe/FXQ2zZu+pU4aDQKv7Gq3mld9+suJsV65HN5bvv
         PXJj8Jg1JC2QlFcUdp4mgC7r9CtoXsF7AQ9RXGrncyewc/pzeiZoD3cF0EuktRNvypaC
         kzpoOMmqwt6PveY+o2IX/Fyy1aYimWp4WXZ94RajnmqZ9DhlRhOkkNi12cw84R+NiUMu
         a93fKDKXoPRCS/oBOmCkqIOJEMOGjiEFGlmOurSEA1A9OlOyhlwgpfGnQuCCyq+xLkXn
         wG7MUPAxMxXhzOWJ0VruFzVT3n3ngoT7s15xkoJNLFBDBtcO8dGlP19ngxpyIOIoBzYd
         ArFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779826943; x=1780431743;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O3khOo62AnXpi3t5fdjIOuCLZoe5BAvt8jokgOAAWUI=;
        b=GaizraFig7z01Yw3MDANWHoliJoACfXXGWhcgnLv14vRMhhyI4mUA7wL0d4XBZSzxZ
         /DJLHvBM13ftJMrO2jYDSoAJ9szt/1xYH/4+M9momxt9OkyYirnrsHAe9sQcjhiAloHt
         zz8++3yr6QBiWlcexe3CcvaP782lycQ5Ev8hHLZkdYzvOUVRgfYED/LfSfM5IP1y5Et/
         TtAuTs65enscMuInwIPQIXAp2YLdEfpgzL9Bwu/ITje9DuivLN8+lBzh5D5yQRPHq0Ht
         VE/jQY1RB4cfoQlzUpkcIYeA/eceMNNRCNteamApo3koILGm5tmys/TL2fJRfn/b4oyT
         UJEA==
X-Gm-Message-State: AOJu0Yw8pELUuobpE/8jYF7PrlWwpAvyyez/XSebptt/fiiaRMNIA0MN
	gB1lBZVxKAHy6Ay0ddXKzx+mMGIpg14Ia4KP5Q5hlrHUgG2vO7MkqFRqHr73kNWff4GLLuzFETw
	qkwebp1Ssn0gGeOAjRAmv0uDq1X0wXQUrhg==
X-Gm-Gg: Acq92OF0USdOKceovXGADdGrfR9lZA1g/1A6GDWc2aaO7a9Iuqab10dY3YTlUttX/U7
	xF5RKvRKweDzyJbDBn+pGSmqqgRF4VSm7qy8tPQDe6iUZWC4L+87bQswmkeA8+HYmaiHxlcSSQa
	uJktTI3kKuYI2RLReZyfbfj0lT4VvXtTEtqV+dPgH3td4cEAisEtkgnqScmuDnhHRaIRNWIjXto
	LRyQQ1p/CyWdMsHGgRnL4WoRkyGwfrLy8S8XfiURhcS1ckUFP6KWV+bJWGyLkX2exOeIVaIJpUF
	+j4PLuEBgQK/Is8C47bgzKD2cd35I9atV4gCfKJerjmVhs1YHuea69Op5ifb7wfpghZfZXK0F1I
	jSUH0fZzQx1f1EnRiqbQZOVKG46L76PxtNjiauF6HLALdSjHodK0Kz+nyFUywZJ3rFhvIM8n0Zp
	YUQa6j7EQbl5lUn1rNvB9h3A==
X-Received: by 2002:a05:6214:468f:b0:8ae:652b:e3c4 with SMTP id
 6a1803df08f44-8cc7b6028aemr322119886d6.49.1779826942996; Tue, 26 May 2026
 13:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 26 May 2026 15:21:43 -0500
X-Gm-Features: AVHnY4KVRgd6-0zBRsC0XHn5TrR-Y_1JPFN8rI-4JW3UZJWZY0MtenWDp_u-58s
Message-ID: <CAH2r5msNKaBO2HQfXri1VbN2RoSqCWgxHwvvWLeODK1hxNueJA@mail.gmail.com>
Subject: chown Samba server bug
To: samba-technical <samba-technical@lists.samba.org>
Cc: CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

I was testing a fix for the Linux client problem with the SMB3.1.1
POSIX extensions where the client was not sending chown or chmod over
the wire, and noticed Samba server had a bug with chown.   I tried two
experiments:

1) chgrp: with my fix I now see the group updated both locally on the
Samba server, and what is reported remotely by Samba (for ls and stat)
is correct and shows the updated group

2) chown: with my fix I only see the user owner updated locally on the
Samba server, what is reported by Samba (for ls and stat) is the old
user owner

Trying the same tests to ksmbd, both chown and chgrp now work, but to
Samba chown only 1/2 works (updates local but not what is reported
remotely)

-- 
Thanks,

Steve
