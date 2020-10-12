Return-Path: <SRS0=VSoq=DT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99616C433E7
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Oct 2020 09:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 277F92080D
	for <linux-cifs@archiver.kernel.org>; Mon, 12 Oct 2020 09:22:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="YWW6RZ0K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727227AbgJLJWI (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 12 Oct 2020 05:22:08 -0400
Received: from mx2.suse.de ([195.135.220.15]:53346 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726104AbgJLJWI (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 12 Oct 2020 05:22:08 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1602494527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=s2H+Qc4M82pSx4oND2UClXWAPfypgeKiFNwQqSJgH7I=;
        b=YWW6RZ0KcZX4IyKqOaLyCj8JbAqtFxE3WEFqYDp4ACJqIJ1BS55b2VBQyrwgkq2tmsoAiZ
        82CTTID3ZJ+/uJ0CeSmLlNTmsw6OpeLYupGfXwg3QFAihKek93ZbcTOOHjH8bjw55VsW3S
        Lnp/n+BJxNjt5/OCEx2W46l1xDZpGVI=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6C5FAB11D;
        Mon, 12 Oct 2020 09:22:07 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Vladimir Zapolskiy <vz@mleia.com>,
        Steve French <stfrench@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>, linux-cifs@vger.kernel.org,
        Vladimir Zapolskiy <vladimir@tuxera.com>
Subject: Re: [PATCH] cifs: Fix incomplete memory allocation on setxattr path
In-Reply-To: <20201010182554.337097-1-vz@mleia.com>
References: <20201010182554.337097-1-vz@mleia.com>
Date:   Mon, 12 Oct 2020 11:22:06 +0200
Message-ID: <87wnzvhk8x.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Thanks Vladimir

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
