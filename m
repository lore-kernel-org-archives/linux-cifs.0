From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/3] cifs.upcall: try and guess the domain name on unqualified names
Date: Sun, 13 Nov 2011 20:17:28 -0500
Message-ID: <1321233448-13548-4-git-send-email-jlayton@samba.org>
References: <1321233448-13548-1-git-send-email-jlayton@samba.org>
Cc: idra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321233448-13548-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Resolve the unqualified hostname and set AI_CANONNAME to make sure that
field is populated. Scan forward to the first '.' in ai_canonname, and
append that value onto the unqualified hostname to get a FQDN. Then
prepend that value with "cifs/" and try to get a service ticket for
that principal. If that fails prepend with "host/" and try again.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |   50 ++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 57ed0ba..ab3f87f 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -945,20 +945,58 @@ retry_new_hostname:
 			if (!rc)
 				break;
 		} else {
+			struct addrinfo hints;
+			struct addrinfo *ai;
+			char *domainname;
+
 			/* shortname: try AD-style first */
 			set_ad_principal(princ, host);
 			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
 			if (!rc)
 				break;
 
+			/* Try to guess the DNS domain name for the host. We must */
+
 			/*
-			 * FIXME: try to guess the DNS domain name for the host. We
-			 * must require that the kernel sends the IP addr in the upcall.
-			 *
-			 * Use getaddrinfo() to resolve the hostname of the server and
-			 * set ai_canonname. Then use the domainname in ai canonname
-			 * to turn the unqualified hostname into a FQDN.
+			 * use getaddrinfo() to resolve the hostname of the server
+			 * and set ai_canonname.
 			 */
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
+
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
+
+			/* now try "host/" */
+			memcpy(princ, "host", 4);
+			rc = handle_krb5_mech(oid, princ, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
 		}
 
 		if (!try_dns || !(have & DKD_HAVE_IP))
-- 
1.7.6.4
