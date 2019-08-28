Return-Path: <SRS0=V1Ry=WY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD02C3A5A1
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 22:18:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A78022DA7
	for <linux-cifs@archiver.kernel.org>; Wed, 28 Aug 2019 22:18:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YiozeJvQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbfH1WSF (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 28 Aug 2019 18:18:05 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33200 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726658AbfH1WSE (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 28 Aug 2019 18:18:04 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so2879547iog.0
        for <linux-cifs@vger.kernel.org>; Wed, 28 Aug 2019 15:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PEljpM8oxHU/fbmW9qLSfUELsyENzSjQ1JItqwaV9ME=;
        b=YiozeJvQmkICS6pYqpOBEpmRt/4gBU6O8zuXyw3bLUKcV7itStvmSn0u00WKbsp3ac
         Yz4W6bFVS79soFCoqSCJkPQGDcFzdmqXPOozznmDD0cbw4OYfx8VFjPpB8J3ygJKafES
         DqHjLonJQY1ZEVwUxTjMNpebqxhtjtv6fKLMrtiGZ/cNE+OsG+Exj8arJ2dVhVsWhKKd
         qnJhG+p5Ii6Xin24dLKQJyMcYp7gNPfai5wpDg+p59TvtqJ8C/1bpXWM0BCa0zJZkr7X
         W4lnda1GAC0VQhfJyLs7rTBSsTMnTTYIyXmBpJln+NiFM/TFRcjFpOdMoWv3SGNGrZbQ
         qO1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PEljpM8oxHU/fbmW9qLSfUELsyENzSjQ1JItqwaV9ME=;
        b=UTlvuRWB0toBUjtyc19Kcy8tzWHrZcvmfNbpdD1L+AaHYzJnNWvq3l/r3K09t0C9qO
         iG2RNIEyt8LRGo5LgciYWORpcT3wQQRjL3CgCTL4OB8K+6OvPeQFAisdSg+jfpKCNJSq
         Fwzorfj0+PnmGwwcKCloVcixTfeB3VID+E95mmXLZQFR32bg1YztmAWPBmpRxrG4sh3s
         Lg2ZL18253hFSkE+HGTOlXqY9yQd9itkxZlvnXKWrPJp1V+4Aoxk4qPQNcFgocJmr1XU
         +lXkoUJHNXiu0J5VDK6v0iFJj9pvHhQR+gcjshn6l3TiG9yT0GVbXxfOtPJ/7LWXqFS1
         RQsA==
X-Gm-Message-State: APjAAAUPkl/TgFYeN+vtEOq5ECv9PB+jWOjMBxbDoVLUutWja/B/m9+d
        1Ws/g+q92hKawAs4REaZ39QVZtui19/R/wNkRPI1QcR6JdI=
X-Google-Smtp-Source: APXvYqx0YL5vfdQZ6tlDOaa/DBKDpPVxQR7oAmeUlc/ceU0dm/jPkfQsOynM4THNH1b4f8ICnGbY96ANX0MI+9rHtJ4=
X-Received: by 2002:a6b:ea12:: with SMTP id m18mr7630502ioc.173.1567030683973;
 Wed, 28 Aug 2019 15:18:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAH2r5mu_koRUCV9snYu_A6at8r+kJ85DgFszG4=seEEn+qb0LQ@mail.gmail.com>
 <87k1axlhf8.fsf@suse.com> <CAN05THSPmp3GtZifXK-mLtVntgQR0uwaYY-c5LS9Dhf_P78grA@mail.gmail.com>
In-Reply-To: <CAN05THSPmp3GtZifXK-mLtVntgQR0uwaYY-c5LS9Dhf_P78grA@mail.gmail.com>
From:   Steve French <smfrench@gmail.com>
Date:   Wed, 28 Aug 2019 17:17:53 -0500
Message-ID: <CAH2r5mveQH4=r40=Xo3qsKWfaxsiwK_7duwK42XpccxTnHFe3w@mail.gmail.com>
Subject: Re: [RFC][SMB3][PATCH] Allow share to be mounted with "cache=ro" if
 immutable share
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Since there isn't really a share flag which says "this share is
writable" (the access mask returned in tcon is only for that user -
not for any user), we could do the reverse ie forbid it if the server
forbids it, but otherwise just warn on it:

See e.g. SMB2_SHAREFLAG_NO_CACHING Offline caching MUST NOT occur.

On Wed, Aug 28, 2019 at 5:27 AM ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
>
> On Wed, Aug 28, 2019 at 8:21 PM Aur=C3=A9lien Aptel <aaptel@suse.com> wro=
te:
> >
> > "Steve French" <smfrench@gmail.com> writes:
> > > Increases performance a lot in cases where we know that the share is
> > > not changing
> >
> > This is just adding the parsing of the option but it sounds like a good=
 idea.
>
> You also have the magic happening in:
> -#define CIFS_CACHE_READ(cinode) (cinode->oplock & CIFS_CACHE_READ_FLG)
> +#define CIFS_CACHE_READ(cinode) ((cinode->oplock &
> CIFS_CACHE_READ_FLG) ||
> (CIFS_SB(cinode->vfs_inode.i_sb)->mnt_cifs_flags &
> CIFS_MOUNT_RO_CACHE))
>
> which makes things work. Still I would want this to be driven by
> whether the server returns "this share is WRITEABLE or  not" flag
> instead of a mount option.
> A mount option only invites people to "I use this because it makes
> thing faster"  then "why do my files look corrupted sometimes" ?
>
> >
> > > +#define CIFS_MOUNT_RO_CACHE  0x20000000  /* assumes share will not c=
hange */
> >
> > This flag probably needs to be added to CIFS_MOUNT_MASK: if one cifs sb
> > is using that flag, it should only be reused for new mounts that also
> > require that flag.
> >
> > Cheers,
> >
> > --
> > Aur=C3=A9lien Aptel / SUSE Labs Samba Team
> > GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
> > SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnber=
g, DE
> > GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=
=C3=BCnchen)



--=20
Thanks,

Steve
