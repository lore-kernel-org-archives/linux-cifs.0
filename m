From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: fix oops while traversing open file list
Date: Wed, 16 May 2012 09:56:43 -0400
Message-ID: <20120516095643.10f78260@tlielax.poochiereds.net>
References: <1337093239-23409-1-git-send-email-shirishpargaonkar@gmail.com>
	<20120515125525.19ef9cc8@tlielax.poochiereds.net>
	<CADT32eLzgHoom5Fp0BVGnZ6+H12J+TAHDyxLrbmGzsO62jbDbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32eLzgHoom5Fp0BVGnZ6+H12J+TAHDyxLrbmGzsO62jbDbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 16 May 2012 08:39:25 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Tue, May 15, 2012 at 11:55 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Tue, 15 May 2012 09:47:19 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >> While traversing the linked list of open file handles, if the iden=
tfied
> >> file handle is invalid, a reopen is attempted and if it fails, we
> >> resume traversing where we stopped and cifs can oops while accessi=
ng
> >> invalid next element, for list might have changed.
> >>
> >> So mark the invalid file handle and attempt reopen if no
> >> valid file handle is found in rest of the list.
> >> Move the invalid file handle to the end of the list and
> >> if reopen fails for that file handle, start traversing the list ag=
ain
> >> from the begining.
> >> Repeat this four times before giving up and returning an error if
> >> file reopen keeps failing.
> >>
> >>
> >> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/cifsglob.h | =C2=A0 =C2=A01 +
> >> =C2=A0fs/cifs/file.c =C2=A0 =C2=A0 | =C2=A0 55 +++++++++++++++++++=
++++++++++----------------------
> >> =C2=A02 files changed, 32 insertions(+), 24 deletions(-)
> >>
> >> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> >> index 4ff6313..73fea28 100644
> >> --- a/fs/cifs/cifsglob.h
> >> +++ b/fs/cifs/cifsglob.h
> >> @@ -43,6 +43,7 @@
> >>
> >> =C2=A0#define CIFS_MIN_RCV_POOL 4
> >>
> >> +#define MAX_REOPEN_ATT =C2=A0 =C2=A0 =C2=A0 5 /* these many maxim=
um attempts to reopen a file */
> >
> >
> > I don't know about this...
> >
> > What happens if we have a long network partition, and then make 5
> > attempts to open the file that time out? AFAICT, we'll end up retur=
ning
> > NULL, and see the dreaded "No writable handles for inode" and then
> > we end up with people complaining about "corrupt data" on writeback=
=2E
> >
>=20
> Jeff, that could happen with existing code as well, right?
> This patch is fixing the oops part, where cifs could trip on an eleme=
nt
> in the list that does not exist while lock was not being held.
>=20

Hmm...good point. I suppose then that that makes this more resilient
than the current code. Fair enough then, this is probably reasonable as
a stopgap measure.

This code is a mess and really needs a complete rethink from the ground
up though.

> > Is that really the outcome we want with this? That doesn't seem lik=
e
> > very resilient behavior for a network filesystem.
> >
> >> =C2=A0/*
> >> =C2=A0 * default attribute cache timeout (jiffies)
> >> =C2=A0 */
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index 81725e9..52da2d2 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1539,10 +1539,11 @@ struct cifsFileInfo *find_readable_file(st=
ruct cifsInodeInfo *cifs_inode,
> >> =C2=A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo=
 *cifs_inode,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool=
 fsuid_only)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 struct cifsFileInfo *open_file;
> >> + =C2=A0 =C2=A0 struct cifsFileInfo *open_file, *inv_file =3D NULL=
;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> =C2=A0 =C2=A0 =C2=A0 bool any_available =3D false;
> >> =C2=A0 =C2=A0 =C2=A0 int rc;
> >> + =C2=A0 =C2=A0 unsigned int refind =3D 0;
> >>
> >> =C2=A0 =C2=A0 =C2=A0 /* Having a null inode here (because mapping-=
>host was set to zero by
> >> =C2=A0 =C2=A0 =C2=A0 the VFS or MM) should not happen but we had r=
eports of on oops (due to
> >> @@ -1562,40 +1563,25 @@ struct cifsFileInfo *find_writable_file(st=
ruct cifsInodeInfo *cifs_inode,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&cifs_file_list_lock);
> >> =C2=A0refind_writable:
> >> + =C2=A0 =C2=A0 if (refind > MAX_REOPEN_ATT) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&cifs_file=
_list_lock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> + =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(open_file, &cifs_inode->o=
penFileList, flist) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!any_availabl=
e && open_file->pid !=3D current->tgid)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fsuid_only &&=
 open_file->uid !=3D current_fsuid())
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (OPEN_FMODE(op=
en_file->f_flags) & FMODE_WRITE) {
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifsFileInfo_get(open_file);
> >> -
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 if (!open_file->invalidHandle) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 /* found a good writable file */
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifsFileInfo_get(open_file);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&cifs_file_list_lock=
);
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return open_file;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 } else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!inv_file)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 inv_file =3D=
 open_file;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 }
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_unlock(&cifs_file_list_lock);
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* Had to unlock since following call can block */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 rc =3D cifs_reopen_file(open_file, false);
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 if (!rc)
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 return open_file;
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* if it fails, try another handle if possible */
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cFYI(1, "wp failed on reopen file");
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifsFileInfo_put(open_file);
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_lock(&cifs_file_list_lock);
> >> -
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 /* else we simply continue to the next entry. Thus
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0we do not loop on reopen errors. =C2=A0If we
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0can not reopen the file, for example if we
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0reconnected to a server with another client
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0racing to delete or lock the file we would not
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0make progress if we restarted before the beginning
> >> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0of the loop here. */
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0 =C2=A0 =C2=A0 /* couldn't find useable FH with same pid, tr=
y any available */
> >> @@ -1603,7 +1589,28 @@ refind_writable:
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 any_available =3D=
 true;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto refind_writa=
ble;
> >> =C2=A0 =C2=A0 =C2=A0 }
> >> +
> >> + =C2=A0 =C2=A0 if (inv_file) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 any_available =3D fals=
e;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 cifsFileInfo_get(inv_f=
ile);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_del(&inv_file->fl=
ist);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_add_tail(&inv_fil=
e->flist, &cifs_inode->openFileList);

nit: the above two lines could be replaced with list_move_tail()

> >> + =C2=A0 =C2=A0 }
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 spin_unlock(&cifs_file_list_lock);
> >> +
> >> + =C2=A0 =C2=A0 if (inv_file) {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 rc =3D cifs_reopen_fil=
e(inv_file, false);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!rc)
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 return inv_file;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else {
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 spin_lock(&cifs_file_list_lock);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 cifsFileInfo_put(inv_file);
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 ++refind;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 goto refind_writable;
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> + =C2=A0 =C2=A0 }
> >> +
> >> =C2=A0 =C2=A0 =C2=A0 return NULL;
> >> =C2=A0}
> >>
> >

Acked-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
