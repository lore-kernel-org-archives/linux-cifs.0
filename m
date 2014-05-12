From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Sun, 11 May 2014 22:02:54 -0500
Message-ID: <CAH2r5mvf8LV6TBG8FQiUYi-P2dbd27OnhNxcWCG275YWcuGrYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Small cifs fix for metadata caching

The following changes since commit 76429f1dedbc1815d875c9b68eefd30c95cb8fa9:

  Merge tag 'regulator-v3.15-rc2' of
git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
(2014-04-24 12:01:58 -0700)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-linus

for you to fetch changes up to a87c9ad956676d84d459739fc14ec5a3c3565717:

  cifs: fix actimeo=0 corner case when cifs_i->time == jiffies
(2014-04-24 22:37:03 -0500)

----------------------------------------------------------------
Jeff Layton (1):
      cifs: fix actimeo=0 corner case when cifs_i->time == jiffies

 fs/cifs/inode.c | 3 +++
 1 file changed, 3 insertions(+)
-- 
Thanks,

Steve
