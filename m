Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C35F1917F0
	for <linux-cifs@vger.kernel.org>; Thu, 13 Nov 2025 04:39:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763008787; cv=none; b=sUb/DWCX3JbocWNf9Ai1kTwLaiTf07c0pUxhsLIfRU3H+l5S4ESL54qZ3kGX+7YTbrdUqXThmBh53MLi9eWLNZIy7PrvawCIpOCbfz5HV5qRPjAbHNMRJqhQghXpNI4demKwEyLAt2NOkkVUnPaptuIdckMCD8Lt6nkgqfwhL3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763008787; c=relaxed/simple;
	bh=8PE/5UQ+uNe5danCCBOkdV9a/gHHtnO41yR+Z+8vF9c=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=dUCg+lLUi7jgwuTLt0+3kf4s2oGmIvR81Ww9qVsW86lCRw9vq9hw1BfWV5jCO0BgSesr6laEkjbcMtbvWoK0zoap5psKZ2xM6wrZ13OImFD6pfYv9E2eX8OlbQ1SIwi4UZbu/vdZP+gg0i0sUrG2Xs/etieahUffXJ1qjWtAlZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TKCKTppC; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TKCKTppC"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-4eddceccb89so4409201cf.0
        for <linux-cifs@vger.kernel.org>; Wed, 12 Nov 2025 20:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763008784; x=1763613584; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=nS1Fb6GY+hcNWo43ARgi6gCvS6V1xrWZtXSBcti+qYA=;
        b=TKCKTppCSwCsllOXmp+xW40ejn0s1bjOGOAAZnNus9cr8MB0XsKTRQGNBvCrsK9nv8
         XeWiETpruJooaY17aBdA3eHHcKhbXcHYltj9zX4kQ0mV815hN5aIYSDo4lkBdJNzFZk/
         6HDGcbgJ0SAKQFqB6txgVzacbJpZhUV5VAcdy9h9PUCbcSpsfvrBJSkXwmB0hBUq+RdR
         c8dBIHqai+HztFx4jXBqyYWjfezTDsU5YjZsvMj6VHAKEzOouJxFwgSdt4v4nAXwwXdZ
         93woQv6U+aTbeI2jO5Pr5jXUBmSbp0qsY+I5qGydyjqYZ7t4EWUzHEMzie/igE3kuRY3
         7+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763008784; x=1763613584;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nS1Fb6GY+hcNWo43ARgi6gCvS6V1xrWZtXSBcti+qYA=;
        b=CjFj+1HfjGBcayHLamwCVva7yZahNTWTyg5P2YJCppcdovkzMU6CrY559dM83Tfltr
         eCrsYzMI+hl9An5FvXj5ZyFNZwUTKcBMChy4j+nFo+XO0+adGsGj9OGDJ7Z9Uo3gaulF
         7ruEPT7o8FdvJNdz8UJzmZ0Bz6cKw06Bhy1wD8Nnl3fXeYpfmntA6KvQ8Ut9F1VBUmEV
         NIeVegUA9GfJzOJ5ZamCyrrHSayZL5VEuExyumUbhEV1FXYRR+i9fCctiGhqk6yjL/kk
         IABFKbtlZR9F8tjOrqg+tqzQ7gYTCsroCZ4q6x9KX5a+aaQZM9IXfyKsf/mASDGxZP/A
         6FgA==
X-Forwarded-Encrypted: i=1; AJvYcCU3QSWuVGbjs5BrDz3VvRFZuXYOmMZBr3AhmEJOcm5I2RA+rspB7XLkLtrshH5CvsuwbNu7Q1qhE11A@vger.kernel.org
X-Gm-Message-State: AOJu0YwscDiCYxSIs9R/z96/bmDtPSShgARPs+r1eLqK0W3F/ZUlbAA4
	z7AX3TkxO9MZYVWmuOuFSHsPjO4IkIjSs96EpBRU4+4NrPPSEML2Q19xHQME0lCytMZPafSgCNc
	RUUb9O/wWqEBmPLzwe/49bEVvnHMg+4pN1hXD
X-Gm-Gg: ASbGnctYLWrY4xIAvX9LgSZBTyP+o2eCYAGtxE7z5c7ZRx+P9QjIVeIJNtzsJchBfEw
	9eT7ycIm0KfLIXx+x5nm705x+tkzUCgRY8Ne7N4WulxsAO9EMkEgCyHd76VyxV0WIUqlU91pYpH
	jq91HQD0P2MCVV/EtMOLbu3hh9issZuSWMpp8rntuU7ujgkHcvAQPG2DTCssLUlBbk+xKkbJphq
	TCgx1HnNYweTZDcXujFfMfK+Eg5oYJ9UTxoWrjOS3ob2O/o72DLuKmKXP/CSsAYd4MgDJmNmOdu
	EVo9PCzV8pIiv29B5r8E596Ta/7PL46rs9XEXKDHSVVS/y5KaUnzS3K09tiMJ6zmHR1ncDEx85t
	cm6VrPgqDLWKaNsLKuMO83lZqArLzlamBQNfu5482AKD6s6lm
X-Google-Smtp-Source: AGHT+IF/HFdvvnrQstUYL2HuKqJQana16mxr6VqWpNpkevQWIOl9K20sZHhgiPfXNxPJU+XnOgrH/DPNQqHwHB8DZKc=
X-Received: by 2002:ac8:5d50:0:b0:4d0:ac40:fab8 with SMTP id
 d75a77b69052e-4eddbc6aa3dmr79240981cf.7.1763008784515; Wed, 12 Nov 2025
 20:39:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Wed, 12 Nov 2025 22:39:33 -0600
X-Gm-Features: AWmQ_bmA8jjlgRZ1SJQzNksGaq_SRIeKXPDybLTOtBvuiJNrv9YIYy_FUkSQTlE
Message-ID: <CAH2r5mt03Ds=Fcbn59XO+9Vy6SVpeQ4DvcUzu-gA4-=gw5A2nw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namjae Jeon <linkinjeon@kernel.org>, 
	"Stefan (metze) Metzmacher" <metze@samba.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c:

  Linux 6.18-rc5 (2025-11-09 15:10:19 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc5-smb-server-fixes

for you to fetch changes up to 55286b1e1bf4ce55f61ad2816d4ff8a7861a8cbb:

  smb: server: let smb_direct_disconnect_rdma_connection() turn
CREATED into DISCONNECTED (2025-11-11 09:50:35 -0600)

----------------------------------------------------------------
Three ksmbd server fixes
- Fix smbdirect (RDMA) disconnect hang bug
- Fix potential Denial of Service when connection limit exceeded
- Fix smbdirect (RDMA) connection (potentially accessing freed memory) bug
----------------------------------------------------------------
Joshua Rogers (2):
      smb: server: rdma: avoid unmapping posted recv on accept failure
      ksmbd: close accepted socket when per-IP limit rejects connection

Stefan Metzmacher (1):
      smb: server: let smb_direct_disconnect_rdma_connection() turn
CREATED into DISCONNECTED

 fs/smb/server/transport_rdma.c | 14 +++++++++++++-
 fs/smb/server/transport_tcp.c  |  5 ++++-
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
Thanks,

Steve
