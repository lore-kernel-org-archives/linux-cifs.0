Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F463C942C
	for <linux-cifs@vger.kernel.org>; Fri, 20 Mar 2026 15:59:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774022360; cv=pass; b=YbbDaVeqP7rWdt4BkXGAoTIsvsK//+vh3NIuZZ1lzL2DwaSgJmBgTg+47G7AY8xAJOiX9VUM7s8cEvujh4bHIAHv/veGybEkkwPPanKPVozpMnFa/tdo5xCIrWC7vbC8h0RoXht0C9Cdmw64vqeFbuTuJDIk8XgxB0+J8kHWc0s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774022360; c=relaxed/simple;
	bh=sjYu5P+JCjZj1iMksiPlWZx1wFiQYpk/3llziEnvAeE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=T677Sx0rCNCReg8llmHAOBxRNZYGxlAMu9Y6iNj0w5tdKtS28nIaH+YpJtJQAx4bGUwZgaRpM4/y0FqeylgIBVQpl7XgQqVWJuI6WtxkUEBowOsHmIPMVLsFlF84DoScrQPimx9+xD4JYaXfJjhjSzbQdZY/AdDtHXeliCIm01k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OckQQ8im; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OckQQ8im"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-899a5db525cso18351346d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 20 Mar 2026 08:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774022357; cv=none;
        d=google.com; s=arc-20240605;
        b=IaXJoeSScYxIwGUk8s2n9w/e4vr53q8duAF5xuHvPyuMPPT91MgbJl42EVoqG81Ygx
         7j6jPadrfGQET/vTTiFMZkn/a9Z5YYdF8sI5PCx2v6mHvbKOoSf8t1qkiPWHxIegfVte
         mGCL35Pkenmpzww3xPQUpEwacm6ejDpifzuCOk6Hs1QCc/bBPBbmjUlwGC7sZZxRxNIZ
         1dcYEv8ITAD/hac/4ZymGd/ESuNVKEMXZRi3X15566MgyXqAP1bGy1hldZzIYzICknwM
         +hhCGckw6j8NSszf+5982SWEeCkr9GXrWhr3/t9gRKKpJdzO+iN5dIb99nmTYIX187SZ
         3Uvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=vHWTprw5iaqOWElRuQPtVzh02Xj5Y66pzdXNJAXFZvE=;
        fh=Nf1mvuQ9XbZKOmPhacDz1X5aHl0t82a+aHbY+2n4zlg=;
        b=Digl4zaA0cd847PYSws8SAS1vLO3cYGOPmkvMypPMUe23xBir9hooHafcblo8elapC
         0GXFNM4Cy4p15YUjHbLVO1Cna1jPUPksXpx2PsZXaWTz/H2vN3Vx3aUK3tNq8K5KezR0
         dSflEekVq9SGLIqUdiW2I/T5SNWAjVO6aue8W7Szqe0INYyXOO+7jV/83dAi979Mub2i
         4KksYuJr4ep9TTAjiSRYIfljk8//QidKeIcu9eGzuF593IffqZ4MtIqwWx8uRVAFme4r
         J/dTEEmifCXnRoo37GDYu1IVvAIoMi7XuoaTdHFb5NCKv5Q13m79HomIcBK5s3JXbekI
         oa+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774022357; x=1774627157; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vHWTprw5iaqOWElRuQPtVzh02Xj5Y66pzdXNJAXFZvE=;
        b=OckQQ8im2j3xrmlFc1mwubMiiSNNPl6DfSsSGhkuCCNQG7JstzD9M+/ui3usfOFcew
         VMQTBYLe0dUu5MRiH/N1hJM+MMPo5XsHJXa3sLR9KCABkPz7kedHKgPaARwURMU/nyoc
         9su4oyKP5OYEyThqYL3+dyMrvMDX11OkSXai4d4dqoyW1UYSPVGasbUi7zhn7JfpKaHM
         FMK2JXpRl3lDdMWxmmd4RlYa7VPpZ+CBtsWhJtnWiwPrfslXjKgLZHuu9p0ofbokHv3i
         vugXEsZX2U0MS43PAI/gf1csba0rm1/fEvXtSIlhHB/+DbwaKiCJmbNqTtn6uD9b3iQp
         Lvcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774022357; x=1774627157;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vHWTprw5iaqOWElRuQPtVzh02Xj5Y66pzdXNJAXFZvE=;
        b=gmwdtBMmRwAqRBPc3hOAXtTsDzFXet0hJvgS64oKjiWuHYa7BGWbukYglpnbxBVNq3
         D6rfJ5YXDb6/4f9tsapGY+MOg9kVPd1VASUAbGHeg8HxShqG7oLVq7jv/MswnhH8lx9V
         FEHAB1hiy+B2hPuVa7pMOb2Sopx8mW49A+KyV5QbnxGduwX2Z+rZnV6aL+FTOzFoLbUW
         nTQYEm8V3Or7z6zYenjZ6J1Obvgf3TVYmUOIG5t7qmPitzSlpmi5kd5F5UA2nu++daE9
         8gInBc3z0CNaPaL1u4YmQz+xuEd3+jk5dFWAimewGq4Pe8+WJBPUMAp6iqWFaYzzoE27
         deHQ==
X-Gm-Message-State: AOJu0Ywp1tv1bfXkwrWwTFBusBE6mkb3/H3AbgFIgU805b/UwNOMH5GU
	A2mdMzZUKkGDGIOrlHh2DaTbOTm1i6GH1HQHkYtoQHDQ03oMGq0b7lr/FIzHUyWG6UocUqDqovR
	h7tCUkJcsXGT85vUm5RdafY/CZZH67cg=
X-Gm-Gg: ATEYQzyIJSBWOSLhGhI8zs4rFnbMxeHp20puHnac/pxJIAbG/MwavTU4a1EqF7zc6zf
	PPI129VpwnmqNDoI0ZzxXHTIbvBkDdgZ10TPIcGN1d9ziFmKE7BHc/7mnjEHHUCyxjZO1Jbz8f6
	gmC97fTC107w3QTMiPCSq+D5o5yWR77sc4RM9W59ektySYLBbBgotQgZ5Gx2LgNNHVx8BrDr/tb
	/6soI4VGynkOVA11sGaDYKzw1fCWNRV2Os8UO+5M9TxEobOwFDyiy6Pk+nHo6SQt6h8ASsQh4IB
	pGu0KSnSDNWS2C2UkCArXtYO5T9iIU4oqdRXOj6Z4oKqd3nnSDiBkAU9Sm9vLttXGj0px9RuOz0
	Jsi9MuJ7OCArQyU6NF6JNGCaVCON/1JNt/RfNq9xG8tNUoA7PQKJtKUBlvxyMyPKa82DTD4OM98
	9yDFmNplcrjOu/IkZq7vk7Ow==
X-Received: by 2002:a05:6214:328d:b0:89c:4fe3:85b5 with SMTP id
 6a1803df08f44-89c85ac847fmr50131896d6.52.1774022356383; Fri, 20 Mar 2026
 08:59:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 20 Mar 2026 10:59:04 -0500
X-Gm-Features: AaiRm53eYT7dz_iRiuCuoFz6UZvlm6p_TpEriSUsF_4xqlPz6AE2zwyCbDQp2nE
Message-ID: <CAH2r5mvhA988KqzRzKhB4S0EaRe=ZJyK2-__O4A3uYjoO2iQGQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

he following changes since commit f338e77383789c0cae23ca3d48adcc5e9e137e3c:

  Linux 7.0-rc4 (2026-03-15 13:52:05 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v7.0-rc4-smb3-client-fixes

for you to fetch changes up to 23b5df09c27aec13962b30d32a4167ebdd043f8e:

  smb: client: fix generic/694 due to wrong ->i_blocks (2026-03-19
13:56:25 -0500)

----------------------------------------------------------------
Three client fixes
- Fix reporting of i_blocks
- Fix Kerberos mounts with different usernames to same server
- Trivial comment cleanup
----------------------------------------------------------------
Joseph Salisbury (1):
      cifs: smb1: fix comment typo

Paulo Alcantara (2):
      smb: client: fix krb5 mount with username option
      smb: client: fix generic/694 due to wrong ->i_blocks

 fs/smb/client/cifsglob.h      |  6 ++++++
 fs/smb/client/connect.c       |  4 ++++
 fs/smb/client/file.c          |  1 -
 fs/smb/client/inode.c         | 21 ++++++---------------
 fs/smb/client/smb1transport.c |  2 +-
 fs/smb/client/smb2ops.c       | 20 ++++----------------
 6 files changed, 21 insertions(+), 33 deletions(-)

-- 
Thanks,

Steve
