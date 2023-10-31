Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66275C4332F
	for <linux-cifs@archiver.kernel.org>; Tue, 31 Oct 2023 11:47:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344065AbjJaLrf (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 31 Oct 2023 07:47:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344042AbjJaLre (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 31 Oct 2023 07:47:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8761291;
        Tue, 31 Oct 2023 04:47:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93E7C433C7;
        Tue, 31 Oct 2023 11:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1698752852;
        bh=ZC9JFWxpt5ZAIOvk/mS72CAu8BV1OkPjki6G3BcuMUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xKRCHNe0XOnVpv3KqVTkp+H61MuVzHYfL+QAZAZqTfBfqOFqeBzsdVMh57SioBJRl
         10MTudQ/NJFRAU5g2c6dlyh+Yh3hGaUuCYiBfGVmHauXE6IbxelgxZYIU2luuJisnD
         UDs1vc0UDWfga6WWzwy2E2IPpqzpyrh3za4H0Jkc=
Date:   Tue, 31 Oct 2023 12:47:29 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Anastasia Belova <abelova@astralinux.ru>
Cc:     stable@vger.kernel.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org,
        Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        Steve French <stfrench@microsoft.com>
Subject: Re: [PATCH 5.10 1/1] smbdirect: missing rc checks while waiting for
 rdma events
Message-ID: <2023103122-thinly-clubbed-f6f5@gregkh>
References: <20231024100226.25860-1-abelova@astralinux.ru>
 <20231024100226.25860-2-abelova@astralinux.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231024100226.25860-2-abelova@astralinux.ru>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Oct 24, 2023 at 01:02:26PM +0300, Anastasia Belova wrote:
> From: Steve French <stfrench@microsoft.com>
> 
> commit 0555b221528e9cb11f5766dcdee19c809187e42e upstream.
> 
> There were two places where we weren't checking for error
> (e.g. ERESTARTSYS) while waiting for rdma resolution.
> 
> Addresses-Coverity: 1462165 ("Unchecked return value")
> Reviewed-by: Tom Talpey <tom@talpey.com>
> Reviewed-by: Long Li <longli@microsoft.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>
> ---
>  fs/cifs/smbdirect.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)

Now queued up, thanks.

greg k-h
