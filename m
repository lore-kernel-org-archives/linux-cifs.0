From: Steve French <smfrench@gmail.com>
Subject: Re: [PATCH] CIFS: Remove pointless variable assignment in
	cifs_dfs_do_automount()
Date: Sun, 23 Jan 2011 22:31:08 -0600
Message-ID: <AANLkTinjC74qUzuTc7xjgD7uvMN7q2tqkJt_SOqNO73-@mail.gmail.com>
References: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <alpine.LNX.2.00.1101222101070.7746@swampdragon.chaosbits.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

merged - thx

On Sat, Jan 22, 2011 at 2:07 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> In fs/cifs/cifs_dfs_ref.c::cifs_dfs_do_automount() we have this code:
>
> =A0 =A0 =A0 =A0...
> =A0 =A0 =A0 =A0mnt =3D ERR_PTR(-EINVAL);
> =A0 =A0 =A0 =A0if (IS_ERR(tlink)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mnt =3D ERR_CAST(tlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto free_full_path;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ses =3D tlink_tcon(tlink)->ses;
>
> =A0 =A0 =A0 =A0rc =3D get_dfs_path(xid, ses, full_path + 1, cifs_sb->loca=
l_nls,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&num_referrals, &referrals,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MAP_S=
PECIAL_CHR);
>
> =A0 =A0 =A0 =A0cifs_put_tlink(tlink);
>
> =A0 =A0 =A0 =A0mnt =3D ERR_PTR(-ENOENT);
> =A0 =A0 =A0 =A0...
>
> The assignment of 'mnt =3D ERR_PTR(-EINVAL);' is completely pointless. If=
 we
> take the 'if (IS_ERR(tlink))' branch we'll set 'mnt' again and we'll also
> do so if we do not take the branch. There is no way we'll ever use 'mnt'
> with the assigned 'ERR_PTR(-EINVAL)' value, so we may as well just remove
> the pointless assignment.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
> =A0cifs_dfs_ref.c | =A0 =A01 -
> =A01 file changed, 1 deletion(-)
>
> diff --git a/fs/cifs/cifs_dfs_ref.c b/fs/cifs/cifs_dfs_ref.c
> index 7ed3653..f1c6862 100644
> --- a/fs/cifs/cifs_dfs_ref.c
> +++ b/fs/cifs/cifs_dfs_ref.c
> @@ -297,7 +297,6 @@ static struct vfsmount *cifs_dfs_do_automount(struct =
dentry *mntpt)
>
> =A0 =A0 =A0 =A0cifs_sb =3D CIFS_SB(mntpt->d_inode->i_sb);
> =A0 =A0 =A0 =A0tlink =3D cifs_sb_tlink(cifs_sb);
> - =A0 =A0 =A0 mnt =3D ERR_PTR(-EINVAL);
> =A0 =A0 =A0 =A0if (IS_ERR(tlink)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mnt =3D ERR_CAST(tlink);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto free_full_path;
>
>
> --
> Jesper Juhl <jj@chaosbits.net> =A0 =A0 =A0 =A0 =A0 =A0http://www.chaosbit=
s.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
