From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 15:09:49 -0500
Message-ID: <20110301150949.6ca5b880@tlielax.poochiereds.net>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110228224957.GB14237@fieldses.org>
	<AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
	<20110228234225.GC14237@fieldses.org>
	<AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
	<20110228235910.GD14237@fieldses.org>
	<AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
	<20110301032808.GA17725@fieldses.org>
	<20110301180700.GC20599@fieldses.org>
	<AANLkTikNH0ujA-qram1=1JEqJ7DH6dLRR723YZgJde1+@mail.gmail.com>
	<20110301192102.GD20599@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110301192102.GD20599-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 1 Mar 2011 14:21:03 -0500
"J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:

> On Tue, Mar 01, 2011 at 12:30:12PM -0600, Shirish Pargaonkar wrote:
> > On Tue, Mar 1, 2011 at 12:07 PM, J. Bruce Fields <bfields@fieldses.=
org> wrote:
> > > On Mon, Feb 28, 2011 at 10:28:08PM -0500, J. Bruce Fields wrote:
> > >> On Mon, Feb 28, 2011 at 08:33:08PM -0600, Steve French wrote:
> > >> > On Mon, Feb 28, 2011 at 5:59 PM, J. Bruce Fields <bfields@fiel=
dses.org> wrote:
> > >> > > On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrote=
:
> > >> > >> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields@f=
ieldses.org> wrote:
> > >> > >> > OK. =A0Then as things stand we're stuck returning ESTALE =
to the client
> > >> > >> > unless we happen to have the inode they're looking for in=
 our cache?
> > >> > >>
> > >> > >> Yes - that seems right and consistent with what I remember =
other file
> > >> > >> systems doing.
> > >> > >
> > >> > > No, other filesystems are able to look up the file on disk b=
y inode
> > >> > > number (or by whatever identifier they use in the filehandle=
). =A0They
> > >> > > don't depend on already having the inode in core.
> > >> >
> > >> > Grepping for ESTALE looks like there are dozens of places in v=
arious
> > >> > fs where ESTALE can get returned ...
> > >>
> > >> Certainly true.
> > >>
> > >> But they do have to be able to look up any inode, regardless of =
whether
> > >> it is currently in cache.
> > >>
> > >> Otherwise applications on the client would see ESTALE after any =
server
> > >> reboot, or any time an inode was forced out of cache (for whatev=
er
> > >> reason).
> > >>
> > >> That would be quite painful.
> > >
> > > So if my understanding of the cifs behavior here is correct, then=
 I
> > > don't believe nfs exports of cifs will be usable.
> > >
> > > In the long term perhaps it could be possible with changes to one=
 or the
> > > other of the protocols: for example, perhaps future versions of t=
he nfs
> > > protocol could be made less reliant on long-lived filehandles. =A0=
But that
> > > would be a major change.
> > >
> > > --b.
> > >
> >=20
> > Bruce, I am not getting a picture of how NFS server would return ES=
TALE
> > error to nfs client and then on to the app for a filehandle fragmen=
t
> > that happens
> > to be coded as uniqueid by cifs during encode_fh if inode  with tha=
t uniqueid
> > does not happen to exist in vfs cache on the server box.
> >=20
> > When nfs passes down  filehandle fragment (uniqueid) to cifs in fh_=
to_dentry,
> > if the inode does not exist in cache, cifs will pick a new inode an=
d copy this
> > uniqueid as inode number.
>=20
> Oh, OK, that's not what I'd imagined.
>=20

Egads. Bruce is quite right and this is just plain not going to work.
Here's one way that this will go wrong and can never be fixed. I'm
fairly certain that there are others:

Suppose that we set up a exported cifs mount. The NFS client mounts it,
opens a file and starts writing data to the inode. So far so good --
the client did a LOOKUP operation at some point, which got translated
to a QPathInfo by cifs and a positive dentry ended up in cache.

The client then buffers up some writes. Now, suppose that the server
then reboots (or that the inode got pushed out of the cache since it
wasn't in use). The server redoes the cifs mount and reexports it. The
client then tries to flush the buffered writes. The server gets a write
request but now the inode isn't in cache and we can't match up the
filehandle to anything. Server returns -ESTALE.

At that point, you're screwed. There's virtually no way for the client
to recover. We can't guarantee that the NFS client will have a valid
path to the inode even if it did want to retry the lookup, which it
really shouldn't need to do anyway.

The fact that the CIFS protocol has no way to look up inodes by
anything like an inode number really makes this whole idea dead on
arrival.
--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
