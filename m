Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77AD6C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 17:13:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EFB521900
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 17:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728078AbfCURNd (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 13:13:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50848 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbfCURNc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 13:13:32 -0400
Received: from mail-ot1-f70.google.com ([209.85.210.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <andreas.hasenack@canonical.com>)
        id 1h71Fz-0004mG-2a
        for linux-cifs@vger.kernel.org; Thu, 21 Mar 2019 17:13:31 +0000
Received: by mail-ot1-f70.google.com with SMTP id q26so3390310otf.19
        for <linux-cifs@vger.kernel.org>; Thu, 21 Mar 2019 10:13:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L4TBTrihcW1OmDzz12SSIsxvMxaFLq4QVEW6CGs8Jt4=;
        b=ZQ1w3kRpz5g2o64TFACjxSunG9C8CG7YP5Di3TtwX65OpkO4noNg+M42AcD1BZPLLh
         A/U1aEHPgFMZJrLaBFjyh9qAqIk34Jt4nmAphs3qwelg8v/mUe2sJBTDiNOR+h/Z84K2
         S0pjnpYzrLzrcJK3DiRm0lSHG1GGrx7zkfSGaSLwPd7zRtBqzq1h1kO0Ek7ZhI8twJXw
         n/dY4xEppulxfB6sgUT7+bV4EVG0CBjfg6fJkn5gf8qhgqL4U7MvlVaiI5ExldGWIb8N
         8uBP3iCXMGRAPyiabQk7yajc3wEgkX4wlGkMmboCVDgDnLq7e5HXoHMHw3HBXtRVzDX4
         1JAg==
X-Gm-Message-State: APjAAAUal6O16OwkJIwE+L7dyWq6N2JOf4FVZlDLUEyhtitwq1t+dcPO
        J+/vXOFXENxTnLp8pKjmHgQKuIDKf0a3dYE0xctlVozx98/T//19T0czHou4QzCty4M6R/o+TEP
        M240i+E/06iMqFbNk7a1UBRjvN9a/rvkD8UMvoA9oTUQnNGQHy6GTNj0=
X-Received: by 2002:aca:5902:: with SMTP id n2mr267344oib.110.1553188409967;
        Thu, 21 Mar 2019 10:13:29 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyqSUmnDr8g5HhzI6yBsF2DDqdr/FGJ+XzeLeq2ZDzovPIy/8pQT75iXyoqUjvU3EYyix+U1qrrOaIgY2V7h+s=
X-Received: by 2002:aca:5902:: with SMTP id n2mr267322oib.110.1553188409594;
 Thu, 21 Mar 2019 10:13:29 -0700 (PDT)
MIME-Version: 1.0
References: <20190321045902.14326-1-lsahlber@redhat.com>
In-Reply-To: <20190321045902.14326-1-lsahlber@redhat.com>
From:   Andreas Hasenack <andreas@canonical.com>
Date:   Thu, 21 Mar 2019 14:13:18 -0300
Message-ID: <CANYNYEHur0w8iNZBHUbc=NJopAH84gLb5k-Wv1ShU9--qREoCw@mail.gmail.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hello Ronnie,

On Thu, Mar 21, 2019 at 1:59 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Fix Guest/Anonymous sessions so that they work with SMB 3.11.
>
> In git commit 6188f28 tightened the conditions and forced signing for
> the SMB2-TreeConnect commands as per MS-SMB2.
> However, this should only apply to normal user sessions and not for
> Guest/Anonumous sessions.
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> CC: Stable <stable@vger.kernel.org>
> ---
>  fs/cifs/smb2pdu.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index c399e09b76e6..8e4a1da95418 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1628,9 +1628,13 @@ SMB2_tcon(const unsigned int xid, struct cifs_ses *ses, const char *tree,
>         iov[1].iov_base = unc_path;
>         iov[1].iov_len = unc_path_len;
>
> -       /* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1 */
> +       /*
> +        * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1
> +        * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> +        */
>         if ((ses->server->dialect == SMB311_PROT_ID) &&
> -           !smb3_encryption_required(tcon))
> +           !smb3_encryption_required(tcon) &&
> +           !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
>                 req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>
>         memset(&rqst, 0, sizeof(struct smb_rqst));
> --
> 2.13.6
>


I tried this patch with an ubuntu kernel
(https://people.canonical.com/~tyhicks/disco-cifs.2/ specifically) but
it didn't work, I'm still getting failures with smb3.11 and a guest
mount.

Maybe I'm missing some other fix, or a more up-to-date kernel? Shall I
try with a self-compiled upstream one?

dmesg: http://paste.ubuntu.com/p/JGhCsgBVcb/

server logs (debug level 5, samba 4.10.0):
log.: http://paste.ubuntu.com/p/jMDJ8DBfRM/
log.smbd: http://paste.ubuntu.com/p/Z9W5z28BP9/
smb.conf: http://paste.ubuntu.com/p/9HpSyFq8n8/
