From: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Initialise mid_q_entry before putting it on the pending
 queue
Date: Wed, 11 Jul 2012 11:31:03 +0100
Message-ID: <1342002663.4041.1.camel@localhost>
References: <1341946720-4980-1-git-send-email-sprabhu@redhat.com>
	 <CADT32e+C2GzUMYizadxnp4Qv=22FO6mihq5fJWu80r_kp0+Bvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADT32e+C2GzUMYizadxnp4Qv=22FO6mihq5fJWu80r_kp0+Bvg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, 2012-07-10 at 14:26 -0500, Shirish Pargaonkar wrote:
> On Tue, Jul 10, 2012 at 1:58 PM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > A user reported a crash in cifs_demultiplex_thread() caused by an
> > incorrectly set mid_q_entry->callback() function. It appears that the
> > callback assignment made in cifs_call_async() was not flushed back to
> > memory suggesting that a memory barrier was required here. Changing the
> > code to make sure that the mid_q_entry structure was completely
> > initialised before it was added to the pending queue fixes the problem.
> >
> > Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  fs/cifs/transport.c |   20 ++++++++++----------
> >  1 file changed, 10 insertions(+), 10 deletions(-)
> >
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> > index 3097ee5..c5faf02 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -365,14 +365,10 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
> >         if (mid == NULL)
> >                 return -ENOMEM;
> >
> > -       /* put it on the pending_mid_q */
> > -       spin_lock(&GlobalMid_Lock);
> > -       list_add_tail(&mid->qhead, &server->pending_mid_q);
> > -       spin_unlock(&GlobalMid_Lock);
> > -
> >         rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
> >         if (rc)
> > -               delete_mid(mid);
> > +               DeleteMidQEntry(mid);
> > +
> >         *ret_mid = mid;
> 
> Looks correct.  But just a thought, why bother assigning ret_mid
> a Deleted mid if rc is not null?

I did notice this line which was already set to do this when I wrote the
patch. Since it did not result in any error, I left it alone. I will
create another patch which cleans this bit of the code.

Sachin Prabhu
> 
> >         return rc;
> >  }
> > @@ -407,17 +403,21 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
> >         mid->callback_data = cbdata;
> >         mid->mid_state = MID_REQUEST_SUBMITTED;
> >
> > +       /* put it on the pending_mid_q */
> > +       spin_lock(&GlobalMid_Lock);
> > +       list_add_tail(&mid->qhead, &server->pending_mid_q);
> > +       spin_unlock(&GlobalMid_Lock);
> > +
> > +
> >         cifs_in_send_inc(server);
> >         rc = smb_sendv(server, iov, nvec);
> >         cifs_in_send_dec(server);
> >         cifs_save_when_sent(mid);
> >         mutex_unlock(&server->srv_mutex);
> >
> > -       if (rc)
> > -               goto out_err;
> > +       if (rc == 0)
> > +               return 0;
> >
> > -       return rc;
> > -out_err:
> >         delete_mid(mid);
> >         add_credits(server, 1);
> >         wake_up(&server->request_q);
> > --
> > 1.7.10.4
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
