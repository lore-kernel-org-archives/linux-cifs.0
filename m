Return-Path: <SRS0=K6R1=ZX=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72500C432C0
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Dec 2019 05:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3DA3E2146E
	for <linux-cifs@archiver.kernel.org>; Sun,  1 Dec 2019 05:35:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ggt0xBK6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbfLAFfN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 1 Dec 2019 00:35:13 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:37535 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfLAFfN (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 1 Dec 2019 00:35:13 -0500
Received: by mail-io1-f67.google.com with SMTP id k24so25964537ioc.4;
        Sat, 30 Nov 2019 21:35:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sJQcM8e79LdID7SJT/aUfaYNQnE4oxz+A2Ga3u3OXxk=;
        b=Ggt0xBK6ayUUJIPIUJSgHo09KPkzXQDXzCPb5v2MtEgRG6YjECDJvMKrIkL56hYY5N
         dYBZxpOap3gWbI+9PaQiic21+2AjihwrGlx1+izI17nXlYkm9YrD8KxbfRHuxoRMvQ7i
         rNPYkD8RWwPqw6Um9igtPw8c53BQi4ZRygPCqG1W2QVOCjMRxGwOzWQr0ZLO+EbXYAE8
         WihAqIu+3adQcbTTDOSKEZtf3az5+QosH+WDLXWrF0PKn37EtTUAyQxKDl5jrohXFRWG
         JGVoacaLiltk3NqFQ2ZhONu4MOf4rySvHEwbkuRY2tGW/fUnXhf129v0SWseM7Rgi7EP
         O6TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sJQcM8e79LdID7SJT/aUfaYNQnE4oxz+A2Ga3u3OXxk=;
        b=G7VBNtLGdLSVoj9ZmMlUbkZQ/TL8s+V5iZTKhxpELwEK4HDWSs5TA5ei60bLQZRhHl
         tDOqDcyimrtLd8Iy+jt7PA6gskHM9GMiXrcZb7hlvsuzYiGUgXd7AOqdGa+plHphvqi1
         tqrEGYzT3jkUGuC4ODobLu4h0vSspi1osVWkqLhLdypUr6WEEpLwSaFFAwR44CdBLVow
         tO06Z109DjDFFW/HnYLkIENHMy2GtVVP16an4gJcB334EjZ7pfryBfv2K/m2kLviuiEH
         tYDazd7zS2PmZjw79+rZxUsaScCf6qq5P0Y9VrsvNlu8WULL7pYSaoFKB4SDArdvBBiW
         E3lg==
X-Gm-Message-State: APjAAAXa/so0kLwxyx9AxhfBlN5g/9BbhnQ+zd/NHrJKgsJwhVF0vEsR
        gvEjhgex5Y9HEUjt7xD13wxkQrDd9Hyp1fTmnqX+kSLz
X-Google-Smtp-Source: APXvYqxgR5gd1Xc5/oz6JVC+0qRl+GNCb1fdTE7mpJK4qvOtZh324a29v/Zbxd7z9kQhQdc6I5TWxVeTB2wi59a4SpI=
X-Received: by 2002:a6b:ee02:: with SMTP id i2mr13989917ioh.153.1575178512181;
 Sat, 30 Nov 2019 21:35:12 -0800 (PST)
MIME-Version: 1.0
References: <20191130053030.7868-1-deepa.kernel@gmail.com> <20191130053030.7868-4-deepa.kernel@gmail.com>
 <CAH2r5msrqokxHGr6c4N8=mOw6v1h9ZXDQFSVMRPHnTmV1n0L=w@mail.gmail.com>
In-Reply-To: <CAH2r5msrqokxHGr6c4N8=mOw6v1h9ZXDQFSVMRPHnTmV1n0L=w@mail.gmail.com>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Sat, 30 Nov 2019 21:35:01 -0800
Message-ID: <CABeXuvqpa4dx6MDwsG-J+1ZNF5FwhunraAKaE1-03Eehz22QiA@mail.gmail.com>
Subject: Re: [PATCH 3/7] fs: cifs: Delete usage of timespec64_trunc
To:     Steve French <smfrench@gmail.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steve French <stfrench@microsoft.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Nov 30, 2019 at 1:25 PM Steve French <smfrench@gmail.com> wrote:
>
> Is this intended to merge separately or do you want it merged through
> the cifs git tree?

It would be simplest for all uses of timespec64_trunc to be removed
through the same tree. Otherwise, whoever takes the [PATCH 6/7] ("fs:
Delete timespec64_trunc()") would have to depend on your tree.

Thanks,
-Deepa
