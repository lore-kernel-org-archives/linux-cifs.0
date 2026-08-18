Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F832D9484
	for <linux-cifs@vger.kernel.org>; Tue, 18 Aug 2026 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787080770; cv=none; b=l+ZIF4synkX+JQ9Uu+zXqVeFKDFkGLV3TxfOxu5dcG14mTdzppZhedzxjgFisY+BnIV63DExh/um0cdPEQ9JA8go8iZmD5jLscn3WYG7ZROcMSb73ehIb4G3/f3LTGaYS3o5o5Qmhi/1r0kATS+C3djEuUa0EmO76F+Jmoe68hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787080770; c=relaxed/simple;
	bh=x+ymKgqGZpdXN7SIdGh7urR4i9amw1jw3O3aw7fSmZs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gJesIo+wAoRObDoQlGKSfQSeuUKh3MAAyEKxf9MONXJLyl/62IA26BA63zEmsbdKVZjm7INUKDgmMwshiFU0+HSP5rC2yXTnGALz83hLlq0Tfp/7wayxX5iL2DJE0ACXG/iN/8++K616nOLQeuK8fIs3hh13YXIENpSkSK0q310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=kImr2Rbp; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="kImr2Rbp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:Message-ID:
	Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=ANonTxk1UfAm3Z0YQK/WRwEOohnT/Gh1rhevfAeFbUw=; b=kImr2RbpmKKv1YUbbO5Wuyeo6h
	l8NupsGfwcvQJ/jBswzV9UYmgD+mO8A8CWkLn1GVAvDsbG5kFp188gLgQ8OEAXL+p17bEqOi3VWj5
	8hIJ/5jTUEZ3Dpzz9GHMuJCbdAIt4oWK6TXwlPQzOIKRso24Mxv4dN5HQiXRGMg/0CYi5AAdNXmWz
	UZhzf3gjf1Izfn+k5RNNX+TcQAjSBot0c/aW8YqHk43foezzQ3KrPKLbIGRfmsij2dvY8hzq374p/
	b5Uudkn+tm5wq7azW90TYarhxBSjwRqvgXlfFdBpwHtwkW9Wo5Zs6HY1smUUUYAViZa27KRj+9Iu0
	GxxFNh8w==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1wwPLB-00000000Ei4-3D1w;
	Tue, 18 Aug 2026 16:19:17 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: Pavel Shilovsky <piastryyy@gmail.com>
Cc: Pierguido Lambri <plambri@redhat.com>,
	Frank Sorenson <sorenson@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>,
	Samuel Cabrero <scabrero@suse.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH] cifs.upcall: fix krb5 regression with --trust-dns
Date: Tue, 18 Aug 2026 16:19:17 -0300
Message-ID: <20260818191917.434889-1-pc@manguebit.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Customer reported randomly failed krb5 authentications against certain
servers when using --trust-dns parameter.  Turned out that the client
failed to establish sessions against those servers when using
CIFS/KRB5_NT_SRV_HST service principals.

Restore old behavior of always trying cifs/KRB5_NT_UNKNOWN service
principal first when using --trust-dns parameter.

Reported-by: Pierguido Lambri <plambri@redhat.com>
Reported-by: Frank Sorenson <sorenson@redhat.com>
Fixes: 562a6cb4f99c ("cifs.upcall: Retry krb5 TGS request with uppercase service name")
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Cc: Steve French <stfrench@microsoft.com>
Cc: Samuel Cabrero <scabrero@suse.com>
Cc: linux-cifs@vger.kernel.org
---
 cifs.upcall.c | 281 +++++++++++++++++++++++++-------------------------
 1 file changed, 140 insertions(+), 141 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 42205e66a676..76e88b79a760 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -698,22 +698,18 @@ out_free_principal:
 	return rc;
 }
 
-static int
-cifs_krb5_get_req(const char *host, krb5_ccache ccache,
-		  DATA_BLOB * mechtoken, DATA_BLOB * sess_key)
+static int cifs_krb5_get_req(const struct cifs_service_name *svc,
+			     const char *host, krb5_ccache ccache,
+			     DATA_BLOB *mechtoken, DATA_BLOB *sess_key)
 {
 	krb5_error_code ret;
 	krb5_keyblock *tokb;
-	krb5_creds in_creds, *out_creds;
+	krb5_creds in_creds = {}, *out_creds;
 	krb5_data apreq_pkt, in_data;
 	krb5_auth_context auth_context = NULL;
 #if defined(HAVE_KRB5_AUTH_CON_SETADDRS) && defined(HAVE_KRB5_AUTH_CON_SET_REQ_CKSUMTYPE)
 	static char gss_cksum[24] = { 0x10, 0x00, /* ... */};
 #endif
-	size_t count = sizeof(cifs_service_names) / sizeof(struct cifs_service_name);
-	size_t i = 0;
-
-	memset(&in_creds, 0, sizeof(in_creds));
 
 	ret = krb5_cc_get_principal(context, ccache, &in_creds.client);
 	if (ret) {
@@ -722,21 +718,16 @@ cifs_krb5_get_req(const char *host, krb5_ccache ccache,
 		return ret;
 	}
 
-	for (i = 0; i < count; i++) {
-		ret = krb5_sname_to_principal(context, host, cifs_service_names[i].name,
-				cifs_service_names[i].type, &in_creds.server);
-		if (ret) {
-			syslog(LOG_DEBUG, "%s: unable to convert sname to princ (%s).",
-			       __func__, host);
-			goto out_free_principal;
-		}
-
-		ret = krb5_get_credentials(context, 0, ccache, &in_creds, &out_creds);
-		krb5_free_principal(context, in_creds.server);
-		if (!ret) {
-			break;
-		}
+	ret = krb5_sname_to_principal(context, host, svc->name,
+				      svc->type, &in_creds.server);
+	if (ret) {
+		syslog(LOG_DEBUG, "%s: unable to convert sname to princ (%s).",
+		       __func__, host);
+		goto out_free_principal;
 	}
+
+	ret = krb5_get_credentials(context, 0, ccache, &in_creds, &out_creds);
+	krb5_free_principal(context, in_creds.server);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get credentials for %s",
 		       __func__, host);
@@ -849,8 +840,9 @@ void cifs_gss_display_status(char *msg, OM_uint32 maj_stat, OM_uint32 min_stat)
 	cifs_gss_display_status_1(msg, min_stat, GSS_C_MECH_CODE);
 }
 
-static int
-cifs_gss_get_req(const char *host, DATA_BLOB *mechtoken, DATA_BLOB *sess_key)
+static int cifs_gss_get_req(const struct cifs_service_name *svc,
+			    const char *host, DATA_BLOB *mechtoken,
+			    DATA_BLOB *sess_key)
 {
 	OM_uint32 maj_stat, min_stat;
 	gss_name_t target_name;
@@ -858,52 +850,43 @@ cifs_gss_get_req(const char *host, DATA_BLOB *mechtoken, DATA_BLOB *sess_key)
 	gss_buffer_desc output_token;
 	gss_krb5_lucid_context_v1_t *lucid_ctx = NULL;
 	gss_krb5_lucid_key_t *key = NULL;
-	size_t count = sizeof(cifs_service_names) / sizeof(struct cifs_service_name);
-	size_t i;
+	gss_buffer_desc target_name_buf;
+	size_t service_name_len;
+	char *service_name;
 
-	for (i = 0; i < count; i++) {
-		size_t service_name_len = strlen(cifs_service_names[i].name) +
-			1 /* @ */ + strlen(host) + 1;
-		char *service_name = malloc(service_name_len);
-		if (!service_name) {
-			syslog(LOG_DEBUG, "out of memory allocating service name");
-			maj_stat = GSS_S_FAILURE;
-			goto out;
-		}
-
-		snprintf(service_name, service_name_len, "%s@%s",
-			 cifs_service_names[i].name, host);
-		gss_buffer_desc target_name_buf;
-		target_name_buf.value = service_name;
-		target_name_buf.length = service_name_len;
-
-		maj_stat = gss_import_name(&min_stat, &target_name_buf,
-				GSS_C_NT_HOSTBASED_SERVICE, &target_name);
-		free(service_name);
-		if (GSS_ERROR(maj_stat)) {
-			cifs_gss_display_status("gss_import_name", maj_stat, min_stat);
-			goto out;
-		}
+	service_name_len = strlen(svc->name) + 1 /* @ */ + strlen(host) + 1;
+	service_name = malloc(service_name_len);
+	if (!service_name) {
+		syslog(LOG_DEBUG, "out of memory allocating service name");
+		maj_stat = GSS_S_FAILURE;
+		goto out;
+	}
 
-		maj_stat = gss_init_sec_context(&min_stat,
-				GSS_C_NO_CREDENTIAL, /* claimant_cred_handle */
-				&ctx,
-				target_name,
-				discard_const(gss_mech_krb5), /* force krb5 */
-				0, /* flags */
-				0, /* time_req */
-				GSS_C_NO_CHANNEL_BINDINGS, /* input_chan_bindings */
-				GSS_C_NO_BUFFER,
-				NULL, /* actual mech type */
-				&output_token,
-				NULL, /* ret_flags */
-				NULL); /* time_rec */
+	snprintf(service_name, service_name_len, "%s@%s", svc->name, host);
 
-		if (maj_stat == GSS_S_COMPLETE || maj_stat == GSS_S_CONTINUE_NEEDED) {
-			break;
-		}
-		(void) gss_release_name(&min_stat, &target_name);
+	target_name_buf.value = service_name;
+	target_name_buf.length = service_name_len;
+	maj_stat = gss_import_name(&min_stat, &target_name_buf,
+				   GSS_C_NT_HOSTBASED_SERVICE, &target_name);
+	free(service_name);
+	if (GSS_ERROR(maj_stat)) {
+		cifs_gss_display_status("gss_import_name", maj_stat, min_stat);
+		goto out;
 	}
+
+	maj_stat = gss_init_sec_context(&min_stat,
+			GSS_C_NO_CREDENTIAL, /* claimant_cred_handle */
+			&ctx,
+			target_name,
+			discard_const(gss_mech_krb5), /* force krb5 */
+			0, /* flags */
+			0, /* time_req */
+			GSS_C_NO_CHANNEL_BINDINGS, /* input_chan_bindings */
+			GSS_C_NO_BUFFER,
+			NULL, /* actual mech type */
+			&output_token,
+			NULL, /* ret_flags */
+			NULL); /* time_rec */
 	if (maj_stat != GSS_S_COMPLETE &&
 		maj_stat != GSS_S_CONTINUE_NEEDED) {
 		cifs_gss_display_status("init_sec_context", maj_stat, min_stat);
@@ -914,8 +897,7 @@ cifs_gss_get_req(const char *host, DATA_BLOB *mechtoken, DATA_BLOB *sess_key)
 	*mechtoken = data_blob(output_token.value, output_token.length);
 
 	maj_stat = gss_krb5_export_lucid_sec_context(&min_stat, &ctx, 1,
-							(void **)&lucid_ctx);
-
+						     (void **)&lucid_ctx);
 	if (GSS_ERROR(maj_stat)) {
 		cifs_gss_display_status("gss_krb5_export_lucid_sec_context",
 					maj_stat, min_stat);
@@ -972,9 +954,9 @@ out:
  *
  * ret: 0 - success, others - failure
  */
-static int
-handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
-		 DATA_BLOB * sess_key, krb5_ccache ccache)
+static int handle_krb5_mech(const char *oid, const struct cifs_service_name *svc,
+			    const char *host, DATA_BLOB *secblob,
+			    DATA_BLOB *sess_key, krb5_ccache ccache)
 {
 	int retval;
 	DATA_BLOB tkt_wrapped;
@@ -987,7 +969,7 @@ handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
 	 */
 	if (!ccache) {
 		syslog(LOG_DEBUG, "%s: using GSS-API", __func__);
-		retval = cifs_gss_get_req(host, &tkt_wrapped, sess_key);
+		retval = cifs_gss_get_req(svc, host, &tkt_wrapped, sess_key);
 		if (retval) {
 			syslog(LOG_DEBUG, "%s: failed to obtain service ticket via GSS (%d)",
 			__func__, retval);
@@ -998,7 +980,7 @@ handle_krb5_mech(const char *oid, const char *host, DATA_BLOB * secblob,
 		syslog(LOG_DEBUG, "%s: using native krb5", __func__);
 
 		/* get a kerberos ticket for the service and extract the session key */
-		retval = cifs_krb5_get_req(host, ccache, &tkt, sess_key);
+		retval = cifs_krb5_get_req(svc, host, ccache, &tkt, sess_key);
 		if (retval) {
 			syslog(LOG_DEBUG, "%s: failed to obtain service ticket (%d)",
 			       __func__, retval);
@@ -1570,6 +1552,83 @@ static const struct option long_options[] = {
 	{NULL, 0, NULL, 0}
 };
 
+static long get_spn_key_from_host(const struct decoded_args *arg,
+				  const struct cifs_service_name *svc,
+				  char *host, DATA_BLOB *secblob,
+				  DATA_BLOB *sess_key, bool try_dns,
+				  krb5_ccache ccache)
+{
+	char hostbuf[NI_MAXHOST] = {};
+	const char *oid;
+	long rc;
+
+	if (arg->sec == MS_KRB5)
+		oid = OID_KERBEROS5_OLD;
+	else
+		oid = OID_KERBEROS5;
+
+retry_new_hostname:
+	lowercase_string(host);
+	rc = handle_krb5_mech(oid, svc, host, secblob, sess_key, ccache);
+	if (!rc)
+		return rc;
+
+	/*
+	 * If hostname has a '.', assume it's a FQDN, otherwise we
+	 * want to guess the domainname.
+	 */
+	if (!strchr(host, '.')) {
+		struct addrinfo hints = {};
+		struct addrinfo *ai;
+		char *domainname;
+		char fqdn[NI_MAXHOST];
+
+		/*
+		 * use getaddrinfo() to resolve the hostname of the
+		 * server and set ai_canonname.
+		 */
+		hints.ai_family = AF_UNSPEC;
+		hints.ai_flags = AI_CANONNAME;
+		rc = getaddrinfo(host, NULL, &hints, &ai);
+		if (rc) {
+			syslog(LOG_ERR, "Unable to resolve host address: %s [%s]",
+			       host, gai_strerror(rc));
+			return rc;
+		}
+
+		/* scan forward to first '.' in ai_canonnname */
+		domainname = strchr(ai->ai_canonname, '.');
+		if (!domainname) {
+			rc = -EINVAL;
+			freeaddrinfo(ai);
+			return rc;
+		}
+		lowercase_string(domainname);
+		rc = snprintf(fqdn, sizeof(fqdn), "%s%s",
+			      host, domainname);
+		freeaddrinfo(ai);
+		if (rc < 0 || (size_t)rc >= sizeof(fqdn)) {
+			syslog(LOG_ERR, "Problem setting hostname in string: %ld", rc);
+			rc = -EINVAL;
+			return rc;
+		}
+
+		rc = handle_krb5_mech(oid, svc, fqdn, secblob, sess_key, ccache);
+		if (!rc)
+			return rc;
+	}
+
+	if (try_dns && (arg->have & DKD_HAVE_IP)) {
+		rc = ip_to_fqdn(arg->ip, hostbuf, sizeof(hostbuf));
+		if (rc)
+			return rc;
+		try_dns = false;
+		host = hostbuf;
+		goto retry_new_hostname;
+	}
+	return rc;
+}
+
 int main(const int argc, char *const argv[])
 {
 	struct cifs_spnego_msg *keydata = NULL;
@@ -1582,9 +1641,8 @@ int main(const int argc, char *const argv[])
 	int mask;
 	bool try_dns = false, legacy_uid = false , env_probe = true;
 	char *buf;
-	char hostbuf[NI_MAXHOST], *host;
+	char *host;
 	struct decoded_args *arg = NULL;
-	const char *oid;
 	uid_t uid;
 	gid_t gid;
 	struct passwd *pw;
@@ -1593,8 +1651,8 @@ int main(const int argc, char *const argv[])
 	krb5_ccache ccache = NULL;
 	unsigned expire_time = DNS_RESOLVER_DEFAULT_TIMEOUT;
 	const char *key_descr = NULL;
-
-	hostbuf[0] = '\0';
+	size_t i;
+	size_t num_spns = sizeof(cifs_service_names) / sizeof(cifs_service_names[0]);
 
 	openlog(prog, 0, LOG_DAEMON);
 	mask = LOG_UPTO(LOG_ERR);
@@ -1864,73 +1922,14 @@ int main(const int argc, char *const argv[])
 		 * TRY only:
 		 * cifs/bar.example.com@REALM
 		 */
-		if (arg->sec == MS_KRB5)
-			oid = OID_KERBEROS5_OLD;
-		else
-			oid = OID_KERBEROS5;
-
-retry_new_hostname:
-		lowercase_string(host);
-		rc = handle_krb5_mech(oid, host, &secblob, &sess_key, ccache);
-		if (!rc)
-			break;
-
-		/*
-		 * If hostname has a '.', assume it's a FQDN, otherwise we
-		 * want to guess the domainname.
-		 */
-		if (!strchr(host, '.')) {
-			struct addrinfo hints;
-			struct addrinfo *ai;
-			char *domainname;
-			char fqdn[NI_MAXHOST];
-
-			/*
-			 * use getaddrinfo() to resolve the hostname of the
-			 * server and set ai_canonname.
-			 */
-			memset(&hints, 0, sizeof(hints));
-			hints.ai_family = AF_UNSPEC;
-			hints.ai_flags = AI_CANONNAME;
-			rc = getaddrinfo(host, NULL, &hints, &ai);
-			if (rc) {
-				syslog(LOG_ERR, "Unable to resolve host address: %s [%s]",
-				       host, gai_strerror(rc));
-				break;
-			}
-
-			/* scan forward to first '.' in ai_canonnname */
-			domainname = strchr(ai->ai_canonname, '.');
-			if (!domainname) {
-				rc = -EINVAL;
-				freeaddrinfo(ai);
-				break;
-			}
-			lowercase_string(domainname);
-			rc = snprintf(fqdn, sizeof(fqdn), "%s%s",
-					host, domainname);
-			freeaddrinfo(ai);
-			if (rc < 0 || (size_t)rc >= sizeof(fqdn)) {
-				syslog(LOG_ERR, "Problem setting hostname in string: %ld", rc);
-				rc = -EINVAL;
-				break;
-			}
-
-			rc = handle_krb5_mech(oid, fqdn, &secblob, &sess_key, ccache);
+		for (i = 0; i < num_spns; i++) {
+			rc = get_spn_key_from_host(arg, &cifs_service_names[i],
+						   host, &secblob, &sess_key,
+						   try_dns, ccache);
 			if (!rc)
 				break;
 		}
-
-		if (!try_dns || !(arg->have & DKD_HAVE_IP))
-			break;
-
-		rc = ip_to_fqdn(arg->ip, hostbuf, sizeof(hostbuf));
-		if (rc)
-			break;
-
-		try_dns = false;
-		host = hostbuf;
-		goto retry_new_hostname;
+		break;
 	default:
 		syslog(LOG_ERR, "sectype: %d is not implemented", arg->sec);
 		rc = 1;
-- 
2.55.0

