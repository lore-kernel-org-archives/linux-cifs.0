From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/5] cifs: clean up some unaligned memory accesses
Date: Tue, 18 Jan 2011 15:33:14 -0500
Message-ID: <1295382799-7902-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When the CIFS client is marshalling a call or parsing a response from
the server, it often will access fields within the packets directly.
It's easily possible however that those fields will not be aligned
properly. Many CPUs handle this transparently. Some CPUs (such as ia64)
throw a warning and then use a slow-path mechanism to deal with it.
Other CPUs (mostly the embedded ones, it seems) actually throw an
exception and just don't work.

For more background on the problem, see this file in the kernel source
tree:

    Documentation/unaligned-memory-access.txt

This was originally reported quite some time ago here:

    https://bugzilla.kernel.org/show_bug.cgi?id=11115

I've also had a report of the same problem on ia64 against RHEL5:

    https://bugzilla.redhat.com/show_bug.cgi?id=659715

My patchset is based on the one originally by John Voltz. His proposed
patch also patched up the generic NLS code for unaligned access, but I
took a different approach by making sure that we just never called into
those routines with an unaligned buffer.

I've tested this patchset on x86_64 and it seems to be fine. I've also
tested a version of this patchset backported to RHEL5 on ia64. Certain
tests would make that arch pop these sorts of printks:

    kernel unaligned access to 0xe0000040ed16807f, ip=0xa0000002029b8530

...with this set, those are eliminated. I suspect that this may also
help CIFS to work on some embedded arches as well (such as avr32).

Note that this is likely not a comprehensive fix for CIFS though. It
seems like there are a lot of places in cifssmb.c that access fields in
the request or response directly. Any of them are probably also fair
game for unaligned access fixes.

I think this patchset is pretty safe, so we should consider getting it
into 2.6.38 if possible. If not, definitely for 2.6.39.

Jeff Layton (5):
  cifs: use get/put_unaligned functions to access ByteCount
  cifs: clean up unaligned accesses in validate_t2
  cifs: fix unaligned access in check2ndT2 and coalesce_t2
  cifs: clean up unaligned accesses in cifs_unicode.c
  cifs: fix unaligned accesses in cifsConvertToUCS

 fs/cifs/cifs_unicode.c |  125 +++++++++++++++++++++++++++++++++++++++--------
 fs/cifs/cifspdu.h      |   47 ++++++++++++++++--
 fs/cifs/cifssmb.c      |   52 ++++++++++----------
 fs/cifs/connect.c      |   43 +++++++---------
 fs/cifs/misc.c         |   71 ---------------------------
 fs/cifs/netmisc.c      |    4 +-
 fs/cifs/sess.c         |   13 ++---
 fs/cifs/transport.c    |    9 ++--
 8 files changed, 202 insertions(+), 162 deletions(-)

-- 
1.7.3.4
