From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fix
Date: Tue, 31 Jan 2017 09:43:11 -0600
Message-ID: <CAH2r5mtunJJxiYcbLYVyv2jhZ0wsRurLCxdWsPgMsrWoT06d5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        robin-VrBV9hrLPhE@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A small cifs fix for stable

Please pull the following changes since commit
2eabb8b8d68bc9c7779ba8b04bec8d4f8baed0bc:

  Merge tag 'nfsd-4.10-1' of git://linux-nfs.org/~bfields/linux
(2017-01-16 09:34:37 -0800)

are available in the git repository at:


  git://git.samba.org/sfrench/cifs-2.6.git for-next

for you to fetch changes up to 81ddd8c0c5e1cb41184d66567140cb48c53eb3d1:

  cifs: initialize file_info_lock (2017-01-14 14:58:29 -0600)

----------------------------------------------------------------
Rabin Vincent (1):
      cifs: initialize file_info_lock

 fs/cifs/readdir.c | 1 +
 1 file changed, 1 insertion(+)

-- 
Thanks,

Steve
