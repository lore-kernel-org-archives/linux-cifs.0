From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/4] cifs: cifsacl cleanups
Date: Tue, 16 Oct 2012 07:26:42 -0400
Message-ID: <1350386806-18356-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Just some nits I noticed while trying to understand how this code works.
Nothing in here that can't wait until 3.8...

Jeff Layton (4):
  cifs: clean up id_mode_to_cifs_acl
  cifs: move num_subauth check inside of CONFIG_CIFS_DEBUG2 check in
    parse_sid()
  cifs: use the NUM_AUTHS and NUM_SUBAUTHS constants in cifsacl code
  cifs: make compare_sids static

 fs/cifs/cifsacl.c | 159 +++++++++++++++++++++++++++---------------------------
 fs/cifs/cifsacl.h |   6 +--
 2 files changed, 81 insertions(+), 84 deletions(-)

-- 
1.7.11.7
