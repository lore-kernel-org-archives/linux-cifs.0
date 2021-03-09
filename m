Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26E1BC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF18C6529C
	for <linux-cifs@archiver.kernel.org>; Tue,  9 Mar 2021 00:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhCIAnt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 8 Mar 2021 19:43:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCIAns (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 8 Mar 2021 19:43:48 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B39C06174A
        for <linux-cifs@vger.kernel.org>; Mon,  8 Mar 2021 16:43:48 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id f20so12046949ioo.10
        for <linux-cifs@vger.kernel.org>; Mon, 08 Mar 2021 16:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=iqOn2WC49AnJcoX4zVp14mCaebdCj8jgrbXfZPWrSLI=;
        b=nAX8PYSq2bAQpPZsHaFrC+z4BYWv/Gi+h+A83oR49KQV5QASPiyB27T4nh2ph9ZBlw
         3j8KGWhXapyvyxhBAaPiuBbzIxmVvO2I0QXH7VrAeHaMkm7MeKpUEtr8KJb5JJzDeIto
         sUr8sVUyQwWtCY8jMW+7ktgHafbgH6sf1TngT/b/5K2vBY8A07bgyyZBKKOxAkLK6WUB
         Z3Rt43av4IgmBgtbALdJACZmIX0MZDrPeIQEXLSH5HhV4SfzT70bTWPn4DpbntuPzfty
         /BDDgoQLZ8IAYw1+rQy4voA2a1cabSjp2A/BIOkhYr+ETE2cjPIU1JMJKQxuPhMbQJTC
         0vNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iqOn2WC49AnJcoX4zVp14mCaebdCj8jgrbXfZPWrSLI=;
        b=HuW5MC3zdIkCcQE4Bsa3mr77rj+oo9ywgFyKcFpU/G1V5gIe2uEw0zjk11Xeu+8twA
         Bu6HGZivb5Plck+XSUuuXB8O/g2gAgXCpIIzSovMQ+wjnqPj9CWIS1LqtxL4DWa6YZnZ
         Ec3ZU8n40OdbEfl8sTmPvje+1sir6pdjZOOHT2WDiyz45JQ0yrT8kI/nDAXNLhWkcbd7
         5LsV4WOedBUEoI3fIkuPxd4Zwc57G8Qj4Fyu7vXkqpmQMysUUpJs282PeHu9ljk6IxW1
         RjKx3WP/97N6ZPn4fsr1NlydhY902BaZya6kFbeQpzzyrkPZ1yxK+TWgfb/N+X60xQ+K
         o0xA==
X-Gm-Message-State: AOAM530zSzjeRNGbb0jkjkMFX7GIKyCGBHqg8TLHhH/9ShkPONH5tgCZ
        wl3zTdxWt+cHeB5kzNj356N5W9GRagwb88+L9c0=
X-Google-Smtp-Source: ABdhPJzp8Mf7XkUm4qCwGRmPygooJ0hgayDCOJdye2vXfbJMjiP6e1DW6xPaxTRdxs1ga23XIEaL0/S2qlqAiUZsBPo=
X-Received: by 2002:a05:6638:218f:: with SMTP id s15mr26290106jaj.58.1615250627658;
 Mon, 08 Mar 2021 16:43:47 -0800 (PST)
MIME-Version: 1.0
References: <20210308150050.19902-1-pc@cjr.nz> <20210308150050.19902-4-pc@cjr.nz>
In-Reply-To: <20210308150050.19902-4-pc@cjr.nz>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 9 Mar 2021 10:43:35 +1000
Message-ID: <CAN05THT9cbwnySBkNSNkWXaRXXuTFyJ_cjKk1oqG57QJKFE38Q@mail.gmail.com>
Subject: Re: [PATCH 4/4] cifs: do not send close in compound create+close requests
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

reviewed-by me

On Tue, Mar 9, 2021 at 1:02 AM Paulo Alcantara <pc@cjr.nz> wrote:
>
> In case of interrupted syscalls, prevent sending CLOSE commands for
> compound CREATE+CLOSE requests by introducing an
> CIFS_CP_CREATE_CLOSE_OP flag to indicate lower layers that it should
> not send a CLOSE command to the MIDs corresponding the compound
> CREATE+CLOSE request.
>
> A simple reproducer:
>
>     #!/bin/bash
>
>     mount //server/share /mnt -o username=3Dfoo,password=3D***
>     tc qdisc add dev eth0 root netem delay 450ms
>     stat -f /mnt &>/dev/null & pid=3D$!
>     sleep 0.01
>     kill $pid
>     tc qdisc del dev eth0 root
>     umount /mnt
>
> Before patch:
>
>     ...
>     6 0.256893470 192.168.122.2 =E2=86=92 192.168.122.15 SMB2 402 Create =
Request File: ;GetInfo Request FS_INFO/FileFsFullSizeInformation;Close Requ=
est
>     7 0.257144491 192.168.122.15 =E2=86=92 192.168.122.2 SMB2 498 Create =
Response File: ;GetInfo Response;Close Response
>     9 0.260798209 192.168.122.2 =E2=86=92 192.168.122.15 SMB2 146 Close R=
equest File:
>    10 0.260841089 192.168.122.15 =E2=86=92 192.168.122.2 SMB2 130 Close R=
esponse, Error: STATUS_FILE_CLOSED
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/cifsglob.h  | 19 ++++++++++---------
>  fs/cifs/smb2inode.c |  1 +
>  fs/cifs/smb2misc.c  |  8 ++++----
>  fs/cifs/smb2ops.c   | 10 +++++-----
>  fs/cifs/smb2proto.h |  3 +--
>  fs/cifs/transport.c |  2 +-
>  6 files changed, 22 insertions(+), 21 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 3de3c5908a72..31fc8695abd6 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -257,7 +257,7 @@ struct smb_version_operations {
>         /* verify the message */
>         int (*check_message)(char *, unsigned int, struct TCP_Server_Info=
 *);
>         bool (*is_oplock_break)(char *, struct TCP_Server_Info *);
> -       int (*handle_cancelled_mid)(char *, struct TCP_Server_Info *);
> +       int (*handle_cancelled_mid)(struct mid_q_entry *, struct TCP_Serv=
er_Info *);
>         void (*downgrade_oplock)(struct TCP_Server_Info *server,
>                                  struct cifsInodeInfo *cinode, __u32 oplo=
ck,
>                                  unsigned int epoch, bool *purge_cache);
> @@ -1705,16 +1705,17 @@ static inline bool is_retryable_error(int error)
>  #define   CIFS_NO_RSP_BUF   0x040    /* no response buffer required */
>
>  /* Type of request operation */
> -#define   CIFS_ECHO_OP      0x080    /* echo request */
> -#define   CIFS_OBREAK_OP   0x0100    /* oplock break request */
> -#define   CIFS_NEG_OP      0x0200    /* negotiate request */
> +#define   CIFS_ECHO_OP            0x080  /* echo request */
> +#define   CIFS_OBREAK_OP          0x0100 /* oplock break request */
> +#define   CIFS_NEG_OP             0x0200 /* negotiate request */
> +#define   CIFS_CP_CREATE_CLOSE_OP 0x0400 /* compound create+close reques=
t */
>  /* Lower bitmask values are reserved by others below. */
> -#define   CIFS_SESS_OP     0x2000    /* session setup request */
> -#define   CIFS_OP_MASK     0x2380    /* mask request type */
> +#define   CIFS_SESS_OP            0x2000 /* session setup request */
> +#define   CIFS_OP_MASK            0x2780 /* mask request type */
>
> -#define   CIFS_HAS_CREDITS 0x0400    /* already has credits */
> -#define   CIFS_TRANSFORM_REQ 0x0800    /* transform request before sendi=
ng */
> -#define   CIFS_NO_SRV_RSP    0x1000    /* there is no server response */
> +#define   CIFS_HAS_CREDITS        0x0400 /* already has credits */
> +#define   CIFS_TRANSFORM_REQ      0x0800 /* transform request before sen=
ding */
> +#define   CIFS_NO_SRV_RSP         0x1000 /* there is no server response =
*/
>
>  /* Security Flags: indicate type of session setup needed */
>  #define   CIFSSEC_MAY_SIGN     0x00001
> diff --git a/fs/cifs/smb2inode.c b/fs/cifs/smb2inode.c
> index 1f900b81c34a..a718dc77e604 100644
> --- a/fs/cifs/smb2inode.c
> +++ b/fs/cifs/smb2inode.c
> @@ -358,6 +358,7 @@ smb2_compound_op(const unsigned int xid, struct cifs_=
tcon *tcon,
>         if (cfile)
>                 goto after_close;
>         /* Close */
> +       flags |=3D CIFS_CP_CREATE_CLOSE_OP;
>         rqst[num_rqst].rq_iov =3D &vars->close_iov[0];
>         rqst[num_rqst].rq_nvec =3D 1;
>         rc =3D SMB2_close_init(tcon, server,
> diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> index 0a55a77d94de..c99966121757 100644
> --- a/fs/cifs/smb2misc.c
> +++ b/fs/cifs/smb2misc.c
> @@ -844,14 +844,14 @@ smb2_handle_cancelled_close(struct cifs_tcon *tcon,=
 __u64 persistent_fid,
>  }
>
>  int
> -smb2_handle_cancelled_mid(char *buffer, struct TCP_Server_Info *server)
> +smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP_Server_Inf=
o *server)
>  {
> -       struct smb2_sync_hdr *sync_hdr =3D (struct smb2_sync_hdr *)buffer=
;
> -       struct smb2_create_rsp *rsp =3D (struct smb2_create_rsp *)buffer;
> +       struct smb2_sync_hdr *sync_hdr =3D mid->resp_buf;
> +       struct smb2_create_rsp *rsp =3D mid->resp_buf;
>         struct cifs_tcon *tcon;
>         int rc;
>
> -       if (sync_hdr->Command !=3D SMB2_CREATE ||
> +       if ((mid->optype & CIFS_CP_CREATE_CLOSE_OP) || sync_hdr->Command =
!=3D SMB2_CREATE ||
>             sync_hdr->Status !=3D STATUS_SUCCESS)
>                 return 0;
>
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index f5087295424c..9bae7e8deb09 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -1195,7 +1195,7 @@ smb2_set_ea(const unsigned int xid, struct cifs_tco=
n *tcon,
>         struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
>         __le16 *utf16_path =3D NULL;
>         int ea_name_len =3D strlen(ea_name);
> -       int flags =3D 0;
> +       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         int len;
>         struct smb_rqst rqst[3];
>         int resp_buftype[3];
> @@ -1573,7 +1573,7 @@ smb2_ioctl_query_info(const unsigned int xid,
>         struct smb_query_info qi;
>         struct smb_query_info __user *pqi;
>         int rc =3D 0;
> -       int flags =3D 0;
> +       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         struct smb2_query_info_rsp *qi_rsp =3D NULL;
>         struct smb2_ioctl_rsp *io_rsp =3D NULL;
>         void *buffer =3D NULL;
> @@ -2577,7 +2577,7 @@ smb2_query_info_compound(const unsigned int xid, st=
ruct cifs_tcon *tcon,
>  {
>         struct cifs_ses *ses =3D tcon->ses;
>         struct TCP_Server_Info *server =3D cifs_pick_channel(ses);
> -       int flags =3D 0;
> +       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         struct smb_rqst rqst[3];
>         int resp_buftype[3];
>         struct kvec rsp_iov[3];
> @@ -2975,7 +2975,7 @@ smb2_query_symlink(const unsigned int xid, struct c=
ifs_tcon *tcon,
>         unsigned int sub_offset;
>         unsigned int print_len;
>         unsigned int print_offset;
> -       int flags =3D 0;
> +       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         struct smb_rqst rqst[3];
>         int resp_buftype[3];
>         struct kvec rsp_iov[3];
> @@ -3157,7 +3157,7 @@ smb2_query_reparse_tag(const unsigned int xid, stru=
ct cifs_tcon *tcon,
>         struct cifs_open_parms oparms;
>         struct cifs_fid fid;
>         struct TCP_Server_Info *server =3D cifs_pick_channel(tcon->ses);
> -       int flags =3D 0;
> +       int flags =3D CIFS_CP_CREATE_CLOSE_OP;
>         struct smb_rqst rqst[3];
>         int resp_buftype[3];
>         struct kvec rsp_iov[3];
> diff --git a/fs/cifs/smb2proto.h b/fs/cifs/smb2proto.h
> index 9565e27681a5..a2eb34a8d9c9 100644
> --- a/fs/cifs/smb2proto.h
> +++ b/fs/cifs/smb2proto.h
> @@ -246,8 +246,7 @@ extern int SMB2_oplock_break(const unsigned int xid, =
struct cifs_tcon *tcon,
>  extern int smb2_handle_cancelled_close(struct cifs_tcon *tcon,
>                                        __u64 persistent_fid,
>                                        __u64 volatile_fid);
> -extern int smb2_handle_cancelled_mid(char *buffer,
> -                                       struct TCP_Server_Info *server);
> +extern int smb2_handle_cancelled_mid(struct mid_q_entry *mid, struct TCP=
_Server_Info *server);
>  void smb2_cancelled_close_fid(struct work_struct *work);
>  extern int SMB2_QFS_info(const unsigned int xid, struct cifs_tcon *tcon,
>                          u64 persistent_file_id, u64 volatile_file_id,
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index f62f512e2cb1..9438a0c35473 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -109,7 +109,7 @@ static void _cifs_mid_q_entry_release(struct kref *re=
fcount)
>         if (midEntry->resp_buf && (midEntry->mid_flags & MID_WAIT_CANCELL=
ED) &&
>             midEntry->mid_state =3D=3D MID_RESPONSE_RECEIVED &&
>             server->ops->handle_cancelled_mid)
> -               server->ops->handle_cancelled_mid(midEntry->resp_buf, ser=
ver);
> +               server->ops->handle_cancelled_mid(midEntry, server);
>
>         midEntry->mid_state =3D MID_FREE;
>         atomic_dec(&midCount);
> --
> 2.30.1
>
