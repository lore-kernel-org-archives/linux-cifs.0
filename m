Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31630C05027
	for <linux-cifs@archiver.kernel.org>; Fri, 17 Feb 2023 05:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQFdX (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 17 Feb 2023 00:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQFdX (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 17 Feb 2023 00:33:23 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEA82497FA
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:33:19 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u27so4202724ljo.12
        for <linux-cifs@vger.kernel.org>; Thu, 16 Feb 2023 21:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5fYzJsdOctTF7U06F6KS70ZNsNiIrJNIsM7sQi8Dtcs=;
        b=i8ICbMeRmY5jnrGJVzSo4MHlbDI3cGWZ031ZTOle6ngV7UZCBbRvuAUUCZMZf01w+F
         E8Kr22/X1iFhwZWm4NRElwoM2jQWPUrsWzPbLJlL+Sv4VRO8u43TPN0YASFcf8j3qs5O
         e6pN22iqqcBZEUb/wBb1SD25NeJPrXeWv1djNhnJoreBy8JGmh6wXprKNFM53RoYlZCp
         g3N98B73K2rejtqOXhFrHzFpJT4S7o9f29Oa5eB+rErH4x6Z1qhgCceW+uMEco3bHEsm
         viNR4lSpR0owK/Eq32fpcMdyJ0KfUuWlk7YYy1QpDOTsqE2furX9ln4Z7w/Zv145jDiV
         Y4Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5fYzJsdOctTF7U06F6KS70ZNsNiIrJNIsM7sQi8Dtcs=;
        b=v5xc2qg6xmbjb6k0UJYnDCiHkiQCZCfBTkkYEUZ6CEROaw3JpE4wGMEok/0VzjUfz1
         N6JiJGGQkLJZnX/NvtXV6BUy5hM7rS+Rar4RFlI1WzXMUlCD6ifotHB1P6hAYUZRf8FE
         eEd7fYhih067hEUFaDYt96KOD4IGfXbvdJ4fTKAv9x9o6brSiQR4KyMdHUUVOumJ2jCQ
         gp+6UPMQPZUxdHLq70yqExdDosM76L5ae6JPMwz/vqrAtgCw5rkRRIdT4Q9ULwGdFNAK
         e0QDjkc7fWtKgZdeLYys5BxwwqI8mpb7oabuYvZx+wOY0xfmywjX3Z7L1o37NrEzty/l
         /Evg==
X-Gm-Message-State: AO0yUKWM9BktrFFGsHAkWggbzViOH/0Sd0DESM7wcbs8IAIS5eEYtqDO
        XdGlgPjoivxy2pX3PKnJHKNygH4Jm72QOZCUdxwBdkZq
X-Google-Smtp-Source: AK7set/0BSWeOwVs51pbwuPdFFOkE6Bsnd3er/qoSGQhVXKPUP4sD+Cn4eunX4s9i6O9AOCm7c/fxgZ8mDqi2YYIf+M=
X-Received: by 2002:a2e:b554:0:b0:293:34b9:b86a with SMTP id
 a20-20020a2eb554000000b0029334b9b86amr9919ljn.7.1676611997809; Thu, 16 Feb
 2023 21:33:17 -0800 (PST)
MIME-Version: 1.0
References: <20230216183322@manguebit.com> <CAN05THRjG_-q65LF8kmQvBAq4Eak2z-7aRcMM+_SLcqqFSrBCQ@mail.gmail.com>
In-Reply-To: <CAN05THRjG_-q65LF8kmQvBAq4Eak2z-7aRcMM+_SLcqqFSrBCQ@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 16 Feb 2023 23:33:06 -0600
Message-ID: <CAH2r5muDWpO1Jo73kHCBXs_g8kW+OdcH6NnHNHozLRKxMTOffQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix mount on old smb servers
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     Paulo Alcantara <pc@manguebit.com>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Feb 16, 2023 at 3:08 PM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> Very nice cleanup.
>
> Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>
>
> On Fri, 17 Feb 2023 at 04:44, Paulo Alcantara <pc@manguebit.com> wrote:
> >
> > The client was sending rfc1002 session request packet with a wrong
> > length field set, therefore failing to mount shares against old SMB
> > servers over port 139.
> >
> > Fix this by calculating the correct length as specified in rfc1002.
> >
> > Fixes: d7173623bf0b ("cifs: use ALIGN() and round_up() macros")
> > Signed-off-by: Paulo Alcantara (SUSE) <pc@manguebit.com>
> > ---
> >  fs/cifs/connect.c | 100 ++++++++++++++++++----------------------------
> >  1 file changed, 38 insertions(+), 62 deletions(-)
> >
> > diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
> > index b2a04b4e89a5..af49ae53aaf4 100644
> > --- a/fs/cifs/connect.c
> > +++ b/fs/cifs/connect.c
> > @@ -2843,72 +2843,48 @@ ip_rfc1001_connect(struct TCP_Server_Info *server)
> >          * negprot - BB check reconnection in case where second
> >          * sessinit is sent but no second negprot
> >          */
> > -       struct rfc1002_session_packet *ses_init_buf;
> > -       unsigned int req_noscope_len;
> > -       struct smb_hdr *smb_buf;
> > +       struct rfc1002_session_packet req = {};
> > +       struct smb_hdr *smb_buf = (struct smb_hdr *)&req;
> > +       unsigned int len;
> > +
> > +       req.trailer.session_req.called_len = sizeof(req.trailer.session_req.called_name);
> > +
> > +       if (server->server_RFC1001_name[0] != 0)
> > +               rfc1002mangle(req.trailer.session_req.called_name,
> > +                             server->server_RFC1001_name,
> > +                             RFC1001_NAME_LEN_WITH_NULL);
> > +       else
> > +               rfc1002mangle(req.trailer.session_req.called_name,
> > +                             DEFAULT_CIFS_CALLED_NAME,
> > +                             RFC1001_NAME_LEN_WITH_NULL);
> > +
> > +       req.trailer.session_req.calling_len = sizeof(req.trailer.session_req.calling_name);
> > +
> > +       /* calling name ends in null (byte 16) from old smb convention */
> > +       if (server->workstation_RFC1001_name[0] != 0)
> > +               rfc1002mangle(req.trailer.session_req.calling_name,
> > +                             server->workstation_RFC1001_name,
> > +                             RFC1001_NAME_LEN_WITH_NULL);
> > +       else
> > +               rfc1002mangle(req.trailer.session_req.calling_name,
> > +                             "LINUX_CIFS_CLNT",
> > +                             RFC1001_NAME_LEN_WITH_NULL);
> >
> > -       ses_init_buf = kzalloc(sizeof(struct rfc1002_session_packet),
> > -                              GFP_KERNEL);
> > -
> > -       if (ses_init_buf) {
> > -               ses_init_buf->trailer.session_req.called_len = 32;
> > -
> > -               if (server->server_RFC1001_name[0] != 0)
> > -                       rfc1002mangle(ses_init_buf->trailer.
> > -                                     session_req.called_name,
> > -                                     server->server_RFC1001_name,
> > -                                     RFC1001_NAME_LEN_WITH_NULL);
> > -               else
> > -                       rfc1002mangle(ses_init_buf->trailer.
> > -                                     session_req.called_name,
> > -                                     DEFAULT_CIFS_CALLED_NAME,
> > -                                     RFC1001_NAME_LEN_WITH_NULL);
> > -
> > -               ses_init_buf->trailer.session_req.calling_len = 32;
> > -
> > -               /*
> > -                * calling name ends in null (byte 16) from old smb
> > -                * convention.
> > -                */
> > -               if (server->workstation_RFC1001_name[0] != 0)
> > -                       rfc1002mangle(ses_init_buf->trailer.
> > -                                     session_req.calling_name,
> > -                                     server->workstation_RFC1001_name,
> > -                                     RFC1001_NAME_LEN_WITH_NULL);
> > -               else
> > -                       rfc1002mangle(ses_init_buf->trailer.
> > -                                     session_req.calling_name,
> > -                                     "LINUX_CIFS_CLNT",
> > -                                     RFC1001_NAME_LEN_WITH_NULL);
> > -
> > -               ses_init_buf->trailer.session_req.scope1 = 0;
> > -               ses_init_buf->trailer.session_req.scope2 = 0;
> > -               smb_buf = (struct smb_hdr *)ses_init_buf;
> > -
> > -               /* sizeof RFC1002_SESSION_REQUEST with no scopes */
> > -               req_noscope_len = sizeof(struct rfc1002_session_packet) - 2;
> > +       /*
> > +        * As per rfc1002, @len must be the number of bytes that follows the
> > +        * length field of a rfc1002 session request payload.
> > +        */
> > +       len = sizeof(req) - offsetof(struct rfc1002_session_packet, trailer.session_req);
> >
> > -               /* == cpu_to_be32(0x81000044) */
> > -               smb_buf->smb_buf_length =
> > -                       cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | req_noscope_len);
> > -               rc = smb_send(server, smb_buf, 0x44);
> > -               kfree(ses_init_buf);
> > -               /*
> > -                * RFC1001 layer in at least one server
> > -                * requires very short break before negprot
> > -                * presumably because not expecting negprot
> > -                * to follow so fast.  This is a simple
> > -                * solution that works without
> > -                * complicating the code and causes no
> > -                * significant slowing down on mount
> > -                * for everyone else
> > -                */
> > -               usleep_range(1000, 2000);
> > -       }
> > +       smb_buf->smb_buf_length = cpu_to_be32((RFC1002_SESSION_REQUEST << 24) | len);
> > +       rc = smb_send(server, smb_buf, len);
> >         /*
> > -        * else the negprot may still work without this
> > -        * even though malloc failed
> > +        * RFC1001 layer in at least one server requires very short break before
> > +        * negprot presumably because not expecting negprot to follow so fast.
> > +        * This is a simple solution that works without complicating the code
> > +        * and causes no significant slowing down on mount for everyone else
> >          */
> > +       usleep_range(1000, 2000);
> >
> >         return rc;
> >  }
> > --
> > 2.39.1
> >



-- 
Thanks,

Steve
