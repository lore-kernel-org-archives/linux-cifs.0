Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E12E364E81
	for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 23:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778543596; cv=pass; b=VYjR2q8TEIo3h/onsAQbyj2h8nTrHnDT2veUSEZPqES82Tq8j6O6DOm23rHbMJbwjXVa2mdNLyJzIF1w19AZopIVzbyIRU6m1wFH+VUa+NiNBFoplZ41LStUeIgzY1bjVDvjNoMixusyW5KlG3CTMVkiwTIhw5H/QY5lsIYRzyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778543596; c=relaxed/simple;
	bh=xiwZEVmtMnDGRx3Or6mTuOAStuC6rLXBvoUhBRBN4Bs=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=lU/AyPIwlL+xad+hzllthzk3taML05PqxETiwsm82WZCh11SHLFuNpJQXHE4WIDDrsptSJOCFn3psNTdOPnIaRHGcvVD38HZkWxUqAWSOkdFxMP5yqtBYsRIdqcGOUGNZ91cRi8TlSetRZhPq9bqTGKaTx7lvolTaeM3G/fWPCE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qvo0i0Jz; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qvo0i0Jz"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8b821f39a12so37835076d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 11 May 2026 16:53:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778543594; cv=none;
        d=google.com; s=arc-20240605;
        b=VxcOLE4s2mZLv9IBvDvZN4OgQLtFvJE567PBFBUTu0pkE0d0Obe1kPrHuahog7hmNy
         +2IJxje6F6OUZGOEQY9e2IPE+kFahwJsQnDV7UX0zS75wIBxgC/hKduV1zUpvXCMlthn
         WyTk4gZFxNbfl9ve/fyc4zXSfn8W9cBrdMwdl4VhgwWbF/P/B9IR4grawI4RxcxGSUDV
         mx9oRqZWB1TuGzbZEjTSCULYQ+xQnMKuSZFvdn/ms4vKlUKz0w9v3F7jbUQAzr23JuIf
         v687T/vQ5AKXf3luzcgbzAvq4m0T7o7eEetyRSv5Ld6W6MmPOwNPgjOQ/jKV/LtNsgca
         +kHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=qvLGMv+b6sEIrmRHjR2a8pruOSoWZUbXi5PndHsgY9M=;
        fh=6tY+Ovy/8DUqZG1+/Nk/+cuG4ArqKwAz485INxhH87g=;
        b=bbTWpRKUG0qiWToa4TtCh2/6aICQd77nryvJZ1szruAYDy6VTBPQoUHnkFqIfy10LF
         YXuyQKsOXovpRJeghZPYDndJM469+oQahkLmsxRPt0deSivB/gR1RUVf0NTDO60IIlc/
         QNan1plwU9eQGQBcDl21d/j8R2xmUnxbO8Z/HA75WHeHQTFTx36fnSU16jY4pzJCqjyW
         vNZCIEn3ew+w66uYhEYOTrjOYEh1FPrANOoSu2vp6QY95mbCcjl0Bzj1zhzyDpzJOqsE
         m1UgzLyPGeQJUAbFnaNGGakr+GrCsr3WvYtpNxjjqi0mN6/mVilxDRMgWniDIXRde53x
         QpTw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778543594; x=1779148394; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qvLGMv+b6sEIrmRHjR2a8pruOSoWZUbXi5PndHsgY9M=;
        b=qvo0i0JzLkhcezBt/lkSUtO1yKaXJ7sGs/k5LFbi8EpxHDjwTNUMFVWCThQSOnJv/R
         Ropg7BqIkVtiglTlcZRQc/S22DcmKoRRHYWTvrkxVztearkn73ndcuQnniTsnEM5sY0X
         qMPckWPaO4x2diHDmzG3GdzCpjGX7OwniD0qgOrPZ/en1bgnfpztuK3HC6Phft16fz42
         uT9e7X/oAp+trPsKDTy0M7aFj+0eSW1IMWdUsfks4LoriBHXoQXGxjKrnUrd/v5t5dHu
         Vhlpjqt99Nn3FBFHgqMUt1H1xnMOE62BNtgubJTNoaHQjyYTHt7P1Z6AGYfn5lv4v8ln
         A+jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778543594; x=1779148394;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qvLGMv+b6sEIrmRHjR2a8pruOSoWZUbXi5PndHsgY9M=;
        b=C+EzP5iamCQ1rTfezrrZQ4cz/i4sbqZzrd/EA6VoA2BgDHlmwPSaVMKNvLN093YAKH
         MiGVLEoR67/gWV9noV8ZDFOS7HTUGr0Fy1GxltKTdBGgI4S2J8T++MIBeMxC7uWwCHJT
         h1VWtXh8Didi3+5AE7AhUPehGiZx1XVUZ5vDaG9BQuNIFHS57mAJqwHGDR7Ov2jNB6np
         rIrco+tlMDn9Dqa9l6DNHPRQ5WcE/uS6Gt7bDYicyZ1YnPlHlTrPBWnbUtEOAgCX1Vt1
         xpOVIhi3SjRL6OyYi5gKREiXW329XwOMSmWrLuAoIvhp9vDDOswh6FcV7ib/FufsCKbe
         alIQ==
X-Gm-Message-State: AOJu0YxbAn4OpqJyFRtsJd0M2/CZzTP5Ct/SKZlGt9vBqJjxNP44bBJ3
	D0BxjjE+gYknq3ycHgZ26GKCoxE5srMj8jTRrCzvdAUyoQFc/P5x9Xgi12oeeJWldULWAKQZoUh
	0RQvU2DprJRCDrcU1qxYlZyzSm+EXfDsS11Nnjjs=
X-Gm-Gg: Acq92OHS3xHlperUm0Nost8/YaTDjIGNztJ/tcHnp1obJwcpHLnw3dB2PBIhkh3FGek
	V8vSLSTtbckpeFLMOLZVZ9qTe1BeelNVIXTXK7A0ydJYFXnammHhCLET9nX5GO8wLhTh6IljQj/
	TAQyV9ndQm86miyDjdhLxIf2qtIeGx/tNSxSKI1rje1frElEz6Q+O9XIztG1OvxIIM2SzfG7wVq
	+B/Iw2EZoyS0EFFCkwV7JYrAAcJDsNmtajKqyMq04e0AEwo2Qr6IuDXWd3Q+EUWVVl9bc2sHCFF
	kWMjuHXZ72silmHhrnqn2S04gt00lQRifHzzO9vEJzoHERwIeyo9CpM84xbjuTPugdgZ/hdyxaT
	dgYUu/0j3As0UTmHZpxVmEQ/qAOT0+Jjznp/iFIrQUrQObz3FDzrDNwFxNbAnWIL0PKwLiUTY55
	sYG22Oos7OIRpfOW8v+rI=
X-Received: by 2002:a05:6214:5b83:b0:8ac:b48f:9fa4 with SMTP id
 6a1803df08f44-8c1af00aa9dmr192716046d6.35.1778543593693; Mon, 11 May 2026
 16:53:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 11 May 2026 18:53:02 -0500
X-Gm-Features: AVHnY4LPxy6WepmxyPAlMJZ91FgFJj2XSEobGAgIhg0EepFKG0j3F_H4P34mr-k
Message-ID: <CAH2r5msyqZYmWxVvdR9sBhDO+ea9uL7nqwGeYtM1GU_vAy-GoA@mail.gmail.com>
Subject: Query Directory level 0x51: FileIdAllExtdBothDirectoryInformation not supported
To: CIFS <linux-cifs@vger.kernel.org>, 
	samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"

I noticed that Windows clients now start Query Directory requests
using level 0x51, FileIdAllExtdBothDirectoryInformation, and when that
fails (as it does to Samba and ksmbd) it falls back to level 0x25,
FileIdBothDirectoryInformation.

Presumably would help perf if Samba and ksmbd implemented
FileIdAllExtdBothDirectoryInformation  Any work started on
implementing that?

See https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/10906442-294c-46d3-8515-c277efe1f752


-- 
Thanks,

Steve
