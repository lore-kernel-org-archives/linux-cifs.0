From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/6] CIFS: Make cifsFileInfo_put work with strict cache
 mode
Date: Wed, 10 Nov 2010 06:36:12 -0500
Message-ID: <20101110063612.535cf79a@tlielax.poochiereds.net>
References: <1288945777-9197-1-git-send-email-piastryyy@gmail.com>
	<1288945777-9197-2-git-send-email-piastryyy@gmail.com>
	<20101109130058.1ba3c435@corrin.poochiereds.net>
	<AANLkTi=BZ_ozRd01VEjDAZ4YWou-Ng6vPnOvAwRWGRxC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=BZ_ozRd01VEjDAZ4YWou-Ng6vPnOvAwRWGRxC-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 9 Nov 2010 21:02:19 +0300
Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> 2010/11/9 Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>:
> > On Fri, =A05 Nov 2010 11:29:32 +0300
> > Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On strict cache mode when we close the last file handle of the ino=
de we
> >> should invalidate it to prevent data coherency problem when we ope=
n it
> >> again but it has been modified by other clients.
> >>
> >> Signed-off-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =A0fs/cifs/cifs_fs_sb.h | =A0 =A01 +
> >> =A0fs/cifs/file.c =A0 =A0 =A0 | =A0 =A06 ++++++
> >> =A02 files changed, 7 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifs_fs_sb.h b/fs/cifs/cifs_fs_sb.h
> >> index e9a393c..be7b159 100644
> >> --- a/fs/cifs/cifs_fs_sb.h
> >> +++ b/fs/cifs/cifs_fs_sb.h
> >> @@ -40,6 +40,7 @@
> >> =A0#define CIFS_MOUNT_FSCACHE =A0 0x8000 /* local caching enabled =
*/
> >> =A0#define CIFS_MOUNT_MF_SYMLINKS =A0 =A0 =A0 0x10000 /* Minshall+=
=46rench Symlinks enabled */
> >> =A0#define CIFS_MOUNT_MULTIUSER 0x20000 /* multiuser mount */
> >> +#define CIFS_MOUNT_STRICT_IO 0x40000 /* strict cache mode */
> >>
> >> =A0struct cifs_sb_info {
> >> =A0 =A0 =A0 struct rb_root tlink_tree;
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 777e7f4..b36de2e 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -264,7 +264,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cif=
s_file)
> >> =A0 =A0 =A0 struct inode *inode =3D cifs_file->dentry->d_inode;
> >> =A0 =A0 =A0 struct cifsTconInfo *tcon =3D tlink_tcon(cifs_file->tl=
ink);
> >> =A0 =A0 =A0 struct cifsInodeInfo *cifsi =3D CIFS_I(inode);
> >> + =A0 =A0 struct cifs_sb_info *cifs_sb =3D CIFS_SB(inode->i_sb);
> >> =A0 =A0 =A0 struct cifsLockInfo *li, *tmp;
> >> + =A0 =A0 bool last_open_file =3D false;
> >>
> >> =A0 =A0 =A0 spin_lock(&cifs_file_list_lock);
> >> =A0 =A0 =A0 if (--cifs_file->count > 0) {
> >> @@ -279,10 +281,14 @@ void cifsFileInfo_put(struct cifsFileInfo *c=
ifs_file)
> >> =A0 =A0 =A0 if (list_empty(&cifsi->openFileList)) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cFYI(1, "closing last open instance fo=
r inode %p",
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_file->dentry->d_i=
node);
> >> + =A0 =A0 =A0 =A0 =A0 =A0 last_open_file =3D true;
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 cifs_set_oplock_level(inode, 0);
> >> =A0 =A0 =A0 }
> >> =A0 =A0 =A0 spin_unlock(&cifs_file_list_lock);
> >>
> >> + =A0 =A0 if ((cifs_sb->mnt_cifs_flags & CIFS_MOUNT_STRICT_IO) && =
last_open_file)
> >> + =A0 =A0 =A0 =A0 =A0 =A0 invalidate_remote_inode(inode);
> >> +
> >
> > Now that I think about it...this looks racy. Suppose someone races =
in
> > after you set last_open_file, opens the file and does a write....
>=20
> Can you explain what bad happens in this case?
>=20

It looks like you'll be invalidating potentially up-to-date data.
Either way...I've been steadily trying to move the code to a more
well-defined codepath for invalidating dirty data. Zapping the cached
pages here is unnecessary. It would be better to just mark the inode as
having an invalid mapping and move on, unless you see some other reason
why we must zap all of the pages here.

> >
> > I think you'd be better served by setting the invalid_mapping flag =
on
> > the cifs_i instead and letting the normal revalidation codepath han=
dle
> > this. The cache will then be invalidated the next time
> > cifs_revalidate_file/dentry is run.
> >
> >> =A0 =A0 =A0 if (!tcon->need_reconnect && !cifs_file->invalidHandle=
) {
> >> =A0 =A0 =A0 =A0 =A0 =A0 =A0 int xid, rc;
> >>
> >
>=20
>=20
>=20


--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
