From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 0/3] cifs: neatening and embedded module size reduction
Date: Thu, 29 Nov 2012 11:37:17 -0800
Message-ID: <cover.1354217746.git.joe@perches.com>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Joe Perches (3):
  cifs: Remove unused cEVENT macro
  cifs: Make CIFS_DEBUG possible to undefine
  cifs: Enable Kconfig control of CIFS_DEBUG

 fs/cifs/Kconfig      |   10 ++++++-
 fs/cifs/cifs_debug.h |   74 +++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 31 deletions(-)

-- 
1.7.8.112.g3fd21
