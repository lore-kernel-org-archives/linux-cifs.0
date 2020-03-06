Return-Path: <SRS0=AX+W=4X=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27932C10F00
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 17:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBE22206E2
	for <linux-cifs@archiver.kernel.org>; Fri,  6 Mar 2020 17:05:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="RWQb/G85"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726299AbgCFRFS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 6 Mar 2020 12:05:18 -0500
Received: from hr2.samba.org ([144.76.82.148]:14804 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbgCFRFR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 6 Mar 2020 12:05:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:Cc:To:From;
        bh=diYmcCVjElVDGG+xMnCmXVh8pr9Q0264ffZIM1s0EoQ=; b=RWQb/G857Pk27rMrgi912woVRf
        TCMV+tGFac3voVaOeWwPQ0+fklOLWpXjotRcMe9OjDR+lXrj21po6JtHyVSQI8/OMb0qyrTJ44p4i
        ydTAr1XOwuxVdQvCDNFzQc9qs2ksj1gNkL+W3veqtpTmhm5GPYZNn6lV6VQ/0PIT5+VlRMchjtQdR
        7QEar/E4d2cJkssdtM1ere5Ux5qZdqa4aytft4h2DE8a7gOsGxsBp8gApkBcZlinpUeAQoO71ES97
        WJ73ZWtROoBUp2E1zxJTO6TPlsbvCnZHAhIcEoGuHOvQvN9QW+GrO9KY9zEyDB39H/AtKedCpu8iB
        Zv3xY1aJ7I2sRAxqmK0WIH2NqU/lSnrmFeEGm0Yt2E4w2sh1x2+ZFTXN/K3Z609A/iNS6fQS9RfQG
        fD7qB0gVAfmzrQ12msOWLX2hk4CfDBg6i2xSrjGAbCeMvOb7b+Ccfukm8/tM1X5Viedyy1NZqrNVQ
        IKV2ge+mFCdnuRZqVpqxCHnh;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1jAGPT-0008G9-S0; Fri, 06 Mar 2020 17:05:15 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v1 04/13] cifs: split out a
 cifs_connect_session_locked() helper function
In-Reply-To: <20200224131510.20608-5-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
 <20200224131510.20608-5-metze@samba.org>
Date:   Fri, 06 Mar 2020 18:05:14 +0100
Message-ID: <875zfhe7n9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

This LGTM but I think we should really test it on the
buildbot. Especially DFS failover and multichannel.

Stefan Metzmacher <metze@samba.org> writes:
> +int
> +cifs_connect_session_locked(const unsigned int xid,
> +			    struct cifs_ses *ses,
> +			    struct nls_table *nls_info,
> +			    bool retry)
> +{
> +	int rc;
> +
> +	if (ses->server->tcpStatus =3D=3D CifsNeedReconnect) {
> +		return -EHOSTDOWN;
> +	}

This check is now done everytime. Probably it's correct, but worth
pointing out.

--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
