From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] resolve_host: silence compiler warning about discarding const qualifier
Date: Wed, 23 Nov 2011 07:33:28 -0500
Message-ID: <1322051608-18427-1-git-send-email-jlayton@samba.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

...don't use "ipaddr" here since it's a const pointer.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 resolve_host.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/resolve_host.c b/resolve_host.c
index 69859a3..17cbd10 100644
--- a/resolve_host.c
+++ b/resolve_host.c
@@ -70,8 +70,7 @@ int resolve_host(const char *host, char *addrstr)
 
 			if (sin6->sin6_scope_id) {
 				len = strnlen(tmpbuf, sizeof(tmpbuf));
-				ipaddr = tmpbuf + len;
-				snprintf(ipaddr, sizeof(tmpbuf) - len, "%%%u",
+				snprintf(tmpbuf + len, sizeof(tmpbuf) - len, "%%%u",
 					 sin6->sin6_scope_id);
 			}
 			break;
-- 
1.7.6.4
