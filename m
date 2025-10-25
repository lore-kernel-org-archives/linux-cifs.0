Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0020CCE4
	for <linux-cifs@vger.kernel.org>; Sat, 25 Oct 2025 01:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761354671; cv=none; b=qC3vUeSMUEEnC30KkFoNWSSg9ndUx2r3eexXcTzOzExxWPB7oZgZe/byu4bsJcq9QeX/+ApM1f23IdqWB0VRWxkyjbio7Ly05CdSA3bZ0r6yPFjaJo3bA13rYuApR5gfkkdfgIfXZDQNiNYEe9Jt+Uh5wQGWFvGFelbb6GS1zY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761354671; c=relaxed/simple;
	bh=vkFLnchn18y3PGU0HuO7wDzePkXF+DMlKXXu3yVYCSI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=QJFRoOFYHynwKOZLaq+LNRfL2bdGCTqPce/4iMnnXy7CGt+EU1ZQd39EFCaSt0Q5tQJ50KpZZBdLx6uLj4IxhEju5n90ITxEn0SPM4hPjnN4i0pZi80l+s84AepSInVkY/hET01GYP1+0597VraLTs0i1FyJMnh1ULYk6MbhmMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XvvzzYLG; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XvvzzYLG"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-79a7d439efbso21749736d6.0
        for <linux-cifs@vger.kernel.org>; Fri, 24 Oct 2025 18:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761354668; x=1761959468; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=pXXynZiVA7ILhETj4SRlC+eTmkqrxVS2pruELk/St0s=;
        b=XvvzzYLGggzo7N7xoLshem6CY5pxDAGyc+sWuMysZ3Z5IhEuzUnL0dCcZqlZyzdtix
         e5Po7GbTujP3+7gJp8VFb+Y1UaUU4JWu8cbJpQfoOqseb8XvMG2AeTs6yaBbqJp1Crfh
         CcUNXrzgb2zRIGFdSfZjUvqM9J1M6DSl0IFbHyV6Os42JBP81eUXGG3muiHpSUyaz1qr
         pjmj+iLRhg6v5ErjeBpY8b9Urdh8rt+avY2GQbBTsqASN+SgB6q4YI9ippm3BxQyqc01
         UIhnv69dQ9h5lQuMQEs6HKeEMFLGgIy74IoshUM9fS7WHNX4lm2aetTGxKsgDB5tyfob
         h3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761354668; x=1761959468;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pXXynZiVA7ILhETj4SRlC+eTmkqrxVS2pruELk/St0s=;
        b=mMcTqCbR52cHcUQJcoQ2nvYT+Q6cXYjR0a0lj65pqsH8slKrtlRRhafmEqmdKQAQE+
         nzHui06TA9DKZSMOycQT6e7DDCpFl/6JuYRqSHfL5ih7MGmpqMgyQYfCcahKe68VQFDS
         YqxfBJn2jl17umrK7b5C6hCgtLOoFxBGXFbyeVKKvVIFPggJl53UKP2pC35kJmOwNR6L
         zfNKewwd2nim/46KhHxbi59qeV6vnIbcrlXto45rqXEH1b8zTTzKQapg9UBffHOeNR98
         Jutfv16P26I2fTIl+GHav6VoWED4PQGaj1n5mCakfRqDCAq36Y83vtva5kfwrYpaUTnd
         bPZw==
X-Forwarded-Encrypted: i=1; AJvYcCU8MMjXcv/v57w0Zqu0zD98iJ9RbkCRrc6IehTgNldG7VbMM+JfVGThe6bBKIJ443k1b6Ii+pntolYj@vger.kernel.org
X-Gm-Message-State: AOJu0Ywg/H9d+2vmDRF+J6RvemSa75+r3mL6U1uUD24auVG0CGZE++UZ
	2U0vXIzLPFAFY+A463um1zqcwdobhRJrWOUF7LKEa3rX666XWfH0lEQksUgQ5a4tDdJNYLrpMCt
	x8sEwtHRzn5KwJdu46bnRTrP/SVbKM4U=
X-Gm-Gg: ASbGnctr2tHLHk2vCSw0xECRwEWhj0Ae+9gJWFDkzIRqlrmmFoXWn9R4HKunMAQL669
	vaJUm2jz6r2jtGEehH1dmwqfmjYt5BW64SNj3h8YwyD8GXkPT8G2ohjzPXYwfmQl8fgW+MEgY+O
	7wa5z0c6TxXIqvdPfUYo3IbUsYmoupdBG/rEcCfzMgjjWOWDeBrdO1fpV15Kh8puJOPa7KCHhGB
	M7NqITVw4wcWZ4K21LrL00C/Tie8L06x+3uCPA8wg/n+rQoA/hwYjJQpZ1Jy1EZJqVFxc7H5iO7
	W6DXshRx5Fkg1z5DfRRa7Vf7inm4XB6F9A5nTD1Jy4ESeReB3aAe4kDJGwFZaNahY+wml867MFd
	DZFPkhDbLHhin+9zX69MjJn63Lm1TxZgFN6sjhJxQCfBr8rdIXsjwafQVq6UWHaoHDNIJO6nlds
	1wT2OBOSfCWA==
X-Google-Smtp-Source: AGHT+IGLC1riZEI7Reuuli+Gtx1S04wkLThtwoO6dLMPrCiDVZkSRZIZ/K4miOs8BpZc7XQeGiqvbgyG8/WTrQJ0SBI=
X-Received: by 2002:ad4:5ca3:0:b0:87d:f3a9:26c7 with SMTP id
 6a1803df08f44-87f9eda1c30mr108192226d6.17.1761354668558; Fri, 24 Oct 2025
 18:11:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 24 Oct 2025 20:10:57 -0500
X-Gm-Features: AWmQ_bnObCO69NTARUO5wmRbMghuLsHgMFyJ2N1PvDKSWdSvX_SolGwmjveF0jU
Message-ID: <CAH2r5muFRm0X_uYTFySHj-T7YZQhXZWVa4WzKny_YmEzXOhCBw@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Namjae Jeon <linkinjeon@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
211ddde0823f1442e4ad052a2f30f050145ccada:

  Linux 6.18-rc2 (2025-10-19 15:19:16 -1000)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.18-rc2-smb-server-fixes

for you to fetch changes up to dd6940f5c7dbee7ae70708f4c8967c3c8cb1d965:

  smb: server: let free_transport() wait for
SMBDIRECT_SOCKET_DISCONNECTED (2025-10-23 20:58:51 -0500)

----------------------------------------------------------------
Seven ksmbd server smbdirect (RDMA) fixes in order avoid potential
submission queue overflows
- free transport teardown fix
- six credit related fixes (five server related, one client related)
----------------------------------------------------------------
Stefan Metzmacher (7):
      smb: server: allocate enough space for RW WRs and ib_drain_qp()
      smb: smbdirect: introduce smbdirect_socket.send_io.lcredits.*
      smb: server: smb_direct_disconnect_rdma_connection() already
wakes all waiters on error
      smb: server: simplify sibling_list handling in
smb_direct_flush_send_list/send_done
      smb: server: make use of smbdirect_socket.send_io.lcredits.*
      smb: client: make use of smbdirect_socket.send_io.lcredits.*
      smb: server: let free_transport() wait for SMBDIRECT_SOCKET_DISCONNECTED

 fs/smb/client/smbdirect.c                  |  67 +++--
 fs/smb/common/smbdirect/smbdirect_socket.h |  13 +-
 fs/smb/server/transport_rdma.c             | 344 +++++++++++++++---------
 3 files changed, 273 insertions(+), 151 deletions(-)

-- 
Thanks,

Steve
