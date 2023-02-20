Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 477BCC636D6
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 20:50:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjBTUud (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Feb 2023 15:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBTUuc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Feb 2023 15:50:32 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB8A7ED5
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 12:50:31 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id ec43so8763540edb.8
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 12:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Q0dePMCFdI7j924k+o2UN9pA5GCpyVrB9p6c/+5Auk=;
        b=aasAIABnyI0rRDe5h8IC1wiJo05RjPe+qIvC3cDlIr8HO4gm1jOMNydvdjB3RN6rZ4
         xq5+q/W+YpvBBBIHY1vdXlIlDvwfHOmOryXakUUoQn9/xZLNMBH1PZw9+nwM1uxHo6/L
         YL96HANpgNFcSsqwLqK/oabppgFw91VH2OhQSJsecblIruUvy+BUQQVcYfKQPh5Ek+E7
         arRY+Ezw39wrKnAXTiYwEf5J+k6sxb6YJQh67Kv1cdMVcGyRWEjP8j+dIkU2heZT+v+/
         Kp8Loh2FaPJUOMvhG6BOyWJEHOZoPdIRdu974FuGypRkc2y2KjzdJtvE1cfs2th0as9s
         aJFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Q0dePMCFdI7j924k+o2UN9pA5GCpyVrB9p6c/+5Auk=;
        b=GkcgUVgSZJJLIjVVegWbjLkXP14p0EwuwCPRsZjO4Q2zMK3O/gyZ9mXF50s8hAPX3E
         dpjd2r691LF/q9UeuZMAF3AhCOd3em6Z9ezZLGYmarKuUrSTB1o2YP5yBVz8cMSevsTM
         0ytj/EHwVpxSMejl8TJgKsJhLGlgN3aBSJtF6oR3nwnW5pq4eRH2YVfpCcM8V9XQTF/M
         8WASuUFEK6BN9JIwOhp+q4f5E5tYxZQJOzTTu3cbhOmi9hhwaNjqX4aIgEsCLG/YyUq2
         SYkRZBI4e0xZwPAG9AzRIeNFvzav8MmNXfYHym5Ua1+IIVzcnUBD1oQDsVg4p7X/LLhp
         1RGA==
X-Gm-Message-State: AO0yUKUNuD7V5zfDagv9lNHkXFFtulphtEQBezunIDew+KbdJimYC+CT
        fag8SFsw8RKX44ZhtGfuiivi+ikcjESYWbwgPRwCLyK+
X-Google-Smtp-Source: AK7set+Ufd9iDNu8GjRlIqQXgnc/AVBtPpfOSpl/kizaHY+eDBpnyF1wNsqnXZgiFwV4foYqjeNm55SOx7sgUJ7q2Kw=
X-Received: by 2002:a17:907:98ce:b0:877:7480:c76b with SMTP id
 kd14-20020a17090798ce00b008777480c76bmr4834415ejc.14.1676926229323; Mon, 20
 Feb 2023 12:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20230220193654@manguebit.com>
In-Reply-To: <20230220193654@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Tue, 21 Feb 2023 06:50:16 +1000
Message-ID: <CAN05THROo-OUQTmapvJ5QGnbh_Aob+V4BcA_Jmtrzi21XPc3=w@mail.gmail.com>
Subject: Re: [PATCH] cifs: get rid of dns resolve worker
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Nice

Reviewed-by lsahlber@redhat.com

On Tue, 21 Feb 2023 at 05:40, Paulo Alcantara <pc@manguebit.com> wrote:
>
> We already upcall to resolve hostnames during reconnect by calling
> reconn_set_ipaddr_from_hostname(), so there is no point in having a
> worker to periodically call it.
>
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/cifsglob.h |  5 -----
>  fs/cifs/connect.c  | 53 ++++++----------------------------------------
>  fs/cifs/sess.c     |  1 -
>  3 files changed, 6 insertions(+), 53 deletions(-)
>
> diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
> index 893c2e21eb8e..b1db5dbae31a 100644
> --- a/fs/cifs/cifsglob.h
> +++ b/fs/cifs/cifsglob.h
> @@ -77,10 +77,6 @@
>  #define SMB_ECHO_INTERVAL_MAX 600
>  #define SMB_ECHO_INTERVAL_DEFAULT 60
>
> -/* dns resolution intervals in seconds */
> -#define SMB_DNS_RESOLVE_INTERVAL_MIN     120
> -#define SMB_DNS_RESOLVE_INTERVAL_DEFAULT 600
> -
>  /* smb multichannel query server interfaces interval in seconds */
>  #define SMB_INTERFACE_POLL_INTERVAL    600
>
> @@ -689,7 +685,6 @@ struct TCP_Server_Info {
>         /* point to the SMBD connection if RDMA is used instead of socket */
>         struct smbd_connection *smbd_conn;
>         struct delayed_work     echo; /* echo ping workqueue job */
> -       struct delayed_work     resolve; /* dns resolution workqueue job */
>         char    *smallbuf;      /* pointer to current "small" buffer */
>         char    *bigbuf;        /* pointer to current "big" buffer */
>         /* Total size of this PDU. Only valid from cifs_demultiplex_thread */
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index c65b06855e5f..6831eb8cea7c 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -79,8 +79,6 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>         int len;
>         char *unc;
>         struct sockaddr_storage ss;
> -       time64_t expiry, now;
> -       unsigned long ttl = SMB_DNS_RESOLVE_INTERVAL_DEFAULT;
>
>         if (!server->hostname)
>                 return -EINVAL;
> @@ -102,29 +100,19 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
>         ss = server->dstaddr;
>         spin_unlock(&server->srv_lock);
>
> -       rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, &expiry);
> +       rc = dns_resolve_server_name_to_ip(unc, (struct sockaddr *)&ss, NULL);
>         kfree(unc);
>
>         if (rc < 0) {
>                 cifs_dbg(FYI, "%s: failed to resolve server part of %s to IP: %d\n",
>                          __func__, server->hostname, rc);
> -               goto requeue_resolve;
> +       } else {
> +               spin_lock(&server->srv_lock);
> +               memcpy(&server->dstaddr, &ss, sizeof(server->dstaddr));
> +               spin_unlock(&server->srv_lock);
> +               rc = 0;
>         }
>
> -       spin_lock(&server->srv_lock);
> -       memcpy(&server->dstaddr, &ss, sizeof(server->dstaddr));
> -       spin_unlock(&server->srv_lock);
> -
> -       now = ktime_get_real_seconds();
> -       if (expiry && expiry > now)
> -               /* To make sure we don't use the cached entry, retry 1s */
> -               ttl = max_t(unsigned long, expiry - now, SMB_DNS_RESOLVE_INTERVAL_MIN) + 1;
> -
> -requeue_resolve:
> -       cifs_dbg(FYI, "%s: next dns resolution scheduled for %lu seconds in the future\n",
> -                __func__, ttl);
> -       mod_delayed_work(cifsiod_wq, &server->resolve, (ttl * HZ));
> -
>         return rc;
>  }
>
> @@ -148,26 +136,6 @@ static void smb2_query_server_interfaces(struct work_struct *work)
>                            (SMB_INTERFACE_POLL_INTERVAL * HZ));
>  }
>
> -static void cifs_resolve_server(struct work_struct *work)
> -{
> -       int rc;
> -       struct TCP_Server_Info *server = container_of(work,
> -                                       struct TCP_Server_Info, resolve.work);
> -
> -       cifs_server_lock(server);
> -
> -       /*
> -        * Resolve the hostname again to make sure that IP address is up-to-date.
> -        */
> -       rc = reconn_set_ipaddr_from_hostname(server);
> -       if (rc) {
> -               cifs_dbg(FYI, "%s: failed to resolve hostname: %d\n",
> -                               __func__, rc);
> -       }
> -
> -       cifs_server_unlock(server);
> -}
> -
>  /*
>   * Update the tcpStatus for the server.
>   * This is used to signal the cifsd thread to call cifs_reconnect
> @@ -939,7 +907,6 @@ static void clean_demultiplex_info(struct TCP_Server_Info *server)
>         spin_unlock(&server->srv_lock);
>
>         cancel_delayed_work_sync(&server->echo);
> -       cancel_delayed_work_sync(&server->resolve);
>
>         spin_lock(&server->srv_lock);
>         server->tcpStatus = CifsExiting;
> @@ -1563,7 +1530,6 @@ cifs_put_tcp_session(struct TCP_Server_Info *server, int from_reconnect)
>                 cifs_put_tcp_session(server->primary_server, from_reconnect);
>
>         cancel_delayed_work_sync(&server->echo);
> -       cancel_delayed_work_sync(&server->resolve);
>
>         if (from_reconnect)
>                 /*
> @@ -1669,7 +1635,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>         INIT_LIST_HEAD(&tcp_ses->tcp_ses_list);
>         INIT_LIST_HEAD(&tcp_ses->smb_ses_list);
>         INIT_DELAYED_WORK(&tcp_ses->echo, cifs_echo_request);
> -       INIT_DELAYED_WORK(&tcp_ses->resolve, cifs_resolve_server);
>         INIT_DELAYED_WORK(&tcp_ses->reconnect, smb2_reconnect_server);
>         mutex_init(&tcp_ses->reconnect_mutex);
>  #ifdef CONFIG_CIFS_DFS_UPCALL
> @@ -1758,12 +1723,6 @@ cifs_get_tcp_session(struct smb3_fs_context *ctx,
>         /* queue echo request delayed work */
>         queue_delayed_work(cifsiod_wq, &tcp_ses->echo, tcp_ses->echo_interval);
>
> -       /* queue dns resolution delayed work */
> -       cifs_dbg(FYI, "%s: next dns resolution scheduled for %d seconds in the future\n",
> -                __func__, SMB_DNS_RESOLVE_INTERVAL_DEFAULT);
> -
> -       queue_delayed_work(cifsiod_wq, &tcp_ses->resolve, (SMB_DNS_RESOLVE_INTERVAL_DEFAULT * HZ));
> -
>         return tcp_ses;
>
>  out_err_crypto_release:
> diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
> index 07822f2a5b7c..13e36ee967a6 100644
> --- a/fs/cifs/sess.c
> +++ b/fs/cifs/sess.c
> @@ -541,7 +541,6 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
>                  * remove this channel
>                  */
>                 cancel_delayed_work_sync(&chan->server->echo);
> -               cancel_delayed_work_sync(&chan->server->resolve);
>                 cancel_delayed_work_sync(&chan->server->reconnect);
>
>                 spin_lock(&ses->chan_lock);
> --
> 2.39.2
>
