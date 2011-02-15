From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix handling of scopeid in cifs_convert_address
Date: Tue, 15 Feb 2011 13:54:56 -0500
Message-ID: <1297796096-5162-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The code finds, the '%' sign in an ipv6 address and copies that to a
buffer allocated on the stack. It then ignores that buffer, and passes
'pct' to simple_strtoul(), which doesn't work right because we're
comparing 'endp' against a completely different string.

=46ix it by passing the correct pointer. While we're at it, this is a
good candidate for conversion to strict_strtoul as well.

Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Bj=C3=B6rn JACKE <bj-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/cifs/netmisc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index 8d9189f..79f641e 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -170,7 +170,7 @@ cifs_convert_address(struct sockaddr *dst, const ch=
ar *src, int len)
 {
 	int rc, alen, slen;
 	const char *pct;
-	char *endp, scope_id[13];
+	char scope_id[13];
 	struct sockaddr_in *s4 =3D (struct sockaddr_in *) dst;
 	struct sockaddr_in6 *s6 =3D (struct sockaddr_in6 *) dst;
=20
@@ -197,9 +197,9 @@ cifs_convert_address(struct sockaddr *dst, const ch=
ar *src, int len)
 		memcpy(scope_id, pct + 1, slen);
 		scope_id[slen] =3D '\0';
=20
-		s6->sin6_scope_id =3D (u32) simple_strtoul(pct, &endp, 0);
-		if (endp !=3D scope_id + slen)
-			return 0;
+		rc =3D strict_strtoul(scope_id, 0,
+					(unsigned long *)&s6->sin6_scope_id);
+		rc =3D (rc =3D=3D 0) ? 1 : 0;
 	}
=20
 	return rc;
--=20
1.7.4
