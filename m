From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifs: cifs_flush should wait for writeback to complete
 before proceeding
Date: Fri, 24 Sep 2010 15:45:20 -0400
Message-ID: <20100924154520.5afad8a7@tlielax.poochiereds.net>
References: <1285333153-9113-1-git-send-email-jlayton@redhat.com>
	<AANLkTimdoOPyAmhWw0kTtnZan6+gudJZn=vgqTNpEL+A@mail.gmail.com>
	<20100924141137.4cb03197@tlielax.poochiereds.net>
	<AANLkTinunozFdg9S+pBrNLpcgZKoAzVg2a4QXBOBi--u@mail.gmail.com>
	<20100924150826.1819f930@tlielax.poochiereds.net>
	<AANLkTikX=cLcVK3FOFyiBeaYBQOSARHE1bnaKQcvXhX+@mail.gmail.com>
	<20100924153206.48c202f4@tlielax.poochiereds.net>
	<AANLkTinECWNE9B56fYhp7iahp3QN8S_f0BHV9XS4SBhX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTinECWNE9B56fYhp7iahp3QN8S_f0BHV9XS4SBhX-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, 24 Sep 2010 14:36:19 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Fri, Sep 24, 2010 at 2:32 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
> > On Fri, 24 Sep 2010 14:24:31 -0500
> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >
> >> On Fri, Sep 24, 2010 at 2:08 PM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> =
wrote:
> >> > On Fri, 24 Sep 2010 13:43:40 -0500
> >> > Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> >> >
> >> >> It don't think it is a correctness issue - if close wants to do=
 an
> >> >> fsync why do we have a flush routine at all? close is the only =
place
> >> >> flush is called. =A0This seems very wrong to require additional
> >> >> semantics beyond Unix semantics here (and slows close performan=
ce way
> >> >> down unnecessarily). =A0Even if we go async we would initiate i=
/o on
> >> >> these before we return close to the user - and we are not going=
 to
> >> >> close the network handle of course until all network writes com=
plete.
> >> >>
> >> >> At a minimum, we don't need to do an fsync (flush with wait) on=
 close
> >> >> if there is more than one handle to that inode open - and shoul=
d be
> >> >> able to just do flush
> >> >>
> >> >
> >> > What does this have to do with fsync? The flush operation is to =
flush
> >> > out data to the server prior to close. CIFS is not like a local =
fs or
> >> > even NFS. We have to have an open filehandle in order to write o=
ut
> >> > data.
> >>
> >> fsync is an fs file operation, handle based - so why do we need a =
distinct
> >> flush call if it has identical semantics?
> >>
> >>
> >
> > fsync has much more strict semantics than close. For many local
> > filesystems that implies a barrier or something equivalent to ensur=
e
> > that it actually made it to the media. For the CIFS case, we also i=
ssue
> > a SMB_COM_FLUSH in the fsync case, but not for close.
> >
> > flush is for the close(2) call. Not all filesystems need to flush d=
ata
> > to disk on close. A local filesystem may be perfectly able to keep
> > the data in pagecache and write it out whenever it gets to it even
> > long after all file descriptors are closed.
> >
> > CIFS is not like that -- no filehandle =3D=3D no writeback. Thus, w=
e need to
> > wait for writeback to complete before allowing writable filehandles=
 to
> > be closed.
>=20
> ? We do that already - we don't close the last writeable filehandle u=
ntil
> all writes complete.  If we had too - we could hold up the close of t=
he
> user's last writeable file handle until all writes complete and
> we can close the last writeable cifs network handle - but we end up
> doing that already.
>=20
>=20

Can you point out where the code waits for writeback to complete before
the last writable filehandle is closed? I'm not seeing it...

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
