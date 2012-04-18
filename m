From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH v2] docs: update to project resources in README
Date: Wed, 18 Apr 2012 14:50:08 -0400
Message-ID: <1334775008-26511-1-git-send-email-jlayton@samba.org>
Cc: piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org, jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, sjayaraman-IBi9RG/b67k@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...and add Igor Druzhinin and Pavel Shilovsky to AUTHORS. Also, change
the "Maintainer:" field to point to me directly, and clarify that
make install should be run as root.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 AUTHORS |    2 ++
 README  |    8 ++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/AUTHORS b/AUTHORS
index 7a7fa87..2807079 100644
--- a/AUTHORS
+++ b/AUTHORS
@@ -3,5 +3,7 @@ Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Igor Mammedov <niallain-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
+Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
+Igor Druzhinin <jaxbrigs-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
 
 ...and others.
diff --git a/README b/README
index 619dc3f..3e311a5 100644
--- a/README
+++ b/README
@@ -5,10 +5,10 @@ separate package.
 
 0. PROJECT RESOURCES
 
-    Home page: http://linux-cifs.samba.org/cifs-utils/
-    Mailing list: linux-cifs-client-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
-    Maintainer: cifs-utils-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
+    Home page: http://wiki.samba.org/index.php/LinuxCIFS_utils
+    Mailing list: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
     Git Repository: git://git.samba.org/cifs-utils.git
+    Maintainer: Jeffrey Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
 
 1. COMPILING
 
@@ -24,6 +24,6 @@ and run these commands:
     $ ./configure
     $ make
 
-To install binaries and documentation, run this:
+To install binaries and documentation, run this (as root):
 
     # make install
-- 
1.7.7.6
