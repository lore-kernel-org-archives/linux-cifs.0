From: Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 04:26:31 -0800 (PST)
Message-ID: <1299717690-sup-2613@think>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
 <20110309215148.GW15097@dastard> <1299707686-sup-6871@think>
 <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Mingming Cao <mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Excerpts from Steve French's message of 2011-03-09 17:13:06 -0500:
> On Wed, Mar 9, 2011 at 3:58 PM, Chris Mason <chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> =
wrote:
> > Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -0500:
> >> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
> >> > Have alternative approaches, other than using wait_on_page_write=
back,
> >> > been considered for solving the stable page write problem in sim=
ilar
> >> > cases (since only about 1 out of 5 linux file systems uses this =
call
> >> > today).
> >>
> >> I think that is incorrect. write_cache_pages() does:
> >>
> >> =C2=A0929 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 lock_page(page);
> >> .....
> >> =C2=A0950 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (PageWriteback(page)) {
> >> =C2=A0951 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (wbc->sync_m=
ode !=3D WB_SYNC_NONE)
> >> =C2=A0952 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 wait_on_page_writeback(page);
> >> =C2=A0953 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 else
> >> =C2=A0954 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 goto continue_unlock;
> >> =C2=A0955 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 }
> >> =C2=A0956
> >> =C2=A0957 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 BUG_ON(PageWriteback(page));
> >> =C2=A0958 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!clear_page_dirty_for_io(page))
> >> =C2=A0959 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 goto continue_u=
nlock;
> >> =C2=A0960
> >> =C2=A0961 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 trace_wbc_writepage(wbc, mapping->backing_d=
ev_info);
> >> =C2=A0962 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 ret =3D (*writepage)(page, wbc, data);
> >>
> >> so every filesystem using the generic_writepages code already does
> >> this check and wait before .writepage is called. Hence only the
> >> filesystems that do not use generic_writepages() or
> >> mpage_writepages() need a specific check, and that means most
> >> filesystems are actually waiting on writeback pages correctly.
> >
> > But checking here just means we don't start writeback on a page tha=
t is
> > writeback, which is a good idea but not really related to stable pa=
ges?
> >
> > stable pages means we don't let mmap'd pages or file_write muck aro=
und
> > with the pages while they are in writeback, so we need to wait in
> > file_write and page_mkwrite.
>=20
> Isn't the file_write case covered by the i_mutex as
> Documentation/filesystems/Locking implies (for write_begin/write_end)=
=2E
>=20

Does cifs take i_mutex before writepage?  The disk based filesystems
don't.  So, i_mutex protects file_write from other procs jumping into
file_write, but it doesn't protect writeback from file_write jumping in
and changing the pages while they are being sent to storage (or over th=
e
wire).

Basically the model needs to be:

file_write:
	lock the page
	wait on page writeback

	< new writeback cannot start because of the page lock >
	copy_from_user
	unlock the page

We also use page_mkwrite to get notified when userland wants to change
some page it has given to mmap.  That needs to wait on page writeback a=
s
well.

-chris
