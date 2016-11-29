From: Mark Syms <mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Handle guest access failures
Date: Tue, 29 Nov 2016 11:36:45 +0000
Message-ID: <20161129113646.13360-1-mark.syms@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <mark.syms-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When testing SMB filesystem access with XenServer we discovered
that if guest access is attempted to a Windows share that requires
authentication the connection establishment stage in the kernel
went into a non-recoverable (without kill -9 of the mount command)
loop attempting to follow a DFS referal. The cause of this is that
the error now surfaces later in the process than previously and all
errors were considered to be the same and caused a DFS referal step.

Mark Syms (1):
  CIFS: handle guest access errors to Windows shares

 fs/cifs/connect.c | 3 +++
 1 file changed, 3 insertions(+)

-- 
2.10.2
