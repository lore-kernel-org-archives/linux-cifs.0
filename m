Return-Path: <SRS0=RVJ6=Q4=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3AC9C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:06:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64A5420880
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Feb 2019 00:06:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dyamxn4e"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726016AbfBUAGh (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 20 Feb 2019 19:06:37 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44713 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfBUAGh (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 20 Feb 2019 19:06:37 -0500
Received: by mail-qk1-f194.google.com with SMTP id r21so3204851qkl.11
        for <linux-cifs@vger.kernel.org>; Wed, 20 Feb 2019 16:06:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=la/b1XlT5RpTzmY74IMd4yTtTLBpwjWfluV5fPvm/Vs=;
        b=dyamxn4e6lyLQ0gKyalPKmscxj57r/Qgkk/HWiCoVva7J33frerlBdfHxLxx/YR+Tj
         LjUVHHm2pB0rqmYm/j7VVK9Pp8VACavK0gulwovYcBXSysbmzBWNGs2/Rc27oaz8dhwo
         NDYA8luMbvAfrw6NMkpDGa4aiXy9LnlA/VLSLTaWwhnZje7DkKac9JtTY+uzIX4c46vT
         Nisg0Xl86bFwXSL3fSG/hQKJfucJfWPZNBCKtCWklHOgnNoF02dDDSt9Uo99FyTZTFv+
         Nu8xYK3AqZyK52GDfGA10M40SizLxkij6J2hjFwLiOyrgSF4PHL4QuY8vsxjihYP0pD+
         mn2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=la/b1XlT5RpTzmY74IMd4yTtTLBpwjWfluV5fPvm/Vs=;
        b=S8WiDZD9ja9j7G4ZYmVZ19M60n/7SzRcImcHZC15K14j47/ue/MEcLTE5ToIWoCEP3
         8pkVDzSIzTE7gth1SZBPlNS5rQjJtYOH1IH7BQZU583KobkwVBRQr7d8+rMnwJ5Uenlb
         u1NRKzuDKuzW/liBjjKSm6fzgSbf3F/rObGxG+7EIgPNUafVKkzA9b2nBWsGx3M01dnN
         dINFSaqTFzmniyD9zxyIqlGVDUCBkWSj88aYYGfqj74FBmZiZ5WeqR4q8fAfEnTaIOMl
         KYDyzAPQta5wRlwekOEoq2+DWiXs1wc3Cae3gc6+YxnhrKerv6Z+/tWwRwQoGODX+t+p
         H+IA==
X-Gm-Message-State: AHQUAuZNPwumhxIyawFHTRh2cu0sydKU0XGN/gLOvc8RnMz6OUJu/H/G
        b8XrN0PUmWtn0cZeZTCuzhdbR1JSZ/9n4vqBiof1jw==
X-Google-Smtp-Source: AHgI3IZ6cvPQPVUZCAHQH4v+AandcDQGJvunV71Rec8+j4P84G9W05xQ93O4ARYq8KC8Ub/egsT/Uitf9y2wn96wfA8=
X-Received: by 2002:ae9:dd04:: with SMTP id r4mr20156500qkf.187.1550707596167;
 Wed, 20 Feb 2019 16:06:36 -0800 (PST)
MIME-Version: 1.0
References: <1550705753-15443-1-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1550705753-15443-1-git-send-email-pshilov@microsoft.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 21 Feb 2019 10:06:24 +1000
Message-ID: <CAN05THTJLY4iBOHSC4h7DEgCXvmNbKr6WDqMQwZEBcpL3AhSsA@mail.gmail.com>
Subject: Re: [PATCH] CIFS: Reset current mid to next value in sequence on send failures
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Awesome!

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Thu, Feb 21, 2019 at 9:38 AM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> When we hit failures during constructing MIDs or sending PDUs
> through the network, we end up not using the message IDs assigned
> to the packet. The next SMB packet will skip those message IDs and
> continue with the next one. This behavior may lead to a server not
> granting us credits until we use the skipped IDs. Fix this by
> reverting the current ID to the original value if any errors occur
> before we push the packet through the network stack.
>
> This patch fixes the generic/310 test from the xfs-tests.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/cifsglob.h      | 15 +++++++++++++++
>  fs/cifs/smb2ops.c       | 12 ++++++++++++
>  fs/cifs/smb2transport.c | 13 +++++++++++--
>  fs/cifs/transport.c     |  6 +++++-
>  4 files changed, 43 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 5bf463c..10be31e 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -238,6 +238,8 @@ struct smb_version_operations {
>         int * (*get_credits_field)(struct TCP_Server_Info *, const int);
>         unsigned int (*get_credits)(struct mid_q_entry *);
>         __u64 (*get_next_mid)(struct TCP_Server_Info *);
> +       void (*revert_current_mid)(struct TCP_Server_Info *server,
> +                                  const unsigned int val);
>         /* data offset from read response message */
>         unsigned int (*read_data_offset)(char *);
>         /*
> @@ -789,6 +791,19 @@ get_next_mid(struct TCP_Server_Info *server)
>         return cpu_to_le16(mid);
>  }
>
> +static inline void
> +revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
> +{
> +       if (server->ops->revert_current_mid)
> +               server->ops->revert_current_mid(server, val);
> +}
> +
> +static inline void
> +dec_current_mid(struct TCP_Server_Info *server)
> +{
> +       return revert_current_mid(server, 1);
> +}
> +
>  static inline __u16
>  get_mid(const struct smb_hdr *smb)
>  {
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 080929a..1243407 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -265,6 +265,14 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
>         return mid;
>  }
>
> +static void
> +smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned int val)
> +{
> +       spin_lock(&GlobalMid_Lock);
> +       server->CurrentMid -= val;
> +       spin_unlock(&GlobalMid_Lock);
> +}
> +
>  static struct mid_q_entry *
>  smb2_find_mid(struct TCP_Server_Info *server, char *buf)
>  {
> @@ -3606,6 +3614,7 @@ struct smb_version_operations smb20_operations = {
>         .get_credits = smb2_get_credits,
>         .wait_mtu_credits = cifs_wait_mtu_credits,
>         .get_next_mid = smb2_get_next_mid,
> +       .revert_current_mid = smb2_revert_current_mid,
>         .read_data_offset = smb2_read_data_offset,
>         .read_data_length = smb2_read_data_length,
>         .map_error = map_smb2_to_linux_error,
> @@ -3702,6 +3711,7 @@ struct smb_version_operations smb21_operations = {
>         .wait_mtu_credits = smb2_wait_mtu_credits,
>         .adjust_credits = smb2_adjust_credits,
>         .get_next_mid = smb2_get_next_mid,
> +       .revert_current_mid = smb2_revert_current_mid,
>         .read_data_offset = smb2_read_data_offset,
>         .read_data_length = smb2_read_data_length,
>         .map_error = map_smb2_to_linux_error,
> @@ -3799,6 +3809,7 @@ struct smb_version_operations smb30_operations = {
>         .wait_mtu_credits = smb2_wait_mtu_credits,
>         .adjust_credits = smb2_adjust_credits,
>         .get_next_mid = smb2_get_next_mid,
> +       .revert_current_mid = smb2_revert_current_mid,
>         .read_data_offset = smb2_read_data_offset,
>         .read_data_length = smb2_read_data_length,
>         .map_error = map_smb2_to_linux_error,
> @@ -3905,6 +3916,7 @@ struct smb_version_operations smb311_operations = {
>         .wait_mtu_credits = smb2_wait_mtu_credits,
>         .adjust_credits = smb2_adjust_credits,
>         .get_next_mid = smb2_get_next_mid,
> +       .revert_current_mid = smb2_revert_current_mid,
>         .read_data_offset = smb2_read_data_offset,
>         .read_data_length = smb2_read_data_length,
>         .map_error = map_smb2_to_linux_error,
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 7b351c6..36baf1b 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -674,13 +674,18 @@ smb2_setup_request(struct cifs_ses *ses, struct smb_rqst *rqst)
>         smb2_seq_num_into_buf(ses->server, shdr);
>
>         rc = smb2_get_mid_entry(ses, shdr, &mid);
> -       if (rc)
> +       if (rc) {
> +               dec_current_mid(ses->server);
>                 return ERR_PTR(rc);
> +       }
> +
>         rc = smb2_sign_rqst(rqst, ses->server);
>         if (rc) {
> +               dec_current_mid(ses->server);
>                 cifs_delete_mid(mid);
>                 return ERR_PTR(rc);
>         }
> +
>         return mid;
>  }
>
> @@ -690,16 +695,20 @@ smb2_setup_async_request(struct TCP_Server_Info *server, struct smb_rqst *rqst)
>         int rc;
>         struct smb2_sync_hdr *shdr =
>                         (struct smb2_sync_hdr *)rqst->rq_iov[0].iov_base;
> +       unsigned int num = le16_to_cpu(shdr->CreditCharge);
>         struct mid_q_entry *mid;
>
>         smb2_seq_num_into_buf(server, shdr);
>
>         mid = smb2_mid_entry_alloc(shdr, server);
> -       if (mid == NULL)
> +       if (mid == NULL) {
> +               revert_current_mid(server, num);
>                 return ERR_PTR(-ENOMEM);
> +       }
>
>         rc = smb2_sign_rqst(rqst, server);
>         if (rc) {
> +               revert_current_mid(server, num);
>                 DeleteMidQEntry(mid);
>                 return ERR_PTR(rc);
>         }
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d4f1224f..849a45d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -695,6 +695,7 @@ cifs_call_async(struct TCP_Server_Info *server, struct smb_rqst *rqst,
>         cifs_in_send_dec(server);
>
>         if (rc < 0) {
> +               revert_current_mid(server, credits.value);
>                 server->sequence_number -= 2;
>                 cifs_delete_mid(mid);
>         }
> @@ -988,6 +989,7 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         for (i = 0; i < num_rqst; i++) {
>                 midQ[i] = ses->server->ops->setup_request(ses, &rqst[i]);
>                 if (IS_ERR(midQ[i])) {
> +                       revert_current_mid(ses->server, i);
>                         for (j = 0; j < i; j++)
>                                 cifs_delete_mid(midQ[j]);
>                         mutex_unlock(&ses->server->srv_mutex);
> @@ -1017,8 +1019,10 @@ compound_send_recv(const unsigned int xid, struct cifs_ses *ses,
>         for (i = 0; i < num_rqst; i++)
>                 cifs_save_when_sent(midQ[i]);
>
> -       if (rc < 0)
> +       if (rc < 0) {
> +               revert_current_mid(ses->server, num_rqst);
>                 ses->server->sequence_number -= 2;
> +       }
>
>         mutex_unlock(&ses->server->srv_mutex);
>
> --
> 2.7.4
>
