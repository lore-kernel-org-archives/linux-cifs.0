Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D6AC04A6B
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 18:46:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93CB820675
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 18:46:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CKUc46yF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbfEFSqL (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 May 2019 14:46:11 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:35451 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbfEFSqL (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 May 2019 14:46:11 -0400
Received: by mail-lf1-f66.google.com with SMTP id j20so9928224lfh.2
        for <linux-cifs@vger.kernel.org>; Mon, 06 May 2019 11:46:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jF9sU+aVlaWy7UekbLrzzFMvSLQttlpmuI4HH1zhVxI=;
        b=CKUc46yF3WjkCO3j8QNNpSoY2DleWh/ADZR3zkgvA1deATLg1J4PNTH7j3wLDSwLrW
         7FC2asjJJztm5VmLp8GgYukKLNtbucX8bVrtzN95VntUtaz4EEQBu1RobFf0JIwzFMyf
         6fHqqvpj3fy5ayQtTZHjbrxKiZibZFFW0LrOYvs28Bd5NY6ok9XL0NZASSm8dCWosOre
         rDDsvHuvJaNHV+ihQgOdLaT1jszwwh8zho2rB+lt5apKqkXOvlVCTDt/A9UhQV7lWTzd
         sekI/jg7xBdcLWge4UXnYVixCzD6iH+y3dWtdO9IOX6b6+JwIkU739sZIvhwLhXaXogn
         W+Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jF9sU+aVlaWy7UekbLrzzFMvSLQttlpmuI4HH1zhVxI=;
        b=pUQ3uz7DI4I1n/07ioC9DP/NbtI03Y9JjhAde6hHJdXU08p5L5YC2ZXV1sE42lCUAD
         QUPzddbmXjqa2/hLkKHfDN9yY7sAAFoXKGDqPecT8xZFERoosHJyoMToHo1JJcdwTw4A
         qTjMfgWmmrf2Mxc7ppLdCLDqPYtQnr6H1sfhrUShRUDW6jy7AJCYdMJsMyXXAt+/bvcz
         uN6qyy7dOnq0M/aGe++IGGSp1+IKDaEzsbsHhkf57Cj2pmblaVKjz9++6iiAJVJ/oUBn
         stg7yke5RHqHAYr6MNgPqj9l/vNiXBZndZyABac+QWrbj89eh4CiA0YPYxoqY0cxvt1u
         Loaw==
X-Gm-Message-State: APjAAAWMoHDbxvDZJA8O3+tkJfi1INu5aV2XeqsClAdg7+VMAsLC8Fs+
        lzxQnMfFI25gs9STEA89VF4Qn+akQ3o1Nqu4Ig==
X-Google-Smtp-Source: APXvYqzNYhU2JnC8AyXB/5Issd1tXWBYP4YD2rCCMWVMyMA2t++DXFXF1QD3MonAge9MmcBmNYnpqMT5we3DXXREVM4=
X-Received: by 2002:ac2:4109:: with SMTP id b9mr13373405lfi.90.1557168368469;
 Mon, 06 May 2019 11:46:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190506000002.32556-1-lsahlber@redhat.com>
In-Reply-To: <20190506000002.32556-1-lsahlber@redhat.com>
From:   Pavel Shilovsky <piastryyy@gmail.com>
Date:   Mon, 6 May 2019 11:45:57 -0700
Message-ID: <CAKywueQmPGTnszKuA0HBZvXxcgU84-FbVdjaG4icNhHT5iLRQg@mail.gmail.com>
Subject: Re: [PATCH] cifs: rename and clarify CIFS_ASYNC_OP and CIFS_NO_RESP
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

=D0=B2=D1=81, 5 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 17:02, Ronnie Sahlbe=
rg <lsahlber@redhat.com>:
>
> The flags were named confusingly.
> CIFS_ASYNC_OP now just means that we will not block waiting for credits
> to become available so we thus rename this to be CIFS_NON_BLOCKING.
>
> Change CIFS_NO_RESP to CIFS_NO_RSP_BUF to clarify that we will actually g=
et a
> response from the server but we will not get/do not want a response buffe=
r.
>
> Delete CIFSSMBNotify. This is an SMB1 function that is not used.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/cifsglob.h  |  4 +--
>  fs/cifs/cifssmb.c   | 98 +++--------------------------------------------=
------
>  fs/cifs/smb2pdu.c   | 10 +++---
>  fs/cifs/transport.c |  9 ++---
>  4 files changed, 14 insertions(+), 107 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index cff7167ffef2..d26a52db1dad 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -1690,11 +1690,11 @@ static inline bool is_retryable_error(int error)
>
>  /* Type of Request to SendReceive2 */
>  #define   CIFS_BLOCKING_OP      1    /* operation can block */
> -#define   CIFS_ASYNC_OP         2    /* do not wait for response */
> +#define   CIFS_NON_BLOCKING     2    /* do not block waiting for credits=
 */
>  #define   CIFS_TIMEOUT_MASK 0x003    /* only one of above set in req */
>  #define   CIFS_LOG_ERROR    0x010    /* log NT STATUS if non-zero */
>  #define   CIFS_LARGE_BUF_OP 0x020    /* large request buffer */
> -#define   CIFS_NO_RESP      0x040    /* no response buffer required */
> +#define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
>
>  /* Type of request operation */
>  #define   CIFS_ECHO_OP      0x080    /* echo request */
> diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
> index 6050851edcb8..1fbd92843a73 100644
> --- a/fs/cifs/cifssmb.c
> +++ b/fs/cifs/cifssmb.c
> @@ -860,7 +860,7 @@ CIFSSMBEcho(struct TCP_Server_Info *server)
>         iov[1].iov_base =3D (char *)smb + 4;
>
>         rc =3D cifs_call_async(server, &rqst, NULL, cifs_echo_callback, N=
ULL,
> -                            server, CIFS_ASYNC_OP | CIFS_ECHO_OP, NULL);
> +                            server, CIFS_NON_BLOCKING | CIFS_ECHO_OP, NU=
LL);
>         if (rc)
>                 cifs_dbg(FYI, "Echo request failed: %d\n", rc);
>
> @@ -2508,8 +2508,8 @@ int cifs_lockv(const unsigned int xid, struct cifs_=
tcon *tcon,
>         iov[1].iov_len =3D (num_unlock + num_lock) * sizeof(LOCKING_ANDX_=
RANGE);
>
>         cifs_stats_inc(&tcon->stats.cifs_stats.num_locks);
> -       rc =3D SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type, CIFS_=
NO_RESP,
> -                         &rsp_iov);
> +       rc =3D SendReceive2(xid, tcon->ses, iov, 2, &resp_buf_type,
> +                         CIFS_NO_RSP_BUF, &rsp_iov);
>         cifs_small_buf_release(pSMB);
>         if (rc)
>                 cifs_dbg(FYI, "Send error in cifs_lockv =3D %d\n", rc);
> @@ -2540,7 +2540,7 @@ CIFSSMBLock(const unsigned int xid, struct cifs_tco=
n *tcon,
>
>         if (lockType =3D=3D LOCKING_ANDX_OPLOCK_RELEASE) {
>                 /* no response expected */
> -               flags =3D CIFS_NO_SRV_RSP | CIFS_ASYNC_OP | CIFS_OBREAK_O=
P;
> +               flags =3D CIFS_NO_SRV_RSP | CIFS_NON_BLOCKING | CIFS_OBRE=
AK_OP;
>                 pSMB->Timeout =3D 0;
>         } else if (waitFlag) {
>                 flags =3D CIFS_BLOCKING_OP; /* blocking operation, no tim=
eout */
> @@ -6567,93 +6567,3 @@ CIFSSMBSetEA(const unsigned int xid, struct cifs_t=
con *tcon,
>         return rc;
>  }
>  #endif
> -
> -#ifdef CONFIG_CIFS_DNOTIFY_EXPERIMENTAL /* BB unused temporarily */
> -/*
> - *     Years ago the kernel added a "dnotify" function for Samba server,
> - *     to allow network clients (such as Windows) to display updated
> - *     lists of files in directory listings automatically when
> - *     files are added by one user when another user has the
> - *     same directory open on their desktop.  The Linux cifs kernel
> - *     client hooked into the kernel side of this interface for
> - *     the same reason, but ironically when the VFS moved from
> - *     "dnotify" to "inotify" it became harder to plug in Linux
> - *     network file system clients (the most obvious use case
> - *     for notify interfaces is when multiple users can update
> - *     the contents of the same directory - exactly what network
> - *     file systems can do) although the server (Samba) could
> - *     still use it.  For the short term we leave the worker
> - *     function ifdeffed out (below) until inotify is fixed
> - *     in the VFS to make it easier to plug in network file
> - *     system clients.  If inotify turns out to be permanently
> - *     incompatible for network fs clients, we could instead simply
> - *     expose this config flag by adding a future cifs (and smb2) notify=
 ioctl.
> - */
> -int CIFSSMBNotify(const unsigned int xid, struct cifs_tcon *tcon,
> -                 const int notify_subdirs, const __u16 netfid,
> -                 __u32 filter, struct file *pfile, int multishot,
> -                 const struct nls_table *nls_codepage)
> -{
> -       int rc =3D 0;
> -       struct smb_com_transaction_change_notify_req *pSMB =3D NULL;
> -       struct smb_com_ntransaction_change_notify_rsp *pSMBr =3D NULL;
> -       struct dir_notify_req *dnotify_req;
> -       int bytes_returned;
> -
> -       cifs_dbg(FYI, "In CIFSSMBNotify for file handle %d\n", (int)netfi=
d);
> -       rc =3D smb_init(SMB_COM_NT_TRANSACT, 23, tcon, (void **) &pSMB,
> -                     (void **) &pSMBr);
> -       if (rc)
> -               return rc;
> -
> -       pSMB->TotalParameterCount =3D 0 ;
> -       pSMB->TotalDataCount =3D 0;
> -       pSMB->MaxParameterCount =3D cpu_to_le32(2);
> -       pSMB->MaxDataCount =3D cpu_to_le32(CIFSMaxBufSize & 0xFFFFFF00);
> -       pSMB->MaxSetupCount =3D 4;
> -       pSMB->Reserved =3D 0;
> -       pSMB->ParameterOffset =3D 0;
> -       pSMB->DataCount =3D 0;
> -       pSMB->DataOffset =3D 0;
> -       pSMB->SetupCount =3D 4; /* single byte does not need le conversio=
n */
> -       pSMB->SubCommand =3D cpu_to_le16(NT_TRANSACT_NOTIFY_CHANGE);
> -       pSMB->ParameterCount =3D pSMB->TotalParameterCount;
> -       if (notify_subdirs)
> -               pSMB->WatchTree =3D 1; /* one byte - no le conversion nee=
ded */
> -       pSMB->Reserved2 =3D 0;
> -       pSMB->CompletionFilter =3D cpu_to_le32(filter);
> -       pSMB->Fid =3D netfid; /* file handle always le */
> -       pSMB->ByteCount =3D 0;
> -
> -       rc =3D SendReceive(xid, tcon->ses, (struct smb_hdr *) pSMB,
> -                        (struct smb_hdr *)pSMBr, &bytes_returned,
> -                        CIFS_ASYNC_OP);
> -       if (rc) {
> -               cifs_dbg(FYI, "Error in Notify =3D %d\n", rc);
> -       } else {
> -               /* Add file to outstanding requests */
> -               /* BB change to kmem cache alloc */
> -               dnotify_req =3D kmalloc(
> -                                               sizeof(struct dir_notify_=
req),
> -                                                GFP_KERNEL);
> -               if (dnotify_req) {
> -                       dnotify_req->Pid =3D pSMB->hdr.Pid;
> -                       dnotify_req->PidHigh =3D pSMB->hdr.PidHigh;
> -                       dnotify_req->Mid =3D pSMB->hdr.Mid;
> -                       dnotify_req->Tid =3D pSMB->hdr.Tid;
> -                       dnotify_req->Uid =3D pSMB->hdr.Uid;
> -                       dnotify_req->netfid =3D netfid;
> -                       dnotify_req->pfile =3D pfile;
> -                       dnotify_req->filter =3D filter;
> -                       dnotify_req->multishot =3D multishot;
> -                       spin_lock(&GlobalMid_Lock);
> -                       list_add_tail(&dnotify_req->lhead,
> -                                       &GlobalDnotifyReqList);
> -                       spin_unlock(&GlobalMid_Lock);
> -               } else
> -                       rc =3D -ENOMEM;
> -       }
> -       cifs_buf_release(pSMB);
> -       return rc;
> -}
> -#endif /* was needed for dnotify, and will be needed for inotify when VF=
S fix */
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 82e2a27bccc0..85f00edcbd16 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1583,7 +1583,7 @@ SMB2_logoff(const unsigned int xid, struct cifs_ses=
 *ses)
>         else if (server->sign)
>                 req->sync_hdr.Flags |=3D SMB2_FLAGS_SIGNED;
>
> -       flags |=3D CIFS_NO_RESP;
> +       flags |=3D CIFS_NO_RSP_BUF;
>
>         iov[0].iov_base =3D (char *)req;
>         iov[0].iov_len =3D total_len;
> @@ -1784,7 +1784,7 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon =
*tcon)
>         if (smb3_encryption_required(tcon))
>                 flags |=3D CIFS_TRANSFORM_REQ;
>
> -       flags |=3D CIFS_NO_RESP;
> +       flags |=3D CIFS_NO_RSP_BUF;
>
>         iov[0].iov_base =3D (char *)req;
>         iov[0].iov_len =3D total_len;
> @@ -4211,7 +4211,7 @@ SMB2_oplock_break(const unsigned int xid, struct ci=
fs_tcon *tcon,
>         req->OplockLevel =3D oplock_level;
>         req->sync_hdr.CreditRequest =3D cpu_to_le16(1);
>
> -       flags |=3D CIFS_NO_RESP;
> +       flags |=3D CIFS_NO_RSP_BUF;
>
>         iov[0].iov_base =3D (char *)req;
>         iov[0].iov_len =3D total_len;
> @@ -4485,7 +4485,7 @@ smb2_lockv(const unsigned int xid, struct cifs_tcon=
 *tcon,
>         struct kvec rsp_iov;
>         int resp_buf_type;
>         unsigned int count;
> -       int flags =3D CIFS_NO_RESP;
> +       int flags =3D CIFS_NO_RSP_BUF;
>         unsigned int total_len;
>
>         cifs_dbg(FYI, "smb2_lockv num lock %d\n", num_lock);
> @@ -4578,7 +4578,7 @@ SMB2_lease_break(const unsigned int xid, struct cif=
s_tcon *tcon,
>         memcpy(req->LeaseKey, lease_key, 16);
>         req->LeaseState =3D lease_state;
>
> -       flags |=3D CIFS_NO_RESP;
> +       flags |=3D CIFS_NO_RSP_BUF;
>
>         iov[0].iov_base =3D (char *)req;
>         iov[0].iov_len =3D total_len;
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index 5573e38b13f3..9a16ff4b9f5e 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -529,7 +529,7 @@ wait_for_free_credits(struct TCP_Server_Info *server,=
 const int num_credits,
>                 return -EAGAIN;
>
>         spin_lock(&server->req_lock);
> -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP) {
> +       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_NON_BLOCKING) {
>                 /* oplock breaks must not be held up */
>                 server->in_flight++;
>                 *credits -=3D 1;
> @@ -838,7 +838,7 @@ SendReceiveNoRsp(const unsigned int xid, struct cifs_=
ses *ses,
>
>         iov[0].iov_base =3D in_buf;
>         iov[0].iov_len =3D get_rfc1002_length(in_buf) + 4;
> -       flags |=3D CIFS_NO_RESP;
> +       flags |=3D CIFS_NO_RSP_BUF;
>         rc =3D SendReceive2(xid, ses, iov, 1, &resp_buf_type, flags, &rsp=
_iov);
>         cifs_dbg(NOISY, "SendRcvNoRsp flags %d rc %d\n", flags, rc);
>
> @@ -1151,7 +1151,7 @@ compound_send_recv(const unsigned int xid, struct c=
ifs_ses *ses,
>                                                      flags & CIFS_LOG_ERR=
OR);
>
>                 /* mark it so buf will not be freed by cifs_delete_mid */
> -               if ((flags & CIFS_NO_RESP) =3D=3D 0)
> +               if ((flags & CIFS_NO_RSP_BUF) =3D=3D 0)
>                         midQ[i]->resp_buf =3D NULL;
>
>         }
> @@ -1302,9 +1302,6 @@ SendReceive(const unsigned int xid, struct cifs_ses=
 *ses,
>         if (rc < 0)
>                 goto out;
>
> -       if ((flags & CIFS_TIMEOUT_MASK) =3D=3D CIFS_ASYNC_OP)
> -               goto out;
> -
>         rc =3D wait_for_response(ses->server, midQ);
>         if (rc !=3D 0) {
>                 send_cancel(ses->server, &rqst, midQ);
> --
> 2.13.6
>

Looks good

Reviewed-by: Pavel Shilovsky <pshilov@microsoft.com>

--
Best regards,
Pavel Shilovsky
