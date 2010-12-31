From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: move time field in cifsInodeInfo
Date: Thu, 30 Dec 2010 20:32:34 -0600
Message-ID: <AANLkTikFVrmkGfL2sMdgutS=D4b26QT_MPrqnqUNgX3=@mail.gmail.com>
References: <1293721034-31120-1-git-send-email-jlayton@redhat.com>
	<AANLkTimrSu3a9pOqCi7AtDp49AndT2q+ct+80RrM3+RQ@mail.gmail.com>
	<20101230102010.43a6b54a@tlielax.poochiereds.net>
	<AANLkTi=ATZ34x_jsRzbRQsMRtNC+8u0EDVUSqFeJvuD4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=ATZ34x_jsRzbRQsMRtNC+8u0EDVUSqFeJvuD4-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Dec 30, 2010 at 8:29 PM, Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> On Thu, Dec 30, 2010 at 9:20 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wro=
te:
>>
>> On Thu, 30 Dec 2010 18:14:34 +0300
>> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> > 2010/12/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > > ...and remove length qualifiers from bools.
>> > >
>> > > Before:
>> > >
>> > > =A0 =A0 =A0 =A0/* size: 1176, cachelines: 19, members: 13 */
>> > > =A0 =A0 =A0 =A0/* sum members: 1165, holes: 2, sum holes: 11 */
>> > > =A0 =A0 =A0 =A0/* bit holes: 1, sum bit holes: 4 bits */
>> > > =A0 =A0 =A0 =A0/* last cacheline: 24 bytes */
>> > >
>> > > After:
>> > >
>> > > =A0 =A0 =A0 =A0/* size: 1168, cachelines: 19, members: 13 */
>> > > =A0 =A0 =A0 =A0/* last cacheline: 16 bytes */
>> > >
>> > > ...savings of 8 bytes per inode.
>> > >
>> > > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > > ---
>> > > =A0fs/cifs/cifsglob.h | =A0 10 +++++-----
>> > > =A01 files changed, 5 insertions(+), 5 deletions(-)
>> > >
>> > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > > index d6433a4..701060d 100644
>> > > --- a/fs/cifs/cifsglob.h
>> > > +++ b/fs/cifs/cifsglob.h
>> > > @@ -439,11 +439,11 @@ struct cifsInodeInfo {
>> > > =A0 =A0 =A0 =A0/* BB add in lists for dirty pages i.e. write cac=
hing info for oplock */
>> > > =A0 =A0 =A0 =A0struct list_head openFileList;
>> > > =A0 =A0 =A0 =A0__u32 cifsAttrs; /* e.g. DOS archive bit, sparse,=
 compressed, system */
>> > > - =A0 =A0 =A0 unsigned long time; =A0 =A0 /* jiffies of last upd=
ate/check of inode */
>> > > - =A0 =A0 =A0 bool clientCanCacheRead:1; =A0 =A0 =A0/* read oplo=
ck */
>> > > - =A0 =A0 =A0 bool clientCanCacheAll:1; =A0 =A0 =A0 /* read and =
writebehind oplock */
>> > > - =A0 =A0 =A0 bool delete_pending:1; =A0 =A0 =A0 =A0 =A0/* DELET=
E_ON_CLOSE is set */
>> > > - =A0 =A0 =A0 bool invalid_mapping:1; =A0 =A0 =A0 =A0 /* pagecac=
he is invalid */
>> > > + =A0 =A0 =A0 bool clientCanCacheRead; =A0 =A0 =A0 =A0/* read op=
lock */
>> > > + =A0 =A0 =A0 bool clientCanCacheAll; =A0 =A0 =A0 =A0 /* read an=
d writebehind oplock */
>> > > + =A0 =A0 =A0 bool delete_pending; =A0 =A0 =A0 =A0 =A0 =A0/* DEL=
ETE_ON_CLOSE is set */
>> > > + =A0 =A0 =A0 bool invalid_mapping; =A0 =A0 =A0 =A0 =A0 /* pagec=
ache is invalid */
>> > > + =A0 =A0 =A0 unsigned long time; =A0 =A0 =A0 =A0 =A0 =A0 /* jif=
fies of last update of inode */
>> > > =A0 =A0 =A0 =A0u64 =A0server_eof; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* current file size on server */
>> > > =A0 =A0 =A0 =A0u64 =A0uniqueid; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0/* server inode number */
>> > > =A0 =A0 =A0 =A0u64 =A0createtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* creation time on server */
>> > > --
>> > > 1.7.3.4
>> > >
>> > > --
>> > > To unsubscribe from this list: send the line "unsubscribe linux-=
cifs" in
>> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > > More majordomo info at =A0http://vger.kernel.org/majordomo-info.=
html
>> > >
>> >
>> > Looks good. May be we should rename clientCanCache* to client_can_=
cache_*?
>> >
>> > Anyway - Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> >
>>
>> No objection to renaming fields. I actually wouldn't mind just keepi=
ng
>> the oplock flag as sent by the server either rather than translating=
 it
>> into bools. Either way though, that should be a separate patch...
>
> I don't mind booleans - on some archs the space saved can be
> significant. but in any case renaming fields from bool seems much
> lower priority than some of the other patches you all have submitted
> recently that add function or improve stability.

I had been thinking about requesting batch oplock for a while to
improve caching of files which are only briefly closed and to allow
multiple opens from the same client to be cached but decided to punt
on this for cifs and just do it for smb2 (don't mind cifs patches for
it - but it is not trivial).  Fortunately in smb2 other oplock
improvements help even more.


--=20
Thanks,

Steve
