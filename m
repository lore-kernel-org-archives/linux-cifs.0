From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [GIT] CIFS Fixes
Date: Mon, 19 Sep 2011 23:49:14 -0500
Message-ID: <CAH2r5munKhMMq3GpRp_iEmrb7t3ATZjkubciwTyCe_R2aUdodw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The following changes since commit 9d037a777695993ec7437e5f451647dea7919d4c:
  Linus Torvalds (1):
        Merge branch 'irq-fixes-for-linus' of
git://tesla.tglx.de/git/linux-2.6-tip

are available in the git repository at:

  git://git.samba.org/sfrench/cifs-2.6.git master

Jeff Layton (1):
      cifs: fix possible memory corruption in CIFSFindNext

Pavel Shilovsky (1):
      CIFS: Fix ERR_PTR dereference in cifs_get_root

Shirish Pargaonkar (1):
      cifs: Fix broken sec=ntlmv2/i sec option (try #2)

Steve French (1):
      Fix the conflict between rwpidforward and rw mount options


-- 
Thanks,

Steve
