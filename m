From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 24 Jan 2011 22:08:00 -0600
Message-ID: <AANLkTi=P1WYZBkRoyUKyJcTWiw5z1HzU-AkeinZwkK2K@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 1bae4ce27c9c90344f23c65ea6966c50ffeae2f5:

  Linux 2.6.38-rc2 (2011-01-21 19:01:34 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git master

Jesper Juhl (1):
      CIFS: Remove pointless variable assignment in cifs_dfs_do_automount()

Rob Landley (1):
      Make CIFS mount work in a container.

 fs/cifs/cifs_dfs_ref.c |    1 -
 fs/cifs/cifsglob.h     |   33 +++++++++++++++++++++++++++++++++
 fs/cifs/connect.c      |   12 ++++++++++--
 3 files changed, 43 insertions(+), 3 deletions(-)


-- 
Thanks,

Steve
