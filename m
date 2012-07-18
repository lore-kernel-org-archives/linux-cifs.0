From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Tue, 17 Jul 2012 19:34:33 -0500
Message-ID: <CAH2r5msT74rWpyFBWWFYG+MT6+FP=7mEV6SjpmVn-uspzjmUnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 055c9fa8874fa7261eec7a268366565db84af474:

  Merge tag 'fixes-for-v3.5' of
git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-gpio
(2012-07-10 13:24:48 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git master

for you to fetch changes up to cd60042cc1392e79410dc8de9e9c1abb38a29e57:

  cifs: always update the inode cache with the results from a FIND_*
(2012-07-16 23:57:23 -0500)

----------------------------------------------------------------
Jeff Layton (3):
      cifs: on CONFIG_HIGHMEM machines, limit the rsize/wsize to the kmap space
      cifs: when CONFIG_HIGHMEM is set, serialize the read/write kmaps
      cifs: always update the inode cache with the results from a FIND_*

Sachin Prabhu (1):
      Initialise mid_q_entry before putting it on the pending queue

 fs/cifs/cifssmb.c   |   30 +++++++++++++++++++++++++++++-
 fs/cifs/connect.c   |   18 ++++++++++++++++++
 fs/cifs/readdir.c   |    7 +++++--
 fs/cifs/transport.c |   26 ++++++++++++++------------
 4 files changed, 66 insertions(+), 15 deletions(-)


-- 
Thanks,

Steve
