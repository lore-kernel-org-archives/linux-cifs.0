From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Complete oplock break jobs before closing file handle
Date: Mon, 19 Jan 2015 16:15:38 -0600
Message-ID: <CAH2r5mssmkhMHhnBrMnSamzmzhUCYopZ4iSMVXsi7toMYoKnnA@mail.gmail.com>
References: <1421324524-2524-1-git-send-email-sprabhu@redhat.com>
 <CADT32eLUO-sSio5PRZWB0kBvGB4QhYgy=LKOBKKOo8-Ww8nASg@mail.gmail.com>
 <20150119070209.0f83b94d@tlielax.poochiereds.net> <1421684692.13255.8.camel@redhat.com>
 <20150119113656.5a47c742@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150119113656.5a47c742-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Mon, Jan 19, 2015 at 10:36 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Mon, 19 Jan 2015 16:24:52 +0000
> Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
>> On Mon, 2015-01-19 at 07:02 -0500, Jeff Layton wrote:
>> > On Sat, 17 Jan 2015 07:45:13 -0600
>> > Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >
>> > > On Thu, Jan 15, 2015 at 6:22 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> > > > Commit
>> > > > c11f1df5003d534fd067f0168bfad7befffb3b5c
>> > > > requires writers to wait for any pending oplock break handler to
>> > > > complete before proceeding to write. This is done by waiting on bit
>> > > > CIFS_INODE_PENDING_OPLOCK_BREAK in cifsFileInfo->flags. This bit is
>> > > > cleared by the oplock break handler job queued on the workqueue once it
>> > > > has completed handling the oplock break allowing writers to proceed with
>> > > > writing to the file.
>> > > >
>> > > > While testing, it was noticed that the filehandle could be closed while
>> > > > there is a pending oplock break which results in the oplock break
>> > > > handler on the cifsiod workqueue being cancelled before it has had a
>> > > > chance to execute and clear the CIFS_INODE_PENDING_OPLOCK_BREAK bit.
>> > > > Any subsequent attempt to write to this file hangs waiting for the
>> > > > CIFS_INODE_PENDING_OPLOCK_BREAK bit to be cleared.
>> > > >
>> > > > We fix this by ensuring that we also clear the bit
>> > > > CIFS_INODE_PENDING_OPLOCK_BREAK when we remove the oplock break handler
>> > > > from the workqueue.
>> > > >
>> > > > The bug was found by Red Hat QA while testing using ltp's fsstress
>> > > > command.
>> > > >
>> > > > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > > > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> > > > ---
>> > > >  fs/cifs/file.c | 6 +++++-
>> > > >  1 file changed, 5 insertions(+), 1 deletion(-)
>> > > >
>> > > > diff --git a/fs/cifs/file.c b/fs/cifs/file.c
>> > > > index 96b7e9b..74f1287 100644
>> > > > --- a/fs/cifs/file.c
>> > > > +++ b/fs/cifs/file.c
>> > > > @@ -366,6 +366,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>> > > >         struct cifsLockInfo *li, *tmp;
>> > > >         struct cifs_fid fid;
>> > > >         struct cifs_pending_open open;
>> > > > +       bool oplock_break_cancelled;
>> > > >
>> > > >         spin_lock(&cifs_file_list_lock);
>> > > >         if (--cifs_file->count > 0) {
>> > > > @@ -397,7 +398,7 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>> > > >         }
>> > > >         spin_unlock(&cifs_file_list_lock);
>> > > >
>> > > > -       cancel_work_sync(&cifs_file->oplock_break);
>> > > > +       oplock_break_cancelled = cancel_work_sync(&cifs_file->oplock_break);
>> > > >
>> > > >         if (!tcon->need_reconnect && !cifs_file->invalidHandle) {
>> > > >                 struct TCP_Server_Info *server = tcon->ses->server;
>> > > > @@ -409,6 +410,9 @@ void cifsFileInfo_put(struct cifsFileInfo *cifs_file)
>> > > >                 _free_xid(xid);
>> > > >         }
>> > > >
>> > > > +       if (oplock_break_cancelled)
>> > > > +               cifs_done_oplock_break(cifsi);
>> > > > +
>> > > >         cifs_del_pending_open(&open);
>> > > >
>> > > >         /*
>> > > > --
>> > > > 2.1.0
>> > > >
>> > > > --
>> > > > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
>> > > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> > >
>> > >
>> > > Does it matter what cancel_work_sync() returns?
>> > > Should cifs_done_oplock_break(cifsi); be called unconditionally?
>> >
>> > I guess the question is whether you can end up with another oplock
>> > break racing in between cancel_work_sync and the
>> > cifs_done_oplock_break. If that can't happen, then calling it
>> > unconditionally is fine.
>>
>> By the time we call cancel_work_sync(), we have removed the file from
>> the list of files opened for the tcon. This is the file list used by
>> is_valid_oplock_break() to find the file which the oplock break refers
>> to and to schedule an oplock break work. Since the file is no longer in
>> the list of open files held for the tcon, we cannot have an oplock break
>> sneaking in between  cancel_work_sync() and cifs_done_oplock_break(). So
>> I guess it can be called unconditionally.
>>
>> Should I make the change?
>>
>
> I dunno. I'm not sure I really grok how this is supposed to work...
>
> The oplock break jobs are per-cifsFileInfo, but the
> CIFS_INODE_PENDING_OPLOCK_BREAK bit is per-inode. ISTM that you could
> end up with oplocks breaks for multiple open files attached to a single
> inode. If that happens though, you just end up waiting on the first one
> to finish (or be cancelled)?

The oplock (in the inode flags) is downgraded immediately.  Getting
multiple overlapping oplock breaks on different opens of the same inode
should be harmless as long as the first break was processed.

Doesn't look like the if (oplock_break_cancelled) ... matters one
way or the other. I am ok with merging as is (will add the CC stable)

Merged into cifs-2.6.git

-- 
Thanks,

Steve
