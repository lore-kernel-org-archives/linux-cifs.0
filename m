Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432B11C5D57;
	Fri,  8 Aug 2025 04:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754629152; cv=none; b=B7cEEIvXAplXUwjAEbIZQaIdjlbHkR1LcI7ZFwWnpPcuqT7y6KDuCYmMbzA6domjxYRH0NJsU2GiWAviuSHTo/QXYRhz+lTyRkmB9QO7pL2zJKoFv14wIRT77aK24ofGcuJw2V4/brM+N8KXTsD3wcf+T+YOVjERGU57z0prv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754629152; c=relaxed/simple;
	bh=/VoKBIRGiniKsG1TFIp8MwJEZI2BoAtxiN0PrthFJkM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Z+u2oCoNK0eFBPwkWLgTvYGOMiG0zWu1MFNfHwhQNkq8aoye6qDCJ1g8F3IwzrHikvBLPmWtM6Iu14Wwtd/4rwO1qpIOsIkzVzQoKoXazPRdfJkGePOsxlEQD8/xWg8VF3j8UfdfD4W8AV1cRd5n5b08Oq9TmkRyYsOyaOdAJiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mbN0x6Cw; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mbN0x6Cw"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70767eef931so21871586d6.3;
        Thu, 07 Aug 2025 21:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754629150; x=1755233950; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=3NMZPTEUmLg12mM+VUodjDSUgZfHpg3c9/sNqjgze9A=;
        b=mbN0x6Cws9Y7oaN5dmZoW5cwtnUEl97LnLTwkG9ERAE8f2B9iDss/nWKlSWn8xaHUw
         TdDaOg4bfuSUeLD7m9a3pla8ITxcqvE+dqB6u7JR6RwqHNKGtBsLwcJRL8VljCD1KWpP
         fz6dEcPVqebeCg40hCJsvj7ROz5yHqlkw2t8MiWmpapnxZvTCq0/fn/dQrKEmkI9Bb8G
         iCKb+Pz/raN9oXP8Ir91XSz+pB6SVPqYVshsGH3gFGtgjJNthkCx6sikMTgQUPh6ybVT
         R5x0C+7JYJa1jFF4fHZCvSsoOGktgQ0HJa24e5hB3SIZZCe+NSXeQcdlVypW+l5gT0Ki
         RcHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754629150; x=1755233950;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3NMZPTEUmLg12mM+VUodjDSUgZfHpg3c9/sNqjgze9A=;
        b=AJcHVfg86wqfBLQvyaPC/DvmR2Aymq84WumDhyXF6cW/nTuVJXBCtpzfPJalX2/WAa
         y8/LcjVxtficNdSkeb2EFT0ED4xRDy9MXglDf1FYgLI9xcB0euQ/f5PQPxCiQSkLwjUp
         O1bXWgVwk8STa0/ihfX5EFW9szB+gyLozEW3ozk45M2QhoCw7DWI78ZxUFcUdhxdepF3
         55uDEtxsg/hY5OHGdDt4WMlciSehaom7Uc3rMEWuk9137kZFBEtinxfpLyh8fb1Tu2C0
         FBqKAH/zJSp3S0wPPmt0xXUhj1wJ7bn9tX5sQdxCp2bdlJgyG6dBa4x8gQ103eeB/POu
         3Gdw==
X-Forwarded-Encrypted: i=1; AJvYcCV8m9WJ+km0cnB/MUMWXncemv/LuKmE5DZdcDPaTmRDsUYNXR/blFO005KZFo5DleZrWgB/KA10xhTSIpkY@vger.kernel.org, AJvYcCWOUcxF25ql8bdeTr8FBf25tGIee98tG9mCHUuHf5GVHqqXCxBg8+D7ziFYE9hUO36Bs+WQ3C/qubGN@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo16lSBsJ+2oTy/ctrkEU5fgW+FRChWMIslh/oXVO0Q4mXZqll
	9Z0TqysNVqEuQz5btzpajeofOexCKWZemIgC43VmMCIBOO+yRLu3CAaLEcc4x9NTc7RGLy2uKKB
	yYfdoEaaUVInrY3KuzMy14JPUP4fozfAREF4c
X-Gm-Gg: ASbGncuiYSvU1S3ee2KwQfrjbZIf7AUJsJqBeDuR1rUzv//85kxiX7KDX88idTqZVpD
	+ZjsDaht60XFOqWMOme3Wp6OwhHhnPnQPayObhdrw/cMrUc2/uwyYKn4zLbbHLPWNeHyDY78h1b
	/lkrF5eITrIwlJFEp5X9JRqcOoafLMX55GJd26ZjumstrPRp+DF00lNx/mCUVWQYFUONA3NCSm0
	V0hVe+GQt0Zbw7hynBGMF6KOiypT9diaWAbk9cQ
X-Google-Smtp-Source: AGHT+IFQVW1TjkW/29AJ4QjojZr1+QwZQV1LqXCN7XtQ/37rwybEDxlOnn6cAfsZ4KcH0fkOgfLkYp9aMoFkFomCBKU=
X-Received: by 2002:a05:6214:2aa1:b0:707:69ad:d84a with SMTP id
 6a1803df08f44-7099a4ba55emr24323766d6.42.1754629149962; Thu, 07 Aug 2025
 21:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 7 Aug 2025 23:58:57 -0500
X-Gm-Features: Ac12FXwUgvDHdw_yjgYnic27b8AfFeABMaXlal7e0NuwgxTuJcpp0DdXf-BKnwI
Message-ID: <CAH2r5mtS_MJcNe9iXHv2VpC+dtf3G_9nqOqwosH5F2N60idrBg@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
e5cf61fa6e2fb9ae6339eaa892612488c966baaf:

  Merge tag 'v6.17-rc-smb3-server-fixes' of git://git.samba.org/ksmbd
(2025-07-28 16:25:24 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.17rc-part2-ksmbd-server-fixes

for you to fetch changes up to 8e7d178d06e8937454b6d2f2811fa6a15656a214:

  smb: server: Fix extension string in ksmbd_extract_shortname()
(2025-08-07 18:23:12 -0500)

----------------------------------------------------------------
Six ksmbd server fixes:
- Fix limiting repeated connections from same IP
- Fix for extracting shortname when name begins with .
- Four smbdirect fixes:
     - three fixes to the receive path: potential unmap bug, potential
       resource leaks and stale connections, and also potential use
       after free race
    - cleanup to remove unneeded queue
----------------------------------------------------------------
Namjae Jeon (1):
      ksmbd: limit repeated connections from clients with the same IP

Stefan Metzmacher (4):
      smb: server: remove separate empty_recvmsg_queue
      smb: server: make sure we call ib_dma_unmap_single() only if we
called ib_dma_map_single already
      smb: server: let recv_done() consistently call
put_recvmsg/smb_direct_disconnect_rdma_connection
      smb: server: let recv_done() avoid touching data_transfer after
cleanup/move

Thorsten Blum (1):
      smb: server: Fix extension string in ksmbd_extract_shortname()

 fs/smb/server/connection.h     |  1 +
 fs/smb/server/smb_common.c     |  2 +-
 fs/smb/server/transport_rdma.c | 97 +++++++++++++++---------------------------
 fs/smb/server/transport_tcp.c  | 17 ++++++++
 4 files changed, 54 insertions(+), 63 deletions(-)

-- 
Thanks,

Steve
