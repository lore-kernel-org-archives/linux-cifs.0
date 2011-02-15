From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] mount.cifs: fix handling of scopeid in resolve_host
Date: Tue, 15 Feb 2011 13:31:10 -0500
Message-ID: <1297794670-4345-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

We get a pointer to the end of the address string (ipaddr), but the cal=
l
snprintf and pass in tmpbuf which is a pointer to the beginning of the
address string. If someone passes in an address with a scopeid then we
end up overwriting the entire address string.

Reported-by: Bj=C3=B6rn JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 resolve_host.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/resolve_host.c b/resolve_host.c
index 7687503..69859a3 100644
--- a/resolve_host.c
+++ b/resolve_host.c
@@ -71,7 +71,7 @@ int resolve_host(const char *host, char *addrstr)
 			if (sin6->sin6_scope_id) {
 				len =3D strnlen(tmpbuf, sizeof(tmpbuf));
 				ipaddr =3D tmpbuf + len;
-				snprintf(tmpbuf, sizeof(tmpbuf) - len, "%%%u",
+				snprintf(ipaddr, sizeof(tmpbuf) - len, "%%%u",
 					 sin6->sin6_scope_id);
 			}
 			break;
--=20
1.7.4
