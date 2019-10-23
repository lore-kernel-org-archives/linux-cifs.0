Return-Path: <SRS0=Yjbq=YQ=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE897CA9EA0
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 02:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A76E021848
	for <linux-cifs@archiver.kernel.org>; Wed, 23 Oct 2019 02:56:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QGzXQpAT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389459AbfJWC4i (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 22:56:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:44842 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732748AbfJWC4i (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 22 Oct 2019 22:56:38 -0400
Received: by mail-io1-f67.google.com with SMTP id w12so23057929iol.11
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 19:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TWYUjkBL22KTOxZSuSY/WWTbm6UdaYCyLk9okPQwusY=;
        b=QGzXQpATrzhxryb8qFE8iARWz+b3vvbtP6kBeOJo1hqz4NPqhS7++IlegpQYYNq3W3
         K0hi9Z0+kzTqWkL59bRAitGAImAkA65JFlZaMJB/TMiHbKaxGDUqDRGit861rLU9tWTV
         SEMPokRkWiZtO/5v/3DnLu24P7MGXmq93mfcXqmBVIu6XL0XWaHjq4+63ECC2PssGTtP
         yvf+li58smFH64xf3opmuZRsavwSqLcr0SEUOXeIUgOQPMF51isA4yhFFRDKfATiam6p
         408IsTx2BPvuEFv/BBZkSEJVsjFvi4+gbKW/gWQ3FkAP0kdxkX7CIw8gIGEsi8LriRdu
         EQfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TWYUjkBL22KTOxZSuSY/WWTbm6UdaYCyLk9okPQwusY=;
        b=f2nts4XeBBFybsUfOr0lwgsVP2JjWcs0mt15EVZwaNiglfNg2GL/q1LTYpdYA0iiGP
         Sq1ReztS8owOt26gHb+KDV82QgXDxtizC1YcMhbkDq4Ck6oVqTXcipNgFHXcMEVlh0jO
         QrRNHl71Pqlf0rOCNFZHvhf0bVHS8Uf4D43DpmOj08Ew4JbCAOLKYbvrQNgmEl2reL5d
         TAWxTBQB7Kt82p365JSUfTwnHAOu7XuOPLl9nBWvLXZI8+WYNdnPT/LdWDzz1ILeW5oJ
         4NxX6k3UPFyZ4ZYmJ1I6BEAep6/r0TXxy6YgByfW/RGPpqDdOZfs9YfGZdvO59qX0Vqx
         t/Jw==
X-Gm-Message-State: APjAAAWoEurXlTO78KRI87sxcOH7liLqp8L0mD89deu5666/3RV3g5wI
        CpxapnpsCdhSLBK7vxJsGFMj4WhftSN7wMtumctSqr1wHS0=
X-Google-Smtp-Source: APXvYqzvTOBPTgeRJIyxDnUJbRN/Y15r7QM4qXWH7ZqfwCXf16DtMHwa7/ISJEspEHl9f9IH9W6BMWxCR0kv9OBw94o=
X-Received: by 2002:a6b:fa12:: with SMTP id p18mr1078920ioh.272.1571799396383;
 Tue, 22 Oct 2019 19:56:36 -0700 (PDT)
MIME-Version: 1.0
References: <20191022223534.21711-1-pshilov@microsoft.com>
In-Reply-To: <20191022223534.21711-1-pshilov@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 22 Oct 2019 21:56:25 -0500
Message-ID: <CAH2r5muBF5cb5bUtVcF1qa-7Bd=khnsYet=OnqKy5tBAseZFdQ@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Fix retry mid list corruption on reconnects
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        David Wysochanski <dwysocha@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Pavel Shilovskiy <pshilov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next

running buildbot now ...
http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/268

On Tue, Oct 22, 2019 at 5:35 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> When the client hits reconnect it iterates over the mid
> pending queue marking entries for retry and moving them
> to a temporary list to issue callbacks later without holding
> GlobalMid_Lock. In the same time there is no guarantee that
> mids can't be removed from the temporary list or even
> freed completely by another thread. It may cause a temporary
> list corruption:
>
> [  430.454897] list_del corruption. prev->next should be ffff98d3a8f316c0, but was 2e885cb266355469
> [  430.464668] ------------[ cut here ]------------
> [  430.466569] kernel BUG at lib/list_debug.c:51!
> [  430.468476] invalid opcode: 0000 [#1] SMP PTI
> [  430.470286] CPU: 0 PID: 13267 Comm: cifsd Kdump: loaded Not tainted 5.4.0-rc3+ #19
> [  430.473472] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
> [  430.475872] RIP: 0010:__list_del_entry_valid.cold+0x31/0x55
> ...
> [  430.510426] Call Trace:
> [  430.511500]  cifs_reconnect+0x25e/0x610 [cifs]
> [  430.513350]  cifs_readv_from_socket+0x220/0x250 [cifs]
> [  430.515464]  cifs_read_from_socket+0x4a/0x70 [cifs]
> [  430.517452]  ? try_to_wake_up+0x212/0x650
> [  430.519122]  ? cifs_small_buf_get+0x16/0x30 [cifs]
> [  430.521086]  ? allocate_buffers+0x66/0x120 [cifs]
> [  430.523019]  cifs_demultiplex_thread+0xdc/0xc30 [cifs]
> [  430.525116]  kthread+0xfb/0x130
> [  430.526421]  ? cifs_handle_standard+0x190/0x190 [cifs]
> [  430.528514]  ? kthread_park+0x90/0x90
> [  430.530019]  ret_from_fork+0x35/0x40
>
> Fix this by obtaining extra references for mids being retried
> and marking them as MID_DELETED which indicates that such a mid
> has been dequeued from the pending list.
>
> Also move mid cleanup logic from DeleteMidQEntry to
> _cifs_mid_q_entry_release which is called when the last reference
> to a particular mid is put. This allows to avoid any use-after-free
> of response buffers.
>
> The patch needs to be backported to stable kernels. A stable tag
> is not mentioned below because the patch doesn't apply cleanly
> to any actively maintained stable kernel.
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Reviewed-and-tested-by: David Wysochanski <dwysocha@redhat.com>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/connect.c   | 10 +++++++++-
>  fs/cifs/transport.c | 42 +++++++++++++++++++++++-------------------
>  2 files changed, 32 insertions(+), 20 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b724227b853c..ac43c79ebdf5 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -564,9 +564,11 @@ cifs_reconnect(struct TCP_Server_Info *server)
>         spin_lock(&GlobalMid_Lock);
>         list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
> +               kref_get(&mid_entry->refcount);
>                 if (mid_entry->mid_state == MID_REQUEST_SUBMITTED)
>                         mid_entry->mid_state = MID_RETRY_NEEDED;
>                 list_move(&mid_entry->qhead, &retry_list);
> +               mid_entry->mid_flags |= MID_DELETED;
>         }
>         spin_unlock(&GlobalMid_Lock);
>         mutex_unlock(&server->srv_mutex);
> @@ -576,6 +578,7 @@ cifs_reconnect(struct TCP_Server_Info *server)
>                 mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>                 list_del_init(&mid_entry->qhead);
>                 mid_entry->callback(mid_entry);
> +               cifs_mid_q_entry_release(mid_entry);
>         }
>
>         if (cifs_rdma_enabled(server)) {
> @@ -895,8 +898,10 @@ dequeue_mid(struct mid_q_entry *mid, bool malformed)
>         if (mid->mid_flags & MID_DELETED)
>                 printk_once(KERN_WARNING
>                             "trying to dequeue a deleted mid\n");
> -       else
> +       else {
>                 list_del_init(&mid->qhead);
> +               mid->mid_flags |= MID_DELETED;
> +       }
>         spin_unlock(&GlobalMid_Lock);
>  }
>
> @@ -966,8 +971,10 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                 list_for_each_safe(tmp, tmp2, &server->pending_mid_q) {
>                         mid_entry = list_entry(tmp, struct mid_q_entry, qhead);
>                         cifs_dbg(FYI, "Clearing mid 0x%llx\n", mid_entry->mid);
> +                       kref_get(&mid_entry->refcount);
>                         mid_entry->mid_state = MID_SHUTDOWN;
>                         list_move(&mid_entry->qhead, &dispose_list);
> +                       mid_entry->mid_flags |= MID_DELETED;
>                 }
>                 spin_unlock(&GlobalMid_Lock);
>
> @@ -977,6 +984,7 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>                         cifs_dbg(FYI, "Callback mid 0x%llx\n", mid_entry->mid);
>                         list_del_init(&mid_entry->qhead);
>                         mid_entry->callback(mid_entry);
> +                       cifs_mid_q_entry_release(mid_entry);
>                 }
>                 /* 1/8th of sec is more than enough time for them to exit */
>                 msleep(125);
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 308ad0f495e1..ca3de62688d6 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -86,22 +86,8 @@ AllocMidQEntry(const struct smb_hdr *smb_buffer, struct TCP_Server_Info *server)
>
>  static void _cifs_mid_q_entry_release(struct kref *refcount)
>  {
> -       struct mid_q_entry *mid = container_of(refcount, struct mid_q_entry,
> -                                              refcount);
> -
> -       mempool_free(mid, cifs_mid_poolp);
> -}
> -
> -void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
> -{
> -       spin_lock(&GlobalMid_Lock);
> -       kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
> -       spin_unlock(&GlobalMid_Lock);
> -}
> -
> -void
> -DeleteMidQEntry(struct mid_q_entry *midEntry)
> -{
> +       struct mid_q_entry *midEntry =
> +                       container_of(refcount, struct mid_q_entry, refcount);
>  #ifdef CONFIG_CIFS_STATS2
>         __le16 command = midEntry->server->vals->lock_cmd;
>         __u16 smb_cmd = le16_to_cpu(midEntry->command);
> @@ -166,6 +152,19 @@ DeleteMidQEntry(struct mid_q_entry *midEntry)
>                 }
>         }
>  #endif
> +
> +       mempool_free(midEntry, cifs_mid_poolp);
> +}
> +
> +void cifs_mid_q_entry_release(struct mid_q_entry *midEntry)
> +{
> +       spin_lock(&GlobalMid_Lock);
> +       kref_put(&midEntry->refcount, _cifs_mid_q_entry_release);
> +       spin_unlock(&GlobalMid_Lock);
> +}
> +
> +void DeleteMidQEntry(struct mid_q_entry *midEntry)
> +{
>         cifs_mid_q_entry_release(midEntry);
>  }
>
> @@ -173,8 +172,10 @@ void
>  cifs_delete_mid(struct mid_q_entry *mid)
>  {
>         spin_lock(&GlobalMid_Lock);
> -       list_del_init(&mid->qhead);
> -       mid->mid_flags |= MID_DELETED;
> +       if (!(mid->mid_flags & MID_DELETED)) {
> +               list_del_init(&mid->qhead);
> +               mid->mid_flags |= MID_DELETED;
> +       }
>         spin_unlock(&GlobalMid_Lock);
>
>         DeleteMidQEntry(mid);
> @@ -872,7 +873,10 @@ cifs_sync_mid_result(struct mid_q_entry *mid, struct TCP_Server_Info *server)
>                 rc = -EHOSTDOWN;
>                 break;
>         default:
> -               list_del_init(&mid->qhead);
> +               if (!(mid->mid_flags & MID_DELETED)) {
> +                       list_del_init(&mid->qhead);
> +                       mid->mid_flags |= MID_DELETED;
> +               }
>                 cifs_server_dbg(VFS, "%s: invalid mid state mid=%llu state=%d\n",
>                          __func__, mid->mid, mid->mid_state);
>                 rc = -EIO;
> --
> 2.17.1
>


-- 
Thanks,

Steve
