Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2713C433EF
	for <linux-cifs@archiver.kernel.org>; Thu,  7 Jul 2022 19:15:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236520AbiGGTPZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 7 Jul 2022 15:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236503AbiGGTPY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 7 Jul 2022 15:15:24 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 583A02ED57
        for <linux-cifs@vger.kernel.org>; Thu,  7 Jul 2022 12:15:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E751F2200F;
        Thu,  7 Jul 2022 19:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1657221321; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eT2b55uvoZ7vpQ6KGsD/V0jSJUL6zYcwNFH1xT/IlhE=;
        b=UczoHA7yL56m+5ut6vpu61eQSWiZkvg/FXzqZX/G1b/gPUh3+q/vl8ZK+1qxdJ/y5EdmbI
        Bhm6Zvte2E09ywB8Ag1v+gp/9ScImfnGuv6CKrHp/1vNMDRblA932W468DzmwVHltA8bWd
        aYqwVURMQj4CHLHanc6pMknx8OiTefI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1657221321;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eT2b55uvoZ7vpQ6KGsD/V0jSJUL6zYcwNFH1xT/IlhE=;
        b=MqD+WUuq2/+QxTUx04fQxVXDZQlJPxirbRS63piAzR0+2ZYbT79ISs2ItRZTLGFyUKczoK
        3+NICWAmTsx5xKDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 69A5313461;
        Thu,  7 Jul 2022 19:15:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id RhJ0C8kwx2LyIgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 07 Jul 2022 19:15:21 +0000
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     dhowells@redhat.com
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com,
        Enzo Matsumiya <ematsumiya@suse.de>
Subject: [PATCH 2/3] key.dns_resolver: refactor read_config()
Date:   Thu,  7 Jul 2022 16:15:06 -0300
Message-Id: <20220707191507.2013-3-ematsumiya@suse.de>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220707191507.2013-1-ematsumiya@suse.de>
References: <20220707191507.2013-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Create a key_dns_conf_t struct to hold config values (*).
Rework read_config() to take a config file path and return a
key_dns_conf_t. This avoids globals and create a structured way to map
between config file values and code.

(*) The only config option is still default_ttl

Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
---
 dns.afsdb.c        |  40 ++++----
 key.dns.h          |   2 +-
 key.dns_resolver.c | 222 ++++++++++++++++++++++++++++-----------------
 3 files changed, 161 insertions(+), 103 deletions(-)

diff --git a/dns.afsdb.c b/dns.afsdb.c
index 2241cf58e55c..806ae85c5632 100644
--- a/dns.afsdb.c
+++ b/dns.afsdb.c
@@ -63,11 +63,12 @@ static int afs_instantiate(payload_t *payload, unsigned int ttl)
  * Lookup VL servers for AFS.
  */
 __attribute__((noreturn))
-void afs_lookup_VL_servers(const char *cell, char *options)
+void afs_lookup_VL_servers(const char *cell, char *options, long config_ttl)
 {
 	payload_t *payload = NULL;
 	struct hostinfo host = { 0 };
 	char *vlsrv_name = NULL;
+	unsigned int ttl;
 	int ret = 0;
 
 	if (!cell)
@@ -107,28 +108,25 @@ void afs_lookup_VL_servers(const char *cell, char *options)
 	}
 
 	dump_payload(payload);
-	info("Key timeout will be %ld seconds", host.ttl);
-
-	if (!debug_mode) {
-		unsigned int ttl;
-
-		/*
-		 * If TTL was set through the config file (key_expiry),
-		 * it takes precedence over the one from the DNS record (stored
-		 * in host.ttl).
-		 */
-		if (key_expiry > -1)
-			ttl = (unsigned int)key_expiry;
-		else if (host.ttl > -1)
-			ttl = (unsigned int)host.ttl;
-		else
-			/* Fallback to default value if dns_resolver() couldn't
-			 * get TTL for some reason */
-			ttl = DEFAULT_KEY_TTL;
 
+	/*
+	 * If TTL was set through the config file (@config_ttl),
+	 * it takes precedence over the one from the DNS record (stored
+	 * in host.ttl).
+	 */
+	if (config_ttl > 0)
+		ttl = (unsigned int)config_ttl;
+	else if (host.ttl > 0)
+		ttl = (unsigned int)host.ttl;
+	else
+		/* Fallback to default value if dns_resolver() couldn't
+		 * get TTL for some reason */
+		ttl = DEFAULT_KEY_TTL;
+
+	info("Key timeout will be %u seconds", ttl);
+
+	if (!debug_mode)
 		ret = afs_instantiate(payload, ttl);
-	}
-
 out_free:
 	free_hostinfo(&host);
 	free(payload);
diff --git a/key.dns.h b/key.dns.h
index f522a51b92ce..25a815b82159 100644
--- a/key.dns.h
+++ b/key.dns.h
@@ -246,6 +246,6 @@ void dump_payload(payload_t *payload);
 int dns_resolver(hostinfo_t *host, payload_t *payload);
 
 /* AFS-specific DNS query function */
-void afs_lookup_VL_servers(const char *cell, char *options);
+void afs_lookup_VL_servers(const char *cell, char *options, long config_ttl);
 
 #endif /* _KEY_DNS_H */
diff --git a/key.dns_resolver.c b/key.dns_resolver.c
index 0c680caf98cc..8da7da6858a0 100644
--- a/key.dns_resolver.c
+++ b/key.dns_resolver.c
@@ -40,18 +40,27 @@
  */
 #include "key.dns.h"
 
+#define DEFAULT_CONFIG_FILE "/etc/keyutils/key.dns_resolver.conf"
+
 static const char *DNS_PARSE_VERSION = "1.0";
 static const char prog[] = "key.dns_resolver";
 static const char key_type[] = "dns_resolver";
 static const char a_query_type[] = "a";
 static const char aaaa_query_type[] = "aaaa";
 static const char afsdb_query_type[] = "afsdb";
-static const char *config_file = "/etc/keyutils/key.dns_resolver.conf";
-static bool config_specified = false;
 key_serial_t key;
 int verbose;
 int debug_mode;
-long key_expiry = DEFAULT_KEY_TTL;
+
+/*
+ * key.dns_resolver.conf struct
+ *
+ * XXX: if this ever grows too big, move to another file
+ */
+typedef struct _key_dns_conf {
+	long default_ttl;
+} key_dns_conf_t;
+
 
 void parse_opts(hostinfo_t *host, char *options)
 {
@@ -109,12 +118,17 @@ void parse_opts(hostinfo_t *host, char *options)
  *   "ipv4": to request only IPv4 addresses
  *   "ipv6": to request only IPv6 addresses
  *   "list": to get multiple addresses
+ * @config_ttl: TTL gotten from key.dns_resolver.conf (callers must set this to
+ *		-1 if no config)
+ *		XXX: might have to change this to a key_dns_conf_t if config
+ *		options increase.
  */
 static __attribute__((noreturn))
-int dns_query_a_or_aaaa(const char *hostname, char *options)
+int dns_query_a_or_aaaa(const char *hostname, char *options, long config_ttl)
 {
 	payload_t *payload = NULL;
 	hostinfo_t host = { 0 };
+	unsigned int ttl;
 	int ret = 0;
 
 	if (!hostname)
@@ -143,34 +157,31 @@ int dns_query_a_or_aaaa(const char *hostname, char *options)
 	}
 
 	dump_payload(payload);
-	info("Key timeout will be %ld seconds", host.ttl);
+
+	/*
+	 * If TTL was set through the config file (@config_ttl),
+	 * it takes precedence over the one from the DNS record (stored
+	 * in host.ttl).
+	 */
+	if (config_ttl > 0)
+		ttl = (unsigned int)config_ttl;
+	else if (host.ttl > 0)
+		ttl = (unsigned int)host.ttl;
+	else
+		/* Fallback to default value if dns_resolver() couldn't
+		 * get TTL for some reason */
+		ttl = DEFAULT_KEY_TTL;
+
+	info("Key timeout will be %u seconds", ttl);
 
 	/* load the key with data key */
 	if (!debug_mode) {
-		unsigned int ttl;
-
-		/*
-		 * If TTL was set through the config file (key_expiry),
-		 * it takes precedence over the one from the DNS record (stored
-		 * in host.ttl).
-		 */
-		if (key_expiry > -1)
-			ttl = (unsigned int)key_expiry;
-		else if (host.ttl > -1)
-			ttl = (unsigned int)host.ttl;
-		else
-			/* Fallback to default value if dns_resolver() couldn't
-			 * get TTL for some reason */
-			ttl = DEFAULT_KEY_TTL;
-
 		ret = keyctl_set_timeout(key, ttl);
 		if (ret) {
 			error("%s: keyctl_set_timeout: %m", __func__);
 			goto out_free;
 		}
 
-		info("Key set to timeout in %u seconds", ttl);
-
 		ret = keyctl_instantiate_iov(key, payload->data, payload->index, 0);
 		if (ret == -1)
 			error("%s: keyctl_instantiate: %m", __func__);
@@ -185,26 +196,42 @@ out_free:
 
 /*
  * Read the config file.
+ *
+ * @config_file: absolute path to the config file to use
+ *
+ * Returns a key_dns_conf_t on success, NULL otherwise (errno is set to
+ * something meaningful). Must be freed by the caller.
  */
-static void read_config(void)
+static key_dns_conf_t *read_config(const char *config_file)
 {
+	key_dns_conf_t *config = NULL;
 	FILE *f;
 	char buf[4096], *b, *p, *k, *v;
 	unsigned int line = 0;
 	long u;
 	int n;
 
-	info("READ CONFIG %s", config_file);
+	if (!config_file) {
+		error("Missing config file");
+		errno = -EINVAL;
+		return NULL;
+	}
+
+	info("Reading config %s", config_file);
+
+	CALLOC_CHECK(config, 1, sizeof(key_dns_conf_t));
 
 	f = fopen(config_file, "r");
 	if (!f) {
-		if (errno == ENOENT && !config_specified) {
-			debug("%s: %m", config_file);
-			return;
-		}
 		error("%s: %m", config_file);
+		goto out;
 	}
 
+#define cfgerr(msg) error("%s:%u: " msg, config_file, line)
+#define cfgerr_k(msg) error("%s:%u: %s: " msg, config_file, line, k)
+#define cfgerr_v(msg) error("%s:%u: %s: " msg " '%s'", config_file, line, k, v)
+
+	errno = -EINVAL;
 	while (fgets(buf, sizeof(buf) - 1, f)) {
 		line++;
 
@@ -217,8 +244,10 @@ static void read_config(void)
 		if (!*b || *b == '#')
 			continue;
 		p = strchr(b, '\n');
-		if (!p)
-			error("%s:%u: line missing newline or too long", config_file, line);
+		if (!p) {
+			cfgerr("line missing newline or too long");
+			goto out;
+		}
 		while (p > buf && isspace(p[-1]))
 			p--;
 		*p = 0;
@@ -231,9 +260,11 @@ static void read_config(void)
 			char quote = 0;
 			bool esc = false;
 
-			if (b == k)
-				error("%s:%u: Unspecified key",
-				      config_file, line);
+			if (b == k) {
+				errno = -EINVAL;
+				cfgerr("Unspecified key");
+				goto out;
+			}
 
 			/* NUL-terminate the key. */
 			for (p = b - 1; isspace(*p); p--)
@@ -244,8 +275,10 @@ static void read_config(void)
 			b++;
 			while (isspace(*b))
 				b++;
-			if (!*b)
-				goto missing_value;
+			if (!*b) {
+				cfgerr_k("Missing value");
+				goto out;
+			}
 
 			if (*b == '"' || *b == '\'') {
 				quote = *b;
@@ -262,7 +295,8 @@ static void read_config(void)
 					case '\\':
 						break;
 					default:
-						goto invalid_escape_char;
+						cfgerr_k("Invalid char in escape");
+						goto out;
 					}
 					esc = false;
 					*p++ = *b++;
@@ -275,8 +309,10 @@ static void read_config(void)
 				}
 				if (*b == quote) {
 					b++;
-					if (*b)
-						goto post_quote_data;
+					if (*b) {
+						cfgerr_k("Data after closing quote");
+						goto out;
+					}
 					quote = 0;
 					break;
 				}
@@ -285,53 +321,64 @@ static void read_config(void)
 				*p++ = *b++;
 			}
 
-			if (esc)
-				error("%s:%u: Incomplete escape", config_file, line);
-			if (quote)
-				error("%s:%u: Unclosed quotes", config_file, line);
+			if (esc) {
+				cfgerr("Incomplete escape");
+				goto out;
+			}
+			if (quote) {
+				cfgerr("Unclosed quotes");
+				goto out;
+			}
 			*p = 0;
 		}
 
 		if (strcmp(k, "default_ttl") == 0) {
-			if (!v)
-				goto missing_value;
-			if (sscanf(v, "%ld%n", &u, &n) != 1)
-				goto bad_value;
-			if (v[n])
-				goto extra_data;
-			if (u < 1 || u > LONG_MAX)
-				goto out_of_range;
-			key_expiry = u;
+			if (!v) {
+				cfgerr_k("Missing value");
+				goto out;
+			}
+			if (sscanf(v, "%ld%n", &u, &n) != 1) {
+				cfgerr_v("Bad value");
+				goto out;
+			}
+			if (v[n]) {
+				cfgerr_k("Extra data supplied");
+				goto out;
+			}
+			if (u < 1 || u > LONG_MAX) {
+				cfgerr_k("Value out of range");
+				goto out;
+			}
+			config->default_ttl = u;
 		} else {
 			warn("%s:%u: Unknown option '%s'", config_file, line, k);
 		}
 	}
 
-	if (ferror(f) || fclose(f) == EOF)
+	if (ferror(f) || fclose(f) == EOF) {
 		error("%s: %m", config_file);
-	return;
-
-missing_value:
-	error("%s:%u: %s: Missing value", config_file, line, k);
-invalid_escape_char:
-	error("%s:%u: %s: Invalid char in escape", config_file, line, k);
-post_quote_data:
-	error("%s:%u: %s: Data after closing quote", config_file, line, k);
-bad_value:
-	error("%s:%u: %s: Bad value", config_file, line, k);
-extra_data:
-	error("%s:%u: %s: Extra data supplied", config_file, line, k);
-out_of_range:
-	error("%s:%u: %s: Value out of range", config_file, line, k);
+		goto out;
+	}
+
+	errno = 0;
+	return config;
+out:
+	free(config);
+	return NULL;
 }
 
 /*
- * Dump the configuration after parsing the config file.
+ * Dump the configuration to stdout after parsing the config file.
  */
 static __attribute__((noreturn))
-void config_dumper(void)
+void dump_config(key_dns_conf_t *config)
 {
-	printf("default_ttl = %ld\n", key_expiry);
+	if (!config) {
+		error("No config loaded");
+		exit(-EINVAL);
+	}
+
+	printf("default_ttl = %ld\n", config->default_ttl);
 	exit(0);
 }
 
@@ -372,9 +419,10 @@ int main(int argc, char *argv[])
 	char *keyend, *p;
 	char *callout_info = NULL;
 	char *buf = NULL, *name;
-	bool dump_config = false;
-
-	key_expiry = -1;
+	bool opt_dump_config = false;
+	key_dns_conf_t *config = NULL;
+	char *config_file = NULL;
+	long ttl = -1;
 
 	openlog(prog, 0, LOG_DAEMON);
 
@@ -382,10 +430,9 @@ int main(int argc, char *argv[])
 		switch (ret) {
 		case 'c':
 			config_file = optarg;
-			config_specified = true;
 			continue;
 		case 2:
-			dump_config = true;
+			opt_dump_config = true;
 			continue;
 		case 'D':
 			debug_mode = 1;
@@ -408,10 +455,23 @@ int main(int argc, char *argv[])
 
 	argc -= optind;
 	argv += optind;
-	read_config();
 
-	if (dump_config)
-		config_dumper();
+	if (config_file)
+		config = read_config(config_file);
+	else
+		/* try to open the default config only if there wasn't one explicitly specified */
+		config = read_config(DEFAULT_CONFIG_FILE);
+
+	if (opt_dump_config)
+		dump_config(config);
+
+	if (config) {
+		ttl = config->default_ttl;
+		free(config);
+	} else {
+		info("No config file loaded. Using default values and/or from "
+		     "DNS records.");
+	}
 
 	if (!debug_mode) {
 		if (argc != 1)
@@ -467,7 +527,7 @@ int main(int argc, char *argv[])
 
 	name = index(keyend, ':');
 	if (!name)
-		dns_query_a_or_aaaa(keyend, callout_info);
+		dns_query_a_or_aaaa(keyend, callout_info, ttl);
 
 	qtlen = name - keyend;
 	name++;
@@ -481,7 +541,7 @@ int main(int argc, char *argv[])
 	    ) {
 		info("Do DNS query of A/AAAA type for '%s', with options '%s'",
 		     name, callout_info);
-		dns_query_a_or_aaaa(name, callout_info);
+		dns_query_a_or_aaaa(name, callout_info, ttl);
 	}
 
 	if (qtlen == sizeof(afsdb_query_type) - 1 &&
@@ -489,7 +549,7 @@ int main(int argc, char *argv[])
 	    ) {
 		info("Do AFS VL server query for '%s', with options '%s'",
 		     name, callout_info);
-		afs_lookup_VL_servers(name, callout_info);
+		afs_lookup_VL_servers(name, callout_info, ttl);
 	}
 
 	error("Query type: \"%*.*s\" is not supported", qtlen, qtlen, keyend);
-- 
2.35.3

