From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] mount.cifs: add cruid= mount option
Date: Wed, 12 Jan 2011 15:43:41 -0600
Message-ID: <AANLkTims8r8uKd=+5C7opd7ykgQ4BHfh8LEMT=dyEthj@mail.gmail.com>
References: <1294863996-7678-1-git-send-email-jlayton@samba.org>
	<1294863996-7678-2-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, walteste-gy3b+zu4XSAfv37vnLkPlQ@public.gmane.org, metze-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294863996-7678-2-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jan 12, 2011 at 2:26 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> Allow admins to pass in a username for the cruid=3D mount option.
>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 =A05 +++++
> =A0mount.cifs.c | =A0 40 ++++++++++++++++++++++++++++++++++++++--
> =A02 files changed, 43 insertions(+), 2 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 5f82ac9..469440d 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -120,6 +120,11 @@ forceuid
> =A0instructs the client to ignore any uid provided by the server for =
files and directories and to always assign the owner to be the value of=
 the uid=3D option\&. See the section on FILE AND DIRECTORY OWNERSHIP A=
ND PERMISSIONS below for more information\&.
> =A0.RE
> =A0.PP
> +cruid=3D\fIarg\fR
> +.RS 4
> +sets the uid of the owner of the credentials cache\&. This is primar=
ily useful with sec=3Dkrb5\&. The default is the real uid of the proces=
s performing the mount\&. Setting this parameter directs the upcall to =
look for a credentials cache owned by that user\&.
> +.RE
> +.PP
> =A0gid=3D\fIarg\fR
> =A0.RS 4
> =A0sets the gid that will own all files or directories on the mounted=
 filesystem when the server does not provide ownership information\&. I=
t may be specified as either a groupname or a numeric gid\&. When not s=
pecified, the default is gid 0\&. The mount\&.cifs helper must be at ve=
rsion 1\&.10 or higher to support specifying the gid in non\-numeric fo=
rm\&. See the section on FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS b=
elow for more information\&.
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 8fccf44..41da67e 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -157,6 +157,7 @@
> =A0#define OPT_REMOUNT =A0 =A026
> =A0#define OPT_MAND =A0 =A0 =A0 27
> =A0#define OPT_NOMAND =A0 =A0 28
> +#define OPT_CRUID =A0 =A0 =A029
>
>
> =A0/* struct for holding parsed mount info for use by privleged proce=
ss */
> @@ -802,6 +803,8 @@ static int parse_opt_token(const char *token)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return OPT_CRED;
> =A0 =A0 =A0 =A0if (strncmp(token, "uid", 3) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return OPT_UID;
> + =A0 =A0 =A0 if (strncmp(token, "cruid", 5) =3D=3D 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return OPT_CRUID;
> =A0 =A0 =A0 =A0if (strncmp(token, "gid", 3) =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return OPT_GID;
> =A0 =A0 =A0 =A0if (strncmp(token, "fmask", 5) =3D=3D 0)
> @@ -856,8 +859,9 @@ parse_options(const char *data, struct parsed_mou=
nt_info *parsed_info)
> =A0 =A0 =A0 =A0int word_len;
> =A0 =A0 =A0 =A0int rc =3D 0;
> =A0 =A0 =A0 =A0int got_uid =3D 0;
> + =A0 =A0 =A0 int got_cruid =3D 0;
> =A0 =A0 =A0 =A0int got_gid =3D 0;
> - =A0 =A0 =A0 uid_t uid;
> + =A0 =A0 =A0 uid_t uid, cruid;
> =A0 =A0 =A0 =A0gid_t gid;
> =A0 =A0 =A0 =A0char txtbuf[12];
> =A0 =A0 =A0 =A0char *ep;
> @@ -1036,6 +1040,23 @@ parse_options(const char *data, struct parsed_=
mount_info *parsed_info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0uid =3D pw->pw_uid;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto nocopy;
>
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case OPT_CRUID:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!value || !*value)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no=
copy;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 got_cruid =3D 1;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cruid =3D strtoul(value=
, &ep, 10);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (errno !=3D EINVAL &=
& *ep =3D=3D '\0')
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto no=
copy;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 pw =3D getpwnam(value);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (pw =3D=3D NULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf=
(stderr, "bad user name \"%s\"\n", value);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return =
EX_USAGE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cruid =3D pw->pw_uid;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto nocopy;
> +
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case OPT_GID:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!value || !*value)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto n=
ocopy;
> @@ -1187,6 +1208,22 @@ nocopy:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snprintf(out + out_len, word_len + 5, =
"uid=3D%s", txtbuf);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0out_len =3D strlen(out);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 if (got_cruid) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 word_len =3D snprintf(txtbuf, sizeof(tx=
tbuf), "%u", cruid);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* comma + "cruid=3D" + terminating NUL=
L =3D=3D 6 */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (out_len + word_len + 8 > MAX_OPTION=
S_LEN) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fprintf(stderr, "Option=
s string too long\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_USAGE;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (out_len) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 strlcat(out, ",", MAX_O=
PTIONS_LEN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_len++;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 snprintf(out + out_len, word_len + 7, "=
cruid=3D%s", txtbuf);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 out_len =3D strlen(out);
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0if (got_gid) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0word_len =3D snprintf(txtbuf, sizeof(t=
xtbuf), "%u", gid);
>
> @@ -1202,7 +1239,6 @@ nocopy:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0snprintf(out + out_len, word_len + 5, =
"gid=3D%s", txtbuf);
> =A0 =A0 =A0 =A0}
> -
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> --
> 1.7.3.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
