From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 08:47:24 -0500
Message-ID: <20110310084724.658fe5d7@barsoom.rdu.redhat.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<1299707686-sup-6871@think>
	<AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com>
	<1299717690-sup-2613@think>
	<20110310081638.0f8275d4@barsoom.rdu.redhat.com>
	<1299763214-sup-2862@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steve French <smfrench@gmail.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-cifs <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Mingming Cao <mcao@us.ibm.com>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1299763214-sup-2862@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 10 Mar 2011 08:32:09 -0500
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Jeff Layton's message of 2011-03-10 08:16:38 -0500:
> > On Thu, 10 Mar 2011 04:26:31 -0800 (PST)
> > Chris Mason <chris.mason@oracle.com> wrote:
> >=20
> > > Excerpts from Steve French's message of 2011-03-09 17:13:06 -0500=
:
> > > > On Wed, Mar 9, 2011 at 3:58 PM, Chris Mason <chris.mason@oracle=
=2Ecom> wrote:
> > > > > Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -=
0500:
> > > > >> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote=
:
> > > > >> > Have alternative approaches, other than using wait_on_page=
_writeback,
> > > > >> > been considered for solving the stable page write problem =
in similar
> > > > >> > cases (since only about 1 out of 5 linux file systems uses=
 this call
> > > > >> > today).
> > > > >>
> > > > >> I think that is incorrect. write_cache_pages() does:
> > > > >>
> > > > >> =A0929 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_=
page(page);
> > > > >> .....
> > > > >> =A0950 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (P=
ageWriteback(page)) {
> > > > >> =A0951 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 if (wbc->sync_mode !=3D WB_SYNC_NONE)
> > > > >> =A0952 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 wait_on_page_writeback(page);
> > > > >> =A0953 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 else
> > > > >> =A0954 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 goto continue_unlock;
> > > > >> =A0955 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > > > >> =A0956
> > > > >> =A0957 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_O=
N(PageWriteback(page));
> > > > >> =A0958 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!=
clear_page_dirty_for_io(page))
> > > > >> =A0959 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 goto continue_unlock;
> > > > >> =A0960
> > > > >> =A0961 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace=
_wbc_writepage(wbc, mapping->backing_dev_info);
> > > > >> =A0962 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D=
 (*writepage)(page, wbc, data);
> > > > >>
> > > > >> so every filesystem using the generic_writepages code alread=
y does
> > > > >> this check and wait before .writepage is called. Hence only =
the
> > > > >> filesystems that do not use generic_writepages() or
> > > > >> mpage_writepages() need a specific check, and that means mos=
t
> > > > >> filesystems are actually waiting on writeback pages correctl=
y.
> > > > >
> > > > > But checking here just means we don't start writeback on a pa=
ge that is
> > > > > writeback, which is a good idea but not really related to sta=
ble pages?
> > > > >
> > > > > stable pages means we don't let mmap'd pages or file_write mu=
ck around
> > > > > with the pages while they are in writeback, so we need to wai=
t in
> > > > > file_write and page_mkwrite.
> > > >=20
> > > > Isn't the file_write case covered by the i_mutex as
> > > > Documentation/filesystems/Locking implies (for write_begin/writ=
e_end).
> > > >=20
> > >=20
> > > Does cifs take i_mutex before writepage? The disk based filesyste=
ms
> > > don't.  So, i_mutex protects file_write from other procs jumping =
into
> > > file_write, but it doesn't protect writeback from file_write jump=
ing in
> > > and changing the pages while they are being sent to storage (or o=
ver the
> > > wire).
> > >=20
> > > Basically the model needs to be:
> > >=20
> > > file_write:
> > >     lock the page
> > >     wait on page writeback
> > >=20
> > >     < new writeback cannot start because of the page lock >
> > >     copy_from_user
> > >     unlock the page
> > >=20
> > > We also use page_mkwrite to get notified when userland wants to c=
hange
> > > some page it has given to mmap.  That needs to wait on page write=
back as
> > > well.
> > >=20
> >=20
> > No, cifs doesn't take the i_mutex in writepage, but the page is loc=
ked.
> > cifs_write_begin calls grab_cache_page_write_begin, which returns a
> > locked page and it's not unlocked until cifs_write_end.
>=20
> Ah ok, so you've got the page locked the whole time it is being sent
> over the wire?  The disk based filesystems split it and drop the page
> lock once the page is set writeback, which is why we need the extra
> waits.
>=20
> So in your case you should just need a page_mkwrite that locks the pa=
ge.
>=20

Right, or do a wait_on_page_writeback. I think that may have a little
less overhead since we won't need to unlock it and it may mean less
serialization if there are other contenders for the page lock.

--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
