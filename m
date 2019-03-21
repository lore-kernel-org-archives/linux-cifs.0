Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 258A5C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 19:00:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DC0CD21873
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 19:00:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="moWwFFsY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728679AbfCUTAq (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 15:00:46 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44912 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728651AbfCUTAq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Mar 2019 15:00:46 -0400
Received: by mail-pg1-f196.google.com with SMTP id i2so4807479pgj.11;
        Thu, 21 Mar 2019 12:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mgHSpuE/QQxqZNPhZcNevC0GqVyB9nb2T+/WH+9lj0I=;
        b=moWwFFsYXTEx+GcG7rfPCqeXFD7betLMDISmOjF0CmR5q6OBb2YcV/GAOykR5kQ4f7
         O5IXBHUKOX1qP4kvXeeB6IUEw2clFOT7xOPkai6JvNXg5vJBAKDRnmsgOAYa6owr3TkL
         9xxfMYeRrFfsD7VOzhty8Q619m/fTv7XVFdUKs3Xn6CM6fQcYb3edOJKsIkh7vjaRwwI
         iy+tH0YPIFYJbx6og/i+SV1m3A8POtFL9nKirSfonZISjf8GXo+ICWg9CiTXJEGPa5Ph
         UdZU5xjeXPgQ0ZBy1TmhGXCc+FSuJR0GZyG3W3ssYsJ2wcSZtqW9Gb4l+TkwWee8QcoL
         w2UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mgHSpuE/QQxqZNPhZcNevC0GqVyB9nb2T+/WH+9lj0I=;
        b=K6u56pYXm+Hy64XcIbKlpiGHmf1Z83V4AG7zQNHaHn7yr5XmhxAVJnThBn5hjsrG7J
         s/LYIE6z7wFG+eHUk6uClUrYLYn4FUFyk688H2r/ibTczVGJg4QKyDxQcS4hi/vFh5aj
         E6+yFpqJ5QuKZs44e8Z3YdHj3c/pJJvVIz1Xjx3EjnW/pA/0hXiwIgpzL+hT+uh2WNVU
         Dtdp39p3A163vr+jzekgu9ZF5iCOKGtNYFZizfi+u9ZIJHej86eNkxnZ1m/nAopkgcwO
         aLy7jYaw6c2CBz/O2655+K5Egq7eCh3kmGyRjE2Opq2WjnFlV6xKnxFpCRnjMQJ/LvdI
         5iZA==
X-Gm-Message-State: APjAAAVQwLSBVr+1eOM21JBGDM4UjuY0KurwVIWgvB32gYJrA/6nm+Y0
        hp6zb89yn1xEUp4l+AG/rwj2+n7XSy9ulS44MiqGmg==
X-Google-Smtp-Source: APXvYqzQG/JeNZuLWTd/JvMsRwNoVEWXaDplfnageQt/4jZh5AXugrvZpQCVXBEwXa9J0MTQDNL0CeWtQPyOWe0pz7k=
X-Received: by 2002:a17:902:b618:: with SMTP id b24mr4856815pls.73.1553194844071;
 Thu, 21 Mar 2019 12:00:44 -0700 (PDT)
MIME-Version: 1.0
References: <20190322054706.3927b16a@canb.auug.org.au>
In-Reply-To: <20190322054706.3927b16a@canb.auug.org.au>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 21 Mar 2019 14:00:32 -0500
Message-ID: <CAH2r5msGv07DGPp+5wzwBNcaMcKP32uvTsJCxcwSGYTsS4gwag@mail.gmail.com>
Subject: Re: linux-next: Signed-off-by missing for commit in the cifs tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     CIFS <linux-cifs@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

fixed

On Thu, Mar 21, 2019 at 1:47 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> Commit
>
>   828a8dfb7069 ("cifs: update internal module version number")
>
> is missing a Signed-off-by from its author and committer.
>
> --
> Cheers,
> Stephen Rothwell



-- 
Thanks,

Steve
