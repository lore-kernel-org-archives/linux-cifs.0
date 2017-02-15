From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [cifs-utils PATCH v3 3/4] cifs.upcall: drop capabilities early in program
Date: Wed, 15 Feb 2017 11:13:24 -0500
Message-ID: <20170215161325.16914-5-jlayton@samba.org>
References: <20170215161325.16914-1-jlayton@samba.org>
Cc: cwseys-JAjqph6Yjy/rea2nFwT0Kw@public.gmane.org, simo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, samba-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170215161325.16914-1-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Much of cifs.upcall can and should be run without elevated privileges.
On entry into the program, drop as many capabilities as we can get away
with, and then always drop any remaining caps after calling setuid().

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 Makefile.am   |  2 +-
 cifs.upcall.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 64 insertions(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 2e99e601049a..4823b6381082 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -16,7 +16,7 @@ clean-local: clean-local-upcall clean-local-idmap clean-local-cifsacl
 if CONFIG_CIFSUPCALL
 sbin_PROGRAMS += cifs.upcall
 cifs_upcall_SOURCES = cifs.upcall.c data_blob.c asn1.c spnego.c
-cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD)
+cifs_upcall_LDADD = -ltalloc -lkeyutils $(KRB5_LDADD) $(CAPNG_LDADD)
 man_MANS += cifs.upcall.8
 
 #
diff --git a/cifs.upcall.c b/cifs.upcall.c
index 2b535a133a30..25af0fb6957b 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -54,6 +54,10 @@
 #include "spnego.h"
 #include "cifs_spnego.h"
 
+#ifdef HAVE_LIBCAP_NG
+#include <cap-ng.h>
+#endif
+
 static krb5_context	context;
 static const char	*prog = "cifs.upcall";
 
@@ -63,6 +67,58 @@ typedef enum _sectype {
 	MS_KRB5
 } sectype_t;
 
+#ifdef HAVE_LIBCAP_NG
+static int
+trim_capabilities(bool need_ptrace)
+{
+	capng_clear(CAPNG_SELECT_BOTH);
+
+	/*
+	 * Need ptrace for environment scraping, and setuid to change uid
+	 */
+	if (capng_updatev(CAPNG_ADD, CAPNG_PERMITTED|CAPNG_EFFECTIVE,
+			CAP_SETUID, CAP_SETGID, CAP_DAC_OVERRIDE, -1)) {
+		syslog(LOG_ERR, "%s: Unable to update capability set: %m\n", __func__);
+		return 1;
+	}
+
+	if (need_ptrace &&
+	    capng_update(CAPNG_ADD, CAPNG_PERMITTED|CAPNG_EFFECTIVE, CAP_SYS_PTRACE)) {
+		syslog(LOG_ERR, "%s: Unable to update capability set: %m\n", __func__);
+		return 1;
+	}
+
+	if (capng_apply(CAPNG_SELECT_BOTH)) {
+		syslog(LOG_ERR, "%s: Unable to apply capability set: %m\n", __func__);
+		return 1;
+	}
+	return 0;
+}
+
+static int
+drop_all_capabilities(void)
+{
+	capng_clear(CAPNG_SELECT_BOTH);
+	if (capng_apply(CAPNG_SELECT_BOTH)) {
+		syslog(LOG_ERR, "%s: Unable to apply capability set: %m\n", __func__);
+		return 1;
+	}
+	return 0;
+}
+#else /* HAVE_LIBCAP_NG */
+static int
+trim_capabilities(void)
+{
+	return 0;
+}
+
+static int
+drop_all_capabilities(void)
+{
+	return 0;
+}
+#endif /* HAVE_LIBCAP_NG */
+
 /*
  * smb_krb5_principal_get_realm
  *
@@ -733,6 +789,9 @@ int main(const int argc, char *const argv[])
 		}
 	}
 
+	if (trim_capabilities(false))
+		goto out;
+
 	/* is there a key? */
 	if (argc <= optind) {
 		usage();
@@ -837,6 +896,10 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
+	rc = drop_all_capabilities();
+	if (rc)
+		goto out;
+
 	rc = krb5_init_context(&context);
 	if (rc) {
 		syslog(LOG_ERR, "unable to init krb5 context: %ld", rc);
-- 
2.9.3
