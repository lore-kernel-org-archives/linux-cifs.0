Return-Path: <SRS0=SV7R=YL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA7B7CA9EA9
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 21:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C91921925
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 21:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbfJRVpB convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:45:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42436 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439420AbfJRVpB (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Oct 2019 17:45:01 -0400
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3563A882F5
        for <linux-cifs@vger.kernel.org>; Fri, 18 Oct 2019 21:45:00 +0000 (UTC)
Received: by mail-qt1-f199.google.com with SMTP id k53so7282625qtk.0
        for <linux-cifs@vger.kernel.org>; Fri, 18 Oct 2019 14:45:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AGzsJjxMBuF8PFVpMypd9ZQwMma+Jg04RN90rz/D+UE=;
        b=j6hZO5oXczoj+M6Bu3gJDZrALnIjyGMhMG9JCLXMhD+sh5HSFi98k4PILr3TtTyYYq
         XkvKEwaVcwj4IiZpVFRF2SGWW363y4kcervLexfo8es5aTP5HV6iMLQhc/w3tEWGbQ1f
         HaoT9XvCbb5mhejr6tkhpr9Zt6WnGAjT+91uEjJbk96vdnAi9MKUo9IAT1PqAN5M9T3Q
         +ToJpP8m6UBPzlahVoAPjexRhc/pPw/1SXSbRXf77K9eDHc2LpjNmyGTUsG8F98MuPu+
         poRsP3svhHgZ35S84AJmCQCR8rwCrOmk6/SqbzNSQ8g1ciGw4Rc72a8lPh+IRlFWW/gC
         J2Xw==
X-Gm-Message-State: APjAAAWcFhSkOOTXG+EufP7xdsm9Ew52k545l3dvAOwk6yJq4f0OjmCD
        W1csiXgT0ftZAEJtErufVKX8yXwYcnOmcWBlHU95VOJtjIZ9Jr0FhRcD894joVurxIg+EmtZKzj
        Nho4e3+FF/JoULx2P1S3bKUKFPuK1PBPL4g1sqw==
X-Received: by 2002:ac8:3f64:: with SMTP id w33mr12121556qtk.191.1571435099463;
        Fri, 18 Oct 2019 14:44:59 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyimClV1Lz1M2rQw4CYnNqhXVCeakalTikzl+yvHKFkngPVeAGZ4NityytqmXihRTAMlceMSUjAUSefODAFTdA=
X-Received: by 2002:ac8:3f64:: with SMTP id w33mr12121536qtk.191.1571435099059;
 Fri, 18 Oct 2019 14:44:59 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
 <CALF+zOn-J9KyDDTL6dJ23RbQ9Gh+V3ti+4-O051zqOur6Fv-PA@mail.gmail.com>
 <1884745525.7250940.1571390858862.JavaMail.zimbra@redhat.com>
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com>
 <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
In-Reply-To: <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Fri, 18 Oct 2019 17:44:23 -0400
Message-ID: <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 18, 2019 at 5:21 PM David Wysochanski <dwysocha@redhat.com> wrote:
>
> On Fri, Oct 18, 2019 at 4:59 PM Pavel Shilovskiy <pshilov@microsoft.com> wrote:
> >
> > Thanks for the good news that the patch is stable in your workload!
> >
> The attached patch I ran on top of 5.4-rc3 for over 5 hrs today on the
> reboot test - before it would crash after a few minutes tops.
>
> > The extra flag may not be necessary and we may rely on a MID state but we would need to handle two states actually: MID_RETRY_NEEDED and MID_SHUTDOWN - see clean_demultiplex_info() which is doing the same things with mid as cifs_reconnect(). Please add ref counting to both functions since they both can race with system call threads.
> >

I agree that loop has the same problem.  I can add that you're ok with
the mid_state approach.  I think the only other option is probably a
flag like Ronnie suggested.
I will have to review the state machine more when I am more alert if
you are concerned about possible subtle regressions.

> > I also think that we need to create as smaller patch as possible to avoid hidden regressions. That's why I don't think we should change IF() to WARN_ON() in the same patch and keep  it separately without the stable tag.
> >
> IMO that 'if' statement is wrong, and should be removed unless it can
> be defended.  Why are we _conditionally_ setting the state to
> MID_RETRY_NEEDED in the same loop as we're putting mids on retry_list?
>  What's the state machine supposed to be doing if it's ambiguous?
>
> > Another general thought is that including extra logic into the MID state may complicate the code. Having a flag like MID_QUEUED would reflect the meaning more straightforward: if mis is queued then de-queue it (aka remove it from the list), else - skip this step. This may be changed later if you think this will complicate the small stable patch.
> >
>
> You all know better than me.  I'll take another look next week and
> look forward to more discussion.
>
> > --
> > Best regards,
> > Pavel Shilovsky
> >
> > -----Original Message-----
> > From: David Wysochanski <dwysocha@redhat.com>
> > Sent: Friday, October 18, 2019 3:12 AM
> > To: Ronnie Sahlberg <lsahlber@redhat.com>
> > Cc: Pavel Shilovskiy <pshilov@microsoft.com>; linux-cifs <linux-cifs@vger.kernel.org>; Frank Sorenson <sorenson@redhat.com>
> > Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect still seen on 5.4-rc3
> >
> > On Fri, Oct 18, 2019 at 5:27 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > >
> > >
> > > ----- Original Message -----
> > > > From: "David Wysochanski" <dwysocha@redhat.com>
> > > > To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> > > > Cc: "Pavel Shilovskiy" <pshilov@microsoft.com>, "linux-cifs" <linux-cifs@vger.kernel.org>, "Frank Sorenson"
> > > > <sorenson@redhat.com>
> > > > Sent: Friday, 18 October, 2019 6:16:45 PM
> > > > Subject: Re: list_del corruption while iterating retry_list in
> > > > cifs_reconnect still seen on 5.4-rc3
> > > >
> > > > On Thu, Oct 17, 2019 at 6:53 PM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
> > > > >
> > > > >
> > > > >
> > > > >
> > >
> > > Good comments.
> > > New version of the patch, please test and see comments inline below
> > >
> > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index
> > > bdea4b3e8005..8a78358693a5 100644
> > > --- a/fs/cifs/connect.c
> > > +++ b/fs/cifs/connect.c
> > > @@ -564,8 +564,13 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > >         spin_lock(&GlobalMid_Lock);
> > >         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> > >                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > > -               if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
> > > -                       mid_entry->mid_state = MID_RETRY_NEEDED;
> > > +               kref_get(&mid_entry->refcount);
> > > +               WARN_ON(mid_entry->mid_state != MID_REQUEST_SUBMITTED);
> > > +               /*
> > > +                * Set MID_RETRY_NEEDED to prevent the demultiplex loop from
> > > +                * removing us, or our neighbours, from the linked list.
> > > +                */
> > > +               mid_entry->mid_state = MID_RETRY_NEEDED;
> > >                 list_move(&mid_entry->qhead, &retry_list);
> > >         }
> > >         spin_unlock(&GlobalMid_Lock);
> > > @@ -575,7 +580,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > >         list_for_each_safe(tmp, tmp2, &retry_list) {
> > >                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > >                 list_del_init(&mid_entry->qhead);
> > > +
> > >                 mid_entry->callback(mid_entry);
> > > +               cifs_mid_q_entry_release(mid_entry);
> > >         }
> > >
> > >         if (cifs_rdma_enabled(server)) { @@ -895,7 +902,7 @@
> > > dequeue_mid(struct mid_q_entry *mid, bool malformed)
> > >         if (mid->mid_flags & MID_DELETED)
> > >                 printk_once(KERN_WARNING
> > >                             "trying to dequeue a deleted mid\n");
> > > -       else
> > > +       else if (mid->mid_state != MID_RETRY_NEEDED)
> >
> > I'm just using an 'if' here not 'else if'.  Do you see any issue with that?
> >
> > Actually this section needed a little of reorganizing due to the setting of the mid_state.  So I have this now for this hunk:
> >
> >         mid->when_received = jiffies;
> >  #endif
> >         spin_lock(&GlobalMid_Lock);
> > -       if (!malformed)
> > -               mid->mid_state = MID_RESPONSE_RECEIVED;
> > -       else
> > -               mid->mid_state = MID_RESPONSE_MALFORMED;
> >         /*
> >          * Trying to handle/dequeue a mid after the send_recv()
> >          * function has finished processing it is a bug.
> > @@ -895,8 +893,14 @@ static inline int reconn_setup_dfs_targets(struct cifs_sb_info *cifs_sb,
> >         if (mid->mid_flags & MID_DELETED)
> >                 printk_once(KERN_WARNING
> >                             "trying to dequeue a deleted mid\n");
> > -       else
> > +       if (mid->mid_state != MID_RETRY_NEEDED)
> >                 list_del_init(&mid->qhead);
> > +
> > +       if (!malformed)
> > +               mid->mid_state = MID_RESPONSE_RECEIVED;
> > +       else
> > +               mid->mid_state = MID_RESPONSE_MALFORMED;
> > +
> >         spin_unlock(&GlobalMid_Lock);
> >  }
> >
> >
> >
> > >                 list_del_init(&mid->qhead);
> > >         spin_unlock(&GlobalMid_Lock);
> > >  }
> > > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c index
> > > 308ad0f495e1..17a430b58673 100644
> > > --- a/fs/cifs/transport.c
> > > +++ b/fs/cifs/transport.c
> > > @@ -173,7 +173,8 @@ void
> > >  cifs_delete_mid(struct mid_q_entry *mid)  {
> > >         spin_lock(&GlobalMid_Lock);
> > > -       list_del_init(&mid->qhead);
> > > +       if (mid->mid_state != MID_RETRY_NEEDED)
> > > +               list_del_init(&mid->qhead);
> > >         mid->mid_flags |= MID_DELETED;
> > >         spin_unlock(&GlobalMid_Lock);
> > >
> > > @@ -872,7 +873,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
> > >                 rc = -EHOSTDOWN;
> > >                 break;
> > >         default:
> > > -               list_del_init(&mid->qhead);
> > > +               if (mid->mid_state != MID_RETRY_NEEDED)
> > > +                       list_del_init(&mid->qhead);
> > >                 cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
> > >                          __func__, mid->mid, mid->mid_state);
> > >                 rc = -EIO;
> > >
> > >
> > >
> > >
> > >
> > >
> > > > >
> > > > > ----- Original Message -----
> > > > > > From: "Pavel Shilovskiy" <pshilov@microsoft.com>
> > > > > > To: "Ronnie Sahlberg" <lsahlber@redhat.com>, "David Wysochanski"
> > > > > > <dwysocha@redhat.com>
> > > > > > Cc: "linux-cifs" <linux-cifs@vger.kernel.org>, "Frank Sorenson"
> > > > > > <sorenson@redhat.com>
> > > > > > Sent: Friday, 18 October, 2019 8:02:23 AM
> > > > > > Subject: RE: list_del corruption while iterating retry_list in
> > > > > > cifs_reconnect still seen on 5.4-rc3
> > > > > >
> > > > > > Ok, looking at cifs_delete_mid():
> > > > > >
> > > > > >  172 void
> > > > > >  173 cifs_delete_mid(struct mid_q_entry *mid)
> > > > > >  174 {
> > > > > >  175 >-------spin_lock(&GlobalMid_Lock);
> > > > > >  176 >-------list_del_init(&mid->qhead);
> > > > > >  177 >-------mid->mid_flags |= MID_DELETED;
> > > > > >  178 >-------spin_unlock(&GlobalMid_Lock);
> > > > > >  179
> > > > > >  180 >-------DeleteMidQEntry(mid);
> > > > > >  181 }
> > > > > >
> > > > > > So, regardless of us taking references on the mid itself or not,
> > > > > > the mid might be removed from the list. I also don't think
> > > > > > taking GlobalMid_Lock would help much because the next mid in
> > > > > > the list might be deleted from the list by another process while
> > > > > > cifs_reconnect is calling callback for the current mid.
> > > > > >
> > > >
> > > > Yes the above is consistent with my tracing the crash after the first
> > > > initial refcount patch was applied.
> > > > After the simple refcount patch, when iterating the retry_loop, it was
> > > > processing an orphaned list with a single item over and over and
> > > > eventually ran itself down to refcount == 0 and crashed like before.
> > > >
> > > >
> > > > > > Instead, shouldn't we try marking the mid as being reconnected? Once we
> > > > > > took
> > > > > > a reference, let's mark mid->mid_flags with a new flag MID_RECONNECT
> > > > > > under
> > > > > > the GlobalMid_Lock. Then modify cifs_delete_mid() to check for this flag
> > > > > > and
> > > > > > do not remove the mid from the list if the flag exists.
> > > > >
> > > > > That could work. But then we should also use that flag to suppress the
> > > > > other places where we do a list_del*, so something like this ?
> > > > >
> > > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > > index 50dfd9049370..b324fff33e53 100644
> > > > > --- a/fs/cifs/cifsglob.h
> > > > > +++ b/fs/cifs/cifsglob.h
> > > > > @@ -1702,6 +1702,7 @@ static inline bool is_retryable_error(int error)
> > > > >  /* Flags */
> > > > >  #define   MID_WAIT_CANCELLED    1 /* Cancelled while waiting for response
> > > > >  */
> > > > >  #define   MID_DELETED            2 /* Mid has been dequeued/deleted */
> > > > > +#define   MID_RECONNECT          4 /* Mid is being used during reconnect
> > > > > */
> > > > >
> > > > Do we need this extra flag?  Can just use  mid_state ==
> > > > MID_RETRY_NEEDED in the necessary places?
> > >
> > > That is a good point.
> > > It saves us a redundant flag.
> > >
> > > >
> > > >
> > > > >  /* Types of response buffer returned from SendReceive2 */
> > > > >  #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
> > > > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > > > index bdea4b3e8005..b142bd2a3ef5 100644
> > > > > --- a/fs/cifs/connect.c
> > > > > +++ b/fs/cifs/connect.c
> > > > > @@ -564,6 +564,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > > > >         spin_lock(&GlobalMid_Lock);
> > > > >         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> > > > >                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > > > > +               kref_get(&mid_entry->refcount);
> > > > > +               mid_entry->mid_flags |= MID_RECONNECT;
> > > > >                 if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
> > > > >                         mid_entry->mid_state = MID_RETRY_NEEDED;
> > > >
> > > > What happens if the state is wrong going in there, and it is not set
> > > > to MID_RETRY_NEEDED, but yet we queue up the retry_list and run it
> > > > below?
> > > > Should the above 'if' check for MID_REQUEST_SUBMITTED be a WARN_ON
> > > > followed by unconditionally setting the state?
> > > >
> > > > WARN_ON(mid_entry->mid_state != MID_REQUEST_SUBMITTED);
> > > > /* Unconditionally set MID_RETRY_NEEDED */
> > > > mid_etnry->mid_state = MID_RETRY_NEEDED;
> > >
> > > Yepp.
> > >
> > > >
> > > >
> > > > >                 list_move(&mid_entry->qhead, &retry_list);
> > > > > @@ -575,7 +577,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > > > >         list_for_each_safe(tmp, tmp2, &retry_list) {
> > > > >                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> > > > >                 list_del_init(&mid_entry->qhead);
> > > > > +
> > > > >                 mid_entry->callback(mid_entry);
> > > > > +               cifs_mid_q_entry_release(mid_entry);
> > > > >         }
> > > > >
> > > > >         if (cifs_rdma_enabled(server)) {
> > > > > @@ -895,7 +899,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
> > > > >         if (mid->mid_flags & MID_DELETED)
> > > > >                 printk_once(KERN_WARNING
> > > > >                             "trying to dequeue a deleted mid\n");
> > > > > -       else
> > > > > +       else if (!(mid->mid_flags & MID_RECONNECT))
> > > >
> > > > Instead of the above,
> > > >
> > > >  -       else
> > > > +          else if (mid_entry->mid_state == MID_RETRY_NEEDED)
> > >
> > > Yes, but mid_state != MID_RETRY_NEEDED
> > >
> >
> > Yeah good catch on that - somehow I reversed the logic, and when I
> > tested the former it blew up spectacularly almost instantaenously!
> > Doh!
> >
> > So far the latest patch has been running for about 25 minutes, which
> > is I think the longest this test has survived.
> > I need a bit more runtime to be sure it's good, but if it keeps going
> > I'll plan to create a patch header and submit to list by end of today.
> > Thanks Ronnie and Pavel for the help tracking this down.
> >
> >
> >
> >
> >
> >
