Return-Path: <SRS0=lkMc=RF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B9C2C43381
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 02:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3CD8420815
	for <linux-cifs@archiver.kernel.org>; Sat,  2 Mar 2019 02:30:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="o3Wj3uYB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfCBCaR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 1 Mar 2019 21:30:17 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:45191 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCBCaN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 1 Mar 2019 21:30:13 -0500
Received: by mail-lf1-f66.google.com with SMTP id f16so2168675lfk.12
        for <linux-cifs@vger.kernel.org>; Fri, 01 Mar 2019 18:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=7nrCkHluEspSwJ0h4N1ZuP0cm+jDSY2EGWNotybZvXE=;
        b=o3Wj3uYB3V364Ifq2tdHGzb4sOgaqAWS+N9DxhcPGp3aJVX5QclaPerEXXlR0hCR//
         KnVWA1mQQN/DU88qweQEm2Q85rM8UooAaz/POZQ6aPbAf6vQIHKXcWGRjbBJml6dX+RK
         0KwGxr5iKzfpk6Wvk+8+KESr85UREbgZeWtN1yTYcgkdLhYDAElUp/AXuDAvBGWrL9V8
         QeMwPNjR9ye6J6Wp+qIe3NEVItx4MLnLxTOGl7CWdWE0+M6pzQkEo5yhFpakibqMSnB/
         0cgBJLSPTgvGXnMCLKoNrAbFwh7DIkZOZFocg3Tham1s31p+eBlyvEifVzbEQULngF4k
         RbZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=7nrCkHluEspSwJ0h4N1ZuP0cm+jDSY2EGWNotybZvXE=;
        b=E/YXwroW6wPd1kde5hWWrnxyuabD0hoIdz0sv0+udDkYSaU8D0J+yeL/QxAG6QEdrS
         FT5RTsxA9yLqzZhUMONvtHczy/e+S7WE67BdweBJDHuvl46882ZHrpx2vxXn+Pdf7Q7w
         XIRzHNn8wKU+0vK70n5diuYFuc7H7uRiz1dnFQeyTV3Pj1CP2f5HWm07S76mdcURhF/Z
         QAJlnbB9LUgMWuzAk0cXXzelyfSUMX+UKPgjBx/68QyVSZwvrbPMl70mZdOtW44YcxTa
         gjrzZ+qf+3RcgVkSzK4i4CCyCTnFQotOLDcEp8CsuXAZWcETg3rRrh8YzwyUp+c+caFT
         4T6g==
X-Gm-Message-State: APjAAAWOCW+6Dugyj5EcTX0dU7y3stGAsoHOnhvmiPZ/hr/xL0mf5uDh
        KxeR8Xb39dYRIiMlZzJnWLXqlAQPQj1H7g8ysJmKEVU=
X-Google-Smtp-Source: APXvYqzNo3/4OtwiRtlin71unwCbLv4I4Ezdn/uwHOHm0fGvmHu21bT4kw79YbAJUZuEDH9S0DWqfV7AF2/teahkLro=
X-Received: by 2002:ac2:55ad:: with SMTP id y13mr4814297lfg.97.1551493810049;
 Fri, 01 Mar 2019 18:30:10 -0800 (PST)
MIME-Version: 1.0
References: <1550779366-38445-1-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1550779366-38445-1-git-send-email-pshilov@microsoft.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Fri, 1 Mar 2019 18:29:58 -0800
Message-ID: <CAKywueRnhxyLaqL5sEHBf=i79tabk3drTRk36Q121ViGFOdFZQ@mail.gmail.com>
Subject: Re: [PATCH v2] CIFS: Do not skip SMB2 message IDs on send failures
To:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D1=87=D1=82, 21 =D1=84=D0=B5=D0=B2=D1=80. 2019 =D0=B3. =D0=B2 12:02, Pavel=
 Shilovsky <piastryyy@gmail.com>:
>
> When we hit failures during constructing MIDs or sending PDUs
> through the network, we end up not using message IDs assigned
> to the packet. The next SMB packet will skip those message IDs
> and continue with the next one. This behavior may lead to a server
> not granting us credits until we use the skipped IDs. Fix this by
> reverting the current ID to the original value if any errors occur
> before we push the packet through the network stack.
>
> This patch fixes the generic/310 test from the xfs-tests.
>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/cifsglob.h      | 18 ++++++++++++++++++
>  fs/cifs/smb2ops.c       | 12 ++++++++++++
>  fs/cifs/smb2transport.c | 12 ++++++++++--
>  fs/cifs/transport.c     |  6 +++++-
>  4 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 5bf463c..31c63e7 100644
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
> @@ -789,6 +791,22 @@ get_next_mid(struct TCP_Server_Info *server)
>         return cpu_to_le16(mid);
>  }
>
> +static inline void
> +revert_current_mid(struct TCP_Server_Info *server, const unsigned int va=
l)
> +{
> +       if (server->ops->revert_current_mid)
> +               server->ops->revert_current_mid(server, val);
> +}
> +
> +static inline void
> +revert_current_mid_from_hdr(struct TCP_Server_Info *server,
> +                           const struct smb2_sync_hdr *shdr)
> +{
> +       unsigned int num =3D le16_to_cpu(shdr->CreditCharge);
> +
> +       return revert_current_mid(server, num > 0 ? num : 1);
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
> +smb2_revert_current_mid(struct TCP_Server_Info *server, const unsigned i=
nt val)
> +{
> +       spin_lock(&GlobalMid_Lock);
> +       server->CurrentMid -=3D val;
> +       spin_unlock(&GlobalMid_Lock);
> +}
> +
>  static struct mid_q_entry *
>  smb2_find_mid(struct TCP_Server_Info *server, char *buf)
>  {
> @@ -3606,6 +3614,7 @@ struct smb_version_operations smb20_operations =3D =
{
>         .get_credits =3D smb2_get_credits,
>         .wait_mtu_credits =3D cifs_wait_mtu_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3702,6 +3711,7 @@ struct smb_version_operations smb21_operations =3D =
{
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
>         .adjust_credits =3D smb2_adjust_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3799,6 +3809,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
>         .adjust_credits =3D smb2_adjust_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3905,6 +3916,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
>         .adjust_credits =3D smb2_adjust_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> diff --git a/fs/cifs/smb2transport.c b/fs/cifs/smb2transport.c
> index 7b351c6..5609c0b 100644
> --- a/fs/cifs/smb2transport.c
> +++ b/fs/cifs/smb2transport.c
> @@ -674,13 +674,18 @@ smb2_setup_request(struct cifs_ses *ses, struct smb=
_rqst *rqst)
>         smb2_seq_num_into_buf(ses->server, shdr);
>
>         rc =3D smb2_get_mid_entry(ses, shdr, &mid);
> -       if (rc)
> +       if (rc) {
> +               revert_current_mid_from_hdr(ses->server, shdr);
>                 return ERR_PTR(rc);
> +       }
> +
>         rc =3D smb2_sign_rqst(rqst, ses->server);
>         if (rc) {
> +               revert_current_mid_from_hdr(ses->server, shdr);
>                 cifs_delete_mid(mid);
>                 return ERR_PTR(rc);
>         }
> +
>         return mid;
>  }
>
> @@ -695,11 +700,14 @@ smb2_setup_async_request(struct TCP_Server_Info *se=
rver, struct smb_rqst *rqst)
>         smb2_seq_num_into_buf(server, shdr);
>
>         mid =3D smb2_mid_entry_alloc(shdr, server);
> -       if (mid =3D=3D NULL)
> +       if (mid =3D=3D NULL) {
> +               revert_current_mid_from_hdr(server, shdr);
>                 return ERR_PTR(-ENOMEM);
> +       }
>
>         rc =3D smb2_sign_rqst(rqst, server);
>         if (rc) {
> +               revert_current_mid_from_hdr(server, shdr);
>                 DeleteMidQEntry(mid);
>                 return ERR_PTR(rc);
>         }
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index d4f1224f..849a45d 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -695,6 +695,7 @@ cifs_call_async(struct TCP_Server_Info *server, struc=
t smb_rqst *rqst,
>         cifs_in_send_dec(server);
>
>         if (rc < 0) {
> +               revert_current_mid(server, credits.value);
>                 server->sequence_number -=3D 2;
>                 cifs_delete_mid(mid);
>         }
> @@ -988,6 +989,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>         for (i =3D 0; i < num_rqst; i++) {
>                 midQ[i] =3D ses->server->ops->setup_request(ses, &rqst[i]=
);
>                 if (IS_ERR(midQ[i])) {
> +                       revert_current_mid(ses->server, i);
>                         for (j =3D 0; j < i; j++)
>                                 cifs_delete_mid(midQ[j]);
>                         mutex_unlock(&ses->server->srv_mutex);
> @@ -1017,8 +1019,10 @@ compound_send_recv(const unsigned int xid, struct =
cifs_ses *ses,
>         for (i =3D 0; i < num_rqst; i++)
>                 cifs_save_when_sent(midQ[i]);
>
> -       if (rc < 0)
> +       if (rc < 0) {
> +               revert_current_mid(ses->server, num_rqst);
>                 ses->server->sequence_number -=3D 2;
> +       }
>
>         mutex_unlock(&ses->server->srv_mutex);
>
> --
> 2.7.4
>

Posted v3 to the list:

replaced revert_current_mid with revert_current_mid_from_hdr in
cifs_call_async(), so it is independent from other credit patches and
can be marked for stable and be applied to 4.19.y, 4.20.y and 5.0.y
kernels.

--
Best regards,
Pavel Shilovsky
