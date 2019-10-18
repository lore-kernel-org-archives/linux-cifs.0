Return-Path: <SRS0=SV7R=YL=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A99ECA9EA9
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 21:21:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FC2920679
	for <linux-cifs@archiver.kernel.org>; Fri, 18 Oct 2019 21:21:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394433AbfJRVVx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:21:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36802 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394432AbfJRVVw (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 18 Oct 2019 17:21:52 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DED3C2BFDC
        for <linux-cifs@vger.kernel.org>; Fri, 18 Oct 2019 21:21:51 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id x77so6826589qka.11
        for <linux-cifs@vger.kernel.org>; Fri, 18 Oct 2019 14:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5tb9jxuXVGGIS3/lcKHq+1id9U+Gnref9WVAnzQeRPI=;
        b=U5BBk2dFvgvg8LmjAR+ey2924hctu+OUWvJVDnkf2439RdkTiLhchEux0o2Yi89BTe
         09ZlqAPonUTrClZbpxpIMna6usHuhgo8ovWl3l+VzDf3BxBLqPKSK5XkMfzK/G+O3sjp
         IxH5GSFuLpTXDjPV3+5YmyY/+osFdNHVA0MoXvhaTBWY5YJCyQc6Tj5hCdcibbhEFEbV
         wToszdboisYMijOlCqZKo5kxuWLIoq1W+JUv7+vhx60mcHabHxPRE9QaLJsZKwUOmunu
         5YlDCx05Scw0Hdhp6kR7OWmIBENFPi+UuK+d83/uJPfKdl4PRCz7hQ4uSegSdEt5HyZ/
         KSLQ==
X-Gm-Message-State: APjAAAXabt3IJm0lTRmlikA1PFwJnpE578T6U6b9BCqj/mXCyjwqJdGN
        rwN5Zqt41/YVurMAwTicZlKc7IS64hjGbB8s3bCJ+Hu72xroK6w20CsZ+C8GYiyu6nzWQfwa3i/
        Wa7Nly8+tRsWjWEetHHdo4/tK0s4iSX4W0ANblQ==
X-Received: by 2002:ac8:4410:: with SMTP id j16mr11957129qtn.389.1571433711116;
        Fri, 18 Oct 2019 14:21:51 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzSSfhbkW77ojyWePpi4Hmx+pur7yCSC649KuAJWf/6gdT1Rfuy8VlI8+1FPttWzwjW5WOWitCl9oIQms5MNnw=
X-Received: by 2002:ac8:4410:: with SMTP id j16mr11957102qtn.389.1571433710708;
 Fri, 18 Oct 2019 14:21:50 -0700 (PDT)
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
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com> <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Fri, 18 Oct 2019 17:21:13 -0400
Message-ID: <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: multipart/mixed; boundary="0000000000001dd78a059535ec60"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

--0000000000001dd78a059535ec60
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2019 at 4:59 PM Pavel Shilovskiy <pshilov@microsoft.com> wr=
ote:
>
> Thanks for the good news that the patch is stable in your workload!
>
The attached patch I ran on top of 5.4-rc3 for over 5 hrs today on the
reboot test - before it would crash after a few minutes tops.

> The extra flag may not be necessary and we may rely on a MID state but we=
 would need to handle two states actually: MID_RETRY_NEEDED and MID_SHUTDOW=
N - see clean_demultiplex_info() which is doing the same things with mid as=
 cifs_reconnect(). Please add ref counting to both functions since they bot=
h can race with system call threads.
>
> I also think that we need to create as smaller patch as possible to avoid=
 hidden regressions. That's why I don't think we should change IF() to WARN=
_ON() in the same patch and keep  it separately without the stable tag.
>
IMO that 'if' statement is wrong, and should be removed unless it can
be defended.  Why are we _conditionally_ setting the state to
MID_RETRY_NEEDED in the same loop as we're putting mids on retry_list?
 What's the state machine supposed to be doing if it's ambiguous?

> Another general thought is that including extra logic into the MID state =
may complicate the code. Having a flag like MID_QUEUED would reflect the me=
aning more straightforward: if mis is queued then de-queue it (aka remove i=
t from the list), else - skip this step. This may be changed later if you t=
hink this will complicate the small stable patch.
>

You all know better than me.  I'll take another look next week and
look forward to more discussion.

> --
> Best regards,
> Pavel Shilovsky
>
> -----Original Message-----
> From: David Wysochanski <dwysocha@redhat.com>
> Sent: Friday, October 18, 2019 3:12 AM
> To: Ronnie Sahlberg <lsahlber@redhat.com>
> Cc: Pavel Shilovskiy <pshilov@microsoft.com>; linux-cifs <linux-cifs@vger=
.kernel.org>; Frank Sorenson <sorenson@redhat.com>
> Subject: Re: list_del corruption while iterating retry_list in cifs_recon=
nect still seen on 5.4-rc3
>
> On Fri, Oct 18, 2019 at 5:27 AM Ronnie Sahlberg <lsahlber@redhat.com> wro=
te:
> >
> >
> > ----- Original Message -----
> > > From: "David Wysochanski" <dwysocha@redhat.com>
> > > To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> > > Cc: "Pavel Shilovskiy" <pshilov@microsoft.com>, "linux-cifs" <linux-c=
ifs@vger.kernel.org>, "Frank Sorenson"
> > > <sorenson@redhat.com>
> > > Sent: Friday, 18 October, 2019 6:16:45 PM
> > > Subject: Re: list_del corruption while iterating retry_list in
> > > cifs_reconnect still seen on 5.4-rc3
> > >
> > > On Thu, Oct 17, 2019 at 6:53 PM Ronnie Sahlberg <lsahlber@redhat.com>=
 wrote:
> > > >
> > > >
> > > >
> > > >
> >
> > Good comments.
> > New version of the patch, please test and see comments inline below
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index
> > bdea4b3e8005..8a78358693a5 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -564,8 +564,13 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >         spin_lock(&GlobalMid_Lock);
> >         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> >                 mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead=
);
> > -               if (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITTED)
> > -                       mid_entry->mid_state =3D MID_RETRY_NEEDED;
> > +               kref_get(&mid_entry->refcount);
> > +               WARN_ON(mid_entry->mid_state !=3D MID_REQUEST_SUBMITTED=
);
> > +               /*
> > +                * Set MID_RETRY_NEEDED to prevent the demultiplex loop=
 from
> > +                * removing us, or our neighbours, from the linked list=
.
> > +                */
> > +               mid_entry->mid_state =3D MID_RETRY_NEEDED;
> >                 list_move(&mid_entry->qhead, &retry_list);
> >         }
> >         spin_unlock(&GlobalMid_Lock);
> > @@ -575,7 +580,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> >         list_for_each_safe(tmp, tmp2, &retry_list) {
> >                 mid_entry =3D list_entry(tmp, struct mid_q_entry, qhead=
);
> >                 list_del_init(&mid_entry->qhead);
> > +
> >                 mid_entry->callback(mid_entry);
> > +               cifs_mid_q_entry_release(mid_entry);
> >         }
> >
> >         if (cifs_rdma_enabled(server)) { @@ -895,7 +902,7 @@
> > dequeue_mid(struct mid_q_entry *mid, bool malformed)
> >         if (mid->mid_flags & MID_DELETED)
> >                 printk_once(KERN_WARNING
> >                             "trying to dequeue a deleted mid\n");
> > -       else
> > +       else if (mid->mid_state !=3D MID_RETRY_NEEDED)
>
> I'm just using an 'if' here not 'else if'.  Do you see any issue with tha=
t?
>
> Actually this section needed a little of reorganizing due to the setting =
of the mid_state.  So I have this now for this hunk:
>
>         mid->when_received =3D jiffies;
>  #endif
>         spin_lock(&GlobalMid_Lock);
> -       if (!malformed)
> -               mid->mid_state =3D MID_RESPONSE_RECEIVED;
> -       else
> -               mid->mid_state =3D MID_RESPONSE_MALFORMED;
>         /*
>          * Trying to handle/dequeue a mid after the send_recv()
>          * function has finished processing it is a bug.
> @@ -895,8 +893,14 @@ static inline int reconn_setup_dfs_targets(struct ci=
fs_sb_info *cifs_sb,
>         if (mid->mid_flags & MID_DELETED)
>                 printk_once(KERN_WARNING
>                             "trying to dequeue a deleted mid\n");
> -       else
> +       if (mid->mid_state !=3D MID_RETRY_NEEDED)
>                 list_del_init(&mid->qhead);
> +
> +       if (!malformed)
> +               mid->mid_state =3D MID_RESPONSE_RECEIVED;
> +       else
> +               mid->mid_state =3D MID_RESPONSE_MALFORMED;
> +
>         spin_unlock(&GlobalMid_Lock);
>  }
>
>
>
> >                 list_del_init(&mid->qhead);
> >         spin_unlock(&GlobalMid_Lock);
> >  }
> > diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c index
> > 308ad0f495e1..17a430b58673 100644
> > --- a/fs/cifs/transport.c
> > +++ b/fs/cifs/transport.c
> > @@ -173,7 +173,8 @@ void
> >  cifs_delete_mid(struct mid_q_entry *mid)  {
> >         spin_lock(&GlobalMid_Lock);
> > -       list_del_init(&mid->qhead);
> > +       if (mid->mid_state !=3D MID_RETRY_NEEDED)
> > +               list_del_init(&mid->qhead);
> >         mid->mid_flags |=3D MID_DELETED;
> >         spin_unlock(&GlobalMid_Lock);
> >
> > @@ -872,7 +873,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struc=
t TCP_Server_Info *server)
> >                 rc =3D -EHOSTDOWN;
> >                 break;
> >         default:
> > -               list_del_init(&mid->qhead);
> > +               if (mid->mid_state !=3D MID_RETRY_NEEDED)
> > +                       list_del_init(&mid->qhead);
> >                 cifs_server_dbg(VFS, "%s: invalid mid state mid=3D%llu =
state=3D%d\n",
> >                          __func__, mid->mid, mid->mid_state);
> >                 rc =3D -EIO;
> >
> >
> >
> >
> >
> >
> > > >
> > > > ----- Original Message -----
> > > > > From: "Pavel Shilovskiy" <pshilov@microsoft.com>
> > > > > To: "Ronnie Sahlberg" <lsahlber@redhat.com>, "David Wysochanski"
> > > > > <dwysocha@redhat.com>
> > > > > Cc: "linux-cifs" <linux-cifs@vger.kernel.org>, "Frank Sorenson"
> > > > > <sorenson@redhat.com>
> > > > > Sent: Friday, 18 October, 2019 8:02:23 AM
> > > > > Subject: RE: list_del corruption while iterating retry_list in
> > > > > cifs_reconnect still seen on 5.4-rc3
> > > > >
> > > > > Ok, looking at cifs_delete_mid():
> > > > >
> > > > >  172 void
> > > > >  173 cifs_delete_mid(struct mid_q_entry *mid)
> > > > >  174 {
> > > > >  175 >-------spin_lock(&GlobalMid_Lock);
> > > > >  176 >-------list_del_init(&mid->qhead);
> > > > >  177 >-------mid->mid_flags |=3D MID_DELETED;
> > > > >  178 >-------spin_unlock(&GlobalMid_Lock);
> > > > >  179
> > > > >  180 >-------DeleteMidQEntry(mid);
> > > > >  181 }
> > > > >
> > > > > So, regardless of us taking references on the mid itself or not,
> > > > > the mid might be removed from the list. I also don't think
> > > > > taking GlobalMid_Lock would help much because the next mid in
> > > > > the list might be deleted from the list by another process while
> > > > > cifs_reconnect is calling callback for the current mid.
> > > > >
> > >
> > > Yes the above is consistent with my tracing the crash after the first
> > > initial refcount patch was applied.
> > > After the simple refcount patch, when iterating the retry_loop, it wa=
s
> > > processing an orphaned list with a single item over and over and
> > > eventually ran itself down to refcount =3D=3D 0 and crashed like befo=
re.
> > >
> > >
> > > > > Instead, shouldn't we try marking the mid as being reconnected? O=
nce we
> > > > > took
> > > > > a reference, let's mark mid->mid_flags with a new flag MID_RECONN=
ECT
> > > > > under
> > > > > the GlobalMid_Lock. Then modify cifs_delete_mid() to check for th=
is flag
> > > > > and
> > > > > do not remove the mid from the list if the flag exists.
> > > >
> > > > That could work. But then we should also use that flag to suppress =
the
> > > > other places where we do a list_del*, so something like this ?
> > > >
> > > > diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> > > > index 50dfd9049370..b324fff33e53 100644
> > > > --- a/fs/cifs/cifsglob.h
> > > > +++ b/fs/cifs/cifsglob.h
> > > > @@ -1702,6 +1702,7 @@ static inline bool is_retryable_error(int err=
or)
> > > >  /* Flags */
> > > >  #define   MID_WAIT_CANCELLED    1 /* Cancelled while waiting for r=
esponse
> > > >  */
> > > >  #define   MID_DELETED            2 /* Mid has been dequeued/delete=
d */
> > > > +#define   MID_RECONNECT          4 /* Mid is being used during rec=
onnect
> > > > */
> > > >
> > > Do we need this extra flag?  Can just use  mid_state =3D=3D
> > > MID_RETRY_NEEDED in the necessary places?
> >
> > That is a good point.
> > It saves us a redundant flag.
> >
> > >
> > >
> > > >  /* Types of response buffer returned from SendReceive2 */
> > > >  #define   CIFS_NO_BUFFER        0    /* Response buffer not return=
ed */
> > > > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > > > index bdea4b3e8005..b142bd2a3ef5 100644
> > > > --- a/fs/cifs/connect.c
> > > > +++ b/fs/cifs/connect.c
> > > > @@ -564,6 +564,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > > >         spin_lock(&GlobalMid_Lock);
> > > >         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
> > > >                 mid_entry =3D list_entry(tmp, struct mid_q_entry, q=
head);
> > > > +               kref_get(&mid_entry->refcount);
> > > > +               mid_entry->mid_flags |=3D MID_RECONNECT;
> > > >                 if (mid_entry->mid_state =3D=3D MID_REQUEST_SUBMITT=
ED)
> > > >                         mid_entry->mid_state =3D MID_RETRY_NEEDED;
> > >
> > > What happens if the state is wrong going in there, and it is not set
> > > to MID_RETRY_NEEDED, but yet we queue up the retry_list and run it
> > > below?
> > > Should the above 'if' check for MID_REQUEST_SUBMITTED be a WARN_ON
> > > followed by unconditionally setting the state?
> > >
> > > WARN_ON(mid_entry->mid_state !=3D MID_REQUEST_SUBMITTED);
> > > /* Unconditionally set MID_RETRY_NEEDED */
> > > mid_etnry->mid_state =3D MID_RETRY_NEEDED;
> >
> > Yepp.
> >
> > >
> > >
> > > >                 list_move(&mid_entry->qhead, &retry_list);
> > > > @@ -575,7 +577,9 @@ cifs_reconnect(struct TCP_Server_Info *server)
> > > >         list_for_each_safe(tmp, tmp2, &retry_list) {
> > > >                 mid_entry =3D list_entry(tmp, struct mid_q_entry, q=
head);
> > > >                 list_del_init(&mid_entry->qhead);
> > > > +
> > > >                 mid_entry->callback(mid_entry);
> > > > +               cifs_mid_q_entry_release(mid_entry);
> > > >         }
> > > >
> > > >         if (cifs_rdma_enabled(server)) {
> > > > @@ -895,7 +899,7 @@ dequeue_mid(struct mid_q_entry *mid, bool malfo=
rmed)
> > > >         if (mid->mid_flags & MID_DELETED)
> > > >                 printk_once(KERN_WARNING
> > > >                             "trying to dequeue a deleted mid\n");
> > > > -       else
> > > > +       else if (!(mid->mid_flags & MID_RECONNECT))
> > >
> > > Instead of the above,
> > >
> > >  -       else
> > > +          else if (mid_entry->mid_state =3D=3D MID_RETRY_NEEDED)
> >
> > Yes, but mid_state !=3D MID_RETRY_NEEDED
> >
>
> Yeah good catch on that - somehow I reversed the logic, and when I
> tested the former it blew up spectacularly almost instantaenously!
> Doh!
>
> So far the latest patch has been running for about 25 minutes, which
> is I think the longest this test has survived.
> I need a bit more runtime to be sure it's good, but if it keeps going
> I'll plan to create a patch header and submit to list by end of today.
> Thanks Ronnie and Pavel for the help tracking this down.
>
>
>
>
>
>

--0000000000001dd78a059535ec60
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-cifs-Fix-list_del-corruption-of-retry_list-in-cifs_r.patch"
Content-Disposition: attachment; 
	filename="0001-cifs-Fix-list_del-corruption-of-retry_list-in-cifs_r.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k1wmz71t0>
X-Attachment-Id: f_k1wmz71t0

RnJvbSAzMmRlZjQxYWFjNzFiMjI3ZGMxMWE1OTg4NzU0Y2JkYTRiYTlhZDhhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBEYXZlIFd5c29jaGFuc2tpIDxkd3lzb2NoYUByZWRoYXQuY29t
PgpEYXRlOiBGcmksIDE4IE9jdCAyMDE5IDA0OjI4OjU2IC0wNDAwClN1YmplY3Q6IFtQQVRDSF0g
Y2lmczogRml4IGxpc3RfZGVsIGNvcnJ1cHRpb24gb2YgcmV0cnlfbGlzdCBpbiBjaWZzX3JlY29u
bmVjdAoKVGhlcmUncyBhIHJhY2UgYmV0d2VlbiB0aGUgZGVtdWx0aXBsZXhlciB0aHJlYWQgYW5k
IHRoZSByZXF1ZXN0Cmlzc3VpbmcgdGhyZWFkIHNpbWlsYXIgdG8gdGhlIHJhY2UgZGVzY3JpYmVk
IGluCmNvbW1pdCA2OTZlNDIwYmIyYTYgKCJjaWZzOiBGaXggdXNlIGFmdGVyIGZyZWUgb2YgYSBt
aWRfcV9lbnRyeSIpCndoZXJlIGJvdGggdGhyZWFkcyBtYXkgb2J0YWluIGFuZCBhdHRlbXB0IHRv
IGNhbGwgbGlzdF9kZWxfaW5pdApvbiB0aGUgc2FtZSBtaWQgYW5kIGEgbGlzdF9kZWwgY29ycnVw
dGlvbiBzaW1pbGFyIHRvIHRoZQpmb2xsb3dpbmcgd2lsbCByZXN1bHQ6CgpbICA0MzAuNDU0ODk3
XSBsaXN0X2RlbCBjb3JydXB0aW9uLiBwcmV2LT5uZXh0IHNob3VsZCBiZSBmZmZmOThkM2E4ZjMx
NmMwLCBidXQgd2FzIDJlODg1Y2IyNjYzNTU0NjkKWyAgNDMwLjQ2NDY2OF0gLS0tLS0tLS0tLS0t
WyBjdXQgaGVyZSBdLS0tLS0tLS0tLS0tClsgIDQzMC40NjY1NjldIGtlcm5lbCBCVUcgYXQgbGli
L2xpc3RfZGVidWcuYzo1MSEKWyAgNDMwLjQ2ODQ3Nl0gaW52YWxpZCBvcGNvZGU6IDAwMDAgWyMx
XSBTTVAgUFRJClsgIDQzMC40NzAyODZdIENQVTogMCBQSUQ6IDEzMjY3IENvbW06IGNpZnNkIEtk
dW1wOiBsb2FkZWQgTm90IHRhaW50ZWQgNS40LjAtcmMzKyAjMTkKWyAgNDMwLjQ3MzQ3Ml0gSGFy
ZHdhcmUgbmFtZTogUmVkIEhhdCBLVk0sIEJJT1MgMC41LjEgMDEvMDEvMjAxMQpbICA0MzAuNDc1
ODcyXSBSSVA6IDAwMTA6X19saXN0X2RlbF9lbnRyeV92YWxpZC5jb2xkKzB4MzEvMHg1NQpbICA0
MzAuNDc4MTI5XSBDb2RlOiA1ZSAxNSA4ZSBlOCA1NCBhMyBjNSBmZiAwZiAwYiA0OCBjNyBjNyA3
OCA1ZiAxNSA4ZSBlOCA0NiBhMyBjNSBmZiAwZiAwYiA0OCA4OSBmMiA0OCA4OSBmZSA0OCBjNyBj
NyAzOCA1ZiAxNSA4ZSBlOCAzMiBhMyBjNSBmZiA8MGY+IDBiIDQ4IDg5IGZlIDRjIDg5IGMyIDQ4
IGM3IGM3IDAwIDVmIDE1IDhlIGU4IDFlIGEzIGM1IGZmIDBmIDBiClsgIDQzMC40ODU1NjNdIFJT
UDogMDAxODpmZmZmYjRkYjAwNDJmZDM4IEVGTEFHUzogMDAwMTAyNDYKWyAgNDMwLjQ4NzY2NV0g
UkFYOiAwMDAwMDAwMDAwMDAwMDU0IFJCWDogZmZmZjk4ZDNhYWJiODgwMCBSQ1g6IDAwMDAwMDAw
MDAwMDAwMDAKWyAgNDMwLjQ5MDUxM10gUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogZmZmZjk4
ZDNiN2ExNzkwOCBSREk6IGZmZmY5OGQzYjdhMTc5MDgKWyAgNDMwLjQ5MzM4M10gUkJQOiBmZmZm
OThkM2E4ZjMxNmMwIFIwODogZmZmZjk4ZDNiN2ExNzkwOCBSMDk6IDAwMDAwMDAwMDAwMDAyODUK
WyAgNDMwLjQ5NjI1OF0gUjEwOiBmZmZmYjRkYjAwNDJmYmYwIFIxMTogZmZmZmI0ZGIwMDQyZmJm
NSBSMTI6IGZmZmY5OGQzYWFiYjg5YzAKWyAgNDMwLjQ5OTExM10gUjEzOiBmZmZmYjRkYjAwNDJm
ZDQ4IFIxNDogMmU4ODVjYjI2NjM1NTQ2OSBSMTU6IGZmZmY5OGQzYjI0YzQ0ODAKWyAgNDMwLjUw
MTk4MV0gRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY5OGQzYjdhMDAwMDAoMDAw
MCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApbICA0MzAuNTA1MjMyXSBDUzogIDAwMTAgRFM6IDAw
MDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzClsgIDQzMC41MDc1NDZdIENSMjogMDAw
MDdmMDhjZDE3YjljMCBDUjM6IDAwMDAwMDAyMzQ4NGEwMDAgQ1I0OiAwMDAwMDAwMDAwMDQwNmYw
ClsgIDQzMC41MTA0MjZdIENhbGwgVHJhY2U6ClsgIDQzMC41MTE1MDBdICBjaWZzX3JlY29ubmVj
dCsweDI1ZS8weDYxMCBbY2lmc10KWyAgNDMwLjUxMzM1MF0gIGNpZnNfcmVhZHZfZnJvbV9zb2Nr
ZXQrMHgyMjAvMHgyNTAgW2NpZnNdClsgIDQzMC41MTU0NjRdICBjaWZzX3JlYWRfZnJvbV9zb2Nr
ZXQrMHg0YS8weDcwIFtjaWZzXQpbICA0MzAuNTE3NDUyXSAgPyB0cnlfdG9fd2FrZV91cCsweDIx
Mi8weDY1MApbICA0MzAuNTE5MTIyXSAgPyBjaWZzX3NtYWxsX2J1Zl9nZXQrMHgxNi8weDMwIFtj
aWZzXQpbICA0MzAuNTIxMDg2XSAgPyBhbGxvY2F0ZV9idWZmZXJzKzB4NjYvMHgxMjAgW2NpZnNd
ClsgIDQzMC41MjMwMTldICBjaWZzX2RlbXVsdGlwbGV4X3RocmVhZCsweGRjLzB4YzMwIFtjaWZz
XQpbICA0MzAuNTI1MTE2XSAga3RocmVhZCsweGZiLzB4MTMwClsgIDQzMC41MjY0MjFdICA/IGNp
ZnNfaGFuZGxlX3N0YW5kYXJkKzB4MTkwLzB4MTkwIFtjaWZzXQpbICA0MzAuNTI4NTE0XSAgPyBr
dGhyZWFkX3BhcmsrMHg5MC8weDkwClsgIDQzMC41MzAwMTldICByZXRfZnJvbV9mb3JrKzB4MzUv
MHg0MAoKVG8gZml4IHRoZSBhYm92ZSwgaW5zaWRlIGNpZnNfcmVjb25uZWN0IHVuY29uZGl0aW9u
YWxseSBzZXQgdGhlCnN0YXRlIHRvIE1JRF9SRVRSWV9ORUVERUQsIGFuZCB0aGVuIHRha2UgYSBy
ZWZlcmVuY2UgYmVmb3JlIHdlCm1vdmUgYW55IG1pZF9xX2VudHJ5IG9uIHNlcnZlci0+cGVuZGlu
Z19taWRfcSB0byB0aGUgdGVtcG9yYXJ5CnJldHJ5X2xpc3QuICBUaGVuIHdoaWxlIHByb2Nlc3Np
bmcgcmV0cnlfbGlzdCBkcm9wIHRoZSByZWZlcmVuY2UKYWZ0ZXIgdGhlIG1pZF9xX2VudHJ5IGNh
bGxiYWNrIGhhcyBiZWVuIGNvbXBsZXRlZC4gIEluIHRoZSBjb2RlCnBhdGhzIGZvciByZXF1ZXN0
IGlzc3VpbmcgdGhyZWFkLCBhdm9pZCBjYWxsaW5nIGxpc3RfZGVsX2luaXQKaWYgd2Ugbm90aWNl
IG1pZC0+bWlkX3N0YXRlICE9IE1JRF9SRVRSWV9ORUVERUQsIGF2b2lkaW5nIHRoZQpyYWNlIGFu
ZCBkdXBsaWNhdGUgY2FsbCB0byBsaXN0X2RlbF9pbml0LgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBX
eXNvY2hhbnNraSA8ZHd5c29jaGFAcmVkaGF0LmNvbT4KLS0tCiBmcy9jaWZzL2Nvbm5lY3QuYyAg
IHwgMTggKysrKysrKysrKystLS0tLS0tCiBmcy9jaWZzL3RyYW5zcG9ydC5jIHwgIDYgKysrKy0t
CiAyIGZpbGVzIGNoYW5nZWQsIDE1IGluc2VydGlvbnMoKyksIDkgZGVsZXRpb25zKC0pCgpkaWZm
IC0tZ2l0IGEvZnMvY2lmcy9jb25uZWN0LmMgYi9mcy9jaWZzL2Nvbm5lY3QuYwppbmRleCBhNjRk
ZmE5NWE5MjUuLmM4YjhkNGVmZTVhNCAxMDA2NDQKLS0tIGEvZnMvY2lmcy9jb25uZWN0LmMKKysr
IGIvZnMvY2lmcy9jb25uZWN0LmMKQEAgLTU2NCw4ICs1NjQsOSBAQCBzdGF0aWMgaW5saW5lIGlu
dCByZWNvbm5fc2V0dXBfZGZzX3RhcmdldHMoc3RydWN0IGNpZnNfc2JfaW5mbyAqY2lmc19zYiwK
IAlzcGluX2xvY2soJkdsb2JhbE1pZF9Mb2NrKTsKIAlsaXN0X2Zvcl9lYWNoX3NhZmUodG1wLCB0
bXAyLCAmc2VydmVyLT5wZW5kaW5nX21pZF9xKSB7CiAJCW1pZF9lbnRyeSA9IGxpc3RfZW50cnko
dG1wLCBzdHJ1Y3QgbWlkX3FfZW50cnksIHFoZWFkKTsKLQkJaWYgKG1pZF9lbnRyeS0+bWlkX3N0
YXRlID09IE1JRF9SRVFVRVNUX1NVQk1JVFRFRCkKLQkJCW1pZF9lbnRyeS0+bWlkX3N0YXRlID0g
TUlEX1JFVFJZX05FRURFRDsKKwkJa3JlZl9nZXQoJm1pZF9lbnRyeS0+cmVmY291bnQpOworCQlX
QVJOX09OKG1pZF9lbnRyeS0+bWlkX3N0YXRlICE9IE1JRF9SRVFVRVNUX1NVQk1JVFRFRCk7CisJ
CW1pZF9lbnRyeS0+bWlkX3N0YXRlID0gTUlEX1JFVFJZX05FRURFRDsKIAkJbGlzdF9tb3ZlKCZt
aWRfZW50cnktPnFoZWFkLCAmcmV0cnlfbGlzdCk7CiAJfQogCXNwaW5fdW5sb2NrKCZHbG9iYWxN
aWRfTG9jayk7CkBAIC01NzYsNiArNTc3LDcgQEAgc3RhdGljIGlubGluZSBpbnQgcmVjb25uX3Nl
dHVwX2Rmc190YXJnZXRzKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2IsCiAJCW1pZF9lbnRy
eSA9IGxpc3RfZW50cnkodG1wLCBzdHJ1Y3QgbWlkX3FfZW50cnksIHFoZWFkKTsKIAkJbGlzdF9k
ZWxfaW5pdCgmbWlkX2VudHJ5LT5xaGVhZCk7CiAJCW1pZF9lbnRyeS0+Y2FsbGJhY2sobWlkX2Vu
dHJ5KTsKKwkJY2lmc19taWRfcV9lbnRyeV9yZWxlYXNlKG1pZF9lbnRyeSk7CiAJfQogCiAJaWYg
KGNpZnNfcmRtYV9lbmFibGVkKHNlcnZlcikpIHsKQEAgLTg4NCwxMCArODg2LDYgQEAgc3RhdGlj
IGlubGluZSBpbnQgcmVjb25uX3NldHVwX2Rmc190YXJnZXRzKHN0cnVjdCBjaWZzX3NiX2luZm8g
KmNpZnNfc2IsCiAJbWlkLT53aGVuX3JlY2VpdmVkID0gamlmZmllczsKICNlbmRpZgogCXNwaW5f
bG9jaygmR2xvYmFsTWlkX0xvY2spOwotCWlmICghbWFsZm9ybWVkKQotCQltaWQtPm1pZF9zdGF0
ZSA9IE1JRF9SRVNQT05TRV9SRUNFSVZFRDsKLQllbHNlCi0JCW1pZC0+bWlkX3N0YXRlID0gTUlE
X1JFU1BPTlNFX01BTEZPUk1FRDsKIAkvKgogCSAqIFRyeWluZyB0byBoYW5kbGUvZGVxdWV1ZSBh
IG1pZCBhZnRlciB0aGUgc2VuZF9yZWN2KCkKIAkgKiBmdW5jdGlvbiBoYXMgZmluaXNoZWQgcHJv
Y2Vzc2luZyBpdCBpcyBhIGJ1Zy4KQEAgLTg5NSw4ICs4OTMsMTQgQEAgc3RhdGljIGlubGluZSBp
bnQgcmVjb25uX3NldHVwX2Rmc190YXJnZXRzKHN0cnVjdCBjaWZzX3NiX2luZm8gKmNpZnNfc2Is
CiAJaWYgKG1pZC0+bWlkX2ZsYWdzICYgTUlEX0RFTEVURUQpCiAJCXByaW50a19vbmNlKEtFUk5f
V0FSTklORwogCQkJICAgICJ0cnlpbmcgdG8gZGVxdWV1ZSBhIGRlbGV0ZWQgbWlkXG4iKTsKLQll
bHNlCisJaWYgKG1pZC0+bWlkX3N0YXRlICE9IE1JRF9SRVRSWV9ORUVERUQpCiAJCWxpc3RfZGVs
X2luaXQoJm1pZC0+cWhlYWQpOworCisJaWYgKCFtYWxmb3JtZWQpCisJCW1pZC0+bWlkX3N0YXRl
ID0gTUlEX1JFU1BPTlNFX1JFQ0VJVkVEOworCWVsc2UKKwkJbWlkLT5taWRfc3RhdGUgPSBNSURf
UkVTUE9OU0VfTUFMRk9STUVEOworCiAJc3Bpbl91bmxvY2soJkdsb2JhbE1pZF9Mb2NrKTsKIH0K
IApkaWZmIC0tZ2l0IGEvZnMvY2lmcy90cmFuc3BvcnQuYyBiL2ZzL2NpZnMvdHJhbnNwb3J0LmMK
aW5kZXggMzA4YWQwZjQ5NWUxLi4xN2E0MzBiNTg2NzMgMTAwNjQ0Ci0tLSBhL2ZzL2NpZnMvdHJh
bnNwb3J0LmMKKysrIGIvZnMvY2lmcy90cmFuc3BvcnQuYwpAQCAtMTczLDcgKzE3Myw4IEBAIHZv
aWQgY2lmc19taWRfcV9lbnRyeV9yZWxlYXNlKHN0cnVjdCBtaWRfcV9lbnRyeSAqbWlkRW50cnkp
CiBjaWZzX2RlbGV0ZV9taWQoc3RydWN0IG1pZF9xX2VudHJ5ICptaWQpCiB7CiAJc3Bpbl9sb2Nr
KCZHbG9iYWxNaWRfTG9jayk7Ci0JbGlzdF9kZWxfaW5pdCgmbWlkLT5xaGVhZCk7CisJaWYgKG1p
ZC0+bWlkX3N0YXRlICE9IE1JRF9SRVRSWV9ORUVERUQpCisJCWxpc3RfZGVsX2luaXQoJm1pZC0+
cWhlYWQpOwogCW1pZC0+bWlkX2ZsYWdzIHw9IE1JRF9ERUxFVEVEOwogCXNwaW5fdW5sb2NrKCZH
bG9iYWxNaWRfTG9jayk7CiAKQEAgLTg3Miw3ICs4NzMsOCBAQCBzdHJ1Y3QgbWlkX3FfZW50cnkg
KgogCQlyYyA9IC1FSE9TVERPV047CiAJCWJyZWFrOwogCWRlZmF1bHQ6Ci0JCWxpc3RfZGVsX2lu
aXQoJm1pZC0+cWhlYWQpOworCQlpZiAobWlkLT5taWRfc3RhdGUgIT0gTUlEX1JFVFJZX05FRURF
RCkKKwkJCWxpc3RfZGVsX2luaXQoJm1pZC0+cWhlYWQpOwogCQljaWZzX3NlcnZlcl9kYmcoVkZT
LCAiJXM6IGludmFsaWQgbWlkIHN0YXRlIG1pZD0lbGx1IHN0YXRlPSVkXG4iLAogCQkJIF9fZnVu
Y19fLCBtaWQtPm1pZCwgbWlkLT5taWRfc3RhdGUpOwogCQlyYyA9IC1FSU87Ci0tIAoxLjguMy4x
Cgo=
--0000000000001dd78a059535ec60--
