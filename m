From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH 0/3] cifs-utils: overhaul of cifs.upcall krb5 handling
Date: Mon, 22 Aug 2016 08:29:19 -0400
Message-ID: <1471868962-7312-1-git-send-email-jlayton@samba.org>
Cc: "Dey, John F" <jfdey-rEd9KcVInK8dYYaOPf09RA@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The handling of krb5 in cifs.upcall has always been pretty klunky. It
rolls through /tmp, trying to find the latest credcache and has some
hacks to allow it to use DIR: caches as well, but none of that really
works for KEYRING:, which is pretty common these days.

In practice, I doubt anyone relies on that behavior. What most people
want is for cifs.upcall to find the default credcache for a user given
krb5.conf -- full stop.

This patchset rips out most of the unneeded machinery in cifs.upcall,
and just has it find the default credcache and verify that it has a
valid TGT. If not then we'll try to init it from the keytab as before.

I think there's some more opportunity to clean up this code in the
future as well. Currently we pass around strings that represent the
credcache, and that could be made more efficient.  It might also be
good to just reimplement the whole thing with gssapi calls instead.

Still, this is a good step in that direction I think.

Jeff Layton (3):
  aclocal: fix typo in idmap.m4
  cifs.upcall: use krb5 routines to get default ccname
  cifs.upcall: make the krb5_context a static global variable

 aclocal/idmap.m4 |   2 +-
 cifs.upcall.c    | 185 ++++++++++---------------------------------------------
 2 files changed, 32 insertions(+), 155 deletions(-)

-- 
2.7.4
