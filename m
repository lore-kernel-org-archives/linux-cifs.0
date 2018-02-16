From: Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v1 0/3] SMB3.11 preauth integrity
Date: Fri, 16 Feb 2018 19:19:26 +0100
Message-ID: <20180216181929.21383-1-aaptel@suse.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Aurelien Aptel <aaptel-IBi9RG/b67k@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi,

This patchset implements pre-authentification signing in which is
mandatory in SMB3.11 (packet signing never worked for 3.11 in cifs.ko
before this).

The main difference is that the signing key is derived from hashing
previous requests and responses. This was partially implemented by
Steve some time ago (the preauth hash buffers were already in the
server and session structures).

The mechanism is well described in the SMB3.11 presentation given at
SDC 2015 (slides are availaible here [1]).

Since this requires a new hashing alg (SHA512) I've tried to clean up
some of the crypto code by refactoring shash & sdesc memory management
in separate functions. Much more readable now :)

1: https://www.snia.org/sites/default/files/SDC15_presentations/smb/GregKramer_%20SMB_3-1-1_rev.pdf

Aurelien Aptel (3):
  CIFS: refactor crypto shash/sdesc allocation&free
  CIFS: add sha512 secmech
  CIFS: implement v3.11 preauth integrity

 fs/cifs/Kconfig         |  1 +
 fs/cifs/cifsencrypt.c   | 85 +++++++------------------------------------
 fs/cifs/cifsfs.c        |  1 +
 fs/cifs/cifsglob.h      |  7 +++-
 fs/cifs/cifsproto.h     |  5 +++
 fs/cifs/link.c          | 27 +++-----------
 fs/cifs/misc.c          | 54 +++++++++++++++++++++++++++
 fs/cifs/smb2misc.c      | 64 ++++++++++++++++++++++++++++++++
 fs/cifs/smb2pdu.c       | 25 +++++++++++++
 fs/cifs/smb2pdu.h       |  1 +
 fs/cifs/smb2proto.h     |  5 +++
 fs/cifs/smb2transport.c | 97 +++++++++++++++++++++----------------------------
 fs/cifs/smbencrypt.c    | 27 +++-----------
 fs/cifs/transport.c     | 17 +++++++++
 14 files changed, 245 insertions(+), 171 deletions(-)

-- 
2.12.3
