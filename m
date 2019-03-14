Return-Path: <SRS0=3edS=RR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E03BAC43381
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:40:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1872217F5
	for <linux-cifs@archiver.kernel.org>; Thu, 14 Mar 2019 07:40:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WeHZTp/v"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbfCNHkA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 14 Mar 2019 03:40:00 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:33631 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbfCNHkA (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 14 Mar 2019 03:40:00 -0400
Received: by mail-pf1-f194.google.com with SMTP id i19so3283768pfd.0;
        Thu, 14 Mar 2019 00:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rygP9PItvKmtF/0cF6oT0YH7PGrpypbEboRmiJeqVxw=;
        b=WeHZTp/vdtRoOge8LeI65rpDNCPCH2vx38xLNG+KrxDHznmUvJCDBDo1f+o1dXkmgx
         D7439UGz/r6XC7GFGXVJ/gcz+epduu7dpzxLG3RXFHqp2IvuVD0rkJPurXTSEDph+LPN
         3gHhQOufL0RwRUA0h31h+KE8v0fJU5IjAvMWBIwA54onKbBxu3Xoh/QJRfW55YdXAqTF
         KwlWBdPdslPRNjo0ORWN23WaLcaTTelxDm5PF8ZzSXv8hL+Wlr33uHGDu2DwgDsI84DS
         CcMjj2cjjRmjyXUsQyBRmG8pBCYTY4qWeSDcfvLL8QqsLT/js+1qbkWkYq5E2QnHUHa4
         TeWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rygP9PItvKmtF/0cF6oT0YH7PGrpypbEboRmiJeqVxw=;
        b=TkQzwpqpr78JPDmPGKpQAD5X/oDatgMBxrbsF/bAjvn+tSMK9IHBiFr9cd7OOa7R3d
         KnYUU2cZB/m9M4ZhOrkuhkjkL4Cz46OStxWd3OPtstnLMeTD0K1XO6+0eLRGgJ+ghQ0e
         E40Fqv5B/ZzsACPlWy0hN7X3wkoqHUbO//vb49165x185htHjbTGCPxiHioWiuikyjPl
         HlaScVrWG0zsnrgBeE/OGn0Z0W1x34bonvPQVfP2Fm02v56GjcLhid8lMdiNjNHsB8ut
         bcrnaPwyfpe/gaPCgTZalyuA4T9BCv39Lpvn9xKDl3idXIry88yFoZTtrE060IsRwU+l
         dA4w==
X-Gm-Message-State: APjAAAVIh5QeWb9pioLZQbMqA0eCglNScxXTa+gz4omjCSTJowxIOXAp
        GbIvB98nqw9pnpa7ZWS+HMk=
X-Google-Smtp-Source: APXvYqzzjRtztkmL7H6HcdkWiksT2eVOHpSKkMtbW55RJt1abDvHTvXfgSimSV0B46GVtEe/CkMKFQ==
X-Received: by 2002:a63:6fc4:: with SMTP id k187mr26742879pgc.312.1552549198983;
        Thu, 14 Mar 2019 00:39:58 -0700 (PDT)
Received: from localhost ([175.223.23.218])
        by smtp.gmail.com with ESMTPSA id h63sm46930690pfd.148.2019.03.14.00.39.57
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 14 Mar 2019 00:39:58 -0700 (PDT)
Date:   Thu, 14 Mar 2019 16:39:54 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steve French <smfrench@gmail.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        Steve French <sfrench@samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 1/2] cifs: remove unused status severity defines
Message-ID: <20190314073954.GA5272@jagdpanzerIV>
References: <20190314061716.19892-1-sergey.senozhatsky@gmail.com>
 <CAH2r5msYG4H19GK1Fmnqb1dNCcp2qahULc_t4v9qdJ=OOZmGXg@mail.gmail.com>
 <CAH2r5msCs5ks3FUi_GhV2REsUR8t2h1=ybgLS6FyBEyka7Qb9g@mail.gmail.com>
 <20190314071245.GA2001@jagdpanzerIV>
 <CAH2r5ms3sdFx864M4se0V1eCAj_x8_3xyyRxoxqS52_UQNNjaA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5ms3sdFx864M4se0V1eCAj_x8_3xyyRxoxqS52_UQNNjaA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On (03/14/19 02:19), Steve French wrote:
> All of those uses of __constant_cpu_to_le32 apparently (at least
> according to checkpatch) should be changed (someday) to cpu_to_le32
> but I didn't research why the change from __constant_cpu_to_le32
> --->   cpu_to_le32

Probably historic reasons.

Looking at linux 2.4.21

/*
 * Allow constant folding
 */
#if defined(__GNUC__) && (__GNUC__ >= 2) && defined(__OPTIMIZE__)
#  define __swahw32(x) \
(__builtin_constant_p((__u32)(x)) ? \
 ___swahw32((x)) : \
 __fswahw32((x)))


My assumption would be that __GNUC__ < 2 did no support
__builtin_constant_p?


> If it has benefit - and checkpatch is right (it warned about
> __constant_cpu_to_le32 being no longer preferred) ... perhaps would be
> worth a followup patch to clean the rest of them up?   If you have any
> context on why kernel code has moved away from using the older format
> of __constant_cpu_to_.... would be useful to know if any benefit to
> the change

Right, that's what I'm going to do - send out patches and update the rest
of __constant_cpu_to_XX users; so, eventually, __constant_cpu_to_XX
can be removed.

	-ss
