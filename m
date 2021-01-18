Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9110EC433E0
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Jan 2021 02:09:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DF12224DF
	for <linux-cifs@archiver.kernel.org>; Mon, 18 Jan 2021 02:09:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbhARCJP (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 17 Jan 2021 21:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730458AbhARCJO (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 17 Jan 2021 21:09:14 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1933C061573;
        Sun, 17 Jan 2021 18:08:33 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id v24so15169617lfr.7;
        Sun, 17 Jan 2021 18:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UCNr++Ssi+GCJXfceKYWtjuCgckAsDZ7Hj+PCOxiPFI=;
        b=Wk1tFUMhMF6+naycYPO5gIKoQs44ym7L+cXKP2iv6fsgQkelky9y5Y9OVGM1P4yfTl
         /RoxHrZ/ZrPlYJ3wP+lUMsmPfwbDCLvoeS26f0b+6SAdG2TwIkmWho2Zb/PwAWx5jY9S
         0oOFpc05VzN4dyPOFoyBZDZVXfCgUok/9CqiOfZdWwIjrYFyVlhtwk+J30tzVrUxND32
         rfnZ0DX1GVMyi5fnD/ePq+8Njwh68TqQKt1YmwTF5D2ra4kyhR8vwlZKDQX4Ou4s2HtR
         bNgl1gDjrcgsSh4DG1BY7r6/4jlUmCi3lbROe8f3U77auAMgRLLXzjsvG1zPxVyLxSYh
         RhGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UCNr++Ssi+GCJXfceKYWtjuCgckAsDZ7Hj+PCOxiPFI=;
        b=S/bPIt9L0a/EDC8TI0Bi553ZQpV8hzWEL1/6qVMWprg5nZnZbKcpUh9dqfk1tbktlT
         WyUDjsWShPSA0mDIAp+6O9kRRBD2+ccbkxYlvG4Rqkk2zW32fX9BN97R+0Zsj4wX8h2P
         Y9enxKL/Qq8KVIYDn1kGkD6vRrlccorLvU7ARWWa5K7KKDnvtNn9oIneMJlmFf8+5KCU
         uw5JTGtcGoLbMnWHcQb2D6bVyfBm5BGWxGumSV9ZKjeLRXI/1GY9UDOF6NrYk6p/qAJK
         sJ0qxW46XcoOnzAp44QmTGxoLvN52WZK2oYS1pgfpHC1X/sQN7eExxBIsS1/PfWoj7Sy
         gJcQ==
X-Gm-Message-State: AOAM532YWJ8VjYo1IW2MuoTJGAXBhVZ0E5MMnn3TN6IBtE5HOiJlmoAx
        TequX/meZOFZaZYtsdPdjO9qVKRSHvLcTyU9YgZAiDAVBiY=
X-Google-Smtp-Source: ABdhPJy1F7PzMeYmUBqKJFwc+OMyBL9Qjt2TMLg2k5TKElN6wCIQIQXXiSfFrAe/V1nyxKQqvyrpCeqNeJ3jhJIIhmE=
X-Received: by 2002:ac2:5689:: with SMTP id 9mr10870086lfr.175.1610935712208;
 Sun, 17 Jan 2021 18:08:32 -0800 (PST)
MIME-Version: 1.0
References: <1610615171-68296-1-git-send-email-abaci-bugfix@linux.alibaba.com>
 <87czy7lvjy.fsf@suse.com> <CAH2r5mvjDAgB6-kE=AOAwrETVk+R79z6Gd8gMnOTWqG-6Mnybw@mail.gmail.com>
 <20210118000152.GH3579531@ZenIV.linux.org.uk>
In-Reply-To: <20210118000152.GH3579531@ZenIV.linux.org.uk>
From:   Steve French <smfrench@gmail.com>
Date:   Sun, 17 Jan 2021 20:08:21 -0600
Message-ID: <CAH2r5mtaf6Kmg2RAxawsV9o=VHyu9hosqa4fZw5QDHLH-tacfg@mail.gmail.com>
Subject: Re: [PATCH] fs/cifs: Replace one-element array with flexible-array member.
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>,
        Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sun, Jan 17, 2021 at 6:02 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Sun, Jan 17, 2021 at 03:58:23PM -0600, Steve French wrote:
> > Jiapeng,
> > Aurelien is correct, you should respin this patch and correct for
> > where it breaks the sizeof calculation.  For example your change:
> >
> > struct smb2_lock_rsp {
> > @@ -1434,7 +1434,7 @@ struct smb2_query_directory_req {
> >         __le16 FileNameOffset;
> >         __le16 FileNameLength;
> >         __le32 OutputBufferLength;
> > -       __u8   Buffer[1];
> > +       __u8   Buffer[];
> >  } __packed;
> >
> > would have the side effect of making the file name off by one:
> >
> > smb2pdu.c-4654- req->FileNameOffset =
> > smb2pdu.c:4655:         cpu_to_le16(sizeof(struct
> > smb2_query_directory_req) - 1);
>
> FWIW, that sizeof() - 1 should've been offsetof()...

agreed

-- 
Thanks,

Steve
