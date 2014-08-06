From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/5] SMB/CIFS nounix support for Connectathon test suite
Date: Wed,  6 Aug 2014 16:01:07 +0400
Message-ID: <1407326472-13853-1-git-send-email-pshilovsky@samba.org>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: Steve Dickson <SteveD-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The goal of the series is to add support of testing various versions of SMB/CIFS protocol without Unix extensions. Also there are two patches that fixes problems in special and tlock tests.

With the patchset applied nounix SMB/CIFS servers and clients can be tested with "server -C" command.

Jeff Layton (2):
  tlock: munmap missed before close
  Add SMB/CIFS mounts support

Pavel Shilovsky (3):
  Add capability to test SMB 2.0 and higher verions
  Add SMB/CIFS section in tests.init
  special: fix op_unlk and op_ren tests output

 basic/runtests       |  8 +++++---
 lock/runtests        |  9 +++++++--
 lock/tlock.c         | 11 +++++++++--
 server               |  5 +++--
 special/op_ren.c     | 16 +++++++++++++---
 special/op_unlk.c    |  8 +++++---
 special/runtests.wrk | 11 ++++++++---
 tests.init           |  4 ++++
 8 files changed, 54 insertions(+), 18 deletions(-)

-- 
1.8.1.2
