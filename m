From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 0/4] Fix various coverity warnings in fs/cifs
Date: Fri, 27 Mar 2015 00:27:58 -0500
Message-ID: <1427434082-4299-1-git-send-email-smfrench@gmail.com>
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Four small fixes to address warnings coverity analyzer displays
for fs/cifs.

Steve French (4):
  [SMB3] Fix warning on uninitialized buftype
  [CIFS] Don't ignore errors on encrypting password in SMBTcon
  [SMB3] Fix dereference before null check warning
  [SMB3] Fix coverity warning

 fs/cifs/connect.c  |  6 ++++++
 fs/cifs/smb2misc.c |  2 +-
 fs/cifs/smb2pdu.c  | 15 +++++++++------
 3 files changed, 16 insertions(+), 7 deletions(-)

-- 
1.9.1
