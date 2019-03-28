Return-Path: <SRS0=iY7O=R7=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D0B9C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 16:02:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CBF420823
	for <linux-cifs@archiver.kernel.org>; Thu, 28 Mar 2019 16:02:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbfC1QC2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 Mar 2019 12:02:28 -0400
Received: from mx2.suse.de ([195.135.220.15]:44308 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726150AbfC1QC1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 Mar 2019 12:02:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 82779B9B3;
        Thu, 28 Mar 2019 16:02:24 +0000 (UTC)
Date:   Thu, 28 Mar 2019 17:02:19 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Pavel Shilovsky <piastryyy@gmail.com>
Subject: Re: [PATCH][smbinfo cifsutils]
Message-ID: <20190328170219.29c72cbf@echidna.suse.de>
In-Reply-To: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
References: <CAH2r5mvQ+KmoBgoxT51SRMpCXZ4OFwg+B1x_SD3DFkcrUcdZQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Thu, 28 Mar 2019 05:05:35 -0500, Steve French wrote:

> +	/* Now that we know the size, query the list from the server */
> +
> +	/* Make sure the buf size is big enough even to handle unexpected server behavior */
> +	buf = malloc(snap_inf.snapshot_array_size + 300);

The buffer length calculations seem pretty arbitrary here, wouldn't it
make sense to use something like the following (with a maximum limit)?
sizeof(struct smb_snapshot_array) +
	(snap_inf.number_of_snapshots * GMT_TOKEN_LEN)

Cheers, David
