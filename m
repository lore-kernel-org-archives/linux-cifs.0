Return-Path: <SRS0=alM3=2Y=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2557EC2D0C2
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 20:15:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7A78222C4
	for <linux-cifs@archiver.kernel.org>; Fri,  3 Jan 2020 20:15:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="zK1KPVtt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbgACUPG (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 3 Jan 2020 15:15:06 -0500
Received: from mx.cjr.nz ([51.158.111.142]:26992 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726050AbgACUPG (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 3 Jan 2020 15:15:06 -0500
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 5B471808BF;
        Fri,  3 Jan 2020 20:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1578082502;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MTrmozS1XlNh03xz8nSVFM0VPXg4j9R25i/QkMW/Lvg=;
        b=zK1KPVtt015ck7RrOs02z6tFp2ZcZn1UqcN7oPWGxV1YSC2bA4s/DchhoZbCG0SPxDunsx
        k0dGiW+GCxi33jqRUDOgs3X0ucyvRKAvsSrJJw+1jrhJcoYzOo2LAWKk5vlxfjYQWqaxZ/
        HardvUK579Vbl/1vQl0exgvvR3BDMNFRtXCraF9i621R0TbpmzsW5J5jHry+suTbib4Itj
        HwrlSJWcoFCbOl/CApaCKbT6gddwxfDs2R/S/lWr+Pk/wBKoQSUOth6tMqkIdYW/hoTC9n
        bwK5noXM+ZMyWQ7h4fT2R0HD51uiZAJbXmGDtXP+QPxYxctzAXvCoC1k7ZywNQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
Subject: Re: cifs.upcall requests ticket for wrong host when using dfs
In-Reply-To: <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
References: <39643d7d-2abb-14d3-ced6-c394fab9a777@prodrive-technologies.com>
 <87png0boej.fsf@cjr.nz>
 <5260c45c-0a31-168d-f9db-83bb6bd4a2cf@prodrive-technologies.com>
Date:   Fri, 03 Jan 2020 17:14:48 -0300
Message-ID: <878smoqouf.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:

> I tried kernel 5.4.6, including this fix, but still no luck:
> [   25.825075] CIFS: Attempting to mount //domain.com/common
> [   27.127925] CIFS VFS:  BAD_NETWORK_NAME: \\domain.com\common
> [   31.406697] CIFS: Attempting to mount //DC01.domain.com/common/Pd_Std
> [   31.414527] srv rsp padded more than expected. Length 98 not 73 for cmd:1 mid:1
> [   31.414533] Status code returned 0xc000006d STATUS_LOGON_FAILURE
> [   31.414537] CIFS VFS: \\DC01.domain.com Send error in SessSetup = -13
> [   31.414544] CIFS VFS: cifs_mount failed w/return code = -13
> [   31.414590] CIFS: Attempting to mount //DC01.domain.com/common/Pd_Std
> [   31.422410] Status code returned 0xc000006d STATUS_LOGON_FAILURE
> [   31.422416] CIFS VFS: \\DC01.domain.com Send error in SessSetup = -13
> [   31.422423] CIFS VFS: cifs_mount failed w/return code = -13
>
> Where 4.19 prints:
> [  132.012498] CIFS: Attempting to mount //domain.com/common
> [  132.183038] CIFS VFS: error -2 on ioctl to get interface list
> [  132.344343] CIFS: Attempting to mount //nas01/common$/pd_std

Thanks for testing it.

Could you post dmesg output of both versions with debugging enabled as per
instructions in [1]?

Thanks,
Paulo

[1] https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting
