From: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [PATCH] cifs.upcall.c: the exit code should be 0 when print version
Date: Fri, 17 May 2013 17:27:02 +0800
Message-ID: <1368782822-15039-1-git-send-email-penght@cn.fujitsu.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

When print version number, the exit code should be 0
and syslog() should not send "Negating key" to the system logger.

Signed-off-by: Peng Haitao <penght-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
---
 cifs.upcall.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 12d5900..6c0b9de 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -857,6 +857,7 @@ int main(const int argc, char *const argv[])
 			legacy_uid++;
 			break;
 		case 'v':
+			rc = 0;
 			printf("version: %s\n", VERSION);
 			goto out;
 		default:
-- 
1.8.1.4
