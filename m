From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH] cifs: Allow nfsd over cifs
Date: Tue, 1 Mar 2011 13:07:00 -0500
Message-ID: <20110301180700.GC20599@fieldses.org>
References: <1298929961-5541-1-git-send-email-shirishpargaonkar@gmail.com>
 <20110228224957.GB14237@fieldses.org>
 <AANLkTimDd-m388VJTC1zJtf3Q7LkFcsvNuwcY6vRwt7K@mail.gmail.com>
 <20110228234225.GC14237@fieldses.org>
 <AANLkTikeSEYOs_nzno40eM0ZSrStMqcziPzWGRViT5M-@mail.gmail.com>
 <20110228235910.GD14237@fieldses.org>
 <AANLkTinFwcBMmPpn0_30Bjaa+0ipoJ6qrM=u1TGQ+Q8g@mail.gmail.com>
 <20110301032808.GA17725@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20110301032808.GA17725-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Feb 28, 2011 at 10:28:08PM -0500, J. Bruce Fields wrote:
> On Mon, Feb 28, 2011 at 08:33:08PM -0600, Steve French wrote:
> > On Mon, Feb 28, 2011 at 5:59 PM, J. Bruce Fields <bfields@fieldses.=
org> wrote:
> > > On Mon, Feb 28, 2011 at 05:52:09PM -0600, Steve French wrote:
> > >> On Mon, Feb 28, 2011 at 5:42 PM, J. Bruce Fields <bfields@fields=
es.org> wrote:
> > >> > OK. =C2=A0Then as things stand we're stuck returning ESTALE to=
 the client
> > >> > unless we happen to have the inode they're looking for in our =
cache?
> > >>
> > >> Yes - that seems right and consistent with what I remember other=
 file
> > >> systems doing.
> > >
> > > No, other filesystems are able to look up the file on disk by ino=
de
> > > number (or by whatever identifier they use in the filehandle). =C2=
=A0They
> > > don't depend on already having the inode in core.
> >=20
> > Grepping for ESTALE looks like there are dozens of places in variou=
s
> > fs where ESTALE can get returned ...
>=20
> Certainly true.
>=20
> But they do have to be able to look up any inode, regardless of wheth=
er
> it is currently in cache.
>=20
> Otherwise applications on the client would see ESTALE after any serve=
r
> reboot, or any time an inode was forced out of cache (for whatever
> reason).
>=20
> That would be quite painful.

So if my understanding of the cifs behavior here is correct, then I
don't believe nfs exports of cifs will be usable.

In the long term perhaps it could be possible with changes to one or th=
e
other of the protocols: for example, perhaps future versions of the nfs
protocol could be made less reliant on long-lived filehandles.  But tha=
t
would be a major change.

--b.
