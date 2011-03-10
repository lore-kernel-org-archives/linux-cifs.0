From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 08:32:09 -0500
Message-ID: <1299763214-sup-2862@think>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com> <20110309215148.GW15097@dastard> <1299707686-sup-6871@think> <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com> <1299717690-sup-2613@think> <20110310081638.0f8275d4@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <20110310081638.0f8275d4-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Excerpts from Jeff Layton's message of 2011-03-10 08:16:38 -0500:
> On Thu, 10 Mar 2011 04:26:31 -0800 (PST)
> Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>=20
> > Excerpts from Steve French's message of 2011-03-09 17:13:06 -0500:
> > > On Wed, Mar 9, 2011 at 3:58 PM, Chris Mason <chris.mason@oracle.c=
om> wrote:
> > > > Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -05=
00:
> > > >> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
> > > >> > Have alternative approaches, other than using wait_on_page_w=
riteback,
> > > >> > been considered for solving the stable page write problem in=
 similar
> > > >> > cases (since only about 1 out of 5 linux file systems uses t=
his call
> > > >> > today).
> > > >>
> > > >> I think that is incorrect. write_cache_pages() does:
> > > >>
> > > >> =C2=A0929 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_page(page);
> > > >> .....
> > > >> =C2=A0950 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (PageWriteback(page)) {
> > > >> =C2=A0951 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wbc->sy=
nc_mode !=3D WB_SYNC_NONE)
> > > >> =C2=A0952 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 wait_on_page_writeback(page);
> > > >> =C2=A0953 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> > > >> =C2=A0954 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 goto continue_unlock;
> > > >> =C2=A0955 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> > > >> =C2=A0956
> > > >> =C2=A0957 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(PageWriteback(page));
> > > >> =C2=A0958 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!clear_page_dirty_for_io(page))
> > > >> =C2=A0959 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto contin=
ue_unlock;
> > > >> =C2=A0960
> > > >> =C2=A0961 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 trace_wbc_writepage(wbc, mapping->backi=
ng_dev_info);
> > > >> =C2=A0962 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D (*writepage)(page, wbc, data);
> > > >>
> > > >> so every filesystem using the generic_writepages code already =
does
> > > >> this check and wait before .writepage is called. Hence only th=
e
> > > >> filesystems that do not use generic_writepages() or
> > > >> mpage_writepages() need a specific check, and that means most
> > > >> filesystems are actually waiting on writeback pages correctly.
> > > >
> > > > But checking here just means we don't start writeback on a page=
 that is
> > > > writeback, which is a good idea but not really related to stabl=
e pages?
> > > >
> > > > stable pages means we don't let mmap'd pages or file_write muck=
 around
> > > > with the pages while they are in writeback, so we need to wait =
in
> > > > file_write and page_mkwrite.
> > >=20
> > > Isn't the file_write case covered by the i_mutex as
> > > Documentation/filesystems/Locking implies (for write_begin/write_=
end).
> > >=20
> >=20
> > Does cifs take i_mutex before writepage? The disk based filesystems
> > don't.  So, i_mutex protects file_write from other procs jumping in=
to
> > file_write, but it doesn't protect writeback from file_write jumpin=
g in
> > and changing the pages while they are being sent to storage (or ove=
r the
> > wire).
> >=20
> > Basically the model needs to be:
> >=20
> > file_write:
> >     lock the page
> >     wait on page writeback
> >=20
> >     < new writeback cannot start because of the page lock >
> >     copy_from_user
> >     unlock the page
> >=20
> > We also use page_mkwrite to get notified when userland wants to cha=
nge
> > some page it has given to mmap.  That needs to wait on page writeba=
ck as
> > well.
> >=20
>=20
> No, cifs doesn't take the i_mutex in writepage, but the page is locke=
d.
> cifs_write_begin calls grab_cache_page_write_begin, which returns a
> locked page and it's not unlocked until cifs_write_end.

Ah ok, so you've got the page locked the whole time it is being sent
over the wire?  The disk based filesystems split it and drop the page
lock once the page is set writeback, which is why we need the extra
waits.

So in your case you should just need a page_mkwrite that locks the page=
=2E

-chris
