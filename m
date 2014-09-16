From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: [PATCH 3/7] cifs: No need to send SIGKILL to demux_thread during umount
Date: Tue, 16 Sep 2014 13:47:38 -0500
Message-ID: <CAH2r5msipN2BQCggkd6Fmi345LO1OxRYwJVjNB1j64T35VCDDQ@mail.gmail.com>
References: <003601cfbc62$fe88d170$fb9a7450$@samsung.com> <20140821073846.660b718a@tlielax.poochiereds.net>
 <CAH2r5mviz=Js_rOQ0LJ2eB5fK=D8RB3hyEcyg7MAMukz07y2BQ@mail.gmail.com>
 <004101cfd186$33aa37d0$9afea770$@samsung.com> <CAH2r5mtt0Y8nDSxsv+DXaG8WdtzOT==-fH_fnNTSqEp8HJ8TyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mtt0Y8nDSxsv+DXaG8WdtzOT==-fH_fnNTSqEp8HJ8TyQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

cc list


---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Tue, Sep 16, 2014 at 1:46 PM
Subject: Re: [PATCH 3/7] cifs: No need to send SIGKILL to demux_thread
during umount
To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Cc: Jeff Layton <jlayton-vpEMnDpepFuMZCB2o+C8xQ@public.gmane.org>, Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


reverted in cifs-2.6.git

On Tue, Sep 16, 2014 at 3:14 AM, Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>> I think this patch may be slowing down the ability to do rmmod after
>> cifs umount (have to wait about 10-20 seconds) since it thinks the
>> cifs module is in use longer now
> Hi Steve,
>
> your concern is correct, rmmod time is increased from 1 second to 7 seconds.
> The reason is why thread is sleeping interruptible in interuptibble state,
> signal delivering wakes up the thread early otherwise it is wake up after
> 7 seconds after timeout expires..
>
> Sorry, Could you revert this patch ?
>
> Thanks.
>
>>
>>
>> ---------- Forwarded message ----------
>> From: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> Date: Thu, Aug 21, 2014 at 4:38 AM
>> Subject: Re: [PATCH 3/7] cifs: No need to send SIGKILL to demux_thread
>> during umount
>> To: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shirish Pargaonkar
>> <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
>> linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>>
>>
>> On Wed, 20 Aug 2014 19:39:17 +0900
>> Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org> wrote:
>>
>> > There is no need to explicitly send SIGKILL to cifs_demultiplex_thread
>> > as it is calling module_put_and_exit to exit cleanly.
>> >
>> > socket sk_rcvtimeo is set to 7 HZ so the thread will wake up in 7 seconds and
>> > clean itself.
>> >
>> > Signed-off-by: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> > Signed-off-by: Ashish Sangwan <a.sangwan-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> > ---
>> >  fs/cifs/connect.c |   19 -------------------
>> >  1 files changed, 0 insertions(+), 19 deletions(-)
>> >
>> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
>> > index 03ed8a0..b4b6d10 100644
>> > --- a/fs/cifs/connect.c
>> > +++ b/fs/cifs/connect.c
>> > @@ -837,7 +837,6 @@ cifs_demultiplex_thread(void *p)
>> >       struct TCP_Server_Info *server = p;
>> >       unsigned int pdu_length;
>> >       char *buf = NULL;
>> > -     struct task_struct *task_to_wake = NULL;
>> >       struct mid_q_entry *mid_entry;
>> >
>> >       current->flags |= PF_MEMALLOC;
>> > @@ -928,19 +927,7 @@ cifs_demultiplex_thread(void *p)
>> >       if (server->smallbuf) /* no sense logging a debug message if NULL */
>> >               cifs_small_buf_release(server->smallbuf);
>> >
>> > -     task_to_wake = xchg(&server->tsk, NULL);
>> >       clean_demultiplex_info(server);
>> > -
>> > -     /* if server->tsk was NULL then wait for a signal before exiting */
>> > -     if (!task_to_wake) {
>> > -             set_current_state(TASK_INTERRUPTIBLE);
>> > -             while (!signal_pending(current)) {
>> > -                     schedule();
>> > -                     set_current_state(TASK_INTERRUPTIBLE);
>> > -             }
>> > -             set_current_state(TASK_RUNNING);
>> > -     }
>> > -
>> >       module_put_and_exit(0);
>> >  }
>> >
>> > @@ -2061,8 +2048,6 @@ cifs_find_tcp_session(struct smb_vol *vol)
>> >  static void
>> >  cifs_put_tcp_session(struct TCP_Server_Info *server)
>> >  {
>> > -     struct task_struct *task;
>> > -
>> >       spin_lock(&cifs_tcp_ses_lock);
>> >       if (--server->srv_count > 0) {
>> >               spin_unlock(&cifs_tcp_ses_lock);
>> > @@ -2086,10 +2071,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server)
>> >       kfree(server->session_key.response);
>> >       server->session_key.response = NULL;
>> >       server->session_key.len = 0;
>> > -
>> > -     task = xchg(&server->tsk, NULL);
>> > -     if (task)
>> > -             force_sig(SIGKILL, task);
>> >  }
>> >
>> >  static struct TCP_Server_Info *
>>
>> Looks fine, I think. That code is a leftover from when we used a
>> different scheme to take down the kthread and I don't think it's
>> necessary any longer.
>>
>> Acked-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>>
>>
>> --
>> Thanks,
>>
>> Steve
>



--
Thanks,

Steve


-- 
Thanks,

Steve
