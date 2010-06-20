From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/6] cifs: session matching and authentication fixes and cleanups
Date: Sun, 20 Jun 2010 17:10:45 -0400
Message-ID: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset does some cleanup and fixes a number of bugs related to
the handling of the TCP_Server_Info->secType. It also adds a bit of code
to allow the userspace mount helper to use the krb5 credcache for the
real user doing the mount instead of the one given by the uid= option.

This is a more incremental change from the previous patchsets that I
proposed for this. In most of those, I moved the secType field to the
cifsSesInfo struct. While I still think that's a better approach, it's
very difficult to do for a couple of reasons:

- the NTLMSSP auth code is broken, so we can't unconditionally set the
  extended security bit in the session setup code yet.

- there is apparent need to allow for multiple sec= mount options.
  Unfortunately, the rules for how that's supposed to work are not at
  all clear to me. I decided it was safer to leave the existing code
  that sets the secType as untouched as possible.

I see these patches as 2.6.36 material. They are also required for the
multisession mount patchset. They're also in the cifs-2.6.36 branch of
my kernel.org git tree as well if it's easier to pull from there.

Comments and suggestions welcome.

Jeff Layton (6):
  cifs: have cifs_convert_address set port
  cifs: move address comparison into separate function
  cifs: match secType when searching for existing tcp session
  cifs: clean up cifs_find_smb_ses
  cifs: remove unused cifsUidInfo struct
  cifs: add separate cred_uid field to sesInfo

 fs/cifs/cifs_spnego.c |    3 +
 fs/cifs/cifsglob.h    |   24 +------
 fs/cifs/cifsproto.h   |    3 +-
 fs/cifs/connect.c     |  161 ++++++++++++++++++++++++++++++++++---------------
 fs/cifs/dns_resolve.c |    2 +-
 fs/cifs/netmisc.c     |    5 +-
 6 files changed, 125 insertions(+), 73 deletions(-)
