From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 0/4] cifs-utils: add -Wextra to CFLAGS and fix up warnings
Date: Tue, 27 Jul 2010 15:37:03 -0400
Message-ID: <1280259427-14617-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patchset adds the -Wextra flag to CFLAGS and fixes up some of the
warnings that that generates. There are still some others that I'm
not sure how best to fix yet.

Jeff Layton (4):
  automake: add -Wextra to CFLAGS
  mtab: add __attribute__((unused)) to unused variables
  cifs.upcall: swap c99 initializers for memset calls
  data_blob: change for loop indices to a unsigned int

 Makefile.am   |    2 +-
 cifs.upcall.c |    8 ++++++--
 data_blob.c   |    4 ++--
 mtab.c        |    4 ++--
 4 files changed, 11 insertions(+), 7 deletions(-)
