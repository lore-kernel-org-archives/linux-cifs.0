From: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/3] cifs.upcall: use krb5_auth_con_set_req_cksumtype() and pass a GSSAPI checksum (bug #7890)
Date: Tue, 28 Dec 2010 09:41:33 +0100
Message-ID: <1293525693-11562-4-git-send-email-metze@samba.org>
References: <1293525693-11562-1-git-send-email-metze@samba.org>
Cc: Stefan Metzmacher <metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293525693-11562-1-git-send-email-metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Some closed source SMB servers doesn't support all checksum types,
so we should try to match windows clients.

This is almost the same logic which is used by Samba.

metze
---
 cifs.upcall.c |   40 ++++++++++++++++++++++++++++++++++++++++
 configure.ac  |    1 +
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index d895ccd..648a138 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -261,6 +261,9 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 	krb5_creds in_creds, *out_creds;
 	krb5_data apreq_pkt, in_data;
 	krb5_auth_context auth_context = NULL;
+#if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
+	static const uint8_t gss_cksum[24] = { 0x10, 0x00, /* ... */};
+#endif
 
 	ret = krb5_init_context(&context);
 	if (ret) {
@@ -309,6 +312,43 @@ cifs_krb5_get_req(const char *principal, const char *ccname,
 		goto out_free_creds;
 	}
 
+#if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
+	/* Ensure we will get an addressless ticket. */
+	ret = krb5_auth_con_setaddrs(context, auth_context, NULL, NULL);
+	if (ret) {
+		syslog(LOG_DEBUG, "%s: unable to set NULL addrs: %d",
+		       __func__, ret);
+		goto out_free_auth;
+	}
+
+	/*
+	 * Create a GSSAPI checksum (0x8003), see RFC 4121.
+	 *
+	 * The current layout is
+	 *
+	 * 0x10, 0x00, 0x00, 0x00 - length = 16
+	 * 0x00, 0x00, 0x00, 0x00 - channel binding info - 16 zero bytes
+	 * 0x00, 0x00, 0x00, 0x00
+	 * 0x00, 0x00, 0x00, 0x00
+	 * 0x00, 0x00, 0x00, 0x00
+	 * 0x00, 0x00, 0x00, 0x00 - flags
+	 *
+	 * GSS_C_NO_CHANNEL_BINDINGS means 16 zero bytes,
+	 * this is needed to work against some closed source
+	 * SMB servers.
+	 *
+	 * See https://bugzilla.samba.org/show_bug.cgi?id=7890
+	 */
+	in_data.data = discard_const_p(char, gss_cksum);
+	in_data.length = 24;
+	ret = krb5_auth_con_set_req_cksumtype(context, auth_context, 0x8003);
+	if (ret) {
+		syslog(LOG_DEBUG, "%s: unable to set 0x8003 checksum",
+		       __func__);
+		goto out_free_auth;
+	}
+#endif
+
 	apreq_pkt.length = 0;
 	apreq_pkt.data = NULL;
 	ret = krb5_mk_req_extended(context, &auth_context, AP_OPTS_USE_SUBKEY,
diff --git a/configure.ac b/configure.ac
index 093b48d..53b698d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -133,6 +133,7 @@ fi
 # non-critical functions (we have workarounds for these)
 if test $enable_cifsupcall != "no"; then
 	AC_CHECK_FUNCS([krb5_principal_get_realm krb5_free_unparsed_name])
+	AC_CHECK_FUNCS([krb5_auth_con_setaddrs krb5_auth_con_set_req_cksumtype])
 fi
 
 LIBS=$cu_saved_libs
-- 
1.7.0.4
