Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4549038F232
	for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 16:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772035741; cv=pass; b=FHlk/5RRlNyLWEpRJbEUWvOTmZ6snMBoeiZXYMDsPtfevkcY2su1ogyUNMes9g3abB91fGfOoXuPc8lKBrFNSXJOBgfJF/6RSYMtkwBGm6slZc9//IURnKIeQizV8q7MfduSVySwbTkwJV3MqeET0qzw2PIbO5uVpp99K5vWO8o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772035741; c=relaxed/simple;
	bh=OJR/Na+jj1LB/h3u5D1eUBs8kCJXr6Kb/poWvQIYOXY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=JMaquxZ8KbyGqrKujLLK2kRtAV2anJBP1088xzfFUIa5MSe/iGhWq8Q+f1vXcsu4uKR36pNdFvd9Xy8zlfnxhx4zBP5XXlbFGLDeISwQM/483pB75z5oe6ZBWPro3EUkQM00suqJgHAoobKF9cCY/dido0YhuSYt/YOFtmwDmKk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com; spf=pass smtp.mailfrom=enakta.com; dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b=u6Ym15Cy; arc=pass smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=enakta.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=enakta.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=enakta-com.20230601.gappssmtp.com header.i=@enakta-com.20230601.gappssmtp.com header.b="u6Ym15Cy"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso1259466a91.3
        for <linux-cifs@vger.kernel.org>; Wed, 25 Feb 2026 08:09:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772035739; cv=none;
        d=google.com; s=arc-20240605;
        b=C9bdpL14SCKEdmUOqULOJ2nczoXgBdoesgCeRvyrESHURoBidW2gU67eJSr+QwoM0x
         zOWX+IWRO+Vw4l8KM8gBQuF5zmsrO1chl9hvgoh7/iFZpxw3SJc0IJB7SzqHi/TkMYLE
         zE7EJi5DUMtCL/eqfRdW63us9n23nCBYUfF1z/6FcE0gAhvAVRPMqfpB0YBU7DAhjYYa
         gSgIwf7ndxHMX5DsKT+lpso5haqvsO1jZqRC49FRouFpA/GHsQJYiS+2Zg8Q0Q5ngc9Z
         gLsk05KGN/PAwD0ZF9iokc10o0bwe2cuIi+hnvYISeCX9Dv7SjfTgr0B/0ldLyrNd/3X
         6r5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=ah0/yq8Nlk6MI5dpLakiuQu8LX7seLqUlMO4deqe/88=;
        fh=GDqh/0K3v9Y9Wx90O3CIZberl/XG8kl+NaULbeuiC6g=;
        b=cy9t9o3nRHqp/jYJ08MFDmVvox3PdeuifiuIgnFGXHqkmoPVCYtBbf+9qR6LDzRZQZ
         gZBu9U4XTXWsBEYgR5ZOMJ3f8pQn91Fn00ptFdm2tDXCDEIffO8NoLaZdh4eaao1Mnny
         cKoQhsTuDSrG754tpl6CGMzLGWEFfzUn4rmx5OlX12pGjUXquH0tSppRk70NmYcWPGsT
         ViueoN+4WVznSzCsh+3XoHzYvO9mMRfPNtQ5b26YIFACSyeChA1qjaDUVnIbGo0zPF1o
         ZYOMhqJAgzBguu0d9ICzIPRCS/7SSatLC4enu9LY5M6utAgT3j706nxiDSK6+sSVbxa7
         tniA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=enakta-com.20230601.gappssmtp.com; s=20230601; t=1772035739; x=1772640539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ah0/yq8Nlk6MI5dpLakiuQu8LX7seLqUlMO4deqe/88=;
        b=u6Ym15Cyc13P5a1HHm40nlLeXKLnyxGUxPYwBMe+iumHPfeQcQm8YZKyihjvzoOfjH
         vlb19Xb5gJNhe9sJAtf+CnLdYa+ZJg/4UcelP9dqezKfIRslTqScQTLS92iALVjbNbfS
         mVHBvyvpFtQjVs40d6hYGzYelrXprz0JzYB3v6TYN8PrWpzKP3wOB2zz4nkMKTrmdaiO
         Uqe4KO6ixYle5N0VesSJU6pRZLKPivVZgCBs20zvB9FH0CshhP+NnhpaSVz5V8NX2gDB
         C6KHVRFeOf/Vqs9cLTw5eFmQ2hmfb4Vkm9EpjS0gQs0ehtM84cI/ehCIrR3NDC8iRjEe
         Gk8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772035739; x=1772640539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ah0/yq8Nlk6MI5dpLakiuQu8LX7seLqUlMO4deqe/88=;
        b=jtuisvXDlqVZxVzFl90ZYILc5tQr6RL73vPtAm9MU3fmFJuuGAZmL2evr5/FaTdR8w
         6FWPXw0Vdpuvo+zwVf+zHnBvwWFzlA862lqTCcjpHSgNEmUv8Be1K2dM90uLkn9jMmRY
         HNNLRE1OqRZtHt5gJviYmMFn1/0uax77NNer9L2sjNQoX1HCFHblB3QYBIBV7schlRJn
         /V8ej9vyx2i0cW5dSjpTQnZHSbQwuV+VQ6SFjbN5OmJlJbP6mvHfEYxatE99tB4gy/V2
         iDxBNLVH6+ggz1AgD6elyFjcssWQzWg82m5nn3gpHOIlE6ujtaEp/Y8x1yA1LPnoEnfj
         blfw==
X-Gm-Message-State: AOJu0YyQF50svfJHDb8gVEuGvJDj3ONi2URXWUFO7WynXtYRsPJRr5lw
	YzbwsKht2awW+PaUINf/8lzs4+eZjvyGxb6KTUltL4oiSozkEWV/KnZJN84yxVdMKBVOyk4hDLv
	hZtVxOzmatNCzUVFRqBkqk8qLuZCUFBRo+vTLgxHubAZdrtN969pAPyM=
X-Gm-Gg: ATEYQzwd6f0v6RboRt1+HRE2920/GCD9tjfTD6w5LQLVM2x7841COOiLajj9RaXhwNZ
	6DJPt5qT9ny3kZ1HNW6ounBlSaFOZJDrfcGMP38bv5kDuaQyds06s/vVPHYkyf7ZRtwL5YKN6AX
	NxYIIJgA/EpMXzpTRiOKg+j/cLYEjrrMrjkAZ70LHZ9EnSqLibt7Bq5tyMiVp4G/ns8wzwAqB62
	nKo/cSuc0QZG2XfWdmeKylWmbY4E/ZSHb7dEH26+xlgRxPI2njXn8Uzj6S9Zfx8bvXC/trmEXPh
	rWAqfUwmThrLPDDnpUB27V7wyb/B3kXdxWVKuOZv1zg7bTki3YSqQ/viJnHdgulQit5T
X-Received: by 2002:a17:90b:2c85:b0:34c:c514:ee1f with SMTP id
 98e67ed59e1d1-358ae7fad35mr16348915a91.11.1772035739446; Wed, 25 Feb 2026
 08:08:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Denis Nuja <dnuja@enakta.com>
Date: Wed, 25 Feb 2026 16:08:48 +0000
X-Gm-Features: AaiRm50bgAoWq_guOYBnqprlZlHDx8z0DldaUjaWF61VHeQDHWcCHk45cLgbluA
Message-ID: <CAGk60SF8WxDMpx1ALrne40qycg5J-hxdBniFnoYG=QhvnX5ktQ@mail.gmail.com>
Subject: Kconfig: CONFIG_CIFS_SMB_DIRECT bool option silently dropped when
 CIFS=m and INFINIBAND=m
To: linux-cifs@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, stfrench@microsoft.com, 
	Ned Pyle <ned.pyle@tuxera.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi everyone

CONFIG_CIFS_SMB_DIRECT cannot be enabled when CONFIG_CIFS=3Dm and
CONFIG_INFINIBAND=3Dm, despite all declared dependencies being
satisfied. The option is silently dropped by olddefconfig and
menuconfig refuses to save it, even though menuconfig displays it as
[*] (enabled).

Kernel version: 6.4.0

File: fs/smb/client/Kconfig

Current dependency:

if CIFS
config CIFS_SMB_DIRECT
    bool "SMB Direct support"
    depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=3Dy
&& INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy

Root cause:

CIFS_SMB_DIRECT is declared as bool (values: n or y only). With CIFS=3Dm
and INFINIBAND=3Dm, the left side of the || expression evaluates to:

CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS
=3D m && m && y =3D m

The result is m (tristate), but since CIFS_SMB_DIRECT is a bool, the
Kconfig engine coerces m to n and silently drops the option. The right
side of the || requires CIFS=3Dy && INFINIBAND=3Dy which forces both to be
built-in =E2=80=94 an unnecessarily restrictive requirement.

Additionally, the CIFS=3Dm/y conditions inside the depends on are
redundant since the option is already inside an if CIFS block, which
handles that guard.

Observed behaviour:

menuconfig shows [*] SMB Direct support (appears enabled)
Saving from menuconfig does not write CONFIG_CIFS_SMB_DIRECT=3Dy to .config
olddefconfig emits warning: override: reassigning to symbol
CIFS_SMB_DIRECT and drops it
scripts/config --enable CONFIG_CIFS_SMB_DIRECT silently has no effect

Proposed fix:

Since the option is inside if CIFS, the CIFS=3Dm/y conditions are
redundant. The dependency should simply be:

- depends on CIFS=3Dm && INFINIBAND && INFINIBAND_ADDR_TRANS || CIFS=3Dy
&& INFINIBAND=3Dy && INFINIBAND_ADDR_TRANS=3Dy
+ depends on INFINIBAND && INFINIBAND_ADDR_TRANS

This correctly expresses the intent (RDMA stack must be present)
without the tristate/bool coercion problem, and is consistent with how
the surrounding if CIFS block already guards the option.

The same issue affects CONFIG_CIFS_FSCACHE on line 191 with an
identical pattern:

depends on CIFS=3Dm && FSCACHE || CIFS=3Dy && FSCACHE=3Dy

which should also be simplified to:

depends on FSCACHE

To reproduce:

# Start with a config where CONFIG_CIFS=3Dm, CONFIG_INFINIBAND=3Dm
scripts/config --enable CONFIG_CIFS_SMB_DIRECT
make olddefconfig
grep SMBDIRECT .config   # empty =E2=80=94 option was dropped


Cheers
Denis
Enakta Labs
