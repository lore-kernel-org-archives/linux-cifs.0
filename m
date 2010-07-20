From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH 2/4] Implement a DNS Resolver Module
Date: Tue, 20 Jul 2010 16:42:11 +0100
Message-ID: <31115.1279640531@redhat.com>
References: <20100720112506.7f7cfe1d@tlielax.poochiereds.net> <20100707091400.16573.2817.stgit@warthog.procyon.org.uk> <20100707091411.16573.81747.stgit@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, smfrench@gmail.com,
	linux-cifs@vger.kernel.org, linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, Wang Lei <wang840925@gmail.com>
To: Jeff Layton <jlayton@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100720112506.7f7cfe1d@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Jeff Layton <jlayton@redhat.com> wrote:

> Another (somewhat minor) nit that Steve F pointed out. The function
> that this replaces in cifs can deal with numeric scopeid's as part of
> the address. For instance:
> 
>     fea1::1%2
> 
> ...where the scopeid here is "2". For linux machines, the scopeid
> essentially equates to an interface index and really has no meaning
> outside of the machine.
> 
> It's not clear to me that we'd ever see one of those in a hostname that
> we want to parse here, but it might not hurt to plan for it and deal
> with it appropriately.

Yeah.  I'm just looking at fixing cifs_convert_address() to take a length and
pass it down so that that can be used instead (and it can take a const pointer
to the address to be parsed).  It's a shame that simple_strtoul() and the like
assume NUL-terminated strings.

See the attached patch to cifs_convert_address().

David
---
diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
index d35d528..a95d3fb 100644
--- a/fs/cifs/netmisc.c
+++ b/fs/cifs/netmisc.c
@@ -139,17 +139,18 @@ static const struct smb_to_posix_error mapping_table_ERRHRD[] = {
  * Returns 0 on failure.
  */
 static int
-cifs_inet_pton(const int address_family, const char *cp, void *dst)
+cifs_inet_pton(const int address_family, const char *cp, int len, void *dst)
 {
 	int ret = 0;
 
 	/* calculate length by finding first slash or NULL */
 	if (address_family == AF_INET)
-		ret = in4_pton(cp, -1 /* len */, dst, '\\', NULL);
+		ret = in4_pton(cp, len, dst, '\\', NULL);
 	else if (address_family == AF_INET6)
-		ret = in6_pton(cp, -1 /* len */, dst , '\\', NULL);
+		ret = in6_pton(cp, len, dst , '\\', NULL);
 
-	cFYI(DBG2, "address conversion returned %d for %s", ret, cp);
+	cFYI(DBG2, "address conversion returned %d for %*.*s",
+	     ret, len, len, cp);
 	if (ret > 0)
 		ret = 1;
 	return ret;
@@ -164,37 +165,39 @@ cifs_inet_pton(const int address_family, const char *cp, void *dst)
  * Returns 0 on failure.
  */
 int
-cifs_convert_address(char *src, void *dst)
+cifs_convert_address(const char *src, int len, void *dst)
 {
-	int rc;
-	char *pct, *endp;
+	int rc, alen, slen;
+	const char *pct;
+	char *endp, scope_id[13];
 	struct sockaddr_in *s4 = (struct sockaddr_in *) dst;
 	struct sockaddr_in6 *s6 = (struct sockaddr_in6 *) dst;
 
 	/* IPv4 address */
-	if (cifs_inet_pton(AF_INET, src, &s4->sin_addr.s_addr)) {
+	if (cifs_inet_pton(AF_INET, src, len, &s4->sin_addr.s_addr)) {
 		s4->sin_family = AF_INET;
 		return 1;
 	}
 
-	/* temporarily terminate string */
-	pct = strchr(src, '%');
-	if (pct)
-		*pct = '\0';
-
-	rc = cifs_inet_pton(AF_INET6, src, &s6->sin6_addr.s6_addr);
-
-	/* repair temp termination (if any) and make pct point to scopeid */
-	if (pct)
-		*pct++ = '%';
+	/* attempt to exclude the scope ID from the address part */
+	pct = memchr(src, '%', len);
+	alen = pct ? pct - src : len;
 
+	rc = cifs_inet_pton(AF_INET6, src, alen, &s6->sin6_addr.s6_addr);
 	if (!rc)
 		return rc;
 
 	s6->sin6_family = AF_INET6;
 	if (pct) {
+		/* grab the scope ID */
+		slen = len - (alen + 1);
+		if (slen <= 0 || slen > 12)
+			return 0;
+		memcpy(scope_id, pct + 1, slen);
+		scope_id[slen] = '\0';
+
 		s6->sin6_scope_id = (u32) simple_strtoul(pct, &endp, 0);
-		if (!*pct || *endp)
+		if (endp != scope_id + slen)
 			return 0;
 	}
 
