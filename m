From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH v3 0/4] cifs.upcall: allow cifs.upcall to scrape cache location initiating task's environment
Date: Wed, 15 Feb 2017 11:15:18 -0500
Message-ID: <20170215161522.17063-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Apologies for v3 series, I had some extra patches in there. This is
the one that should have been sent. Relabeled as v4 for clarity.

Third respin of this series. Reordered for better safety for bisecting.
The environment scraping is now on by default, but can be disabled with
"-E" in environments where it's not needed.

Also, I've added a patch to make cifs.upcall drop capabilities before
doing most of its work. This may help reduce the attack surface of the
program.

Jeff Layton (4):
  cifs.upcall: convert two flags from int to bool
  cifs.upcall: switch group IDs when handling an upcall
  cifs.upcall: drop capabilities early in program
  cifs.upcall: allow scraping of KRB5CCNAME out of initiating task's
    /proc/<pid>/environ file

 Makefile.am      |   2 +-
 cifs.upcall.8.in |   9 ++
 cifs.upcall.c    | 255 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 256 insertions(+), 10 deletions(-)

-- 
2.9.3
