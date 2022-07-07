Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1120DC43334
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jul 2022 19:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236507AbiGGTPY (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiGGTPX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jul 2022 15:15:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E7E3337E
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jul 2022 12:15:19 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8E9441FDB1;
        Thu,  7 Jul 2022 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657221318; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ueyh7rTlGmi7UrB+hxUn7ZyHAmqiSK/OMUlb7vJq4A4=;
        b=xBhea4ATOnyPNEwm0mv20X29MR3vNdEPaSdCNXP20YvOXWWcT1iijS9WeUmSwg4LkHmvIE
        kurzxK/Tsi1orLyojaOX1DD6rbgM501zkh+nzh/1UFA+03/c3yzr2b5AvmhDiHkVFRcyZj
        jp87OCuxlPT1Bdw6eWXQYD8AvYMUZ7g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657221318;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ueyh7rTlGmi7UrB+hxUn7ZyHAmqiSK/OMUlb7vJq4A4=;
        b=isEHcfnfxwR6jRhW+LqF46GDAhWD24VVFj6skeU089NcJpWPVJWXVID02siQEs0+9IMpxc
        AWWdh/Zi4RUmIpAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8DC0313461;
        Thu,  7 Jul 2022 19:15:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lmRPFMUwx2LuIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 07 Jul 2022 19:15:17 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     dhowells@redhat.com
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 1/3] key.dns: create a common DNS interface
Date:   Thu,  7 Jul 2022 16:15:05 -0300
Message-Id: <20220707191507.2013-2-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220707191507.2013-1-ematsumiya@suse.de>
References: <20220707191507.2013-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This commit merges all the common DNS functionalities into
key.dns.{h,c}.

The main function exposed by this API is the dns_resolver() function,
that will resolve the desired hostname. There's a second exposed function
afs_lookup_VL_servers() for querying AFSDB records, but will use
dns_resolver() internally as well.

Some refactor to the imported exsiting code was also done:
- dns_resolver() now uses only libresolv functions, pulling away
  getaddrinfo() as it didn't provid no other information aside
  from the resolved IP address (e.g. it's now possible to get the
  TTL from the DNS record for any of query type)
- better error handling and rework on error logging
- reduced number of globals, such as key expiry, payload buffer, etc
- simplify the code from the caller modules

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 Makefile           |   6 +-
 dns.afsdb.c        | 348 +++++---------------
 key.dns.c          | 794 +++++++++++++++++++++++++++++++++++++++++++++
 key.dns.h          | 255 ++++++++++++---
 key.dns_resolver.c | 490 +++++++---------------------
 5 files changed, 1207 insertions(+), 686 deletions(-)
 create mode 100644 key.dns.c

diff --git a/Makefile b/Makefile
index 599b1452a05a..80d82e538a48 100644
--- a/Makefile
+++ b/Makefile
@@ -159,12 +159,14 @@ keyctl_watch.o: watch_queue.h
 request-key: request-key.o $(LIB_DEPENDENCY)
 	$(CC) -L. $(CFLAGS) $(LDFLAGS) $(RPATH) -o $@ $< -lkeyutils
 
-key.dns_resolver: key.dns_resolver.o dns.afsdb.o $(LIB_DEPENDENCY)
+key.dns_resolver: key.dns_resolver.o dns.afsdb.o key.dns.h key.dns.o $(LIB_DEPENDENCY)
 	$(CC) -L. $(CFLAGS) $(LDFLAGS) $(RPATH) -o $@ \
-		key.dns_resolver.o dns.afsdb.o -lkeyutils -lresolv
+		key.dns_resolver.o dns.afsdb.o key.dns.o \
+		-lkeyutils -lresolv
 
 key.dns_resolver.o: key.dns_resolver.c key.dns.h
 dns.afsdb.o: dns.afsdb.c key.dns.h
+key.dns.o: key.dns.c key.dns.h
 
 ###############################################################################
 #
diff --git a/dns.afsdb.c b/dns.afsdb.c
index 986c0f385a1a..2241cf58e55c 100644
--- a/dns.afsdb.c
+++ b/dns.afsdb.c
@@ -38,296 +38,100 @@
 #include "key.dns.h"
 
 /*
- *
- */
-static void afsdb_hosts_to_addrs(ns_msg handle, ns_sect section)
-{
-	char *vllist[MAX_VLS];	/* list of name servers	*/
-	int vlsnum = 0;		/* number of name servers in list */
-	int rrnum;
-	ns_rr rr;
-	int subtype, i, ret;
-	unsigned int ttl = UINT_MAX, rr_ttl;
-
-	debug("AFSDB RR count is %d", ns_msg_count(handle, section));
-
-	/* Look at all the resource records in this section. */
-	for (rrnum = 0; rrnum < ns_msg_count(handle, section); rrnum++) {
-		/* Expand the resource record number rrnum into rr. */
-		if (ns_parserr(&handle, section, rrnum, &rr)) {
-			_error("ns_parserr failed : %m");
-			continue;
-		}
-
-		/* We're only interested in AFSDB records */
-		if (ns_rr_type(rr) == ns_t_afsdb) {
-			vllist[vlsnum] = malloc(MAXDNAME);
-			if (!vllist[vlsnum])
-				error("Out of memory");
-
-			subtype = ns_get16(ns_rr_rdata(rr));
-
-			/* Expand the name server's domain name */
-			if (ns_name_uncompress(ns_msg_base(handle),
-					       ns_msg_end(handle),
-					       ns_rr_rdata(rr) + 2,
-					       vllist[vlsnum],
-					       MAXDNAME) < 0)
-				error("ns_name_uncompress failed");
-
-			rr_ttl = ns_rr_ttl(rr);
-			if (ttl > rr_ttl)
-				ttl = rr_ttl;
-
-			/* Check the domain name we've just unpacked and add it to
-			 * the list of VL servers if it is not a duplicate.
-			 * If it is a duplicate, just ignore it.
-			 */
-			for (i = 0; i < vlsnum; i++)
-				if (strcasecmp(vllist[i], vllist[vlsnum]) == 0)
-					goto next_one;
-
-			/* Turn the hostname into IP addresses */
-			ret = dns_resolver(vllist[vlsnum], NULL);
-			if (ret) {
-				debug("AFSDB RR can't resolve."
-				      "subtype:%d, server name:%s, netmask:%u",
-				      subtype, vllist[vlsnum], mask);
-				goto next_one;
-			}
-
-			info("AFSDB RR subtype:%d, server name:%s, ip:%*.*s, ttl:%u",
-			     subtype, vllist[vlsnum],
-			     (int)payload[payload_index - 1].iov_len,
-			     (int)payload[payload_index - 1].iov_len,
-			     (char *)payload[payload_index - 1].iov_base,
-			     ttl);
-
-			/* prepare for the next record */
-			vlsnum++;
-			continue;
-
-		next_one:
-			free(vllist[vlsnum]);
-		}
-	}
-
-	key_expiry = ttl;
-	info("ttl: %u", key_expiry);
-}
-
-/*
- *
- */
-static void srv_hosts_to_addrs(ns_msg handle, ns_sect section)
-{
-	char *vllist[MAX_VLS];	/* list of name servers	*/
-	int vlsnum = 0;		/* number of name servers in list */
-	int rrnum;
-	ns_rr rr;
-	int subtype, i, ret;
-	unsigned short pref, weight, port;
-	unsigned int ttl = UINT_MAX, rr_ttl;
-	char sport[8];
-
-	debug("SRV RR count is %d", ns_msg_count(handle, section));
-
-	/* Look at all the resource records in this section. */
-	for (rrnum = 0; rrnum < ns_msg_count(handle, section); rrnum++) {
-		/* Expand the resource record number rrnum into rr. */
-		if (ns_parserr(&handle, section, rrnum, &rr)) {
-			_error("ns_parserr failed : %m");
-			continue;
-		}
-
-		if (ns_rr_type(rr) == ns_t_srv) {
-			vllist[vlsnum] = malloc(MAXDNAME);
-			if (!vllist[vlsnum])
-				error("Out of memory");
-
-			subtype = ns_get16(ns_rr_rdata(rr));
-
-			/* Expand the name server's domain name */
-			if (ns_name_uncompress(ns_msg_base(handle),
-					       ns_msg_end(handle),
-					       ns_rr_rdata(rr) + 6,
-					       vllist[vlsnum],
-					       MAXDNAME) < 0) {
-				_error("ns_name_uncompress failed");
-				continue;
-			}
-
-			rr_ttl = ns_rr_ttl(rr);
-			if (ttl > rr_ttl)
-				ttl = rr_ttl;
-
-			pref   = ns_get16(ns_rr_rdata(rr));
-			weight = ns_get16(ns_rr_rdata(rr) + 2);
-			port   = ns_get16(ns_rr_rdata(rr) + 4);
-			info("rdata %u %u %u", pref, weight, port);
-
-			sprintf(sport, "+%hu", port);
-
-			/* Check the domain name we've just unpacked and add it to
-			 * the list of VL servers if it is not a duplicate.
-			 * If it is a duplicate, just ignore it.
-			 */
-			for (i = 0; i < vlsnum; i++)
-				if (strcasecmp(vllist[i], vllist[vlsnum]) == 0)
-					goto next_one;
-
-			/* Turn the hostname into IP addresses */
-			ret = dns_resolver(vllist[vlsnum], sport);
-			if (ret) {
-				debug("SRV RR can't resolve."
-				      "subtype:%d, server name:%s, netmask:%u",
-				      subtype, vllist[vlsnum], mask);
-				goto next_one;
-			}
-
-			info("SRV RR subtype:%d, server name:%s, ip:%*.*s, ttl:%u",
-			     subtype, vllist[vlsnum],
-			     (int)payload[payload_index - 1].iov_len,
-			     (int)payload[payload_index - 1].iov_len,
-			     (char *)payload[payload_index - 1].iov_base,
-			     ttl);
-
-			/* prepare for the next record */
-			vlsnum++;
-			continue;
-
-		next_one:
-			free(vllist[vlsnum]);
-		}
-	}
-
-	key_expiry = ttl;
-	info("ttl: %u", key_expiry);
-}
-
-/*
- * Look up an AFSDB record to get the VL server addresses.
+ * Instantiate the key.
  */
-static int dns_query_AFSDB(const char *cell)
+static int afs_instantiate(payload_t *payload, unsigned int ttl)
 {
-	int	response_len;		/* buffer length */
-	ns_msg	handle;			/* handle for response message */
-	union {
-		HEADER hdr;
-		u_char buf[NS_PACKETSZ];
-	} response;		/* response buffers */
-
-	debug("Get AFSDB RR for cell name:'%s'", cell);
-
-	/* query the dns for an AFSDB resource record */
-	response_len = res_query(cell,
-				 ns_c_in,
-				 ns_t_afsdb,
-				 response.buf,
-				 sizeof(response));
+	int ret = 0;
 
-	if (response_len < 0) {
-		/* negative result */
-		_nsError(h_errno, cell);
-		return -1;
+	/* set the key's expiry time from the minimum TTL encountered */
+	ret = keyctl_set_timeout(key, ttl);
+	if (ret) {
+		error("%s: keyctl_set_timeout: %m", __func__);
+		return ret;
 	}
 
-	if (ns_initparse(response.buf, response_len, &handle) < 0)
-		error("ns_initparse: %m");
-
-	/* look up the hostnames we've obtained to get the actual addresses */
-	afsdb_hosts_to_addrs(handle, ns_s_an);
+	/* instantiate the key */
+	ret = keyctl_instantiate_iov(key, payload->data, payload->index, 0);
+	if (ret)
+		error("%s: keyctl_instantiate: %m", __func__);
 
-	info("DNS query AFSDB RR results:%u ttl:%u", payload_index, key_expiry);
-	return 0;
+	return ret;
 }
 
 /*
- * Look up an SRV record to get the VL server addresses [RFC 5864].
+ * Lookup VL servers for AFS.
  */
-static int dns_query_VL_SRV(const char *cell)
+__attribute__((noreturn))
+void afs_lookup_VL_servers(const char *cell, char *options)
 {
-	int	response_len;		/* buffer length */
-	ns_msg	handle;			/* handle for response message */
-	union {
-		HEADER hdr;
-		u_char buf[NS_PACKETSZ];
-	} response;
-	char name[1024];
-
-	snprintf(name, sizeof(name), "_afs3-vlserver._udp.%s", cell);
-
-	debug("Get VL SRV RR for name:'%s'", name);
-
-	response_len = res_query(name,
-				 ns_c_in,
-				 ns_t_srv,
-				 response.buf,
-				 sizeof(response));
-
-	if (response_len < 0) {
-		/* negative result */
-		_nsError(h_errno, cell);
-		return -1;
+	payload_t *payload = NULL;
+	struct hostinfo host = { 0 };
+	char *vlsrv_name = NULL;
+	int ret = 0;
+
+	if (!cell)
+		error_ex("%s: missing hostname", __func__);
+
+	CALLOC_CHECK(vlsrv_name, 1, MAXDNAME);
+	snprintf(vlsrv_name, MAXDNAME, "_afs3-vlserver._udp.%s", cell);
+	STRNDUP_CHECK(host.hostname, vlsrv_name, strlen(vlsrv_name));
+	CALLOC_CHECK(payload, 1, sizeof(payload_t));
+
+	free(vlsrv_name);
+
+	host.af = AF_UNSPEC;
+	host.single_addr = true;
+
+	parse_opts(&host, options);
+
+	/*
+	 * Look up an SRV record to get the VL server addresses [RFC 5864].
+	 */
+	host.type = ns_t_srv;
+	ret = dns_resolver(&host, payload);
+	if (ret) {
+		free(host.hostname);
+		STRNDUP_CHECK(host.hostname, cell, strlen(cell));
+
+		/*
+		 * Look up an AFSDB record to get the VL server addresses.
+		 */
+		host.type = ns_t_afsdb;
+		ret = dns_resolver(&host, payload);
 	}
 
-	if (ns_initparse(response.buf, response_len, &handle) < 0)
-		error("ns_initparse: %m");
-
-	/* look up the hostnames we've obtained to get the actual addresses */
-	srv_hosts_to_addrs(handle, ns_s_an);
-
-	info("DNS query VL SRV RR results:%u ttl:%u", payload_index, key_expiry);
-	return 0;
-}
-
-/*
- * Instantiate the key.
- */
-static __attribute__((noreturn))
-void afs_instantiate(const char *cell)
-{
-	int ret;
-
-	/* set the key's expiry time from the minimum TTL encountered */
-	if (!debug_mode) {
-		ret = keyctl_set_timeout(key, key_expiry);
-		if (ret == -1)
-			error("%s: keyctl_set_timeout: %m", __func__);
+	if (ret || payload->index == 0) {
+		ret = get_err(0);
+		goto out_free;
 	}
 
-	/* handle a lack of results */
-	if (payload_index == 0)
-		nsError(NO_DATA, cell);
-
-	/* must include a NUL char at the end of the payload */
-	payload[payload_index].iov_base = "";
-	payload[payload_index++].iov_len = 1;
-	dump_payload();
+	dump_payload(payload);
+	info("Key timeout will be %ld seconds", host.ttl);
 
-	/* load the key with data key */
 	if (!debug_mode) {
-		ret = keyctl_instantiate_iov(key, payload, payload_index, 0);
-		if (ret == -1)
-			error("%s: keyctl_instantiate: %m", __func__);
+		unsigned int ttl;
+
+		/*
+		 * If TTL was set through the config file (key_expiry),
+		 * it takes precedence over the one from the DNS record (stored
+		 * in host.ttl).
+		 */
+		if (key_expiry > -1)
+			ttl = (unsigned int)key_expiry;
+		else if (host.ttl > -1)
+			ttl = (unsigned int)host.ttl;
+		else
+			/* Fallback to default value if dns_resolver() couldn't
+			 * get TTL for some reason */
+			ttl = DEFAULT_KEY_TTL;
+
+		ret = afs_instantiate(payload, ttl);
 	}
 
-	exit(0);
-}
-
-/*
- * Look up VL servers for AFS.
- */
-void afs_look_up_VL_servers(const char *cell, char *options)
-{
-	/* Is the IP address family limited? */
-	if (strcmp(options, "ipv4") == 0)
-		mask = INET_IP4_ONLY;
-	else if (strcmp(options, "ipv6") == 0)
-		mask = INET_IP6_ONLY;
-
-	if (dns_query_VL_SRV(cell) != 0)
-		dns_query_AFSDB(cell);
+out_free:
+	free_hostinfo(&host);
+	free(payload);
 
-	afs_instantiate(cell);
+	exit(ret);
 }
diff --git a/key.dns.c b/key.dns.c
new file mode 100644
index 000000000000..6390f3118a6e
--- /dev/null
+++ b/key.dns.c
@@ -0,0 +1,794 @@
+/*
+ * Common DNS resolving code for keyutils
+ *
+ * Copyright (c) 2022, SUSE LLC
+ * Author: Enzo Matsumiya <ematsumiya@suse.de>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ */
+#include "key.dns.h"
+
+#define clamp(x, lo, hi) (MIN(hi, MAX(x, lo)))
+
+static const int ns_errno_map[] = {
+	[0]			= ECONNREFUSED,
+	[HOST_NOT_FOUND]	= ENODATA,
+	[TRY_AGAIN]		= EAGAIN,
+	[NO_RECOVERY]		= ECONNREFUSED,
+	[NO_DATA]		= ENODATA,
+};
+static const int ns_errno_max = sizeof(ns_errno_map) / sizeof(ns_errno_map[0]);
+
+/*
+ * Returns -errno, @optval, -h_errno, or -1, in that order.
+ *
+ * Resets errno and h_errno to 0 unconditionally.
+ */
+int get_err(int optval)
+{
+	int ret = -1;
+
+	if (errno)
+		ret = -errno;
+	else if (optval)
+		ret = optval;
+	else if (h_errno >= ns_errno_max)
+		ret = -ECONNREFUSED;
+	else if (h_errno)
+		ret = -(ns_errno_map[h_errno]);
+
+	errno = h_errno = 0;
+	return ret;
+}
+
+const char *get_strerr(int optval)
+{
+	int opt = optval < 0 ? -optval : optval;
+
+	/* begin with h_errno here because it can be more descriptive for us */
+	if (h_errno)
+		return hstrerror(h_errno);
+	else if (errno)
+		return strerror(errno);
+	else if (opt)
+		return strerror(opt);
+
+	return "Unknown error";
+}
+
+void _log(FILE *f, int level, const char *fmt, ...)
+{
+	va_list va;
+
+	va_start(va, fmt);
+	if (isatty(2)) {
+		vfprintf(f, fmt, va);
+		fputc('\n', f);
+	} else {
+		vsyslog(level, fmt, va);
+	}
+	va_end(va);
+}
+
+/*
+ * Print nameserver error
+ *
+ * Error code is always h_errno (netdb.h) for these.
+ */
+void nsError(const char *hostname)
+{
+	if (isatty(2))
+		error("NS: %s: %s.", hostname, hstrerror(h_errno));
+	else
+		error("%s: %s", hostname, hstrerror(h_errno));
+}
+
+/*
+ * Print nameserver error and exit
+ */
+void nsError_ex(const char *hostname)
+{
+	unsigned timeout;
+	int ret, err;
+
+	nsError(hostname);
+
+	if (!debug_mode) {
+		if (h_errno >= ns_errno_max)
+			err = ECONNREFUSED;
+		else
+			err = ns_errno_map[h_errno];
+
+		switch (h_errno) {
+		case TRY_AGAIN:
+			timeout = 1;
+			break;
+		case 0:
+		case NO_RECOVERY:
+			timeout = 10;
+			break;
+		default:
+			timeout = 1 * 60;
+			break;
+		}
+
+		error("Reject the key with error %d", err);
+
+		ret = keyctl_reject(key, timeout, err, KEY_REQKEY_DEFL_DEFAULT);
+		if (ret == -1)
+			error_ex("keyctl_reject: %m");
+	}
+
+	exit(h_errno);
+}
+
+/*
+ * Dump the payload when debugging
+ */
+void dump_payload(payload_t *payload)
+{
+	size_t plen, n;
+	unsigned char *buf, *p;
+	int i;
+
+	plen = 0;
+	for (i = 0; i < payload->index; i++) {
+		n = payload->data[i].iov_len;
+		debug("seg[%d] size %zu", i, n);
+		plen += n;
+	}
+	if (plen == 0) {
+		info("Key instantiation data is empty");
+		return;
+	}
+
+	debug("payload len: %zu", plen);
+
+	CALLOC_CHECK(buf, 1, plen + 1);
+
+	p = buf;
+	for (i = 0; i < payload->index; i++) {
+		n = payload->data[i].iov_len;
+		memcpy(p, payload->data[i].iov_base, n);
+		p += n;
+	}
+
+	info("The key instantiation data is '%s'", buf);
+	free(buf);
+}
+
+static char *get_addr_str(int af, char *s, const void *data)
+{
+	switch (af) {
+	case AF_INET:
+		inet_ntop(AF_INET, data, s, INET_ADDRSTRLEN);
+		break;
+	case AF_INET6:
+		inet_ntop(AF_INET6, data, s, INET6_ADDRSTRLEN);
+		break;
+	default:
+		error("Invalid address family '%d'", af);
+		s = NULL;
+	}
+
+	return s;
+}
+
+/*
+ * "valid" for our cases
+ * ns_t_any is used to represent an "A/AAAA" query, i.e. both IPv4 and IPv6
+ * addresses must be queried
+ */
+static bool is_type_valid(ns_type type)
+{
+	switch(type) {
+	case ns_t_a:
+	case ns_t_aaaa:
+	case ns_t_any:
+	case ns_t_afsdb:
+	case ns_t_srv:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static inline bool is_type_resolvable(ns_type type)
+{
+	return (type == ns_t_a || type == ns_t_aaaa);
+}
+
+static bool can_resolve_host(hostinfo_t *host)
+{
+	bool afok = false, typeok = false;
+
+	if (!host)
+		return false;
+
+	switch (host->af) {
+	case AF_INET:
+	case AF_INET6:
+	case AF_UNSPEC:
+		afok = true;
+		break;
+	default:
+		afok = false;
+		break;
+	}
+
+	switch(host->type) {
+	case ns_t_a:
+	case ns_t_aaaa:
+	case ns_t_any:
+		typeok = true;
+		break;
+	default:
+		typeok = false;
+	}
+
+	return (afok && typeok);
+}
+
+static inline int ns2af(ns_type type)
+{
+	if (type == ns_t_a)
+		return AF_INET;
+	if (type == ns_t_aaaa)
+		return AF_INET6;
+
+	return AF_UNSPEC;
+}
+
+static inline void add_to_payload(payload_t *payload, void *data, size_t len)
+{
+	payload->data[payload->index].iov_base = data;
+	payload->data[payload->index].iov_len = len;
+	payload->index++;
+}
+
+/*
+ * Append an address to the payload segment list
+ */
+static void append_addr(char *addr, payload_t *payload)
+{
+	size_t len;
+	int i;
+
+	if (!addr) {
+		error("no address to append to payload");
+		return;
+	}
+
+	if (!payload) {
+		error("payload buffer is NULL, can't append addr '%s'", addr);
+		return;
+	}
+
+	len = strlen(addr);
+
+	debug("append '%s'", addr);
+
+	if (payload->index + 2 > MAX_PAYLOAD - 1) {
+		info("payload buffer is full, can't append addr '%s'", addr);
+		return;
+	}
+
+	/* do not append duplicate entry */
+	for (i = 0; i < payload->index; i++)
+		if (payload->data[i].iov_len == len &&
+		    memcmp(payload->data[i].iov_base, addr, len) == 0)
+			return;
+
+	if (payload->index != 0)
+		add_to_payload(payload, ",", 1);
+
+	add_to_payload(payload, (void *)strndup(addr, len), len);
+}
+
+/*
+ * Returns the smallest TTL from all targets.
+ */
+static long append_addrs(hostinfo_t **targets, int ntgts, payload_t *payload)
+{
+	int i;
+	long ttl = LONG_MAX;
+
+	for (i = 0; i < ntgts; i++) {
+		hostinfo_t *t = targets[i];
+		int n;
+
+		for (n = 0; n < t->naddrs; n++) {
+			if (t->port[0] != '\0')
+				strcat(t->addrs[n], t->port);
+			append_addr(t->addrs[n], payload);
+		}
+
+		dump_host(t);
+		ttl = MIN(ttl, t->ttl);
+	}
+
+	/* must include a NUL char at the end of the payload */
+	add_to_payload(payload, "", 1);
+
+	return ttl;
+}
+
+static inline bool is_host_dup(hostinfo_t *h1, hostinfo_t *h2)
+{
+	int len;
+
+	if (!h1 || !h2)
+		return false;
+
+	if (!h1->hostname || !h2->hostname)
+		return false;
+
+	len = MAX(strlen(h1->hostname), strlen(h2->hostname));
+	if (strncasecmp(h1->hostname, h2->hostname, len) != 0)
+		return false;
+
+	debug("dup host '%s'", h1->hostname);
+	return true;
+}
+
+/*
+ * Get maximum number of targets a record might have
+ */
+static int get_rr_count(ns_msg *handle)
+{
+	return ns_msg_count(*handle, ns_s_an);
+}
+
+static int get_rr_name(hostinfo_t *host, const unsigned char *rdata)
+{
+	int ret = 0;
+
+	CALLOC_CHECK(host->hostname, 1, MAXDNAME);
+
+	/* Expand the name server's domain name */
+	ret = ns_name_uncompress(ns_msg_base(*(host->handle)),
+				 ns_msg_end(*(host->handle)),
+				 rdata, host->hostname, MAXDNAME);
+	if (ret < 0) {
+		warn("ns_name_uncompress() failed: %m");
+		ret = get_err(-ENODATA);
+		return ret;
+	}
+
+	return 0;
+}
+
+/*
+ * Parses a resource record
+ */
+static int parse_rr(hostinfo_t *host, ns_rr rr)
+{
+	const unsigned char *rdata;
+	unsigned short prio, weight, port; /* for ns_t_srv */
+	int subtype = 0; /* for ns_t_afsdb */
+	ns_type rrtype;
+	int ret = 0;
+
+	if (!host)
+		return -EINVAL;
+
+	rrtype = ns_rr_type(rr);
+	rdata = ns_rr_rdata(rr);
+
+	/* increment rdata after reading each field, based on type */
+	switch (rrtype) {
+	case ns_t_afsdb:
+		NS_GET16(subtype, rdata);
+		debug("rdata: subtype=%d", subtype);
+		break;
+	case ns_t_srv:
+		NS_GET16(prio, rdata);
+		NS_GET16(weight, rdata);
+		NS_GET16(port, rdata);
+
+		snprintf(host->port, 10, "+%hu", port); // '+' + 8 + NUL
+
+		debug("rdata: prio=%u, weight=%u, port=%u",
+		      prio, weight, port);
+		break;
+	case ns_t_a:
+	case ns_t_aaaa:
+		if (host->naddrs == MAX_ADDRS) {
+			warn("Can't add more IP addresses (max '%d' reached)",
+			     MAX_ADDRS);
+			break;
+		}
+
+		CALLOC_CHECK(host->addrs[host->naddrs], 1, MAX_ADDR_LEN);
+		get_addr_str(ns2af(rrtype), host->addrs[host->naddrs], rdata);
+
+		debug("rdata: addr=%s", host->addrs[host->naddrs]);
+
+		host->naddrs++;
+		break;
+	default:
+		debug("invalid type '%s' (%d)", str_type(rrtype), rrtype);
+		return -EINVAL;
+	}
+
+	debug("rdata: type='%s' (%d), ttl=%d", str_type(rrtype), rrtype,
+	      ns_rr_ttl(rr));
+
+	host->type = rrtype;
+	host->ttl = ns_rr_ttl(rr);
+
+	if (!is_type_resolvable(rrtype))
+		ret = get_rr_name(host, rdata);
+
+	debug("rdata: hostname='%s'", host->hostname);
+
+	return ret;
+}
+
+/*
+ * Get host targets/cells for AFSDB and SRV records
+ *
+ * @host: host with queried handle
+ * @targets: array to store targets' information. Must be initialized and
+ *	     freed by caller.
+ * @maxn: Maximum number of targets we have available to process. It gets updated
+ *        when done parsing to the actual number of targets available.
+ *
+ * Non-unique info is copied from @host to each target. Targets with duplicate
+ * hostnames are discarded.
+ *
+ * Returns 0 on success, or -error otherwise.
+ */
+static int get_targets(hostinfo_t *host, hostinfo_t **targets, int *maxn)
+{
+	int n = 0; /* list index */
+	int i, ret;
+	ns_rr rr;
+
+	debug("Resource record count is %d", *maxn);
+
+	for (i = 0; i < *maxn; i++) {
+		hostinfo_t *target = NULL;
+
+		if (ns_parserr(host->handle, ns_s_an, i, &rr)) {
+			error("ns_parserr failed: %m");
+			continue;
+		}
+
+		CALLOC_CHECK(targets[n], 1, sizeof(hostinfo_t));
+		target = targets[n];
+
+		target->handle = host->handle; /* temp */
+		ret = parse_rr(target, rr);
+		if (ret)
+			goto out;
+
+		/* discard if duplicate */
+		for (i = 0; i < n; i++)
+			if (is_host_dup(targets[i], target))
+				goto next;
+
+		target->handle = NULL;
+		target->af = host->af;
+		target->single_addr = host->single_addr;
+
+		n++;
+		continue;
+next:
+		free_host(target);
+		target = NULL;
+	}
+
+	ret = 0;
+
+	if (n == 0) {
+		error("Failed to parse all records");
+		ret = -ENODATA;
+	}
+
+	*maxn = n;
+out:
+	return ret;
+}
+
+/*
+ * "resolves" a host as in: parses a host containing A/AAAA resource
+ * records, i.e. assumes @host::handle is allocated and is valid.
+ */
+static int resolve_host(hostinfo_t *host, int n)
+{
+	int i, ret = 0, err = 0;
+	ns_rr rr;
+
+	if (!host->handle)
+		return -ENODATA;
+
+	for (i = 0; i < n; i++) {
+		ns_type type;
+
+		if (ns_parserr(host->handle, ns_s_an, i, &rr)) {
+			error("ns_parserr failed: %m");
+			continue;
+		}
+
+		type = ns_rr_type(rr);
+		/* ignore resource records that doesn't contain IP addresses */
+		if (!is_type_resolvable(type)) {
+			debug("skipping unresolvable type '%s' (%d)",
+			      str_type(type), type);
+			err++;
+			continue;
+		}
+
+		ret = parse_rr(host, rr);
+		if (ret) {
+			warn("Failed to parse host '%s': %s", host->hostname,
+			     get_strerr(ret));
+			err++;
+			/* continue */
+		}
+	}
+
+	if (err >= n)
+		ret = -ENODATA;
+
+	return ret;
+}
+
+/*
+ * Makes the actual query
+ *
+ * @host: host info to query for
+ *
+ * Returns 0 on success and sets host->handle for resource record processing. 
+ * Returns -error otherwise.
+ *
+ * Caller is responsible for freeing the allocated handle in both cases.
+ */
+static int dns_query(hostinfo_t *host)
+{
+	res_state sp;
+	int ret, len;
+
+	if (!host)
+		return -EINVAL;
+
+	if (!is_type_valid(host->type))
+		return -EINVAL;
+
+	union {
+		HEADER hdr;
+		u_char buf[NS_PACKETSZ];
+	} answer; /* answer buffers */
+
+	CALLOC_CHECK(sp, 1, sizeof(*sp));
+
+	if (res_ninit(sp) < 0) {
+		error("Can't initialize sp");
+		return -ENODEV;
+	}
+
+	h_errno = 0;
+	/* query the dns for a @type resource record */
+	len = res_nquery(sp, host->hostname, ns_c_in, host->type, answer.buf,
+			 sizeof(answer));
+
+	if (len < 0 || len > NS_MAXMSG) {
+		ret = get_err(-ENODATA);
+		goto out;
+	}
+
+	CALLOC_CHECK(host->handle, 1, sizeof(ns_msg));
+
+	ret = 0;
+
+	if (ns_initparse(answer.buf, len, host->handle) < 0) {
+		error("ns_initparse: %m");
+		ret = get_err(-ENODATA);
+	}
+out:
+	/* frees sp */
+	res_nclose(sp);
+	return ret;
+}
+
+/*
+ * Queries the host and returns the number of targets (resource records)
+ * for it. Returns -error in case of errors.
+ */
+static int query_host(hostinfo_t *host)
+{
+	int n, ret;
+
+	ret = dns_query(host);
+	if (ret) {
+		if (host->handle) {
+			free(host->handle);
+			host->handle = NULL;
+		}
+		return ret;
+	}
+
+	n = get_rr_count(host->handle);
+	if (n == 0)
+		return -ENODATA;
+
+	if (!is_type_resolvable(host->type) && n > MAX_VLS) {
+		info("Processing only '%d' records.", MAX_VLS);
+		return MAX_VLS;
+	}
+
+	if (n > 1 && is_type_resolvable(host->type) && host->single_addr)
+		return 1;
+
+	return n;
+}
+
+static int __resolve_targets(hostinfo_t **targets, int ntgts, ns_type type)
+{
+	int n = 0;
+	int i, ret, err = 0;
+
+	if (!is_type_resolvable(type))
+		return -EINVAL;
+
+	for (i = 0; i < ntgts; i++) {
+		targets[i]->type = type;
+		targets[i]->af = ns2af(type);
+
+		n = query_host(targets[i]);
+		if (!n) {
+			debug("can't query '%s', error %d", targets[i]->hostname, n);
+			err++;
+			continue;
+		}
+
+		ret = resolve_host(targets[i], n);
+		if (ret) {
+			debug("failed to parse '%s' resource records for target '%s': %s",
+			      str_type(type), targets[i]->hostname, get_strerr(ret));
+			err++;
+		}
+	}
+
+	if (err >= ntgts)
+		ret = -ENODATA;
+
+	return ret;
+}
+
+static int resolve_targets4(hostinfo_t **targets, int ntgts)
+{
+	return __resolve_targets(targets, ntgts, ns_t_a);
+}
+
+static int resolve_targets6(hostinfo_t **targets, int ntgts)
+{
+	return __resolve_targets(targets, ntgts, ns_t_aaaa);
+}
+
+/*
+ * This function resolves the targets in @targets, based on @af address family
+ * (requested by the "ipv4" or "ipv6" options).
+ *
+ * On success, each target will have at least one IP address in its addrs list,
+ * ready to be appended to the payload. Returns 0.
+ * On errors:
+ * - if @af is AF_INET or AF_INET6, returns -ENODATA
+ * - if @af is AF_UNSPEC, returns -AF_INET if only ipv4 failed, -AF_INET6 if
+ *   only ipv6 failed, and -ENODATA if both failed
+ */
+static int resolve_targets(hostinfo_t **targets, int ntgts, int af)
+{
+	int ret4 = 0, ret6 = 0, ret = 0;
+
+	if (IS_IP4(af) || IS_IP_ANY(af))
+		ret4 = resolve_targets4(targets, ntgts);
+	if (ret4) {
+		warn("Failed to resolve IPv4 targets: %s", get_strerr(ret4));
+		ret = IS_IP_ANY(af) ? -AF_INET : -ENODATA;
+	}
+
+	if (IS_IP6(af) || IS_IP_ANY(af))
+		ret6 = resolve_targets6(targets, ntgts);
+	if (ret6) {
+		warn("Failed to resolve IPv6 targets: %s", get_strerr(ret6));
+		ret = IS_IP_ANY(af) ? -AF_INET6 : -ENODATA;
+	}
+
+	if (ret4 && ret6)
+		ret = -ENODATA;
+
+	return ret;
+}
+
+/*
+ * Perform address resolution for a hostname and add the resulting addresses as
+ * strings to the list of payload segments
+ *
+ * @host: host information to query for
+ * @payload: payload buffer to append results to. Initialized and freed by caller.
+ *
+ * Returns 0 on success, -error otherwise.
+ */
+int dns_resolver(hostinfo_t *host, payload_t *payload)
+{
+	hostinfo_t *targets[MAX_TARGETS];
+	int ntgts = 0, i;
+	int ret = 0;
+	long ttl;
+
+	if (!host || !host->hostname || !payload)
+		return -EINVAL;
+
+	if (!is_type_valid(host->type)) {
+		warn("Invalid query type '%s' (%d)", str_type(host->type),
+		     host->type);
+		return -EINVAL;
+	}
+
+	debug("Querying hostname %s with query type '%s' (%d)",
+	      host->hostname, str_type(host->type), host->type);
+
+	for (i = 0; i < MAX_TARGETS; i++)
+		targets[i] = NULL;
+
+	host->handle = NULL;
+	host->naddrs = 0;
+
+	if (can_resolve_host(host)) {
+		targets[0] = host;
+		ntgts = 1;
+
+		goto resolve;
+	}
+
+	/* else, can't straight resolve, must query+fetch targets first */
+	ntgts = query_host(host);
+	if (ntgts < 1) {
+		ret = ntgts;
+		error("Failed to query host '%s': %s", host->hostname,
+		      get_strerr(ret));
+		goto out;
+	}
+
+	ret = get_targets(host, targets, &ntgts);
+	if (ret || ntgts == 0) {
+		error("Failed to get targets for '%s': %s", host->hostname,
+		      get_strerr(ret));
+		goto out;
+	}
+
+resolve:
+	ret = resolve_targets(targets, ntgts, host->af);
+	if (ret == -ENODATA) {
+		error("Failed to resolve targets for '%s': %s", host->hostname,
+		      get_strerr(ret));
+		goto out;
+	} /* else, we got at least *some* data */
+
+	/* append resolved addresses to payload */
+	ttl = append_addrs(targets, ntgts, payload);
+
+	host->ttl = clamp(ttl, -1, LONG_MAX);
+
+	/* success if reached here */
+	ret = errno = h_errno = 0;
+out:
+	i = 0;
+	while (targets[i] && targets[i] != host)
+		free_host(targets[i++]);
+
+	return ret;
+}
diff --git a/key.dns.h b/key.dns.h
index 33d0ab3b05b1..f522a51b92ce 100644
--- a/key.dns.h
+++ b/key.dns.h
@@ -1,14 +1,25 @@
 /*
+ * Common DNS resolving code for keyutils
+ *
+ * Copyright (c) 2022, SUSE LLC
+ * Author: Enzo Matsumiya <ematsumiya@suse.de>
+ *
  * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public Licence as published by
- * the Free Software Foundation; either version 2 of the Licence, or
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
  * (at your option) any later version.
  *
  * This program is distributed in the hope that it will be useful,
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public Licence for more details.
+ * GNU General Public License for more details.
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
  */
+#ifndef _KEY_DNS_H
+#define _KEY_DNS_H 
+
 #define _GNU_SOURCE
 #include <netinet/in.h>
 #include <arpa/nameser.h>
@@ -25,50 +36,216 @@
 #include <stdbool.h>
 #include <stdio.h>
 #include <stdarg.h>
-#include <keyutils.h>
 #include <stdlib.h>
 #include <unistd.h>
 #include <time.h>
 #include <ctype.h>
+#include <sys/param.h>
+#include <sys/uio.h> // struct iovec
+
+#include "keyutils.h"
+
+extern int verbose;
+extern int debug_mode;
+extern key_serial_t key;
+extern long key_expiry;
+
+#define DEFAULT_KEY_TTL 5
+
+#define MAX_VLS		15	/* Max Volume Location Servers Per-Cell (AFSDB) */
+#define MAX_PAYLOAD	256	/* Max number of payload vectors (iovecs) */
 
-#define	MAX_VLS			15	/* Max Volume Location Servers Per-Cell */
-#define	INET_IP4_ONLY		0x1
-#define	INET_IP6_ONLY		0x2
-#define	INET_ALL		0xFF
-#define ONE_ADDR_ONLY		0x100
+#define MAX_ADDRS	MAX_PAYLOAD	/* Max number of IP addresses for a hostname */
+#define MAX_ADDR_LEN	(INET6_ADDRSTRLEN + 8 + 1)
+#define MAX_TARGETS	128
+
+#define IS_IP4(af)	((af) == AF_INET)
+#define IS_IP6(af)	((af) == AF_INET6)
+#define IS_IP_ANY(af)	((af) == AF_UNSPEC)
+
+/* For DNS/libresolv-specific messages */
+void nsError(const char *hostname);
+void nsError_ex(const char *hostname);
+int get_err(int optval);
+/* For keyutils-specific messages */
+extern __attribute__((format(printf, 3, 4)))
+void _log(FILE *f, int level, const char *fmt, ...);
 
 /*
- * key.dns_resolver.c
+ * Just print an error to stderr or the syslog
  */
-extern key_serial_t key;
-extern int debug_mode;
-extern unsigned mask;
-extern unsigned int key_expiry;
-
-#define N_PAYLOAD 256
-extern struct iovec payload[N_PAYLOAD];
-extern int payload_index;
-
-extern __attribute__((format(printf, 1, 2), noreturn))
-void error(const char *fmt, ...);
-extern __attribute__((format(printf, 1, 2)))
-void _error(const char *fmt, ...);
-extern __attribute__((format(printf, 1, 2)))
-void warning(const char *fmt, ...);
-extern __attribute__((format(printf, 1, 2)))
-void info(const char *fmt, ...);
-extern __attribute__((noreturn))
-void nsError(int err, const char *domain);
-extern void _nsError(int err, const char *domain);
-extern __attribute__((format(printf, 1, 2)))
-void debug(const char *fmt, ...);
-
-extern void append_address_to_payload(const char *addr);
-extern void dump_payload(void);
-extern int dns_resolver(const char *server_name, const char *port);
+#define error(fmt, ...) \
+	do { \
+		_log(stderr, LOG_ERR, "E: " fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/*
+ * Print an error to stderr or the syslog, negate the key being created, and
+ * exit with a generic -1 error code.
+ *
+ * On error, negatively instantiate the key ourselves so that we can
+ * make sure the kernel doesn't hang it off of a searchable keyring
+ * and interfere with the next attempt to instantiate the key.
+ */
+#define error_ex(fmt, ...) \
+	do { \
+		_log(stderr, LOG_ERR, fmt, ##__VA_ARGS__); \
+		if (!debug_mode) \
+			keyctl_negate(key, 1, KEY_REQKEY_DEFL_DEFAULT); \
+		exit(-1); \
+	} while (0)
+
+#define error_oom() error_ex("%s: out of memory", __func__)
+
+/*
+ * Print a warning to stderr or the syslog
+ */
+#define warn(fmt, ...) \
+	do { \
+		_log(stderr, LOG_WARNING, "W: " fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/*
+ * Print status information
+ */
+#define info(fmt, ...) \
+	do { \
+		if (verbose >= 1) \
+			_log(stdout, LOG_INFO, "I: " fmt, ##__VA_ARGS__); \
+	} while (0)
 
 /*
- * dns.afsdb.c
+ * Print debugging information
  */
-extern __attribute__((noreturn))
-void afs_look_up_VL_servers(const char *cell, char *options);
+#define debug(fmt, ...) \
+	do { \
+		if (verbose >= 2) \
+			_log(stdout, LOG_DEBUG, "D: " fmt, ##__VA_ARGS__); \
+	} while (0)
+
+/*
+ * Print nameserver warning
+ */
+#define nsWarn(fmt, ...) \
+	do { \
+		if (isatty(2)) \
+			_log(stderr, LOG_WARNING, "NS: W: " fmt, ##__VA_ARGS__); \
+		else \
+			_log(stderr, LOG_WARNING, fmt, ##__VA_ARGS__); \
+	} while (0)
+
+#define STRNDUP_CHECK(dst, src, len) \
+	do { \
+		(dst) = strndup(src, len); \
+		if (!(dst)) \
+			error_oom(); \
+	} while (0)
+
+#define CALLOC_CHECK(dst, count, size) \
+	do { \
+		(dst) = calloc(count, size); \
+		if (!(dst)) \
+			error_oom(); \
+	} while (0)
+
+static inline const char *str_type(ns_type type)
+{
+	if (type == ns_t_invalid)
+		return "invalid";
+
+	if (type == ns_t_any)
+		return "A/AAAA";
+
+	/* p_type is deprecated in glibc >2.34 */
+#pragma GCC diagnostic push
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+	return p_type(type);
+#pragma GCC diagnostic pop
+}
+
+/* data to be sent through keyctl */
+struct payload {
+	struct iovec data[MAX_PAYLOAD];
+	int index;
+};
+
+typedef struct payload payload_t;
+
+/* Structure to easily pass around host information */
+struct hostinfo {
+	char *hostname;
+	ns_type type;
+	char *addrs[MAX_ADDRS];
+	int naddrs;
+	char port[10];
+	int af;
+	long ttl;
+	ns_msg *handle;
+	bool single_addr;
+};
+
+typedef struct hostinfo hostinfo_t;
+
+static inline void dump_host(hostinfo_t *host)
+{
+	int i = 0;
+
+	if (!host)
+		return;
+
+	debug("Host info:");
+	debug("  hostname: %s", host->hostname);
+	debug("  type: %s", (host->type == ns_t_a || host->type == ns_t_aaaa) ?
+			    "A/AAAA" : str_type(host->type));
+	for (i = 0; i < host->naddrs; i++)
+		debug("  addr[%d]: %s", i, host->addrs[i]);
+	if (host->port[0] != '\0')
+		debug("  port: %s", host->port+1);
+	/* skip af; it's used only internally for resolving and could contain
+	 * incoherent information */
+	debug("  ttl: %ld", host->ttl);
+}
+
+static inline void free_hostinfo(hostinfo_t *host)
+{
+	int i;
+
+	if (!host)
+		return;
+
+	if (host->hostname) {
+		free(host->hostname);
+		host->hostname = NULL;
+	}
+	for (i = 0; i < host->naddrs; i++) {
+		if (host->addrs[i]) {
+			free(host->addrs[i]);
+			host->addrs[i] = NULL;
+		}
+	}
+	if (host->handle) {
+		free(host->handle);
+		host->handle = NULL;
+	}
+}
+
+static inline void free_host(hostinfo_t *host)
+{
+	if (!host)
+		return;
+
+	free_hostinfo(host);
+	free(host);
+	host = NULL;
+}
+
+extern void parse_opts(hostinfo_t *host, char *options);
+void dump_payload(payload_t *payload);
+
+/* Main function for DNS module */
+int dns_resolver(hostinfo_t *host, payload_t *payload);
+
+/* AFS-specific DNS query function */
+void afs_lookup_VL_servers(const char *cell, char *options);
+
+#endif /* _KEY_DNS_H */
diff --git a/key.dns_resolver.c b/key.dns_resolver.c
index 7a7ec4241ea0..0c680caf98cc 100644
--- a/key.dns_resolver.c
+++ b/key.dns_resolver.c
@@ -49,399 +49,138 @@ static const char afsdb_query_type[] = "afsdb";
 static const char *config_file = "/etc/keyutils/key.dns_resolver.conf";
 static bool config_specified = false;
 key_serial_t key;
-static int verbose;
+int verbose;
 int debug_mode;
-unsigned mask = INET_ALL;
-unsigned int key_expiry = 5;
+long key_expiry = DEFAULT_KEY_TTL;
 
-
-/*
- * segmental payload
- */
-struct iovec payload[N_PAYLOAD];
-int payload_index;
-
-/*
- * Print an error to stderr or the syslog, negate the key being created and
- * exit
- */
-void error(const char *fmt, ...)
-{
-	va_list va;
-
-	va_start(va, fmt);
-	if (isatty(2)) {
-		vfprintf(stderr, fmt, va);
-		fputc('\n', stderr);
-	} else {
-		vsyslog(LOG_ERR, fmt, va);
-	}
-	va_end(va);
-
-	/*
-	 * on error, negatively instantiate the key ourselves so that we can
-	 * make sure the kernel doesn't hang it off of a searchable keyring
-	 * and interfere with the next attempt to instantiate the key.
-	 */
-	if (!debug_mode)
-		keyctl_negate(key, 1, KEY_REQKEY_DEFL_DEFAULT);
-
-	exit(1);
-}
-
-#define error(FMT, ...) error("Error: " FMT, ##__VA_ARGS__);
-
-/*
- * Just print an error to stderr or the syslog
- */
-void _error(const char *fmt, ...)
-{
-	va_list va;
-
-	va_start(va, fmt);
-	if (isatty(2)) {
-		vfprintf(stderr, fmt, va);
-		fputc('\n', stderr);
-	} else {
-		vsyslog(LOG_ERR, fmt, va);
-	}
-	va_end(va);
-}
-
-/*
- * Print a warning to stderr or the syslog
- */
-void warning(const char *fmt, ...)
-{
-	va_list va;
-
-	va_start(va, fmt);
-	if (isatty(2)) {
-		vfprintf(stderr, fmt, va);
-		fputc('\n', stderr);
-	} else {
-		vsyslog(LOG_WARNING, fmt, va);
-	}
-	va_end(va);
-}
-
-/*
- * Print status information
- */
-void info(const char *fmt, ...)
-{
-	va_list va;
-
-	if (verbose < 1)
-		return;
-
-	va_start(va, fmt);
-	if (isatty(1)) {
-		fputs("I: ", stdout);
-		vfprintf(stdout, fmt, va);
-		fputc('\n', stdout);
-	} else {
-		vsyslog(LOG_INFO, fmt, va);
-	}
-	va_end(va);
-}
-
-/*
- * Print a nameserver error and exit
- */
-static const int ns_errno_map[] = {
-	[0]			= ECONNREFUSED,
-	[HOST_NOT_FOUND]	= ENODATA,
-	[TRY_AGAIN]		= EAGAIN,
-	[NO_RECOVERY]		= ECONNREFUSED,
-	[NO_DATA]		= ENODATA,
-};
-
-void _nsError(int err, const char *domain)
-{
-	if (isatty(2))
-		fprintf(stderr, "NS:%s: %s.\n", domain, hstrerror(err));
-	else
-		syslog(LOG_INFO, "%s: %s", domain, hstrerror(err));
-
-	if (err >= sizeof(ns_errno_map) / sizeof(ns_errno_map[0]))
-		err = ECONNREFUSED;
-	else
-		err = ns_errno_map[err];
-
-	info("Reject the key with error %d", err);
-}
-
-void nsError(int err, const char *domain)
-{
-	unsigned timeout;
-	int ret;
-
-	_nsError(err, domain);
-
-	switch (err) {
-	case TRY_AGAIN:
-		timeout = 1;
-		break;
-	case 0:
-	case NO_RECOVERY:
-		timeout = 10;
-		break;
-	default:
-		timeout = 1 * 60;
-		break;
-	}
-
-	if (!debug_mode) {
-		ret = keyctl_reject(key, timeout, err, KEY_REQKEY_DEFL_DEFAULT);
-		if (ret == -1)
-			error("%s: keyctl_reject: %m", __func__);
-	}
-	exit(0);
-}
-
-/*
- * Print debugging information
- */
-void debug(const char *fmt, ...)
+void parse_opts(hostinfo_t *host, char *options)
 {
-	va_list va;
+	char *k, *val;
+	bool invalid;
 
-	if (verbose < 2)
+	if (!host || !options)
 		return;
 
-	va_start(va, fmt);
-	if (isatty(1)) {
-		fputs("D: ", stdout);
-		vfprintf(stdout, fmt, va);
-		fputc('\n', stdout);
-	} else {
-		vsyslog(LOG_DEBUG, fmt, va);
-	}
-	va_end(va);
-}
-
-/*
- * Append an address to the payload segment list
- */
-void append_address_to_payload(const char *addr)
-{
-	size_t sz = strlen(addr);
-	char *copy;
-	int loop;
-
-	debug("append '%s'", addr);
-
-	if (payload_index + 2 > N_PAYLOAD - 1)
-		return;
-
-	/* discard duplicates */
-	for (loop = 0; loop < payload_index; loop++)
-		if (payload[loop].iov_len == sz &&
-		    memcmp(payload[loop].iov_base, addr, sz) == 0)
-			return;
-
-	copy = malloc(sz);
-	if (!copy)
-		error("%s: malloc: %m", __func__);
-	memcpy(copy, addr, sz);
-
-	if (payload_index != 0) {
-		payload[payload_index  ].iov_base = ",";
-		payload[payload_index++].iov_len = 1;
-	}
-	payload[payload_index  ].iov_base = copy;
-	payload[payload_index++].iov_len = sz;
-}
-
-/*
- * Dump the payload when debugging
- */
-void dump_payload(void)
-{
-	size_t plen, n;
-	char *buf, *p;
-	int loop;
-
-	if (debug_mode)
-		verbose = 1;
-	if (verbose < 1)
-		return;
-
-	plen = 0;
-	for (loop = 0; loop < payload_index; loop++) {
-		n = payload[loop].iov_len;
-		debug("seg[%d]: %zu", loop, n);
-		plen += n;
-	}
-	if (plen == 0) {
-		info("The key instantiation data is empty");
-		return;
-	}
-
-	debug("total: %zu", plen);
-	buf = malloc(plen + 1);
-	if (!buf)
-		return;
-
-	p = buf;
-	for (loop = 0; loop < payload_index; loop++) {
-		n = payload[loop].iov_len;
-		memcpy(p, payload[loop].iov_base, n);
-		p += n;
-	}
-
-	info("The key instantiation data is '%s'", buf);
-	info("The expiry time is %us", key_expiry);
-	free(buf);
-}
-
-/*
- * Perform address resolution on a hostname and add the resulting address as a
- * string to the list of payload segments.
- */
-int dns_resolver(const char *server_name, const char *port)
-{
-	struct addrinfo hints, *addr, *ai;
-	char buf[INET6_ADDRSTRLEN + 8 + 1];
-	int ret, len;
-	void *sa;
-
-	debug("Resolve '%s' with %x", server_name, mask);
-
-	memset(&hints, 0, sizeof(hints));
-	switch (mask & INET_ALL) {
-	case INET_IP4_ONLY:	hints.ai_family = AF_INET;	debug("IPv4"); break;
-	case INET_IP6_ONLY:	hints.ai_family = AF_INET6;	debug("IPv6"); break;
-	default: break;
-	}
-
-	/* resolve name to ip */
-	ret = getaddrinfo(server_name, NULL, &hints, &addr);
-	if (ret) {
-		info("unable to resolve hostname: %s [%s]",
-		     server_name, gai_strerror(ret));
-		return -1;
-	}
-
-	for (ai = addr; ai; ai = ai->ai_next) {
-		debug("RR: %x,%x,%x,%x,%x,%s",
-		      ai->ai_flags, ai->ai_family,
-		      ai->ai_socktype, ai->ai_protocol,
-		      ai->ai_addrlen, ai->ai_canonname);
-
-		/* convert address to string */
-		switch (ai->ai_family) {
-		case AF_INET:
-			if (!(mask & INET_IP4_ONLY))
-				continue;
-			sa = &(((struct sockaddr_in *)ai->ai_addr)->sin_addr);
-			len = INET_ADDRSTRLEN;
-			break;
-		case AF_INET6:
-			if (!(mask & INET_IP6_ONLY))
-				continue;
-			sa = &(((struct sockaddr_in6 *)ai->ai_addr)->sin6_addr);
-			len = INET6_ADDRSTRLEN;
-			break;
-		default:
-			debug("Address of unknown family %u", addr->ai_family);
+	do {
+		invalid = false;
+		k = options;
+		options = strchr(options, ' ');
+		if (!options)
+			options = k + strlen(k);
+		else
+			*options++ = '\0';
+		if (!*k)
 			continue;
+		if (strchr(k, ','))
+			error_ex("Option name '%s' contains a comma", k);
+
+		val = strchr(k, '=');
+		if (val)
+			*val++ = '\0';
+
+		if (strcmp(k, "ipv4") == 0) {
+			host->af = AF_INET;
+			host->type = ns_t_a;
+		} else if (strcmp(k, "ipv6") == 0) {
+			host->af = AF_INET6;
+			host->type = ns_t_aaaa;
+		} else if (strcmp(k, "list") == 0) {
+			host->single_addr = false;
+		} else {
+			invalid = true;
 		}
 
-		if (!inet_ntop(ai->ai_family, sa, buf, len))
-			error("%s: inet_ntop: %m", __func__);
-
-		if (port)
-			strcat(buf, port);
-		append_address_to_payload(buf);
-		if (mask & ONE_ADDR_ONLY)
-			break;
-	}
-
-	freeaddrinfo(addr);
-	return 0;
+		if (invalid && !val)
+			warn("Skipping invalid opt %s", k);
+		else if (invalid && val)
+			warn("Skipping invalid opt %s=%s", k, val);
+		else if (val)
+			debug("Opt %s=%s", k, val);
+		else
+			debug("Opt %s", k);
+	} while (*options);
 }
 
 /*
  * Look up a A and/or AAAA records to get host addresses
  *
- * The callout_info is parsed for request options.  For instance, "ipv4" to
- * request only IPv4 addresses, "ipv6" to request only IPv6 addresses and
- * "list" to get multiple addresses.
+ * @hostname: hostname to query for
+ * @options is parsed for request options:
+ *   "ipv4": to request only IPv4 addresses
+ *   "ipv6": to request only IPv6 addresses
+ *   "list": to get multiple addresses
  */
 static __attribute__((noreturn))
 int dns_query_a_or_aaaa(const char *hostname, char *options)
 {
-	int ret;
+	payload_t *payload = NULL;
+	hostinfo_t host = { 0 };
+	int ret = 0;
 
-	debug("Get A/AAAA RR for hostname:'%s', options:'%s'",
-	      hostname, options);
+	if (!hostname)
+		error_ex("%s: missing hostname", __func__);
 
-	if (!options[0]) {
-		/* legacy mode */
-		mask = INET_IP4_ONLY | ONE_ADDR_ONLY;
-	} else {
-		char *k, *val;
-
-		mask = INET_ALL | ONE_ADDR_ONLY;
-
-		do {
-			k = options;
-			options = strchr(options, ' ');
-			if (!options)
-				options = k + strlen(k);
-			else
-				*options++ = '\0';
-			if (!*k)
-				continue;
-			if (strchr(k, ','))
-				error("Option name '%s' contains a comma", k);
-
-			val = strchr(k, '=');
-			if (val)
-				*val++ = '\0';
+	debug("Query A/AAAA records for hostname:'%s', options:'%s'",
+	      hostname, options);
 
-			debug("Opt %s", k);
+	host.af = AF_UNSPEC;
+	host.single_addr = true;
+	host.type = ns_t_any;
 
-			if (strcmp(k, "ipv4") == 0) {
-				mask &= ~INET_ALL;
-				mask |= INET_IP4_ONLY;
-			} else if (strcmp(k, "ipv6") == 0) {
-				mask &= ~INET_ALL;
-				mask |= INET_IP6_ONLY;
-			} else if (strcmp(k, "list") == 0) {
-				mask &= ~ONE_ADDR_ONLY;
-			}
+	parse_opts(&host, options);
 
-		} while (*options);
-	}
+	CALLOC_CHECK(payload, 1, sizeof(payload_t));
+	STRNDUP_CHECK(host.hostname, hostname, strlen(hostname));
+	ret = h_errno = 0;
 
 	/* Turn the hostname into IP addresses */
-	ret = dns_resolver(hostname, NULL);
-	if (ret)
-		nsError(NO_DATA, hostname);
+	ret = dns_resolver(&host, payload);
 
 	/* handle a lack of results */
-	if (payload_index == 0)
-		nsError(NO_DATA, hostname);
+	if (ret || payload->index == 0) {
+		ret = get_err(0);
+		goto out_free;
+	}
 
-	/* must include a NUL char at the end of the payload */
-	payload[payload_index].iov_base = "";
-	payload[payload_index++].iov_len = 1;
-	dump_payload();
+	dump_payload(payload);
+	info("Key timeout will be %ld seconds", host.ttl);
 
 	/* load the key with data key */
 	if (!debug_mode) {
-		ret = keyctl_set_timeout(key, key_expiry);
-		if (ret == -1)
+		unsigned int ttl;
+
+		/*
+		 * If TTL was set through the config file (key_expiry),
+		 * it takes precedence over the one from the DNS record (stored
+		 * in host.ttl).
+		 */
+		if (key_expiry > -1)
+			ttl = (unsigned int)key_expiry;
+		else if (host.ttl > -1)
+			ttl = (unsigned int)host.ttl;
+		else
+			/* Fallback to default value if dns_resolver() couldn't
+			 * get TTL for some reason */
+			ttl = DEFAULT_KEY_TTL;
+
+		ret = keyctl_set_timeout(key, ttl);
+		if (ret) {
 			error("%s: keyctl_set_timeout: %m", __func__);
-		ret = keyctl_instantiate_iov(key, payload, payload_index, 0);
+			goto out_free;
+		}
+
+		info("Key set to timeout in %u seconds", ttl);
+
+		ret = keyctl_instantiate_iov(key, payload->data, payload->index, 0);
 		if (ret == -1)
 			error("%s: keyctl_instantiate: %m", __func__);
 	}
 
-	exit(0);
+out_free:
+	free_hostinfo(&host);
+	free(payload);
+
+	exit(ret);
 }
 
 /*
@@ -451,7 +190,8 @@ static void read_config(void)
 {
 	FILE *f;
 	char buf[4096], *b, *p, *k, *v;
-	unsigned int line = 0, u;
+	unsigned int line = 0;
+	long u;
 	int n;
 
 	info("READ CONFIG %s", config_file);
@@ -555,15 +295,15 @@ static void read_config(void)
 		if (strcmp(k, "default_ttl") == 0) {
 			if (!v)
 				goto missing_value;
-			if (sscanf(v, "%u%n", &u, &n) != 1)
+			if (sscanf(v, "%ld%n", &u, &n) != 1)
 				goto bad_value;
 			if (v[n])
 				goto extra_data;
-			if (u < 1 || u > INT_MAX)
+			if (u < 1 || u > LONG_MAX)
 				goto out_of_range;
 			key_expiry = u;
 		} else {
-			warning("%s:%u: Unknown option '%s'", config_file, line, k);
+			warn("%s:%u: Unknown option '%s'", config_file, line, k);
 		}
 	}
 
@@ -591,7 +331,7 @@ out_of_range:
 static __attribute__((noreturn))
 void config_dumper(void)
 {
-	printf("default_ttl = %u\n", key_expiry);
+	printf("default_ttl = %ld\n", key_expiry);
 	exit(0);
 }
 
@@ -634,6 +374,8 @@ int main(int argc, char *argv[])
 	char *buf = NULL, *name;
 	bool dump_config = false;
 
+	key_expiry = -1;
+
 	openlog(prog, 0, LOG_DAEMON);
 
 	while ((ret = getopt_long(argc, argv, "c:vDV", long_options, NULL)) != -1) {
@@ -667,6 +409,7 @@ int main(int argc, char *argv[])
 	argc -= optind;
 	argv += optind;
 	read_config();
+
 	if (dump_config)
 		config_dumper();
 
@@ -676,27 +419,27 @@ int main(int argc, char *argv[])
 
 		/* get the key ID */
 		if (!**argv)
-			error("Invalid blank key ID");
+			error_ex("Invalid blank key ID");
 		key = strtol(*argv, &p, 10);
 		if (*p)
-			error("Invalid key ID format");
+			error_ex("Invalid key ID format");
 
 		/* get the key description (of the form "x;x;x;x;<query_type>:<name>") */
 		ret = keyctl_describe_alloc(key, &buf);
 		if (ret == -1)
-			error("keyctl_describe_alloc failed: %m");
+			error_ex("keyctl_describe_alloc failed: %m");
 
 		/* get the callout_info (which can supply options) */
 		ret = keyctl_read_alloc(KEY_SPEC_REQKEY_AUTH_KEY, (void **)&callout_info);
 		if (ret == -1)
-			error("Invalid key callout_info read: %m");
+			error_ex("Invalid key callout_info read: %m");
 	} else {
 		if (argc != 2)
 			usage();
 
 		ret = asprintf(&buf, "%s;-1;-1;0;%s", key_type, argv[0]);
 		if (ret < 0)
-			error("Error %m");
+			error_ex("Error %m");
 		callout_info = argv[1];
 	}
 
@@ -706,20 +449,20 @@ int main(int argc, char *argv[])
 
 	p = strchr(buf, ';');
 	if (!p)
-		error("Badly formatted key description '%s'", buf);
+		error_ex("Badly formatted key description '%s'", buf);
 	ktlen = p - buf;
 
 	/* make sure it's the type we are expecting */
 	if (ktlen != sizeof(key_type) - 1 ||
 	    memcmp(buf, key_type, ktlen) != 0)
-		error("Key type is not supported: '%*.*s'", ktlen, ktlen, buf);
+		error_ex("Key type is not supported: '%*.*s'", ktlen, ktlen, buf);
 
 	keyend = buf + ktlen + 1;
 
 	/* the actual key description follows the last semicolon */
 	keyend = rindex(keyend, ';');
 	if (!keyend)
-		error("Invalid key description: %s", buf);
+		error_ex("Invalid key description: %s", buf);
 	keyend++;
 
 	name = index(keyend, ':');
@@ -736,7 +479,7 @@ int main(int argc, char *argv[])
 	    (qtlen == sizeof(aaaa_query_type) - 1 &&
 	     memcmp(keyend, aaaa_query_type, sizeof(aaaa_query_type) - 1) == 0)
 	    ) {
-		info("Do DNS query of A/AAAA type for:'%s' mask:'%s'",
+		info("Do DNS query of A/AAAA type for '%s', with options '%s'",
 		     name, callout_info);
 		dns_query_a_or_aaaa(name, callout_info);
 	}
@@ -744,10 +487,11 @@ int main(int argc, char *argv[])
 	if (qtlen == sizeof(afsdb_query_type) - 1 &&
 	    memcmp(keyend, afsdb_query_type, sizeof(afsdb_query_type) - 1) == 0
 	    ) {
-		info("Do AFS VL server query for:'%s' mask:'%s'",
+		info("Do AFS VL server query for '%s', with options '%s'",
 		     name, callout_info);
-		afs_look_up_VL_servers(name, callout_info);
+		afs_lookup_VL_servers(name, callout_info);
 	}
 
 	error("Query type: \"%*.*s\" is not supported", qtlen, qtlen, keyend);
+	exit(-EINVAL);
 }
-- 
2.35.3

