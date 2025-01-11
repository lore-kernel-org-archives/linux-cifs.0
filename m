Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1B8EC0;
	Sat, 11 Jan 2025 16:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736611699; cv=none; b=s5OQdnmslF73DN84o3ievbbBl0rdnEcHUOjvHHOVPi/GbEHDYBNKKWSoEeAN+ZWARgTHaGyZY06ntCJaCyrPzbQcfw9zhERY8LPNCUacu7KstLZp3C5zF9KkIZGBQg82ZXr5CGQirUZPAtir+sRIREllP5rqeb04Nh3UqHvCppo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736611699; c=relaxed/simple;
	bh=mv9Gn+gijjY/GivzuCw+MKi3UO6F5+0GIy+OwnTCwR0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=NC7tpz+QVYF3816VkWs5xUeSt+jEomXBAsLBVURsjlYLytmj6g8tj7EnuwhftcQgfzVBq+R1nKDXJ8E9XovdvHHhl5EMbzjQaQyTi0Of6bDg/VGiGn/dXhIDzqQq5zx3dUQX4rIfd4cV9QpDtVhbrgfJFhz9WNLHzT2Aq2U71Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxKtz593; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxKtz593"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5401bd6ccadso2953256e87.2;
        Sat, 11 Jan 2025 08:08:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736611695; x=1737216495; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DMirUcnt1GmDgmnHZn3w2oukzcwick3Hn6+pTUCpdVg=;
        b=JxKtz593EYUk3gAQoH8k+TPjzC0tWgCgyfvAdXLDbp/Q+uNs3g22kWOdvttPBjqZz1
         vpH5bfYRjB2eNZ1CruBG+wC8LTtKv6uijXb1GkOHSzgsJkSlvvvmdLdJwAs6xASe3rm4
         n9Il7Bl2iRXdpXVsyzUimHdarNlntqD30TffNoBitwkonu6vae5aN6zm1wLMHzqLV89S
         DKQDx/qUdRmrGlYsDLaRbqAPz783AJnCYpn/R3nt4nTNGlqmVAVRDYUQVKumSAaELvUS
         EjuMPRbZH9J9RhgaEzwrBqG93HrQxbYGlYBpckiP7RIyBeqbK8ugR3rsZ7E0XsPGX+Ni
         LO5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736611695; x=1737216495;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DMirUcnt1GmDgmnHZn3w2oukzcwick3Hn6+pTUCpdVg=;
        b=G2cZYXBz/kESPPGStdGrQFg+MA/y/De/4y5JienZchyitbXwEP2vyaAFzysiMcmJg0
         ORhDyyyAgtAG6eTx8iXLeXkgkcEhizLxcA7QWU48wFSgdYUzBXe5RL6DJ5rVvEk+YlgU
         Mt2ZOvYI8JCLM4nuzzuBET8gmk2z+DGwL+HyXSrYnFitXhIRpZC6QuwS+n00ZTk2T41V
         8jAyP8tc3GIoTM9Kt9ohu0ppFrNm9aYzp+JMb3W05MAZUGRNt8JB7Ajpb5gkeKfEab+e
         b1MtCG1wgpeUcGPFuYqKANGSI0O9EBTmZSfRj6vkme/YZK5dgGQsnBspilLu0VCM9g6+
         5dyg==
X-Forwarded-Encrypted: i=1; AJvYcCUFIVccabqna7BiQfb8zsqN6ivWI1kegDDs9RhFK5yflGUYvGSKYLQuyLs379N4ZPpGG+age1KoTWY/@vger.kernel.org
X-Gm-Message-State: AOJu0Ywu8GjiomeIgIYIkU9MB8CX4QYCDKO6Cf9s1FygD/4nn8YKxlqd
	XbMhgiJG8/MKcbmWzsLajW9aK5zz4beppIScS9anui3jIIznuzYnbvDaYklEGXYytu0CU9H8pBz
	SZaFXG+FiE109DX31hjwegBRKrmvmAXkZ
X-Gm-Gg: ASbGncu8CYjr0kW2IMpjUoxc2543vstqTn6OW6Xt5wTCPHWKmT+hSYfb6JSL55UJwon
	yjtCTLExRBNGvEyfPhp9X5HwxwX7nzbLxiPeunINr5Bo/N7i+4mbhYZL9gZ3XC0KTIEfh0WTj
X-Google-Smtp-Source: AGHT+IEgzl+o9cWMfWx13HhPi57kK53c0bZRarpGpJI3Gkx9kjewMTVlIUH3WNZwZF8YoXWre7w1II32+Zc3BBdpQ3Q=
X-Received: by 2002:a05:6512:1249:b0:540:2a92:7daa with SMTP id
 2adb3069b0e04-542845b1fbemr4639339e87.42.1736611694655; Sat, 11 Jan 2025
 08:08:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 11 Jan 2025 10:08:03 -0600
X-Gm-Features: AbW1kvb3MkWvvMI6rP6lcPIW5Lrk8Up7PtcwM_c4lIFi2ozr3qYgRIKWNzxs0rc
Message-ID: <CAH2r5msBKUWjPu28QaiG0XU=op7b+p2eNfa_uBORhi6vDscMGg@mail.gmail.com>
Subject: [GIT PULL] smb3 client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9d89551994a430b50c4fffcb1e617a057fa76e20:

  Linux 6.13-rc6 (2025-01-05 14:13:40 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.13-rc6-SMB3-client-fix

for you to fetch changes up to 20b1aa912316ffb7fbb5f407f17c330f2a22ddff:

  smb: client: sync the root session and superblock context passwords
before automounting (2025-01-10 17:55:35 -0600)

----------------------------------------------------------------
DFS (smb3 global namespace) client fix
- fix unneeded session setup retry due to stale password e.g. for DFS automounts

----------------------------------------------------------------
Meetakshi Setiya (1):
      smb: client: sync the root session and superblock context
passwords before automounting

 fs/smb/client/namespace.c | 19 ++++++++++++++++++-

-- 
Thanks,

Steve
