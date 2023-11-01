Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9E7C4332F
	for <linux-cifs@archiver.kernel.org>; Wed,  1 Nov 2023 03:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjKADaZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 23:30:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231924AbjKADaY (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 23:30:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D00B9
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:30:20 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id 2adb3069b0e04-507c1936fd5so490640e87.1
        for <linux-cifs@vger.kernel.org>; Tue, 31 Oct 2023 20:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698809418; x=1699414218; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rLy+eCHcpUx16byVdIwKtNlDqZnO2zFS+DqgVGCMlRQ=;
        b=IvBNWPrc44BpqvMKv7HxRzlZOw8GZnOI0U01slSCuscGRyV+Ue4reaFPDEPbYJNfj9
         j8+pCABR1jlgZQwUtBpp6T1oFE+AuJgsLQRJ68IPKofyveUGAhgyZXf2VWhjDijvo8WK
         cYis3JqZfIDmukZMYFKHs33GHYn5OnjR9hDCbyjI3ENIyRBpCUXLgdGn8zcc1KNOR0if
         yVbg30I8D+W52K5MTncMJOw+2JTIUpyVFQLz+ZBIUok1OqGNunnu3SnwSlf8VXlAM97X
         +DR/iGURsd24lQQszEf0DmuH9/SMbOK2n6P0J1Z5n1urGA5mx+04GnEqBtYYFTpkRsS8
         OCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698809418; x=1699414218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rLy+eCHcpUx16byVdIwKtNlDqZnO2zFS+DqgVGCMlRQ=;
        b=cy2/0/wDrd1VnJ/qjPTGUIcXQxV7KARbqS1ZYKm81DKwBWL2BXMFhXMIXzXDROGFK4
         sVIkKkb1C30LnEt8L1i4dpzquLt/9QG8BC8Y3TjD+3YlDvgxq1g36NC7tGEza/ajBgud
         JKC8yXODDBnAbp2XBYEbcRMik9MhRxcixKDOm7MqfFnaz6+oYQl32h29wPT1pB7EM2wx
         aETPEcZqDB7/NgikQR1pJJH2ZEEldpNLhse+kVFF7KqSJql5d+J3CWWUVHfpOJYnO+dh
         zvTE/Nn5u9DxcAEU7WY6aw2w8mxAEmTlXxYu0QX2DhTScxdtaWy57awO6okHgxkZtEc4
         mLgQ==
X-Gm-Message-State: AOJu0YzRU7U5H/5jG8UUB35AOBNx1IkFNjkhPeD94l2zY0JsYlHhpjQQ
        PJxucBFOxd0LjUg05O/b37bP45sB2KlTQOFmPCM=
X-Google-Smtp-Source: AGHT+IHUVS8tDlzZg5rEylJLIYbSfbXh+kZSZHVsFyipMB56sKcOMYc16u1hM+NWsUw8jePCU1NvkTMCRvANiBlDpnE=
X-Received: by 2002:a05:6512:ac6:b0:4fd:c8fb:eb71 with SMTP id
 n6-20020a0565120ac600b004fdc8fbeb71mr1876042lfu.11.1698809417675; Tue, 31 Oct
 2023 20:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20231030110020.45627-1-sprasad@microsoft.com> <20231030110020.45627-11-sprasad@microsoft.com>
In-Reply-To: <20231030110020.45627-11-sprasad@microsoft.com>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Oct 2023 22:30:06 -0500
Message-ID: <CAH2r5msNBJd2aSp9X8C3PChRvJN87ztq_478XiM6NG9ahha1wQ@mail.gmail.com>
Subject: Re: [PATCH 11/14] cifs: handle when server starts supporting multichannel
To:     nspmangalore@gmail.com
Cc:     pc@manguebit.com, bharathsm.hsk@gmail.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next pending more testing

added cc:stable

On Mon, Oct 30, 2023 at 6:00=E2=80=AFAM <nspmangalore@gmail.com> wrote:
>
> From: Shyam Prasad N <sprasad@microsoft.com>
>
> When the user mounts with multichannel option, but the
> server does not support it, there can be a time in future
> where it can be supported.
>
> With this change, such a case is handled.
>
> Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
> ---
>  fs/smb/client/cifsproto.h |  4 ++++
>  fs/smb/client/connect.c   |  6 +++++-
>  fs/smb/client/smb2pdu.c   | 31 ++++++++++++++++++++++++++++---
>  3 files changed, 37 insertions(+), 4 deletions(-)
>
> diff --git a/fs/smb/client/cifsproto.h b/fs/smb/client/cifsproto.h
> index 65c84b3d1a65..5a4c1f1e0d91 100644
> --- a/fs/smb/client/cifsproto.h
> +++ b/fs/smb/client/cifsproto.h
> @@ -132,6 +132,10 @@ extern int SendReceiveBlockingLock(const unsigned in=
t xid,
>                         struct smb_hdr *in_buf,
>                         struct smb_hdr *out_buf,
>                         int *bytes_returned);
> +
> +void
> +smb2_query_server_interfaces(struct work_struct *work);
> +
>  void
>  cifs_signal_cifsd_for_reconnect(struct TCP_Server_Info *server,
>                                       bool all_channels);
> diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
> index e71aa33bf026..149cde77500e 100644
> --- a/fs/smb/client/connect.c
> +++ b/fs/smb/client/connect.c
> @@ -116,7 +116,8 @@ static int reconn_set_ipaddr_from_hostname(struct TCP=
_Server_Info *server)
>         return rc;
>  }
>
> -static void smb2_query_server_interfaces(struct work_struct *work)
> +void
> +smb2_query_server_interfaces(struct work_struct *work)
>  {
>         int rc;
>         int xid;
> @@ -134,6 +135,9 @@ static void smb2_query_server_interfaces(struct work_=
struct *work)
>         if (rc) {
>                 cifs_dbg(FYI, "%s: failed to query server interfaces: %d\=
n",
>                                 __func__, rc);
> +
> +               if (rc =3D=3D -EOPNOTSUPP)
> +                       return;
>         }
>
>         queue_delayed_work(cifsiod_wq, &tcon->query_interfaces,
> diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
> index b7665155f4e2..2617437a4627 100644
> --- a/fs/smb/client/smb2pdu.c
> +++ b/fs/smb/client/smb2pdu.c
> @@ -163,6 +163,7 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon =
*tcon,
>         int rc =3D 0;
>         struct nls_table *nls_codepage =3D NULL;
>         struct cifs_ses *ses;
> +       int xid;
>
>         /*
>          * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
> @@ -307,17 +308,41 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tco=
n *tcon,
>                 tcon->need_reopen_files =3D true;
>
>         rc =3D cifs_tree_connect(0, tcon, nls_codepage);
> -       mutex_unlock(&ses->session_mutex);
>
>         cifs_dbg(FYI, "reconnect tcon rc =3D %d\n", rc);
>         if (rc) {
>                 /* If sess reconnected but tcon didn't, something strange=
 ... */
> +               mutex_unlock(&ses->session_mutex);
>                 cifs_dbg(VFS, "reconnect tcon failed rc =3D %d\n", rc);
>                 goto out;
>         }
>
> -       if (smb2_command !=3D SMB2_INTERNAL_CMD)
> -               mod_delayed_work(cifsiod_wq, &server->reconnect, 0);
> +       if (!rc &&
> +           (server->capabilities & SMB2_GLOBAL_CAP_MULTI_CHANNEL)) {
> +               mutex_unlock(&ses->session_mutex);
> +
> +               /*
> +                * query server network interfaces, in case they change
> +                */
> +               xid =3D get_xid();
> +               rc =3D SMB3_request_interfaces(xid, tcon, false);
> +               free_xid(xid);
> +
> +               if (rc)
> +                       cifs_dbg(FYI, "%s: failed to query server interfa=
ces: %d\n",
> +                                __func__, rc);
> +
> +               if (ses->chan_max > ses->chan_count &&
> +                   !SERVER_IS_CHAN(server)) {
> +                       if (ses->chan_count =3D=3D 1)
> +                               cifs_dbg(VFS, "server %s supports multich=
annel now\n",
> +                                        ses->server->hostname);
> +
> +                       cifs_try_adding_channels(tcon->cifs_sb, ses);
> +               }
> +       } else {
> +               mutex_unlock(&ses->session_mutex);
> +       }
>
>         atomic_inc(&tconInfoReconnectCount);
>  out:
> --
> 2.34.1
>


--=20
Thanks,

Steve
