From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] SMB3 Fixes for stable
Date: Fri, 22 Sep 2017 20:58:06 -0500
Message-ID: <CAH2r5mu21zr=nU71_eCKzh1TQ1MUgvrYfCMfHiB7tnD+jEQVTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
        "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Please pull the following changes since commit
12fcf66e74b16b96e57fc1ce32bdf27b3a426fd0:

  Merge branch 'for-next' of
git://git.kernel.org/pub/scm/linux/kernel/git/shli/md (2017-09-19
08:39:32 -0700)

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git
tags/4.14-smb3-fixes-from-recent-test-events-for-stable

for you to fetch changes up to 1013e760d10e614dc10b5624ce9fc41563ba2e65:

  SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags (2017-09-22
19:47:17 -0500)

----------------------------------------------------------------
Various SMB3 fixes for stable and security improvements from the
recently completed SMB3/Samba test events

----------------------------------------------------------------
Colin Ian King (1):
      CIFS: make arrays static const, reduces object code size

Ronnie Sahlberg (1):
      cifs: show 'soft' in the mount options for hard mounts

Shu Wang (2):
      cifs: release cifs root_cred after exit_cifs
      cifs: release auth_key.response for reconnect.

Steve French (7):
      Fix SMB3.1.1 guest authentication to Samba
      SMB3: Fix endian warning
      SMB3: Warn user if trying to sign connection that authenticated as guest
      [SMB3] Update session and share information displayed for
debugging SMB2/SMB3
      SMB: Validate negotiate (to protect against downgrade) even if signing off
      SMB3: handle new statx fields
      SMB3: Don't ignore O_SYNC/O_DSYNC and O_DIRECT flags

 fs/cifs/cifs_debug.c |  9 +++++++--
 fs/cifs/cifsfs.c     |  4 +++-
 fs/cifs/connect.c    |  8 ++++++++
 fs/cifs/file.c       | 19 +++++++++++++++----
 fs/cifs/inode.c      | 15 +++++++++++++++
 fs/cifs/smb2pdu.c    | 26 ++++++++++++++++++--------
 6 files changed, 66 insertions(+), 15 deletions(-)

-- 
Thanks,

Steve
