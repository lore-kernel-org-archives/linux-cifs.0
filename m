Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED9F3081D3
	for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 16:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761927212; cv=none; b=d5gmsFzqpUEh67vFd6v6SRCK+iFRSZ7mJv2tLCxCj7IwZmq2hYUEqXqTFPyxbGVKXnM1Qmc5lPuf9GGR9wwVqCSYypMlaA2itL5wndlYJro469Td/VG2txNSYIMmCDvhEpniPgoEre3L6pWpBne1ld0/f1XlWbcxy7/INGAFlco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761927212; c=relaxed/simple;
	bh=9RdCBa4+4sRCwXB20xmXer78rbra+zl9rgLx/Ct8cus=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Yp6CteUiB+7RIgDsn+nODSuyZxTF0lSZMvesN0HLqHzxq+Iq65LXRBbYTXTWfoHz4G+gYb+e5MCJlIijfB4zL2A68kgDejsg/JwqXmOEuC2og7OEee3lWAByGkmLyLpcaO8fHER1KIslh9H4o7TICE6/h/LDfClZTsiVgLDDJQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ORVqpIt1; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ORVqpIt1"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8802f480f65so8995026d6.3
        for <linux-cifs@vger.kernel.org>; Fri, 31 Oct 2025 09:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761927209; x=1762532009; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=2xkF6zKonfubE7Gp45g4295GunQ1O6+736QRxZvvn1w=;
        b=ORVqpIt1GmcIbDzbHsdSmDxORXdoKcRKGqL25FqvEJ0kc1gcyxGte81BM55QZyD3K8
         jpxCCykrkM1QDVeYAjXI173urdb+58NPBWLTLEO5Pz1MbSEeRB9S6yQ2ySIQQ/yq7Y/J
         4AxNuLFo2kKv6WV5fpJWgWzRFSK3brUMrwC+KQHFSHngNzP4syeKmL71OwV5DLrmn+NN
         hfEHCbi4697f1zdB008F/a4f7AosnFlGZE94aK0HsZkg0lKVv4Prchm+A8nfv7YWC58x
         mno3k5J+/GiW8opwg3lhoOw+N54wfnguxHmaA7747ylFWiYX+5GYGE4bAgzjTbg/G1qG
         y9zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761927209; x=1762532009;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2xkF6zKonfubE7Gp45g4295GunQ1O6+736QRxZvvn1w=;
        b=CeyiNAugczbgFfZzVAOXU5KPL3IOHV4/ioR1SpwN3Q4fwmenIu5wGCBEzVqV2VetcS
         ald+Ou8zZK+3utGBSaFahaRb9LKVn3IAUvji/I+7BokFMES/g+lp+UyP9v4eqNzJQ1hr
         qVmsFLKtsxIA0cHQdeMc+gwo168XK9HjwhXB6KUyr4TRXR0Bc0TBmFxp1TfxEfl7knFt
         vqQ4GksULwoQb+L2ki8znS+O7dfAwDRx/tz2tKkX6vfezMPYv3cjzcClKrimxzxRAXxW
         Rc/XtC0tdia8fwp1Nfs+nU7OK0NSL67/vCFWtUS2Xi7cNWse2l5fsQ2RWKMTB2lUFs7W
         5Kpw==
X-Forwarded-Encrypted: i=1; AJvYcCXMnKYvjycRSm2f95+amLi5bxFFiK1mYpoExiCr7gSGfFEbxI5nGnYwK8ArITbxsfqVTvc/6/gotrtR@vger.kernel.org
X-Gm-Message-State: AOJu0YzMMlQMVGe96VJiFttXuXQzlmuc1PKvEhxIO9QMK4fY6mJMqsn+
	xipgO3mBHpW4dgeRik0rT2ElyvYaXjUJK0Kb3rTgvyXmtbT4Bn5xUbQXN0DWH45gqK2nv+irtfb
	RHs5kngTnSbAj7CHdelzC1yGtl0ftkZo=
X-Gm-Gg: ASbGncv+S6pmqPLgjUktwOV3JMJbxI6IuFrS+RZfMu0+guyk2IBGKREjVMLi6itywko
	h7BGROC+bnpxlFJdcRzpflcRDSfzY241PdgZ/zmBaV+gZDSyAiUPywnyBkDBGbuwAQrvRl4p6ic
	auq7fOgJI62IWTqoJ8QuPE24BwLW4NgsagDyOwqULsiLzjrrBMUc2ItyjW5/4VZiybECY+rrB7F
	xfLXGcgJODEbtswoZkrn6K4JTybVp7fymuQ0BzpIPAiZFt51OWVlOAWbOoVETqUgDMXrKwxd3Di
	D8PExZbDMnBVxgrBKHpRiRSU+BxjgIXWmBtd1VmISvrwN5QGUFU9EDLZnI+UQGP/uzSJdHVfW99
	M4WMZRSMVlk8/WjXh7QU1aq63yV2OeX9wWRTPen538vulWJ5Ax4W2LhSxRLYrSTxmwGdMO+71tT
	0oBi+QY48Kzg==
X-Google-Smtp-Source: AGHT+IE52OHr9noC3oLJ1WckJWhHadkdiT7DbUmXmXtxox11pJWlk5r6sZIzlJMLBkAH7DXTCdcA9fcO7XZllyQdAeQ=
X-Received: by 2002:a05:6214:20ac:b0:880:415d:a9ff with SMTP id
 6a1803df08f44-880415dacc8mr18734106d6.37.1761927209173; Fri, 31 Oct 2025
 09:13:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 31 Oct 2025 11:13:15 -0500
X-Gm-Features: AWmQ_blIddoJEuR4b-Bb6q2Sqpv8Ry0bX3Y62WreUtUF4tvYBQPX1WS7N1E64rg
Message-ID: <CAH2r5mvmJJAp1AX2Sda3ungmu7hcaYje2NYS6YtngC4F67PHeA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
dcb6fa37fd7bc9c3d2b066329b0d27dedf8becaa:

  Linux 6.18-rc3 (2025-10-26 15:59:49 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.18-rc3-smb-client-fixes

for you to fetch changes up to 895ad6f7083b0c9f1902b23b84136298a492cbeb:

  smb: client: call smbd_destroy() in the same splace as
kernel_sock_shutdown()/sock_release() (2025-10-29 20:13:13 -0500)

----------------------------------------------------------------
Four smb client fixes
- Fix potential UAF in statfs
- DFS fix for expired referrals
- Fix minor modinfo typo
- small improvement to reconnect for smbdirect
----------------------------------------------------------------
Henrique Carvalho (1):
      smb: client: fix potential cfid UAF in smb2_query_info_compound

Paulo Alcantara (1):
      smb: client: handle lack of IPC in dfs_cache_refresh()

Stefan Metzmacher (1):
      smb: client: call smbd_destroy() in the same splace as
kernel_sock_shutdown()/sock_release()

Steve French (1):
      cifs: fix typo in enable_gcm_256 module parameter

 fs/smb/client/cifsfs.c    |  2 +-
 fs/smb/client/cifsproto.h |  2 ++
 fs/smb/client/connect.c   | 46 ++++++++++++++++-----------------------
 fs/smb/client/dfs_cache.c | 55 ++++++++++++++++++++++++++++++++++++++++-------
 fs/smb/client/smb2ops.c   |  3 ++-
 5 files changed, 71 insertions(+), 37 deletions(-)


-- 
Thanks,

Steve
