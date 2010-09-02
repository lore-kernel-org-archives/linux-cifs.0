From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] cifs: revert recent NTLMSSP changes
Date: Wed,  1 Sep 2010 21:37:29 -0400
Message-ID: <1283391455-6848-1-git-send-email-jlayton@redhat.com>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The NTLMSSP patches that were merged recently were never reviewed. It
was originally posted as a single enormous patch. By the time that I was
able to request that the patch be re-posted as a series of smaller
patches, so that I could review it, the giant patch had already been
merged.

This patch has already created at least one fairly serious regression
-- an oops when more than one session is used on a single socket. This
regression was due to a fundamental design flaw in the original patch --
something that would likely have been caught in review if this had been
proposed as a series of sanely-sized patches.

While it's possible to fix that problem, there's no way to know what
other bugs are lurking in here since this wasn't reviewed before being
merged.

At this point, I'd like to see them reverted and have Shirish re-post
them to the list as a series of discrete changes that we can review. To
that end, here is a series of patches that reverts the original patch
and the others that fixed problems with it. I'll be happy to help
review the patches when they're posted in sanely-sized pieces.

Jeff Layton (6):
  Revert "[CIFS] CIFS requires CRYPTO, not just CRYPTO_MD5 selected in
    Kconfig"
  Revert "cifs: revert needless change in decode_negTokenInit"
  Revert "[CIFS] Eliminate unused variable warning"
  Revert "Eliminate sparse warning - bad constant expression"
  Revert "missing changes during ntlmv2/ntlmssp auth and sign"
  Revert "[CIFS] Fix ntlmv2 auth with ntlmssp"

 fs/cifs/Kconfig       |    3 -
 fs/cifs/cifsencrypt.c |  475 +++++++++++++------------------------------------
 fs/cifs/cifsglob.h    |   25 +---
 fs/cifs/cifspdu.h     |    7 +-
 fs/cifs/cifsproto.h   |   12 +-
 fs/cifs/cifssmb.c     |   13 +-
 fs/cifs/connect.c     |   13 +--
 fs/cifs/ntlmssp.h     |   13 --
 fs/cifs/sess.c        |  132 ++++----------
 fs/cifs/transport.c   |    6 +-
 10 files changed, 178 insertions(+), 521 deletions(-)

-- 
1.7.2.2
