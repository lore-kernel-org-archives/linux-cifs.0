From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH 3/4] cifs.upcall: swap c99 initializers for memset calls
Date: Tue, 27 Jul 2010 15:37:06 -0400
Message-ID: <1280259427-14617-4-git-send-email-jlayton@samba.org>
References: <1280259427-14617-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1280259427-14617-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

gcc says:

cifs.upcall.c: In function =E2=80=98cifs_krb5_get_req=E2=80=99:
cifs.upcall.c:261:2: warning: missing initializer
cifs.upcall.c:261:2: warning: (near initialization for =E2=80=98in_cred=
s.client=E2=80=99)
cifs.upcall.c: In function =E2=80=98main=E2=80=99:
cifs.upcall.c:622:9: warning: missing initializer
cifs.upcall.c:622:9: warning: (near initialization for =E2=80=98arg.ver=
=E2=80=99)

=2E..this is probably just gcc being balky, but we can silence the
warning. It may also be a micro optimization in an error condition
if we delay zeroing out the struct until it's needed.

Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifs.upcall.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/cifs.upcall.c b/cifs.upcall.c
index 8f7850a..9b1436e 100644
--- a/cifs.upcall.c
+++ b/cifs.upcall.c
@@ -258,7 +258,7 @@ cifs_krb5_get_req(const char *principal, const char=
 *ccname,
 	krb5_keyblock *tokb;
 	krb5_context context;
 	krb5_ccache ccache;
-	krb5_creds in_creds =3D { }, *out_creds;
+	krb5_creds in_creds, *out_creds;
 	krb5_data apreq_pkt, in_data;
 	krb5_auth_context auth_context =3D NULL;
=20
@@ -275,6 +275,8 @@ cifs_krb5_get_req(const char *principal, const char=
 *ccname,
 		goto out_free_context;
 	}
=20
+	memset(&in_creds, 0, sizeof(in_creds));
+
 	ret =3D krb5_cc_get_principal(context, ccache, &in_creds.client);
 	if (ret) {
 		syslog(LOG_DEBUG, "%s: unable to get client principal name",
@@ -619,7 +621,7 @@ int main(const int argc, char *const argv[])
 	int c, try_dns =3D 0, legacy_uid =3D 0;
 	char *buf, *princ =3D NULL, *ccname =3D NULL;
 	char hostbuf[NI_MAXHOST], *host;
-	struct decoded_args arg =3D { };
+	struct decoded_args arg;
 	const char *oid;
=20
 	hostbuf[0] =3D '\0';
@@ -677,6 +679,8 @@ int main(const int argc, char *const argv[])
 		goto out;
 	}
=20
+	memset(&arg, 0, sizeof(arg));
+
 	have =3D decode_key_description(buf, &arg);
 	SAFE_FREE(buf);
 	if ((have & DKD_MUSTHAVE_SET) !=3D DKD_MUSTHAVE_SET) {
--=20
1.7.1.1
