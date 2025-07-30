Received: from air.basealt.ru (air.basealt.ru [193.43.8.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE665347DD
	for <linux-cifs@vger.kernel.org>; Wed, 30 Jul 2025 17:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.43.8.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753895372; cv=none; b=IL1DyAfSNztZ2bx8X1Sz6jX9uF/mrAfs3PIWJrWEjnlkIaAwaPtHo+4PT9oO6Q6/0McAlBhhjhzoJy8DXX88BxqM4j28vXGdcu8fiBNrQ7tKKZeOa/z12fY3XPwnV7BlEbAkHayldKG3Lls6aPGvwRm8VwHMC/tt+W7UI7tiYKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753895372; c=relaxed/simple;
	bh=zIi9Ql5cb5HasNHayjI8capNnCJthbN+ja/e+bHg6TI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppO6ENbouzrRhos7kBLgziIxcA2jy8dmO925ktpbmn05BscnazskLjzbkqBECVLUY/khWLm/vkJsNNH/sg6l8kc1Pnj0ILFfO0fxV9jHaj9eIzQ6n3WDH9kgzLvij52TMn+vw/1+dWColEd3hRcUS60+3aSPi9lYSClXfwfeeIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org; spf=pass smtp.mailfrom=altlinux.org; arc=none smtp.client-ip=193.43.8.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=altlinux.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=altlinux.org
Received: from lenovo-93812.smb.basealt.ru (unknown [193.43.9.250])
	(Authenticated sender: alekseevamo)
	by air.basealt.ru (Postfix) with ESMTPSA id C94B423372;
	Wed, 30 Jul 2025 20:09:26 +0300 (MSK)
From: Maria Alexeeva <alxvmr@altlinux.org>
To: smfrench@gmail.com
Cc: pc@manguebit.com,
	linux-cifs@vger.kernel.org,
	ivolchenko86@gmail.com,
	samba-technical@lists.samba.org,
	vt@altlinux.org,
	tom@talpey.com,
	Maria Alexeeva <alxvmr@altlinux.org>
Subject: [PATCH] mount.cifs: add support for domain-based DFS targets with Kerberos via hostname resolution
Date: Wed, 30 Jul 2025 21:09:04 +0400
Message-ID: <20250730170904.156323-1-alxvmr@altlinux.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
References: <8f2ad82d-0dd4-4195-b414-59f25f859a9e@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enhance the mount.cifs utility to support mounting of domain-based DFS shares using
Kerberos authentication by enabling hostname-based resolution of DFS targets.

Previously, only IP addresses were resolved and passed to the kernel, which
prevented Kerberos from functioning properly with DFS shares
that require hostname-based access.

This patch:
1. Adds hostlist support to track hostnames alongside resolved IP addresses.
2. Modifies resolve_host() into resolve_host_with_names() to collect both IPs and
   associated DNS names.
3. Updates mount retry logic to iterate over hostnames as well as addresses.
4. Appends hostname= mount option when available to allow the kernel to use
   hostname for Kerberos validation.
5. Includes fallback to existing logic when Kerberos is not used.
6. Introduces helper iterlist() to simplify parsing of comma-separated lists.
7. Buffer size fix for AD site names: Updates the buffer size used to store
   Active Directory site names from MAXCDNAME to MAXLABEL, in line with
   Active Directory specifications.
   According to [MS-ADTS] and RFC 1035, site names in AD are limited to DNS label
   size (MAXLABEL, 63 bytes), not full domain name size (MAXCDNAME, 255 bytes).

Suggested-by: Ivan Volchenko <ivolchenko86@gmail.com>
Signed-off-by: Maria Alexeeva <alxvmr@altlinux.org>
---
 cldap_ping.c   |  2 +-
 cldap_ping.h   |  2 +-
 mount.cifs.c   | 28 +++++++++++++++++-----------
 resolve_host.c | 43 ++++++++++++++++++++++++++++++++++++-------
 resolve_host.h |  5 +++++
 util.c         | 14 ++++++++++++++
 util.h         |  1 +
 7 files changed, 75 insertions(+), 20 deletions(-)

diff --git a/cldap_ping.c b/cldap_ping.c
index 5c20f84..e8cba50 100644
--- a/cldap_ping.c
+++ b/cldap_ping.c
@@ -280,7 +280,7 @@ int netlogon_get_client_site(char *netlogon_response, size_t netlogon_size, char
 	for (int i=0; i < 8; i++) {
 		// iterate over DnsForestName, DnsDomainName, NetbiosDomainName, NetbiosComputerName, UserName, DcSiteName
 		// to finally get to our desired ClientSiteName field
-		if (read_dns_string(netlogon_response, netlogon_size, sitename, MAXCDNAME, &offset) < 0) {
+		if (read_dns_string(netlogon_response, netlogon_size, sitename, MAXLABEL, &offset) < 0) {
 			return CLDAP_PING_PARSE_ERROR_NETLOGON;
 		}
 	}
diff --git a/cldap_ping.h b/cldap_ping.h
index 9a23e72..a15a14c 100644
--- a/cldap_ping.h
+++ b/cldap_ping.h
@@ -8,7 +8,7 @@
 
 // returns CLDAP_PING_TRYNEXT if you should use another dc
 // any other error code < 0 is a fatal error
-// site_name must be of MAXCDNAME size!
+// site_name must be of MAXLABEL size!
 int cldap_ping(char *domain, sa_family_t family, void *addr, char *site_name);
 
 #endif /* _CLDAP_PING_H_ */
diff --git a/mount.cifs.c b/mount.cifs.c
index 1923913..d50af71 100644
--- a/mount.cifs.c
+++ b/mount.cifs.c
@@ -190,6 +190,7 @@ struct parsed_mount_info {
 	char password[MOUNT_PASSWD_SIZE + 1];
 	char password2[MOUNT_PASSWD_SIZE + 1];
 	char addrlist[MAX_ADDR_LIST_LEN];
+	char hostlist[MAX_HOST_LIST_LEN];
 	unsigned int got_user:1;
 	unsigned int got_password:1;
 	unsigned int got_password2:1;
@@ -1939,6 +1940,7 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 {
 	int rc;
 	char *newopts = NULL;
+	char *hostlist;
 
 	rc = drop_capabilities(0);
 	if (rc)
@@ -1983,8 +1985,10 @@ assemble_mountinfo(struct parsed_mount_info *parsed_info,
 	if (rc)
 		goto assemble_exit;
 
+	parsed_info->hostlist[0] = '\0';
 	if (parsed_info->addrlist[0] == '\0') {
-		rc = resolve_host(parsed_info->host, parsed_info->addrlist);
+		hostlist = parsed_info->is_krb5 ? parsed_info->hostlist : NULL;
+		rc = resolve_host_with_names(parsed_info->host, parsed_info->addrlist, hostlist);
 		if (rc == 0 && parsed_info->verboseflag)
 			fprintf(stderr, "Host \"%s\" resolved to the following IP addresses: %s\n", parsed_info->host, parsed_info->addrlist);
 	}
@@ -2142,6 +2146,7 @@ int main(int argc, char **argv)
 	char *options = NULL;
 	char *orig_dev = NULL;
 	char *currentaddress, *nextaddress;
+	char *currenthost, *nexthost;
 	char *value = NULL;
 	char *ep = NULL;
 	int rc = 0;
@@ -2300,12 +2305,14 @@ assemble_retry:
 	}
 
 	currentaddress = parsed_info->addrlist;
-	nextaddress = strchr(currentaddress, ',');
-	if (nextaddress)
-		*nextaddress++ = '\0';
+	nextaddress = NULL;
+	currenthost = parsed_info->hostlist;
+	nexthost = NULL;
 
 mount_retry:
 	options[0] = '\0';
+	iterlist(&currentaddress, &nextaddress);
+	iterlist(&currenthost, &nexthost);
 	if (!currentaddress) {
 		fprintf(stderr, "Unable to find suitable address.\n");
 		rc = parsed_info->nofail ? 0 : EX_FAIL;
@@ -2329,9 +2336,14 @@ mount_retry:
 		strlcat(options, parsed_info->prefix, options_size);
 	}
 
-	if (sloppy)
+	if (sloppy || currenthost)
 		strlcat(options, ",sloppy", options_size);
 
+	if (currenthost) {
+		strlcat(options, ",dfs_domain_hostname=", options_size);
+		strlcat(options, currenthost, options_size);
+	}
+
 	if (parsed_info->verboseflag)
 		fprintf(stderr, "%s kernel mount options: %s",
 			thisprogram, options);
@@ -2378,12 +2390,6 @@ mount_retry:
 				fprintf(stderr, "mount error(%d): could not connect to %s",
 					errno, currentaddress);
 			}
-			currentaddress = nextaddress;
-			if (currentaddress) {
-				nextaddress = strchr(currentaddress, ',');
-				if (nextaddress)
-					*nextaddress++ = '\0';
-			}
 			goto mount_retry;
 		case ENODEV:
 			fprintf(stderr,
diff --git a/resolve_host.c b/resolve_host.c
index 918c6ad..5b6aed8 100644
--- a/resolve_host.c
+++ b/resolve_host.c
@@ -37,7 +37,7 @@
 /*
  * resolve hostname to comma-separated list of address(es)
  */
-int resolve_host(const char *host, char *addrstr) {
+int resolve_host_with_names(const char *host, char *addrstr, char *hoststr) {
 	int rc;
 	/* 10 for max width of decimal scopeid */
 	char tmpbuf[NI_MAXHOST + 1 + 10 + 1];
@@ -114,7 +114,7 @@ int resolve_host(const char *host, char *addrstr) {
 
 
 	// Is this a DFS domain where we need to do a cldap ping to find the closest node?
-	if (count_v4 > 1 || count_v6 > 1) {
+	if (count_v4 > 1 || count_v6 > 1 || hoststr) {
 		int res;
 		ns_msg global_domain_handle;
 		unsigned char global_domain_lookup[4096];
@@ -122,6 +122,8 @@ int resolve_host(const char *host, char *addrstr) {
 		unsigned char site_domain_lookup[4096];
 		char dname[MAXCDNAME];
 		int srv_cnt;
+		int number_addresses = 0;
+		const char *hostname;
 
 		res = res_init();
 		if (res != 0)
@@ -144,7 +146,7 @@ int resolve_host(const char *host, char *addrstr) {
 
 		// No or just one DC we are done
 		if (srv_cnt < 2)
-			goto resolve_host_out;
+			goto resolve_host_global;
 
 		char site_name[MAXCDNAME];
 		site_name[0] = '\0';
@@ -200,7 +202,6 @@ int resolve_host(const char *host, char *addrstr) {
 		if (res < 0)
 			goto resolve_host_out;
 
-		int number_addresses = 0;
 		for (int i = 0; i < ns_msg_count(site_domain_handle, ns_s_ar); i++) {
 			if (i > MAX_ADDRESSES)
 				break;
@@ -214,6 +215,7 @@ int resolve_host(const char *host, char *addrstr) {
 				case ns_t_aaaa:
 					if (ns_rr_rdlen(rr) != NS_IN6ADDRSZ)
 						continue;
+					hostname = ns_rr_name(rr);
 					ipaddr = inet_ntop(AF_INET6, ns_rr_rdata(rr), tmpbuf,
 									   sizeof(tmpbuf));
 					if (!ipaddr) {
@@ -224,6 +226,7 @@ int resolve_host(const char *host, char *addrstr) {
 				case ns_t_a:
 					if (ns_rr_rdlen(rr) != NS_INADDRSZ)
 						continue;
+					hostname = ns_rr_name(rr);
 					ipaddr = inet_ntop(AF_INET, ns_rr_rdata(rr), tmpbuf,
 									   sizeof(tmpbuf));
 					if (!ipaddr) {
@@ -237,14 +240,22 @@ int resolve_host(const char *host, char *addrstr) {
 
 			number_addresses++;
 
-			if (i == 0)
+			if (i == 0) {
 				*addrstr = '\0';
-			else
+				if (hoststr)
+					*hoststr = '\0';
+			} else {
 				strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
+				if (hoststr)
+					strlcat(hoststr, ",", MAX_ADDR_LIST_LEN);
+			}
 
 			strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
+			if (hoststr)
+				strlcat(hoststr, hostname, MAX_HOST_LIST_LEN);
 		}
 
+resolve_host_global:
 		// Preferred site ips is now the first entry in addrstr, fill up with other sites till MAX_ADDRESS
 		for (int i = 0; i < ns_msg_count(global_domain_handle, ns_s_ar); i++) {
 			if (number_addresses > MAX_ADDRESSES)
@@ -259,6 +270,7 @@ int resolve_host(const char *host, char *addrstr) {
 				case ns_t_aaaa:
 					if (ns_rr_rdlen(rr) != NS_IN6ADDRSZ)
 						continue;
+					hostname = ns_rr_name(rr);
 					ipaddr = inet_ntop(AF_INET6, ns_rr_rdata(rr), tmpbuf,
 									   sizeof(tmpbuf));
 					if (!ipaddr) {
@@ -269,6 +281,7 @@ int resolve_host(const char *host, char *addrstr) {
 				case ns_t_a:
 					if (ns_rr_rdlen(rr) != NS_INADDRSZ)
 						continue;
+					hostname = ns_rr_name(rr);
 					ipaddr = inet_ntop(AF_INET, ns_rr_rdata(rr), tmpbuf,
 									   sizeof(tmpbuf));
 					if (!ipaddr) {
@@ -280,6 +293,12 @@ int resolve_host(const char *host, char *addrstr) {
 					continue;
 			}
 
+			if (number_addresses == 0) {
+				*addrstr = '\0';
+				if (hoststr)
+					*hoststr = '\0';
+			}
+
 			char *found = strstr(addrstr, tmpbuf);
 
 			if (found) {
@@ -293,9 +312,15 @@ int resolve_host(const char *host, char *addrstr) {
 				}
 			}
 
+			if (number_addresses > 0) {
+				strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
+				if (hoststr)
+					strlcat(hoststr, ",", MAX_HOST_LIST_LEN);
+			}
 			number_addresses++;
-			strlcat(addrstr, ",", MAX_ADDR_LIST_LEN);
 			strlcat(addrstr, tmpbuf, MAX_ADDR_LIST_LEN);
+			if (hoststr)
+				strlcat(hoststr, hostname, MAX_HOST_LIST_LEN);
 		}
 	}
 
@@ -303,3 +328,7 @@ resolve_host_out:
 	freeaddrinfo(addrlist);
 	return rc;
 }
+
+int resolve_host(const char *host, char *addrstr) {
+	return resolve_host_with_names(host, addrstr, NULL);
+}
diff --git a/resolve_host.h b/resolve_host.h
index f2b19e6..b507757 100644
--- a/resolve_host.h
+++ b/resolve_host.h
@@ -22,6 +22,7 @@
 #define _RESOLVE_HOST_H_
 
 #include <arpa/inet.h>
+#include <resolv.h>
 
 /* currently maximum length of IPv6 address string */
 #define MAX_ADDRESS_LEN INET6_ADDRSTRLEN
@@ -31,6 +32,10 @@
 /* limit list of addresses to MAX_ADDRESSES max-size addrs */
 #define MAX_ADDR_LIST_LEN ((MAX_ADDRESS_LEN + 1) * MAX_ADDRESSES)
 
+/* limit list of hostnames to MAX_ADDRESSES max-size names */
+#define MAX_HOST_LIST_LEN ((MAXCDNAME + 1) * MAX_ADDRESSES)
+
+extern int resolve_host_with_names(const char *host, char *addrstr, char *hoststr);
 extern int resolve_host(const char *host, char *addrstr);
 
 #endif /* _RESOLVE_HOST_H_ */
diff --git a/util.c b/util.c
index 546f284..c722df5 100644
--- a/util.c
+++ b/util.c
@@ -83,3 +83,17 @@ getusername(uid_t uid)
 	return username;
 }
 
+int
+iterlist(char **curr, char **next) {
+    if (!*curr || *curr[0] == '\0' || *curr == *next) {
+        *curr = *next = NULL;
+        return 0;
+    }
+    *curr = *next ? *next : *curr;
+    *next = strchr(*curr, ',');
+    if (*next)
+        *(*next)++ = '\0';
+    else
+        *next = *curr;
+    return 1;
+}
diff --git a/util.h b/util.h
index 2864130..59e4200 100644
--- a/util.h
+++ b/util.h
@@ -29,5 +29,6 @@ extern size_t strlcpy(char *d, const char *s, size_t bufsize);
 extern size_t strlcat(char *d, const char *s, size_t bufsize);
 
 extern char *getusername(uid_t uid);
+extern int iterlist(char **curr, char **next);
 #endif /* _LIBUTIL_H */
 

base-commit: edac7178bec9520fb57d14946e67f5dd33b82d43
-- 
2.50.1

