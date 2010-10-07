From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 13/15] cifs: convert cifsFileInfo->count to non-atomic counter
Date: Thu, 7 Oct 2010 10:37:54 -0500
Message-ID: <AANLkTi=MMzU6nr6+19PKW=gPKTdk9e-O5pjrYWmbV4AJ@mail.gmail.com>
References: <1286394857-32541-1-git-send-email-jlayton@redhat.com>
	<1286394857-32541-14-git-send-email-jlayton@redhat.com>
	<4CAD8972.9090406@suse.de>
	<20101007071819.2446312b@barsoom.rdu.redhat.com>
	<4CADB949.2070205@suse.de>
	<20101007084334.0e03f586@barsoom.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007084334.0e03f586-xSBYVWDuneFaJnirhKH9O4GKTjYczspe@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 7, 2010 at 7:43 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Thu, 07 Oct 2010 17:42:57 +0530
> Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>
>> On 10/07/2010 04:48 PM, Jeff Layton wrote:
>> > On Thu, 07 Oct 2010 14:18:50 +0530
>> > Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org> wrote:
>> >
>> >> On 10/07/2010 01:24 AM, Jeff Layton wrote:
>> >>> The count for cifsFileInfo is currently an atomic, but that just=
 adds
>> >>> complexity for little value. We generally need to hold cifs_file=
_list_lock
>> >>> to traverse the lists anyway so we might as well make this count=
er
>> >>> non-atomic and simply use the cifs_file_list_lock to protect it.
>> >>>
>> >>> Signed-off-by: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> >>> ---
>> >>> =A0fs/cifs/cifsglob.h | =A0 =A09 ++++++---
>> >>> =A0fs/cifs/file.c =A0 =A0 | =A0 =A08 +++++---
>> >>> =A02 files changed, 11 insertions(+), 6 deletions(-)
>> >>>
>> >>> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
>> >>> index 531a768..f3c4e00 100644
>> >>> --- a/fs/cifs/cifsglob.h
>> >>> +++ b/fs/cifs/cifsglob.h
>> >>> @@ -393,16 +393,19 @@ struct cifsFileInfo {
>> >>> =A0 struct list_head llist; /* list of byte range locks we have.=
 */
>> >>> =A0 bool invalidHandle:1; =A0 /* file closed via session abend *=
/
>> >>> =A0 bool oplock_break_cancelled:1;
>> >>> - atomic_t count; =A0 =A0 =A0 =A0 /* reference count */
>> >>> + int count; =A0 =A0 =A0 =A0 =A0 =A0 =A0/* refcount -- protected=
 by cifs_file_list_lock */
>> >>> =A0 struct mutex fh_mutex; /* prevents reopen race after dead se=
s*/
>> >>> =A0 struct cifs_search_info srch_inf;
>> >>> =A0 struct work_struct oplock_break; /* work for oplock breaks *=
/
>> >>> =A0};
>> >>>
>> >>> -/* Take a reference on the file private data */
>> >>> +/*
>> >>> + * Take a reference on the file private data. Must be called wi=
th
>> >>> + * cifs_file_list_lock held for read or write.
>> >>> + */
>> >>> =A0static inline void cifsFileInfo_get(struct cifsFileInfo *cifs=
_file)
>> >>> =A0{
>> >>> - atomic_inc(&cifs_file->count);
>> >>> + ++cifs_file->count;
>> >>
>> >> Since we now use cifs_file_list_lock to protect cifs_file->count =
too,
>> >> shouldn't all the callers of cifsFileInfo_get() need to acquire a=
 write
>> >> lock instead of read lock?
>> >>
>> >
>> > I puzzled over that too, but it's not really necessary. The lock i=
s
>> > really there to make sure that the list traversals are safe from
>> > removals. We do need the write lock when inserting or removing the
>> > cifsFileInfo into the lists, but for incrementing a non-zero refco=
unt a
>> > read lock is sufficient. That will prevent cifsFileInfo_put from
>> > racing in, decrementing the refcount and modifying the list since =
it
>> > needs a write lock.
>>
>> Fine, but, isn't possible to get the refcount wrong due to calls to
>> cifsFileInfo_get() from multiple callers?
>>
>
> Argh...good point. Maybe we do need to make this a regular spinlock
> after all. The times you can use a read lock safely are pretty limite=
d
> here.
>
>> > TBH, I think it would be far simpler (and maybe even more efficien=
t) to
>> > use a regular spinlock here, but I figured this would be easier to=
 get
>> > past review.
>> >
>>
>> I'm little worried about the overhead as I'm not sure whether all th=
e
>> paths are low contention paths...
>>
>
> I think they are generally low contention paths. Also, the lists are
> generally very short so the time the lock is held is too. Unless most
> of your accesses (like 90%) are read locked, then it's actually worse
> to use a rwlock than a regular spinlock.
>
> Even if a regular spinlock adds some overhead, it's really unlikely t=
o
> make any real difference in performance. CIFS is almost always bound =
by
> network latency, not CPU time.
>
> Steve, I mostly left this as a rwlock as I figured you might have
> issues moving this to a normal spinlock. Would you?

I doubt that a spinlock vs. a rwlock makes much difference,
but a rwlock lock for list insertion/removal seems more intuitive
and overloading it to also protect a counter adds complexity.
Seems more natural to leave it as an atomic counter.


--=20
Thanks,

Steve
