Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64DE93AE1B1
	for <linux-cifs@vger.kernel.org>; Sat,  1 Aug 2026 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785561603; cv=none; b=qOto9UAyS1pKOIuSbaeN6esfK0i1Te1Xx5gOcdsPxuFGmSWFHH7N0VR24VzM75Jpiml/aCbiXrkNpWtb0ZyPFnzGtOxB8AnnrtUTwG4qq3//73QK+tWqt0428gl7tS8G0BkJs/8IvFqb8kbVV64PlivbBvb6qyUU9Ljm3NWHwIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785561603; c=relaxed/simple;
	bh=jbEDp0aP4KLyL/H/rKmqW2nwUp9AZgPPFIt0VYnjFK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MXB7P2mxxrKFxm3MM1BaoqOndoJiBLhEaHtqgzKZ1kgbK70woaoiGSoIrxKm7T0Iz2WcU+C/tsfPyP/qb2qSA4SuC697P6jCWkSQYo1kivYRriHYcSOzkgpDX85r+krxEQSc9DlU2n01h/jerr7gZggI4fou4lGwp215Cwzy/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NeGkKnwS; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NeGkKnwS"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a097f5ab95so2096542a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 31 Jul 2026 22:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785561600; x=1786166400; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+MW1sK29/W0l4mdCnor2pMbKH+7EMn5ospanwRqU0XU=;
        b=NeGkKnwSA0Vu+LjT71R4X68Ln8c7EDU6JSTCT0E04wtURNaUaj4BWHVQ77EzUdrEFU
         aGeFZv1NpXqYk6brv00xbGb3ZchuT1pIvUFDs7fcqT3+AOdlnQR9PyPnnafs9CqsPONN
         3GN83DVfoxDCevPsRuw1lz1/s3bgWtb99Z3iFiJBtnBoP3RC50l/QrtI23UrufJ8kyVb
         i6LE+K923bApKvit3MCR1ExfRuZ25FAk5Ufmw71gw6YWfTlxoJRqidvNGNU2BnxhKovu
         H8w5Og6ZDDAyaX771auK4H9JzqbXhfcJsWZ9pE1ytuoSQdZ7B4DbQGrkC8+8oXnEqzyD
         02/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785561600; x=1786166400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+MW1sK29/W0l4mdCnor2pMbKH+7EMn5ospanwRqU0XU=;
        b=FpkYst1V3+Bc/wztApezssbbiqU5Kf+vDkteYeG3TLfN9dSaHvQPeT1arcjcZaEXkU
         yRcrOsch1/387a0lgx7Kw1teHeIDSlDUGHCcZMsPwNWgYj2A/SqLzzFR7PD/kFenIUvu
         bDpF8z8AKsVcS2QPk8Ltm81mnKQZW+TLdcQZwYGfmYrvBGLJWfyZBl8DGu0iFtaPWPzb
         OUMJphuKufOYCrrdZRfJSrIcRNSZoKX66e90MDYdEA/5YFO9jKWU9kN2k3Tro3ho7RVN
         ZFpa9JR/MpY505/gLDA2AiJcleBp7s9uQTk6pwL0V+HS+14Aq0SXcRwI2DRbIxn7oRcE
         T1xw==
X-Gm-Message-State: AOJu0YzbdUlxRHc70KP4r/Ox/UIBcsVLaZHbbJ7QfTzrWD3FtgUmISKw
	lDvDzctzXdZGPO3btOvYIeK4xBZqFfN+ZZOe73Daq3RIfAKwAxNpoc3o
X-Gm-Gg: AR+sD128NKKIGn1m3krvTGyWTw0KJo2Ro56S3+ncl/bjNtzfOuH1DgiUo/EVjGYnvy8
	PkHGPJRHDy2RJMrDsVCVTj/IGdsSFMSLb27ovlzFLQn7NDVdK4TqwzV5NvKG3Ltu/44ayG5yf8+
	j9LdMc2hoZI5msN38pA/WY1Fwp+6kF3WgOaSc1/T4A3RcmudpaBrjkcSbyenLU753KExrU+seST
	dYhsKByE74jYf9peBCtVkyu36dJV5qmgz6PL01Gq8CUXsNFTCDdFJavNELVbvJAga/S3xOIO+Fu
	o38YSoZmiNXL6Om+3b3f/uryVzCvpnWJHqcV9m9MmBwDV0sLjIFzxIRJ1hpihVs9L2/b+5sjCI1
	Cph5R9mxadpa4X3ELoPCZG7aq+hofQ30h2tjeeIl/XGVFY0e16p5zY6uGEVF9OqVfWvoSZsd+St
	Tcw259OhvwFAvYUPEa//wDCIFP06GzMHBr48v0vzwKFYP+8hh7ohVdY0Ko/lhJrxdcNDHGq+Zi7
	+A=
X-Received: by 2002:a17:907:1b28:b0:c1c:2b61:b9da with SMTP id a640c23a62f3a-c1fe83325f0mr129579066b.34.1785561600352;
        Fri, 31 Jul 2026 22:20:00 -0700 (PDT)
Received: from SHUANAT ([95.47.122.240])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd3c5b608sm287393766b.8.2026.07.31.22.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 22:19:58 -0700 (PDT)
From: Anatolii Shumak <anatoliy.shumak@gmail.com>
To: linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org,
	Anatolii Shumak <anatoliy.shumak@gmail.com>
Subject: [PATCH 0/2] ksmbd: harden SMB 3.1.1 compression receive path
Date: Sat,  1 Aug 2026 08:19:51 +0300
Message-ID: <20260801051953.74245-1-anatoliy.shumak@gmail.com>
X-Mailer: git-send-email 2.51.0.windows.2
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Namjae,

As requested in https://github.com/namjaejeon/ksmbd/issues/529,
please find two patches:

1) Reject Pattern_V1 on decompress when it was not negotiated.
2) Validate compression Flags before kvmalloc.

Tested on 7.2.0-070200rc5-generic.

Thanks,
Anatolii Shumak

Anatolii Shumak (2):
  smb: compress: reject Pattern_V1 when not negotiated
  ksmbd: validate compression Flags before kvmalloc

 fs/smb/common/compress/compress.c | 11 ++++++++---
 fs/smb/common/compress/compress.h |  3 ++-
 fs/smb/server/compress.c          | 12 +++++++++++-
 3 files changed, 21 insertions(+), 5 deletions(-)

-- 
2.51.0.windows.2
