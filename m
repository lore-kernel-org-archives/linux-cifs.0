From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 1 Jul 2013 13:40:07 -0500
Message-ID: <CAH2r5mt6bzUEpHuedZ0KkAHVViZQ-hcnfXqH1z9FomWph9rMTg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Various CIFS/SMB2/SMB3 updates for 3.11.  Includes bug fixes - SMB3
support should be much more stable with key DFS fix and also signing possible
now (although is more work to do to get SMB3 signing working well with
multiuser).
Mounts using the new SMB 3.02 dialect can now be done (specify "vers=3.02"
on mount) against the most current Microsoft systems. Also includes a big
cleanup of the cifs/smb2/smb3 authentication code from Jeff which fixes
some long standing problems with the way allowed authentication flavors and
signing are configured.   Some followon patches later in the cycle will clean
up allocation of structures for the various security mechanisms depending on
what dialect is chosen (reduces memory usage a little) and to add support
for the secure negotiate fsctl (for smb3) which prevents downgrade attacks.

The following changes since commit acdb37c361dc87e165889a504e291c1e82ae133c:

  fs: fix new splice.c kernel-doc warning (2013-06-23 16:19:56 -1000)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 7ac0febb81259fb9e0c447e0b90d0f05f409a02b:

  cifs: fill TRANS2_QUERY_FILE_INFO ByteCount fields (2013-06-29 00:09:44 -0500)

----------------------------------------------------------------
David Disseldorp (1):
      cifs: fill TRANS2_QUERY_FILE_INFO ByteCount fields

Jeff Layton (21):
      cifs: add a "nosharesock" mount option to force new sockets to
server to be created
      cifs: remove protocolEnum definition
      cifs: remove useless memset in LANMAN auth code
      cifs: make decode_ascii_ssetup void return
      cifs: throw a warning if negotiate or sess_setup ops are passed
NULL server or session pointers
      cifs: remove the cifs_ses->flags field
      cifs: break out decoding of security blob into separate function
      cifs: break out lanman NEGOTIATE handling into separate function
      cifs: move handling of signed connections into separate function
      cifs: factor out check for extended security bit into separate function
      cifs: add new "Unspecified" securityEnum value
      cifs: track the flavor of the NEGOTIATE reponse
      cifs: add new fields to cifs_ses to track requested security flavor
      add new fields to smb_vol to track the requested security flavor
      cifs: track the enablement of signing in the TCP_Server_Info
      move sectype to the cifs_ses instead of TCP_Server_Info
      cifs: update the default global_secflags to include "raw" NTLMv2
      cifs: clean up the SecurityFlags write handler
      revalidate directories instiantiated via FIND_* in order to
handle DFS referrals
      cifs: try to handle the MUST SecurityFlags sanely
      cifs: fix SMB2 signing enablement in cifs_enable_signing

Steve French (16):
      Fix endian error in SMB2 protocol negotiation
      Add SMB3.02 dialect support
      Add some missing SMB3 and SMB3.02 flags
      Add ability to dipslay SMB3 share flags and capabilities for debugging
      Update cifs version number
      Update headers to update various SMB3 ioctl definitions
      Some missing share flags
      Remove typo
      Charge at least one credit, if server says that it supports multicredit
      SMB2 FSCTL and IOCTL worker function
      Handle big endianness in NTLM (ntlmv2) authentication
      When server doesn't provide SecurityBuffer on SMB2Negotiate pick default
      [CIFS] fix static checker warning
      [CIFS] Do not set DFS flag on SMB2 open
      [CIFS] SMB3 Signing enablement
      [CIFS] Fix build warning

Zhao Hongjiang (1):
      cifs: using strlcpy instead of strncpy

 fs/cifs/Kconfig         |   1 +
 fs/cifs/cifs_debug.c    |  52 +++++-
 fs/cifs/cifs_unicode.h  |   8 +-
 fs/cifs/cifsencrypt.c   |  40 ++++-
 fs/cifs/cifsfs.c        |  11 +-
 fs/cifs/cifsfs.h        |   2 +-
 fs/cifs/cifsglob.h      |  48 +++---
 fs/cifs/cifspdu.h       |  17 +-
 fs/cifs/cifsproto.h     |   4 +
 fs/cifs/cifssmb.c       | 425 +++++++++++++++++++++++-------------------------
 fs/cifs/connect.c       | 159 ++++++++----------
 fs/cifs/misc.c          |   3 +-
 fs/cifs/readdir.c       |  29 ++++
 fs/cifs/sess.c          |  95 ++++++++---
 fs/cifs/smb1ops.c       |  23 +--
 fs/cifs/smb2glob.h      |   2 +
 fs/cifs/smb2misc.c      |   4 +
 fs/cifs/smb2ops.c       |  48 +++++-
 fs/cifs/smb2pdu.c       | 282 +++++++++++++++++++++-----------
 fs/cifs/smb2pdu.h       | 100 +++++++++++-
 fs/cifs/smb2proto.h     |   4 +
 fs/cifs/smb2transport.c | 151 ++++++++++++++++-
 fs/cifs/smbfsctl.h      |  27 ++-
 fs/cifs/transport.c     |   4 +-
 24 files changed, 1034 insertions(+), 505 deletions(-)

-- 
Thanks,

Steve
