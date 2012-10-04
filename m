From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: cifs_readv_callback and smb2_readv_callback are very similar and
 I would like to merge them ...
Date: Thu, 4 Oct 2012 12:11:23 +0400
Message-ID: <CAKywueRMGFGqktswxTmYoqDPWwV+O+vYMJ-q_5Hxaejy-SsyMg@mail.gmail.com>
References: <CACyXjPzbmK309pj6FR_JgqDyKPFQV5zPqaL7uj1XVTaMMz+P6w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPzbmK309pj6FR_JgqDyKPFQV5zPqaL7uj1XVTaMMz+P6w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/10/4 Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Hi folks,
>
> I want to simplify the read path as the first part of the changes I
> would like to perform to introduce multi-channel support.
>
> One impediment is that we have two functions, cifs_readv_callback and
> smb2_readv_callback that are very similar. The following shows how
> similar:
>
> @@ -1,9 +1,11 @@
>  static void
> -cifs_readv_callback(struct mid_q_entry *mid)
> +smb2_readv_callback(struct mid_q_entry *mid)
>  {
>         struct cifs_readdata *rdata = mid->callback_data;
>         struct cifs_tcon *tcon = tlink_tcon(rdata->cfile->tlink);
>         struct TCP_Server_Info *server = tcon->ses->server;
> +       struct smb2_hdr *buf = (struct smb2_hdr *)rdata->iov.iov_base;
> +       unsigned int credits_received = 1;
>         struct smb_rqst rqst = { .rq_iov = &rdata->iov,
>                                  .rq_nvec = 1,
>                                  .rq_pages = rdata->pages,
> @@ -16,13 +18,13 @@
>
>         switch (mid->mid_state) {
>         case MID_RESPONSE_RECEIVED:
> +               credits_received = le16_to_cpu(buf->CreditRequest);
>                 /* result already set, check signature */
>                 if (server->sec_mode &
>                     (SECMODE_SIGN_REQUIRED | SECMODE_SIGN_ENABLED)) {
> -                       int rc = 0;
> +                       int rc;
>
> -                       rc = cifs_verify_signature(&rqst, server,
> -                                                 mid->sequence_number + 1);
> +                       rc = smb2_verify_signature(&rqst, server);
>                         if (rc)
>                                 cERROR(1, "SMB signature verification returned "
>                                        "error = %d", rc);
> @@ -36,10 +38,14 @@
>                 rdata->result = -EAGAIN;
>                 break;
>         default:
> -               rdata->result = -EIO;
> +               if (rdata->result != -ENODATA)
> +                       rdata->result = -EIO;
>         }
>
> +       if (rdata->result)
> +               cifs_stats_fail_inc(tcon, SMB2_READ_HE);
> +
>         queue_work(cifsiod_wq, &rdata->work);
>         DeleteMidQEntry(mid);
> -       add_credits(server, 1, 0);
> +       add_credits(server, credits_received, 0);
>  }
>
> So, we start off with a seemingly unused variable, struct smb2_hdr
> *buf in smb2_readv_callback.
>
> Then we have unsigned int credits_received in one and not the other.
> We always assume a credit received of 1 in cifs_readv_callback. We
> could unify these by:
>
> 1. declaring credits received in cifs_readv_callback and then
> 2. calling a protocol-specific credit-extraction routine, ie
> server->ops->hdr_get_credits(buf) or something like that. The
> CIFS/SMB1 hdr_get_credits function could simply return 1 every time.
>
> Then we have different signature verification routines, but that is
> caused by the fact that the signature algorithms are different, with
> the message sequence number being passed in by client/server rather
> than being in the header. However, this again can be handled by having
> a protocol-specific signature algorithm (which we will likely need for
> SMB3.0 anyway because it uses a different hashing algorithm) and
> passing in the extra info regardless of whether it is needed. The
> extra info we pass in could be the MID pointer.
>
> We are almost done. There appears to be a little reorganization of the
> code occurring there, and some stats collection in SMB2 that is not in
> CIFS by the look of things, but we can fix that.
>
> So, does anyone have any objections to me doing this?

Agree with your points - no objections from my side.

-- 
Best regards,
Pavel Shilovsky.
