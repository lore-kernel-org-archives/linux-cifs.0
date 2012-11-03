From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 00/17] cifs-utils: userspace getcifsacl/setcifsacl/cifs.idmap
Date: Sat,  3 Nov 2012 08:50:17 -0400
Message-ID: <1351947034-18876-1-git-send-email-jlayton@samba.org>
Cc: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset represents a number of fixes to the userspace getcifsacl,
setcifsacl, and cifs.idmap tools. I *think* that with this set, the
tools should now work properly on big-endian machines, but that still
needs testing.

Jeff Layton (17):
  setcifsacl: clean up sizing of cifs_sid
  setcifsacl: fix overrun of subauths array when copying SIDs
  setcifsacl: clean up get_numfaces
  get/setcifsacl: set "prog" via basename(argv[0])
  setcifsacl: declare an enum for the action values
  setcifsacl: fix up getopt() usage
  cifsacl: header file cleanup
  setcifsacl: fix endianness on SIDs provided by winbind routines
  cifs.idmap: fix endianness on SIDs before sending to kernel
  setcifsacl: fix up endianness conversions
  setcifsacl: clean up get_numcaces
  setcifsacl: clean up parse_cmdline_aces
  setcifsacl: fix verify_ace_sid
  getcifsacl: clarify magic number if print_ace
  getcifsacl: fix endianness before handing off SID to winbind
  getcifsacl: don't use wbcDomainSid internally
  getcifsacl: fix raw SID printing routine

 cifs.idmap.c |  23 +++++-
 cifsacl.h    |  22 +++---
 getcifsacl.c |  72 +++++++++++++------
 setcifsacl.1 |   4 ++
 setcifsacl.c | 230 ++++++++++++++++++++++++++++++-----------------------------
 5 files changed, 204 insertions(+), 147 deletions(-)

-- 
1.7.11.7
