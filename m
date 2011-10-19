From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/9] cifs: cleanup and overhaul of the receive codepath (try #4)
Date: Wed, 19 Oct 2011 09:16:50 -0400
Message-ID: <1319030219-3811-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset represents the remainder of the patches that Steve hasn't
committed yet. The reason for the respin is to incorporate some review
comments by Pavel and to respin for conflicts due to other patches that
have been merged into Steve's tree.

The differences are pretty minor:

1) fix the function name in the comment on kvec_array_init.

2) make the patch that adds readv_from_socket use a GFP_NOFS allocation.
This was fixed in a later patch, but there could be problems bisecting
without that change.

3) The unnecessary reset of the "malformed" variable in handle_mid has
been removed

Other than that, this patchset is essentially the same as before. These
are also available in the cifs-3.2 branch of my git tree on
git.samba.org:

    http://git.samba.org/?p=jlayton/linux.git;a=summary

Jeff Layton (9):
  cifs: turn read_from_socket into a wrapper around a vectorized
    version
  cifs: keep a reusable kvec array for receives
  cifs: add a third receive phase to cifs_demultiplex_thread
  cifs: move mid finding into separate routine
  cifs: eliminate is_multi_rsp parm to find_cifs_mid
  cifs: move buffer pointers into TCP_Server_Info
  cifs: find mid earlier in receive codepath
  cifs: break out 3rd receive phase into separate function
  cifs: add a callback function to receive the rest of the frame

 fs/cifs/cifsglob.h  |   29 ++++-
 fs/cifs/cifsproto.h |    5 +-
 fs/cifs/cifssmb.c   |    5 +-
 fs/cifs/connect.c   |  370 +++++++++++++++++++++++++++++++++------------------
 fs/cifs/transport.c |    5 +-
 5 files changed, 275 insertions(+), 139 deletions(-)

-- 
1.7.6.4
