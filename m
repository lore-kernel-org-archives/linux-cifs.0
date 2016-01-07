From: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] mount.cifs: ignore x-* mount options
Date: Thu,  7 Jan 2016 11:02:49 +0100
Message-ID: <1452160969-16970-1-git-send-email-kzak@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jeffrey Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

x-* prefix is used for userspace mount options and it's pretty
commonly used to extend fstab configuration in systemd world (e.g.
x-systemd.automount). These options is necessary to ignored.

The command mount(8) does not pass x-* mount options to mount.<type>
helpers, but in some use-cases it's possible that the cifs helper reads
mount options from fstab or users directly call mount.cifs and copy & past
mount options, etc.

This patch marks all options prefixed by "x-" as OPT_IGNORE to make
things more robust for end-users. We already uses the same concept for
_netdev.

Signed-off-by: Karel Zak <kzak-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mount.cifs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mount.cifs.c b/mount.cifs.c
index 3535096..5c5734f 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -756,6 +756,8 @@ static int parse_opt_token(const char *token)
 		return OPT_BKUPGID;
 	if (strncmp(token, "nofail", 6) == 0)
 		return OPT_NOFAIL;
+	if (strncmp(token, "x-", 2) == 0)
+		return OPT_IGNORE;
 
 	return OPT_ERROR;
 }
-- 
2.4.3
