Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.216.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794874667;
	b=evYxSwk7iITHiM49T19Mb3208QNYzjBSg0MblRHbXI1P/cfWB/t9+QfSqjvLxi28JY/J
	 Jy8jKPTmZ2gnv3DS2h9sEtmxwUj/HvIXMpxP4uYEhsgkxqzt7Qbn7ZGctEHFkd9WpFhcZ
	 I0t8RuduQ/FIr6Z3TIS95p0Gl2gxKzDMVadinxqeEe4wraUlQjeranTQtfaw18zPI+Fw5
	 8bF+cSXxy3qQfVRGpN3zwzmNnz/9hJL+2uPTs7rJKQ1JmN14+sa+BapUTmbeOPTZn/0R3
	 SN6B+gAVcBuAi1yE3wliS6uAbnamTSc4osPV8dHJpB1YFR8k3L6+L8kxaVo2SeuxMVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794874667;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=mZCjeYoVLTXgPtFhooWOdAgqkSbxaoBgREf6dkUm8L0=;
	b=sok81GKSGChPzJ84uMADbcOqI4C4wO5BwdF1x/0PkjHsGNBV0vxioPx43xDIaBM+dad4
	 c3UnryPL/zzG73R1f0nDBgjtnLPf3j9IgB7VBBxquekUbgn4/+y2L4ttKUYMGBJy9cppD
	 74ITRyP5vlOQfRDJFqNid586f0alQcktWVP3OYhQltRNXdC5hstbvPJTaRzZ3LIiPAWvR
	 wm2nwFZin+NhU2t0X7V0fGamQB2L3SXyO2Q1Xyjb4OFnRw21gL5ZvYMp7aZFtfFz1Bhb8
	 QjstC1eZ8ZzjPyehLLezvgcD+DvTbTkVQOZI6UnX37utujXhrMqTBoKTS8s2KCJ2rLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bP1+urcu;
	arc=none smtp.remote-ip=209.85.216.48
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDCB606A882
	for <linux-cifs@vger.kernel.org>; Tue, 17 Nov 2026 00:17:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFDCB606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bP1+urcu
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3b1535be329so3014989a91.3
        for <linux-cifs@vger.kernel.org>; Mon, 16 Nov 2026 16:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794874656; x=1795479456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=mZCjeYoVLTXgPtFhooWOdAgqkSbxaoBgREf6dkUm8L0=;
        b=bP1+urcuvG16SgYF1OlKCcQwtL5AF2QgxhzyAilER2O/2K10dUgzTXa2OCmKoNV+oR
         WshNzaqsm8e87NiYj95klrjEPXi07MY0D7RS6hFSkKfj4s321WH0gOOkTIR427iLvMjP
         DPFfvlDSsAOaWbYKSoUnrLZcjBnC1rocwA20a9NoDnI6K3v3cusl7Hj7SS2YyLqLnB6B
         fC8Cmlw/fMS9X0nzccc1Fs391BgFFh46sagagHoFRIHIDQ0Ycnd0fu4/7kgzBM8e0Qwd
         TBN4a4UdNCRqVMOzg1bhktc8KOeFfiAv/Cr/FzXg61GfZenrNe61OMsNR+lZ6ctWo5v9
         1R6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794874656; x=1795479456;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mZCjeYoVLTXgPtFhooWOdAgqkSbxaoBgREf6dkUm8L0=;
        b=NT5rFNU0lcd57J7XrVHaoh1INUA5VWO82jPphkrWNO8EGc+MEm/dlLbSL3puDzncDA
         nWDH7gTl09oMt1BXuJgZ1pvv0yB+NBwyPqf3gT+kbi7Kjt45vPGEVRrxmdD/t/exc/aj
         9IJkA8z0Bvv57nbMGsm6N+ofa25bfJHZX2tkMWCiwA4kP0J+6MW6daMbQfRgjZJ+4XKj
         oFzx49j8BSWbTgTZjWmwUjVnqm1BdlYyKcHOPvHtp+oq9ItwyTps0TwjxrrlcHLkss2c
         ckTp5shZQCNZbW0y5Y76evOen0GJwEDXs4n01E53InkUo6iUJAwAFK3JX4uQDwpWvHrY
         LXZA==
X-Forwarded-Encrypted: i=1; AL+hErEhQXTKYXirH9rrx8MzwC4FJ9llyLdJt95T0UlN/dHZuSTEPRzt0z1UCdLnErP6Zx7alg9wP5d7rtoj@vger.kernel.org
X-Gm-Message-State: APuU4Z9h1QaIcslUBQ8MRD4FVmHMqN8GOQoRTQsuRhBMEedYHrkzlLDU
	rS0Decnv0QDcRANQJbQZJmfbVA1sEFJ5gnPBgKqjCZr/y3RJX/PEr2ZQFC90jQ==
X-Gm-Gg: AZFdTZeGNRMgGMXBBxsX/9Whuq8hcWloxi6uqBCLJNonjETX9Z76Sb0kVPQxJRHbBEk
	yN+KDGc6mgLkQmvWMOYI6AP2ZiskCNK5r0/AgEyri8MPP2H+y6HhnID0+OV8XYsYmv6X2jL7QYX
	z4TPENW+ohCcgPP+9d03KU1aEw4zJfxNNZlckicJPw+6CSXw6T6X/i4hT4d3EMH76mkkTGhRco2
	vr63PGTcxhovmgMD3MvPPC8w+oNFrEEsQEf/A9T+qJKzeHFHLtic5lcJNtOhm+nrJa0mRQ+IQJ+
	laIgzf4ZnWUMOdgQcmIIQWRlE230egh1/Dl6Fa4R2kZrur/jjy4Cc4s5g7dEXyo7URgFxzJV+9C
	CzfFJ49L8+uz6EdqD4f0CrFf2LCVF4ZoSlaZBj9iKcS/OSEVq4x7ZbQVEQCnjdqsxeF7WfMsrYq
	S6jq2PI5eqbQCR9xPj/JEfBOzmZJVRpTSdaQK8jh/PUDaLllR3C7Ntuetxk3V0bmjhKosSh8hLY
	qEAgqQLrdHxnrV6S4fVsl2I9hpTBz33ckBIdOa+wSqSMmACf4rcQK96IzqEX/rXmBIoMtDlMwC1
	tNBl28kU+E5S78mQ6OqHFga2X8nc/YCYfFg/9Iauu68JYPH2dRZf5y0Rwl2pYoKQ4Fv33H4sQU/
	q6o+SsBBDXkUB0kruac3rIGjgCLNCq26voMYtjPAfEi6OkU7ZkdqTB0xDpBRpLPI/OkxVbnsxtk
	/cU6z/GqlaQH56SiMyngVzf+MIyFHR1dL/IxFUxErw
X-Received: by 2002:a17:90b:5585:b0:3b0:9e2f:cfc3 with SMTP id 98e67ed59e1d1-3b1b0a0ddf5mr11086246a91.32.1794874655997;
        Mon, 16 Nov 2026 16:17:35 -0800 (PST)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b3abe77179sm1194081a91.11.2026.11.16.16.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 16:17:35 -0800 (PST)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: Paulo Alcantara <pc@manguebit.org>
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Allen Pais <apais@microsoft.com>,
	Rachel Menge <rachelmenge@linux.microsoft.com>,
	Hardik Garg <hargar@linux.microsoft.com>,
	Adam Kim <adamkim@microsoft.com>,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 0/2] smb: client: fix unmount busy dentry/inode races on openFileList
Date: Tue, 17 Nov 2026 00:17:31 +0000
Message-ID: <20261117001733.192399-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series fixes two unmount races in cifs_kill_sb() where background
paths walk tcon->openFileList while wait_var_event() is waiting on
cifs_sb->outstanding_rreq and take new cifsFileInfo references that
outlive the wait, causing busy dentry/inode warnings and panics in
generic_shutdown_super():

- Patch 1 counts queued oplock/lease breaks in cifs_sb->outstanding_rreq
  from cifs_queue_oplock_break() until cifs_oplock_break() completes.
- Patch 2 counts persistent handle reopens in cifs_sb->outstanding_rreq
  in cifs_reopen_persistent_handles() until cifsFileInfo_put() drops the
  handle reference.

Siddharth Chintamaneni (2):
  smb: client: fix busy dentry and inode on unmount from late oplock
    break
  smb: client: fix busy dentry on unmount from persistent handle reopen

 fs/smb/client/cifsfs.c | 10 +++++-----
 fs/smb/client/file.c   |  9 +++++++++
 fs/smb/client/misc.c   |  6 +++++-
 3 files changed, 19 insertions(+), 6 deletions(-)

-- 
2.43.0

