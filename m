From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Misc. cleanup in cifsacl handling
Date: Tue, 16 Nov 2010 15:48:38 -0600
Message-ID: <AANLkTinRQPNFyeKkj1-FEhnJ2VoPYTzdP39v6UB5Yuet@mail.gmail.com>
References: <1289664138-16108-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1289664138-16108-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Sat, Nov 13, 2010 at 10:02 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> Change the name of function mode_to_acl to mode_to_cifs_acl.
>
> Handle return code in functions mode_to_cifs_acl and
> cifs_acl_to_fattr.
>
> Pass fid to inode helper function which passes it on to
> get inode info function so we do not end up opening the
> opened file again thus breaking oplocks.

<snip>

> @@ -2113,11 +2118,15 @@ cifs_setattr_nounix(struct dentry *direntry, =
struct iattr *attrs)
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0if (attrs->ia_valid & ATTR_MODE) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D 0;
> =A0#ifdef CONFIG_CIFS_EXPERIMENTAL
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_CIFS_ACL)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mode_to_acl(inod=
e, full_path, mode);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (cifs_sb->mnt_cifs_flags & CIFS_MOUN=
T_CIFS_ACL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D mode_to_cifs_acl=
(inode, full_path, mode);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (rc) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1,=
 "%s: Setting ACL failed with error: %d",
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 __func__, rc);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ci=
fs_setattr_exit;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> =A0#endif
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (((mode & S_IWUGO) =3D=3D 0) &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(cifsInode->cifsAttrs & ATTR_R=
EADONLY) =3D=3D 0) {

This changes behavior.   When you mount with CIFS_ACL then you are
still falling through to set the mode bits too (it used to avoid
setting the mode bits when we can use ACLs to more accurately
represent the mode).  You got rid of the else ... Did you mean to do
that?
Thanks,

Steve
