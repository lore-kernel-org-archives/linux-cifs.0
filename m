Return-Path: <SRS0=eDtx=RA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D618C43381
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE1F72087C
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Feb 2019 07:26:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OETEe/f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfBYH0S (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Feb 2019 02:26:18 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:42113 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728217AbfBYH0S (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 25 Feb 2019 02:26:18 -0500
Received: by mail-pg1-f196.google.com with SMTP id b2so4066106pgl.9
        for <linux-cifs@vger.kernel.org>; Sun, 24 Feb 2019 23:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jWc8aSwCH47nuTyggFuQCnQnH9g6qTolsFnmQjrX/GE=;
        b=OETEe/f0dS5qSkRW/yHYUjm6LNHqGSRNGzePN0Q9/8aR2PlqWfEYhUVvTrQjG6f6nR
         UutCUfzddajHaahiGxPzu5IWHe511jr3mFlP6z3RPakzAgIDJ/BDPLQK5C00NVu7wB47
         Fp4i7mEBChkoJsLCIPDzDIBCApzde7g4QVej3EPDmUtsqZ02wPQbacOjKHGDMMpwphUh
         FDRJCMI/YiEy4AANzkqlPOdwe8mAZUfD/BrioeUeP9740lMNTffb9ybTnZejqaZWT+gK
         YceBLlSDr4lF5bCc0bO35LLAUUUu2c8m1ICZuORW3OJwQY7hseVESWQyH0BXQDGFZEjw
         2wFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jWc8aSwCH47nuTyggFuQCnQnH9g6qTolsFnmQjrX/GE=;
        b=hSN0mlglJjSwsvP/K1M8xP6r7rOW1jP1V7xh7JpDp1jjBUGyFto4AUC0Kg/jeJtFo3
         1CNupPgnLMz5jt9T2FhK7BQ4xP1VKCQiH/3AWS/SFXzQishbJs8n5/9zUBwRj7DfLVoK
         F27DBP2HwUJ+Ro4YRcc8JiBrKQcB4v1RfDJalT8yNTqb5sEK91fkF1onI6ZyIPbZBqCO
         WfXe+nnViq1l2VK4aM5Q9LGq4bSUg68j4wbysvTbRHs61aKoLqGq0VmuBjWBmgwOLFUZ
         I7sUcGedXXbsB+TT7nSsNyhcaTGOw55fWWHLLBezjkBlgYVu5KZcjp7rclEde2Y5YjMl
         U4QA==
X-Gm-Message-State: AHQUAuay6nL9T6rJD0+tBiHCyaCIehc1k9rhJAXtuQumvIW88vm54ljI
        TPS3vBgezifF+qaVydzeNisu81Z9Svy3880jmr8=
X-Google-Smtp-Source: AHgI3IZ6n4Ej8c8NH93SPAbL310kLXZazyx4PN9TRkOgAHRrXeeSm4Tri49K5BQEyW4W9xoQY3XWAglpLR7quIJ5LJQ=
X-Received: by 2002:a62:12d5:: with SMTP id 82mr18868528pfs.255.1551079577629;
 Sun, 24 Feb 2019 23:26:17 -0800 (PST)
MIME-Version: 1.0
References: <CAH2r5msoRSXFj=SM54Dg7A74yMj9X1XB=S8JY1zM=FgH13qzog@mail.gmail.com>
 <b3ffde7e-b8b1-b44c-a440-bcd2d1c9ca0b@samba.org>
In-Reply-To: <b3ffde7e-b8b1-b44c-a440-bcd2d1c9ca0b@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Mon, 25 Feb 2019 01:26:05 -0600
Message-ID: <CAH2r5muat94zgOLN6rqUF5pfFWfq=TN2FAJrEXLPtus9WCa78g@mail.gmail.com>
Subject: Re: Update POSIX negotiate context during negprot to include GUID
To:     Stefan Metzmacher <metze@samba.org>
Cc:     Jeremy Allison <jra@samba.org>, CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Feb 25, 2019 at 1:22 AM Stefan Metzmacher <metze@samba.org> wrote:
>
> Am 25.02.19 um 01:01 schrieb Steve French via samba-technical:
> > As requested - updated the POSIX negotiate context to include the GUID
> > of the only supported POSIX open/create context.
> >
> > Let me know if any objections..
>
> Don't you need to change POSIX_CTXT_DATA_LEN?

Isn't 16 bytes correct (at least one GUID - in this case matching the
POSIX open context GUID)?  The patch included this change:

-#define POSIX_CTXT_DATA_LEN    8
+#define POSIX_CTXT_DATA_LEN    16



-- 
Thanks,

Steve
