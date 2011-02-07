From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cifs: don't perform SMB echoes on un-negotiated socket
Date: Mon,  7 Feb 2011 08:54:34 -0500
Message-ID: <1297086876-19165-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jg-9fI4heB6ewM@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Commit 247ec9b4 makes the SMB echo workqueue job skip doing echoes
unless the tcpStatus == CifsGood. Problem: tcpStatus == CifsGood is not
a reliable indicator of whether the socket has had a NEGOTIATE done on
it. This fixes that by adding a new tcpStatus of CifsNeedNegotiate that
indicates this. It also cleans up cifs_reconnect_tcon a bit.

This is not the only way to fix this issue. As Steve pointed out to me,
we could also check to see whether there's a valid SMB session on the
list as an indicator of whether a NEGOTIATE has been done. I think the
approach I'm proposing clarifies the code better, but I'm willing to go
with his approach if that's the general concensus.

JG reported this problem and tested the patch and stated that it fixed
the problem for him.

Comments and suggestions welcome...

Jeff Layton (2):
  cifs: remove checks for ses->status == CifsExiting
  cifs: clarify the meaning of tcpStatus == CifsGood

 fs/cifs/cifsglob.h |    3 ++-
 fs/cifs/cifssmb.c  |    9 +++------
 fs/cifs/connect.c  |    8 ++++----
 3 files changed, 9 insertions(+), 11 deletions(-)

-- 
1.7.4
