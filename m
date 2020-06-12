Return-Path: <SRS0=RdgD=7Z=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1566C433DF
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 10:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8D682081A
	for <linux-cifs@archiver.kernel.org>; Fri, 12 Jun 2020 10:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbgFLK4o convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 12 Jun 2020 06:56:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:49944 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726314AbgFLK4n (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 12 Jun 2020 06:56:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4EAA1AC4E;
        Fri, 12 Jun 2020 10:56:46 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][SMB3] Add support for POSIX Extension info level on
 query info
In-Reply-To: <CAH2r5mvJ3U_-EegHZwSPiaW7b8yA_PLqJhAHPdVJZE=5R8y=Qg@mail.gmail.com>
References: <CAH2r5mvJ3U_-EegHZwSPiaW7b8yA_PLqJhAHPdVJZE=5R8y=Qg@mail.gmail.com>
Date:   Fri, 12 Jun 2020 12:56:41 +0200
Message-ID: <87imfwimc6.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


It looks good to me. Trying to unify all the query infos has proved to
be difficult with the different struct types, parameters and code being
done in each. So I guess having another func is ok.

We could have a func just doing a switch on all 3 funcs, as a first
follow up cleanup.

Some notes:
- Probably needs more thorough checks on buffer sizes
- UID-mapping is still TODO (also in my query dir code) and probably
  breaks with multi user mounts

Steve French <smfrench@gmail.com> writes:
> @@ -595,6 +596,62 @@ static int cifs_sfu_mode(struct cifs_fattr *fattr, const unsigned char *path,
>  #endif
>  }
>  
> +	/* The srv fs device id is overridden on network mount so setting rdev isn't needed here */
> +/*	fattr->cf_rdev = le32_to_cpu(info->DeviceId); */

Indentation.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
