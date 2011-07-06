From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: fix regressions when chasing DFS referrals at mount time
Date: Wed,  6 Jul 2011 08:10:35 -0400
Message-ID: <1309954239-17345-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

While the patch I posted yesterday fixes the oops that was occurring
when the client tried to chase DFS referrals at mount time, doing so
still didn't work.

The main culprit seems to be the shared-superblock patchset, which
broke this in several different ways. This patchset fixes the problems
for me and passes basic smoke testing.

Steve, please consider these for 3.0. I don't really like pushing a
set this large close to release, but I don't see any alternative.

Jeff Layton (4):
  cifs: fix build_unc_path_to_root to account for a prefixpath
  cifs: have cifs_cleanup_volume_info not take a double pointer
  cifs: factor smb_vol allocation out of cifs_setup_volume_info
  cifs: fix expand_dfs_referral

 fs/cifs/cifsfs.c    |    8 ++--
 fs/cifs/cifsproto.h |    6 +-
 fs/cifs/connect.c   |  111 +++++++++++++++++++++++++++++----------------------
 3 files changed, 70 insertions(+), 55 deletions(-)

-- 
1.7.6
