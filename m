From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 0/2] cifs: CIFS_ENUMERATE_SNAPSHOTS fixes
Date: Wed,  3 May 2017 17:39:07 +0200
Message-ID: <20170503153909.5783-1-ddiss@suse.de>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

A couple of one line fixes for the new CIFS_ENUMERATE_SNAPSHOTS
functionality.

 fs/cifs/ioctl.c   | 2 ++
 fs/cifs/smb2ops.c | 1 +
 2 files changed, 3 insertions(+)
