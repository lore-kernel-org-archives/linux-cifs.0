Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BBC3C4332F
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Nov 2022 19:59:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiKST7v (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Nov 2022 14:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232895AbiKST7v (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sat, 19 Nov 2022 14:59:51 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637521836E;
        Sat, 19 Nov 2022 11:59:49 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id s8so13325740lfc.8;
        Sat, 19 Nov 2022 11:59:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FwUOG5FZhO4dhjRA45yKkVi3IF2EbFqShN5s+O9Kd5s=;
        b=kTWTIjYrz6ZFGwCgHRFnWSySppLVS9chsJ6CUdWyF1JGlGUfpN1sSCM4oCE3wyIAk+
         xZgJ5ulAnN0jJ6CifLlbcCvc+ekdarqot/KOWwUN269rjvcnCMzh3uC5F0RqZkbauMfL
         lwYYmuE+DQND/FQLHz984/KOAIYZbRNl6/SEiZ/qAnwIvZU/5FWXzmCblm3Sfm1LkZet
         1OmrPexF1kbNHhyzQx8w4V5sQw3UmkfssoA0B+5mof7/Sc+RHhTDhqGSzuixqI1aVwbB
         Zo63Bz/v0vxgIQbinHB11eF2u6CuY08Aby/QjeFjUTYXq6lAEKt+63uTz+sNUqFgSM7J
         683Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FwUOG5FZhO4dhjRA45yKkVi3IF2EbFqShN5s+O9Kd5s=;
        b=Bx7Jy9rL8Lkxjv6fGGkVkzUjzKHOdzYsh7rReNlyQEYcANaUokera6QUj0p7Ie2f+i
         Rv+aj2OG/XqqKu6aRdf/iatJKhuAGzAI3mHGh7kyVZi8vE8sSVN8wLHEMDmi4GIhJIFq
         wOqEv2w6y617O30nRA2ZkK3NUspb4EKVVRPzH8kQIjWEOqw8JLf3xmh2nCAZgQNwfgwv
         en6cmAH0mdcLUymIaIGuA0UEqf1plGNHcO1t7X2sUMYv+Zb+JpbQ/+gdNeWGRA5jh72M
         2jrUx6wg7JfA2FEmqlnsn3O30B5dvKnfkIp8bYXgp9K1/vHpNoUk6Zd4/jZuXY6hZ6q8
         LXnw==
X-Gm-Message-State: ANoB5pk1dhl+CoFffpQNe/tchTx+eYD5mC6syC9piFGFXUy7qM4ZYEp/
        ug5fKtF77EyCN3yYGSwdxi6YVszLIDwlT0OqVQk=
X-Google-Smtp-Source: AA0mqf5d63RKrc4xvjMlt8kezPSfqPjOQZJjZruRI5krdmqgLc/0DQc66EaG3xIQ68ZyLoDI66yUP6Dd1X9mEXA6kjI=
X-Received: by 2002:a05:6512:3b8b:b0:4b0:54a9:38a3 with SMTP id
 g11-20020a0565123b8b00b004b054a938a3mr800423lfv.20.1668887987474; Sat, 19 Nov
 2022 11:59:47 -0800 (PST)
MIME-Version: 1.0
References: <Y3dw8KLm7MDgACCY@kili> <87edu0jp3r.fsf@cjr.nz>
In-Reply-To: <87edu0jp3r.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Sat, 19 Nov 2022 13:59:35 -0600
Message-ID: <CAH2r5mtHsg0tO1NB38xSUwK7_9ak5izaBMhwuasfHXo_Wx_ZFw@mail.gmail.com>
Subject: Re: [PATCH] cifs: Use after free in debug code
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Dan Carpenter <error27@gmail.com>,
        Steve French <sfrench@samba.org>, linux-cifs@vger.kernel.org,
        Shyam Prasad N <sprasad@microsoft.com>,
        samba-technical@lists.samba.org, kernel-janitors@vger.kernel.org,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Tom Talpey <tom@talpey.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Nov 18, 2022 at 8:48 AM Paulo Alcantara via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> Dan Carpenter <error27@gmail.com> writes:
>
> > This debug code dereferences "old_iface" after it was already freed by
> > the call to release_iface().  Re-order the debugging to avoid this
> > issue.
> >
> > Fixes: b54034a73baf ("cifs: during reconnect, update interface if necessary")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  fs/cifs/sess.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>
>


-- 
Thanks,

Steve
