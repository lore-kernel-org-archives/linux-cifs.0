From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: guard against entries being deleted from open file list
Date: Mon, 18 Apr 2011 09:21:05 -0500
Message-ID: <BANLkTi=dVQt1GQmrG+x0PF8Akq_hbvE7cQ@mail.gmail.com>
References: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1303134275-12587-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Is there a reproduction scenario or bug report for this (or was it
noted by inspection)?

On Mon, Apr 18, 2011 at 8:44 AM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> It is possible that a close can occur while a file is
> being reopened which can result in list entry deleted
> from the list and an oops.
> Use list_for_each_entry_safe instead.
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> =A0fs/cifs/file.c | =A0 =A05 +++--
> =A01 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index faf5952..aa29167 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(struct =
cifsInodeInfo *cifs_inode,
> =A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo *cifs=
_inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0bool fsuid_only)
> =A0{
> - =A0 =A0 =A0 struct cifsFileInfo *open_file;
> + =A0 =A0 =A0 struct cifsFileInfo *open_file, *tmpf;
> =A0 =A0 =A0 =A0struct cifs_sb_info *cifs_sb;
> =A0 =A0 =A0 =A0bool any_available =3D false;
> =A0 =A0 =A0 =A0int rc;
> @@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(struct =
cifsInodeInfo *cifs_inode,
>
> =A0 =A0 =A0 =A0spin_lock(&cifs_file_list_lock);
> =A0refind_writable:
> - =A0 =A0 =A0 list_for_each_entry(open_file, &cifs_inode->openFileLis=
t, flist) {
> + =A0 =A0 =A0 list_for_each_entry_safe(open_file, tmpf, &cifs_inode->=
openFileList,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 flist) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!any_available && open_file->pid !=
=3D current->tgid)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0continue;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fsuid_only && open_file->uid !=3D =
current_fsuid())
> --
> 1.6.0.2
>
>



--=20
Thanks,

Steve
