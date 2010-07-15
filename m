From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/6] cifs: add separate cred_uid field to sesInfo
Date: Thu, 15 Jul 2010 15:24:46 -0500
Message-ID: <AANLkTik7vm4iYcRH2oGxuINyL2VxY_h9Y03sFhQWR19d@mail.gmail.com>
References: <1277068251-16344-1-git-send-email-jlayton@redhat.com>
	<1277068251-16344-7-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1277068251-16344-7-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I merged the first 5 of this series, but wanted to understand what
behavior this changes first (it is probably ok).  With current
userspace code - what changes would a user see with this?

On Sun, Jun 20, 2010 at 4:10 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> Right now, there's no clear separation between the uid that owns the
> credentials used to do the mount and the overriding owner of the file=
s
> on that mount.
>
> Add a separate cred_uid field that is set to the real uid
> of the mount user. Unlike the linux_uid, the uid=3D option does not
> override this parameter. The parm is sent to cifs.upcall, which can t=
hen
> preferentially use the creduid=3D parm instead of the uid=3D parm for
> finding credentials.
>
> This is not the only way to solve this. We could try to do all of thi=
s
> in kernel instead by having a module parameter that affects what gets
> passed in the uid=3D field of the upcall. That said, we have a lot mo=
re
> flexibility to change things in userspace so I think it probably make=
s
> sense to do it this way.
>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/cifs_spnego.c | =A0 =A03 +++
> =A0fs/cifs/cifsglob.h =A0 =A0| =A0 =A03 ++-
> =A0fs/cifs/connect.c =A0 =A0 | =A0 =A07 +++++--
> =A03 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifs_spnego.c b/fs/cifs/cifs_spnego.c
> index 379bd7d..6effccf 100644
> --- a/fs/cifs/cifs_spnego.c
> +++ b/fs/cifs/cifs_spnego.c
> @@ -144,6 +144,9 @@ cifs_get_spnego_key(struct cifsSesInfo *sesInfo)
> =A0 =A0 =A0 =A0sprintf(dp, ";uid=3D0x%x", sesInfo->linux_uid);
>
> =A0 =A0 =A0 =A0dp =3D description + strlen(description);
> + =A0 =A0 =A0 sprintf(dp, ";creduid=3D0x%x", sesInfo->cred_uid);
> +
> + =A0 =A0 =A0 dp =3D description + strlen(description);
> =A0 =A0 =A0 =A0sprintf(dp, ";user=3D%s", sesInfo->userName);
>
> =A0 =A0 =A0 =A0dp =3D description + strlen(description);
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 415703b..e15d7a5 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -209,7 +209,8 @@ struct cifsSesInfo {
> =A0 =A0 =A0 =A0char *serverNOS; =A0 =A0 =A0 =A0/* name of network ope=
rating system of server */
> =A0 =A0 =A0 =A0char *serverDomain; =A0 =A0 /* security realm of serve=
r */
> =A0 =A0 =A0 =A0int Suid; =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* remote smb ui=
d =A0*/
> - =A0 =A0 =A0 uid_t linux_uid; =A0 =A0 =A0 =A0/* local Linux uid */
> + =A0 =A0 =A0 uid_t linux_uid; =A0 =A0 =A0 =A0/* overriding owner of =
files on the mount */
> + =A0 =A0 =A0 uid_t cred_uid; =A0 =A0 =A0 =A0 /* owner of credentials=
 */
> =A0 =A0 =A0 =A0int capabilities;
> =A0 =A0 =A0 =A0char serverName[SERVER_NAME_LEN_WITH_NULL * 2]; /* BB =
make bigger for
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0TCP na=
mes - will ipv6 and sctp addresses fit? */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 58e0217..920d94e 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -66,6 +66,7 @@ struct smb_vol {
> =A0 =A0 =A0 =A0char *iocharset; =A0/* local code page for mapping to =
and from Unicode */
> =A0 =A0 =A0 =A0char source_rfc1001_name[16]; /* netbios name of clien=
t */
> =A0 =A0 =A0 =A0char target_rfc1001_name[16]; /* netbios name of serve=
r for Win9x/ME */
> + =A0 =A0 =A0 uid_t cred_uid;
> =A0 =A0 =A0 =A0uid_t linux_uid;
> =A0 =A0 =A0 =A0gid_t linux_gid;
> =A0 =A0 =A0 =A0mode_t file_mode;
> @@ -830,7 +831,8 @@ cifs_parse_mount_options(char *options, const cha=
r *devname,
> =A0 =A0 =A0 =A0/* null target name indicates to use *SMBSERVR default=
 called name
> =A0 =A0 =A0 =A0 =A0 if we end up sending RFC1001 session initialize *=
/
> =A0 =A0 =A0 =A0vol->target_rfc1001_name[0] =3D 0;
> - =A0 =A0 =A0 vol->linux_uid =3D current_uid(); =A0/* use current_eui=
d() instead? */
> + =A0 =A0 =A0 vol->cred_uid =3D current_uid();
> + =A0 =A0 =A0 vol->linux_uid =3D current_uid();
> =A0 =A0 =A0 =A0vol->linux_gid =3D current_gid();
>
> =A0 =A0 =A0 =A0/* default to only allowing write access to owner of t=
he mount */
> @@ -1647,7 +1649,7 @@ cifs_find_smb_ses(struct TCP_Server_Info *serve=
r, struct smb_vol *vol)
> =A0 =A0 =A0 =A0list_for_each_entry(ses, &server->smb_ses_list, smb_se=
s_list) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (server->secType) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case Kerberos:
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vol->linux_uid !=3D=
 ses->linux_uid)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (vol->cred_uid !=3D =
ses->cred_uid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0contin=
ue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0default:
> @@ -1764,6 +1766,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server=
, struct smb_vol *volume_info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ses->domainName)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0strcpy(ses->domainName=
, volume_info->domainname);
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 ses->cred_uid =3D volume_info->cred_uid;
> =A0 =A0 =A0 =A0ses->linux_uid =3D volume_info->linux_uid;
> =A0 =A0 =A0 =A0ses->overrideSecFlg =3D volume_info->secFlg;
>
> --
> 1.6.6.1
>
>



--=20
Thanks,

Steve
