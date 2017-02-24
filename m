From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 0/8] cifs-utils: fix problems with credcaches with overridden process creds
Date: Fri, 24 Feb 2017 09:27:42 -0500
Message-ID: <20170224142750.4151-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, ssorce-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
        samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The main impetus for this set is patch #7, which is a one-liner. #8 may
be overkill, but I do think that it's the right approach, at least for
now.

In order to get all of this to build however, we need to eliminate the
unsetenv override in replace.h, or add a test for unsetenv. I chose the
former, so the real patches are preceded by a number of cleanup patches.

Jeff Layton (8):
  data_blob: remove need for replace.h
  spengo.c/asn1.c: remove need for replace.h
  cifs.upcall: remove need for replace.h
  replace.h: remove it
  treewide: Eliminate SAFE_FREE
  data_blob: Eliminate _PUBLIC_
  cifs.upcall: unset $KRB5CCNAME when creating new credcache from keytab
  cifs.upcall: don't do env scraping when uid is 0

 asn1.c           |   2 +-
 cifs.upcall.8.in |   5 +-
 cifs.upcall.c    |  56 +++--
 configure.ac     |   2 +-
 data_blob.c      |  11 +-
 data_blob.h      |  10 +-
 mount.cifs.c     |  16 +-
 replace.h        | 674 -------------------------------------------------------
 spnego.c         |   2 +-
 9 files changed, 64 insertions(+), 714 deletions(-)
 delete mode 100644 replace.h

-- 
2.9.3
