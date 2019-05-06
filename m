Return-Path: <SRS0=HMAP=TG=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9821C04A6B
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 19:03:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9451A20830
	for <linux-cifs@archiver.kernel.org>; Mon,  6 May 2019 19:03:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pLTdkPoK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfEFTD7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 May 2019 15:03:59 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33366 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfEFTD6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 6 May 2019 15:03:58 -0400
Received: by mail-lj1-f195.google.com with SMTP id f23so12083291ljc.0;
        Mon, 06 May 2019 12:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KEDXiJHWKjviYqvoTWdg/VpobGoPEHk3jlyAFxU4pGQ=;
        b=pLTdkPoKFEcO9WR2wUZw9/qM5VyxwTnkPmLQfy/kmsOtWZhFhZMuF5e3k1w29bKKbY
         myFxg7Rfa5KQFfeqDqjzNI6fKgteSNL6lyWmGEvdzrkcKGHxoH2gBD9wWqjP10a9A/oD
         Np+6/YXrpJwN4B9IT0lyF4cTxARTM6qsGHEb8UYtPwDMUbbqvxQML0Aeh4ANyYXD5cvL
         EcGO+Fy/sbFUfrDsuZVhKXoM5OEH4XLyERFNyc+YwSdbD3MNltAKT93Uys0WTgcczjzz
         m7FkQGDFmbxeWxv6eN+guqn/i4roWZ1zQXeF1rVa/FV0s9NzmYCdoGbvukJLVttEYYr5
         KRMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KEDXiJHWKjviYqvoTWdg/VpobGoPEHk3jlyAFxU4pGQ=;
        b=gj7xV6s8DzILDIVTFkv9y6usP6E4sQhPgdOUz8bEnMAb0du2ONpts/9fsrMRmYevEV
         WnnY/28dLT4UL5XM7OrC2YBRGLg98aT6IJ93eYAe8n02XbtSaehU46bNdprD7G0LuftN
         ETYbk7o4F1V6c/hGKbyjfGJzdwHc9BeioxY76imv7zQ7Ht5fPwGSHfLxerPucVUOa5cC
         cmDEUMoeS3THPjhPjoaJAfJmr+KveIu0LGF8AbaG7EnoM1CyYfDVmTsxYIZYlPzXBbLS
         dO+vlv2eFKIbzhuoHnCxM1qinBKrrh6KNCUlDxFQRLFQsh8x7rIvdr61ecFbagNUFMmi
         mH/A==
X-Gm-Message-State: APjAAAUc5yGE7u9czlTPjD7rdVkf8BGenqlpyGPVgXv9s9L90qatg3W5
        0ij7wl8WC9/j0TXMwc0qkDjO/TeuZ0aEP+B5Gg==
X-Google-Smtp-Source: APXvYqzs4JPs9r9knhDNfuaG7vck0LQKmuH914uaQI3NGuFSQ5jL3XF6xd3BYRmkoWPVj9EfDZiyZbSINn0G7YfIHQ4=
X-Received: by 2002:a2e:9196:: with SMTP id f22mr12526196ljg.82.1557169436484;
 Mon, 06 May 2019 12:03:56 -0700 (PDT)
MIME-Version: 1.0
References: <1557155792-2703-1-git-send-email-kernel@probst.it>
 <CAH2r5mtdpOvcE25P2UuNFpOwsNyFiBWRQELQFui+FJGVOOBV8w@mail.gmail.com>
 <20190506165658.GA168433@jra4> <CAH2r5msK6yNNm_QbdsFZuB5uS0iNRuqe8gSDKvVAiR0N6E3MWg@mail.gmail.com>
In-Reply-To: <CAH2r5msK6yNNm_QbdsFZuB5uS0iNRuqe8gSDKvVAiR0N6E3MWg@mail.gmail.com>
From:   Pavel Shilovsky <pavel.shilovsky@gmail.com>
Date:   Mon, 6 May 2019 12:03:45 -0700
Message-ID: <CAKywueR6DcfkzGcZUgydV4n6F4MKDEOvtCaM-gQSonX02tA9tg@mail.gmail.com>
Subject: Re: [PATCH] cifs: fix strcat buffer overflow in smb21_set_oplock_level()
To:     Steve French <smfrench@gmail.com>
Cc:     Jeremy Allison <jra@samba.org>, Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Probst <kernel@probst.it>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

The patch itself is fine but I think we have a bigger problem here:

3052 >-------cinode->oplock =3D 0;

here we reset oplock level of the inode, so forcing all the IO go to the se=
rver.

3053 >-------if (oplock & SMB2_LEASE_READ_CACHING_HE) {
3054 >------->-------cinode->oplock |=3D CIFS_CACHE_READ_FLG;
3055 >------->-------strcat(message, "R");
3056 >-------}
3057 >-------if (oplock & SMB2_LEASE_HANDLE_CACHING_HE) {
3058 >------->-------cinode->oplock |=3D CIFS_CACHE_HANDLE_FLG;
3059 >------->-------strcat(message, "H");
3060 >-------}
3061 >-------if (oplock & SMB2_LEASE_WRITE_CACHING_HE) {
3062 >------->-------cinode->oplock |=3D CIFS_CACHE_WRITE_FLG;

this and 3 above cases are all racy with other threads opening the
same file and the oplock break thread.

3063 >------->-------strcat(message, "W");
3064 >-------}
3065 >-------if (!cinode->oplock)
3066 >------->-------strcat(message, "None");
3067 >-------cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
3068 >------->------- &cinode->vfs_inode);

Besides the fix in the patch I would temporarily suggest to not touch
cinode->oplock more than once in this function - have a local variable
cifs_oplock which accumulates flags and set cinode->oplock at the very
end. It reduce raciness a little bit but this code requires much more
thinking about proper locking I guess.

Best regards,
Pavel Shilovskiy

=D0=BF=D0=BD, 6 =D0=BC=D0=B0=D1=8F 2019 =D0=B3. =D0=B2 10:02, Steve French =
via samba-technical
<samba-technical@lists.samba.org>:
>
> We could always switch it to strncpy :)
>
> In any case - he is correct, it is better than what was there because
> we should not strcat unless the array were locked across the whole
> function
>
> On Mon, May 6, 2019 at 11:57 AM Jeremy Allison <jra@samba.org> wrote:
> >
> > On Mon, May 06, 2019 at 11:53:44AM -0500, Steve French via samba-techni=
cal wrote:
> > > I think strcpy is clearer - but I don't think it can overflow since i=
f
> > > R, W or W were written to "message" then cinode->oplock would be
> > > non-zero so we would never strcap "None"
> >
> > Ahem. In Samba we have :
> >
> > lib/util/safe_string.h:#define strcpy(dest,src) __ERROR__XX__NEVER_USE_=
STRCPY___;
> >
> > Maybe you should do likewise :-).
> >
> > > On Mon, May 6, 2019 at 10:26 AM Christoph Probst <kernel@probst.it> w=
rote:
> > > >
> > > > Change strcat to strcpy in the "None" case as it is never valid to =
append
> > > > "None" to any other message. It may also overflow char message[5], =
in a
> > > > race condition on cinode if cinode->oplock is unset by another thre=
ad
> > > > after "RHW" or "RH" had been written to message.
> > > >
> > > > Signed-off-by: Christoph Probst <kernel@probst.it>
> > > > ---
> > > >  fs/cifs/smb2ops.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> > > > index c36ff0d..5fd5567 100644
> > > > --- a/fs/cifs/smb2ops.c
> > > > +++ b/fs/cifs/smb2ops.c
> > > > @@ -2936,7 +2936,7 @@ smb21_set_oplock_level(struct cifsInodeInfo *=
cinode, __u32 oplock,
> > > >                 strcat(message, "W");
> > > >         }
> > > >         if (!cinode->oplock)
> > > > -               strcat(message, "None");
> > > > +               strcpy(message, "None");
> > > >         cifs_dbg(FYI, "%s Lease granted on inode %p\n", message,
> > > >                  &cinode->vfs_inode);
> > > >  }
> > > > --
> > > > 2.1.4
> > > >
> > >
> > >
> > > --
> > > Thanks,
> > >
> > > Steve
> > >
>
>
>
> --
> Thanks,
>
> Steve
>
