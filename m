Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E1FEEBB
	for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776984637; cv=pass; b=ZlMBOXyIuVC5zZz5+G66mATQcNkOtMGBugeq/cUHtWHpeFFAxP9WfuPbwqgR2g1bCpyf2n3OaK4/SEAybx8nzBH62qYUZRDLrFBDPVp9QOOO0t7cQqN+pTCvo5zMDHkVhbbdO4oGHcHdT+FREiJ3bzgonNdY44WWa1u0qyr/0rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776984637; c=relaxed/simple;
	bh=0Q9OSQ5wyZ6xriaK7qqqZoWVrbSZ7wZKLqeszxOoLvU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jMKhyH+P13phpM3a92wqi+2WXqZpnEC6wymLVfwZ4nvyj2O2pPJuQGDwfm/b76yZcNx9xd9ny+p+kgRAAuBI2eWj3UE7LIISWKaxyME7gm82RDsC5DfXLmx5pylsEulGUafFFjGsAOzCp4sMbkcFg5mNaLe73/sgLkVXmfzcwNw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EaWoUhee; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EaWoUhee"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8aca6bd57cfso68295856d6.0
        for <linux-cifs@vger.kernel.org>; Thu, 23 Apr 2026 15:50:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776984634; cv=none;
        d=google.com; s=arc-20240605;
        b=Q9O7eB2Y2mxMQdOhGMrU22//lvT5m7yKZAFdgl0vkInko8agShbFUo8OWdJJne6R15
         I82soEYvsTy2wew5wgO3SKbuQUaeX/C0DRXA7HT3V+2ywYPVhLWS7vnOx8Js3ncQ66c4
         dHNWvtClDYOXtRYbLqhUJrYIL2qjBIHEAPNsfXgthvtvnpYAjwb1i3dgIv3Z+FVudKJH
         /HS6ZcK9qOaPGkGB5U8BkhMT6uzXtp2YNhhq4fYJBS04TvG/EoubDzn1/2WdT49P5NLH
         3pS6L4omuuSnLgJY7LbbrJbZSSmAs1Y3WmdeA/PBboEg1Dy/pu8YGI3hrYYpAfSj27k0
         7yrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=crYEejDGWcEK6uKfAbPhkL2PUkstrJ+iYZaIJ0+0+kw=;
        fh=flUB7rGzqVKCWl9O48f630z8Bi1dTZoteVHMR6bDLRg=;
        b=eDlQ1FtmaRqvBqszjzSJ7ZrPTD7xoN5XL0/RRNhK89V8QZI1PTwbRJ8kPKXH6c2QZR
         BDla0lpCzbSpLLPTgzHcFC8aMekPRBJeh+RtXOEWt2f3f47ueXlxQwvdBHG/nTsJMk+F
         /6DdIddeg7HyL/sC0K22GRyYJ+4b6tirCuZzKPU27yHHJ6eFMxVEoyYgscwmXshL3hZi
         RIoOqdeL48Kv4i5V7U215N1ynw2Y0yytPKoyPjAt1nn4gcaqoQk/nObjSPeRHNwyORQL
         zPqrzO6WwW2CqOmC7RJXqk3JuIgqOMVk7L6xcKkQNV/z2c126WhVlBg2OKoL4h7TT3+0
         zuzw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776984634; x=1777589434; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=crYEejDGWcEK6uKfAbPhkL2PUkstrJ+iYZaIJ0+0+kw=;
        b=EaWoUheeNxPMYbpdeUM7xG2W3CHMYukG/hD3WzZdHEL96DyE3oUcFIWfbiI3FZGWD7
         Zm/UVjmk9k+XNzddEKYXmD/qhOaNK4CXWz874PsWLdskKpnIovwD4+UZpWfodU8AZOVl
         G3QlCm4nk3kaaNs+wKyIFi0EH+GSEoSeZyft1dyIvBvdiFpKchX9pt5MF4KimVd8xhRj
         Yj8K0y0qd+LD3DaMCYWlTVbgs+DC5cNARpM/BwWV3xjf674IBn9Qj2yk9CpIo5UMJvzE
         dOyGQjnXRXuiTfVUZucHpFohjginbQ5tnToy65gUzFa8NvxNhXkXtaS6Zq/ArlZWAhm+
         CEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776984634; x=1777589434;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=crYEejDGWcEK6uKfAbPhkL2PUkstrJ+iYZaIJ0+0+kw=;
        b=QlB8uVNoNwmUUHwOAtFn8M0KWYZPovwW0SF4ZO/52pcsMJ9EQNKVllBMNj/V+oGr/H
         COro3yVifJDyHO0aJSIK5WuylDrplVtNDVIKHQGTKzdduv88aNiIa5luMqs/NFGYui+d
         TraBxrG1P2PPCCtHHqRPOl5L8mhzX1lHQacMDG2U49VVjgxbbwJai2vjd2dsAk1ttFyT
         n+hNnbet2TrE6jXiS6sxpTFRzpfG+GFNeDlMLk8woV+iUQxiCxOCrM/xdO3udIlNvYrJ
         KOofmfHVdfTrZHJmtkki492p3Dr2vgLj9OPqtqh/mszArDHArbTOLrucR6tBgKKBn6pc
         mlNA==
X-Forwarded-Encrypted: i=1; AFNElJ92pWgMcbkM6nGttmJ3fPDbYzGgvVqm5a3c+bpPqg6qooLteSYDM39boJ0iCJi7grj/l/sTsXawTlmu@vger.kernel.org
X-Gm-Message-State: AOJu0YwplaBEb4nXwqzXWTF3TtUiF3oiBUIlp378a2Oyz5QOPpCh6gSr
	gaCRKPOBcSXxS6hErwRfKa8wHIaXYJF1IpFdCxTZA7NPxqb5w/U2R03G/f3tKGZWccwRd4ze1b8
	iVnAR2pMBnvx5l6R/uoKvJjgcVvN60RE=
X-Gm-Gg: AeBDievDn2X+JtN7xmjwTFzHmQNlW8ldpYRf7P7LXyysaBg9HP4skUqj2oheJrud0JC
	l1vlEx838Z3oqo+hxPZhidm0IvKQjQ+rCCc8ZyCHeA69rOCiuYtXd4ljrARDCVd6m+GHpJxhToK
	eHMY2Wyn+bq0o89n5Tgafiwwp2WNiyxkfb7e/W9TRzcv4lavkEk83GDSdaTvakcMQt2vHmCtUUR
	aV4Iq/7VSmb3F34OdwtRPHv/phHreHXj8bbrAITNLIe9fu0PmLOHv3S4MTThtKt252hEvaYKxJf
	YMMuVsG1g5g454GL92tasYY12jub4thdnxDzwsmf+qtL2/M9DXHLNwZnRWUQHNBtIGdovQ6UmvE
	keOFstebhVb4MJHgnUJ4yCplZv1A5P5VY5UQrIoySB878cbtSRB052IbXHRwEejjT00cCSFngzt
	fBZCCuqiG1jhdTKYi7eEV58xraUY0+D51AyRux2HhaBYI=
X-Received: by 2002:a05:6214:3913:b0:8ad:bccd:94cf with SMTP id
 6a1803df08f44-8b0280733ebmr442816736d6.18.1776984633860; Thu, 23 Apr 2026
 15:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Thu, 23 Apr 2026 17:50:21 -0500
X-Gm-Features: AQROBzCxmBiBpdWs0AqTR5HhCwCUVrssy1DupayVpoI2GBY9BC9WVaAtIecNEWY
Message-ID: <CAH2r5mspnU4XxcU9Vr98PeY1iMVag9QpxdB72GO5t4EExbKkRQ@mail.gmail.com>
Subject: [GIT PULL] ksmbd server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
0b2f2b1fc0c61e602a6babf580b91f895b0ea80a:

  Merge tag 'v7.1-rc1-part2-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2026-04-16 19:14:55 -0700)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v7.1-rc-part2-ksmbd-fixes

for you to fetch changes up to 1249c01aa42160e40bc765ba5a3cde751491ff0a:

  smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/
(2026-04-22 19:00:41 -0500)

----------------------------------------------------------------
18 ksmbd server fixes
- move fs/smb/common/smbdirect to fs/smb/smbdirect
- change signature calc to use AES-CMAC library, simpler and faster
- invalid signature fix
- multichannel fix
- open create options fix
- fix durable handle leak
- cap maximum lock count to avoid potential denial of service
- four connection fixes: connection free and session destroy IDA
fixes, refcount fix, connection leak fix, max_connections off by one
fix
- IPC validation fix
- fix out of bounds write in getting xattrs
- fix use after free in durable handle reconnect
- three ACL fixes: fix potential ACL overflow, harden num_aces check,
and fix minimum ACE size check

----------------------------------------------------------------
Akif (1):
      ksmbd: fix use-after-free in smb2_open during durable reconnect

Akif Sait (1):
      ksmbd: fix O(N^2) DoS in smb2_lock via unbounded LockCount

DaeMyung Kang (6):
      smb: server: fix max_connections off-by-one in tcp accept path
      ksmbd: reset rcount per connection in ksmbd_conn_wait_idle_sess_id()
      ksmbd: destroy tree_conn_ida in ksmbd_session_destroy()
      ksmbd: destroy async_ida in ksmbd_conn_free()
      ksmbd: fix durable fd leak on ClientGUID mismatch in durable v2 open
      ksmbd: fix CreateOptions sanitization clobbering the whole field

Eric Biggers (1):
      ksmbd: Use AES-CMAC library for SMB3 signature calculation

Hyunwoo Kim (1):
      ksmbd: scope conn->binding slowpath to bound sessions only

Marios Makassikis (1):
      smb: server: stop sending fake security descriptors

Michael Bommarito (4):
      smb: server: fix active_num_conn leak on transport allocation failure
      ksmbd: validate response sizes in ipc_validate_msg()
      ksmbd: require minimum ACE size in smb_check_perm_dacl()
      ksmbd: validate num_aces and harden ACE walk in smb_inherit_dacl()

Stefan Metzmacher (1):
      smb: smbdirect: move fs/smb/common/smbdirect/ to fs/smb/smbdirect/

Tristan Madani (2):
      ksmbd: use check_add_overflow() to prevent u16 DACL size overflow
      ksmbd: fix out-of-bounds write in smb2_get_ea() EA alignment

 MAINTAINERS                                        |  2 +-
 fs/smb/Kconfig                                     |  2 +-
 fs/smb/Makefile                                    |  1 +
 fs/smb/client/Kconfig                              |  2 +-
 fs/smb/client/smbdirect.c                          |  2 +-
 fs/smb/client/smbdirect.h                          |  2 +-
 fs/smb/common/Makefile                             |  1 -
 fs/smb/common/smbdirect/Makefile                   | 18 -------
 fs/smb/server/Kconfig                              |  4 +-
 fs/smb/server/auth.c                               | 51 +++++-------------
 fs/smb/server/auth.h                               |  4 +-
 fs/smb/server/connection.c                         | 14 +++--
 fs/smb/server/crypto_ctx.c                         | 58 --------------------
 fs/smb/server/crypto_ctx.h                         | 12 -----
 fs/smb/server/mgmt/user_config.c                   |  6 ---
 fs/smb/server/mgmt/user_session.c                  | 12 +++--
 fs/smb/server/server.c                             |  1 -
 fs/smb/server/smb2pdu.c                            | 53 ++++++++-----------
 fs/smb/server/smbacl.c                             | 61 +++++++++++++++++-----
 fs/smb/server/transport_ipc.c                      | 16 ++++--
 fs/smb/server/transport_rdma.c                     |  2 +-
 fs/smb/server/transport_rdma.h                     |  2 +-
 fs/smb/server/transport_tcp.c                      |  4 +-
 fs/smb/{common => }/smbdirect/Kconfig              |  2 +-
 fs/smb/smbdirect/Makefile                          | 18 +++++++
 .../smbdirect_accept.c => smbdirect/accept.c}      |  4 +-
 .../smbdirect_connect.c => smbdirect/connect.c}    |  4 +-
 .../connection.c}                                  |  2 +-
 .../smbdirect_debug.c => smbdirect/debug.c}        |  2 +-
 .../smbdirect_devices.c => smbdirect/devices.c}    |  2 +-
 .../smbdirect_internal.h => smbdirect/internal.h}  |  6 +--
 .../smbdirect_listen.c => smbdirect/listen.c}      |  2 +-
 .../smbdirect_main.c => smbdirect/main.c}          |  2 +-
 .../smbdirect/smbdirect_mr.c => smbdirect/mr.c}    |  2 +-
 .../smbdirect/smbdirect_pdu.h => smbdirect/pdu.h}  |  0
 .../smbdirect_public.h => smbdirect/public.h}      |  0
 .../smbdirect/smbdirect_rw.c => smbdirect/rw.c}    |  2 +-
 fs/smb/{common => }/smbdirect/smbdirect.h          |  0
 .../smbdirect_socket.c => smbdirect/socket.c}      |  2 +-
 .../smbdirect_socket.h => smbdirect/socket.h}      |  0
 40 files changed, 165 insertions(+), 215 deletions(-)
 delete mode 100644 fs/smb/common/smbdirect/Makefile
 rename fs/smb/{common => }/smbdirect/Kconfig (86%)
 create mode 100644 fs/smb/smbdirect/Makefile
 rename fs/smb/{common/smbdirect/smbdirect_accept.c => smbdirect/accept.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_connect.c =>
smbdirect/connect.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_connection.c =>
smbdirect/connection.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_debug.c => smbdirect/debug.c} (98%)
 rename fs/smb/{common/smbdirect/smbdirect_devices.c =>
smbdirect/devices.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_internal.h =>
smbdirect/internal.h} (98%)
 rename fs/smb/{common/smbdirect/smbdirect_listen.c => smbdirect/listen.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_main.c => smbdirect/main.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_mr.c => smbdirect/mr.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_pdu.h => smbdirect/pdu.h} (100%)
 rename fs/smb/{common/smbdirect/smbdirect_public.h =>
smbdirect/public.h} (100%)
 rename fs/smb/{common/smbdirect/smbdirect_rw.c => smbdirect/rw.c} (99%)
 rename fs/smb/{common => }/smbdirect/smbdirect.h (100%)
 rename fs/smb/{common/smbdirect/smbdirect_socket.c => smbdirect/socket.c} (99%)
 rename fs/smb/{common/smbdirect/smbdirect_socket.h =>
smbdirect/socket.h} (100%)

-- 
Thanks,

Steve
