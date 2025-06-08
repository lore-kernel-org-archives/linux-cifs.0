Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90D8BA3F;
	Sun,  8 Jun 2025 01:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749344609; cv=none; b=N4dWvewT04BwskSDQqbd4GYMWNs/qNYTqXx1j5VnIfPlioNiop+4ydzqut5M0bwx4iyqqcQ8jZ15YF8Aze0yRQmf1QpFfV7L9Wt3A63Vp+kOYg3liZjeFsTBKAUXBTof2MuJC0HUIutUEeNMWTcJz48aG5JkOSV383fasWKgOag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749344609; c=relaxed/simple;
	bh=1DBk1/3hW6AD0jC2kHKQB4BwxaYpmiMAJ2x9dIk/uEQ=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=eKsK8TeNk7h7JjJjGjJqr7jEIrq/wy92bbqV51keFj7fub6xJgm9uLx3Vi6myCw44hjdYt8bxJCf321Na0cZcWqqyhKgYXaFt1hz8pDdlAxzIU0fpCeQ1RNNHDmfljNAHuRRVWrb2aR+G4hridfMhopAsWJum6aHwdkO7Zv1L5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Zi8AW5Bc; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zi8AW5Bc"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-553543ddfc7so3241006e87.0;
        Sat, 07 Jun 2025 18:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749344604; x=1749949404; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eOno41Y5407AxKrCDHPBscevc6cncFpgsXyyghp6mJw=;
        b=Zi8AW5BczqzIaD1YRPXVpq99xVl/dgJK63007IysjOWYkDo2CNJ3kM8GZXuuco6K4J
         6XsYLZ7RbijJAwfoGz9mIP76VbQpHtNv3/gID5gwRXa56kWpeyduSI1wLKonfM5O6zI+
         HXTdZ6XqMcsoEwZm0QCeKtippBKR+pDc+j9mANBSHuqW7Y0M96eVQMbDq7MHk1UcrZRk
         g9r0FO+fRR1Vx4arzkfIO9icJVD2NRPvIQy377cBvmRbWnYCJLQhx8rxLBgQ7US9r0P4
         xnscUm6SMkdTTfJOeLxSmRRdIilBwCl71s8raz4bWFWrburrpwgWOFIL6SOJVjghKVgn
         I+rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749344604; x=1749949404;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eOno41Y5407AxKrCDHPBscevc6cncFpgsXyyghp6mJw=;
        b=goK5xPDaSaN94yu6wqHIu/4ABDyegEJbG8hEgu3lUSQ0WbzQNuI4v4vV4jSUqemBxv
         QkGsaPYY5i8HGTVMo6UN0Ws02eUU/yU/J5nuFRYZoDCRH9GZ6ZcqIsfUHE0aKw1lsSfb
         TxETRfttVz3uY6S4qByI+tsHGMxvm6GidpVsFjijiz84rE8BEk+/ZhbcQrrh6yruuYF4
         dH9yIGZIGXO5Kh5oO/45XYEdkWVw5L0RlPYD0kRF3XM7CwLUf1FiQS0QGFCb60DFqOrE
         lRjrVmi8VoxkJ67U6jQi+LgfAX3N2W3vGygi2l/F4ISanzY8Z0hhmnPI72nuksdHghev
         eSxg==
X-Forwarded-Encrypted: i=1; AJvYcCWTU2sjsq594md9JNzR/5A8SaQvCrY21ZbfbvOajXSz1BAwQ/botgsjelcpOko6dfYlhUcFFnflfVU2CwM=@vger.kernel.org
X-Gm-Message-State: AOJu0YwfE9H93x6VS+iXVKcyF0Uap2V0eNxBm+X13iiJPuunL462iRDI
	tyBtW3wgrPscyawR31hCTHGuww41rvgAitBiMOUQZyqpZRawlu1fKaxD9e1PVajov2PDZTU+UjF
	QdcDY2jIA2AbKVioDFRX+QQbc4+3QGSkSpKqp
X-Gm-Gg: ASbGncvokGDdt9s+8Ur8ISepqBQAy8BDbJ8pdTWx559tIWedPx1NbvPvR84AoJIRG87
	T67Tl+PPRFw/KxIpkeDeWNt9brTyjUayuOm2n4Sekb0Kmj5FPg8cc0OZr6HF+aL9k54D5Z5r/N4
	D4G89jxt715N9QqSPpf5FChpzAWnOBmCMrQJwrplF9/ouDdavlMGCKUd3ga5Tx23aZtfqFPEzMW
	pAi
X-Google-Smtp-Source: AGHT+IFI24gvQuV0lGx4sjAUCwKgKFqloJT6lRkQB3DiJjy7Sbt6+T7udpvVwKHBE6p6TYUV5b4G5Xv14XpUvwbyjdg=
X-Received: by 2002:a05:651c:1545:b0:30b:b987:b6a7 with SMTP id
 38308e7fff4ca-32adf92f552mr22704691fa.0.1749344604123; Sat, 07 Jun 2025
 18:03:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Sat, 7 Jun 2025 20:03:12 -0500
X-Gm-Features: AX0GCFuWRQgqxBkBM-zybVWhjF-NUFhn8WNZ4Cl-lGBCqaHjgXLlWyhZgXTZ500
Message-ID: <CAH2r5muDjjJVcngtDHa87ZWKGD_uZPV7KVO=Fg7g57-OyudMxQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: CIFS <linux-cifs@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
6d9b5f6b81ace1b2b0830271ad46628d6fad31bb:

  Merge tag 'v6.16-rc-part1-smb-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-06-03 16:04:29 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/6.16-rc-part2-smb3-client-fixes

for you to fetch changes up to 8e9d6efccdd728fb1193e4faada45dff03773608:

  cifs: update internal version number (2025-06-05 10:21:17 -0500)

----------------------------------------------------------------
Fourteen smb3 client fixes
- 3 multichannel/reconnect fixes
- 8 fixes to move smbdirect (smb over RDMA) defines to fs/smb/common
so they will be able to be used in the future more broadly, and a
documentation update explaining setting up smbdirect mounts
- Update email address for Paulo

----------------------------------------------------------------
Meetakshi Setiya (1):
      cifs: add documentation for smbdirect setup

Paulo Alcantara (1):
      MAINTAINERS, mailmap: Update Paulo Alcantara's email address

Shyam Prasad N (3):
      cifs: deal with the channel loading lag while picking channels
      cifs: serialize other channels when query server interfaces is pending
      cifs: do not disable interface polling on failure

Stefan Metzmacher (8):
      smb: smbdirect: add smbdirect_pdu.h with protocol definitions
      smb: client: make use of common smbdirect_pdu.h
      smb: smbdirect: add smbdirect.h with public structures
      smb: client: make use of common smbdirect.h
      smb: smbdirect: add smbdirect_socket.h
      smb: client: make use of common smbdirect_socket
      smb: smbdirect: introduce smbdirect_socket_parameters
      smb: client: make use of common smbdirect_socket_parameters

Steve French (1):
      cifs: update internal version number

 .mailmap                                    |   6 +
 Documentation/filesystems/smb/index.rst     |   1 +
 Documentation/filesystems/smb/smbdirect.rst | 103 ++++++++
 MAINTAINERS                                 |   4 +-
 fs/smb/client/cifs_debug.c                  |  23 +-
 fs/smb/client/cifsfs.h                      |   4 +-
 fs/smb/client/cifsglob.h                    |   1 +
 fs/smb/client/connect.c                     |   6 +-
 fs/smb/client/smb2ops.c                     |  14 +-
 fs/smb/client/smb2pdu.c                     |  50 ++--
 fs/smb/client/smbdirect.c                   | 389 ++++++++++++++++-------------
 fs/smb/client/smbdirect.h                   |  71 +-----
 fs/smb/client/transport.c                   |  14 +-
 fs/smb/common/smbdirect/smbdirect.h         |  37 +++
 fs/smb/common/smbdirect/smbdirect_pdu.h     |  55 ++++
 fs/smb/common/smbdirect/smbdirect_socket.h  |  43 ++++
 16 files changed, 533 insertions(+), 288 deletions(-)
 create mode 100644 Documentation/filesystems/smb/smbdirect.rst
 create mode 100644 fs/smb/common/smbdirect/smbdirect.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
 create mode 100644 fs/smb/common/smbdirect/smbdirect_socket.h


-- 
Thanks,

Steve
