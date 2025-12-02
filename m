Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6A8156C6A
	for <linux-cifs@vger.kernel.org>; Tue,  2 Dec 2025 01:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764637600; cv=none; b=IlJ+hrtBiAjwxLLfbrvm/PFQmMPgzQNfMLkT4pzeblIJbYPqXx4wdssLLMyefvH+p+DORWST+95Qhz02U7M2dFjO3O5W47z6vEOIAaPeGAmQlbo68TGBmc0s/LOCVpQUAGhjOrX+pQ0valEbz0c6lOHYzh00vI4mEGZj9QZft5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764637600; c=relaxed/simple;
	bh=cXbPLnfNOe6ZUhjM1/4mXpS0ZBnknia0Sn9ksr5ckQA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=piAiNBIwnftM7/MfL36YkHaBAD89KZlVpHL0R/YRwJVrRX4MvBUnOsK8EDOkAWwjnNu6LHDb4qDDAg7z05s7qUcB3GN1XzeqGec5YbIhQcK5XK0G99291HtUJ8Gkrdgt54NT2otRYpueq2ztiq6xg09iaxYEdffuemEVYFbE8AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=esA0BHNn; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="esA0BHNn"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-882475d8851so50828226d6.2
        for <linux-cifs@vger.kernel.org>; Mon, 01 Dec 2025 17:06:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764637597; x=1765242397; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PCK1w2skKoeS9Ig4LRwEj+8rZXEbKiqDILXbcH2UKRY=;
        b=esA0BHNnVFMAnJjv+a/bmEwjM+cm7SmmEKuRDN57LHL/Fi1hkryQiZ5IQ+YOaqigKj
         NoE5AR1t/Jzsm8VdiVbcOaASTazIaptp/1qXrRMnoTaCYPwvzM3MWSlhMgfaSofeW6h2
         zy7fg10bw5Dc3eDbHcAhBKIUnXCZNQcR7/6BEkin9u0obHt3jwZ3lc7HsdeiEETqB4lf
         KBSUvyt8ion83boeJ/Y/a3/47l6Oe7oMMB//gF0YXoLcvO+TO1cosG1Wh/CxQAskBI58
         pllR7XYHa8wm9YlXM0nNo6ts91XbsMHvEOlhLhWoP1Er9TV9gA1Kch+qeK27/oIxUtnu
         tYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764637597; x=1765242397;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PCK1w2skKoeS9Ig4LRwEj+8rZXEbKiqDILXbcH2UKRY=;
        b=VMqLEFqJfV5rCy/ijq0DkqUfBZD5eBwVryWQQqoBmvGjpJgGrr4Hfx8XA8EMk8qzMg
         mgKTTnqHVES7NWd0DN0gGqYTMA4u0yYEZZFd4cAh6TqscP2LdMPBwyTdbiPseo8Pgrlv
         FX9g12t5lYI8SHEH8T9vgemVISeVeXBrKQTRgdS0f9af6NLWoV70rbqL+TqgVTekA/3F
         OackSl8jJwGdNzQhQU5fGeUmmNb4yjy1zvu7OzT4K1408M3llWQc56HmVAxs65cJGlzP
         hkEwzXfO/3lz2uJt586Lz9wRJW8+k90zKprQkAzl0X1ZnVzDmn91zjOZ/k6LIQruiAe6
         km0A==
X-Forwarded-Encrypted: i=1; AJvYcCXoBK4jgu1wuw4wr8blDLRu/lhSjlkeD6Y8XUxhIavUyhoC6iAIZ9DXkCeSFzaovhlyO7SDZVGDb6hj@vger.kernel.org
X-Gm-Message-State: AOJu0YygYPduyDYPUguVmycAzufD+GS6yhFz24Ha8k8Iofvi3T+FhGMN
	mqEmq+qLC9bKJd0znaTqVtsXnEfROalf0roRcGPx44e6UUJYTbA2tVoqOaBDrgDIfya8QH6fgyv
	sC9m5Tyj1qwtwTQgJ2Bn/n81iOkw5Qu450rpt6Rg=
X-Gm-Gg: ASbGncs4LG1a/YDDHQ1hT1JDqWs0vDI9PmZNRpf7DGW+LqsgYhc+iJw4tREwK86qj/X
	ans7E7N281ElfYB5GUwGlFFAhMf3U3bMEQjmBdzCaRjsigszT2zMTlpRJI67LxEDBYaQsEX43X7
	5tHovvf2hZpTLMa+LYUrppMpad1WExPuFzSvwFg9Z1Ns0zVnVGYuKsFVR54imNcZW3Pa46wIoiF
	9xg+/RnGegDm8PJTOcV8iEbbM15x4mSmk5oO6tNZuGqCXWslaIW7Yb0yRJOub9AEi4DBBUvrcUH
	AMuMqebKch6FfpWepz7G+UNqhS1MTOw48Zq51CEtcfxkB9bZ8+tJacyrW6ShrtvzMX+25/bzLcc
	pV/2oSTzv5s/Nd3r11SDyr4F2GY/Xf3Imxdz35hhSoWrfvJqTSwq19S8qgI38A+WmigtlcPeCgW
	TLTgBoUbvUgcZfZZwyjV24
X-Google-Smtp-Source: AGHT+IGfCWNw+BT9Y/XouwAkjh4QMitXriOL33ZyHuEjGkok69KV1EyDwwr+u4Otq2Z3Rf1oKR9Z3gPtT0/aR+VSrGE=
X-Received: by 2002:a05:6214:2605:b0:882:3aad:e5ee with SMTP id
 6a1803df08f44-8847c511348mr794146346d6.40.1764637597218; Mon, 01 Dec 2025
 17:06:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 1 Dec 2025 19:06:25 -0600
X-Gm-Features: AWmQ_bkV-tAOXj8gh97ZoRoNs2HUxB0NPUVc2cagYr2YmnBNgKag9dUsWVExrPc
Message-ID: <CAH2r5mtHWXNvtYB0mTUci0qa-b0dmOjUMr7sARERV9SyFpTAVA@mail.gmail.com>
Subject: [GIT PULL] smb client and server fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>, 
	Namjae Jeon <linkinjeon@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
7d0a66e4bb9081d75c82ec4957c50034cb0ea449:

  Linux 6.18 (2025-11-30 14:42:10 -0800)

are available in the Git repository at:

  git://git.samba.org/ksmbd.git tags/v6.19-rc-smb-fixes

for you to fetch changes up to e1469f56089fc00bc94706a07c5cd63fa3e8625b:

  cifs: Use netfs_alloc/free_folioq_buffer() (2025-11-30 21:11:46 -0600)

----------------------------------------------------------------
Forty four smb client and server changesets
1) server fixes:
     - IPC use after free locking fix
     - fix locking bug in delete paths
     - fix use after free in disconnect
     - fix underflow in locking check
     - error mapping improvement
     - socket listening improvement
     - five return code mapping fixes
     - three crypto improvements (to use default libraries)
2) cleanup patches:
     - netfs
     - client checkpatch cleanup
     - server cleanup
     - 20 patches to move server/client duplicate code to common
     - fix some defines to better match protocol specification
3) four smbdirect (RDMA) fixes
4) two client debugging improvements (for leases)
----------------------------------------------------------------
Aaditya Kansal (1):
      ksmbd: implement error handling for STATUS_INFO_LENGTH_MISMATCH
in smb server

Bharath SM (2):
      smb: client: show smb lease key in open_files output
      smb: client: show smb lease key in open_dirs output

ChenXiaoSong (19):
      smb/server: fix return value of smb2_read()
      smb/server: fix return value of smb2_notify()
      smb/server: fix return value of smb2_query_dir()
      smb/server: fix return value of smb2_ioctl()
      smb/server: fix return value of smb2_oplock_break()
      smb/server: update some misguided comment of smb2_0_server_cmds proc
      smb/client: fix CAP_BULK_TRANSFER value
      smb: move MAX_CIFS_SMALL_BUFFER_SIZE to common/smbglob.h
      smb: move create_durable_req_v2 to common/smb2pdu.h
      smb: move create_durable_handle_reconnect_v2 to common/smb2pdu.h
      smb: move create_durable_rsp_v2 to common/smb2pdu.h
      smb: move SMB_NEGOTIATE_REQ to common/smb2pdu.h
      smb: move list of FileSystemAttributes to common/fscc.h
      smb: move some duplicate struct definitions to common/fscc.h
      smb: move FILE_SYSTEM_SIZE_INFO to common/fscc.h
      smb: do some cleanups
      smb: fix some warnings reported by scripts/checkpatch.pl
      smb: move create_durable_reconn to common/smb2pdu.h
      smb: move FILE_SYSTEM_ATTRIBUTE_INFO to common/fscc.h

David Howells (1):
      cifs: Use netfs_alloc/free_folioq_buffer()

Eric Biggers (3):
      ksmbd: Use SHA-512 library for SMB3.1.1 preauth hash
      ksmbd: Use HMAC-SHA256 library for message signing and key generation
      ksmbd: Use HMAC-MD5 library for NTLMv2

Namjae Jeon (1):
      ksmbd: fix use-after-free in ksmbd_tree_connect_put under concurrency

Qianchang Zhao (3):
      ksmbd: skip lock-range check on equal size to avoid size==0 underflow
      ksmbd: vfs: fix race on m_flags in vfs_cache
      ksmbd: ipc: fix use-after-free in ipc_msg_send_request

Qingfang Deng (1):
      ksmbd: server: avoid busy polling in accept loop

Stefan Metzmacher (4):
      smb: smbdirect: introduce SMBDIRECT_DEBUG_ERR_PTR() helper
      smb: smbdirect: introduce SMBDIRECT_CHECK_STATUS_{WARN,DISCONNECT}()
      smb: server: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
recv_done() and smb_direct_cm_handler()
      smb: client: relax WARN_ON_ONCE(SMBDIRECT_SOCKET_*) checks in
recv_done() and smbd_conn_upcall()

Thorsten Blum (1):
      ksmbd: Replace strcpy + strcat to improve convert_to_nt_pathname

ZhangGuoDong (8):
      smb: rename common/cifsglob.h to common/smbglob.h
      smb: move smb_version_values to common/smbglob.h
      smb: move get_rfc1002_len() to common/smbglob.h
      smb: move SMB1_PROTO_NUMBER to common/smbglob.h
      smb: move smb_sockaddr_in and smb_sockaddr_in6 to common/smb2pdu.h
      smb: move copychunk definitions to common/smb2pdu.h
      smb: move resume_key_ioctl_rsp to common/smb2pdu.h
      smb: move some duplicate definitions to common/smb2pdu.h

 fs/smb/client/cifs_debug.c                 |  23 +-
 fs/smb/client/cifsglob.h                   |  31 +-
 fs/smb/client/cifspdu.h                    | 601 ++++++++---------------------
 fs/smb/client/cifssmb.c                    |  18 +-
 fs/smb/client/cifstransport.c              |   8 +-
 fs/smb/client/connect.c                    |   6 +-
 fs/smb/client/inode.c                      |   4 +-
 fs/smb/client/misc.c                       |   2 +-
 fs/smb/client/ntlmssp.h                    |   8 +-
 fs/smb/client/readdir.c                    |  12 +-
 fs/smb/client/reparse.h                    |   8 +-
 fs/smb/client/rfc1002pdu.h                 |   8 +-
 fs/smb/client/smb1ops.c                    |   2 +-
 fs/smb/client/smb2inode.c                  |   2 +-
 fs/smb/client/smb2ops.c                    |  91 +----
 fs/smb/client/smb2pdu.c                    |  45 ++-
 fs/smb/client/smb2pdu.h                    | 112 ------
 fs/smb/client/smbdirect.c                  |  28 +-
 fs/smb/common/cifsglob.h                   |  30 --
 fs/smb/common/fscc.h                       | 174 +++++++++
 fs/smb/common/smb2pdu.h                    | 279 ++++++++++++-
 fs/smb/common/smbacl.h                     |   8 +-
 fs/smb/common/smbdirect/smbdirect_socket.h |  51 +++
 fs/smb/common/smbglob.h                    |  72 ++++
 fs/smb/server/Kconfig                      |   6 +-
 fs/smb/server/auth.c                       | 390 ++++---------------
 fs/smb/server/auth.h                       |  10 +-
 fs/smb/server/crypto_ctx.c                 |  24 --
 fs/smb/server/crypto_ctx.h                 |  15 +-
 fs/smb/server/mgmt/tree_connect.c          |  18 +-
 fs/smb/server/mgmt/tree_connect.h          |   1 -
 fs/smb/server/misc.c                       |  15 +-
 fs/smb/server/oplock.c                     |   8 +-
 fs/smb/server/server.c                     |   4 -
 fs/smb/server/smb2misc.c                   |   2 +-
 fs/smb/server/smb2ops.c                    |  38 +-
 fs/smb/server/smb2pdu.c                    | 217 +++++------
 fs/smb/server/smb2pdu.h                    | 107 -----
 fs/smb/server/smb_common.h                 | 276 +------------
 fs/smb/server/transport_ipc.c              |   7 +-
 fs/smb/server/transport_rdma.c             |  40 +-
 fs/smb/server/transport_tcp.c              |  41 +-
 fs/smb/server/vfs.c                        |   7 +-
 fs/smb/server/vfs_cache.c                  |  88 +++--
 44 files changed, 1194 insertions(+), 1743 deletions(-)
 delete mode 100644 fs/smb/common/cifsglob.h
 create mode 100644 fs/smb/common/fscc.h
 create mode 100644 fs/smb/common/smbglob.h

-- 
Thanks,

Steve
