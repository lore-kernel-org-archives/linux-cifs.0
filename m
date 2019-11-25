Return-Path: <SRS0=nVbX=ZR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76AACC432C0
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 11:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5536E2068E
	for <linux-cifs@archiver.kernel.org>; Mon, 25 Nov 2019 11:41:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727232AbfKYLl4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 25 Nov 2019 06:41:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:33528 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727188AbfKYLl4 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 25 Nov 2019 06:41:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 237B5AB98;
        Mon, 25 Nov 2019 11:41:55 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>, smfrench@gmail.com
Cc:     linux-cifs@vger.kernel.org, "Paulo Alcantara \(SUSE\)" <pc@cjr.nz>
Subject: Re: [PATCH 3/7] cifs: Fix potential softlockups while refreshing
 DFS cache
In-Reply-To: <20191122153057.6608-4-pc@cjr.nz>
References: <20191122153057.6608-1-pc@cjr.nz> <20191122153057.6608-4-pc@cjr.nz>
Date:   Mon, 25 Nov 2019 12:41:54 +0100
Message-ID: <87fticw5bx.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Paulo Alcantara (SUSE)" <pc@cjr.nz> writes:
> We used to skip reconnects on all SMB2_IOCTL commands due to SMB3+
> FSCTL_VALIDATE_NEGOTIATE_INFO - which made sense since we're still
> establishing a SMB session.
>
> However, when refresh_cache_worker() calls smb2_get_dfs_refer() and
> we're under reconnect, SMB2_ioctl() will not be able to get a proper
> status error (e.g. -EHOSTDOWN in case we failed to reconnect) but an
> -EAGAIN from cifs_send_recv() thus looping forever in
> refresh_cache_worker().


I think we can add a Fixes tag:

Fixes: e99c63e4d86d ("SMB3: Fix deadlock in validate negotiate hits reconnect")

Otherwise looks good.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
