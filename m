Return-Path: <SRS0=//+f=TY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC683C282DD
	for <linux-cifs@archiver.kernel.org>; Fri, 24 May 2019 00:44:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DCDA2177E
	for <linux-cifs@archiver.kernel.org>; Fri, 24 May 2019 00:44:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kgWuwz97"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387613AbfEXAo3 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 23 May 2019 20:44:29 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:52674 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387582AbfEXAo3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 23 May 2019 20:44:29 -0400
Received: by mail-it1-f196.google.com with SMTP id t184so13034916itf.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 May 2019 17:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cBdTpIg2gWXtHdWWQaizcWsMiKn69d5jlf7saug0Gc8=;
        b=kgWuwz97jeBSyNltwZRW4zJBJgJ0SmXuu4hZhkWriaXEJ7dB4EuxisBWwzD9ISjb1d
         b2bXuCLtHSdv6Hyvq8QfAO10sDWSKTM0oQRMQIDoj6e9kk4J0mTvjLaxCgxRMh7jwuCU
         73nTUzLDJLwCQZwipQ5sJu7FEaoNqpiPVU3aZEJASa5+zpVKHBvUckQmIpTnONeNkI7m
         TLdaYbyNnA2WvSJMPwS+yyd54zCG5NEKGlyjoA677DpMAZGPfg8KayykBiZJwAfqOqJ5
         4e4UKJU+MFnfc5cqRqM5JlijPzCdi9SqC81wPG2GGUpQQqyFQT5vGoQsLL4gOhyiCtMI
         t/OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cBdTpIg2gWXtHdWWQaizcWsMiKn69d5jlf7saug0Gc8=;
        b=aIHyovzVZHe2jNu5e3CKixi68BrTbNDEvD38T5b4jo8oMCTykd/3YTBNSjd3wia9f7
         VuNg46J1jB4I3Hfi0cfy3ILyqE5PYociiUBoWu0uJQdHgf7TkfOtefOYwZ6vHhygGyb/
         uqegZdBHUsQcyRNgmqCwrAFcSZNBkqSuArGmxuS4/Zuvc/CIuBXOTPjq3wYcnQN2jeSF
         AzDZDfnK7TfL0sk5t+Dg7GXW04K/O2+WY/Vj3441rUMv3STJ8hfxN0kUcQcgCWWhFMVS
         hSSMsaWqVHZlcJDOID4tnxpG/F3nH4rVpJTQOESgeLpISmPGQwHcEpzjQPnqR918dxxf
         pd4w==
X-Gm-Message-State: APjAAAWGT5oDbxebmRiEq4zZ0/XArUKmpsXOHskR07cmnimLR8JfzB7i
        d+afLwGo/BT0YpzHrz2UaBC9tzwxFsElvf7WW38=
X-Google-Smtp-Source: APXvYqy3Sv2APT+/ht41+W7tahXc0FfaR1Yukoijj4q8P7YstoOBuiYBcSlcbcp7qj5Y4/K3eJc0+DDMAmPLAYQxXAo=
X-Received: by 2002:a24:7c97:: with SMTP id a145mr11243094itd.117.1558658668746;
 Thu, 23 May 2019 17:44:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190523041243.12340-1-jencce.kernel@gmail.com>
In-Reply-To: <20190523041243.12340-1-jencce.kernel@gmail.com>
From:   ronnie sahlberg <ronniesahlberg@gmail.com>
Date:   Fri, 24 May 2019 10:44:17 +1000
Message-ID: <CAN05THTBYkDOdqLaS8Pt6n3xs-v9GSXsrzFbnj+NOUGb=RwyCA@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs/smb2pdu.c: fix buffer free in SMB2_ioctl_free
To:     Murphy Zhou <jencce.kernel@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        Long Li <longli@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, May 23, 2019 at 2:14 PM Murphy Zhou <jencce.kernel@gmail.com> wrote:
>
> The 2nd buffer could be NULL even if iov_len is not zero. This can
> trigger a panic when handling symlinks. It's easy to reproduce with
> LTP fs_racer scripts[1] which are randomly craete/delete/link files
> and dirs. Fix this panic by checking if the 2nd buffer is padding
> before kfree, like what we do in SMB2_open_free.

Looks good.

Reviewed-by: Ronnie Sahlberg <lsahlber@redhat.com>


>
> [1] https://github.com/linux-test-project/ltp/tree/master/testcases/kernel/fs/racer
>
> Fixes: 2c87d6a ("cifs: Allocate memory for all iovs in smb2_ioctl")
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> ---
>  fs/cifs/smb2pdu.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 710ceb8..c36f940 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2619,10 +2619,12 @@ int smb311_posix_mkdir(const unsigned int xid, struct inode *inode,
>  void
>  SMB2_ioctl_free(struct smb_rqst *rqst)
>  {
> +       int i;
>         if (rqst && rqst->rq_iov) {
>                 cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
> -               if (rqst->rq_iov[1].iov_len)
> -                       kfree(rqst->rq_iov[1].iov_base);
> +               for (i = 1; i < rqst->rq_nvec; i++)
> +                       if (rqst->rq_iov[i].iov_base != smb2_padding)
> +                               kfree(rqst->rq_iov[i].iov_base);
>         }
>  }
>
> --
> 1.8.3.1
>
