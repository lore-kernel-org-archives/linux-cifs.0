Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF93FA3740
	for <linux-cifs@archiver.kernel.org>; Mon, 31 Oct 2022 10:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbiJaK42 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 31 Oct 2022 06:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbiJaK41 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 31 Oct 2022 06:56:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3CFE40
        for <linux-cifs@vger.kernel.org>; Mon, 31 Oct 2022 03:56:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AA9E61123
        for <linux-cifs@vger.kernel.org>; Mon, 31 Oct 2022 10:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEBCC433D6;
        Mon, 31 Oct 2022 10:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667213785;
        bh=/ZZi7UVHyUir9VTh0zRwbCWPED+ifN6jX6kC/XpXN2s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CQnxOJBzXcLjgXSAOn2CMjXV7q/hBWvuJZDQAmHXQx3NG/RRQkjDV/MWBug7TGa5h
         KCxUDUHvOgldatLoBn/DPR+TPcfwKU/82mcaVEsfC1zGGF3QA9B4hHCgkhX2hqO5Xm
         h6FZCXANamZZaRkLX9c1c4rw5mfwCniGkAwVIGci6TXvHxdj6G5YhT2GOzcN5V0EUU
         RnKtVQITnPbR4xr1cbpuuluupUGYREPELYSJD0C4SAJxXVlAgNAHmxA/YAi+LCPq1d
         yGka3e4pIkfdEHAlU40GAa1wRAUjPehx/S271gtwK+n9Jk+tHPuBakn09SNEvzCE+u
         KfQtLWOIAWXdQ==
Date:   Mon, 31 Oct 2022 11:56:21 +0100
From:   Christian Brauner <brauner@kernel.org>
To:     Steve French <smfrench@gmail.com>
Cc:     CIFS <linux-cifs@vger.kernel.org>
Subject: Re: vfstest idmapped mounts
Message-ID: <20221031105621.57wzltgcmnqcpaco@wittgenstein>
References: <CAH2r5mteAkioMJWfQG9MpZym9-Co1uAetebe91ENnJ3ryKO69A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAH2r5mteAkioMJWfQG9MpZym9-Co1uAetebe91ENnJ3ryKO69A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 21, 2022 at 09:49:48PM -0500, Steve French wrote:
> I noticed test generic/645 is skipped on cifs.ko due to
>         "src/vfs/vfstest --idmapped-mounts-supported ..."
> returning an error for
>          generic/645
> casuing
>          [not run] vfstest not support by cifs
> 
> Any ideas on what it takes for a filesystem to support idmapped mounts
> (in this case cifs.ko)?

There shouldn't be much magic to it and I plan to implement support for
a networking filesystem in the not too distant future. Before that
happens though I want to do some vfs conversions to improve security
even more.

Basically all that is needed is that all inode operations that require
knowledge about __local__ ownership wrt to {g,u}ids take the mount's
idmapping into account. So in the worst case we might need to extend
some additional inode operations to pass down the mount's idmapping. The
rest is then filesystems specific work. As I said, I try to convert a
networking filesystems next year. It will be too short to do it by the
end of this year.

Christian
