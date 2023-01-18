Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8471EC32793
	for <linux-cifs@archiver.kernel.org>; Wed, 18 Jan 2023 22:07:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229492AbjARWHt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:07:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjARWHt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 18 Jan 2023 17:07:49 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A996630A7
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:07:47 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id o7so199184ljj.8
        for <linux-cifs@vger.kernel.org>; Wed, 18 Jan 2023 14:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YcfWH0Gf0JYsGdi1h9B5VB8NYTAhEUgcm1LGo3mlF80=;
        b=dPzQ2eRfcOccDyrTWEfWwbJR9rd/hCG5lBNlgaPUOEBUP3xSEMY9DdaibvQG7fux+0
         rm5SYgo92MhGGrCAYxRBsVd3xL8cjf1eOYIrpXnR+AOTmOa0uw75BC6dZK+FObp2ssxx
         1K7hPKa9FFvs4UL1daIbhSu/XfyRd+BBKJ6BAaRzu/LJoaqAyKun8MaSEtY0HAgcoSw9
         Z6PsDB2KGcLGp4z4/kEPK5gdN0vqC3dO3BxZ+HRBmM19yL9FmHni5fGlz3Wh8G1/sT8q
         qfO5w+75IyTHrAXFhr89/PBtIkCTyG5go6HqYxiWhrOQTqFUbiduqpsY3sxMa9z362vZ
         7Phw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YcfWH0Gf0JYsGdi1h9B5VB8NYTAhEUgcm1LGo3mlF80=;
        b=oK0YtZylznO61BSfM000wmr7Fns9FmVgIa6XvDn5b1QzjtCKHPYshskOsnRdRnhC3z
         7skOSXL2A6Rp7hercXK+WSetPiqFtjT57mW+ktx7qNpr/e1C+ZZm7eqlEGGpx98ukEf1
         7IQHsKcEJpkaCtCrCUd+M6jHoHMLdFAmGJokZ0NrZBrwMNXSOeymKNmduwc1um3W4gKY
         oQS+WjT5ATHXIn1ikon5mwk5+QMPbsy0ePvx2JezgGDkpKNiaw31PfWbvzY0mrdOQbL2
         Kv0NaDvN5e7zAXzcPb6v/AcGOz3jOytBHCKM+hBbe2+0pD59JGumtlZM/KnWxMUAflIp
         O9cw==
X-Gm-Message-State: AFqh2kpfiT74GlDe3GyrO9qQ6d15HAHiYkLBiUKMAkQe9Xe6G6HMLxIh
        eMNOUeaOtW8W93OpFTBhusB7pHgx3r/vtVbmk1vf+WFg
X-Google-Smtp-Source: AMrXdXsz8+P7fPGDh1G9OHMSAVpe746popYk7EWRS0q989TECXsIFEeBZ0rDOiUBJQTW6qhb4fsI8mp7iIEp0svk8Rg=
X-Received: by 2002:a2e:7812:0:b0:28b:a916:b55e with SMTP id
 t18-20020a2e7812000000b0028ba916b55emr275821ljc.411.1674079665730; Wed, 18
 Jan 2023 14:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20230118170657.17585-1-ematsumiya@suse.de> <871qnrvc7z.fsf@cjr.nz>
In-Reply-To: <871qnrvc7z.fsf@cjr.nz>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 18 Jan 2023 16:07:34 -0600
Message-ID: <CAH2r5muxweTSeBdGjcG1W_WjuM7fdd4JpqPCB7AqVXjn8QyhBw@mail.gmail.com>
Subject: Re: [PATCH] cifs: do not include page data when checking signature
To:     Paulo Alcantara <pc@cjr.nz>
Cc:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

I wasn't able to reproduce this with generic/465 - at least not
running to current Samba.  Any thoughts on how to reproduce the
original problem?

On Wed, Jan 18, 2023 at 2:07 PM Paulo Alcantara <pc@cjr.nz> wrote:
>
> Enzo Matsumiya <ematsumiya@suse.de> writes:
>
> > On async reads, page data is allocated before sending.  When the
> > response is received but it has no data to fill (e.g.
> > STATUS_END_OF_FILE), __calc_signature() will still include the pages in
> > its computation, leading to an invalid signature check.
> >
> > This patch fixes this by not setting the async read smb_rqst page data
> > (zeroed by default) if its got_bytes is 0.
> >
> > This can be reproduced/verified with xfstests generic/465.
> >
> > Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> > ---
> >  fs/cifs/smb2pdu.c | 15 +++++++++------
> >  1 file changed, 9 insertions(+), 6 deletions(-)
>
> Reviewed-by: Paulo Alcantara (SUSE) <pc@cjr.nz>



-- 
Thanks,

Steve
