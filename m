From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] CIFS: Use invalidate_inode_pages2 instead of
 invalidate_remote_inode (try #4)
Date: Wed, 23 Mar 2011 13:56:26 -0400
Message-ID: <20110323135626.1fe56d84@corrin.poochiereds.net>
References: <1300229732-4902-1-git-send-email-piastry@etersoft.ru>
	<20110322080409.23461155@corrin.poochiereds.net>
	<AANLkTin_dHLJLpZxnmbCM=ukg7_xBi7YHg_YRaaYUmkj@mail.gmail.com>
	<20110322111711.55365655@corrin.poochiereds.net>
	<AANLkTikMbyg6FK7tgcb-a9kc_2r-rToA2x0AvY_KHQUw@mail.gmail.com>
	<20110322123549.022e590e@corrin.poochiereds.net>
	<AANLkTim=J7Y-b07HHKypfxgXL=jpgVVaZ1hn2201Amny@mail.gmail.com>
	<AANLkTikg4WQrguR_cvvkxXZ8XomO=3ySjPzT67yO_cvk@mail.gmail.com>
	<20110322130334.0680b9a3@corrin.poochiereds.net>
	<AANLkTikSUaLsEk5CNfVMXqLN4z=UGOeyYoMkTGQBLf2A@mail.gmail.com>
	<20110322134246.4b9e497e@corrin.poochiereds.net>
	<AANLkTi=zcYODYnx1q1bzBQtt2z7w1rkRxSTNTrK4u=7d@mail.gmail.com>
	<AANLkTimBdrWfAXZ4Ea_K33PyFN_REfNwcH7JjW71mJnh@mail.gmail.com>
	<AANLkTikPTVfiz4FNwu-i=1pHjE92vQgUh+eJLHY6j9nW@mail.gmail.com>
	<20110323121428.398f4d4c@corrin.poochiereds.net>
	<AANLkTimtOTGO6YPFwuRJGcZrxRk9VwjtA4kWOB_4RKDd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimtOTGO6YPFwuRJGcZrxRk9VwjtA4kWOB_4RKDd-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, 23 Mar 2011 12:32:03 -0500
Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Wed, Mar 23, 2011 at 11:14 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
> > On Wed, 23 Mar 2011 12:27:31 +0300
> > Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org> wrote:
> >
> >> 2011/3/23 Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> >> > Pavel,
> >> > Jeff and I talked about invalidate_mapping and its uses this
> >> > afternoon. =C2=A0A few comments:
> >> > 1) =C2=A0 Take a look at what happens on filemap_fdatawait call =
in
> >> > invalidate_mapping to see if it makes sense to return errors thr=
ough
> >> > back to some of the callers of invalidate_mapping, in particular=
,
> >> > strict_fsync. =C2=A0If we can't write out the file data (ENOSPC,=
 or host
> >> > down etc.), we want to make sure that the return code gets sent =
back
> >> > on any calls that can reasonably expect such an error.
> >>
> >> vfs_fsync_range has already done filemap_fdatawait call - so, in t=
his
> >> case there is no need to do it again in cifs_invalidate_mapping. T=
he
> >> only reason for calling this is to invalidate_inode_pages2 but any
> >> error there shouldn't affect fsync behavior, as I think.
> >>
> >> > 2) If invalidate_inode_pages2 fails (e.g. with EBUSY, because on=
e of
> >> > the pages couldn't be freed from the mapping because it just got
> >> > redirtied right after we flushed it the line before) we set the
> >> > mapping to invalid but don't check
> >> > =C2=A0 =C2=A0cifs_i->invalid_mapping
> >> > in many places. =C2=A0Should we add checks for cifs_i->invalid_m=
apping in
> >> > more places?
> >>
> >> The one place where we should add such a check is read call, but i=
t
> >> needs cifs_revalidate_file instead (that I am going to provide nex=
t)
> >> before generic_file_aio_read. In this case cifs_revalidate will ch=
eck
> >> for invalid_mapping and needs to return a error if we could not
> >> invalidate all inode pages in cifs_invalidate_mapping (because it
> >> returns wrong data to the read call). But as you noticed lseek
> >> shouldn't think about this error and it uses cifs_revalidate_file =
too.
> >>
> >> So, we may add extra check for -EBUSY error code in callers of
> >> cifs_revalidate_{dentry,file} and cifs_invaliadate_mapping and
> >> separate them into two groups:
> >> 1) that aware about -EBUSY error code and return a error the it's =
caller.
> >> these are: cifs_d_revalidate, cifs_file_aio_read (future
> >> implementation), cifs_file_strict_mmap.
> >> 2) that doesn't aware about it and return ok in this case.
> >> these are: cifs_getattrs, cifs_lseek, cifs_fsync.
> >>
> >> Thoughts?
> >>
> >
> > The main reason I think we need to reconsider that error is that I
> > spent several months tracking down a rather nasty data corruption b=
ug
> > relating to mmap on NFS in RHEL5 a few years ago:
> >
> > =C2=A0 =C2=A0https://bugzilla.redhat.com/show_bug.cgi?id=3D435291
> >
> > Part of the problem there was that the NFS client ignored the retur=
n
> > code from invalidate_inode_pages2. The other part of the problem wa=
s a
> > lack of synchronization between mmap calls and the page fault handl=
er.
> >
> > Needless to say, this was not a fun problem to track down. I think =
you
> > need to be very careful about ignoring errors from
> > invalidate_inode_pages2 and think carefully about what a failure th=
ere
> > means for all cases.
>=20
> I agree - need to be careful, but IIRC the NFS problem would be that
> it has a launder_page method which is returning an error through
> invalidate_inode_pages2 while in the cifs case the data is forced to
> be written out through filemap_fdatawrite or filemap_write_and_wait.
>=20

No. RHEL5 at that time didn't have a launder page method (it does now,
but that's another story).

--=20
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
