Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8253548EE
	for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 20:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760993518; cv=none; b=GHAh9+FUQX9svIhWE3Jxdd6sKeMq7PIXjvj7k0hFLXkRVzXXR4sZACH8dhthSmU9aa4IEJFm4h/vnzvXvMvWsY+8bwp+mo24GFnmXn1ApJQpPG3SK0rFJ+DqGGOwdT+s8yU4bioGhzDnUOqPhpJZ5VAWLs0BaQKy0XgQzeitevs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760993518; c=relaxed/simple;
	bh=O7Be63o2RWOO2VrR+RWnqi897fs+IRBvDIQRRHqgkkU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=b1eQyD3mVQt0zVCg52tZlI+sMf3nGGW1WPSRLcin1w/Je3i4/x2gotwwpMt8ELE+32F+0wnbyXm6ESZUJeN+WddSJbnCyVkalAwgI85CWQSWYsAfEGAByuJYLyuBoDu9ZDDotVANzrq18V8XfETyoQ+z0ExrwLPuAhlYYD0dCuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JquY7Q02; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JquY7Q02"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-780fe73e337so61865617b3.1
        for <linux-cifs@vger.kernel.org>; Mon, 20 Oct 2025 13:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760993516; x=1761598316; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xVDb5Gyqr6ZXc6QhjbKfQ/wWZN7WMcPi0//kPhTzEwc=;
        b=JquY7Q02AhEJbWubvqI0+B+iaBv5Jh+ZhKQmIAVP46Fy7oyA3OM8MWltiETORo53i4
         ka/S/XfonJzahV2jfGBeTub8T4LxJPdDs79zgb3hYI7j6usvtwaxkEcujAHQpLEt5R5J
         bTJuoGEhFTyWRz4CjrD+l87CoCP98BIkt3tV4tKtGHt0U8B9YxzHIc0gRvfBuO/VU7Rk
         b70ZqZwQceCW/1t2+4NNHIz49ThnCKlQRuQRqNFdfAKcLql7ydXJ25M4MdvlSnkggxKg
         pLfRYYVeQboBZL4+2vTrICsctIEYYS80C+Xw9Y0sjDjzqxEOWHCIEUx0w33TKAeOxhv/
         OdUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760993516; x=1761598316;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xVDb5Gyqr6ZXc6QhjbKfQ/wWZN7WMcPi0//kPhTzEwc=;
        b=I4P/AS3gX0G75hv48Ufv/6BDeCGuW9mWAQOgE1ueElCcloDVJd5D/0tKPjAWld9x5o
         YJS0DLe5bW0grYbI6SNmyvYJoaZ+NQuewrHq7F+2jM7h9BJFm5fk3/bfq1J7nVv91bb4
         FsLdoIKct8whf0nErLfyik9mETAtaZCtNAzeXULunX+4ZSCuqTd9wB8nWfueJEXgU/kR
         9n42Kmql+MFnt3scaiD/+iwNVMIypN71S2cQ74hMdlNYY+M2PTTei92VnxhFwkTXcUX0
         REZ6/t4IruB41oxslBJgwhK5rypuWxwL+TsgkdD7hAzUtp4hUDmA9nPi1QORa/xc2l9l
         msLw==
X-Gm-Message-State: AOJu0YzCDmxfNdS3y1ibrTaakvKMQP2SJIB3jUVlsPAWUidS4UN0lkRq
	RD5vC4XrhrW/1uzLFKjYCTaHG/CdpSpzabzsP+RlGO1yRIVHxKCPfTG0+PICGHd9sBtcTpIORX1
	iQHwfU8hCo+jTO/hfSusl3u0d8FROtMerHreBBtk=
X-Gm-Gg: ASbGncthuqlM/uOD+epAb5FJ5mxiuNAeIjXMqLY2VoGYbXfhaDO17gz44YvR+hfajhi
	b8mcRrtin31zVyofr9XnjNgHsw2n6mzSFTACT+3BDYU+GLvfbboa7AXo0204z4UvwAWmj3/8dnH
	lUNB2TTeH1lmZdS2duS6keCR+XMODnBGb6+AJXu0wQua6AAZcBWHQlsAkqfk7nQrNar9mlkDwYQ
	skkhYb+xCSFmsbb/SLXrxcbJw8Kug9U98IJKWta7xnQOi/zUx1mn6ti02M7UmxgIZJZiWEBpEaU
	1qzJOhl5AoWurUqHVYOM3uRppEQlCdkgsFliC63kXjzHlYloTMkvEB87M7DR3ONCHdOLHk1HwRL
	Naw==
X-Google-Smtp-Source: AGHT+IHh17QJHwaCWjt/rnioUsCAlamlwNyFKJJYbJjFwOVDlZLpC9OwHSFi6WTQ1CdpBZBW19DrI7ofzJGEGf+5y5o=
X-Received: by 2002:a05:690e:1901:b0:63b:4356:52ee with SMTP id
 956f58d0204a3-63e16168bebmr11692564d50.2.1760993515710; Mon, 20 Oct 2025
 13:51:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Thomas Spear <speeddymon@gmail.com>
Date: Mon, 20 Oct 2025 15:51:20 -0500
X-Gm-Features: AS18NWAUKU9RhC7KwF70whXBGEIMqvsyOodo7Ady3FX2_7lX5riwhca458DIQ8g
Message-ID: <CAEAsNvQmV=xFsU-4jn9zC2DYoAUjXTS3qcsGNe7XUZEEXg1cLg@mail.gmail.com>
Subject: mount.cifs fails to negotiate AES-256-GCM but works when enforced via
 sysfs or modprobe options
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

First time emailing here, I hope I'm writing to the correct place.

I have an Azure Storage account that has been configured with an Azure
Files share to allow only AES-256-GCM channel encryption with NTLMv2
authentication via SMB, and I have a linux client which is running
Ubuntu 24.04 and has the Ubuntu version of cifs-utils 7.0 installed,
however after looking at the release notes for the later upstream
releases I don't think this is specific to this version and rather it
is an issue in the upstream.

When I try to mount an Azure Files share over SMB, I get a mount error
13. However, if I do either of the following, I'm able to successfully
mount.

1. Enable AES-128-GCM on the storage account
2. Keep AES-128-GCM disabled on the storage account, but enforce
AES-256-GCM on the client side by running 'echo 1 >
/sys/module/cifs/parameters/require_gcm_256' after loading the cifs
module with modprobe.

I can see after running modprobe that the parameter "enable_gcm_256"
is set to Y (the default value) and the parameter "require_gcm_256" is
set to N (also the default value)  so I believe the mount command
should theoretically negotiate with the server, but it seems that no
matter what I try, unless I require 256 bits on the client side by
overwriting the "require_gcm_256" parameter, it will never mount
successfully when the server only allows 256 bits.

It seems like mount.cifs should look at the "enable_gcm_256" parameter
and if it's "Y" try to use 256 bits at first, falling back to 128 bits
if the server doesn't support it or throwing an error if the
"require_gcm_256" parameter is set to the default "N" value, but I
must admit I don't know if there's some reason that can't be done.

Is this something that could be looked at and possibly improved? I'm
unfortunately not a developer, but just a user interested in making
better documentation so if this cannot be improved, I'll go ahead and
get something written up and share it with downstream teams like Azure
Files CSI driver -- on that note, I'll appreciate any clarification on
why setting this specific parameter is required if this can't be
improved.

Thank you,

Thomas Spear
