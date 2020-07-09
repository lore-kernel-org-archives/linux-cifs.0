Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AC5C433E0
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 05:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D9D8B2053B
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 05:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iGg48WSV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgGIFUA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 01:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgGIFT7 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 9 Jul 2020 01:19:59 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0628C061A0B
        for <linux-cifs@vger.kernel.org>; Wed,  8 Jul 2020 22:19:59 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id q8so1023593iow.7
        for <linux-cifs@vger.kernel.org>; Wed, 08 Jul 2020 22:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4u4m4Lx8EHaxpdPrmFfF6PVOAqtep1Zffvb/EYduSCk=;
        b=iGg48WSVFFGYujoYKFCQygEKoxMw4Wv37sFrTsVNpqsJjA6WJzvostk27wi88CZNeg
         62QzAe81ahE51dkUGuQ9e4XWZ9oHZZK9NTs5W05+SUj4cxjpPQn/gh3Psrmk66p/bX2X
         6bgyBfzV5o15x+TYidQ4jAGB3T3EQRl1Eg0eu3zC4cHOEhwwSCzb1sKry59iQiRaXIGA
         Lki9PGEMFjyMu7z79yHxtCmtU+Jyq1EGb3pbayH8ciTDMTLqHwNxvk/0koDM0lgtzWZm
         NnCvRMHPtF1gB7E3br31S/RQoeaMN2WhXfHigDXUN1TyufWVz2Vnslx5VW4a4Llnh6pF
         Dg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4u4m4Lx8EHaxpdPrmFfF6PVOAqtep1Zffvb/EYduSCk=;
        b=C0f/M+zTBKrPQaalRpY3au8GpJRZIbAW8tozKP0BbiP+SDNMnzCGv4QhSZpJ5GjOY6
         QJmVtHvg/a6NfTzsEp1DTYZ9y4D/JoC5ypKhMKjevMuvGz9wPXhgNkVf1ctkV8Tp9eMl
         Til9RezoF5qc18mX9WTG0V8m+fRDlaqjTbpC+DeLBu0+YeL9OOj2XMGDjPSdlmJ+Iemb
         333W8kKqGUm+2RvYl8p1BCU6f9fA82z2ZcDpxXjmH6BJALF04oqwiSXJlelsPKjAuNjn
         OmFGMBovTyu0nE+D11lMaxOHz4Z8q05Ixc+9ywX3W671FBEY/fn6fC6/hAPJDEqd8kgJ
         awvw==
X-Gm-Message-State: AOAM530Tcwtz7s+OxqoEnQmvLODS5K1eKfuRYy1eGmWOUkWgvFiBqXjE
        ztpryNXk0SjpgfvCg0Z4TOPXiRal751kw0NZipg=
X-Google-Smtp-Source: ABdhPJz6JLE0HdfMyCf+pEhiYjWkG4MeWbL/rMg9GdEQsgjj4TZnce+16DjvBAQxVqGQz0lQqZXMmn3lAXyd+ua9fyE=
X-Received: by 2002:a05:6602:21c7:: with SMTP id c7mr40672417ioc.1.1594271998829;
 Wed, 08 Jul 2020 22:19:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200703092932.18967-1-rbergant@redhat.com>
In-Reply-To: <20200703092932.18967-1-rbergant@redhat.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Thu, 9 Jul 2020 15:19:47 +1000
Message-ID: <CAN05THT0tgcOVj=_Ky_=_AUSLim8ngBvzxAQ27qNg4CLRUjY9Q@mail.gmail.com>
Subject: Re: [PATCH] cifs : handle ERRBaduid for SMB1
To:     Roberto Bergantinos Corpas <rbergant@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>

On Fri, Jul 3, 2020 at 7:30 PM Roberto Bergantinos Corpas
<rbergant@redhat.com> wrote:
>
> If server returns ERRBaduid but does not reset transport connection,
> we'll keep sending command with a non-valid UID for the server as long
> as transport is healthy, without actually recovering. This have been
> observed on the field.
>
> This patch adds ERRBaduid handling so that we set CifsNeedReconnect.
>
> map_and_check_smb_error() can be modified to extend use cases.
>
> Signed-off-by: Roberto Bergantinos Corpas <rbergant@redhat.com>
> ---
>  fs/cifs/cifsproto.h |  1 +
>  fs/cifs/netmisc.c   | 27 +++++++++++++++++++++++++++
>  fs/cifs/transport.c |  2 +-
>  3 files changed, 29 insertions(+), 1 deletion(-)
>
> diff --git a/fs/cifs/cifsproto.h b/fs/cifs/cifsproto.h
> index 948bf3474db1..d72cf20ab048 100644
> --- a/fs/cifs/cifsproto.h
> +++ b/fs/cifs/cifsproto.h
> @@ -149,6 +149,7 @@ extern int decode_negTokenInit(unsigned char *security_blob, int length,
>  extern int cifs_convert_address(struct sockaddr *dst, const char *src, int len);
>  extern void cifs_set_port(struct sockaddr *addr, const unsigned short int port);
>  extern int map_smb_to_linux_error(char *buf, bool logErr);
> +extern int map_and_check_smb_error(struct mid_q_entry *mid, bool logErr);
>  extern void header_assemble(struct smb_hdr *, char /* command */ ,
>                             const struct cifs_tcon *, int /* length of
>                             fixed section (word count) in two byte units */);
> diff --git a/fs/cifs/netmisc.c b/fs/cifs/netmisc.c
> index 9b41436fb8db..ae9679a27181 100644
> --- a/fs/cifs/netmisc.c
> +++ b/fs/cifs/netmisc.c
> @@ -881,6 +881,33 @@ map_smb_to_linux_error(char *buf, bool logErr)
>         return rc;
>  }
>
> +int
> +map_and_check_smb_error(struct mid_q_entry *mid, bool logErr)
> +{
> +       int rc;
> +       struct smb_hdr *smb = (struct smb_hdr *)mid->resp_buf;
> +
> +       rc = map_smb_to_linux_error((char *)smb, logErr);
> +       if (rc == -EACCES && !(smb->Flags2 & SMBFLG2_ERR_STATUS)) {
> +               /* possible ERRBaduid */
> +               __u8 class = smb->Status.DosError.ErrorClass;
> +               __u16 code = le16_to_cpu(smb->Status.DosError.Error);
> +
> +               /* switch can be used to handle different errors */
> +               if (class == ERRSRV && code == ERRbaduid) {
> +                       cifs_dbg(FYI, "Server returned 0x%x, reconnecting session...\n",
> +                               code);
> +                       spin_lock(&GlobalMid_Lock);
> +                       if (mid->server->tcpStatus != CifsExiting)
> +                               mid->server->tcpStatus = CifsNeedReconnect;
> +                       spin_unlock(&GlobalMid_Lock);
> +               }
> +       }
> +
> +       return rc;
> +}
> +
> +
>  /*
>   * calculate the size of the SMB message based on the fixed header
>   * portion, the number of word parameters and the data portion of the message
> diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
> index cb3ee916f527..e8dbd6b55559 100644
> --- a/fs/cifs/transport.c
> +++ b/fs/cifs/transport.c
> @@ -935,7 +935,7 @@ cifs_check_receive(struct mid_q_entry *mid, struct TCP_Server_Info *server,
>         }
>
>         /* BB special case reconnect tid and uid here? */
> -       return map_smb_to_linux_error(mid->resp_buf, log_error);
> +       return map_and_check_smb_error(mid, log_error);
>  }
>
>  struct mid_q_entry *
> --
> 2.21.0
>
