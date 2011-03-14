From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: always do is_path_accessible check in cifs_mount
Date: Mon, 14 Mar 2011 14:04:42 -0500
Message-ID: <AANLkTinv8bmv3G-p9gcUJ3ciGABurNhdNr4Je32cmMVH@mail.gmail.com>
References: <1300124888-16958-1-git-send-email-jlayton@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ysharma-3moEsy1GKqIAvxtiuMwx3w@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1300124888-16958-1-git-send-email-jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

merged

On Mon, Mar 14, 2011 at 12:48 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrot=
e:
> Currently, we skip doing the is_path_accessible check in cifs_mount i=
f
> there is no prefixpath. I have a report of at least one server howeve=
r
> that allows a TREE_CONNECT to a share that has a DFS referral at its
> root. The reporter in this case was using a UNC that had no prefixpat=
h,
> so the is_path_accessible check was not triggered and the box later h=
it
> a BUG() because we were chasing a DFS referral on the root dentry for
> the mount.
>
> This patch fixes this by removing the check for a zero-length
> prefixpath. =A0That should make the is_path_accessible check be done =
in
> this situation and should allow the client to chase the DFS referral =
at
> mount time instead.
>
> Cc: stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
> Reported-and-Tested-by: Yogesh Sharma <ysharma-3moEsy1GKqIAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
> =A0fs/cifs/connect.c | =A0 =A02 +-
> =A01 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index 63ec77c..b82e8af 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2865,7 +2865,7 @@ try_mount_again:
>
> =A0remote_path_check:
> =A0 =A0 =A0 =A0/* check if a whole path (including prepath) is not re=
mote */
> - =A0 =A0 =A0 if (!rc && cifs_sb->prepathlen && tcon) {
> + =A0 =A0 =A0 if (!rc && tcon) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* build_path_to_root works only when =
we have a valid tcon */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0full_path =3D cifs_build_path_to_root(=
cifs_sb, tcon);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (full_path =3D=3D NULL) {
> --
> 1.7.4
>
>



--=20
Thanks,

Steve
