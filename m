From: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC/PATCH] cifs.upcall: use kernel.provided principal name if available
Date: Tue,  6 Sep 2011 17:26:34 +0200
Message-ID: <1315322794-10725-1-git-send-email-martin.wilck@ts.fujitsu.com>
References: <1315322512-10652-1-git-send-email-martin.wilck@ts.fujitsu.com>
Cc: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
	Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1315322512-10652-1-git-send-email-martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This patch complements the kernel patch
"cifs: add server-provided principal name in upcall". When cifs.upcall
is started with -p, the kernel-provided principal name from the initial
negotiation with the server will be used to obtain a ticket. If this fails,
"cifs/<hostname>" and "host/hostname" fallbacks will be tried as fallback.

This will enable kerberos-based CIFS mounts on more servers, and make
mount.cifs work more similar to smbclient.

Note that the "-p" option must be added in the cifs.upcall line in
/etc/request-key.conf to activate this.

Signed-off-by: Martin Wilck <martin.wilck-RJz4owOZxyXQFUHtdCDX3A@public.gmane.org>
---
 cifs.upcall.8.in |    6 ++++++
 cifs.upcall.c    |   38 +++++++++++++++++++++++++++++++-------
 cifs_spnego.h    |    2 +-
 3 files changed, 38 insertions(+), 8 deletions(-)

diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
index 03842b7..7d90d1e 100644
--- a/cifs.upcall.8.in
+++ b/cifs.upcall.8.in
@@ -52,6 +52,12 @@ Traditionally, the kernel has sent only a single uid= parameter to the upcall fo
 Newer kernels send a creduid= option as well, which contains what uid it thinks actually owns the credentials that it\'s looking for\&. At mount time, this is generally set to the real uid of the user doing the mount. For multisession mounts, it's set to the fsuid of the mount user. Set this option if you want cifs.upcall to use the older uid= parameter instead of the creduid= parameter\&.
 .RE
 .PP
+\-\-principal\-from\-kernel|\-p
+.RS 4
+When this option is used, the principal name obtained by the kernel from the CIFS server is used rather than a principal name derived from the host name. If this fails, the host name is used as fallback.
+This makes it possible to obtain credentials for CIFS servers using nonstandard principal names, and makes cifs mounts behave more similar to smbclient, which also uses the server-provided principal name.
+.RE
+.PP
 \-\-version|\-v
 .RS 4
 Print version number and exit\&.
diff --git a/cifs.upcall.c b/cifs.upcall.c
index de92092..2adac1d 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -518,11 +518,13 @@ handle_krb5_mech(const char *oid, const char *principal, DATA_BLOB * secblob,
 #define DKD_HAVE_PID		0x20
 #define DKD_HAVE_CREDUID	0x40
 #define DKD_HAVE_USERNAME	0x80
+#define DKD_HAVE_PRINCIPAL	0x100
 #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
 
 struct decoded_args {
 	int ver;
 	char *hostname;
+	char *principal;
 	char *ip;
 	char *username;
 	uid_t uid;
@@ -557,6 +559,21 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 			}
 			retval |= DKD_HAVE_HOSTNAME;
 			syslog(LOG_DEBUG, "host=%s", arg->hostname);
+		} else if (!strncmp(tkn, "pri=", 4)) {
+			if (pos == NULL)
+				len = strlen(tkn);
+			else
+				len = pos - tkn;
+
+			len -= 4;
+			SAFE_FREE(arg->principal);
+			arg->principal = strndup(tkn + 4, len);
+			if (arg->principal == NULL) {
+				syslog(LOG_ERR, "Unable to allocate memory");
+				return 1;
+			}
+			retval |= DKD_HAVE_PRINCIPAL;
+			syslog(LOG_DEBUG, "pri=%s", arg->principal);
 		} else if (!strncmp(tkn, "ip4=", 4) || !strncmp(tkn, "ip6=", 4)) {
 			if (pos == NULL)
 				len = strlen(tkn);
@@ -755,6 +772,7 @@ static void usage(void)
 const struct option long_options[] = {
 	{"trust-dns", 0, NULL, 't'},
 	{"legacy-uid", 0, NULL, 'l'},
+	{"principal-from-kernel", 0, NULL, 'p'},
 	{"version", 0, NULL, 'v'},
 	{NULL, 0, NULL, 0}
 };
@@ -768,7 +786,7 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	unsigned int have;
 	long rc = 1;
-	int c, try_dns = 0, legacy_uid = 0;
+	int c, try_dns = 0, legacy_uid = 0, use_principal = 0;
 	char *buf, *princ = NULL, *ccname = NULL;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg;
@@ -781,7 +799,7 @@ int main(const int argc, char *const argv[])
 
 	openlog(prog, 0, LOG_DAEMON);
 
-	while ((c = getopt_long(argc, argv, "cltv", long_options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cltpv", long_options, NULL)) != -1) {
 		switch (c) {
 		case 'c':
 			/* legacy option -- skip it */
@@ -792,6 +810,9 @@ int main(const int argc, char *const argv[])
 		case 'l':
 			legacy_uid++;
 			break;
+		case 'p':
+			use_principal++;
+			break;
 		case 'v':
 			printf("version: %s\n", VERSION);
 			goto out;
@@ -873,9 +894,16 @@ int main(const int argc, char *const argv[])
 	host = arg.hostname;
 
 	// do mech specific authorization
+	oid = OID_KERBEROS5;
 	switch (arg.sec) {
 	case MS_KRB5:
+		oid = OID_KERBEROS5_OLD;
 	case KRB5:
+		if (use_principal && have & DKD_HAVE_PRINCIPAL) {
+			rc = handle_krb5_mech(oid, arg.principal, &secblob, &sess_key, ccname);
+			if (!rc)
+				break;
+		}
 retry_new_hostname:
 		/* for "cifs/" service name + terminating 0 */
 		datalen = strlen(host) + 5 + 1;
@@ -885,11 +913,6 @@ retry_new_hostname:
 			break;
 		}
 
-		if (arg.sec == MS_KRB5)
-			oid = OID_KERBEROS5_OLD;
-		else
-			oid = OID_KERBEROS5;
-
 		/*
 		 * try getting a cifs/ principal first and then fall back to
 		 * getting a host/ principal if that doesn't work.
@@ -965,6 +988,7 @@ out:
 	data_blob_free(&sess_key);
 	SAFE_FREE(ccname);
 	SAFE_FREE(arg.hostname);
+	SAFE_FREE(arg.principal);
 	SAFE_FREE(arg.ip);
 	SAFE_FREE(arg.username);
 	SAFE_FREE(keydata);
diff --git a/cifs_spnego.h b/cifs_spnego.h
index f8753a7..d43f965 100644
--- a/cifs_spnego.h
+++ b/cifs_spnego.h
@@ -23,7 +23,7 @@
 #ifndef _CIFS_SPNEGO_H
 #define _CIFS_SPNEGO_H
 
-#define CIFS_SPNEGO_UPCALL_VERSION 2
+#define CIFS_SPNEGO_UPCALL_VERSION 3
 
 /*
  * The version field should always be set to CIFS_SPNEGO_UPCALL_VERSION.
-- 
1.7.6
