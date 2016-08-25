From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCHv2 0/6] cifs.upcall: cleanup and overhaul of the cifs.upcall krb5 handling code
Date: Thu, 25 Aug 2016 10:17:39 -0400
Message-ID: <1472134665-4014-1-git-send-email-jlayton@samba.org>
Cc: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This is an update of the patchset that I posted to linux-cifs mailing
list last week, with the main change being a few extra cleanups to
the code, to make it a bit more efficient. This also removes a large
chunk of (largely unneeded) code from the program.

Only lightly tested so far, but it seems to do the right thing. The
main assumption here is that no one actually relies on the code to
scan /tmp for credcaches, and that we should just rely on krb5.conf to
tell us where they are.

While this is a step in the right direction, what I think we might
want to do longer-term is to make this use gss_init_sec_context
instead of micromanaging it like we do now. The only part I'm a
little unclear on is how to extract the session key in that case.

Comments welcome!

Jeff Layton (6):
  aclocal: fix typo in idmap.m4
  cifs.upcall: use krb5 routines to get default ccname
  cifs.upcall: make the krb5_context a static global variable
  cifs.upcall: remove KRB5_TC_OPENCLOSE
  cifs.upcall: make get_tgt_time take a ccache arg
  cifs.upcall: stop passing around ccache name strings

 aclocal/idmap.m4 |   2 +-
 cifs.upcall.c    | 266 +++++++++++++------------------------------------------
 2 files changed, 61 insertions(+), 207 deletions(-)

-- 
2.7.4
