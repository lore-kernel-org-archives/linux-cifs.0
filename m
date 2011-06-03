From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: fix the kernel release version in the default
 security warning message
Date: Fri, 3 Jun 2011 10:31:55 -0500
Message-ID: <BANLkTinC+NR+H9jGVBXGNwhNxxjxgC8GCQ@mail.gmail.com>
References: <4DE880E3.8020502@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DE880E3.8020502-l3A5Bk7waGM@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Fri, Jun 3, 2011 at 1:36 AM, Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> w=
rote:
>
> When ntlm security mechanim is used, the message that warns about the=
 upgrade
> to ntlmv2 got the kernel release version wrong (Blame it on Linus :).=
 Fix it.
>
> Signed-off-by: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 6d88b82..84c7307 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -1976,7 +1976,7 @@ cifs_get_smb_ses(struct TCP_Server_Info *server=
, struct smb_vol *volume_info)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0warned_on_ntlm =3D true;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cERROR(1, "default security mechanism =
requested. =A0The default "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"security mechanism wi=
ll be upgraded from ntlm to "
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ntlmv2 in kernel relea=
se 2.6.41");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "ntlmv2 in kernel relea=
se 3.1");
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ses->overrideSecFlg =3D volume_info->secFlg;
>
> --
> 1.7.1
>



--=20
Thanks,

Steve
