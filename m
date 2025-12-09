Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB29018FDBE
	for <linux-cifs@vger.kernel.org>; Tue,  9 Dec 2025 03:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765252448; cv=none; b=CRoluOMbifv5ohEkxsb5x8nSa8WKG2OVsh2yg4TrB0kQgsTvO2Yxg6n4jwQdAYVlxwZj31Ofut6ZyrSVkQQB4zpP7ggnZRMW6Vd4gtuigDu3nFt5o0eBbrelJ1N7OD6oo4t8rswKU+WMP/A1QdvPw6hwG8823BC1uV+fVW8A6B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765252448; c=relaxed/simple;
	bh=kIbvOV3JdfdM/cVWnjRp17FLbQMjJxHuIhrdfBNQ5tM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jnr+W/eA08VGvXFJ9gRFTDK6GyS7KOVY/Ddz51x0gy/vY1OtRPvheU24ux0Ir8r5o7HxO++oAViJQdRlkaxXNXAi+tXo1cDIqcdjV3URyviJpnhzocaSMVh+M3VYHA2DffUbjKeVELRCpnxBR12Eiw09aaX0ANx39akMZ55AFEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z+GJmZ/p; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z+GJmZ/p"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-8824ce9812cso48351116d6.0
        for <linux-cifs@vger.kernel.org>; Mon, 08 Dec 2025 19:54:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765252443; x=1765857243; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A6b0xnrOoSS2VW3HmKDc0Kb3dK+eqgYmlRD5ODE+2Wg=;
        b=Z+GJmZ/pYlhKIfeFZGKwmiBh7NWNevRsEIDT48aBUH93KBtcQmsExd5NRmkTCeJdq4
         1GBJFfl8qntHh4W98f6f1aGiw6xhqsO9qrnsrLm+XP+qXT4ro150pGaV49xZVW+xjj/0
         BevvGvC5+DefkK1f//pu3kqp4LskS4LFC5bEsJ4FU/OsXLkVKC6+MxrkRBAlJT2YLz++
         9KWOcSMlyOkhVCzdCdqmzYsH5Kd4C4Bm+pL4ayqXrFXocCtK9JQX52e37NMRKSWofQPF
         J6cUVQ9f/BuMgoHD+XQ4VAVFgpcKZQ6xuunZULeO8scbuMEF7HMcbSjIZOA7/2LP6caG
         e3LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765252443; x=1765857243;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A6b0xnrOoSS2VW3HmKDc0Kb3dK+eqgYmlRD5ODE+2Wg=;
        b=PyC2I15/+sV7kyCnXaCUXtv+lM4lVuhdtlv4c3BYYrMmGxkVmeZ8ns/BpZb6W3xPW8
         5dsyAyk0wND7IGQqiwfqhHE6e0rY1BJ/2rsc5LmKt0zGKHLFMyldDdVigooVm8gv7UNn
         o/ORxKJwZfHXbFT6wXRkDBmtTaiZvye+dZu/+GwX0DoFb3zMp5vQ5ME3mr+oCI3QODDi
         Y/hrXzaCV8T0QIFz+AaRRRZHkajCCx5+H6//sYg2bQoWT1TCWdTeXUNVMGP0rgEeoxrY
         rOj0xVw2YNbatFHXhjSYHK5yiJrfWWn1j1Xw+z8eJWNIktWo7wxUq6JTtxYaJe4joPe1
         ZNbA==
X-Forwarded-Encrypted: i=1; AJvYcCXFnWet0J/h80IIU9Jnt9ivglA01A3GsIHWPdNFcCfFdDOE7pxbFlgw2wd6zepQ1dxH8Dqjh2Ts5tN4@vger.kernel.org
X-Gm-Message-State: AOJu0Yz01Bzcs11RxRNQeTcEo+eZLQlXP6d95cngTlisgKUz4I0I0L36
	utN1Doh/iL7xblg4MvoNGShO56T2oKma9VADyk3hxDl1C+339JTGSWkIJmn25nM05F9VbELmrlq
	RZXFTcPkP1LUddpnuAWmITZCYvqnXjns=
X-Gm-Gg: ASbGnctaPhRdHnq1Pp9WM8MF8Ch8QpzFiQjveSyXOBJO3zNyzrN4utiI4GgpuSXv+7h
	mJdUvmH1wMAb0oHVhdhiXpCcSKiAW1+FiN9cKG5jMUoQzouBUINjjGRo/B+16dinNZPP8pIYI1e
	TSHrHtLQ7NlF+l8IUpQSijUyK9JaV0mz4KggrtN7HhftHVYRIQak3ZvUIAj8ACwAVzyxzbWWfeQ
	F97ryP3ZNaCVOZoEiaHvZSGCdaSJPZsODm3//jLoIzdd00kcKF/eKFwMziUnU4xk8Ft0oT0Gulz
	iAupuTSJcMG0lkxSCHwolyAuNca/0eqprd3TqV/ZI8xtk905ZFSlpM8InGv585JIbPxJUCcx1VO
	apQL4WL76JJGTREsP56W3B+nQcKrhM5hYD9r2G9dwUUH8Hi/eF4eRNYLIGIIG+f+15nfKbYEoCY
	9CcFxlmw==
X-Google-Smtp-Source: AGHT+IF13KP4SEjF4hiETlxlpdeWlEEjNhioJsS7izAic++eU3a6vA4JUiPsq363tOdYuxE700fAAXxVtFVqswfezd4=
X-Received: by 2002:a05:6214:1bc6:b0:880:5193:10fb with SMTP id
 6a1803df08f44-8883dc20a77mr170718526d6.54.1765252443382; Mon, 08 Dec 2025
 19:54:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Steve French <smfrench@gmail.com>
Date: Mon, 8 Dec 2025 21:53:51 -0600
X-Gm-Features: AQt7F2pnbQP7m_9yeammjWK-OCVB8-BwQ3g_ywioiAWmbLtl2sIWP9tKf7NxS-s
Message-ID: <CAH2r5msaVyrK7m_FvOWn9mFp0PpGij2aeiX0VOrwiVMtjBq5dQ@mail.gmail.com>
Subject: [GIT PULL] smb3 client fixes part 1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Please pull the following changes since commit
869737543b39a145809c41a7253c6ee777e22729:

  Merge tag 'v6.19-rc-smb-fixes' of git://git.samba.org/ksmbd
(2025-12-03 20:23:41 -0800)

are available in the Git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git tags/v6.19-rc-part1-smb3-client-fixes

for you to fetch changes up to d8f52650b24d9018dfb65d2c60e17636b077e63e:

  smb/client: update some SMB2 status strings (2025-12-07 11:46:19 -0600)

----------------------------------------------------------------
22 smb3 client fixes
- Two multichannel fixes, including enabling ability to change
multichannel settings with remount
- Three debugging improvements, two for adding additional tracepoints,
one for improving log messages
- Ten cleanup patches, including restructuring some of the transport
layer for the client to make it clearer, and cleanup of status code
table to be more consistent with protocol documentation
- Two fixes for reads that start beyond end of file use cases
- Fix to backoff reconnects to reduce reconnect storms
- Locking improvement for getting mid entries
- Two fixes for missing status code error mappings
- Performance improvement for status code to error mappings

----------------------------------------------------------------
ChenXiaoSong (5):
      smb/client: reduce loop count in map_smb2_to_linux_error() by half
      smb/client: remove unused elements from smb2_error_map_table array
      smb: rename to STATUS_SMB_NO_PREAUTH_INTEGRITY_HASH_OVERLAP
      smb/client: add two elements to smb2_error_map_table array
      smb/client: update some SMB2 status strings

David Howells (12):
      cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1
      cifs: Remove the RFC1002 header from smb_hdr
      cifs: Make smb1's SendReceive() wrap cifs_send_recv()
      cifs: Clean up some places where an extra kvec[] was required for rfc1002
      cifs: Replace SendReceiveBlockingLock() with SendReceive() plus flags
      cifs: Fix specification of function pointers
      cifs: Remove the server pointer from smb_message
      cifs: Don't need state locking in smb2_get_mid_entry()
      cifs: Add a tracepoint to log EIO errors
      cifs: Do some preparation prior to organising the function declarations
      cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB2
      cifs: Remove dead function prototypes

Paulo Alcantara (3):
      smb: client: relax session and tcon reconnect attempts
      smb: client: improve error message when creating SMB session
      smb: client: Add tracepoint for krb5 auth

Rajasi Mandal (2):
      cifs: client: enforce consistent handling of multichannel and max_channels
      cifs: client: allow changing multichannel mount options on remount

 fs/smb/client/cached_dir.c    |   2 +-
 fs/smb/client/cifs_debug.c    |  14 +-
 fs/smb/client/cifs_debug.h    |   6 +-
 fs/smb/client/cifs_spnego.c   |   1 +
 fs/smb/client/cifs_spnego.h   |   2 -
 fs/smb/client/cifs_unicode.h  |   3 -
 fs/smb/client/cifsacl.c       |  10 +-
 fs/smb/client/cifsencrypt.c   |  83 +---
 fs/smb/client/cifsfs.c        |  13 +-
 fs/smb/client/cifsglob.h      | 172 +++-----
 fs/smb/client/cifspdu.h       |   2 +-
 fs/smb/client/cifsproto.h     | 204 +++++++---
 fs/smb/client/cifssmb.c       | 913 +++++++++++++++++++++++++------------------
 fs/smb/client/cifstransport.c | 382 ++----------------
 fs/smb/client/compress.c      |  23 +-
 fs/smb/client/compress.h      |  19 +-
 fs/smb/client/connect.c       |  96 ++---
 fs/smb/client/dir.c           |   8 +-
 fs/smb/client/dns_resolve.h   |   4 -
 fs/smb/client/file.c          |   6 +-
 fs/smb/client/fs_context.c    | 118 +++++-
 fs/smb/client/fs_context.h    |   2 +
 fs/smb/client/inode.c         |  14 +-
 fs/smb/client/link.c          |  10 +-
 fs/smb/client/misc.c          |  53 +--
 fs/smb/client/netmisc.c       |  11 +-
 fs/smb/client/readdir.c       |   2 +-
 fs/smb/client/reparse.c       |  53 ++-
 fs/smb/client/sess.c          |  51 ++-
 fs/smb/client/smb1ops.c       |  78 +++-
 fs/smb/client/smb2file.c      |   9 +-
 fs/smb/client/smb2inode.c     |  13 +-
 fs/smb/client/smb2maperror.c  |  52 +--
 fs/smb/client/smb2misc.c      |   3 +-
 fs/smb/client/smb2ops.c       |  78 ++--
 fs/smb/client/smb2pdu.c       | 280 ++++++++-----
 fs/smb/client/smb2proto.h     |  16 +-
 fs/smb/client/smb2transport.c |  59 ++-
 fs/smb/client/trace.c         |   1 +
 fs/smb/client/trace.h         | 192 +++++++++
 fs/smb/client/transport.c     | 180 ++++-----
 fs/smb/client/xattr.c         |   2 +-
 fs/smb/common/smb2pdu.h       |   3 -
 fs/smb/common/smb2status.h    |   5 +-
 fs/smb/common/smbglob.h       |   1 -
 fs/smb/server/smb2pdu.c       |   2 +-
 46 files changed, 1740 insertions(+), 1511 deletions(-)


-- 
Thanks,

Steve
