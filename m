Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFCB433A0;
	Wed, 28 Aug 2024 01:39:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724809167; cv=none; b=eMig3PEcVj4C6zcQQadeZof6lyWZHA75Jf3XaPciBYSSoGBqL3kqjWG4MTB+0lD6VZFIFwHI/slozo56T7IHaqnsWjiffTBbMQNfWHALrolOZjtfApaEaiDmrddX9pXaKbOimjvKzaUkrq0PgPUBFLoxLe/3kSkF/VenFEjoBXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724809167; c=relaxed/simple;
	bh=/9TLc8EbSBJH5R764dm3/rvLn5kXSvNyS1VR6Q8vfOU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=Y/iqfYypbjS8T/TAWLbp6Aj2OVhg6xPfxErR9oveKa1I5vxRzT/AcUvlCdlNB0oPkfjB5qf+RULdNx9wIWGXdTVw6LbeVhBtM95UIqvVW0LT9xK7pkW/Wkl1Utf+64kJ5QjX4u//DFDu3AeZdJUtVrBzioxY5Af+s59i7xKIsNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NO95nIrD; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NO95nIrD"
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2f406034874so61977261fa.1;
        Tue, 27 Aug 2024 18:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724809164; x=1725413964; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JTEjX7nck7OOiG863T7jB9HoyueMbOK90upwZwBfEEk=;
        b=NO95nIrDpnvoGQvuKLd/3UM2WM1VXZYMz2OU0gj9W5VXW5oNGMJqetdbr+xtf+Cmtk
         4SeQ3SVLxZc9WlV8RURH5MIQKNZ0J/eFM+nLEusus3BhdeSPbsGLSUtjWSbnXhO9tm8j
         jZgSRJ/mfzoIiUDyiU8Rw8g/znjmLOkyql25JMab/AmEClrX/1Zr4tM3TX+j5wIoZsyn
         uoclMyGYHT6jXNTIGpnjnO+RARQv0Um/VndQqKDRAYmOOwfcBQtKNWq3Gz9CsdGerkDu
         s4cN4htdAlckqlGN9vCVjm5uqFkVbht13kkJHfSdHPk22G7cwOiUhkFExGllJ34hsE/J
         wDZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724809164; x=1725413964;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JTEjX7nck7OOiG863T7jB9HoyueMbOK90upwZwBfEEk=;
        b=jSVHEX8dHoqk3VIemFtKXYjlt8F3gBcm7ttXvGA9EeCaLdWis1RP5ghJ3yHrtPiK2V
         FErtxPKLPoUuorzkfE/JPvfZPR8V+5DuaXXlxVIKWHC4nw37JJV6BZO2rrlFQk+1VebF
         xLDSISaR15o90VgUULNCsTtI/RiQ1WnN5Ow1keDsRlOYoR/Y1a/zTCG8Z39NpX3T6HrS
         hJucHQxx2hvMJtz7eoXMkVQkUagao5h9KDTcoyMgi3JmNNuAUyF0LSpOKCKPIb/cRaf6
         Nn2eCejY8ykdi1O3Epq47dB1iQlCmCMa0DeXTkZuIJM9FPQnwiPO8kBKS5zQ8JH7n+IZ
         lwHg==
X-Forwarded-Encrypted: i=1; AJvYcCVuMXlX3YbYmJoh9uPiLR7rgAgp8pHumOQ4GCqbax2icSn6j0XS8g85VwZP1dOXTUqi3curSvv2emzIcGU=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/CLRVakB1+wwg9/8Cz+gx4l8SZdyiV/KvQYUDoxIpgNEBZ5Rt
	VT786WXb20JHg+LdC+9TBlHYkilYkbuBq2fHvaAYoNib5fXHoFV7rV48sdlBdIXbJCZ5fsxags6
	itka4NBpeiTo++yZvhNvmHTC2V4dxuhIt
X-Google-Smtp-Source: AGHT+IE5UK0vjKCh/Nm1qbqRBQoqT5w75OeLQz81np5KcB8bwmR45la99bi6beLXLQpBi/CJMoegZ657c/tHy1QP6MU=
X-Received: by 2002:a05:6512:398a:b0:52e:fc74:552c with SMTP id
 2adb3069b0e04-5346c62878dmr268233e87.33.1724809163861; Tue, 27 Aug 2024
 18:39:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Tue, 27 Aug 2024 20:39:12 -0500
Message-ID: <CAH2r5msMPe09TV2mmMFZC=BEXoYrN1foPk3ccgZrozgFU9YZFA@mail.gmail.com>
Subject: [GIT PULL] smb3 fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
5be63fc19fcaa4c236b307420483578a56986a37:

  Linux 6.11-rc5 (2024-08-25 19:07:11 +1200)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.11-rc5-client-fixes

for you to fetch changes up to 416871f4fb84bc96822562e654941d5625a25bf8:

  cifs: Fix FALLOC_FL_PUNCH_HOLE support (2024-08-25 09:06:25 -0500)

----------------------------------------------------------------
Four cifs.ko client fixes
- 2 RDMA/smbdirect fixes and a minor cleanup
- punch hole fix

----------------------------------------------------------------
David Howells (1):
      cifs: Fix FALLOC_FL_PUNCH_HOLE support

Stefan Metzmacher (3):
      smb/client: avoid dereferencing rdata=NULL in smb2_new_read_req()
      smb/client: remove unused rq_iter_size from struct smb_rqst
      smb/client: fix rdma usage in smb2_async_writev()

 fs/smb/client/cifsglob.h |  1 -
 fs/smb/client/cifssmb.c  |  1 -
 fs/smb/client/smb2ops.c  | 24 ++++++++++++++++++++++--
 fs/smb/client/smb2pdu.c  | 44 +++++++++++++++++++++-----------------------
 4 files changed, 43 insertions(+), 27 deletions(-)


--
Thanks,

Steve
