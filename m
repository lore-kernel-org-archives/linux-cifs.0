Return-Path: <SRS0=tZQk=YK=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9132ECA9EB3
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 23:41:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EA9221D7A
	for <linux-cifs@archiver.kernel.org>; Thu, 17 Oct 2019 23:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438711AbfJQXlm (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 17 Oct 2019 19:41:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55241 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438582AbfJQXll (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 17 Oct 2019 19:41:41 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 731EE882F5;
        Thu, 17 Oct 2019 23:41:41 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 682EE60BE1;
        Thu, 17 Oct 2019 23:41:41 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 5B7644EDA5;
        Thu, 17 Oct 2019 23:41:41 +0000 (UTC)
Date:   Thu, 17 Oct 2019 19:41:41 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     David Wysochanski <dwysocha@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>,
        Steven French <Steven.French@microsoft.com>
Message-ID: <1687170050.7216953.1571355701290.JavaMail.zimbra@redhat.com>
In-Reply-To: <DM5PR21MB01850AD14CCFC8F3C7CE752BB66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com> <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com> <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com> <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com> <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com> <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com> <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com> <DM5PR21MB01850AD14CCFC8F3C7CE752BB66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
Subject: Re: list_del corruption while iterating retry_list in
 cifs_reconnect still seen on 5.4-rc3
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.54.116, 10.4.195.3]
Thread-Topic: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
Thread-Index: AQHVhFfJ9oP6OHPYNEeW5MnF2E27oqdd98kAgACTlgCAACvBAIAAKOAAgAAWtQCAADArYIAAEQ8AgAAJKVCAAArhgIAAE4yAgAAC0eDft33iN6BIlrfAlURL368=
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Thu, 17 Oct 2019 23:41:41 +0000 (UTC)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org





----- Original Message -----
> From: "Pavel Shilovskiy" <pshilov@microsoft.com>
> To: "Ronnie Sahlberg" <lsahlber@redhat.com>
> Cc: "David Wysochanski" <dwysocha@redhat.com>, "linux-cifs" <linux-cifs@vger.kernel.org>, "Frank Sorenson"
> <sorenson@redhat.com>, "Steven French" <Steven.French@microsoft.com>
> Sent: Friday, 18 October, 2019 9:20:51 AM
> Subject: RE: list_del corruption while iterating retry_list in cifs_reconnect still seen on 5.4-rc3
> 
> Agree.
> 
> Probably the change in dequeue_mid() is not needed but won't hurt at least -
> right now dequeue_mid() is being called from the demultiplex thread only, so
> as cifs_reconnect(). I am wondering how your patch behaves with the repro.

Thanks.
Dave, can you test with your reproducer if this makes things better?


> 
> In general, I am starting to think more that we should probably remove a MID
> immediately from the pending list once we parse MessageId from the response
> and find the entry in the list. Especially with the recent parallel
> decryption capability that Steve is working on, we would need to break the
> above assumption and process the mid entry in another thread. There are some
> cases where we don't end up removing the MID but for those cases we may
> simply add the entry back. Anyway, it needs much more thinking and out of
> the scope of the bugfix being discussed.

I agree.

Btw, I think we have had bug sin this code since at least the 3.x kernels
so we need a simple fix that is easy to backport to stable and beyond.


> 
> --
> Best regards,
> Pavel Shilovsky
> 
> -----Original Message-----
> From: Ronnie Sahlberg <lsahlber@redhat.com>
> Sent: Thursday, October 17, 2019 3:54 PM
> To: Pavel Shilovskiy <pshilov@microsoft.com>
> Cc: David Wysochanski <dwysocha@redhat.com>; linux-cifs
> <linux-cifs@vger.kernel.org>; Frank Sorenson <sorenson@redhat.com>
> Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
> still seen on 5.4-rc3
> 
> That could work. But then we should also use that flag to suppress the other
> places where we do a list_del*, so something like this ?
> 
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h index
> 50dfd9049370..b324fff33e53 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1702,6 +1702,7 @@ static inline bool is_retryable_error(int error)
>  /* Flags */
>  #define   MID_WAIT_CANCELLED    1 /* Cancelled while waiting for response */
>  #define   MID_DELETED            2 /* Mid has been dequeued/deleted */
> +#define   MID_RECONNECT          4 /* Mid is being used during reconnect */
>  
>  /* Types of response buffer returned from SendReceive2 */
>  #define   CIFS_NO_BUFFER        0    /* Response buffer not returned */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c index
> bdea4b3e8005..b142bd2a3ef5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -564,6 +564,8 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         spin_lock(&GlobalMid_Lock);
>         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> +               kref_get(&mid_entry->refcount);
> +               mid_entry->mid_flags |= MID_RECONNECT;
>                 if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
>                         mid_entry->mid_state = MID_RETRY_NEEDED;
>                 list_move(&mid_entry->qhead, &retry_list); @@ -575,7 +577,9
>                 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         list_for_each_safe(tmp, tmp2, &retry_list) {
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>                 list_del_init(&mid_entry->qhead);
> +
>                 mid_entry->callback(mid_entry);
> +               cifs_mid_q_entry_release(mid_entry);
>         }
>  
>         if (cifs_rdma_enabled(server)) { @@ -895,7 +899,7 @@
>         dequeue_mid(struct mid_q_entry *mid, bool malformed)
>         if (mid->mid_flags & MID_DELETED)
>                 printk_once(KERN_WARNING
>                             "trying to dequeue a deleted mid\n");
> -       else
> +       else if (!(mid->mid_flags & MID_RECONNECT))
>                 list_del_init(&mid->qhead);
>         spin_unlock(&GlobalMid_Lock);
>  }
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c index
> 308ad0f495e1..ba4b5ab9cf35 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -173,7 +173,8 @@ void
>  cifs_delete_mid(struct mid_q_entry *mid)  {
>         spin_lock(&GlobalMid_Lock);
> -       list_del_init(&mid->qhead);
> +       if (!(mid->mid_flags & MID_RECONNECT))
> +               list_del_init(&mid->qhead);
>         mid->mid_flags |= MID_DELETED;
>         spin_unlock(&GlobalMid_Lock);
>  
> @@ -872,7 +873,8 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct
> TCP_Server_Info *server)
>                 rc = -EHOSTDOWN;
>                 break;
>         default:
> -               list_del_init(&mid->qhead);
> +               if (!(mid->mid_flags & MID_RECONNECT))
> +                       list_del_init(&mid->qhead);
>                 cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu
>                 state=%d\n",
>                          __func__, mid->mid, mid->mid_state);
>                 rc = -EIO;
> 
