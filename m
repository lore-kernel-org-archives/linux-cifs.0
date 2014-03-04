From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 4 Mar 2014 09:07:47 -0600
Message-ID: <CAH2r5ms7UO6FXxtXnAR8C-ckkfgs2enghMJnNu=p4DZVZORy6Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A few small cifs fixes including one for a problem Al spotted in
cifs_writev and also fixes to ensure that cifs never sends more than
the smb frame length over the socket (as we saw with the
cifs_iovec_write problem that was fixed last month).

The following changes since commit f9b080803ec66f708309ceffab14ce879c302963:

  Merge tag 'usb-3.14-rc4' of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb (2014-02-23
10:40:22 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to dca1c8d17a2feae056f9e334ea75a462ae4cb52a:

  cifs: mask off top byte in get_rfc1002_length() (2014-02-28 14:01:14 -0600)

----------------------------------------------------------------
Jeff Layton (2):
      cifs: sanity check length of data to send before sending
      cifs: mask off top byte in get_rfc1002_length()

Pavel Shilovsky (1):
      CIFS: Fix wrong pos argument of cifs_find_lock_conflict

 fs/cifs/cifsglob.h  |  2 +-
 fs/cifs/file.c      | 24 ++++++------------------
 fs/cifs/transport.c | 29 +++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 19 deletions(-)

-- 
Thanks,

Steve
