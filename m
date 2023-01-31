Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69CB1C38142
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Jan 2023 06:03:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbjAaGDa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Jan 2023 01:03:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjAaGD3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Jan 2023 01:03:29 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4662115CB3
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 22:03:28 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id f34so22590709lfv.10
        for <linux-cifs@vger.kernel.org>; Mon, 30 Jan 2023 22:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ekU64BkYaLZqWJDR41WQN/a5Bve6XwGcK1Ufsksb2mQ=;
        b=U5ugTjw6WPzSXCfQR6O6Pcpb/B3UZlgC8ew61zFNndq0uA7xP0UPN/q0k2v2G4FP13
         DQarzobhCfPLd8imCtnXiS2iehZxkGaGWWkOmXal4CwiLR4RUrRpM++62VtJfscSXwEW
         KS5U9cup9taXIsFzjgmluRCGnZ35I6CcV60Lqf1eY71ZZPan9P4aLTQdK+htGEttluJc
         MU0xoUHMMCTvKBDnuo8LZi/r9Vukp7tBjqtbWzAVqSWtviMhMtmeOAi1Xfs5Owtipzvj
         zO6OXdQvpVEePIbTiDjs4vkLQG5eU3HB3zWrA8CWJP5LQEdA0DjH8754fK3h4JDBlIDr
         nyDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ekU64BkYaLZqWJDR41WQN/a5Bve6XwGcK1Ufsksb2mQ=;
        b=7zl1BHYv74PN0k/cL95C+YLQqo1R6FsfqGjm8Ydc48oRh4ytdfPHFc4WgMuBpYCrGd
         kxoG5agxoYOnzgxqhJqyazzMlo2x9eKv6X8EGhH9eROgmXIEeNX2NiDzVy20ouyxvwVw
         u/r6Bp7JrUv6RwUbyCaWfSqCeS4XEzHR0t6ruzadYgvmLZ8C3MxrCFN98K9hqgEO85/u
         Ykd4PYGbGVq3rwenIr9s7JoN1KGvqButYyLXYCaBNtv3c30y+zXg63+X2HrbRAaHWZEA
         /LQsMX6vYL++TiC6yiz89yAXcjc9MYPVebP1M1WTfp5/UntxVy5AQzTajdS4e4vm41KY
         2ARg==
X-Gm-Message-State: AFqh2kqzLdSdQZO7/bZQxWD6xt9YfkiMO7ci+ZsEenkN3U8VWD2W6PhX
        UB54q9HzlmvmGJYQGT0YhvHNYJwN+9gaH7ZjWJ4=
X-Google-Smtp-Source: AMrXdXvMXg9cQeV/unQPh7lRNvKU/Eih3oNNmvpfd/jLv+tXsAr2OY/WXMBXmjRVQWsUqXNqhWd4RG3a5P9Hz4Ao8sA=
X-Received: by 2002:a05:6512:1284:b0:4d5:9957:541 with SMTP id
 u4-20020a056512128400b004d599570541mr5167980lfs.52.1675145006231; Mon, 30 Jan
 2023 22:03:26 -0800 (PST)
MIME-Version: 1.0
References: <20230130233329.7074-1-pc@cjr.nz>
In-Reply-To: <20230130233329.7074-1-pc@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 31 Jan 2023 00:03:15 -0600
Message-ID: <CAH2r5mu9xT8oij5kvLqJi0t=j1LH2NoVM1N5VmQgkrkt5H5fhQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: prevent data race in smb2_reconnect()
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next pending review/testing

On Mon, Jan 30, 2023 at 5:33 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Make sure to get an up-to-date TCP_Server_Info::nr_targets value prior
> to waiting the server to be reconnected in smb2_reconnect().  It is
> set in cifs_tcp_ses_needs_reconnect() and protected by
> TCP_Server_Info::srv_lock.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
> ---
>  fs/cifs/smb2pdu.c | 119 +++++++++++++++++++++++++---------------------
>  1 file changed, 64 insertions(+), 55 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 2c9ffa921e6f..2d5c3df2277d 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -139,6 +139,66 @@ smb2_hdr_assemble(struct smb2_hdr *shdr, __le16 smb2_cmd,
>         return;
>  }
>
> +static int wait_for_server_reconnect(struct TCP_Server_Info *server,
> +                                    __le16 smb2_command, bool retry)
> +{
> +       int timeout = 10;
> +       int rc;
> +
> +       spin_lock(&server->srv_lock);
> +       if (server->tcpStatus != CifsNeedReconnect) {
> +               spin_unlock(&server->srv_lock);
> +               return 0;
> +       }
> +       timeout *= server->nr_targets;
> +       spin_unlock(&server->srv_lock);
> +
> +       /*
> +        * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
> +        * here since they are implicitly done when session drops.
> +        */
> +       switch (smb2_command) {
> +       /*
> +        * BB Should we keep oplock break and add flush to exceptions?
> +        */
> +       case SMB2_TREE_DISCONNECT:
> +       case SMB2_CANCEL:
> +       case SMB2_CLOSE:
> +       case SMB2_OPLOCK_BREAK:
> +               return -EAGAIN;
> +       }
> +
> +       /*
> +        * Give demultiplex thread up to 10 seconds to each target available for
> +        * reconnect -- should be greater than cifs socket timeout which is 7
> +        * seconds.
> +        *
> +        * On "soft" mounts we wait once. Hard mounts keep retrying until
> +        * process is killed or server comes back on-line.
> +        */
> +       do {
> +               rc = wait_event_interruptible_timeout(server->response_q,
> +                                                     (server->tcpStatus != CifsNeedReconnect),
> +                                                     timeout * HZ);
> +               if (rc < 0) {
> +                       cifs_dbg(FYI, "%s: aborting reconnect due to received signal\n",
> +                                __func__);
> +                       return -ERESTARTSYS;
> +               }
> +
> +               /* are we still trying to reconnect? */
> +               spin_lock(&server->srv_lock);
> +               if (server->tcpStatus != CifsNeedReconnect) {
> +                       spin_unlock(&server->srv_lock);
> +                       return 0;
> +               }
> +               spin_unlock(&server->srv_lock);
> +       } while (retry);
> +
> +       cifs_dbg(FYI, "%s: gave up waiting on reconnect\n", __func__);
> +       return -EHOSTDOWN;
> +}
> +
>  static int
>  smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>                struct TCP_Server_Info *server)
> @@ -146,7 +206,6 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>         int rc = 0;
>         struct nls_table *nls_codepage;
>         struct cifs_ses *ses;
> -       int retries;
>
>         /*
>          * SMB2s NegProt, SessSetup, Logoff do not have tcon yet so
> @@ -184,61 +243,11 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
>             (!tcon->ses->server) || !server)
>                 return -EIO;
>
> +       rc = wait_for_server_reconnect(server, smb2_command, tcon->retry);
> +       if (rc)
> +               return rc;
> +
>         ses = tcon->ses;
> -       retries = server->nr_targets;
> -
> -       /*
> -        * Give demultiplex thread up to 10 seconds to each target available for
> -        * reconnect -- should be greater than cifs socket timeout which is 7
> -        * seconds.
> -        */
> -       while (server->tcpStatus == CifsNeedReconnect) {
> -               /*
> -                * Return to caller for TREE_DISCONNECT and LOGOFF and CLOSE
> -                * here since they are implicitly done when session drops.
> -                */
> -               switch (smb2_command) {
> -               /*
> -                * BB Should we keep oplock break and add flush to exceptions?
> -                */
> -               case SMB2_TREE_DISCONNECT:
> -               case SMB2_CANCEL:
> -               case SMB2_CLOSE:
> -               case SMB2_OPLOCK_BREAK:
> -                       return -EAGAIN;
> -               }
> -
> -               rc = wait_event_interruptible_timeout(server->response_q,
> -                                                     (server->tcpStatus != CifsNeedReconnect),
> -                                                     10 * HZ);
> -               if (rc < 0) {
> -                       cifs_dbg(FYI, "%s: aborting reconnect due to a received signal by the process\n",
> -                                __func__);
> -                       return -ERESTARTSYS;
> -               }
> -
> -               /* are we still trying to reconnect? */
> -               spin_lock(&server->srv_lock);
> -               if (server->tcpStatus != CifsNeedReconnect) {
> -                       spin_unlock(&server->srv_lock);
> -                       break;
> -               }
> -               spin_unlock(&server->srv_lock);
> -
> -               if (retries && --retries)
> -                       continue;
> -
> -               /*
> -                * on "soft" mounts we wait once. Hard mounts keep
> -                * retrying until process is killed or server comes
> -                * back on-line
> -                */
> -               if (!tcon->retry) {
> -                       cifs_dbg(FYI, "gave up waiting on reconnect in smb_init\n");
> -                       return -EHOSTDOWN;
> -               }
> -               retries = server->nr_targets;
> -       }
>
>         spin_lock(&ses->chan_lock);
>         if (!cifs_chan_needs_reconnect(ses, server) && !tcon->need_reconnect) {
> --
> 2.39.1
>


-- 
Thanks,

Steve
