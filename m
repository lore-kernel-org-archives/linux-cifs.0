Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E35F4C61DA4
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Feb 2023 21:09:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230136AbjBPVJG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbjBPVJF (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Feb 2023 16:09:05 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69CED521FD
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:59 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id c1so7866385edt.4
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 13:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YFI1uhVWicUVRIKhqqQ8UGC9QCbg2sJ4ChVsk7Qr634=;
        b=ChddP9JDQENBSuetvs2VGupwdzBTU9Sk0yWMijZzQD5YzNbLn3KwqckpXVphaMUO6x
         v60uxZ+RYJECHyR+pMw52k7dBNtz/U+INTqOEVkXIWyYR4oou/8B/XYiIuD6um67YrnR
         JupjgW0J7lwZUan8NnC/t/pdPIZGKj0jXJGlZ8lmQ9w0BmXJbUjxiN9mBtM75A33vsex
         hYwHuEtDl+o1EGioPDNZGydYXGEK5beAaD0nYvsJOc3o9a4/M7yVotgzDLMuWh4STlV9
         LXEIcqahX4kQtrLQidH3qY2gdnETZcSA0HYy5Xl2Ag9oQFhOCJtWqKM1/NtLYY4ybu4H
         QXiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YFI1uhVWicUVRIKhqqQ8UGC9QCbg2sJ4ChVsk7Qr634=;
        b=tKd9iEEgPo4IaXBCqjtmlmPfAa3AAPjaphLyUvEJwZwICUg/8hTWznscw7gTSoBc18
         bS3h6faXNyS3FfbemuSCk6RUw/OQ+qg3RD1rJ7RtsbDh2pXL+Hxjo5YP7MHVYt9OfMeR
         eoS45wA+omZ9O4SN5ED4dQDw4/la/dewPFXEUU4eVn4Cv6jhlcxrlmYbUjkAZ1kOGaKG
         fqhoDd60ee22PJK/OXCuIdlMCabBwalfF+O0dl+ZGcbWcl7pHIqUbH0v3NtjYlOuj0hg
         P8W9dHrtubjOl9Vc0V7kk6uOcSmk/4sAsOkOlxNuenSXtFnbPV1hA2edzV21SzLHVEXV
         VaOA==
X-Gm-Message-State: AO0yUKXwIG9XRx3E5sVclp607gif/eAnFTSupNuE4rszqRPcREJOWPY0
        u2dkj7RKuzeerX/KZOqfYHxBlB84EZb7Nn2gZL24+nMk
X-Google-Smtp-Source: AK7set8nUpwtB3sWO0O0s60e4y98YDakqK+cbuzCQQjPznW3B03WSSp7OQ6tuU+HWRgJxFmjVxYABf8cTra0XasR6HA=
X-Received: by 2002:a50:d0d3:0:b0:4aa:b918:44cf with SMTP id
 g19-20020a50d0d3000000b004aab91844cfmr3814350edf.8.1676581737812; Thu, 16 Feb
 2023 13:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20230216183322@manguebit.com>
In-Reply-To: <20230216183322@manguebit.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 17 Feb 2023 07:08:45 +1000
Message-ID: <CAN05THRjG_-q65LF8kmQvBAq4Eak2z-7aRcMM+_SLcqqFSrBCQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix mount on old smb servers
To:     Paulo Alcantara <pc@manguebit.com>
Cc:     smfrench@gmail.com, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Very nice cleanup.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Fri, 17 Feb 2023 at 04:44, Paulo Alcantara <pc@manguebit.com> wrote:
>
> The client was sending rfc1002 session request packet with a wrong
> length field set, therefore failing to mount shares against old SMB
> servers over port 139.
>
> Fix this by calculating the correct length as specified in rfc1002.
>
> Fixes: d7173623bf0b ("cifs: use ALIGN() and round_up() macros")
> Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> ---
>  fs/cifs/connect.c | 100 ++++++++++++++++++----------------------------
>  1 file changed, 38 insertions(+), 62 deletions(-)
>
> diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> index b2a04b4e89a5..af49ae53aaf4 100644
> --- a/fs/cifs/connect.c
> +++ b/fs/cifs/connect.c
> @@ -2843,72 +2843,48 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
>          * negprot - BB check reconnection in case where second
>          * sessinit is sent but no second negprot
>          */
> -       struct rfc1002_session_packet *ses_init_buf;
> -       unsigned int req_noscope_len;
> -       struct smb_hdr *smb_buf;
> +       struct rfc1002_session_packet req = {};
> +       struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
> +       unsigned int len;
> +
> +       req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
> +
> +       if (server->server_RFC1001_name[0] != 0)
> +               rfc1002mangle(req.trailer.session_req.called_name,
> +                             server->server_RFC1001_name,
> +                             RFC1001_NAME_LEN_WITH_NULL);
> +       else
> +               rfc1002mangle(req.trailer.session_req.called_name,
> +                             DEFAULT_CIFS_CALLED_NAME,
> +                             RFC1001_NAME_LEN_WITH_NULL);
> +
> +       req.trailer.session_req.calling_len = sizeof(req.trailer.session_req.calling_name);
> +
> +       /* calling name ends in null (byte 16) from old smb convention */
> +       if (server->workstation_RFC1001_name[0] != 0)
> +               rfc1002mangle(req.trailer.session_req.calling_name,
> +                             server->workstation_RFC1001_name,
> +                             RFC1001_NAME_LEN_WITH_NULL);
> +       else
> +               rfc1002mangle(req.trailer.session_req.calling_name,
> +                             "LINUX_CIFS_CLNT",
> +                             RFC1001_NAME_LEN_WITH_NULL);
>
> -       ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
> -                              GFP_KERNEL);
> -
> -       if (ses_init_buf) {
> -               ses_init_buf->trailer.session_req.called_len = 32;
> -
> -               if (server->server_RFC1001_name[0] != 0)
> -                       rfc1002mangle(ses_init_buf->trailer.
> -                                     session_req.called_name,
> -                                     server->server_RFC1001_name,
> -                                     RFC1001_NAME_LEN_WITH_NULL);
> -               else
> -                       rfc1002mangle(ses_init_buf->trailer.
> -                                     session_req.called_name,
> -                                     DEFAULT_CIFS_CALLED_NAME,
> -                                     RFC1001_NAME_LEN_WITH_NULL);
> -
> -               ses_init_buf->trailer.session_req.calling_len = 32;
> -
> -               /*
> -                * calling name ends in null (byte 16) from old smb
> -                * convention.
> -                */
> -               if (server->workstation_RFC1001_name[0] != 0)
> -                       rfc1002mangle(ses_init_buf->trailer.
> -                                     session_req.calling_name,
> -                                     server->workstation_RFC1001_name,
> -                                     RFC1001_NAME_LEN_WITH_NULL);
> -               else
> -                       rfc1002mangle(ses_init_buf->trailer.
> -                                     session_req.calling_name,
> -                                     "LINUX_CIFS_CLNT",
> -                                     RFC1001_NAME_LEN_WITH_NULL);
> -
> -               ses_init_buf->trailer.session_req.scope1 = 0;
> -               ses_init_buf->trailer.session_req.scope2 = 0;
> -               smb_buf = (struct smb_hdr *)ses_init_buf;
> -
> -               /* sizeof RFC1002_SESSION_REQUEST with no scopes */
> -               req_noscope_len = sizeof(struct rfc1002_session_packet) - 2;
> +       /*
> +        * As per rfc1002, @len must be the number of bytes that follows the
> +        * length field of a rfc1002 session request payload.
> +        */
> +       len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
>
> -               /* == cpu_to_be32(0x81000044) */
> -               smb_buf->smb_buf_length =
> -                       cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | req_noscope_len);
> -               rc = smb_send(server, smb_buf, 0x44);
> -               kfree(ses_init_buf);
> -               /*
> -                * RFC1001 layer in at least one server
> -                * requires very short break before negprot
> -                * presumably because not expecting negprot
> -                * to follow so fast.  This is a simple
> -                * solution that works without
> -                * complicating the code and causes no
> -                * significant slowing down on mount
> -                * for everyone else
> -                */
> -               usleep_range(1000, 2000);
> -       }
> +       smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
> +       rc = smb_send(server, smb_buf, len);
>         /*
> -        * else the negprot may still work without this
> -        * even though malloc failed
> +        * RFC1001 layer in at least one server requires very short break before
> +        * negprot presumably because not expecting negprot to follow so fast.
> +        * This is a simple solution that works without complicating the code
> +        * and causes no significant slowing down on mount for everyone else
>          */
> +       usleep_range(1000, 2000);
>
>         return rc;
>  }
> --
> 2.39.1
>
