From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2 v2] Add copy_file_range support for cifs
Date: Fri, 10 Feb 2017 16:03:49 +0530
Message-ID: <20170210103351.10163-1-sprabhu@redhat.com>
To: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is used by the syscall copy_file_range() to provide server
side copy facilities using the SMB2 ioctl
FSCTL_SRV_COPYCHUNK_WRITE

v2:
Rename operation clone_range to copychunk_range
Do not remove the ioctls which allow users to directly
call FSCTL_SRV_COPYCHUNK_WRITE

Sachin Prabhu (2):
  Rename clone_range to copychunk_range
  Introduce cifs_copy_file_range()

 fs/cifs/cifsfs.c   | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/cifs/cifsfs.h   |  5 ++++
 fs/cifs/cifsglob.h |  7 +++--
 fs/cifs/ioctl.c    | 66 ++++-------------------------------------
 fs/cifs/smb2ops.c  | 32 ++++++++++++--------
 5 files changed, 120 insertions(+), 77 deletions(-)

-- 
2.9.3
