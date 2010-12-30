From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: move time field in cifsInodeInfo
Date: Thu, 30 Dec 2010 18:29:38 +0300
Message-ID: <AANLkTin=wnye+2UX_wNSjwAL1DwQkhGw=QRJ6k7eg1PQ@mail.gmail.com>
References: <1293721034-31120-1-git-send-email-jlayton@redhat.com>
	<AANLkTimrSu3a9pOqCi7AtDp49AndT2q+ct+80RrM3+RQ@mail.gmail.com>
	<20101230102010.43a6b54a@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101230102010.43a6b54a-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/12/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> On Thu, 30 Dec 2010 18:14:34 +0300
> Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> 2010/12/30 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
>> > ...and remove length qualifiers from bools.
>> >
>> > Before:
>> >
>> > =A0 =A0 =A0 =A0/* size: 1176, cachelines: 19, members: 13 */
>> > =A0 =A0 =A0 =A0/* sum members: 1165, holes: 2, sum holes: 11 */
>> > =A0 =A0 =A0 =A0/* bit holes: 1, sum bit holes: 4 bits */
>> > =A0 =A0 =A0 =A0/* last cacheline: 24 bytes */
>> >
>> > After:
>> >
>> > =A0 =A0 =A0 =A0/* size: 1168, cachelines: 19, members: 13 */
>> > =A0 =A0 =A0 =A0/* last cacheline: 16 bytes */
>> >
>> > ...savings of 8 bytes per inode.
>> >
>> > Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > ---
>> > =A0fs/cifs/cifsglob.h | =A0 10 +++++-----
>> > =A01 files changed, 5 insertions(+), 5 deletions(-)
>> >
>> > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> > index d6433a4..701060d 100644
>> > --- a/fs/cifs/cifsglob.h
>> > +++ b/fs/cifs/cifsglob.h
>> > @@ -439,11 +439,11 @@ struct cifsInodeInfo {
>> > =A0 =A0 =A0 =A0/* BB add in lists for dirty pages i.e. write cachi=
ng info for oplock */
>> > =A0 =A0 =A0 =A0struct list_head openFileList;
>> > =A0 =A0 =A0 =A0__u32 cifsAttrs; /* e.g. DOS archive bit, sparse, c=
ompressed, system */
>> > - =A0 =A0 =A0 unsigned long time; =A0 =A0 /* jiffies of last updat=
e/check of inode */
>> > - =A0 =A0 =A0 bool clientCanCacheRead:1; =A0 =A0 =A0/* read oplock=
 */
>> > - =A0 =A0 =A0 bool clientCanCacheAll:1; =A0 =A0 =A0 /* read and wr=
itebehind oplock */
>> > - =A0 =A0 =A0 bool delete_pending:1; =A0 =A0 =A0 =A0 =A0/* DELETE_=
ON_CLOSE is set */
>> > - =A0 =A0 =A0 bool invalid_mapping:1; =A0 =A0 =A0 =A0 /* pagecache=
 is invalid */
>> > + =A0 =A0 =A0 bool clientCanCacheRead; =A0 =A0 =A0 =A0/* read oplo=
ck */
>> > + =A0 =A0 =A0 bool clientCanCacheAll; =A0 =A0 =A0 =A0 /* read and =
writebehind oplock */
>> > + =A0 =A0 =A0 bool delete_pending; =A0 =A0 =A0 =A0 =A0 =A0/* DELET=
E_ON_CLOSE is set */
>> > + =A0 =A0 =A0 bool invalid_mapping; =A0 =A0 =A0 =A0 =A0 /* pagecac=
he is invalid */
>> > + =A0 =A0 =A0 unsigned long time; =A0 =A0 =A0 =A0 =A0 =A0 /* jiffi=
es of last update of inode */
>> > =A0 =A0 =A0 =A0u64 =A0server_eof; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/=
* current file size on server */
>> > =A0 =A0 =A0 =A0u64 =A0uniqueid; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
/* server inode number */
>> > =A0 =A0 =A0 =A0u64 =A0createtime; =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/=
* creation time on server */
>> > --
>> > 1.7.3.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>> >
>>
>> Looks good. May be we should rename clientCanCache* to client_can_ca=
che_*?
>>
>> Anyway - Reviewed-by: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>
> No objection to renaming fields. I actually wouldn't mind just keepin=
g
> the oplock flag as sent by the server either rather than translating =
it
> into bools. Either way though, that should be a separate patch...

Agree. MS-CIFS has another oplock value - batch - that we didn't
implement yet. For the future, I think that keeping oplock flag is
better than keeping three different values.

--=20
Best regards,
Pavel Shilovsky.
