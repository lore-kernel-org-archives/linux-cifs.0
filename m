From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Thu, 17 Oct 2013 16:13:20 -0500
Message-ID: <CAH2r5msVAfmh=us2SrmS6Em+JvTXHfb0wk=dHS4b=9KnOn_djA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Five small cifs fixes (includes fixes for: unmount hang, 2 security
related, symlink, large file writes).

The following changes since commit e62063d69911886a5a92c719d262a2a87e1e5b60:

  Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/mason/linux-btrfs
(2013-10-05 12:17:24 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to 0c26606cbe4937f2228a27bb0c2cad19855be87a:

  cifs: ntstatus_to_dos_map[] is not terminated (2013-10-14 12:14:01 -0500)

----------------------------------------------------------------
Jan Klos (1):
      cifs: Fix inability to write files >2GB to SMB2/3 shares

Sachin Prabhu (1):
      cifs: Allow LANMAN auth method for servers supporting
unencapsulated authentication methods

Shirish Pargaonkar (1):
      cifs: Avoid umount hangs with smb2 when server is unresponsive

Steve French (1):
      do not treat non-symlink reparse points as valid symlinks

Tim Gardner (1):
      cifs: ntstatus_to_dos_map[] is not terminated

 fs/cifs/cifsfs.c    |  6 ++++--
 fs/cifs/cifspdu.h   | 31 +++++++++++++++++++++++--------
 fs/cifs/cifssmb.c   | 40 ++++++++++++++++++++++++++++++++++------
 fs/cifs/netmisc.c   |  4 +++-
 fs/cifs/sess.c      |  4 ++--
 fs/cifs/smb2pdu.c   |  6 ++++++
 fs/cifs/smbfsctl.h  | 14 ++++++++++++++
 fs/cifs/transport.c |  9 +++++++--
 8 files changed, 93 insertions(+), 21 deletions(-)

-- 
Thanks,

Steve
