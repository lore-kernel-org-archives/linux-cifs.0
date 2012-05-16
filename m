From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix misspelling of "forcedirectio"
Date: Wed, 16 May 2012 07:10:26 -0400
Message-ID: <1337166626-17966-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/connect.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 5dcc551..08c9ece 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -164,7 +164,7 @@ static const match_table_t cifs_mount_option_tokens = {
 	{ Opt_sign, "sign" },
 	{ Opt_seal, "seal" },
 	{ Opt_direct, "direct" },
-	{ Opt_direct, "forceddirectio" },
+	{ Opt_direct, "forcedirectio" },
 	{ Opt_strictcache, "strictcache" },
 	{ Opt_noac, "noac" },
 	{ Opt_fsc, "fsc" },
-- 
1.7.7.6
