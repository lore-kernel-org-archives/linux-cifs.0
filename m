From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: [PATCH] cifs: trivial doc fix: note setlease implemented
Date: Sat, 30 Oct 2010 17:06:21 -0400
Message-ID: <20101030210621.GD480@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Signed-off-by: J. Bruce Fields <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/TODO |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

I was grepping for setlease and noticed this.--b.

diff --git a/fs/cifs/TODO b/fs/cifs/TODO
index 5aff46c..355abcd 100644
--- a/fs/cifs/TODO
+++ b/fs/cifs/TODO
@@ -81,7 +81,7 @@ u) DOS attrs - returned as pseudo-xattr in Samba format (check VFAT and NTFS for
 
 v) mount check for unmatched uids
 
-w) Add support for new vfs entry points for setlease and fallocate 
+w) Add support for new vfs entry point for fallocate
 
 x) Fix Samba 3 server to handle Linux kernel aio so dbench with lots of 
 processes can proceed better in parallel (on the server)
-- 
1.7.1
