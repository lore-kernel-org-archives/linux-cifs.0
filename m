From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mount.cifs: remove smb2 multicall binary code
Date: Fri, 11 May 2012 21:43:57 -0500
Message-ID: <CAH2r5msRufn6WRjhoFuFtZTD=7v-7_9K9jG6+KMQxLeGConwnQ@mail.gmail.com>
References: <1336784436-9176-1-git-send-email-jlayton@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336784436-9176-1-git-send-email-jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

This may be fine but we need to ask the obvious question ...

Are we sure that we don't ever want a distinct fstype (cifs vs. smb2)
in the long run?

It does seem strange that smb2 and cifs would be the same fstype.  For =
a while
fstab supported nfs4 as an fstype (as distinct from nfs (nfs3)) cifs
and smb2 are
quite a bit different.

Certainly calling smb3 or smb2 as cifs should work - but I have the fee=
ling
that smb3 will in the long run be better known as a name (than cifs) so
we will have to provide synonyms (mount.smb3 could basically would
be mount.cifs but pass vers=3D3)

On Fri, May 11, 2012 at 8:00 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> This was added when it was thought that smb2 would be a different fst=
ype
> altogether. Now that we are not adding a separate fstype, this code i=
s
> no longer needed since nothing will ever call /sbin/mount.smb2.
>
> Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> ---
> =A0mount.cifs.c | =A0 61 +++-----------------------------------------=
-------------
> =A01 files changed, 4 insertions(+), 57 deletions(-)
>
> diff --git a/mount.cifs.c b/mount.cifs.c
> index 3041987..2d1d842 100644
> --- a/mount.cifs.c
> +++ b/mount.cifs.c
> @@ -181,7 +181,6 @@ struct parsed_mount_info {
>
> =A0const char *thisprogram;
> =A0const char *cifs_fstype =3D "cifs";
> -const char *smb2_fstype =3D "smb2";
>
> =A0static int parse_unc(const char *unc_name, struct parsed_mount_inf=
o *parsed_info);
>
> @@ -250,7 +249,7 @@ check_fstab(const char *progname, const char *mou=
ntpoint, const char *devname,
>
> =A0BB end finish BB */
>
> -static int mount_cifs_usage(FILE * stream)
> +static int mount_usage(FILE * stream)
> =A0{
> =A0 =A0 =A0 =A0fprintf(stream, "\nUsage: =A0%s <remotetarget> <dir> -=
o <options>\n",
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0thisprogram);
> @@ -290,52 +289,6 @@ static int mount_cifs_usage(FILE * stream)
> =A0 =A0 =A0 =A0return 0;
> =A0}
>
> -static int mount_smb2_usage(FILE *stream)
> -{
> - =A0 =A0 =A0 fprintf(stream, "\nUsage: =A0%s <remotetarget> <dir> -o=
 <options>\n",
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 thisprogram);
> - =A0 =A0 =A0 fprintf(stream, "\nMount the remote target, specified a=
s a UNC name,");
> - =A0 =A0 =A0 fprintf(stream, " to a local directory.\n\nOptions:\n")=
;
> - =A0 =A0 =A0 fprintf(stream, "\tuser=3D<arg>\n\tpass=3D<arg>\n\tdom=3D=
<arg>\n");
> - =A0 =A0 =A0 fprintf(stream, "\nLess commonly used options:");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tcredentials=3D<filename>,guest,per=
m,noperm,rw,ro,");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tsep=3D<char>,iocharset=3D<codepage=
>,exec,noexec");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tnolock,directio,sec=3D<authenticat=
ion mechanism>,sign");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tuid=3D<uid>,gid=3D<gid>,dir_mode=3D=
<mode>,file_mode=3D<mode>");
> - =A0 =A0 =A0 fprintf(stream, "\n\nRarely used options:");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tport=3D<tcpport>,rsize=3D<size>,ws=
ize=3D<size>,unc=3D<unc_name>,ip=3D<ip_address>,");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tdev,nodev,hard,soft,intr,");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\tnointr,ignorecase,noacl,prefixpath=
=3D<path>,nobrl");
> - =A0 =A0 =A0 fprintf(stream,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 "\n\nOptions are described in more deta=
il in the manual page");
> - =A0 =A0 =A0 fprintf(stream, "\n\tman 8 mount.smb2\n");
> - =A0 =A0 =A0 fprintf(stream, "\nTo display the version number of the=
 mount helper:");
> - =A0 =A0 =A0 fprintf(stream, "\n\tmount.smb2 -V\n");
> -
> - =A0 =A0 =A0 if (stream =3D=3D stderr)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return EX_USAGE;
> - =A0 =A0 =A0 return 0;
> -}
> -
> -static int mount_usage(FILE *stream)
> -{
> - =A0 =A0 =A0 int rc;
> -
> - =A0 =A0 =A0 if (strcmp(thisprogram, "mount.smb2") =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mount_smb2_usage(stream);
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mount_cifs_usage(stream);
> -
> - =A0 =A0 =A0 return rc;
> -}
> -
> =A0/*
> =A0* CIFS has to "escape" commas in the password field so that they d=
on't
> =A0* end up getting confused for option delimiters. Copy password int=
o pw
> @@ -1928,7 +1881,6 @@ int main(int argc, char **argv)
> =A0 =A0 =A0 =A0size_t options_size =3D MAX_OPTIONS_LEN;
> =A0 =A0 =A0 =A0struct parsed_mount_info *parsed_info =3D NULL;
> =A0 =A0 =A0 =A0pid_t pid;
> - =A0 =A0 =A0 const char *fstype;
>
> =A0 =A0 =A0 =A0rc =3D check_setuid();
> =A0 =A0 =A0 =A0if (rc)
> @@ -2109,14 +2061,9 @@ mount_retry:
> =A0 =A0 =A0 =A0if (rc)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mount_exit;
>
> - =A0 =A0 =A0 if (strcmp(thisprogram, "mount.smb2") =3D=3D 0)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fstype =3D smb2_fstype;
> - =A0 =A0 =A0 else
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 fstype =3D cifs_fstype;
> -
> =A0 =A0 =A0 =A0if (!parsed_info->fakemnt) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0toggle_dac_capability(0, 1);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mount(orig_dev, ".", fstype, par=
sed_info->flags, options);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mount(orig_dev, ".", cifs_fstype=
, parsed_info->flags, options);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0toggle_dac_capability(0, 0);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rc =3D=3D 0)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto do_mtab;
> @@ -2133,7 +2080,7 @@ mount_retry:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto mount_retry;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ENODEV:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mount =
error: %s filesystem not supported by the system\n", fstype);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "mount =
error: %s filesystem not supported by the system\n", cifs_fstype);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case ENXIO:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!already_uppercase=
d &&
> @@ -2163,7 +2110,7 @@ do_mtab:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto m=
ount_exit;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
>
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D add_mtab(orig_dev, mountpoint, p=
arsed_info->flags, fstype);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D add_mtab(orig_dev, mountpoint, p=
arsed_info->flags, cifs_fstype);
> =A0 =A0 =A0 =A0}
>
> =A0mount_exit:
> --
> 1.7.7.6
>



--=20
Thanks,

Steve
