From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] autoconf: fix help message for --enable-cifsidmap
Date: Tue, 23 Aug 2011 09:03:23 -0400
Message-ID: <1314104603-3941-1-git-send-email-jlayton@samba.org>
Cc: pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org, shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It currently says "no" is the default, but it should be "yes".

Reported-by: Elias Pipping <pipping-N9AOi2cAC9ZBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 configure.ac |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/configure.ac b/configure.ac
index 780abe7..6a9ad75 100644
--- a/configure.ac
+++ b/configure.ac
@@ -24,7 +24,7 @@ AC_ARG_ENABLE(cifscreds,
 
 AC_ARG_ENABLE(cifsidmap,
 	[AC_HELP_STRING([--enable-cifsidmap],
-			[Create cifs.idmap binary @<:@default=no@:>@])],
+			[Create cifs.idmap binary @<:@default=yes@:>@])],
 	enable_cifsidmap=$enableval,
 	enable_cifsidmap="maybe")
 
-- 
1.7.6
