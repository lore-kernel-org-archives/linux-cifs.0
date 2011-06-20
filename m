From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [OOPS] 3.0-rc1 cifs
Date: Mon, 20 Jun 2011 12:33:16 +0400
Message-ID: <1308558796-2693-1-git-send-email-piastryyy@gmail.com>
References: <201106152155.48167.maciej.rutecki@gmail.com>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201106152155.48167.maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Figured it out: it was broken by b946845a9dc523c759cae2b6a0f6827486c3221a commit - "cifs: cifs_parse_mount_options: do not tokenize mount options in-place". So, as a quick fix I suggest to apply this patch.

[PATCH] CIFS: Fix kfree() with constant string in a null user case

Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/cifs/connect.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 20c60dd..ad3de1c 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2887,7 +2887,11 @@ try_mount_again:
 
 	if (volume_info->nullauth) {
 		cFYI(1, "null user");
-		volume_info->username = "";
+		volume_info->username = kzalloc(1, GFP_KERNEL);
+		if (volume_info->username == NULL) {
+			rc = -ENOMEM;
+			goto out;
+		}
 	} else if (volume_info->username) {
 		/* BB fixme parse for domain name here */
 		cFYI(1, "Username: %s", volume_info->username);
-- 
1.7.1
