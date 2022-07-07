Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D6A2C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jul 2022 19:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236603AbiGGTP2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:15:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiGGTP1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jul 2022 15:15:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972562ED57
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jul 2022 12:15:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 55FC722021;
        Thu,  7 Jul 2022 19:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657221325; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmBvLokVE7Rx9+xBE4Rb3FOzWkpDGHQ2fHv/UE5g/V0=;
        b=Vrnl3gVOxHsVfWwKnGB+B1cnhAW2Ah3MURR0FKcjng5JWj0Keqru9ttfuFO+7XVy0+lB0l
        f7DceJxComuEvHRWGWB+pusPfv639JzHR3ZrV5GyVPIwBjT1CRHyEXE2mfzIfCRBfn7Quz
        R2zydDiEX7pJOwP3X1vI5vSi8D+dsqg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657221325;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VmBvLokVE7Rx9+xBE4Rb3FOzWkpDGHQ2fHv/UE5g/V0=;
        b=fx98C4n4LpuP7JxoS//3qJlk+8dkXhDQCYyMRDtTh049wbFyGBDIgZzh6gVGbrRa9SPgO3
        7KfgKbGOvg5dbTBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C9F1413461;
        Thu,  7 Jul 2022 19:15:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id zYTEIswwx2L3IgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 07 Jul 2022 19:15:24 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     dhowells@redhat.com
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 3/3] key.dns: allow to use custom nameservers
Date:   Thu,  7 Jul 2022 16:15:07 -0300
Message-Id: <20220707191507.2013-4-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220707191507.2013-1-ematsumiya@suse.de>
References: <20220707191507.2013-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This commit allows the user to use custom nameservers for their
key.dns_resolver queries.

It can be achieved by passing the "ns=ADDR" option as the callout info
for dns_resolver(). Both IPv4 and IPv6 are supported. A maximum of 3
nameservers is allowed, as a libresolv limitation.

Each nameserver will be queried only once for the hostname specified.
Upon success (hostname was resolved), the information is returned and
no further queries are made to the remaining nameservers.

If all specified nameservers fail (either unreachable or can't resolve
the hostname), there's no fallback to using system's default. Callers
must adapt their calls to remove the failing nameservers from their
callout info and query again.

If no nameservers are passed, the system's default will be used (just
like before this patch).

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 dns.afsdb.c        |   2 +
 key.dns.c          | 107 ++++++++++++++++++++++++++++++++++++++++++---
 key.dns.h          |   5 +++
 key.dns_resolver.c |  41 +++++++++++++++--
 4 files changed, 146 insertions(+), 9 deletions(-)

diff --git a/dns.afsdb.c b/dns.afsdb.c
index 806ae85c5632..7e18b969bc7f 100644
--- a/dns.afsdb.c
+++ b/dns.afsdb.c
@@ -129,6 +129,8 @@ void afs_lookup_VL_servers(const char *cell, char *options, long config_ttl)
 		ret = afs_instantiate(payload, ttl);
 out_free:
 	free_hostinfo(&host);
+	while (host.nslen-- > 0)
+		free(host.nameservers[host.nslen]);
 	free(payload);
 
 	exit(ret);
diff --git a/key.dns.c b/key.dns.c
index 6390f3118a6e..39ef62fa4847 100644
--- a/key.dns.c
+++ b/key.dns.c
@@ -168,6 +168,19 @@ void dump_payload(payload_t *payload)
 	free(buf);
 }
 
+static int get_af_from_addr(const char *addr)
+{
+	char buf[MAX_ADDR_LEN];
+	int ret;
+
+	if ((ret =inet_pton(AF_INET, addr, buf)))
+		return AF_INET;
+	else if ((ret = inet_pton(AF_INET6, addr, buf)))
+		return AF_INET6;
+
+	return (!ret) ? -EINVAL : -EAFNOSUPPORT;
+}
+
 static char *get_addr_str(int af, char *s, const void *data)
 {
 	switch (af) {
@@ -377,6 +390,7 @@ static int parse_rr(hostinfo_t *host, ns_rr rr)
 	const unsigned char *rdata;
 	unsigned short prio, weight, port; /* for ns_t_srv */
 	int subtype = 0; /* for ns_t_afsdb */
+	char *addrbuf = NULL; /* for ns_t_a/aaaa */
 	ns_type rrtype;
 	int ret = 0;
 
@@ -405,16 +419,23 @@ static int parse_rr(hostinfo_t *host, ns_rr rr)
 	case ns_t_a:
 	case ns_t_aaaa:
 		if (host->naddrs == MAX_ADDRS) {
-			warn("Can't add more IP addresses (max '%d' reached)",
+			warn("Can't add more IP addresses, max '%d' reached",
 			     MAX_ADDRS);
-			break;
+			return -ENOMEM;
 		}
 
-		CALLOC_CHECK(host->addrs[host->naddrs], 1, MAX_ADDR_LEN);
-		get_addr_str(ns2af(rrtype), host->addrs[host->naddrs], rdata);
+		CALLOC_CHECK(addrbuf, 1, MAX_ADDR_LEN);
+		get_addr_str(ns2af(rrtype), addrbuf, rdata);
 
-		debug("rdata: addr=%s", host->addrs[host->naddrs]);
+		if (!strcmp(addrbuf, "0.0.0.0") || !strcmp(addrbuf, "::")) {
+			info("Discarding invalid address '%s'", addrbuf);
+			free(addrbuf);
+			return -EINVAL;
+		}
+
+		debug("rdata: addr=%s", addrbuf);
 
+		host->addrs[host->naddrs] = addrbuf;
 		host->naddrs++;
 		break;
 	default:
@@ -460,6 +481,7 @@ static int get_targets(hostinfo_t *host, hostinfo_t **targets, int *maxn)
 
 	for (i = 0; i < *maxn; i++) {
 		hostinfo_t *target = NULL;
+		int ns;
 
 		if (ns_parserr(host->handle, ns_s_an, i, &rr)) {
 			error("ns_parserr failed: %m");
@@ -482,6 +504,9 @@ static int get_targets(hostinfo_t *host, hostinfo_t **targets, int *maxn)
 		target->handle = NULL;
 		target->af = host->af;
 		target->single_addr = host->single_addr;
+		for (ns = 0; ns < host->nslen; ns++)
+			target->nameservers[ns] = host->nameservers[ns];
+		target->nslen = host->nslen;
 
 		n++;
 		continue;
@@ -546,6 +571,43 @@ static int resolve_host(hostinfo_t *host, int n)
 	return ret;
 }
 
+/* Sets a nameserver to use in @sp */
+static int set_ns(res_state sp, char *addr)
+{
+	int ret, af;
+
+	if (!sp || !addr || !strlen(addr))
+		return -EINVAL;
+
+	af = get_af_from_addr(addr);
+	if (af < 0) {
+		nsWarn("Can't convert nameserver address '%s'", addr);
+		return -EINVAL;
+	}
+
+	ret = inet_pton(af, addr, &sp->nsaddr_list[0].sin_addr.s_addr);
+	if (!ret) {
+		nsWarn("Invalid nameserver address '%s'", addr);
+		return -EINVAL;
+	} else if (ret == -1) {
+		nsWarn("Invalid address family '%d'", af);
+		return -EAFNOSUPPORT;
+	}
+
+	sp->nscount = 1;
+	sp->nsaddr_list[0].sin_family = af;
+	sp->nsaddr_list[0].sin_port = htons(53);
+
+	sp->options = RES_DEFAULT;
+	/* RES_DFLRETRY is 2 by default (resolv.h), but the retry logic there
+	 * is different from what we do here; see more below */
+	sp->retry = RES_DFLRETRY;
+
+	debug("using nameserver: %s", addr);
+
+	return 0;
+}
+
 /*
  * Makes the actual query
  *
@@ -559,6 +621,7 @@ static int resolve_host(hostinfo_t *host, int n)
 static int dns_query(hostinfo_t *host)
 {
 	res_state sp;
+	int maxns, ns;
 	int ret, len;
 
 	if (!host)
@@ -579,12 +642,46 @@ static int dns_query(hostinfo_t *host)
 		return -ENODEV;
 	}
 
+	ns = 0;
+	ret = 0;
+	maxns = clamp(host->nslen, 0, MAXNS);
+
+	/*
+	 * The retry logic here for nameserver rotation is based on the answer
+	 * containing 1 or more valid resource records, instead of the NS
+	 * server being down/unreachable (as libresolv does internally).
+	 * So the RES_ROTATE option flag doesn't apply here since we'll be
+	 * trying a single NS a time. Ditto for sp->retry (used for DNS over
+	 * TCP (RES_USEVC)).
+	 */
+retry:
+	/* Find the next suitable nameserver in @host::nameservers */
+	while (ns < maxns && (ret = set_ns(sp, host->nameservers[ns])))
+		ns++;
+
+	if (ret && ns == maxns) {
+		error("Can't use any of the nameservers provided.");
+		ret = get_err(-ECONNREFUSED);
+		goto out;
+	}
+
 	h_errno = 0;
 	/* query the dns for a @type resource record */
 	len = res_nquery(sp, host->hostname, ns_c_in, host->type, answer.buf,
 			 sizeof(answer));
 
 	if (len < 0 || len > NS_MAXMSG) {
+		if (host->nslen > 0) {
+			if (ret == -ECONNREFUSED)
+				error("Can't reach nameserver '%s'",
+				      host->nameservers[ns]);
+			else
+				error("Nameserver '%s' can't resolve '%s'",
+				     host->nameservers[ns], host->hostname);
+			ns++;
+			if (ns < maxns)
+				goto retry;
+		}
 		ret = get_err(-ENODATA);
 		goto out;
 	}
diff --git a/key.dns.h b/key.dns.h
index 25a815b82159..295c7b2241e3 100644
--- a/key.dns.h
+++ b/key.dns.h
@@ -182,6 +182,8 @@ struct hostinfo {
 	long ttl;
 	ns_msg *handle;
 	bool single_addr;
+	char *nameservers[MAXNS];
+	int nslen;
 };
 
 typedef struct hostinfo hostinfo_t;
@@ -204,6 +206,9 @@ static inline void dump_host(hostinfo_t *host)
 	/* skip af; it's used only internally for resolving and could contain
 	 * incoherent information */
 	debug("  ttl: %ld", host->ttl);
+	if (host->nslen > 0)
+		for (i = 0; i < host->nslen; i++)
+			debug("  custom ns[%d]: %s", i, host->nameservers[i]);
 }
 
 static inline void free_hostinfo(hostinfo_t *host)
diff --git a/key.dns_resolver.c b/key.dns_resolver.c
index 8da7da6858a0..325683bdb584 100644
--- a/key.dns_resolver.c
+++ b/key.dns_resolver.c
@@ -65,11 +65,16 @@ typedef struct _key_dns_conf {
 void parse_opts(hostinfo_t *host, char *options)
 {
 	char *k, *val;
+	int ns;
 	bool invalid;
 
 	if (!host || !options)
 		return;
 
+	for (ns = 0; ns < MAXNS; ns++)
+		host->nameservers[ns] = NULL;
+	ns = 0;
+
 	do {
 		invalid = false;
 		k = options;
@@ -95,14 +100,38 @@ void parse_opts(hostinfo_t *host, char *options)
 			host->type = ns_t_aaaa;
 		} else if (strcmp(k, "list") == 0) {
 			host->single_addr = false;
+		} else if (strcmp(k, "ns") == 0) {
+			if (ns < MAXNS) {
+				size_t vlen = strlen(val);
+				if (vlen >= INET6_ADDRSTRLEN) {
+					debug("%s: value too long for ns= key: %s",
+					      __func__, val);
+					invalid = true;
+					goto invalid;
+				}
+				/*
+				 * Blindly copy the specified address here,
+				 * it'll be checked later in dns_query().
+				 * Must be freed by callers.
+				 */
+				STRNDUP_CHECK(host->nameservers[ns], val, vlen);
+				ns++;
+				host->nslen = ns;
+			} else {
+				warn("Max of %d nameservers allowed. Skipping %s=%s",
+				     MAXNS, k, val);
+				continue;
+			}
 		} else {
 			invalid = true;
 		}
 
-		if (invalid && !val)
-			warn("Skipping invalid opt %s", k);
-		else if (invalid && val)
-			warn("Skipping invalid opt %s=%s", k, val);
+invalid:
+		if (invalid)
+			if (val)
+				warn("Skipping invalid opt %s=%s", k, val);
+			else
+				warn("Skipping invalid opt %s", k);
 		else if (val)
 			debug("Opt %s=%s", k, val);
 		else
@@ -118,6 +147,8 @@ void parse_opts(hostinfo_t *host, char *options)
  *   "ipv4": to request only IPv4 addresses
  *   "ipv6": to request only IPv6 addresses
  *   "list": to get multiple addresses
+ *   "ns=ADDR": use ADDR as a custom nameserver. Max of 3 nameservers is
+ *              allowed (MAXNS from libresolv).
  * @config_ttl: TTL gotten from key.dns_resolver.conf (callers must set this to
  *		-1 if no config)
  *		XXX: might have to change this to a key_dns_conf_t if config
@@ -189,6 +220,8 @@ int dns_query_a_or_aaaa(const char *hostname, char *options, long config_ttl)
 
 out_free:
 	free_hostinfo(&host);
+	while (host.nslen-- > 0)
+		free(host.nameservers[host.nslen]);
 	free(payload);
 
 	exit(ret);
-- 
2.35.3

