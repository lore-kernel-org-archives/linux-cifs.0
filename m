From: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/3] cifs: fix a few fscache issues
Date: Wed, 24 Nov 2010 17:49:04 +0530
Message-ID: <1290601147-11392-1-git-send-email-sjayaraman@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset fixes a couple of issues with fscache found by Jeff Layton. I
think these are straight-forward fixes and can be considered for next -rc.

Suresh Jayaraman (3):
   cifs: allow fsc mount option only if CONFIG_CIFS_FSCACHE is set
   cifs: enable fscache iff fsc mount option is used explicitly
   cifs: display fsc in /proc/mounts


 cifsfs.c  |    2 ++
 connect.c |    5 +++++
 fscache.c |   12 ++++++------
 3 files changed, 13 insertions(+), 6 deletions(-)
