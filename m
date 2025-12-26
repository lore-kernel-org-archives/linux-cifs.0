Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B227A1917ED
	for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 20:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766779600; cv=none; b=n5cgKXz3Su+UwFkDr3geCTGxPao5Oyw07AQBXD1mxzyN37VutywD5ImecrCoIgKQKPblpuEexQrcVyn7VKCauQsEwmQo+4MzYmlwDON8K6Auazh64M6zX7D3JiiOX9uFfThsFcRM98aPL/kn72TXyRbdm2Y2Kv9XtfaANCXZD8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766779600; c=relaxed/simple;
	bh=YomV2I38sopwkiQrse5IK0GFvSe98C7v1qooAXVeXZo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=rYg+azDK6l2u71P+Z1KxfXoLrdXerfpzL8YGCnJFg809nmIaz3KL29/EX6EQZ8BqmXB0GfGEppK8JNd3TAwavwcgxib+J3aAB9ZGr9EqyfaUBcZr1hRrnctr75q4MgHFF8r/fWx9gWm4X9w4xo4hfF8UGqZIBY/AEOlCrJnlEDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JnJG8Cet; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JnJG8Cet"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-88a288811a4so85415786d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 26 Dec 2025 12:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766779598; x=1767384398; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=0n6AZYSaNKRLuigU8+yNwNN5HtJzTv/6QBu56jgDHDA=;
        b=JnJG8CetfTHx7H7EpVY36vX8S+34Fr7ZAHcE50W16/J7Su3qismsZsjHTFkbjiLB3I
         4EBW0AKdIjDAFhffVLLDmHWb8neb/WKhnhsm7LbL83Xyy41QGCNR/ab730yaZkw7GcWc
         RNRPI+an9vz78XMCLegQPOGsv50XiMWXYzQ8xLeglcVg/6ZdY2cdbuPLBhDcX2O3oJkq
         ADaMoAh6FngMsB+Vvt43F8vWzi9MzPK+B1xQ7+u0x1Hhhj+W39T5zK7va7WrQuagQAZa
         fiOUJwiMFKkOxAw80Wi1/zhS/ZCEO1+R2TETQ6pT9Qqkacv18USqZrQxL5ppr7tYgFRm
         cPIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766779598; x=1767384398;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0n6AZYSaNKRLuigU8+yNwNN5HtJzTv/6QBu56jgDHDA=;
        b=Qaw8Pj+a3rqBHqVQYf8iIzVo1LWWisOX9Cr4IDXVcxbDue1SJkbrOVsx9osxOwRN2n
         6Ye9nbqQmSAfrzM4iZ5Cme3lWjbBv11Is5Ln4Y0i5huLsThRGEAtHpf7sUqlGH18b3Q+
         /ddzjZsBqdtWVyCKtOXBZOtgHipSIaJGYOFRgnpouLTuHiqEVVP1yLJElvBb9zwcWsDi
         k/7GPkA5/tnZIcTMlM2VW1jPpnpDAdfRyHc4vXkYqpruOr3tfojWL1elmR43I/mxC+GV
         sAE10uh9RF3cSfmrCx/6Rz3CZy3MKmY6oLCo7tmLJ4BiKab6BwyfwLt4pHCTmdo2KrKG
         6IHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxgAw9nEGHGY/Kg4yARz2/qbsDz8bNX/3r36eJ3AqXkMJIqQPwkr7PdnFoy41/UvQ1gCWMJBWlhG+U@vger.kernel.org
X-Gm-Message-State: AOJu0YxDojKveQ3tFy3Oe7HYja+NeOf4Pg6cKVBGWN/Gq33RWSmpdi75
	AkMyxcGx1vBna27qyipCaXZwgqvzhNzxt3OEjqNfLE0HMJSduDutCGMQPAxlNC9C68hMKH1XJkR
	+k3/Xcc2nagRyaB8RVMXCmoMF4Fzv0+s=
X-Gm-Gg: AY/fxX712hkQp1HN/JdK/AJVNV7Y+jaAG/EEmGRGMKm7ZEO6TGjJM6BjdLlJ7SKctpx
	fDQbhSeK4xCQQgtedke46TimJ9Ol5Wv/MlpJ346oh038hf05z5u4cTNHijcNHN6dud1qjGh90TW
	oYiN/MMnT8gFFXp0TL+pxxfGlYN46et3f2rOBneGuFQAdt2y5zTS1UzZbsKEf9g6Ya+D5VjjrhI
	xcWkhvqGvVu87V2hXdlj823RuHIdrCx9ZRyyzfxqg1pdqqruwY5qaILW8CJ0KloBkZyxFX5YkLk
	7yaYgkxH/AjhhEddKMKEnct+Qq1NnupmP7/jOlxSnyxXJ6TM/KNryCANg+bDGC6Ol9IxurZRHDi
	I/mztTOHzk//iD9dqsNLpReTFz7DMbHVQcapYGXcLQvUJeQHHmQ==
X-Google-Smtp-Source: AGHT+IHkh0Ro1tUTKf2qbn+KNa6/ul4q8Jn+P0RnRG6fzSx1JuSiMzhk8N+RZj3W06yQrkF3Zrafg0mbKrYRCMe1SFA=
X-Received: by 2002:a05:622a:6690:b0:4f4:de7f:c343 with SMTP id
 d75a77b69052e-4f4de7fc415mr123937301cf.48.1766779597582; Fri, 26 Dec 2025
 12:06:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 26 Dec 2025 14:06:26 -0600
X-Gm-Features: AQt7F2qmDEbYISP6XPQWkn4OF6iVuemgJj1K5ZmGIry6IPcG23HDtgmBCYsoJH0
Message-ID: <CAH2r5mvm777oSgR=O5Xjpg6V=cP9ADv+JbyPZBs_208K9LAshQ@mail.gmail.com>
Subject: [GIT PULL] smb client fix
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
9448598b22c50c8a5bb77a9103e2d49f134c9578:

  Linux 6.19-rc2 (2025-12-21 15:52:04 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc2-smb3-client-fix

for you to fetch changes up to cb6d5aa9c0f10074f1ad056c3e2278ad2cc7ec8d:

  cifs: Fix memory and information leak in smb3_reconfigure()
(2025-12-24 11:07:15 -0600)

----------------------------------------------------------------
SMB3 client fix
- Fix potential memory leak
----------------------------------------------------------------
Zilin Guan (1):
      cifs: Fix memory and information leak in smb3_reconfigure()

 fs/smb/client/fs_context.c | 2 ++
 1 file changed, 2 insertions(+)


-- 
Thanks,

Steve
