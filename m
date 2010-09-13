From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 13 Sep 2010 11:55:42 -0500
Message-ID: <AANLkTikH4frp4fHO+2qODFUke_xDgW7C7LK0-+1QLzNt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit d56557af19867edb8c0e96f8e26399698a08857f:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci-2.6
(2010-09-07 16:00:17 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jeff Layton (4):
      cifs: eliminate redundant xdev check in cifs_rename
      cifs: prevent cifsd from exiting prematurely
      cifs: eliminate some more premature cifsd exits
      cifs: prevent possible memory corruption in cifs_demultiplex_thread

Steve French (5):
      Revert "[CIFS] Eliminate unused variable warning"
      Revert "Eliminate sparse warning - bad constant expression"
      Revert "missing changes during ntlmv2/ntlmssp auth and sign"
      Revert "[CIFS] Fix ntlmv2 auth with ntlmssp"
      [CIFS] ntlmv2/ntlmssp remove-unused-function CalcNTLMv2_partial_mac_key

 fs/cifs/Kconfig       |    2 -
 fs/cifs/asn1.c        |    6 +-
 fs/cifs/cifsencrypt.c |  418 ++++++++-----------------------------------------
 fs/cifs/cifsglob.h    |   25 +---
 fs/cifs/cifspdu.h     |    7 +-
 fs/cifs/cifsproto.h   |   13 +-
 fs/cifs/cifssmb.c     |   13 +-
 fs/cifs/connect.c     |   71 +++------
 fs/cifs/inode.c       |   30 +---
 fs/cifs/netmisc.c     |   22 ++-
 fs/cifs/ntlmssp.h     |   13 --
 fs/cifs/sess.c        |  132 ++++------------
 fs/cifs/transport.c   |    6 +-
 13 files changed, 166 insertions(+), 592 deletions(-)


-- 
Thanks,

Steve
