Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F129C38BE2
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:38:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEC6520836
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:38:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="fJvv7NTu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727756AbgBXSiR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:38:17 -0500
Received: from hr2.samba.org ([144.76.82.148]:52068 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726652AbgBXSiR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 13:38:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:To:From:CC;
        bh=k1jCqlYSgoJ8Cs7clXV4vEV7ZmDGUpQ1M3R6Q4krXQ0=; b=fJvv7NTuIO6A9XPg36hyx5kt43
        yWDdlWhtSALzQSBgqoEGhwVVrwIAiJ72qc5B3g0wHxOnYaZZZ15WjpJJENxh1h+pMNiwiXRWWqMBB
        /rRWHjCJ9u2ll8lZbPsFQGTVIsV5yDIVktdLJ6wlzzkxxh5CdMYEsKZ/1kZuDq9r65sT5VjXfwMoB
        rrPBIxGt+rhb5ggEn+xAaYw0ExwZ2kkm4nJk9ly1PycSESaAaNlyuume8RMfziTeSiTjUKx/o1xI4
        d4VIV0VElYzyhgQ602AoilnBBMpe+AXzq76a/tICZlYHSRSoAKUPHyNStdLDoW7vsh7IC2Q9kNJ44
        NZQMjh929R5eonL4s3AjvFPBCvy+xQ5Q+D2tRsAJ3iIzFoSUUv6sXPLsCpkyTvTAvp8SV8TrN+F3P
        G0o4WgvN4+fyOH8aWZgjXoU9SpvK/z0qdIzlhpyrilZ03rsG1ChkK11LWw9WJpvToGWVZ6ygNZBcz
        lBwR8VloFq5EY1+K2GbS4XUp;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1j6IcR-0000kJ-2o; Mon, 24 Feb 2020 18:38:15 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Subject: Re: [PATCH v1 00/13] Avoid reconnects of failed session setups on
 soft mounts
In-Reply-To: <20200224131510.20608-1-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
Date:   Mon, 24 Feb 2020 19:38:14 +0100
Message-ID: <87mu974yqx.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:
> The first patches consolidate the retry/reconnect handling between SMB1
> and SMB2/3.

This code is very tricky, we had to tweak it multiple times to deal with
races, deadlocks and DFS (with DFS we have to failover to a different
server and have to update TCP_Server_Info fields) and we can't
test/repro those easily so we need to be very careful. I will start
looking but it will take some time. In any case amazing work in unifying
these things, reconnect code path is horribly complex.

Also, you should try to run checkpatch.pl (from the kernel repo) and
sparse (kernel static analysis). You need a recent version of sparse to
work on the kernel (get&build the git repo somewhere).
I like to use something this when working on a series:

 git rebase -x 'bash -c "./scripts/checkpatch.pl <(git format-patch -1 --st=
dout)" && touch fs/cifs/*.[ch] && make CHECK=3Dpath_to_your_sparse_bin C=3D=
1' HEAD~13

(on one line)

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
