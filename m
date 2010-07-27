From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 2/4] mtab: add __attribute__((unused)) to unused variables
Date: Tue, 27 Jul 2010 15:37:05 -0400
Message-ID: <1280259427-14617-3-git-send-email-jlayton@samba.org>
References: <1280259427-14617-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280259427-14617-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...to silence -Wextra warnings.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 mtab.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mtab.c b/mtab.c
index 70789bc..de1aabd 100644
--- a/mtab.c
+++ b/mtab.c
@@ -51,12 +51,12 @@ static int lockfile_fd = -1;
 static int signals_have_been_setup = 0;
 
 static void
-handler (int sig) {
+handler (int sig __attribute__((unused))) {
      exit(EX_USER);
 }
 
 static void
-setlkw_timeout (int sig) {
+setlkw_timeout (int sig __attribute__((unused))) {
      /* nothing, fcntl will fail anyway */
 }
 
-- 
1.7.1.1
