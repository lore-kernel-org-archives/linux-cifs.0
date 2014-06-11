From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/2] xfstests: add cifs.ko server-side copy helper
Date: Wed, 11 Jun 2014 16:05:42 +0200
Message-ID: <1402495544-12865-1-git-send-email-ddiss@suse.de>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

In preparation for adding cifs.ko support to xfstests, this patch series
extends the cloner binary to support SMB2 server-side copies via
CIFS_IOC_COPYCHUNK_FILE, in addition to the existing Btrfs COW clone
functionality.

This could be split into a separate binary if deemed necessary, but
given the code overlap, I though it suitable to share the same source.

Feedback appreciated.

--

David Disseldorp (2):
      src/cloner: check filesystem type
      src/cloner: add CIFS_IOC_COPYCHUNK_FILE support

 configure.ac |   1 +
 src/cloner.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 114 insertions(+), 10 deletions(-)
