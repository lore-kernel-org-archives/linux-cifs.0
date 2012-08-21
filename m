From: Nalin Dahyabhai <nalin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Finding krb5 ccaches of new types in new locations
Date: Tue, 21 Aug 2012 18:54:43 -0400
Message-ID: <20120821225443.GG9511@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

One of the things we're currently trying to do for Fedora 18 is to move
user credential caches from being files ("FILE" ccaches) in /tmp to
being subdirectories ("DIR" ccaches) under /run/user/${UID}.  To be very
specific, we'd go from using one of:
  FILE:/tmp/krb5cc_${UID}
  FILE:/tmp/krb5cc_${UID}_XXXXXX
to possibly using one of those, and possibly also any of these:
  DIR:/run/user/${UID}/krb5cc
  DIR:/run/user/${UID}/krb5cc_XXXXXX
  FILE:/run/user/${UID}/krb5cc
  FILE:/run/user/${UID}/krb5cc_XXXXXX
  DIR:/tmp/krb5cc_${UID}
  DIR:/tmp/krb5cc_${UID}_XXXXXX

Some would be more likely than others, but my goal here is to make sure
that cifs.upcall can find credentials in these other locations.  I'll
reply to this with suggested patches.

Thanks,

Nalin
