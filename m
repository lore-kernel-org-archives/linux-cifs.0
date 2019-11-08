Return-Path: <SRS0=ZZqS=ZA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89500FA372C
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 06:25:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57C9A2087E
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 06:25:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGJ9XJHT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725877AbfKHGZ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:25:27 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:42630 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHGZ1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Nov 2019 01:25:27 -0500
Received: by mail-io1-f66.google.com with SMTP id g15so5139133iob.9
        for <linux-cifs@vger.kernel.org>; Thu, 07 Nov 2019 22:25:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=piGujdKQqraB3pPmboMsNcCt0BhBIyxXBALFMDd+udU=;
        b=kGJ9XJHT97DnXcHQgox+W0+8Wai6QfYendjAVZtA7i9oZq0K6U0utezx+Su7gdacIp
         pxnRFcV1pdoNPVsPrK8IIh2797b6dmuPQRKlf4SO+1FxdGCNDhMun1dlBGqUB/CXZixl
         gFP4oq+dCuavL+ghd+KFKjhP6ae7HwZFnmJscd/g38wmfiB5aMVu52gdmghxwIq06/st
         QnPr4VPS53NkLXU1hPm02ZMGaEDXGg9Nck67uDPre1FaOqwgNDolE6pVFePQIBvRUqlQ
         BJKVQ1+FDsz6TT1g3xpQWfY8kRIBYsyUrgA+CErwrh3OGZjaChX51Hyr7Qb1QDPSC4hr
         ETfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=piGujdKQqraB3pPmboMsNcCt0BhBIyxXBALFMDd+udU=;
        b=Pwvfhbn4i/BCILu5pY1zlLffj8Sf/jAZ0p36ynzIXhTBPf+Jw8upfkAeID7uRaokRb
         sDgR+FElmpl3z0EYBMoU9sWdcIUwlW2NuTwt+5rcIVCmEpdWv1CvgeO78uZnvxgz++9j
         iaN7vComTfcCPjmVMg61WhV+lvwbeyBqi+rWVzRUZzjIC4sOGVwmaVnPzfCopjEABglF
         MoenT4yMR7NWKGn/apxQpPk5bPDLpjOONee8334XnKUNgan5Amt7IJNd7s0cgjXX1ZmB
         5hx/lDDS7W64arbg3Im9xC5UXYqF2Fk94uac7WtCQdJoxnL3LUUb6f8WYYRgMrrZeAO1
         Mqqg==
X-Gm-Message-State: APjAAAUVQGb7KbhNO6d3gqsR6oOQaIL4ZO8p2fhM7WIaBfXoGSkrMXvX
        wG+xmkUeb6yIJOAwb+UGcoh+KNYkJPdoRMP8hAI=
X-Google-Smtp-Source: APXvYqxAWiuBRK0HQ/Nt4ShIV43QulZUkbKGYE8fAC/cq33gblA79oyKIFCKzueeyXJgcGr0sPpM0X4uwsKfdhklAk4=
X-Received: by 2002:a05:6638:20a:: with SMTP id e10mr9495011jaq.27.1573194326451;
 Thu, 07 Nov 2019 22:25:26 -0800 (PST)
MIME-Version: 1.0
References: <20191107070038.6029-1-lsahlber@redhat.com>
In-Reply-To: <20191107070038.6029-1-lsahlber@redhat.com>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Nov 2019 00:25:15 -0600
Message-ID: <CAH2r5muu935+=ZUpZCKFn7bc9iAAm=rnihCbaNTCZ4GtHi_DQQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: close the shared root handle on tree disconnect
To:     Ronnie Sahlberg <lsahlber@redhat.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Thu, Nov 7, 2019 at 1:03 AM Ronnie Sahlberg <lsahlber@redhat.com> wrote:
>
> Signed-off-by: Ronnie Sahlberg <lsahlber@redhat.com>
> ---
>  fs/cifs/smb2pdu.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 05149862aea4..acb70f67efc9 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -1807,6 +1807,8 @@ SMB2_tdis(const unsigned int xid, struct cifs_tcon *tcon)
>         if ((tcon->need_reconnect) || (tcon->ses->need_reconnect))
>                 return 0;
>
> +       close_shroot(&tcon->crfid);
> +
>         rc = smb2_plain_req_init(SMB2_TREE_DISCONNECT, tcon, (void **) &req,
>                              &total_len);
>         if (rc)
> --
> 2.13.6
>


-- 
Thanks,

Steve
