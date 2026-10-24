Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792815317;
	b=iGRngeyJ8FLYrWQdoadVeWWZV3Q3HM3rlANf983xKYnSC7tACXiJH7tYTGKUNJZ7BNss
	 xdG/RgmaxN/4QP63I8L+TmPAw6tG43WX69QVmT4qBXvNoZpmTHTxBx4yIjPYxytC5HEwZ
	 NS9Rv4HkDWUOZieYl+WuOXC/fkqaepBncG6g+CmoOrQIm3REyuvFCf/Mp33NMvhgcscRQ
	 L4xzZNg/EJZAIe12f2OQv29TK0P7a8DsKPE0GVX5qhvaIA5wvBJ4+787ggqonZj6qHmRp
	 ivKMCVTeHMsH/J1oni7llqSU6LQkz9Fu+1NvHrohCaIjmU9/mfC/lqietNAnwbAXISg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792815317;
	h=Received:DKIM-Signature:Received:X-Forwarded-Encrypted:
	 X-Gm-Message-State:X-Received:MIME-Version:From:Date:
	 X-Gmail-Original-Message-ID:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=CX1h7nkyuViVFJezBLayN4UjS+kYqcxD/dUygmHRPSk=;
	b=y1HYS4ArPWuNsKUBXXWU7xIehvitYFpZOOGqpqIFy06cN6sFa1RT8NrAZLO8DHVUEibi
	 DuvgxmlD1hvpnrR4SI74Qsot7bXSntG8k9E/QS/R+Ss4swmegx6ID+3jCQUfYpCM/8hm4
	 NUW6pC615ajlIE80XBSRkBJJuAdz+mt/HtvZHzuFX2elCyLvaKG8CMddUiW28o26lj1Jw
	 0G76Zn9B/uD1MLyHiaPg5xGOPVl8TUHyyVZHagcRuRAHhghu5a8VcRCYioEZSmbqUKlCx
	 TrSvFXlP/XmKLMJwhZ+P7nqQe7mQ9urRKflQkzGRJ03UhZnu0Zq1dTq01HwYyHKcGhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZPsaI5s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52792606A320
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 04:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BZPsaI5s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA8701F01825
	for <linux-cifs@vger.kernel.org>; Sat, 24 Oct 2026 04:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792815316;
	bh=CX1h7nkyuViVFJezBLayN4UjS+kYqcxD/dUygmHRPSk=;
	h=From:Date:Subject:To:Cc;
	b=BZPsaI5sOlsZ4Aq2ep+ndNua8EOKVQun/gpjH21mjBDYoL4OS2OymoaYKe+486dij
	 KWT4zfKNJ4zYSXeB+rJfzdMz1Yri+BLdI2CwpYrpfMLh76bYHh8g26dZ9rGYU8KLuV
	 eSyqpj/361kffpjnBTOUdJbVY5lpk+eklPxRDk6onIO7nb7nzf+UFRnAe4mFzXbzzb
	 8v8eLXac0DwRuVMypim3rp7wVkdNT6DqEvhjYGflIyUQtHQAXA5R9fifIorkldGTav
	 hXR9EgmE2K1BQcEOlgoe/XzkpCakI3xCTyhzAq5Me/OM+1wN6on8KHAh/bJX2FXJEP
	 ZyDG5fSkjJDrg==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6afbc363efeso2393272a12.3
        for <linux-cifs@vger.kernel.org>; Fri, 23 Oct 2026 21:15:16 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzAyEH4TuxQtui45AW6qfpRbZ283NVB6sSOA/yoopm3iomgjA3XobacHnb1pMpJI/nHZSPufeB2sZdt@vger.kernel.org
X-Gm-Message-State: AFq9FYJZdc3ui5xI73CVJRLIj54JaQj85Ne2qSbiExxgmy8k2/17k9gG
	RndRlAJYeVZgC4LWG3jfWroPT805xW5RI8zB5v0L1VP+bNzVrSS9eErXRY/1N2e1uR7lkmNmrKc
	46ntZVYxA0Qq8OgYCTNUCmJyLwVmSdzE=
X-Received: by 2002:a05:6402:1246:b0:6b1:d661:d37f with SMTP id
 4fb4d7f45d1cf-6b442fc9ccfmr853882a12.9.1792815314114; Fri, 23 Oct 2026
 21:15:14 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Sat, 24 Oct 2026 13:15:01 +0900
X-Gmail-Original-Message-ID: <CAKYAXd-E14WN6OkWLtkuDBqRE00WS9zKQBmm01iJ7k1wavLw-Q@mail.gmail.com>
X-Gm-Features: AclHuK_wUklnIS7CqIRw3e5bcLSjnM-l2_TRuxazQGMtwgYQ7dKwSgTNMHCU-lw
Message-ID: <CAKYAXd-E14WN6OkWLtkuDBqRE00WS9zKQBmm01iJ7k1wavLw-Q@mail.gmail.com>
Subject: [GIT PULL] ksmbd server update for 7.4-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Linus,

This is ksmbd server update pull request for v7.4-rc1. I add a description =
of
this pull request below. Please pull ksmbd with following ones.

Thanks!

The following changes since commit 4cbdd58dfa7aaad679bf62f81cdbc96a6cb7c6ae=
:

  Merge tag 'perf-core-2026-10-18' of
git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2026-10-20
13:00:41 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linkinjeon/smb.git
tags/ksmbd-for-7.4-rc1

for you to fetch changes up to 2c36c4a86104d763ee798d4a89e2d3384b4cd626:

  ksmbd: select CRYPTO_AES (2026-10-23 10:09:14 +0900)

----------------------------------------------------------------
 - Add extended SMB2 directory information support.
   Implement FileIdExtdDirectoryInformation,
   FileId64ExtdDirectoryInformation,
   FileId64ExtdBothDirectoryInformation,
   FileIdAllExtdDirectoryInformation, and
   FileIdAllExtdBothDirectoryInformation, including reparse tags,
   file attributes, and initialized response padding.

 - Track unsigned 64-bit lock ranges in the server lock index, with
   conflict detection, blocking waits, cancellation, rollback, and
   cleanup for ranges beyond the VFS signed-offset limit.

 - Add configurable per-connection session limits.
   Reserve slots for new sessions and multichannel bindings, release
   them during failure and cleanup, and expose the configured limit
   through procfs.

 - Validate POSIX negotiate and CREATE contexts, including payload
   lengths, extension tags, duplicate contexts, dialect requirements,
   and share eligibility. Require POSIX opens for POSIX file,
   directory, and filesystem information queries.

 - Apply requested POSIX create modes, including mode zero, and NFS
   mode ACEs with special permission bits. Enforce append-only writes
   and base byte-range lock checks on each open's POSIX state.

 - Complete POSIX metadata responses with filenames, file types,
   permission bits, and filesystem device identifiers. Query filesystem
   information through the requested open and report the filesystem
   fragment size and response length.

 - Validate SMB3 encryption transform flags and ensure decrypted
   compound requests use the session authenticated by the transform,
   including requests containing compressed payloads.

 - Serialize negotiation with receive processing, size CREATE responses
   for their contexts, reserve UTF-16 terminator space in stream
   information, and validate WRITE data against the active compound
   request to prevent buffer overruns and stale-data writes.

 - Validate security descriptor offsets before pointer arithmetic,
   handle DACL offset overflow on 32-bit systems, and propagate inode
   ACL lookup failures safely.

 - Deny access through empty DACLs while retaining the owner's implicit
   security-management rights. Add KUnit regression coverage for DACL
   walk boundaries and maximal-access calculations.

 - Validate RPC pipe ownership for IPC$ reads and writes, and fix
   FSCTL_PIPE_TRANSCEIVE handle lookup and response file IDs.

 - Fix durable reconnect path validation for symlinked share paths,
   shares exporting "/", and handles opened at the share root.
   Check path boundaries before comparisons to prevent out-of-bounds
   reads and cross-share confusion.

 - Rebind completed durable CREATE replays to surviving channels
   without draining unrelated requests on the old channel. Transfer
   open accounting with the binding and avoid consuming additional
   open-file budget during durable reconnects.

 - Scope AppInstanceId takeovers to the matching share, path, stream,
   and client identity. Check access and AppInstanceVersion before
   closing an existing open.

 - Retry oplock and lease break notifications through other live
   channels, track queued TCP delivery, serialize acknowledgment
   updates, and expire unacknowledged breaks while waking blocked
   requests.

 - Keep lease tables and byte-range lock indexes independent of their
   original connection so surviving channels and detached durable
   opens retain access to lease and lock state.

 - Reclaim ended sessions after logoff and expiration, hold connection
   references for session channels, and drain procfs readers before
   releasing session table references. Avoid deadlocks during
   previous-session teardown and connection scavenging.

 - Prevent file publication after tree disconnect and retain tree
   references until final file release. Take parent dentry references
   during directory enumeration and serialize directory emptiness
   checks with readdir.

 - Prevent share-root removal through empty removal paths and return
   appropriate errors for directory zero-data requests and temporary
   directory attributes.

 - Fix named-stream writes, EOF changes, end-of-file reads, and content
   copying into rename targets. Reuse existing xattr names, report
   sizes by exact xattr name, and avoid emptying streams after lookup
   or permission failures.

 - Round allocation requests to the advertised allocation unit and
   avoid allocation changes that leave on-disk EOF inconsistent with
   the in-memory size.

 - Inherit FileIds across related compound requests, including
   CHANGE_NOTIFY, and use the existing async request machinery for
   notify waiting and cancellation.

 - Restore share configuration and Kerberos authentication compatibility
   with released ksmbd-tools. Advertise extended session security for
   raw NTLMSSP when requested by the client.

 - Improve Windows chained-compression compatibility, synthesized
   AFP_AfpInfo headers, generated short names, and UTF-16 alignment
   in partial normalized-name responses.

 - Fix interface-query locking, response chaining, link-speed reporting,
   and independent IPv4/IPv6 address enumeration. Display native IPv6
   client addresses accurately in procfs.

 - Improve SMB Direct socket cleanup by reclaiming failed pending
   connections, skipping failed sockets during accept, avoiding
   indefinite disconnect waits, and handling unexpected receive
   opcodes without triggering kernel warnings.

 - Select CRYPTO_AES for SMB3 encryption, replace deprecated system
   workqueues, and update feature status documentation and POSIX
   specification references.

----------------------------------------------------------------
Aamir Ahmed (1):
      ksmbd: deny access for an empty DACL instead of granting the request

Abdifatah Suruur (1):
      ksmbd: reserve space for the UTF-16 terminator in stream info

Cen Zhang (Microsoft) (1):
      ksmbd: fix parent dentry lifetime in directory enumeration

ChenXiaoSong (4):
      smb/server: support compound fid in notify requests
      smb/server: fix trailing period in generated short names
      smb/server: align partial normalized name responses to UTF-16
      smb/server: rename smb2_file_alt_name_info to smb2_file_name_info

DaeMyung Kang (6):
      ksmbd: fix named stream write and EOF handling
      ksmbd: return end of file for reads past a named stream's data
      ksmbd: use the existing xattr name for a named stream
      ksmbd: preserve unreadable named streams on open
      ksmbd: avoid restoring only in-memory EOF after allocation change
      ksmbd: round SetAllocation to the advertised allocation unit

Daijiamu (1):
      ksmbd: use clear_and_wake_up_bit() directly

Dairui Zhang (2):
      ksmbd: fix OOB read and cross-share confusion in
ksmbd_validate_name_reconnect()
      ksmbd: verify transform SessionId matches the decrypted header

Gael Blivet (5):
      ksmbd: refactor smb2_notify() to a blocking wait
      ksmbd: copy stream content when renaming to a new stream name
      ksmbd: look up stream size by exact xattr name
      ksmbd: fix AFP_AfpInfo header fields in synthesized xattr
      ksmbd: print IPv6 client addresses correctly in procfs

Giorgi Kobakhia (1):
      ksmbd: fix overflow in dacloffset bounds check in build_sec_desc()

Hang Nan (3):
      ksmbd: add KUnit test for the DACL walk boundary
      ksmbd: test smb_check_perm_dacl() DACL walk boundary
      ksmbd: test maximal-access DACL walk boundary

Henry Hu (6):
      ksmbd: fix iface_list use-after-free during server reset
      ksmbd: fix invalid pointer dereference when get_inode_acl() fails
      ksmbd: fix link speed query in fsctl_query_iface_info_ioctl()
      ksmbd: fix unlocked IPv6 addr_list walk in fsctl_query_iface_info_ioc=
tl()
      ksmbd: fix invalid Next offset in interface info replies
      ksmbd: report IPv4 and IPv6 addresses independently in iface query

J=C3=A9r=C3=A9my Jean (1):
      ksmbd: fix SMB2 CREATE response buffer overflow

Karl Mehltretter (1):
      ksmbd: use u8 for SMB2 oplock level values

Lee Seong Hyeon (1):
      ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle

Michail Andreas Michalopoulos (4):
      ksmbd: accept share config responses from ksmbd-tools before 3.5.3
      ksmbd: reject FILE_ATTRIBUTE_TEMPORARY on directories
      ksmbd: restore Kerberos logins with released ksmbd-tools
      ksmbd: select CRYPTO_AES

Mohammed Alquraini (1):
      ksmbd: reject foreign RPC pipe handles on IPC$ read and write

Namjae Jeon (44):
      ksmbd: prevent stale data from being written by SMB2 WRITE requests
      ksmbd: doc: update SMB3 multichannel support status
      ksmbd: doc: update RDMA feature support status
      ksmbd: doc: update feature status
      ksmbd: disconnect on invalid encryption transform flags
      ksmbd: wait for negotiation before receiving another PDU
      ksmbd: support FileIdAllExtdBothDirectoryInformation
      ksmbd: support FileIdExtdDirectoryInformation
      ksmbd: support FileId64ExtdDirectoryInformation
      ksmbd: support FileId64ExtdBothDirectoryInformation
      ksmbd: support FileIdAllExtdDirectoryInformation
      ksmbd: cache the resolved share path for durable reconnects
      ksmbd: fix durable reconnects for root shares
      ksmbd: fix extended session security negotiation for raw NTLMSSP
      ksmbd: validate security descriptor offsets before pointer arithmetic
      ksmbd: release connection lock while draining old session
      ksmbd: serialize oplock break ACK state updates
      ksmbd: track delivery of queued TCP writes
      ksmbd: retry break notifications on another connection
      ksmbd: keep lease tables until their last lease is closed
      ksmbd: index byte-range locks independently of their connection
      ksmbd: rebind completed CREATE replays without draining the old chann=
el
      ksmbd: track SMB2 locks above OFFSET_MAX in server lock table
      ksmbd: expire unacknowledged oplock breaks
      ksmbd: expire unacknowledged lease breaks
      ksmbd: validate POSIX negotiate contexts
      ksmbd: validate POSIX create contexts
      ksmbd: enforce POSIX append-only writes
      ksmbd: apply byte-range lock checks per open
      ksmbd: use requested mode in POSIX creates
      ksmbd: apply POSIX mode ACEs in security updates
      ksmbd: correct POSIX file metadata in responses
      ksmbd: include filenames in POSIX query info
      ksmbd: require POSIX opens for file and directory queries
      ksmbd: query POSIX filesystem info through the open file
      ksmbd: correct POSIX filesystem block size and response length
      ksmbd: inherit FileIds in related compound requests
      ksmbd: defer connection scavenging while session locks are busy
      ksmbd: hold a connection reference for each session channel
      ksmbd: limit sessions on each connection
      ksmbd: reclaim ended sessions on logoff and expiration
      ksmbd: drain session procfs readers before dropping table references
      ksmbd: fix fd_limit accounting across durable reconnects
      ksmbd: prevent share root removal through empty paths

Omkar Chandorkar (2):
      smb: compress: relax trailing flags in chained decompression
      ksmbd: fix FSCTL_PIPE_TRANSCEIVE file lookup and response handling

Stefan Metzmacher (4):
      smb: smbdirect: don't wait for RDMA_CM_EVENT_DISCONNECTED in
smbdirect_socket_destroy_sync()
      smb: smbdirect: release failed pending sockets of a listener
      smb: smbdirect: don't hand out already failed sockets in
smbdirect_socket_accept()
      smb: smbdirect: don't WARN on an unexpected receive opcode

Sung Byeongchan (1):
      ksmbd: validate AppInstanceId takeover target

Weiming Shi (1):
      smb/server: prevent file publication after tree disconnect

Yongjun Gwon (1):
      ksmbd: serialize directory emptiness checks with readdir

ZhangGuoDong (3):
      smb/server: update POSIX extension specification references
      smb/common: update POSIX extension specification references
      smb/server: replace deprecated system workqueues

 Documentation/filesystems/smb/ksmbd.rst |   14 +-
 fs/smb/common/compress/compress.c       |   16 +-
 fs/smb/common/fscc.h                    |    5 +-
 fs/smb/common/smbglob.h                 |    1 +
 fs/smb/server/Kconfig                   |    3 +
 fs/smb/server/Makefile                  |    1 +
 fs/smb/server/auth.c                    |    6 +-
 fs/smb/server/compress.c                |    1 +
 fs/smb/server/connection.c              |   59 +-
 fs/smb/server/connection.h              |   31 +-
 fs/smb/server/ksmbd_netlink.h           |    8 +-
 fs/smb/server/ksmbd_work.c              |   22 +-
 fs/smb/server/ksmbd_work.h              |   18 +-
 fs/smb/server/mgmt/share_config.c       |   43 +-
 fs/smb/server/mgmt/share_config.h       |    6 +-
 fs/smb/server/mgmt/tree_connect.c       |    7 +
 fs/smb/server/mgmt/tree_connect.h       |    2 +
 fs/smb/server/mgmt/user_session.c       |  221 ++-
 fs/smb/server/mgmt/user_session.h       |   12 +-
 fs/smb/server/oplock.c                  | 1126 ++++++++++------
 fs/smb/server/oplock.h                  |   23 +-
 fs/smb/server/proc.c                    |    2 +
 fs/smb/server/server.c                  |   31 +-
 fs/smb/server/server.h                  |    3 +
 fs/smb/server/smb2ops.c                 |   33 +
 fs/smb/server/smb2pdu.c                 | 2222 ++++++++++++++++++++-------=
----
 fs/smb/server/smb2pdu.h                 |   26 +-
 fs/smb/server/smb_common.c              |   10 +-
 fs/smb/server/smb_common.h              |   98 ++
 fs/smb/server/smbacl.c                  |   77 +-
 fs/smb/server/smbacl.h                  |    4 +-
 fs/smb/server/tests/Kconfig             |   15 +
 fs/smb/server/tests/Makefile            |    4 +
 fs/smb/server/tests/smbacl_kunit.c      |  301 +++++
 fs/smb/server/transport_ipc.c           |   23 +-
 fs/smb/server/transport_tcp.c           |  307 ++++-
 fs/smb/server/vfs.c                     |  126 +-
 fs/smb/server/vfs.h                     |    8 +-
 fs/smb/server/vfs_cache.c               |  732 +++++++---
 fs/smb/server/vfs_cache.h               |   35 +-
 fs/smb/smbdirect/accept.c               |  227 +++-
 fs/smb/smbdirect/connect.c              |    2 +-
 fs/smb/smbdirect/connection.c           |   14 +-
 fs/smb/smbdirect/internal.h             |    2 +
 fs/smb/smbdirect/listen.c               |  137 +-
 fs/smb/smbdirect/socket.c               |  113 +-
 fs/smb/smbdirect/socket.h               |   42 +
 47 files changed, 4501 insertions(+), 1718 deletions(-)
 create mode 100644 fs/smb/server/tests/Kconfig
 create mode 100644 fs/smb/server/tests/Makefile
 create mode 100644 fs/smb/server/tests/smbacl_kunit.c
