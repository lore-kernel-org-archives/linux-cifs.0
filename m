From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 14:11:32 -0600
Message-ID: <AANLkTikc2GAe1+jRyuJGEJ8i5EBtoO-dayocL2yATMWQ@mail.gmail.com>
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
	<20110301150949.6ca5b880@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110301150949.6ca5b880-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

I vaguely remember that the same problem can occur with nfsd on a
local file system and that nfs clients have to be able to recover from
ESTALE (e.g. lookup/delete/create/lookup would fail with ESTALE
otherwise).   Don't clients handle ESTALE by relooking up the file ala

http://lwn.net/Articles/272684/

On Tue, Mar 1, 2011 at 2:09 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, 1 Mar 2011 14:21:03 -0500
> "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org> wrote:
>
>> On Tue, Mar 01, 2011 at 12:30:12PM -0600, Shirish Pargaonkar wrote:
>> > On Tue, Mar 1, 2011 at 12:07 PM, J. Bruce Fields <bfields@fieldses=
=2Eorg> wrote:
>> > > On Mon, Feb 28, 2011 at 10:28:08PM -0500, J. Bruce Fields wrote:
>> > >> On Mon, Feb 28, 2011 at 08:33:08PM -0600, Steve French wrote:
>> > >> > On Mon, Feb 28, 2011 at 5:59 PM, J. Bruce Fields <bfields@fie=
ldses.org> wrote:
>> > >> > > On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrot=
e:
>> > >> > >> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields@=
fieldses.org> wrote:
>> > >> > >> > OK. =A0Then as things stand we're stuck returning ESTALE=
 to the client
>> > >> > >> > unless we happen to have the inode they're looking for i=
n our cache?
>> > >> > >>
>> > >> > >> Yes - that seems right and consistent with what I remember=
 other file
>> > >> > >> systems doing.
>> > >> > >
>> > >> > > No, other filesystems are able to look up the file on disk =
by inode
>> > >> > > number (or by whatever identifier they use in the filehandl=
e). =A0They
>> > >> > > don't depend on already having the inode in core.
>> > >> >
>> > >> > Grepping for ESTALE looks like there are dozens of places in =
various
>> > >> > fs where ESTALE can get returned ...
>> > >>
>> > >> Certainly true.
>> > >>
>> > >> But they do have to be able to look up any inode, regardless of=
 whether
>> > >> it is currently in cache.
>> > >>
>> > >> Otherwise applications on the client would see ESTALE after any=
 server
>> > >> reboot, or any time an inode was forced out of cache (for whate=
ver
>> > >> reason).
>> > >>
>> > >> That would be quite painful.
>> > >
>> > > So if my understanding of the cifs behavior here is correct, the=
n I
>> > > don't believe nfs exports of cifs will be usable.
>> > >
>> > > In the long term perhaps it could be possible with changes to on=
e or the
>> > > other of the protocols: for example, perhaps future versions of =
the nfs
>> > > protocol could be made less reliant on long-lived filehandles. =A0=
But that
>> > > would be a major change.
>> > >
>> > > --b.
>> > >
>> >
>> > Bruce, I am not getting a picture of how NFS server would return E=
STALE
>> > error to nfs client and then on to the app for a filehandle fragme=
nt
>> > that happens
>> > to be coded as uniqueid by cifs during encode_fh if inode =A0with =
that uniqueid
>> > does not happen to exist in vfs cache on the server box.
>> >
>> > When nfs passes down =A0filehandle fragment (uniqueid) to cifs in =
fh_to_dentry,
>> > if the inode does not exist in cache, cifs will pick a new inode a=
nd copy this
>> > uniqueid as inode number.
>>
>> Oh, OK, that's not what I'd imagined.
>>
>
> Egads. Bruce is quite right and this is just plain not going to work.
> Here's one way that this will go wrong and can never be fixed. I'm
> fairly certain that there are others:
>
> Suppose that we set up a exported cifs mount. The NFS client mounts i=
t,
> opens a file and starts writing data to the inode. So far so good --
> the client did a LOOKUP operation at some point, which got translated
> to a QPathInfo by cifs and a positive dentry ended up in cache.
>
> The client then buffers up some writes. Now, suppose that the server
> then reboots (or that the inode got pushed out of the cache since it
> wasn't in use). The server redoes the cifs mount and reexports it. Th=
e
> client then tries to flush the buffered writes. The server gets a wri=
te
> request but now the inode isn't in cache and we can't match up the
> filehandle to anything. Server returns -ESTALE.
>
> At that point, you're screwed. There's virtually no way for the clien=
t
> to recover. We can't guarantee that the NFS client will have a valid
> path to the inode even if it did want to retry the lookup, which it
> really shouldn't need to do anyway.
>
> The fact that the CIFS protocol has no way to look up inodes by
> anything like an inode number really makes this whole idea dead on
> arrival.
> --
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>



--=20
Thanks,

Steve
