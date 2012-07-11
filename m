From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2] Initialise mid_q_entry before putting it on the
 pending queue
Date: Wed, 11 Jul 2012 07:04:27 -0500
Message-ID: <CADT32eKUiSjsop=jNnMDq1KkO5CFG8=wW-X=UXQ1itPrbiToVQ@mail.gmail.com>
References: <1342006085-5816-1-git-send-email-sprabhu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342006085-5816-1-git-send-email-sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 11, 2012 at 6:28 AM, Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> A user reported a crash in cifs_demultiplex_thread() caused by an
> incorrectly set mid_q_entry->callback() function. It appears that the
> callback assignment made in cifs_call_async() was not flushed back to
> memory suggesting that a memory barrier was required here. Changing the
> code to make sure that the mid_q_entry structure was completely
> initialised before it was added to the pending queue fixes the problem.
>
> Signed-off-by: Sachin Prabhu <sprabhu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  fs/cifs/transport.c |   26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
>
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 3097ee5..f25d4ea 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -365,16 +365,14 @@ cifs_setup_async_request(struct TCP_Server_Info *server, struct kvec *iov,
>         if (mid == NULL)
>                 return -ENOMEM;
>
> -       /* put it on the pending_mid_q */
> -       spin_lock(&GlobalMid_Lock);
> -       list_add_tail(&mid->qhead, &server->pending_mid_q);
> -       spin_unlock(&GlobalMid_Lock);
> -
>         rc = cifs_sign_smb2(iov, nvec, server, &mid->sequence_number);
> -       if (rc)
> -               delete_mid(mid);
> +       if (rc) {
> +               DeleteMidQEntry(mid);
> +               return rc;
> +       }
> +
>         *ret_mid = mid;
> -       return rc;
> +       return 0;
>  }
>
>  /*
> @@ -407,17 +405,21 @@ cifs_call_async(struct TCP_Server_Info *server, struct kvec *iov,
>         mid->callback_data = cbdata;
>         mid->mid_state = MID_REQUEST_SUBMITTED;
>
> +       /* put it on the pending_mid_q */
> +       spin_lock(&GlobalMid_Lock);
> +       list_add_tail(&mid->qhead, &server->pending_mid_q);
> +       spin_unlock(&GlobalMid_Lock);
> +
> +
>         cifs_in_send_inc(server);
>         rc = smb_sendv(server, iov, nvec);
>         cifs_in_send_dec(server);
>         cifs_save_when_sent(mid);
>         mutex_unlock(&server->srv_mutex);
>
> -       if (rc)
> -               goto out_err;
> +       if (rc == 0)
> +               return 0;
>
> -       return rc;
> -out_err:
>         delete_mid(mid);
>         add_credits(server, 1);
>         wake_up(&server->request_q);
> --
> 1.7.10.4
>

Looks correct.

Reviewed-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
