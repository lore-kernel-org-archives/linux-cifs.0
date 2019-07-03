Return-Path: <SRS0=Wa1n=VA=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C474C0650E
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 20:17:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5DF7021850
	for <linux-cifs@archiver.kernel.org>; Wed,  3 Jul 2019 20:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oMP6yg7C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfGCURB (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 3 Jul 2019 16:17:01 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44114 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfGCURA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 3 Jul 2019 16:17:00 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so3796230ljc.11;
        Wed, 03 Jul 2019 13:16:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6gjTEURaI56DnWgxjUVHz+R8emA5V0RKIIK+KTO8T2A=;
        b=oMP6yg7CNAOFToPUIfpH+HChAeSfcf8UWM78eEjIqXhCaE0NSSJndklmjBf8C1do6N
         qssAZFk7YahYpQt9smVi4vZmRlHzY80DpPjWtEDaQt9Mctf5NSxzrz+lVJehsOI8bJNr
         nInQ97PqRSv7rWteUxtgyvtjJP2joGRrGXhJHzsbV4RRGyhuV60WafTiXn9KW1pTdbNh
         f8AWOzlkd4PGsXqrEdy2nDyA4HrjOZRyZRx8qoOf4OkZoFsj+EIMpe6k3h3u7CgkK6CX
         b3yaXQJV/lXLuQBI04iwVyHFaiz6lNTAp1qJOTjqZqwXOLnnYcTkv0AMuyrtxXHjhUb5
         ri9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6gjTEURaI56DnWgxjUVHz+R8emA5V0RKIIK+KTO8T2A=;
        b=AwNIga1yxhXFR5W5jR5OMAh0gmyNZzct44FbFHLwSBk/ITixIBdGbqIMIlcpFPNI/0
         qZf+5fGs+XxA0KhnOHNAwyJgi7Mm0RjR4e5xzzqgrLgHlexW8To6ZzOc03OpLhFZLP6K
         9GmIHexop7kx/VSPCaDBvv5J5vWsa6zhmiopGn9w74c7zzOhsA9foXtSSARY3zXiyNFS
         FY7scctzyRSxiCsaStwtiSkXQ+qyWVi+d3k75H31EmlpKgGlFerEALUtZV3MO0YmMWK4
         lH/ph6dxS99zLyfd/+lQyanXbsp6KFPNQ10yLR5CoAvma8+AXpmPfLw7gBJ7PBr4tgSx
         MdgQ==
X-Gm-Message-State: APjAAAW7ACWSKvhep5WmcGvT1SaLe1zPhbuRO0VrzSN/0W+sWaLRueLH
        H1z4BuKwb9tMIGarx1N6JD89NUsl8/mesW1l1eoriOSF2wM=
X-Google-Smtp-Source: APXvYqx8kL0PBOrg78gwrkY0ym1FFSDwe4mo0eFKm7Pj8XsmsdpOQrUgSN3rUl1fhnQnU3nEvTyNVTO2EyoDaohSsMY=
X-Received: by 2002:a2e:8396:: with SMTP id x22mr8686274ljg.135.1562185018170;
 Wed, 03 Jul 2019 13:16:58 -0700 (PDT)
MIME-Version: 1.0
References: <20190703131716.25689-1-huangfq.daxian@gmail.com>
In-Reply-To: <20190703131716.25689-1-huangfq.daxian@gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 3 Jul 2019 15:16:46 -0500
Message-ID: <CAH2r5muo1y5BPnpf6hNfaaSW8QCvNc=qtHHVbRF60fde_65F8Q@mail.gmail.com>
Subject: Re: [PATCH 22/30] cifs: Use kmemdup rather than duplicating its implementation
To:     Fuqian Huang <huangfq.daxian@gmail.com>
Cc:     Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Looks like this was already merged

commit c8fc464cbda384ba4ed48c1e744ca82cd69f1f93
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Sat Jun 1 03:31:10 2019 +0000

    cifs: Use kmemdup in SMB2_ioctl_init()

    Use kmemdup rather than duplicating its implementation

    This was reported by coccinelle.

    Signed-off-by: YueHaibing <yuehaibing@huawei.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 75311a8a68bf..ab8dc73d2282 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -2550,12 +2550,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct
smb_rqst *rqst,
                 * indatalen is usually small at a couple of bytes max, so
                 * just allocate through generic pool
                 */
-               in_data_buf = kmalloc(indatalen, GFP_NOFS);
+               in_data_buf = kmemdup(in_data, indatalen, GFP_NOFS);
                if (!in_data_buf) {
                        cifs_small_buf_release(req);
                        return -ENOMEM;
                }
-               memcpy(in_data_buf, in_data, indatalen);
        }

        req->CtlCode = cpu_to_le32(opcode);

On Wed, Jul 3, 2019 at 8:18 AM Fuqian Huang <huangfq.daxian@gmail.com> wrote:
>
> kmemdup is introduced to duplicate a region of memory in a neat way.
> Rather than kmalloc/kzalloc + memset, which the programmer needs to
> write the size twice (sometimes lead to mistakes), kmemdup improves
> readability, leads to smaller code and also reduce the chances of mistakes.
> Suggestion to use kmemdup rather than using kmalloc/kzalloc + memset.
>
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>
> ---
>  fs/cifs/smb2pdu.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 75311a8a68bf..ab8dc73d2282 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -2550,12 +2550,11 @@ SMB2_ioctl_init(struct cifs_tcon *tcon, struct smb_rqst *rqst,
>                  * indatalen is usually small at a couple of bytes max, so
>                  * just allocate through generic pool
>                  */
> -               in_data_buf = kmalloc(indatalen, GFP_NOFS);
> +               in_data_buf = kmemdup(in_data, indatalen, GFP_NOFS);
>                 if (!in_data_buf) {
>                         cifs_small_buf_release(req);
>                         return -ENOMEM;
>                 }
> -               memcpy(in_data_buf, in_data, indatalen);
>         }
>
>         req->CtlCode = cpu_to_le32(opcode);
> --
> 2.11.0
>


-- 
Thanks,

Steve
