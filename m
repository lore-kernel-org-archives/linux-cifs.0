Return-Path: <SRS0=ZZqS=ZA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.4 required=3.0 tests=BIGNUM_EMAILS,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8D9C5DF60
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 06:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4ECA1214DA
	for <linux-cifs@archiver.kernel.org>; Fri,  8 Nov 2019 06:58:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/NllLxj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726149AbfKHG6w (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 8 Nov 2019 01:58:52 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:39116 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfKHG6w (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 8 Nov 2019 01:58:52 -0500
Received: by mail-io1-f67.google.com with SMTP id k1so5227482ioj.6
        for <linux-cifs@vger.kernel.org>; Thu, 07 Nov 2019 22:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tJSKKOKWIzZmPBGPWeIG6jPO7n2X30HQfnEY7hDHsvw=;
        b=k/NllLxjxRteaRlV6JKiiOVo6nnXAXan+UzRinOwJV13AJVImW02hSYunfkOdjExF0
         KuIH4m4O2kOfGo5uWVvsbtou5JfPjLZ8Kp64+973jZ9V9kacN72H+5HeV/BWoU4lCQ/p
         mMvmtsWxtxARqGTyXTZTUxCcgmd8J06DPPQrin6JWJHAQw3OXjf8H8HVEw4j9t9Qlik5
         gFot2dbdga/FWiXBbnS4nhEXO+jGj5pL/G2AdSuxLhQ2pVeC8KuKGnNO1ycDNMK4DrCU
         wCo3nWvzOjkPfF2wUTqRtDd58yb/K/DboGZnWh3yIUMt1nIhJ5GW0SGZX2kLLL+oo1WV
         nMgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tJSKKOKWIzZmPBGPWeIG6jPO7n2X30HQfnEY7hDHsvw=;
        b=TZ+cLKan9DXlK+0eVSd03j31/yz7W0aQymSJXealYgIm/Ns2KD5MPdSVCPoW5lTB9B
         71GsFTTLU/KjlSJc7+bTxZqcdn5vpVh0UZOfulcmiv6pnph1sRPkpZFipKw43Q+9jQK+
         V7z0EkI+GRsye9mSFjnIQLTWRig9i+ns0jA94sbr5tqYyF6ZsBed31psCYrxYATVD8BE
         j6q+SfQYQXad0YESdxJFvVxdSOuF9cKZVhrVssqIClAXoyCyDKGhNeIzQ+AofCvw12oi
         kQhdfSKgkuLdluYUL/77HVAjICXGhY+BII8W5IrxOgjxAAxXSNI1gevl5qRnnb1tAdVo
         SKrw==
X-Gm-Message-State: APjAAAWp2AR0x8J/wUWuyfx6OTFfkbZ5T19li31wWVcSQGZVFTz1Rr5A
        nf0JS7zTMVIZTWbpXjiArYv97B3UvLS+GF9b1oA=
X-Google-Smtp-Source: APXvYqz01f6F9/eMcRNWVVRdC1JiU5S2zAL8tJfk9jg353UEQiV92YnDqhWfFFFTMZ4kC5DQW4MzLnknoXYSJtc/kF8=
X-Received: by 2002:a5e:8201:: with SMTP id l1mr8112569iom.173.1573196331534;
 Thu, 07 Nov 2019 22:58:51 -0800 (PST)
MIME-Version: 1.0
References: <20191108051954.GA27432@mwanda>
In-Reply-To: <20191108051954.GA27432@mwanda>
From:   Steve French <smfrench@gmail.com>
Date:   Fri, 8 Nov 2019 00:58:40 -0600
Message-ID: <CAH2r5mt0fSMAGZ+V9KHFxY+Ec8Vj1i6qYOVA4DK09fPT+gL5XQ@mail.gmail.com>
Subject: Re: [bug report] smb3: remove confusing dmesg when mounting with
 encryption ("seal")
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Steve French <stfrench@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This was fixed in a later version of this patch yesterday, but ...
Pavel suggested just removing the warning message that prompted this
patch - easier, and the warning message wasn't very useful.

On Thu, Nov 7, 2019 at 11:20 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Hello Steve French,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 6a364520b30e: "smb3: remove confusing dmesg when mounting
> with encryption ("seal")" from Nov 5, 2019, leads to the following
> Smatch complaint:
>
>     fs/cifs/connect.c:1091 cifs_handle_standard()
>     warn: variable dereferenced before check 'mid' (see line 1075)
>
> fs/cifs/connect.c
>   1074          length = server->ops->check_message(buf, server->total_read, server,
>   1075                                              mid->decrypted);
>                                                     ^^^^^^^^^^^^^^
> New unchecked dereference.
>
>   1076          if (length != 0)
>   1077                  cifs_dump_mem("Bad SMB: ", buf,
>   1078                          min_t(unsigned int, server->total_read, 48));
>   1079
>   1080          if (server->ops->is_session_expired &&
>   1081              server->ops->is_session_expired(buf)) {
>   1082                  cifs_reconnect(server);
>   1083                  wake_up(&server->response_q);
>   1084                  return -1;
>   1085          }
>   1086
>   1087          if (server->ops->is_status_pending &&
>   1088              server->ops->is_status_pending(buf, server))
>   1089                  return -1;
>   1090
>   1091          if (!mid)
>                     ^^^^
> The old code assumed it could be NULL.
>
>   1092                  return length;
>   1093
>
> regards,
> dan carpenter



-- 
Thanks,

Steve
