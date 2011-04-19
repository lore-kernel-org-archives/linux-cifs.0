From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH] cifs: guard against entries being deleted from open
 file list
Date: Tue, 19 Apr 2011 07:49:46 -0400
Message-ID: <20110419074946.5f9458b9@corrin.poochiereds.net>
References: <1303134275-12587-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110418105025.2b62fa69@corrin.poochiereds.net>
	<BANLkTimuLqbz6fj9SuV+_3KmuJ9Keh_9hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTimuLqbz6fj9SuV+_3KmuJ9Keh_9hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, 18 Apr 2011 22:02:21 -0500
Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Mon, Apr 18, 2011 at 9:50 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrot=
e:
> > On Mon, 18 Apr 2011 08:44:35 -0500
> > shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
> >
> >> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >>
> >>
> >> It is possible that a close can occur while a file is
> >> being reopened which can result in list entry deleted
> >> from the list and an oops.
> >> Use list_for_each_entry_safe instead.
> >>
> >>
> >> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> ---
> >> =C2=A0fs/cifs/file.c | =C2=A0 =C2=A05 +++--
> >> =C2=A01 files changed, 3 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> >> index faf5952..aa29167 100644
> >> --- a/fs/cifs/file.c
> >> +++ b/fs/cifs/file.c
> >> @@ -1056,7 +1056,7 @@ struct cifsFileInfo *find_readable_file(stru=
ct cifsInodeInfo *cifs_inode,
> >> =C2=A0struct cifsFileInfo *find_writable_file(struct cifsInodeInfo=
 *cifs_inode,
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 bool=
 fsuid_only)
> >> =C2=A0{
> >> - =C2=A0 =C2=A0 struct cifsFileInfo *open_file;
> >> + =C2=A0 =C2=A0 struct cifsFileInfo *open_file, *tmpf;
> >> =C2=A0 =C2=A0 =C2=A0 struct cifs_sb_info *cifs_sb;
> >> =C2=A0 =C2=A0 =C2=A0 bool any_available =3D false;
> >> =C2=A0 =C2=A0 =C2=A0 int rc;
> >> @@ -1079,7 +1079,8 @@ struct cifsFileInfo *find_writable_file(stru=
ct cifsInodeInfo *cifs_inode,
> >>
> >> =C2=A0 =C2=A0 =C2=A0 spin_lock(&cifs_file_list_lock);
> >> =C2=A0refind_writable:
> >> - =C2=A0 =C2=A0 list_for_each_entry(open_file, &cifs_inode->openFi=
leList, flist) {
> >> + =C2=A0 =C2=A0 list_for_each_entry_safe(open_file, tmpf, &cifs_in=
ode->openFileList,
> >> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 flist) {
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!any_availabl=
e && open_file->pid !=3D current->tgid)
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 continue;
> >> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (fsuid_only &&=
 open_file->uid !=3D current_fsuid())
> >
> > I don't think this is a real fix for this problem, and may cause ot=
her
> > issues. list_for_each_entry_safe is only protects you when you are
> > iterating over a list (usually while holding a lock) and removing t=
hose
> > entries. The *_safe part makes it ok to remove the entry that you'r=
e
> > currently dealing with from the list.
> >
> > Now, that can happen if you find an entry, do a cifsFileInfo_get, d=
rop
> > the spinlock and then calling cifsFileInfo_put and putting the last
> > reference afterward. Here's the problem though -- once you drop the
> > spinlock, there's nothing that says that the next entry in the list=
 is
> > necessarily still valid once you move to that entry.
> >
> > What if the entry *after* the one that you're currently dealing wit=
h is
> > removed from the list while you're iterating over it? This patch wi=
ll
> > cause an oops in that situation now when it didn't before. So, I th=
ink
> > this patch will probably just trade one set of problems for another=
=2E
> >
> > I think the real fix is overhauling how all of the reopen_file stuf=
f
> > works, but fixing it looks anything but straightforward.
> >
> > --
> > Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
> >
>=20
> Jeff, I do not mind taking a stab at it.  Do you have suggestsion/ide=
as
> about how to approach it?
>=20

One idea might be to break up the openFileList into two lists. One for
valid handles and one for invalid ones. When you mark the file invalid,
move it to the other list.

When calling find_writable_file, walk the list of valid handles first,
and then walk the other list and start reclaiming filehandles and
moving them back to the openFileList if you don't find one on the first
pass.

Getting the locking right on all of that will be "fun", though.

While you're at it, it might also be a good time to get rid of some of
these global locks. The cifs_file_list_lock for instance could probably
stand to be more granular.

Some of the callers of find_writable_file could also be eliminated --
the ones in the setattr codepath, specifically by having them use
iattr->ia_file field.

It also wouldn't hurt to merge find_readable_file and
find_writable_file into a single function that takes a fmode_t argument=
=2E

Or, consider something more general -- a generic filehandle acquisition
layer that looks for open files that meet criteria that can be used by
any opener or current caller of find_*_file.

The possibilities for glory are endless here...

--=20
Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
