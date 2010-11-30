From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cifs: fix parsing of hostname in dfs referrals
Date: Tue, 30 Nov 2010 15:14:48 -0500
Message-ID: <1291148088-18710-1-git-send-email-jlayton@redhat.com>
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robbert-C1IQQP51G3M@public.gmane.org, wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
	dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

The DFS referral parsing code does a memchr() call to find the '\\'
delimiter that separates the hostname in the referral UNC from the
sharename. It then uses that value to set the length of the hostname via
pointer subtraction.  Instead of subtracting the start of the hostname
however, it subtracts the start of the UNC, which causes the code to
pass in a hostname length that is 2 bytes too long.

Regression introduced in commit 1a4240f4.

Reported-and-Tested-by: Robbert Kouprie <robbert-C1IQQP51G3M@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Wang Lei <wang840925-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
---
 fs/cifs/dns_resolve.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/cifs/dns_resolve.c b/fs/cifs/dns_resolve.c
index 0eb8702..548f062 100644
--- a/fs/cifs/dns_resolve.c
+++ b/fs/cifs/dns_resolve.c
@@ -66,7 +66,7 @@ dns_resolve_server_name_to_ip(const char *unc, char **ip_addr)
 	/* Search for server name delimiter */
 	sep = memchr(hostname, '\\', len);
 	if (sep)
-		len = sep - unc;
+		len = sep - hostname;
 	else
 		cFYI(1, "%s: probably server name is whole unc: %s",
 		     __func__, unc);
-- 
1.7.3.2
