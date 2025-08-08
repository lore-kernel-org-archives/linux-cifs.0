Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BEFD19DF9A;
	Fri,  8 Aug 2025 21:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754688132; cv=none; b=FpaBJmvo5sBWWKiK34btYiKEoPqOrHnWb+IR+W4bZ29KBf/IClzsf3DkTTgPYrPKn6LUHQRGRAnGuj9TJZ5V+pdXdVurSZ5NYGX+9y72Y741xqUmRha72C/VoNLCgh631Qhhcj0U2TxX89n249SNPAxyWc8sMTvG4FPes5A5IOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754688132; c=relaxed/simple;
	bh=bLJhCgnltVB7EE4FmIRKXg3wsdMKApA9ExHW3A1d7WI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=IbwfGGA+YUxoIv7kYkDDOQxoVIALgb/zHVljKjgF2h4AtHOvOcqq3KVDEHKP/4uvkOaeZNgUuIoOxRW3D9OQzYCtqNh3GZKzwSltYHdK4eH3hCNzXM8KaSrOsZZRZ/FsXXl9rXFAYWU+GJJV1y+zqmv86X6ghDnnmUNPkiiqA0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bcBwV2jw; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bcBwV2jw"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4b070e57254so28131111cf.3;
        Fri, 08 Aug 2025 14:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754688129; x=1755292929; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7ORL7KqSf3Snq5ilYE9ydZ56m+WfiWfk8qGevFR6BwM=;
        b=bcBwV2jwuaWplAftPDXmEGL9M+iiAdF1oW+FmiSE9po7PBw+BB0qkNRLehMpfKEjyf
         64rrjDzzatPYUZk8YC7j2doYMK1duMFbknLNpx1nqekV5a1MCaFRCrCZ6hzE28iXI+NN
         9+eCChI9xuAY79iKiFFSIkkKngrOTQG9dbjwX2e3VaKDFeEmsM2Mj7X8BOsg4XN4qIxw
         wtvG7GsmoiWVbvLSGO43AfDo4ewadTsY7wanbUmriTD+K0NerXsC2fWYh7cfyTa2eCLd
         uGgT4c3DjmWc3p6X254pzRyz8DkA//HhBiXP2+G2UGi5/IyqF25nS9TfF4DaOqyB5f9a
         WCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754688129; x=1755292929;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7ORL7KqSf3Snq5ilYE9ydZ56m+WfiWfk8qGevFR6BwM=;
        b=NIkd7mo9EEOA1APLPtlMqsmg5BXoWcAzQ6rMAW3c8/DFMtAJdephcKme5kxO/Db5uJ
         ia28Suo180L/Fnn2NKgjUWYT+EUABiplQJ3WKMBvJJYHoLsJcvEWhz21MpVSbnE1FTm7
         wFbsDOmEwUImKI31u2pRNNSpRVHK1uazmthxcyvM+0MiE1mnYrY5rdp5+pXWDJLWf8dN
         8OtbSNtjzLX7IVn5ZtvgmfTYQDIGXWlmh8ZyYwrgcXfiRGrYof6MeDZ5NDCah4tDOC0b
         rXvS1tw9U6QGAbc8blQJX1LV3zpGETYiF4wN6iFk8h2hhbvAOgfda44idXJ2dwFyvb0E
         H7cA==
X-Forwarded-Encrypted: i=1; AJvYcCU0YsULl+WHmcD/EdTbIcxT0KUiEU9QxCuezWEAh+W8VVIIu4X71MitchN1SdikG7VGsXtpgsJkSi6O@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3vlphTIi6JD4P1O5bCNcsxxI4iwzEn82Z0bxzUkQNa1FJumye
	Hsws20UQzI2R4LRrAZ9MOFT0YMKBAn4f2szHtsF/iU2qLf08IAomDYIkrAANOAme9EK5lvP5M3z
	E+9T2JeiAzGTQV5YsAEI8YyD33SNnD2iOebuB
X-Gm-Gg: ASbGncuDc37aVWo0UPQCE+vpUjrxoPdoPd/J6W5zffIWa/65GMJb/VYoJrya14W3EN7
	uFfCxua5REnWaYYU1zkBZhlx8NkQY5oWIA3gbS5xOtEFZ5qtLcoPTUG/tY7cSQaNY0IswXTTGH3
	whMwlT6i1xyuguQbFlU9hOkj67z3txQdapsI2dG8Ay1/eKzRkG30cIxJ/fYG90uj7pFbcj3kxZz
	kDw5LtKfwjWZ9KnyoW9xWCKoasj45xSJi3sx2B6
X-Google-Smtp-Source: AGHT+IGXx6lz7GgPsAz1oQB7YaDnoIO7s26PuCVxcJGGG2ZczK9V5S/QvllyBhHkyI60vwQFiGIxgAQaYbQibQR9Uws=
X-Received: by 2002:ac8:588d:0:b0:4b0:61bf:c2b with SMTP id
 d75a77b69052e-4b0aedfe308mr62314831cf.42.1754688129158; Fri, 08 Aug 2025
 14:22:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Fri, 8 Aug 2025 16:21:57 -0500
X-Gm-Features: Ac12FXw_2JmezpLxO7RxpWZFgcfSZ0bBTYxxgN-09mMMqx4opUQGBT35y5vf3fU
Message-ID: <CAH2r5mtLo02s=t_PUh99CniXe3qLaWBypkxqJO8gj1zqwyUoXA@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
db68e4c80d995b67a92460711038b9223166bda7:

  Merge tag 'v6.17-rc-part1-smb3-client-fixes' of
git://git.samba.org/sfrench/cifs-2.6 (2025-07-31 21:22:04 -0700)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.17rc-part2-SMB3-client-fixes

for you to fetch changes up to dfe6f14aedbf59bfb7145de5c7da908583ae50fd:

  smb: client: only use a single wait_queue to monitor smbdirect
connection status (2025-08-07 12:40:11 -0500)

----------------------------------------------------------------
33 smb3/cifs client changesets, mostly smbdirect cleanup

Eight non-smbdirect fixes
 - Fix null ptr deref caused by delay in global spinlock initialization
 - Two fixes for native symlink creation with SMB3.1.1 POSIX Extensions
 - Fix for socket special file creation with SMB3.1.1 POSIX Exensions
 - Reduce lock contention by splitting out mid_counter_lock
    - move SMB1 transport code to separate file to reduce module size
      when support for legacy servers is disabled
 - Two cleanup patches: rename mid_lock to make it clearer what it protects
   and one to convert mid flags to bool to make clearer

Twenty five smbdirect/RDMA restructuring patches and fixes
 - Fix for error handling in send done
 - Remove unneeded empty packet queue
 - Fix put_receive_buffer error path
 - Two fixes to recv_done error paths
 - Remove unused variable
 - Improve response and recvmsg type handling
 - Fix handling of incoming message type
 - Two cleanup fixes for better handling smbdirect recv io
 - Two cleanup fixes for socket spinlock
 - Two patches that add socket reassembly struct
 - Remove unused connection_status enum
 - Use flag in common header for SMBDIRECT_RECV_IO_MAX_SGE
 - Two cleanup patches to introduce and use smbdirect send io
 - Two cleanup patches to introduce and use smbdirect send_io struct
 - Fix to return error if rdma connect takes longer than 5 seconds
 - Error logging improvements
 - Fix redundand call to init_waitqueue_head
 - Remove unneeded wait queue
----------------------------------------------------------------
Paulo Alcantara (3):
      smb: client: set symlink type as native for POSIX mounts
      smb: client: default to nonativesocket under POSIX mounts
      smb: client: fix creating symlinks under POSIX mounts

Stefan Metzmacher (25):
      smb: client: let send_done() cleanup before calling
smbd_disconnect_rdma_connection()
      smb: client: remove separate empty_packet_queue
      smb: client: make sure we call ib_dma_unmap_single() only if we
called ib_dma_map_single already
      smb: client: let recv_done() cleanup before notifying the callers.
      smb: client: let recv_done() avoid touching data_transfer after
cleanup/move
      smb: client: remove unused smbd_connection->fragment_reassembly_remaining
      smb: smbdirect: introduce smbdirect_socket.recv_io.expected
      smb: client: make use of smbdirect_socket->recv_io.expected
      smb: smbdirect: introduce struct smbdirect_recv_io
      smb: client: make use of struct smbdirect_recv_io
      smb: smbdirect: introduce smbdirect_socket.recv_io.free.{list,lock}
      smb: client: make use of smb: smbdirect_socket.recv_io.free.{list,lock}
      smb: smbdirect: introduce smbdirect_socket.recv_io.reassembly.*
      smb: client: make use of smbdirect_socket.recv_io.reassembly.*
      smb: client: remove unused enum smbd_connection_status
      smb: smbdirect: add SMBDIRECT_RECV_IO_MAX_SGE
      smb: client: make use of SMBDIRECT_RECV_IO_MAX_SGE
      smb: smbdirect: introduce struct smbdirect_send_io
      smb: client: make use of struct smbdirect_send_io
      smb: smbdirect: add smbdirect_socket.{send,recv}_io.mem.{cache,pool}
      smb: client: make use of smbdirect_socket.{send,recv}_io.mem.{cache,pool}
      smb: client: return an error if rdma_connect does not return
within 5 seconds
      smb: client: improve logging in smbd_conn_upcall()
      smb: client: don't call init_waitqueue_head(&info->conn_wait)
twice in _smbd_get_connection
      smb: client: only use a single wait_queue to monitor smbdirect
connection status

Steve French (1):
      cifs: Move the SMB1 transport code out of transport.c

Wang Zhaolong (3):
      smb: client: rename server mid_lock to mid_queue_lock
      smb: client: add mid_counter_lock to protect the mid counter counter
      smb: client: smb: client: eliminate mid_flags field

Yunseong Kim (1):
      cifs: Fix null-ptr-deref by static initializing global lock

 fs/smb/client/Makefile                     |   2 +-
 fs/smb/client/cifs_debug.c                 |  24 +-
 fs/smb/client/cifsfs.c                     |   8 +-
 fs/smb/client/cifsglob.h                   |  23 +-
 fs/smb/client/cifsproto.h                  |  15 +
 fs/smb/client/cifssmb.c                    |   4 +-
 fs/smb/client/cifstransport.c              | 566 +++++++++++++++++++++++++++
 fs/smb/client/connect.c                    |  35 +-
 fs/smb/client/fs_context.c                 |  19 +-
 fs/smb/client/fs_context.h                 |  18 +-
 fs/smb/client/link.c                       |  13 +-
 fs/smb/client/reparse.c                    |   2 +-
 fs/smb/client/smb1ops.c                    |  19 +-
 fs/smb/client/smb2inode.c                  |   5 +-
 fs/smb/client/smb2ops.c                    |  63 ++-
 fs/smb/client/smb2transport.c              |   4 +-
 fs/smb/client/smbdirect.c                  | 465 +++++++++++-----------
 fs/smb/client/smbdirect.h                  |  92 +----
 fs/smb/client/transport.c                  | 602 ++---------------------------
 fs/smb/common/smbdirect/smbdirect_socket.h | 118 ++++++
 20 files changed, 1066 insertions(+), 1031 deletions(-)
 create mode 100644 fs/smb/client/cifstransport.c

--
Thanks,

Steve
