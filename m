Return-Path: <SRS0=vRfO=RH=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD10C43381
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 22:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27FBD2070B
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Mar 2019 22:06:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vglZPSid"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbfCDWGM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Mar 2019 17:06:12 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:37526 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726038AbfCDWGM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Mar 2019 17:06:12 -0500
Received: by mail-lf1-f68.google.com with SMTP id z196so4650327lff.4
        for <linux-cifs@vger.kernel.org>; Mon, 04 Mar 2019 14:06:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Lhb7/lDprkCpURPsaI8FZIthSoNfEkaS9fH9fK32EXg=;
        b=vglZPSidqPC5NonGLyWOFqoEhcKr7wt1xjKLvrZU3DGFfjvkhhoHJx9XEVvTrKF/oU
         JZzGPF+AzWK6QPiyPBiUmQRZwZpggXPhxC8HRsx7op8FMce6PjRm7RVS9zJEbRS6AhW5
         gSSWfipST6M3SKqcAqzAn3Llj99Yr75XeS9UfRzMbc9STZNJU44HQP/q17PdkMqmjvQN
         1wBDRHUAkhdl06mD13Lv1TyMBNiSexuF4NvnqWh5ZDVuwJXw4Wbm9UOA3eiDnBgbjsxW
         GIVoELb6q2IewRMcrF5vYuHxaxLxRpS0qUugh2jWre0zOxFTNuC49Dwj8Z8ieRlkQLON
         1SfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Lhb7/lDprkCpURPsaI8FZIthSoNfEkaS9fH9fK32EXg=;
        b=KxwITBqQhJ9eA2VahNzKhju6rISgHs148BjyL7ZPAqz1Z2kbK9dxnHprxY/N0JdM00
         ZhZizALsWe1gDml7AKz370iLItYXUm7rNPzE92CG1vM6xJYYzMpbnxEoCH6WUb4P8juT
         jmiX77VT12JghxkkjHbhlLQ4blqofFf7W+ZCJ+onf4L20efieTHDuoi2DNR0ba7c50JM
         zWNQUbpmGpbHwINNzWagVrwSK6ZeMYjbWiEj3cymkcjhJZ/tE7QipLgu5eM3MPoiVRY/
         Q39pIXfvzkYlTDcj3wGgiSCiqFva7Xx0svhjp7IyruLKvIUoY+GDORdh/Am68Fs9dteO
         Z9XQ==
X-Gm-Message-State: APjAAAUbSwyKJ37p+XABNaMHVBH19PkWpbhDyiC/3Bq/BxqdZQQG+1Yy
        dqvyXFVq9ROtcQIUbn6YkV7W4QdhJpFBPiOpYTrYcFk=
X-Google-Smtp-Source: APXvYqy8c8IideopB+v+FReCjGFXXrgGvDxvJf83q2eUZ1xYvmWoze7euT4evmFvx7C/3RZcqNgn9UiGrvWp1i424F8=
X-Received: by 2002:a19:f506:: with SMTP id j6mr622159lfb.159.1551737169116;
 Mon, 04 Mar 2019 14:06:09 -0800 (PST)
MIME-Version: 1.0
References: <1551493567-97156-1-git-send-email-pshilov@microsoft.com>
In-Reply-To: <1551493567-97156-1-git-send-email-pshilov@microsoft.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 4 Mar 2019 14:05:57 -0800
Message-ID: <CAKywueQG+LeYVWq1PNn_GbwxLaC8iEOZaDHvqW+HZD8D-=BrmA@mail.gmail.com>
Subject: Re: [PATCH v3] CIFS: Do not skip SMB2 message IDs on send failures
To:     linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=BF=D1=82, 1 =D0=BC=D0=B0=D1=80. 2019 =D0=B3. =D0=B2 18:26, Pavel Shilov=
sky <piastryyy@gmail.com>:
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
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Pavel Shilovsky <pshilov@microsoft.com>
> ---
>  fs/cifs/cifsglob.h      | 18 ++++++++++++++++++
>  fs/cifs/smb2ops.c       | 12 ++++++++++++
>  fs/cifs/smb2transport.c | 12 ++++++++++--
>  fs/cifs/transport.c     |  6 +++++-
>  4 files changed, 45 insertions(+), 3 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 33264f9a..fe4eed1 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -236,6 +236,8 @@ struct smb_version_operations {
>         int * (*get_credits_field)(struct TCP_Server_Info *, const int);
>         unsigned int (*get_credits)(struct mid_q_entry *);
>         __u64 (*get_next_mid)(struct TCP_Server_Info *);
> +       void (*revert_current_mid)(struct TCP_Server_Info *server,
> +                                  const unsigned int val);
>         /* data offset from read response message */
>         unsigned int (*read_data_offset)(char *);
>         /*
> @@ -771,6 +773,22 @@ get_next_mid(struct TCP_Server_Info *server)
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
> index 1670494..254d602 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -219,6 +219,14 @@ smb2_get_next_mid(struct TCP_Server_Info *server)
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
> @@ -3560,6 +3568,7 @@ struct smb_version_operations smb20_operations =3D =
{
>         .get_credits =3D smb2_get_credits,
>         .wait_mtu_credits =3D cifs_wait_mtu_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3655,6 +3664,7 @@ struct smb_version_operations smb21_operations =3D =
{
>         .get_credits =3D smb2_get_credits,
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3751,6 +3761,7 @@ struct smb_version_operations smb30_operations =3D =
{
>         .get_credits =3D smb2_get_credits,
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
>         .get_next_mid =3D smb2_get_next_mid,
> +       .revert_current_mid =3D smb2_revert_current_mid,
>         .read_data_offset =3D smb2_read_data_offset,
>         .read_data_length =3D smb2_read_data_length,
>         .map_error =3D map_smb2_to_linux_error,
> @@ -3856,6 +3867,7 @@ struct smb_version_operations smb311_operations =3D=
 {
>         .get_credits =3D smb2_get_credits,
>         .wait_mtu_credits =3D smb2_wait_mtu_credits,
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
> index 53532bd..d680c7b 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -647,6 +647,7 @@ cifs_call_async(struct TCP_Server_Info *server, struc=
t smb_rqst *rqst,
>         cifs_in_send_dec(server);
>
>         if (rc < 0) {
> +               revert_current_mid_from_hdr(server, rqst->rq_iov[0].iov_b=
ase);
>                 server->sequence_number -=3D 2;
>                 cifs_delete_mid(mid);
>         }
> @@ -868,6 +869,7 @@ compound_send_recv(const unsigned int xid, struct cif=
s_ses *ses,
>         for (i =3D 0; i < num_rqst; i++) {
>                 midQ[i] =3D ses->server->ops->setup_request(ses, &rqst[i]=
);
>                 if (IS_ERR(midQ[i])) {
> +                       revert_current_mid(ses->server, i);
>                         for (j =3D 0; j < i; j++)
>                                 cifs_delete_mid(midQ[j]);
>                         mutex_unlock(&ses->server->srv_mutex);
> @@ -897,8 +899,10 @@ compound_send_recv(const unsigned int xid, struct ci=
fs_ses *ses,
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

posted V4 with the following changes since V3:

- fixed mid miscalculation for encrypted requests in cifs_call_async
- added mid->credits to contain the number of credits consumed by the mid
- prevented server->CurrentMid to go negative and then be converted to u64

--
Best regards,
Pavel Shilovsky
