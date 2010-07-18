From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 6/6] cifs: add separate cred_uid field to sesInfo
Date: Sun, 18 Jul 2010 07:18:19 -0400
Message-ID: <20100718071819.4264e8aa@tlielax.poochiereds.net>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
	<1277068251-16344-7-git-send-email-jlayton@redhat.com>
	<AANLkTik7vm4iYcRH2oGxuINyL2VxY_h9Y03sFhQWR19d@mail.gmail.com>
	<20100715171936.4252a16d@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100715171936.4252a16d-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, 15 Jul 2010 17:19:36 -0400
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, 15 Jul 2010 15:24:46 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> 
> > I merged the first 5 of this series, but wanted to understand what
> > behavior this changes first (it is probably ok).  With current
> > userspace code - what changes would a user see with this?
> > 
> 
> With this and the accompanying userspace patch, this makes it so that
> the credentials cache used when mounting with sec=krb5 is unaffected by
> the uid= option. The credcache will be determined using the real uid of
> the user performing the mount. There will be a cifs.upcall option that
> will make it use the legacy behavior for those that require it for some
> reason. 
> 
> I consider the current situation a bad design decision on my part as
> the ownership of files on the mount has no direct relationship to the
> owner of the mount credentials. The mount credentials should always be
> under the ownership of the user performing the mount. The existing
> scheme allows someone to use the credcache of another user to perform
> a mount.
> 
> I'll resend the userspace patch in another day or two when I get back
> from vacation.
> 

The corresponding userspace patch for this is below:

------------------------[snip]---------------------------

[PATCH] cifs.upcall: use "creduid=" parm by default when available

When I did the original krb5 implementation, I goofed and ended up making
it so that when someone specifies the "uid=" mount option that also affects
the owner of the krb5 credential cache and not just the ownership of the
mount. I'm proposing a patch for the kernel to attempt to fix this by
making the kernel send a "creduid=" parameter in the upcall which is
intended to be the user that should own the credentials cache.

That's not necessarily the same user that has "ownership" of the mount.
Usually the creduid= will be set to the real uid of the user doing the
mounting. When multisession mounts are introduced they will usually set
this to the fsuid that walks into the mount.

To ease the transition, this patch also adds a command line switch that
makes cifs.upcall use the "legacy" uid= parameter instead. Use that if you
want it to behave like it used to.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.8 |    9 ++++++++-
 cifs.upcall.c |   32 +++++++++++++++++++++++++++-----
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/cifs.upcall.8 b/cifs.upcall.8
index 7fc1603..815dd04 100644
--- a/cifs.upcall.8
+++ b/cifs.upcall.8
@@ -22,7 +22,7 @@
 cifs.upcall \- Userspace upcall helper for Common Internet File System (CIFS)
 .SH "SYNOPSIS"
 .HP \w'\ 'u
-cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] {keyid}
+cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\-uid|\-l] {keyid}
 .SH "DESCRIPTION"
 .PP
 This tool is part of the cifs-utils suite\&.
@@ -45,6 +45,13 @@ With krb5 upcalls, the name used as the host portion of the service principal de
 This is less secure than not trusting DNS\&. When using this option, it\'s possible that an attacker could get control of DNS and trick the client into mounting a different server altogether\&. It\'s preferable to instead add server principals to the KDC for every possible hostname, but this option exists for cases where that isn\'t possible\&. The default is to not trust reverse hostname lookups in this fashion\&.
 .RE
 .PP
+\-\-legacy\-uid|\-l
+.RS 4
+Traditionally, the kernel has sent only a single uid= parameter to the upcall for the SPNEGO upcall that\'s used to determine what user's credential cache to use. This parameter was generally determined by the uid= mount option, which also governs the ownership of files on the mount\&.
+.sp
+Newer kernels send a creduid= option as well, which contains what uid it thinks actually owns the credentials that it\'s looking for\&. At mount time, this is generally set to the real uid of the user doing the mount. For multisession mounts, it's set to the fsuid of the mount user. Set this option if you want cifs.upcall to use the older uid= parameter instead of the creduid= parameter\&.
+.RE
+.PP
 \-\-version|\-v
 .RS 4
 Print version number and exit\&.
diff --git a/cifs.upcall.c b/cifs.upcall.c
index d4376cc..1f4341d 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -389,6 +389,7 @@ handle_krb5_mech(const char *oid, const char *principal, DATA_BLOB * secblob,
 #define DKD_HAVE_IP		0x8
 #define DKD_HAVE_UID		0x10
 #define DKD_HAVE_PID		0x20
+#define DKD_HAVE_CREDUID	0x40
 #define DKD_MUSTHAVE_SET (DKD_HAVE_HOSTNAME|DKD_HAVE_VERSION|DKD_HAVE_SEC)
 
 struct decoded_args {
@@ -396,6 +397,7 @@ struct decoded_args {
 	char *hostname;
 	char *ip;
 	uid_t uid;
+	uid_t creduid;
 	pid_t pid;
 	sectype_t sec;
 };
@@ -461,6 +463,16 @@ decode_key_description(const char *desc, struct decoded_args *arg)
 			} else {
 				retval |= DKD_HAVE_UID;
 			}
+		} else if (strncmp(tkn, "creduid=", 8) == 0) {
+			errno = 0;
+			arg->creduid = strtol(tkn + 8, NULL, 16);
+			if (errno != 0) {
+				syslog(LOG_ERR, "Invalid creduid format: %s",
+				       strerror(errno));
+				return 1;
+			} else {
+				retval |= DKD_HAVE_CREDUID;
+			}
 		} else if (strncmp(tkn, "ver=", 4) == 0) {	/* if version */
 			errno = 0;
 			arg->ver = strtol(tkn + 4, NULL, 16);
@@ -584,12 +596,13 @@ static int ip_to_fqdn(const char *addrstr, char *host, size_t hostlen)
 
 static void usage(void)
 {
-	syslog(LOG_INFO, "Usage: %s [-t] [-v] key_serial", prog);
-	fprintf(stderr, "Usage: %s [-t] [-v] key_serial\n", prog);
+	syslog(LOG_INFO, "Usage: %s [-t] [-v] [-l] key_serial", prog);
+	fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial\n", prog);
 }
 
 const struct option long_options[] = {
 	{"trust-dns", 0, NULL, 't'},
+	{"legacy-uid", 0, NULL, 'l'},
 	{"version", 0, NULL, 'v'},
 	{NULL, 0, NULL, 0}
 };
@@ -603,7 +616,7 @@ int main(const int argc, char *const argv[])
 	size_t datalen;
 	unsigned int have;
 	long rc = 1;
-	int c, try_dns = 0;
+	int c, try_dns = 0, legacy_uid = 0;
 	char *buf, *princ = NULL, *ccname = NULL;
 	char hostbuf[NI_MAXHOST], *host;
 	struct decoded_args arg = { };
@@ -621,6 +634,9 @@ int main(const int argc, char *const argv[])
 		case 't':
 			try_dns++;
 			break;
+		case 'l':
+			legacy_uid++;
+			break;
 		case 'v':
 			printf("version: %s\n", VERSION);
 			goto out;
@@ -677,13 +693,19 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
 
-	if (have & DKD_HAVE_UID) {
+	if (!legacy_uid && (have & DKD_HAVE_CREDUID)) {
+		rc = setuid(arg.creduid);
+		if (rc == -1) {
+			syslog(LOG_ERR, "setuid: %s", strerror(errno));
+			goto out;
+		}
+		ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, arg.creduid);
+	} else if (have & DKD_HAVE_UID) {
 		rc = setuid(arg.uid);
 		if (rc == -1) {
 			syslog(LOG_ERR, "setuid: %s", strerror(errno));
 			goto out;
 		}
-
 		ccname = find_krb5_cc(CIFS_DEFAULT_KRB5_DIR, arg.uid);
 	}
 
-- 
1.7.1.1


-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
