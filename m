From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Fri, 24 Sep 2010 13:43:40 -0500
Message-ID: <AANLkTinunozFdg9S+pBrNLpcgZKoAzVg2a4QXBOBi--u@mail.gmail.com>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
	<AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
	<20100924141137.4cb03197@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100924141137.4cb03197-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

It don't think it is a correctness issue - if close wants to do an
fsync why do we have a flush routine at all? close is the only place
flush is called.  This seems very wrong to require additional
semantics beyond Unix semantics here (and slows close performance way
down unnecessarily).  Even if we go async we would initiate i/o on
these before we return close to the user - and we are not going to
close the network handle of course until all network writes complete.

At a minimum, we don't need to do an fsync (flush with wait) on close
if there is more than one handle to that inode open - and should be
able to just do flush

On Fri, Sep 24, 2010 at 1:11 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote=
:
> On Fri, 24 Sep 2010 12:58:55 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> We need to see the performance impact. =A0As you say cifs_writepages=
 is
>> synchronous so we should be ok without it. =A0Any test results
>> before/after?
>>
>
> No, I haven't tested this for performance. It is a correctness issue
> though. We absolutely can't put the last reference to the last open
> filehandle without flushing all of the data first.
>
> My expectation here though is that this may help performance in some
> cases since this patch also has it skip the flush on files open
> read-only.
>
>> On Fri, Sep 24, 2010 at 7:59 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>> > It's possible that the kernel will call cifs_close on a filp while=
 there
>> > is still dirty data attached to the inode. If it's the last writea=
ble
>> > filp for an inode, then we may have no way to flush this data to t=
he
>> > server.
>> >
>> > Thus, simply doing a filemap_fdatawrite in the .flush operation is=
n't
>> > sufficient. The client needs to wait for it to complete before
>> > returning. OTOH, there's no real need to perform a flush on a
>> > filehandle that's read-only.
>> >
>> > What currently saves us on this is the fact that cifs_writepages i=
s
>> > basically synchronous. If and when we ever switch to an async writ=
eback
>> > model, this will need to be fixed, so we might as well go ahead an=
d
>> > fix it now.
>> >
>> > When flushing a writable filp, wait for the writeback to complete =
before
>> > returning to ensure that the filehandle stays around until the wri=
teback
>> > is complete.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/file.c | =A0 17 +++++++----------
>> > =A01 files changed, 7 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > index 80856f1..8084a8d 100644
>> > --- a/fs/cifs/file.c
>> > +++ b/fs/cifs/file.c
>> > @@ -1737,16 +1737,13 @@ int cifs_flush(struct file *file, fl_owner=
_t id)
>> > =A0 =A0 =A0 =A0struct inode *inode =3D file->f_path.dentry->d_inod=
e;
>> > =A0 =A0 =A0 =A0int rc =3D 0;
>> >
>> > - =A0 =A0 =A0 /* Rather than do the steps manually:
>> > - =A0 =A0 =A0 =A0 =A0lock the inode for writing
>> > - =A0 =A0 =A0 =A0 =A0loop through pages looking for write behind d=
ata (dirty pages)
>> > - =A0 =A0 =A0 =A0 =A0coalesce into contiguous 16K (or smaller) chu=
nks to write to server
>> > - =A0 =A0 =A0 =A0 =A0send to server (prefer in parallel)
>> > - =A0 =A0 =A0 =A0 =A0deal with writebehind errors
>> > - =A0 =A0 =A0 =A0 =A0unlock inode for writing
>> > - =A0 =A0 =A0 =A0 =A0filemapfdatawrite appears easier for the time=
 being */
>> > -
>> > - =A0 =A0 =A0 rc =3D filemap_fdatawrite(inode->i_mapping);
>> > + =A0 =A0 =A0 /*
>> > + =A0 =A0 =A0 =A0* if the file is writable, then flush any dirty d=
ata to ensure that
>> > + =A0 =A0 =A0 =A0* the filehandle isn't closed out before writebac=
k completes.
>> > + =A0 =A0 =A0 =A0*/
>> > + =A0 =A0 =A0 if (file->f_mode & FMODE_WRITE)
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 rc =3D filemap_write_and_wait(inode-=
>i_mapping);
>> > +
>> > =A0 =A0 =A0 =A0/* reset wb rc if we were able to write out dirty p=
ages */
>> > =A0 =A0 =A0 =A0if (!rc) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rc =3D CIFS_I(inode)->write_behind_=
rc;
>> > --
>> > 1.7.2.3
>> >
>> >
>>
>>
>>
>
>
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
