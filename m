Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8313126BF
	for <linux-cifs@vger.kernel.org>; Fri,  3 Jul 2026 20:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783111643; cv=pass; b=AiXIz/1OjlJ6qbaSUhwoWpZrj5fzpqHZBbimRxjyHZx5FkutVnTy4fQTC24Z6LdyMOkWxgsEloDtNahhAikzLovbHNUwH2YcaigDGIU+GX2qRqwXlDee1Fo95ro0/DBKCmGUdEvgYOsEnBI5YFZj/mj2GAtb8B9rHFqG7lNfbV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783111643; c=relaxed/simple;
	bh=im25RQCB+T3BLn9WCRZnv+bXYA/iEa2Jpv3RcK2yRMk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Vn/BQhyE6uE/aa5goVh3vtsKXpuGuFYEhZwUmh8ZezRqzvhoL1l1e3w4/GpV7JSbsKGUeA/PvBhhAzmoVk1zDSk2aPhaN37YO2/b4+iz7otFWKt3VUahVg2cMm45JzyBAJyKwvdQY3E6F+C1D1tEGJlajem3e4ltR06mmHtf+fc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bmmXukis; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bmmXukis"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8eec5dfdb65so3316956d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 03 Jul 2026 13:47:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783111630; cv=none;
        d=google.com; s=arc-20260327;
        b=rKI/sW/Yrzyh3G7Q7Ty6ysQFcZlUsP7OhN9OtQ7C69gU73Vl1wcURD44QVPv61fXFP
         +V4G40aBTii96p45N2XBdQF6xyMfdr/4VAwjdOPx5Kz8qlbvss9QM7CXOoT9NM3fLLZy
         ce1Z/Fx+q3bxktMdWrlRvTvaf3qz1mUNWxVNG/lRvFNFKDKP7lZoo1j0YajlcebxM+O8
         OFKMxweFHfNFssTJuTmnfPwdhEonBIjsEXQFdVSpcJukVLmXHcSBtgkBXvKaiByo7T4u
         0XYExdgKbTgXv8WG1S1UvHkgrW6Fc1jcJIbDbdIkidoEViz5WFgIoaHiishtF02JZkQM
         eHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=eNkhfBBpa6qxaQoPn2vbDMLQIpi0aj/+bgkcBKVpGzE=;
        fh=bR62hPsuqGWTBYZG9cvUMeDbzmKyhbk7J9AuZfEtFCM=;
        b=pLDxi43cR5XY5l+tu0+6IAIcmpsA/td5wcRO/n5UFco4be5AxJDrUSXfxS3XIjS1/A
         Yk50+yh/s5I2GaAiJc353tz+NB78mNQ5GmprMrV5rfWyN1Rd1CODREPbSrxmTzvF0mkK
         fuXk2isN9QelurwRvizkmRju/DQEEOdGvUc2WEF0zaLhVyLlHXv9nu0SAuq/rwgBo2HG
         4EKPT2q9AkpDUjdZDtoWTu9Rnwnl6MJYCPixoCJQymkGkt2ZQGsoqr121ayY+EuNffb1
         WCrcoXVGQikdrldsyrujijXd7fbBEx7QXh+YWhhhhOahwh+F5y9Y6QEt2N39ZjbJnMTZ
         h0BQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783111630; x=1783716430; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eNkhfBBpa6qxaQoPn2vbDMLQIpi0aj/+bgkcBKVpGzE=;
        b=bmmXukisUluJn81LQi6gPlWDPTB+WqtFcEkqo/IxtsItc76LU06Cukm0WpeTOcEnkA
         SygZwQaa7MJPN+EwjlfNwGSLFZ4NOdUK8x/RuX8qMFhkAQ/E9HkC1vkbtyY2fpSmNQg5
         x0f/CVbFBSCPy9iq5xGRh0w5rdqFLu9ix++QCKbrfozYyPHb749XcrxlF+T7DUV4QQ6R
         rk7TVNjcA2zdKn+BZME9kgTrTipX++JBZwERv0ONHMymbWcP80T6uju+tT/yd5lwqyFo
         s1RyOSVoUFpsW4BE0X9rEJdircRAeBDz8R0EI+q1xTNSX/Gsz/4wffqj75G9TkoNl3CJ
         uUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783111630; x=1783716430;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eNkhfBBpa6qxaQoPn2vbDMLQIpi0aj/+bgkcBKVpGzE=;
        b=ilga6vwjiztgQnMw/4v611+7MY83K5HX5pxCgsLxwejjbLfJJA8JWz5G+UvfyiCwcV
         Fk4+92q+O4m2SddtjRjhx+2UzCYcRFdSuKRXNFFrT8MLPdvPOtZHJySLApXbkAW1hW95
         YIkOJl4wpufHDVEdSsWxJqGZo1pO7r09lFX9uGpSj9ndmHqYR1mCOoxB2cYfUqWFld9g
         XVaa0SkI3OREHODhdg/zqvlbdjSuwobMkJFE8o0lCOx/2+UK5xhxYQiObIfHpxtqqe3U
         osmYVCHMZej3metsBh7NdW+K1ltbwab821FoTRcK2D/p0qc6LXKgLvNuZA6gp6gmOl92
         PBxw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5/zurg7xqLu1ymSgZd9YqPjF9LPTDaZ1XRtWtlJdsDBpz0zM/R0L7LudQZoCx6LO0WPKswRhtN+4x@vger.kernel.org
X-Gm-Message-State: AOJu0Yxrzw6w9eIeGkLCimVk3vQkKHc38l3g3VtCuFsiHYPRyqYtDKds
	/XLJo2cGAFO/UPXffNQnj9/DuSolT7eChJJkDyi6Tb7Q+CEWBZwmTicZYnusEwd0yUo8pYN7h7D
	fStDEk2yQq749I51x/7uzKLLp0HO0Dns=
X-Gm-Gg: AfdE7clDKrsVjjq+AGIFurqLUB8y5zqOqK3nk0Jo1mh/fX+urk6nv2nQ3o1iAKcXmDN
	ApVyVNzUU3RzML+UQE4+n8ZJ82MJH6FNJXkq82abomr+ILkOifGwERvomKN/Z7guKSu4jBbsuhn
	vT36r91RHYTHA7iS556Ktu7+1H/MXA/Nmw39AaQ+4fVDYGxBRpAwFq46KeocOe9pYrbiwGbdjJR
	0tmmqYV0dcat6rYzwYik5O7JHKwGL3nikutwdx4LfFVQCyLpEZnIvMMifQrq0jejsJOyDunN9eD
	v9TO4vqP7l68mf3jBU2UT424lgddIi3ao95JHd4IHQRAHjb5BlreJ7rLMnAjFOjI6qeJCylwqp2
	s9HPH7XBOGlsgyEoNUoMnGfz6gv/g12YwCBxMCplM0ESktgflKw4UCgUKvLbtAS7Kqsqlwre+SE
	6hRZ2wVNTE2Go=
X-Received: by 2002:ad4:5aaf:0:b0:8de:a916:6226 with SMTP id
 6a1803df08f44-8f749a75051mr13251796d6.6.1783111630178; Fri, 03 Jul 2026
 13:47:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 3 Jul 2026 15:46:58 -0500
X-Gm-Features: AVVi8Cdl8mPBzhJEy3wkHQJmbNtGPm9HYYzQFK2ehn16r1ZaqninznXADbVl27w
Message-ID: <CAH2r5mt596rpemKQBEQx_7SO0ZteTBiA=ud5VvycFgkLrQmA6Q@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.2-rc1-smb3-client-fixes

for you to fetch changes up to c16b8c4cfb4fe2244cc33e469a93c1ab8684146b:

  cifs: Fix missing credit release on failure in cifs_issue_read()
(2026-07-02 09:16:03 -0500)

----------------------------------------------------------------
4 smb client fixes
- Credit fix
- Fix alignment issue in parse_posix_ctxt
- SID parsing fix
----------------------------------------------------------------
David Howells (1):
      cifs: Fix missing credit release on failure in cifs_issue_read()

Steve French (1):
      cifs: update internal module version number

Zihan Xi (2):
      smb: client: harden POSIX SID length parsing
      smb: client: use unaligned reads in parse_posix_ctxt()

 fs/smb/client/cifsfs.h  | 4 ++--
 fs/smb/client/file.c    | 1 +
 fs/smb/client/smb2pdu.c | 8 ++++----
 3 files changed, 7 insertions(+), 6 deletions(-)

-- 
Thanks,

Steve
