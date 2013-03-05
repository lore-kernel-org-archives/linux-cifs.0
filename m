From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/3] Improvements to cifs_rename_pending_delete()
Date: Tue,  5 Mar 2013 19:25:54 +0000
Message-ID: <1362511557-22607-1-git-send-email-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The patch series consists of a bug fix and a couple of enhancements
to cifs_rename_pending_delete()

Sachin Prabhu (3):
  cifs: Fix bug when checking error condition in
    cifs_rename_pending_delete()
  cifs: Check server capability before attempting silly rename
  cifs: Return EBUSY instead of ETXTBSY in cifs_rename_pending_delete()

 fs/cifs/inode.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

-- 
1.7.11.7
