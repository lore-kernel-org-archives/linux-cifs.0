From: Jeff Layton <jlayton@redhat.com>
Subject: Re: stable page writes: wait_on_page_writeback and packet signing
Date: Thu, 10 Mar 2011 08:16:38 -0500
Message-ID: <20110310081638.0f8275d4@barsoom.rdu.redhat.com>
References: <AANLkTinFx9KGKDWSdUvFSvT4S6f9QjBzX=6Uo17oO89+@mail.gmail.com>
	<20110309215148.GW15097@dastard>
	<1299707686-sup-6871@think>
	<AANLkTikK8MOm-m9XsOA4YGRe=E9bJTDh4iEYXtZumNmv@mail.gmail.com>
	<1299717690-sup-2613@think>
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
In-Reply-To: <1299717690-sup-2613@think>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, 10 Mar 2011 04:26:31 -0800 (PST)
Chris Mason <chris.mason@oracle.com> wrote:

> Excerpts from Steve French's message of 2011-03-09 17:13:06 -0500:
> > On Wed, Mar 9, 2011 at 3:58 PM, Chris Mason <chris.mason@oracle.com=
> wrote:
> > > Excerpts from Dave Chinner's message of 2011-03-09 16:51:48 -0500=
:
> > >> On Wed, Mar 09, 2011 at 01:44:24PM -0600, Steve French wrote:
> > >> > Have alternative approaches, other than using wait_on_page_wri=
teback,
> > >> > been considered for solving the stable page write problem in s=
imilar
> > >> > cases (since only about 1 out of 5 linux file systems uses thi=
s call
> > >> > today).
> > >>
> > >> I think that is incorrect. write_cache_pages() does:
> > >>
> > >> =A0929 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 lock_page=
(page);
> > >> .....
> > >> =A0950 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (PageW=
riteback(page)) {
> > >> =A0951 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 if (wbc->sync_mode !=3D WB_SYNC_NONE)
> > >> =A0952 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 wait_on_page_writeback(page);
> > >> =A0953 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 else
> > >> =A0954 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 goto continue_unlock;
> > >> =A0955 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> > >> =A0956
> > >> =A0957 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 BUG_ON(Pa=
geWriteback(page));
> > >> =A0958 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!clea=
r_page_dirty_for_io(page))
> > >> =A0959 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 goto continue_unlock;
> > >> =A0960
> > >> =A0961 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 trace_wbc=
_writepage(wbc, mapping->backing_dev_info);
> > >> =A0962 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ret =3D (=
*writepage)(page, wbc, data);
> > >>
> > >> so every filesystem using the generic_writepages code already do=
es
> > >> this check and wait before .writepage is called. Hence only the
> > >> filesystems that do not use generic_writepages() or
> > >> mpage_writepages() need a specific check, and that means most
> > >> filesystems are actually waiting on writeback pages correctly.
> > >
> > > But checking here just means we don't start writeback on a page t=
hat is
> > > writeback, which is a good idea but not really related to stable =
pages?
> > >
> > > stable pages means we don't let mmap'd pages or file_write muck a=
round
> > > with the pages while they are in writeback, so we need to wait in
> > > file_write and page_mkwrite.
> >=20
> > Isn't the file_write case covered by the i_mutex as
> > Documentation/filesystems/Locking implies (for write_begin/write_en=
d).
> >=20
>=20
> Does cifs take i_mutex before writepage? The disk based filesystems
> don't.  So, i_mutex protects file_write from other procs jumping into
> file_write, but it doesn't protect writeback from file_write jumping =
in
> and changing the pages while they are being sent to storage (or over =
the
> wire).
>=20
> Basically the model needs to be:
>=20
> file_write:
> 	lock the page
> 	wait on page writeback
>=20
> 	< new writeback cannot start because of the page lock >
> 	copy_from_user
> 	unlock the page
>=20
> We also use page_mkwrite to get notified when userland wants to chang=
e
> some page it has given to mmap.  That needs to wait on page writeback=
 as
> well.
>=20

No, cifs doesn't take the i_mutex in writepage, but the page is locked.
cifs_write_begin calls grab_cache_page_write_begin, which returns a
locked page and it's not unlocked until cifs_write_end.

So I'm not sure I understand the potential race here. A normal
write_begin/end file write will block on the page lock, and the page is
locked during any writeback (either via writepage or writepages).

The only real "danger" is from processes that have the page mmapped as
they don't care about the page lock at all. A page_mkwrite routine that
does a wait_on_page_writeback should prevent that however.

--=20
Jeff Layton <jlayton@redhat.com>
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
