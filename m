Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFFB5C4320A
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 11:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D6F486023E
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Aug 2021 11:48:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240398AbhHJLsi (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Aug 2021 07:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbhHJLsZ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 10 Aug 2021 07:48:25 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A491EC061799
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 04:48:03 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z11so29751279edb.11
        for <linux-cifs@vger.kernel.org>; Tue, 10 Aug 2021 04:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNxlzYY6Rvsl4R66x+M7R7HNz2uXThuZXHE6hKWxQoA=;
        b=btbVrIYLMBDf41DIpqU9MaKZYSUVpVNPsuyk2qtHsdYQ9pDCObLq7EyQvJjyBYuuS/
         PdbLV6eOLDWRRpuGWRW5ldtQsYD1qSS4he3OZ3vjoIpm2RK5VtYmNtdTZ3ojzGl2i/go
         PjugJQ10KNO0zqm/sb49gnF5jp3OVFs+dofxUPjtjEew0qbTVYPsFccog1YsEae0GlRM
         7VNVYGN2HSpAGp+XfuH5++ifGdbytz6G/Dyj7yLrhstX8i3n/iE+e96cEz5aDJG++c/E
         hkfKdQq2eyxqcgPwYl0prpvEaVwUgecrF1To+FnDoCAfzpPfY8EsakBnE9Fa5ds5hEhf
         dlEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNxlzYY6Rvsl4R66x+M7R7HNz2uXThuZXHE6hKWxQoA=;
        b=CvXy6GS+mzLYKxCxRWwKbTnfkVdxdU5IbBPnEW/74Ydzilm4g36EUzJrEM8LyInJBA
         cjqg9Mro1Mw26nC7WsAOwokIRGzTlxoKglREtFsmeMwKIBJCjso6Y2OY9Mw9fgSAi5Vk
         /MivzAuhS+m/kJP2YeTSuvnByYw0795BL60R47sE2kHDLvBt4EKATxrXc1o/H+4jB5zE
         Rb/0VV3Y/z+nE9WKrmWnhu6mu34G7VBk2W4SXi5ruRGO1K3h14O4Ar91ncIdqmB/uwPB
         hILNn6Ej8MXc2wxVnvcoQIv4+NJyM2ob/i2+h5CDvplNbXFKT7LdWdKxU+4PMtfxzYE9
         Irfg==
X-Gm-Message-State: AOAM531jBjcJRJgqqPS+y9xa233B7KkindedYAiSY7GDUBkiQBZb29s/
        7gKj42sahCk/ge1h+jgfScswf+8E2GnpKZ1/fdY=
X-Google-Smtp-Source: ABdhPJxibQqVI/jQ+F8bTEEN5JUqoz3KYLLfn09s2T3nzVhkLx0M0m7FhL9vVRf+fKMVnAv2XUbA/a4V9EzSuliC7+Y=
X-Received: by 2002:aa7:c246:: with SMTP id y6mr4288312edo.335.1628596082209;
 Tue, 10 Aug 2021 04:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <CACdtm0Z4rDEGsi02+0DJnw2EoTV2CSC-jDN-SyDhKz0WcGZoAQ@mail.gmail.com>
In-Reply-To: <CACdtm0Z4rDEGsi02+0DJnw2EoTV2CSC-jDN-SyDhKz0WcGZoAQ@mail.gmail.com>
From:   Shyam Prasad N <nspmangalore@gmail.com>
Date:   Tue, 10 Aug 2021 17:17:50 +0530
Message-ID: <CANT5p=rN_ogRccKmYpE+17qz=zRyUJChcKo5+cJiwDTFq_cBJw@mail.gmail.com>
Subject: Re: [PATCH][CIFS]Call close synchronously during unlink/rename/lease break.
To:     Rohith Surabattula <rohiths.msft@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        ronnie sahlberg <ronniesahlberg@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Already gave my review comments along with this one to the other email.

Reviewed-by: Shyam Prasad N <sprasad@microsoft.com>

On Mon, Aug 9, 2021 at 3:28 PM Rohith Surabattula
<rohiths.msft@gmail.com> wrote:
>
> Hi Steve/All,
>
> During unlink/rename/lease break, deferred work for close is
> scheduled immediately but in asynchronous manner which might
> lead to race with actual(unlink/rename) commands.
>
> This change will schedule close synchronously which will avoid
> the race conditions with other commands.
>
> Regards,
> Rohith



-- 
Regards,
Shyam
