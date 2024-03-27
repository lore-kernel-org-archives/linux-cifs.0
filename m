Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF56A487B4
	for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2024 10:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711533673; cv=none; b=sJRgRmV0us5DLbRWsHEc5D4Bgx2qxL1QCbq3SXc6Iupdflg5uaZYwhXOlm3PwbJP0U9/1F/K69LM/H7Gc6L55ILP/IWXepsxLCEJrtTMkZ9dMqYGMN57sUOumOreZ4b7i9ydmavFq+MkboGb/jPuqdf8aq0gne8i39U/blUeJFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711533673; c=relaxed/simple;
	bh=rUMcXT3tL/eSxmnNz9zBcbOOULF8X5UL2Wp8A4o5xiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eyUb/UMJW+wPgLlCfdvfUK3f5ECPT6mcj/7lUy7UY3F+lQyRvr8YaHLWcd105GJnIzShxAnFkKQB3wtkD3QIaayQd8qhXdfEYKlA37e3JGYcGQQ+zu+BYoe6LeoCwR53FmlIVLcBJbmFFR8yj5jCsU5kjIxNrkE7XFNgIjF6yIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m1dh3TOc; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m1dh3TOc"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-a44f2d894b7so796144666b.1
        for <linux-cifs@vger.kernel.org>; Wed, 27 Mar 2024 03:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1711533668; x=1712138468; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FYzyFT9ZM49hXEtoFU5IXE3TFC+8aFbWYt3+jT9M06I=;
        b=m1dh3TOcUBu+iufDVx/U8Gh0eNKYnYbWN31QI9zGGAkfeXEx1l0QMQkLMgQLiJCZpe
         0RHwgVsOn6K5Onx/eKebGARgNXxfkaFGvvmAFbFtfJ1vMC3wriXCZkEdVvQq/V8UxmPe
         hR6fGFmNHIpdOgQJ5sGjiDCkh3UX3has9bPNGn3o19RjfUPCiDGiFK1cnnctnfplc7MA
         vqfJUFcQofzXEM41fWcih29fMYWZwxUcap6CbGqpJwmR0lV/lEDZdWTdo49uVoB4O7kR
         ij2NUuXRRLpyXzaA64kKnMyvfWpFIKacu4uCtZBD6V3IE2RJEONA+IW25gaZGlLqz1y0
         PFXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711533668; x=1712138468;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYzyFT9ZM49hXEtoFU5IXE3TFC+8aFbWYt3+jT9M06I=;
        b=li1OFTroGCpFxQJys2OCQlRu0CiBrc+oYAUoBd1A2QTrHkuUOLi0APLJOvX5O5jPYy
         QQZAINUibRhFQFks9VOj0U/gUQoL4L2B41Gm7Mh4+dH5ml0788Bs2kiOUHlZG/PB4DMe
         FeNI2me0VKVUxCb9L76EgU+wRq093L5Us8dpsmQh7UB2j+J75ytmQMY95nFcTBO9UoeQ
         rQgiDjU7o3DCuYs18lSAb92XjrhqiyWkT9qghNTqErOF9zlkqSikQ4Q+gnHLufz5lLhF
         COMdHzpS/bAVk69ApwYvgAFaRQCH60fTiU4hwOS7q2rkGNFhETSYPasi3M6gfNXZMShq
         fesA==
X-Gm-Message-State: AOJu0YwFc8/gk8SeYtHpPAcbaxVnOyENKzPJKkWf7RB4k9Qd9f7X7pJD
	PvOQJM24UjWAmqG7HYzJvhmoiX5AqWLRtyl2QF3pO83infoW3VwW8qlw3AE=
X-Google-Smtp-Source: AGHT+IHTxbJHYjr3DKCJwwLvcYlOO/vo5TKywWtAPAjjcLPwwgo1R/BctQbZn6I9i6FMLyuWdHijnA==
X-Received: by 2002:a17:906:c452:b0:a4d:f98e:dc3e with SMTP id ck18-20020a170906c45200b00a4df98edc3emr2416495ejb.12.1711533667509;
        Wed, 27 Mar 2024 03:01:07 -0700 (PDT)
Received: from torus.fritz.box ([2a02:810d:b83f:e400:16a0:2f96:e202:fd52])
        by smtp.gmail.com with ESMTPSA id e5-20020a17090681c500b00a4a2bbee931sm3444249ejx.118.2024.03.27.03.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 03:01:07 -0700 (PDT)
From: David Voit <david.voit@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: David Voit <david.voit@gmail.com>
Subject: [PATCH v3 1/1] Implement CLDAP Ping to find the closest site
Date: Wed, 27 Mar 2024 11:00:18 +0100
Message-ID: <20240327100018.63694-2-david.voit@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240327100018.63694-1-david.voit@gmail.com>
References: <20240327100018.63694-1-david.voit@gmail.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For domain based DFS we always need to contact the domain controllers.
On setups, which are using bigger AD installations you could get random dc on the other side of the world,
if you don't have site support. This can lead to network timeouts and other problems.

CLDAP-Ping uses ASN.1 + UDP (CLDAP) and custom-DCE encoding including DName compressions without
field separation. Finally after finding the sitename we now need to do a DNS SRV lookups to find
the correct IPs to our closest site and fill up the remaining IPs from the global list.

Signed-off-by: David Voit <david.voit@gmail.com>
---
 Makefile.am    |  15 ++-
 cldap_ping.c   | 344 +++++++++++++++++++++++++++++++++++++++++++++++++
 cldap_ping.h   |   9 ++
 mount.cifs.c   |   5 +-
 resolve_host.c | 259 ++++++++++++++++++++++++++++++++-----
 resolve_host.h |   6 +-
 6 files changed, 600 insertions(+), 38 deletions(-)
 create mode 100644 cldap_ping.c
 create mode 100644 cldap_ping.h

diff --git a/Makefile.am b/Makefile.am
index 1a22266..7877823 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,8 +3,8 @@ ACLOCAL_AMFLAGS = -I aclocal
 
 root_exec_sbindir = $(ROOTSBINDIR)
 root_exec_sbin_PROGRAMS = mount.cifs
-mount_cifs_SOURCES = mount.cifs.c mtab.c resolve_host.c util.c
-mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD)
+mount_cifs_SOURCES = mount.cifs.c mtab.c $(resolve_hosts_SOURCES) util.c
+mount_cifs_LDADD = $(LIBCAP) $(CAPNG_LDADD) $(RT_LDADD) $(resolve_hosts_LDADD)
 include_HEADERS = cifsidmap.h
 rst_man_pages = mount.cifs.8
 
@@ -28,6 +28,9 @@ bin_PROGRAMS =
 bin_SCRIPTS =
 sbin_PROGRAMS =
 
+resolve_hosts_SOURCES = data_blob.c asn1.c cldap_ping.c resolve_host.c
+resolve_hosts_LDADD = -ltalloc -lresolv
+
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS += cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c
@@ -43,8 +46,8 @@ endif
 
 if CONFIG_CIFSCREDS
 bin_PROGRAMS += cifscreds
-cifscreds_SOURCES = cifscreds.c cifskey.c resolve_host.c util.c
-cifscreds_LDADD = -lkeyutils
+cifscreds_SOURCES = cifscreds.c cifskey.c $(resolve_hosts_SOURCES) util.c
+cifscreds_LDADD = -lkeyutils $(resolve_hosts_LDADD)
 
 rst_man_pages += cifscreds.1
 
@@ -105,8 +108,8 @@ endif
 if CONFIG_PAM
 pam_PROGRAMS = pam_cifscreds.so
 rst_man_pages += pam_cifscreds.8
-pam_cifscreds.so: pam_cifscreds.c cifskey.c resolve_host.c util.c
-	$(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ -lpam -lkeyutils
+pam_cifscreds.so: pam_cifscreds.c cifskey.c $(resolve_hosts_SOURCES) util.c
+	$(CC) $(DEFS) $(CFLAGS) $(AM_CFLAGS) $(LDFLAGS) -shared -fpic -o $@ $+ -lpam -lkeyutils $(resolve_hosts_LDADD)
 
 endif
 
diff --git a/cldap_ping.c b/cldap_ping.c
new file mode 100644
index 0000000..a98d71c
--- /dev/null
+++ b/cldap_ping.c
@@ -0,0 +1,344 @@
+/*
+ * CLDAP Ping to find closest ClientSiteName
+ *
+ * Copyright (C) 2024 David Voit (david.voit@gmail.com)
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <talloc.h>
+#include <string.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
+#include <unistd.h>
+#include <resolv.h>
+#include <stdbool.h>
+#include "data_blob.h"
+#include "asn1.h"
+
+#define LDAP_DNS_DOMAIN "DnsDomain"
+#define LDAP_DNS_DOMAIN_LEN strlen(LDAP_DNS_DOMAIN)
+#define LDAP_NT_VERSION "NtVer"
+#define LDAP_NT_VERSION_LEN strlen(LDAP_NT_VERSION)
+#define LDAP_ATTRIBUTE_NETLOGON "NetLogon"
+#define LDAP_ATTRIBUTE_NETLOGON_LEN strlen(LDAP_ATTRIBUTE_NETLOGON)
+
+
+// Parse a ASN.1 BER tag size-field, returns start of payload of tag
+char *parse_ber_size(char *buf, size_t *tag_size) {
+	size_t size = *buf & 0xff;
+	char *ret = (buf + 1);
+	if (size >= 0x81) {
+		switch (size) {
+			case 0x81:
+				size = *ret & 0xff;
+				ret += 1;
+				break;
+			case 0x82:
+				size = (*ret << 8) | (*(ret + 1) & 0xff);
+				ret += 2;
+				break;
+			case 0x83:
+				size = (*ret << 16) | (*(ret + 1) << 8) | (*(ret + 2) & 0xff);
+				ret += 3;
+				break;
+			case 0x84:
+				size = (*ret << 24) | (*(ret + 1) << 16) | (*(ret + 2) << 8) | (*(ret + 3) & 0xff);
+				ret += 4;
+				break;
+			default:
+				return NULL;
+		}
+	}
+
+	*tag_size = size;
+	return ret;
+}
+
+// simple wrapper over dn_expand which also calculates the new offset for the next compressed dn
+int read_dns_string(char *buf, size_t buf_size, char *dest, size_t dest_size, size_t *offset) {
+	int compressed_length = dn_expand((u_char *)buf, (u_char *)buf+buf_size, (u_char *)buf+*offset, dest, (int)dest_size);
+	if (compressed_length < 0) {
+		return -1;
+	}
+
+	*offset = *offset+compressed_length;
+
+	return 0;
+}
+
+// LDAP request for: (&(DnsDomain=DOMAIN_HERE)(NtVer=\\06\\00\\00\\00))
+ASN1_DATA *generate_cldap_query(char *domain) {
+	ASN1_DATA *data;
+	TALLOC_CTX *mem_ctx = talloc_init("cldap");
+
+	data = asn1_init(mem_ctx);
+	asn1_push_tag(data, ASN1_SEQUENCE(0));
+
+	// Message id
+	asn1_push_tag(data, ASN1_INTEGER);
+	asn1_write_uint8(data, 1);
+	asn1_pop_tag(data);
+
+	// SearchRequest
+	asn1_push_tag(data, ASN1_APPLICATION(3));
+
+	// empty baseObject
+	asn1_push_tag(data, ASN1_OCTET_STRING);
+	asn1_pop_tag(data);
+
+	// scope 0 = baseObject
+	asn1_push_tag(data, ASN1_ENUMERATED);
+	asn1_write_uint8(data, 0);
+	asn1_pop_tag(data);
+
+	// derefAliasses 0=neverDerefAlias
+	asn1_push_tag(data, ASN1_ENUMERATED);
+	asn1_write_uint8(data, 0);
+	asn1_pop_tag(data);
+
+	// sizeLimit
+	asn1_push_tag(data, ASN1_INTEGER);
+	asn1_write_uint8(data, 0);
+	asn1_pop_tag(data);
+
+	// timeLimit
+	asn1_push_tag(data, ASN1_INTEGER);
+	asn1_write_uint8(data, 0);
+	asn1_pop_tag(data);
+
+	// typesOnly
+	asn1_push_tag(data, ASN1_BOOLEAN);
+	asn1_write_uint8(data, 0);
+	asn1_pop_tag(data);
+
+	// AND
+	asn1_push_tag(data, ASN1_CONTEXT(0));
+	// equalityMatch
+	asn1_push_tag(data, ASN1_CONTEXT(3));
+	asn1_write_OctetString(data, LDAP_DNS_DOMAIN, LDAP_DNS_DOMAIN_LEN);
+	asn1_write_OctetString(data, domain, strlen(domain));
+	asn1_pop_tag(data);
+
+	// equalityMatch
+	asn1_push_tag(data, ASN1_CONTEXT(3));
+	asn1_write_OctetString(data, LDAP_NT_VERSION, LDAP_NT_VERSION_LEN);
+	// Bitmask NETLOGON_NT_VERSION_5 & NETLOGON_NT_VERSION_5EX -> To get NETLOGON_SAM_LOGON_RESPONSE_EX as response
+	asn1_write_OctetString(data, "\x06\x00\x00\x00", 4);
+	asn1_pop_tag(data);
+
+	// End AND
+	asn1_pop_tag(data);
+
+	asn1_push_tag(data, ASN1_SEQUENCE(0));
+	asn1_write_OctetString(data, LDAP_ATTRIBUTE_NETLOGON, LDAP_ATTRIBUTE_NETLOGON_LEN);
+	asn1_pop_tag(data);
+
+	// End SearchRequest
+	asn1_pop_tag(data);
+	// End Sequence
+	asn1_pop_tag(data);
+
+	return data;
+}
+
+// Input is a cldap response, output is a pointer to the NETLOGON_SAM_LOGON_RESPONSE_EX payload
+ssize_t extract_netlogon_section(char *buffer, size_t buffer_size, char **netlogon_payload) {
+	size_t ber_size;
+	size_t netlogon_payload_size;
+	// Not enough space to read initial sequence - not an correct cldap response
+	if (buffer_size < 7) {
+		return -1;
+	}
+
+	// Sequence tag
+	if (*buffer != 0x30) {
+		return -1;
+	}
+
+	char *message_id_tag = parse_ber_size(buffer + 1, &ber_size);
+
+	if (ber_size > buffer_size) {
+		return -1;
+	}
+
+	if (*message_id_tag != 0x02) {
+		return -1;
+	}
+
+	char *message_id = parse_ber_size(message_id_tag + 1, &ber_size);
+
+	if (ber_size != 1 || *message_id != 1) {
+		return -1;
+	}
+
+	// SearchResultEntry
+	if (*(message_id+1) != 0x64) {
+		return -1;
+	}
+
+	char *object_name_tag = parse_ber_size(message_id+2, &ber_size);
+	if (object_name_tag == NULL) {
+		return -1;
+	}
+
+	char *object_name = parse_ber_size(object_name_tag+1, &ber_size);
+	if (object_name == NULL) {
+		return -1;
+	}
+
+	if (*object_name_tag != 4 || ber_size != 0) {
+		return -1;
+	}
+
+	char *partial_attribute_list_tag = parse_ber_size(object_name+1, &ber_size);
+	if (partial_attribute_list_tag == NULL) {
+		return -1;
+	}
+
+	if (*partial_attribute_list_tag != 0x30) {
+		return -1;
+	}
+
+
+	char *partial_attribute_tag = parse_ber_size(partial_attribute_list_tag+1, &ber_size);
+	if (partial_attribute_tag == NULL) {
+		return -1;
+	}
+
+	char *attribute_name = parse_ber_size(partial_attribute_tag+1, &ber_size);
+	if (attribute_name == NULL) {
+		return -1;
+	}
+
+	if (ber_size != LDAP_ATTRIBUTE_NETLOGON_LEN) {
+		return -1;
+	}
+
+	if (strncasecmp(LDAP_ATTRIBUTE_NETLOGON, attribute_name, LDAP_ATTRIBUTE_NETLOGON_LEN) != 0) {
+		return -1;
+	}
+
+	// SET
+	if (*(attribute_name+LDAP_ATTRIBUTE_NETLOGON_LEN) != 0x31) {
+		return -1;
+	}
+
+	char *start_of_data = parse_ber_size(attribute_name+LDAP_ATTRIBUTE_NETLOGON_LEN+1, &ber_size);
+	if (start_of_data == NULL) {
+		return -1;
+	}
+
+	// octat-string of NetLogon data
+	if (*start_of_data != '\x04') {
+		return -1;
+	}
+
+	*netlogon_payload = parse_ber_size(start_of_data + 1, &netlogon_payload_size);
+
+	if (*netlogon_payload == NULL) {
+		*netlogon_payload = NULL;
+		return -1;
+	}
+
+	return (ssize_t)netlogon_payload_size;
+}
+
+int netlogon_get_client_site(char *netlogon_response, size_t netlogon_size, char *sitename) {
+	// 24 mandatory bytes
+	if (netlogon_size < 25) {
+		return -1;
+	}
+
+	// NETLOGON_SAM_LOGON_RESPONSE_EX Opcode: 0x17
+	if (*netlogon_response != 0x17 || *(netlogon_response + 1) != 0x00) {
+		return -1;
+	}
+
+	// skip over sbz, ds_flags and domain_guid
+	// and start directly at variable string portion of NETLOGON_SAM_LOGON_RESPONSE_EX
+	size_t offset = 24;
+
+	for (int i=0; i < 8; i++) {
+		// iterate over DnsForestName, DnsDomainName, NetbiosDomainName, NetbiosComputerName, UserName, DcSiteName
+		// to finally get to our desired ClientSiteName field
+		if (read_dns_string(netlogon_response, netlogon_size, sitename, MAXCDNAME, &offset) < 0) {
+			return -1;
+		}
+	}
+
+	return 0;
+}
+
+// returns -1 of fatal errors, and -2 on network errors
+// if we get one of those retry do the cldap ping again on a another dc
+// site_name must be of MAXCDNAME size!
+int cldap_ping(char *domain, sa_family_t family, void *addr, char *site_name) {
+	char buffer[8196];
+	ssize_t response_size;
+	char *netlogon_response;
+	ssize_t netlogon_size;
+	struct sockaddr_storage socketaddr;
+	size_t addr_size;
+	int sock = socket(family, SOCK_DGRAM, 0);
+	if (sock < 0) {
+		return -1;
+	}
+
+	ASN1_DATA *data = generate_cldap_query(domain);
+
+	if (family == AF_INET6) {
+		addr_size = sizeof(struct sockaddr_in6);
+		bzero((void *) &socketaddr, addr_size);
+		socketaddr.ss_family = AF_INET6;
+		((struct sockaddr_in6 *)&socketaddr)->sin6_addr = *((struct in6_addr*)addr);
+		((struct sockaddr_in6 *)&socketaddr)->sin6_port = htons(389);
+	} else {
+		addr_size = sizeof(struct sockaddr_in);
+		bzero((void *) &socketaddr, addr_size);
+		socketaddr.ss_family = AF_INET;
+		((struct sockaddr_in *)&socketaddr)->sin_addr = *((struct in_addr*)addr);
+		((struct sockaddr_in *)&socketaddr)->sin_port = htons(389);
+	}
+
+	struct timeval timeout = {.tv_sec = 2, .tv_usec = 0};
+	if (setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout)) < 0) {
+		return -1;
+	}
+	if (setsockopt(sock, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout)) < 0) {
+		return -1;
+	}
+
+	if (sendto(sock, data->data, data->length, 0, (struct sockaddr *)&socketaddr, addr_size) < 0) {
+		close(sock);
+		return -2;
+	}
+
+	asn1_free(data);
+
+	response_size = recv(sock, buffer, sizeof(buffer), 0);
+	close(sock);
+
+	if (response_size < 0) {
+		return -2;
+	}
+
+	netlogon_size = extract_netlogon_section(buffer, response_size, &netlogon_response);
+	if (netlogon_size < 0) {
+		return -1;
+	}
+
+	return netlogon_get_client_site(netlogon_response, netlogon_size, site_name);
+}
+
diff --git a/cldap_ping.h b/cldap_ping.h
new file mode 100644
index 0000000..5c8406e
--- /dev/null
+++ b/cldap_ping.h
@@ -0,0 +1,9 @@
+#ifndef _CLDAP_PING_H_
+#define _CLDAP_PING_H_
+
+// returns -1 of fatal errors, and -2 on network errors
+// if we get one of those retry do the cldap ping again on a another dc
+// site_name must be of MAXCDNAME size!
+int cldap_ping(char *domain, sa_family_t family, void *addr, char *site_name);
+
+#endif /* _CLDAP_PING_H_ */
diff --git a/mount.cifs.c b/mount.cifs.c
index 2278995..3b7a6b3 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -1889,8 +1889,11 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	if (rc)
 		goto assemble_exit;
 
-	if (parsed_info->addrlist[0] == '\0')
+	if (parsed_info->addrlist[0] == '\0') {
 		rc = resolve_host(parsed_info->host, parsed_info->addrlist);
+		if (rc == 0 && parsed_info->verboseflag)
+			fprintf(stderr, "Host \"%s\" resolved to the following IP addresses: %s\n", parsed_info->host, parsed_info->addrlist);
+	}
 
 	switch (rc) {
 	case EX_USAGE:
diff --git a/resolve_host.c b/resolve_host.c
index 17cbd10..4881f76 100644
--- a/resolve_host.c
+++ b/resolve_host.c
@@ -3,6 +3,7 @@
  *
  * Copyright (C) 2010 Jeff Layton (jlayton@samba.org)
  * Copyright (C) 2010 Igor Druzhinin (jaxbrigs@gmail.com)
+ * Copyright (C) 2024 David Voit (david.voit@gmail.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -27,15 +28,16 @@
 #include <sys/socket.h>
 #include <arpa/inet.h>
 #include <netdb.h>
+#include <resolv.h>
 #include "mount.h"
 #include "util.h"
+#include "cldap_ping.h"
 #include "resolve_host.h"
 
 /*
  * resolve hostname to comma-separated list of address(es)
  */
-int resolve_host(const char *host, char *addrstr)
-{
+int resolve_host(const char *host, char *addrstr) {
 	int rc;
 	/* 10 for max width of decimal scopeid */
 	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
@@ -44,6 +46,7 @@ int resolve_host(const char *host, char *addrstr)
 	struct addrinfo *addrlist, *addr;
 	struct sockaddr_in *sin;
 	struct sockaddr_in6 *sin6;
+	size_t count_v4 = 0, count_v6 = 0;
 
 	rc = getaddrinfo(host, NULL, NULL, &addrlist);
 	if (rc != 0)
@@ -53,40 +56,51 @@ int resolve_host(const char *host, char *addrstr)
 	while (addr) {
 		/* skip non-TCP entries */
 		if (addr->ai_socktype != SOCK_STREAM ||
-		    addr->ai_protocol != IPPROTO_TCP) {
+			addr->ai_protocol != IPPROTO_TCP) {
 			addr = addr->ai_next;
 			continue;
 		}
 
 		switch (addr->ai_addr->sa_family) {
-		case AF_INET6:
-			sin6 = (struct sockaddr_in6 *)addr->ai_addr;
-			ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
-					   sizeof(tmpbuf));
-			if (!ipaddr) {
-				rc = EX_SYSERR;
-				goto resolve_host_out;
-			}
+			case AF_INET6:
+				count_v6++;
+				if (count_v6 + count_v4 > MAX_ADDRESSES) {
+					addr = addr->ai_next;
+					continue;
+				}
 
-			if (sin6->sin6_scope_id) {
-				len = strnlen(tmpbuf, sizeof(tmpbuf));
-				snprintf(tmpbuf + len, sizeof(tmpbuf) - len, "%%%u",
-					 sin6->sin6_scope_id);
-			}
-			break;
-		case AF_INET:
-			sin = (struct sockaddr_in *)addr->ai_addr;
-			ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
-					   sizeof(tmpbuf));
-			if (!ipaddr) {
-				rc = EX_SYSERR;
-				goto resolve_host_out;
-			}
+				sin6 = (struct sockaddr_in6 *) addr->ai_addr;
+				ipaddr = inet_ntop(AF_INET6, &sin6->sin6_addr, tmpbuf,
+								   sizeof(tmpbuf));
+				if (!ipaddr) {
+					rc = EX_SYSERR;
+					goto resolve_host_out;
+				}
 
-			break;
-		default:
-			addr = addr->ai_next;
-			continue;
+
+				if (sin6->sin6_scope_id) {
+					len = strnlen(tmpbuf, sizeof(tmpbuf));
+					snprintf(tmpbuf + len, sizeof(tmpbuf) - len, "%%%u",
+							 sin6->sin6_scope_id);
+				}
+				break;
+			case AF_INET:
+				count_v4++;
+				if (count_v6 + count_v4 > MAX_ADDRESSES) {
+					addr = addr->ai_next;
+					continue;
+				}
+				sin = (struct sockaddr_in *) addr->ai_addr;
+				ipaddr = inet_ntop(AF_INET, &sin->sin_addr, tmpbuf,
+								   sizeof(tmpbuf));
+				if (!ipaddr) {
+					rc = EX_SYSERR;
+					goto resolve_host_out;
+				}
+				break;
+			default:
+				addr = addr->ai_next;
+				continue;
 		}
 
 		if (addr == addrlist)
@@ -98,6 +112,193 @@ int resolve_host(const char *host, char *addrstr)
 		addr = addr->ai_next;
 	}
 
+
+	// Is this a DFS domain where we need to do a cldap ping to find the closest node?
+	if (count_v4 > 1 || count_v6 > 1) {
+		int res;
+		ns_msg global_domain_handle;
+		unsigned char global_domain_lookup[4096];
+		ns_msg site_domain_handle;
+		unsigned char site_domain_lookup[4096];
+		char dname[MAXCDNAME];
+		int srv_cnt;
+
+		res = res_init();
+		if (res != 0)
+			goto resolve_host_out;
+
+
+		res = snprintf(dname, MAXCDNAME, "_ldap._tcp.dc._msdcs.%s", host);
+		if (res < 0)
+			goto resolve_host_out;
+
+		res = res_query(dname, C_IN, ns_t_srv, global_domain_lookup, sizeof(global_domain_lookup));
+		if (res < 0)
+			goto resolve_host_out;
+
+		// res is also the size of the response_buffer
+		res = ns_initparse(global_domain_lookup, res, &global_domain_handle);
+		if (res < 0)
+			goto resolve_host_out;
+
+		srv_cnt = ns_msg_count (global_domain_handle, ns_s_an);
+
+		// No or just one DC we are done
+		if (srv_cnt < 2)
+			goto resolve_host_out;
+
+		char site_name[MAXCDNAME];
+		// We assume that AD always sends the ip addresses in the addtional data block
+		for (int i = 0; i < ns_msg_count(global_domain_handle, ns_s_ar); i++) {
+			ns_rr rr;
+			res = ns_parserr(&global_domain_handle, ns_s_ar, i, &rr);
+			if (res < 0)
+				goto resolve_host_out;
+
+			switch (ns_rr_type(rr)) {
+				case ns_t_aaaa:
+					if (ns_rr_rdlen(rr) != NS_IN6ADDRSZ)
+						continue;
+					res = cldap_ping((char *) host, AF_INET6, (void *)ns_rr_rdata(rr), site_name);
+					break;
+				case ns_t_a:
+					if (ns_rr_rdlen(rr) != NS_INADDRSZ)
+						continue;
+					res = cldap_ping((char *) host, AF_INET, (void *)ns_rr_rdata(rr), site_name);
+					break;
+				default:
+					continue;
+			}
+
+			if (res == -2) {
+				continue;
+			}
+
+			if (res < 0) {
+				goto resolve_host_out;
+			}
+
+			if (site_name[0] == '\0') {
+				goto resolve_host_out;
+			} else {
+				// site found - leave loop
+				break;
+			}
+		}
+
+		res = snprintf(dname, MAXCDNAME, "_ldap._tcp.%s._sites.dc._msdcs.%s", site_name, host);
+		if (res < 0) {
+			goto resolve_host_out;
+		}
+
+		res = res_query(dname, C_IN, ns_t_srv, site_domain_lookup, sizeof(site_domain_lookup));
+		if (res < 0)
+			goto resolve_host_out;
+
+		// res is also the size of the response_buffer
+		res = ns_initparse(site_domain_lookup, res, &site_domain_handle);
+		if (res < 0)
+			goto resolve_host_out;
+
+		int number_addresses = 0;
+		for (int i = 0; i < ns_msg_count(site_domain_handle, ns_s_ar); i++) {
+			if (i > MAX_ADDRESSES)
+				break;
+
+			ns_rr rr;
+			res = ns_parserr(&site_domain_handle, ns_s_ar, i, &rr);
+			if (res < 0)
+				goto resolve_host_out;
+
+			switch (ns_rr_type(rr)) {
+				case ns_t_aaaa:
+					if (ns_rr_rdlen(rr) != NS_IN6ADDRSZ)
+						continue;
+					ipaddr = inet_ntop(AF_INET6, ns_rr_rdata(rr), tmpbuf,
+									   sizeof(tmpbuf));
+					if (!ipaddr) {
+						rc = EX_SYSERR;
+						goto resolve_host_out;
+					}
+					break;
+				case ns_t_a:
+					if (ns_rr_rdlen(rr) != NS_INADDRSZ)
+						continue;
+					ipaddr = inet_ntop(AF_INET, ns_rr_rdata(rr), tmpbuf,
+									   sizeof(tmpbuf));
+					if (!ipaddr) {
+						rc = EX_SYSERR;
+						goto resolve_host_out;
+					}
+					break;
+				default:
+					continue;
+			}
+
+			number_addresses++;
+
+			if (i == 0)
+				*addrstr = '\0';
+			else
+				strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
+
+			strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
+		}
+
+		// Preferred site ips is now the first entry in addrstr, fill up with other sites till MAX_ADDRESS
+		for (int i = 0; i < ns_msg_count(global_domain_handle, ns_s_ar); i++) {
+			if (number_addresses > MAX_ADDRESSES)
+				break;
+
+			ns_rr rr;
+			res = ns_parserr(&global_domain_handle, ns_s_ar, i, &rr);
+			if (res < 0)
+				goto resolve_host_out;
+
+			switch (ns_rr_type(rr)) {
+				case ns_t_aaaa:
+					if (ns_rr_rdlen(rr) != NS_IN6ADDRSZ)
+						continue;
+					ipaddr = inet_ntop(AF_INET6, ns_rr_rdata(rr), tmpbuf,
+									   sizeof(tmpbuf));
+					if (!ipaddr) {
+						rc = EX_SYSERR;
+						goto resolve_host_out;
+					}
+					break;
+				case ns_t_a:
+					if (ns_rr_rdlen(rr) != NS_INADDRSZ)
+						continue;
+					ipaddr = inet_ntop(AF_INET, ns_rr_rdata(rr), tmpbuf,
+									   sizeof(tmpbuf));
+					if (!ipaddr) {
+						rc = EX_SYSERR;
+						goto resolve_host_out;
+					}
+					break;
+				default:
+					continue;
+			}
+
+			char *found = strstr(addrstr, tmpbuf);
+
+			if (found) {
+				// We only have a real match if the substring is between  ',' or it's the last/first entry in the list
+				char previous_seperator = found > addrstr?*(found-1):'\0';
+				char next_seperator = *(found+strlen(tmpbuf));
+
+				if ((next_seperator == ',' || next_seperator == '\0')
+					&& (previous_seperator == ',' || previous_seperator == '\0')) {
+					continue;
+				}
+			}
+
+			number_addresses++;
+			strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
+			strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
+		}
+	}
+
 resolve_host_out:
 	freeaddrinfo(addrlist);
 	return rc;
diff --git a/resolve_host.h b/resolve_host.h
index b949245..f2b19e6 100644
--- a/resolve_host.h
+++ b/resolve_host.h
@@ -26,8 +26,10 @@
 /* currently maximum length of IPv6 address string */
 #define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
 
-/* limit list of addresses to 16 max-size addrs */
-#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * 16)
+#define MAX_ADDRESSES 16
+
+/* limit list of addresses to MAX_ADDRESSES max-size addrs */
+#define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * MAX_ADDRESSES)
 
 extern int resolve_host(const char *host, char *addrstr);
 
-- 
2.44.0

