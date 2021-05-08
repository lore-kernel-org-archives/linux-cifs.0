Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB292C433B4
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 12:30:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6163601FD
	for <linux-cifs@archiver.kernel.org>; Sat,  8 May 2021 12:30:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230326AbhEHMbT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 8 May 2021 08:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230419AbhEHMbR (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 8 May 2021 08:31:17 -0400
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762B3C061574
        for <linux-cifs@vger.kernel.org>; Sat,  8 May 2021 05:30:16 -0700 (PDT)
Received: by mail-yb1-xb33.google.com with SMTP id h202so15422066ybg.11
        for <linux-cifs@vger.kernel.org>; Sat, 08 May 2021 05:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gC5aAitydEirSJmKm7+ZvllnGyChNePS7SviEnapacI=;
        b=umii6971AAZAkZlVSB0P6k39gK/1ILSbImpFeQMUodszo3uZI8oLFktGoF5v02cV8a
         /ofpAkT945RKyo+qjvko0euaZUUd7KxblEjbm7qHP654hwAPgr1HXq2ff3Gzin0HLNX0
         lrO0WNQiBk1nG/sy3iNl8Bmp7TMaNeIQPW1UaXQFrp/vtx5EA84qDGVxVtbOA7v+Rd8J
         8rpwo8U/OoOboHSQDi+ahS+SnOEys2QZkDdSeQtyBgvSZTJaQ4lTR7a4ToBZmkq/MwS7
         vyblrTdDzNLhPe26di/FHc7tLBIetapXzr5vodSXppJFzehDMq9TzpfHmET/dh1m5Tck
         /ZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gC5aAitydEirSJmKm7+ZvllnGyChNePS7SviEnapacI=;
        b=USYa8bNvE91RM1fZ/xK2Ld8ng0DJwTaYDfXiOyo4DkTaS+ox0yBHWl330GSKyxvsQs
         yFg1uqmZzBiaNIXnoUV/UIlCY2xBZgTR6A4tfBMLnvavEOe0mSmxGiq90gey8nzvZbak
         fmX0tzVJ5p2PcbNQuxP3kdZS+UL1prdD0yEBR/DHCe8Kr9ZE8w5hS7kDdC3F0idVJGAr
         weQ8K8VkVucjGd5SlUFva/QjBV7pZUe5TAX1vhOFXlQMYaL/pRokN0qYlUDngQANjBIN
         yE91LzlRus6IZYncq00bV6alu4/5IXbd2tdrQ9aLsqK59mX1juRBkQSKT8G92VMhqsYO
         b6Ig==
X-Gm-Message-State: AOAM532Y9w593RdJ55UzC6MXsagupr1HUin3eMmDNuX87YKcJKtXyzaK
        yRekdlyKVuGsuLMHlQfwZU78yxpGW/qeuhv1yB6l/PfV
X-Google-Smtp-Source: ABdhPJze+eSvWcCg5pElYlFmH29hVxzAbb81WrVIV6JSbQTrcxTog61KiwzDHZ+Sfm6skd71tBFuqmARXqsQVq/egGg=
X-Received: by 2002:a25:ef42:: with SMTP id w2mr18686077ybm.34.1620477015690;
 Sat, 08 May 2021 05:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
In-Reply-To: <CAH2r5mu3m6FWWqrfOeQugXWGZOPiEE+Xgk8wc0rn8OgLRVPSWQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Sat, 8 May 2021 18:00:04 +0530
Message-ID: <CANT5p=q1o7UofWJGQ4iWzXhZ4VcaSQj4iciM17G6-Tza3Mefqw@mail.gmail.com>
Subject: Re: [PATCH][SMB3] 3 small multichannel client patches
To:     Steve French <smfrench@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>
... for all three patches.

For 0003, logging is okay for now. However, when we have a way to pass
custom messages to userspace with new mount API, we should have this
message there too.

Regards,
Shyam

On Sat, May 8, 2021 at 6:43 AM Steve French <smfrench@gmail.com> wrote:
>
> 1) we were not setting CAP_MULTICHANNEL on negotiate request
> 2) we were ignoring whether the server set CAP_NEGOTIATE in the response
> 3) we were silently ignoring multichannel when "max_channels" was > 1
> but the user forgot to include "multichannel" in mount line.
>
>
>
> --
> Thanks,
>
> Steve



-- 
Regards,
Shyam
