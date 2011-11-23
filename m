From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 4/4] cifs.upcall: try and guess the domain name on unqualified names
Date: Wed, 23 Nov 2011 07:44:06 -0500
Message-ID: <1322052246-18707-5-git-send-email-jlayton@samba.org>
References: <1322052246-18707-1-git-send-email-jlayton@samba.org>
Cc: abartlet-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1322052246-18707-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Resolve the unqualified hostname and set AI_CANONNAME to make sure that
field is populated. Scan forward to the first '.' in ai_canonname, and
append that value onto the unqualified hostname to get a FQDN. Then
prepend that value with "cifs/" and try to get a service ticket for
that principal.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 42 insertions(+), 5 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 16dec81..f560d21 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -926,12 +926,49 @@ retry_new_hostname:
 			break;
 
 		/*
-		 * FIXME: try to guess the DNS domain name for non-FQDN's.
-		 *
-		 * Use getaddrinfo() to resolve the hostname of the server and
-		 * set ai_canonname. Then use the domainname in ai_canonname
-		 * to turn the unqualified hostname into a FQDN.
+		 * If hostname has a '.', assume it's a FQDN, otherwise we want to
+		 * guess the domainname.
 		 */
+		if (!strchr(host, '.')) {
+			struct addrinfo hints;
+			struct addrinfo *ai;
+			char *domainname;
+
+			/*
+			 * use getaddrinfo() to resolve the hostname of the server
+			 * and set ai_canonname.
+			 */
+			memset(&hints, 0, sizeof(hints));
+			hints.ai_family = AF_UNSPEC;
+			hints.ai_flags = AI_CANONNAME;
+			rc = getaddrinfo(host, NULL, &hints, &ai);
+			if (rc) {
+				syslog(LOG_ERR, "Unable to resolve host address: %s [%s]",
+				       host, gai_strerror(rc));
+				break;
+			}
+
+			/* scan forward to first '.' in ai_canonnname */
+			domainname = strchr(ai->ai_canonname, '.');
+			if (!domainname) {
+				rc = -EINVAL;
+				freeaddrinfo(ai);
+				break;
+			}
+			lowercase_string(domainname);
+			rc = snprintf(princ, sizeof(princ), "cifs/%s%s",
+					host, domainname);
+			freeaddrinfo(ai);
+			if (rc < 0 || (size_t)rc >= sizeof(princ)) {
+				syslog(LOG_ERR, "Problem setting hostname in string: %ld", rc);
+				rc = -EINVAL;
+				break;
+			}
+
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+		}
 
 		if (!try_dns || !(have & DKD_HAVE_IP))
 			break;
-- 
1.7.6.4
