Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416B5C433DB
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:22:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 111A961A1A
	for <linux-cifs@archiver.kernel.org>; Thu, 25 Mar 2021 15:22:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbhCYPVs (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 25 Mar 2021 11:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbhCYPV2 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 25 Mar 2021 11:21:28 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433CAC06174A;
        Thu, 25 Mar 2021 08:21:28 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id w37so3041191lfu.13;
        Thu, 25 Mar 2021 08:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DWdXrxswFdWMzj92Kr/qs8gPd/Sy1C2PZmeLqGsaT0g=;
        b=JD88zvybm4xyFniHi1xZGqHj46f2jKSKyv3nO53GvqYvOJhjmA2Lj9kAXYVrbN2Pv/
         n8IB5e9GtuizoQu3vYcWhMfdlZ2ssXfi4NbO4/ERozh8EJIsRMq7L0TMDs0URckQAsNZ
         5+zZxvVSMMMn8JXoc3r6a32aIxQt23zlelsqJh3dD9caCez3mdeMAxirZYZ7E3IfWlC1
         KUZHhvCrRvlSaqp65U5N+IdXIsP0NdShEwX2ek6t0d7I/PgBhvl6ei989QxI5YfQTG74
         JaA/QrKYvfdX4ipXKDcLa+6FBqhUrilien0HIOOk6JaHBy8zfq887j100E/f2VFFLoMQ
         zDxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DWdXrxswFdWMzj92Kr/qs8gPd/Sy1C2PZmeLqGsaT0g=;
        b=O1r1LkH/7ehA3rIhoT1pzKYy7uHmA/2Kn0KdmZIqVElPcWb5Jtac8EXPAZBP9g+0yA
         9RTcP1vLOGcANNAtztb1GMOokd/XG2SIgkXUK1KVntip1FuOEORAbA6UA5V3EIuv4N3b
         K6RJeE7fRHiQzKZTYnRMIZ/N4V7ccERS9ntva5lD+vXbadeEZQJOd51oZ331ijRrMYuX
         mAGn4pTFKQg8xnv7sik3tetcny8vcI2VqlEq+2B/TYZxC+mCryoM9XHK31ah+Cx7K02+
         wAqUw5cNvf14D+8/Gujl44PhCzYZcaVLjLqRBkMZbtifhQU9I9rMTnyCnOlkDWDLyYVr
         qsZQ==
X-Gm-Message-State: AOAM533iwKzwLysT3NgmMkJQUx/1AaZnJDJPuz89qMTLwM01dRYaKqkE
        GNFRzwEC6dfQFTFFmNzT+WrBCeQjdgJLvF5Qr/w=
X-Google-Smtp-Source: ABdhPJz8Jk01Oa9yQeykNwQUixDOSgogUkQOfoY+YTQEVaXTvbSeJRS3xejE5ZUVCAaKKtMrNQGRfvZWiMi1Ru5d3z0=
X-Received: by 2002:a19:8c0a:: with SMTP id o10mr5538032lfd.175.1616685686587;
 Thu, 25 Mar 2021 08:21:26 -0700 (PDT)
MIME-Version: 1.0
References: <20210319135711.11802-1-vincent.whitchurch@axis.com> <4ebdf34a-bd01-68ad-6d27-b1c02d21aebe@talpey.com>
In-Reply-To: <4ebdf34a-bd01-68ad-6d27-b1c02d21aebe@talpey.com>
From:   Steve French <smfrench@gmail.com>
Date:   Thu, 25 Mar 2021 10:21:15 -0500
Message-ID: <CAH2r5msWO8s9zfYOAnRhMj0uP+_phZu8=M3SKQYYi=j-KT5dxA@mail.gmail.com>
Subject: Re: [PATCH v3] cifs: Silently ignore unknown oplock break handle
To:     Tom Talpey <tom@talpey.com>
Cc:     Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>, kernel <kernel@axis.com>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

merged into cifs-2.6.git for-next

On Fri, Mar 19, 2021 at 9:06 AM Tom Talpey via samba-technical
<samba-technical@lists.samba.org> wrote:
>
> LGTM feel free to add
>
> Reviewed-By: Tom Talpey <tom@talpey.com>
>
> On 3/19/2021 9:57 AM, Vincent Whitchurch wrote:
> > Make SMB2 not print out an error when an oplock break is received for an
> > unknown handle, similar to SMB1.  The debug message which is printed for
> > these unknown handles may also be misleading, so fix that too.
> >
> > The SMB2 lease break path is not affected by this patch.
> >
> > Without this, a program which writes to a file from one thread, and
> > opens, reads, and writes the same file from another thread triggers the
> > below errors several times a minute when run against a Samba server
> > configured with "smb2 leases = no".
> >
> >   CIFS: VFS: \\192.168.0.1 No task to wake, unknown frame received! NumMids 2
> >   00000000: 424d53fe 00000040 00000000 00000012  .SMB@...........
> >   00000010: 00000001 00000000 ffffffff ffffffff  ................
> >   00000020: 00000000 00000000 00000000 00000000  ................
> >   00000030: 00000000 00000000 00000000 00000000  ................
> >
> > Signed-off-by: Vincent Whitchurch <vincent.whitchurch@axis.com>
> > ---
> >
> > Notes:
> >      v3:
> >      - Change debug print to Tom Talpey's suggestion
> >
> >      v2:
> >      - Drop change to lease break
> >      - Rewrite commit message
> >
> >   fs/cifs/smb2misc.c | 4 ++--
> >   1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/cifs/smb2misc.c b/fs/cifs/smb2misc.c
> > index 60d4bd1eae2b..76cd05b8d53b 100644
> > --- a/fs/cifs/smb2misc.c
> > +++ b/fs/cifs/smb2misc.c
> > @@ -754,8 +754,8 @@ smb2_is_valid_oplock_break(char *buffer, struct TCP_Server_Info *server)
> >               }
> >       }
> >       spin_unlock(&cifs_tcp_ses_lock);
> > -     cifs_dbg(FYI, "Can not process oplock break for non-existent connection\n");
> > -     return false;
> > +     cifs_dbg(FYI, "No file id matched, oplock break ignored\n");
> > +     return true;
> >   }
> >
> >   void
> >
>


-- 
Thanks,

Steve
