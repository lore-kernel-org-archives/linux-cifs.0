Return-Path: <SRS0=VVBU=AR=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67DA3C433DF
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 396FE20720
	for <linux-cifs@archiver.kernel.org>; Mon,  6 Jul 2020 15:47:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cjr.nz header.i=@cjr.nz header.b="wj0b+Fty"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729358AbgGFPr0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 6 Jul 2020 11:47:26 -0400
Received: from mx.cjr.nz ([51.158.111.142]:56386 "EHLO mx.cjr.nz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729321AbgGFPrZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 6 Jul 2020 11:47:25 -0400
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id 277687FD17;
        Mon,  6 Jul 2020 15:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1594050443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kSaELfUN28R66jvF6kpukxmXJcF3D9yHLaIJ/5OQa4k=;
        b=wj0b+FtyKLcBanvSEmPOi5BMAaclhv5LG+OYpfebf4s/Y/9V5bqLmeuFx6fSnK5U1S0hla
        gi6Vnx7BY3lEPNBTfBYDNGI64xn/SM10JsbJVinbPeVSMi3tpVvRVlxO4+DctSd9Eae2J3
        lD/ruasvBit1Tu4T5kEUVuyTOt2AlKC0lj9E6by2d8HuKIBLi/ZqcfVqtgcy0Yb6LMMRwj
        waxRTdN0iPYq3F+MF9LrSoX+CXZrb8iPyJfZTkfMtga8q6zJXeYB8TMTh5ZYQS30mEiOlp
        F9ZWD+XTXIYeAJq+Ds89YkkxFF2DNcwSjQIqKQNgQt0/B5jw6NXssddBd5hNuQ==
From:   Paulo Alcantara <pc@cjr.nz>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Subject: Re: [PATCH 1/7] cifs: merge __{cifs,smb2}_reconnect[_tcon]() into
 cifs_tree_connect()
In-Reply-To: <03f472c0-3c36-a28d-41bc-5b064b4ea16f@samba.org>
References: <20200706152402.5721-1-pc@cjr.nz>
 <20200706152402.5721-2-pc@cjr.nz>
 <03f472c0-3c36-a28d-41bc-5b064b4ea16f@samba.org>
Date:   Mon, 06 Jul 2020 12:47:18 -0300
Message-ID: <87wo3gsl15.fsf@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Stefan Metzmacher <metze@samba.org> writes:

>> +		if (tcon->ipc) {
>> +			scnprintf(tree, MAX_TREE_SIZE, "\\\\%s\\IPC$", share);
>> +			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
>> +		} else {
>> +			scnprintf(tree, MAX_TREE_SIZE, "\\%s", share);
>> +			rc = ops->tree_connect(xid, tcon->ses, tree, tcon, nlsc);
>> +			if (!rc) {
>> +				rc = update_super_prepath(tcon, prefix, prefix_len);
>> +				break;
>> +			}
>> +		}
>
> The original code used:
>
> -		scnprintf(tree, MAX_TREE_SIZE, "\\%.*s", (int)share_len,
> -			  share);
>
> So it's no longer identical.
>
> Was the share_len code added after my initial patch?

Yep.  See

      e4af35fa55b0 (cifs: handle hostnames that resolve to same ip in failover)
      bacd704a95ad (cifs: handle prefix paths in reconnect)
