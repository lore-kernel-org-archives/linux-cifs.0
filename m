Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C85C11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AC53B2084E
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="BC42UiW5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727636AbgBXSMN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:12:13 -0500
Received: from hr2.samba.org ([144.76.82.148]:43566 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBXSMN (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 13:12:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:Cc:To:From;
        bh=Njl9Ir2tJsob5fhhHjBRpAZ0DXGTL3hLfCWy0jGiDx4=; b=BC42UiW5b51LsSsXZE4CvTsNn+
        vCiz+pya4TKnBJK/xaTB2QFLACSXviZf7K+2iA2TH1GoLwQG+xN0CLSjGS8/EtXhJ9DxQKHReraew
        J6Z+4CHyY3aanvVVLzbkLXfxhpz+tP/rSzd0eYolPBmmRkdnWy+yW3gz85kxizp17+UP0vFG8zhv9
        ZiufDG1EKNj1FWKiQNmxFpd069MHTqaOZ9YT2JubLV/LqPRRHdHL2G9YsCEnKTdI78iX5mNfEtgyK
        yETfNuW3l4uawvnXjNY46cPX4vQ8wuFN65v7nK1RHN3KpPcos2W8wWKdQORL9FPaLFAiNH6bGr8C6
        MqogRW0c7Azn2tuwobLmrZA0h0rQXwUIGOSqE2xyKAn2lTf8CwTYLCxk3GHyecsAY8999Hq4GEfbF
        Q1akwj1JkAVF+d0RmotvagnMEdZ7tx0i++Kl9qfmfm05+OTWsOtYQKZO3VVcSkRfVFk2ANCCbxlIF
        9otlry2qgn0iB+QXA6anQNCW;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1j6IDC-0000Wu-W2; Mon, 24 Feb 2020 18:12:11 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v1 03/13] cifs: make use of cap_unix(ses) in
 cifs_reconnect_tcon()
In-Reply-To: <20200224131510.20608-4-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
 <20200224131510.20608-4-metze@samba.org>
Date:   Mon, 24 Feb 2020 19:12:09 +0100
Message-ID: <87pne34zye.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
