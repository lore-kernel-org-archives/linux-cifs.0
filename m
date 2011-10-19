From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] manpage: cleanups to new backupuid/gid sections
Date: Wed, 19 Oct 2011 13:07:32 -0500
Message-ID: <CADT32eJGuR_jK3iT8MwJK58gPhv84VXOQrGC+tZCUwaJ=ZUCCA@mail.gmail.com>
References: <1319047024-8676-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1319047024-8676-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Oct 19, 2011 at 12:57 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> Minor cleanups and consistency fixes...
>
> Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.8 | =A0 14 +++++---------
> =A01 files changed, 5 insertions(+), 9 deletions(-)
>
> diff --git a/mount.cifs.8 b/mount.cifs.8
> index 8207bcb..958efa5 100644
> --- a/mount.cifs.8
> +++ b/mount.cifs.8
> @@ -282,16 +282,16 @@ See sections on
> =A0for more information\&.
> =A0.RE
> =A0.PP
> -backupuid=3Darg
> +backupuid=3D\fIarg\fR
> =A0.RS 4
> -Restrict access to files, with the backup intent, to a user. =A0Eith=
er a name or an id must be provided as an argument, there are no defaul=
t values.
> +Restrict access to files with the backup intent to a user. Either a =
name or an id must be provided as an argument, there are no default val=
ues.
> =A0.sp
> =A0See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more deta=
ils
> =A0.RE
> =A0.PP
> -backupgid=3Darg
> +backupgid=3D\fIarg\fR
> =A0.RS 4
> -Restrict Allow access to files, with the backup intent, to a group. =
=A0Either a name or an id must be provided as an argument, there are no=
 default values.
> +Restrict access to files with the backup intent to a group. Either a=
 name or an id must be provided as an argument, there are no default va=
lues.
> =A0.sp
> =A0See section \fIACCESSING FILES WITH BACKUP INTENT\fR for more deta=
ils
> =A0.RE
> @@ -625,11 +625,7 @@ But the user testuser, if it becomes part of the=
 group Backup Operators, can ope
> =A0Any user on the client side who can authenticate as such a user on=
 the server,
> =A0can access the files with the backup intent. But it is desirable a=
nd preferable for security reasons amongst many, to restrict this speci=
al right.
>
> -The mount option backupuid is used to restrict this special right to=
 a user which is specified by either a name or an id.
> -.sp 0
> -The mount option backupgid is used to restrict this special right to=
 the users in a group which is specified by either a name or an id.
> -.sp 0
> -These two mount options can be used together.
> +The mount option backupuid is used to restrict this special right to=
 a user which is specified by either a name or an id. The mount option =
backupgid is used to restrict this special right to the users in a grou=
p which is specified by either a name or an id. These two mount options=
 can be used together.
> =A0.SH "FILE AND DIRECTORY OWNERSHIP AND PERMISSIONS"
> =A0.PP
> =A0The core CIFS protocol does not provide unix ownership information=
 or mode for files and directories\&. Because of this, files and direct=
ories will generally appear to be owned by whatever values the uid=3D o=
r gid=3D options are set, and will have permissions set to the default =
file_mode and dir_mode for the mount\&. Attempting to change these valu=
es via chmod/chown will return success but have no effect\&.
> --
> 1.7.6.4
>
>

Looks good.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
