From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Q: cifs, freeing volume_info->UNCip
Date: Thu, 18 Aug 2011 11:55:22 -0500
Message-ID: <CAH2r5mvA3i8E-KAuQ=+10gfzF1q8dWwB2KQiY3W1FBw_gscurQ@mail.gmail.com>
References: <7087.1313450537@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	kirk w <kirkpuppy-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
To: "J. R. Okajima" <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7087.1313450537@jrobl>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Mon, Aug 15, 2011 at 6:22 PM, J. R. Okajima <hooanon05-/E1597aS9LR3+QwDJ9on6Q@public.gmane.org> =
wrote:
>
> Hello,
>
> CIFS cleanup_volume_info_contents() looks like having a memory
> corruption problem.
> When UNCip is set to "&vol->UNC[2]" in cifs_parse_mount_options(), it
> should not be kfree()-ed in cleanup_volume_info_contents().
>
> If it is correct and the code in mainline is not fixed yet, then here=
 is
> a patch.
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index ccc1afa..e0ea721 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2838,7 +2838,8 @@ cleanup_volume_info_contents(struct smb_vol *vo=
lume_info)
> =A0 =A0 =A0 =A0kfree(volume_info->username);
> =A0 =A0 =A0 =A0kzfree(volume_info->password);
> =A0 =A0 =A0 =A0kfree(volume_info->UNC);
> - =A0 =A0 =A0 kfree(volume_info->UNCip);
> + =A0 =A0 =A0 if (volume_info->UNCip !=3D volume_info->UNC + 2)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(volume_info->UNCip);
> =A0 =A0 =A0 =A0kfree(volume_info->domainname);
> =A0 =A0 =A0 =A0kfree(volume_info->iocharset);
> =A0 =A0 =A0 =A0kfree(volume_info->prepath);
>
>
> J. R. Okajima
>



--=20
Thanks,

Steve
