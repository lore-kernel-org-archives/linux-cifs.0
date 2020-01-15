Return-Path: <SRS0=xi6A=3E=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5F0C32771
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8051B222C3
	for <linux-cifs@archiver.kernel.org>; Wed, 15 Jan 2020 20:53:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lvop1QhX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728596AbgAOUxk (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 15 Jan 2020 15:53:40 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:38221 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgAOUxj (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 15 Jan 2020 15:53:39 -0500
Received: by mail-io1-f67.google.com with SMTP id i7so10902103ioo.5;
        Wed, 15 Jan 2020 12:53:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YWIHRbYWg17G075OY4eWYQhDn0gRsG9PxICiq1XbMr8=;
        b=Lvop1QhXrCEbQx2immTT1T6xd7Fg2zKxq5onuyBGSnZ7dU1zv4gwaZkY4ZACskshd+
         Ac85gV7njN9+DH22TJiIdpN309gssNeKtNMDAUSRLSPVq+3MYFJI8JHIBKV6FnMClI2k
         Nmqz6hcUmIB7ZzsbE6DioYhKbBKB3U6WF7l1sRHQfOumOgwl7u3+kAgGf1o6erJq3XTX
         nxc2o7XnFxutgZiCNO/piqNRYsSVH+meRegX9mXPljhW6kG1i01JjgazqEf9wd2hjm+7
         RMMZJZBJHeceUkjK99sf419KZTNbeLH7NSMDqTz8y2HtnmC64kDQmaTI2FuDzinzlaFN
         eeAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YWIHRbYWg17G075OY4eWYQhDn0gRsG9PxICiq1XbMr8=;
        b=R7+kCa1aMis3BoVdcazgh6OAuwxDmSuaWOE60A1krvv+sls6wkyI2/tW9kj2AHX/+o
         0hACSn0g/hNd9wUX/DBQMvZKYm2yWvbykizfe1wmbg95QDcLMpI7kfypwtWWdCDoKU2a
         P8+WzyDUgCsO4a5sM1VzctFuCcRu0NN2ScJz8W3Ak7aH2m4G/H4sr7+d7pUvhZ0FVf6q
         w0pouv8i5JljJk3Wrw9hLNTyYkDeTXhPBBozG9BUz1u7q+Fpn2fD1iuArUW3Bg6qVB/D
         UdDoc/R7NX6UKbmz97nZrZU6F4lRrpq7y+lH0rIxNw0W8XfuNrn+LB5pYcjvKZLa7Rhv
         CEPg==
X-Gm-Message-State: APjAAAVsnjMZzYiK5WTaQJvncZ4c0WmolHBaaeCPs5qwNwWKcekqARAI
        LFmKSfwMnCa3G0M14HZ4Qpjx9JYeLvO0xvpX7jGKUX1u
X-Google-Smtp-Source: APXvYqzrrT1mqNol7/s30EC4wo/MmtHb5zzwePJp5mVWT+JRRMSFP+DT8sWmfEDB31Wo3Rinfyf7H9kaAeNEKqlDskQ=
X-Received: by 2002:a5d:84d1:: with SMTP id z17mr1872158ior.169.1579121618886;
 Wed, 15 Jan 2020 12:53:38 -0800 (PST)
MIME-Version: 1.0
References: <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
In-Reply-To: <157432403818.17624.9300948341879954830.stgit@warthog.procyon.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 15 Jan 2020 14:53:28 -0600
Message-ID: <CAH2r5msP9W5Jd+=W0oFnEbqzj5dYEzdiydSoX0m0sdZ5KOF-zQ@mail.gmail.com>
Subject: Re: [PATCH] cifs: Don't use iov_iter::type directly
To:     David Howells <dhowells@redhat.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tentatively merged into cifs-2.6.git for-next (pending more of the
usual automated testing we do with the buildbot)

On Thu, Nov 21, 2019 at 2:14 AM David Howells <dhowells@redhat.com> wrote:
>
> Don't use iov_iter::type directly, but rather use the new accessor
> functions that have been added.  This allows the .type field to be split
> and rearranged without the need to update the filesystems.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>  fs/cifs/file.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/cifs/file.c b/fs/cifs/file.c
> index fa7b0fa72bb3..526f2b95332d 100644
> --- a/fs/cifs/file.c
> +++ b/fs/cifs/file.c
> @@ -2833,7 +2833,7 @@ cifs_write_from_iter(loff_t offset, size_t len, struct iov_iter *from,
>                                         "direct_writev couldn't get user pages "
>                                         "(rc=%zd) iter type %d iov_offset %zd "
>                                         "count %zd\n",
> -                                       result, from->type,
> +                                       result, iov_iter_type(from),
>                                         from->iov_offset, from->count);
>                                 dump_stack();
>
> @@ -3044,7 +3044,7 @@ static ssize_t __cifs_writev(
>          * In this case, fall back to non-direct write function.
>          * this could be improved by getting pages directly in ITER_KVEC
>          */
> -       if (direct && from->type & ITER_KVEC) {
> +       if (direct && iov_iter_is_kvec(from)) {
>                 cifs_dbg(FYI, "use non-direct cifs_writev for kvec I/O\n");
>                 direct = false;
>         }
> @@ -3556,7 +3556,7 @@ cifs_send_async_read(loff_t offset, size_t len, struct cifsFileInfo *open_file,
>                                         "couldn't get user pages (rc=%zd)"
>                                         " iter type %d"
>                                         " iov_offset %zd count %zd\n",
> -                                       result, direct_iov.type,
> +                                       result, iov_iter_type(&direct_iov),
>                                         direct_iov.iov_offset,
>                                         direct_iov.count);
>                                 dump_stack();
> @@ -3767,7 +3767,7 @@ static ssize_t __cifs_readv(
>          * fall back to data copy read path
>          * this could be improved by getting pages directly in ITER_KVEC
>          */
> -       if (direct && to->type & ITER_KVEC) {
> +       if (direct && iov_iter_is_kvec(to)) {
>                 cifs_dbg(FYI, "use non-direct cifs_user_readv for kvec I/O\n");
>                 direct = false;
>         }
>


-- 
Thanks,

Steve
