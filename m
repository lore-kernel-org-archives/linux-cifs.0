From: Germano Percossi <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Fix NTLMSSP default behaviour for empty domains
Date: Thu, 24 Nov 2016 21:20:38 +0000
Message-ID: <1480022439-27875-1-git-send-email-germano.percossi@citrix.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
        <germano.percossi-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
To: <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We have observed few regressions in XenServer since we upgraded
our kernel from 3.10 to 4.x

This is due to the change in the preferred authentication mechanism
and its behaviour when the domain is not passed.

Passing 'domain=""' instead of leaving it empty, could be a
workaround (but it is not right in principle) if mount.cifs
would allow this option to be sent to the kernel module.
A patch for cifs-utils has been already submitted.

The main points (see below) of the patch are:
 - It alignes behaviour with Windows clients
 - It fixes backward compatibility
 - It fixes UPN


Germano Percossi (1):
  Fix default behaviour for empty domains and add domainauto option

 fs/cifs/cifsencrypt.c | 14 +++++++++-----
 fs/cifs/cifsglob.h    |  2 ++
 fs/cifs/connect.c     |  7 +++++++
 3 files changed, 18 insertions(+), 5 deletions(-)

-- 
1.9.1
