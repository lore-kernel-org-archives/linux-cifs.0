From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: [PATCH] cifscreds: add a check and warning for missing session keyring
Date: Tue, 17 Jul 2012 09:28:37 -0400
Message-ID: <1342531717-30135-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Many distros do not call into pam_keyinit to set up the session keyring
properly at login time. When cifscreds add is used in such a session,
the kernel will spawn a new session keyring in which to install the
credentials. That keyring will then go away once the cifscreds process
exits.

Check for this situation  by looking to see if the session and
user-session keyrings are the same. Throw a warning if so, and add some
verbiage to the cifscreds manpage that explains the issue.

Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Reported-by: Milan Kn=C3=AD=C5=BEek <knizek.confy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
---
 cifscreds.1   |    9 ++++++++-
 cifscreds.c   |   21 +++++++++++++++++++++
 cifscreds.pod |    8 ++++++++
 3 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/cifscreds.1 b/cifscreds.1
index 44a02a2..83afae6 100644
--- a/cifscreds.1
+++ b/cifscreds.1
@@ -124,7 +124,7 @@
 .\" =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
 .\"
 .IX Title "CIFSCREDS 1"
-.TH CIFSCREDS 1 "2012-01-24" "" ""
+.TH CIFSCREDS 1 "2012-07-17" "" ""
 .\" For nroff, turn off justification.  Always turn off hyphenation; i=
t makes
 .\" way too many mistakes in technical documents.
 .if n .ad l
@@ -186,6 +186,13 @@ different username.
 The cifscreds utility requires a kernel built with support for the
 \&\fBlogin\fR key type. That key type was added in v3.3 in mainline Li=
nux
 kernels.
+.PP
+Since \fBcifscreds\fR adds keys to the session keyring, it is highly
+recommended that one use \fBpam_keyinit\fR to ensure that a session ke=
yring
+is established at login time.
+.SH "SEE ALSO"
+.IX Header "SEE ALSO"
+\&\fIpam_keyinit\fR\|(8)
 .SH "AUTHORS"
 .IX Header "AUTHORS"
 The cifscreds program was originally developed by Igor Druzhinin
diff --git a/cifscreds.c b/cifscreds.c
index efc76e6..f521ba5 100644
--- a/cifscreds.c
+++ b/cifscreds.c
@@ -465,6 +465,25 @@ static int cifscreds_update(struct cmdarg *arg)
 	return EXIT_SUCCESS;
 }
=20
+static void
+check_session_keyring(void)
+{
+	key_serial_t	ses_key, uses_key;
+
+	ses_key =3D keyctl_get_keyring_ID(KEY_SPEC_SESSION_KEYRING, 0);
+	if (ses_key =3D=3D -1)
+		return;
+
+	uses_key =3D keyctl_get_keyring_ID(KEY_SPEC_USER_SESSION_KEYRING, 0);
+	if (uses_key =3D=3D -1)
+		return;
+
+	if (ses_key =3D=3D uses_key)
+		fprintf(stderr, "Warning: you have no session keyring. "
+				"cifscreds keys will not persist. See "
+				"pam_keyinit(8).\n");
+}
+
 int main(int argc, char **argv)
 {
 	struct command *cmd, *best;
@@ -535,5 +554,7 @@ int main(int argc, char **argv)
 	if (arg.user =3D=3D NULL)
 		arg.user =3D getusername(getuid());
=20
+	check_session_keyring();
+
 	return best->action(&arg);
 }
diff --git a/cifscreds.pod b/cifscreds.pod
index 17e453f..c3bafb5 100644
--- a/cifscreds.pod
+++ b/cifscreds.pod
@@ -79,6 +79,14 @@ The cifscreds utility requires a kernel built with s=
upport for the
 B<login> key type. That key type was added in v3.3 in mainline Linux
 kernels.
=20
+Since B<cifscreds> adds keys to the session keyring, it is highly
+recommended that one use B<pam_keyinit> to ensure that a session keyri=
ng
+is established at login time.
+
+=3Dhead1 SEE ALSO
+
+pam_keyinit(8)
+
 =3Dhead1 AUTHORS
=20
 The cifscreds program was originally developed by Igor Druzhinin
--=20
1.7.10.4
