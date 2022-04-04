Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF750C41535
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Apr 2022 21:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376635AbiDDVUR (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379048AbiDDQZH (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 4 Apr 2022 12:25:07 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BA35BC0B
        for <linux-cifs@vger.kernel.org>; Mon,  4 Apr 2022 09:23:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id ED47D1F388;
        Mon,  4 Apr 2022 16:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1649089389; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sEd+u18OqQZLt80MHeV41VOOCW5YZRNRevMs/+Ozlkk=;
        b=vm35pTSgFvmAUDKDHa6twkiSIhk2TMzgynL1JXeEtuoU8qv9zsfxqsoj0vR7T/2VoX9qlZ
        jkaNzASGPcMAwaWvRS61bf9NnlEZ7WK+slvTRK7TBPF8f7Z0tBF4YrsYTxj9JIPxv6F34L
        Z+jklzR/Po4v3bwZdFqAJa8V8HTNveU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1649089389;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sEd+u18OqQZLt80MHeV41VOOCW5YZRNRevMs/+Ozlkk=;
        b=A/Wbxuc+8X5kXCVUL/e6AOQdGd1nC7YMCW7Eug6/JUyh2HV6wEHhT3Q8VusC4rqyMBKiKw
        NF5Omtcfb2uz3RAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7BF9913216;
        Mon,  4 Apr 2022 16:23:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7zhrEW0bS2IZdQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 04 Apr 2022 16:23:09 +0000
Date:   Mon, 4 Apr 2022 13:23:07 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     Tom Talpey <tom@talpey.com>, CIFS <linux-cifs@vger.kernel.org>,
        Pavel Shilovsky <pshilovsky@samba.org>,
        Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH] mount.cifs.rst: add FIPS information
Message-ID: <20220404162307.34xrmdfran3mvnvb@cyberdelia>
References: <20220331235251.4753-1-ematsumiya@suse.de>
 <efb1d822-4fcf-dc3b-2861-8394f50aedbe@talpey.com>
 <20220401152508.edovgwz5pxn6gnhn@cyberdelia>
 <d5648e12-c5b9-07de-a20b-afd49adc5f56@talpey.com>
 <20220401174145.6x443h555ch7kspd@cyberdelia>
 <CAH2r5mvG3-TT2YG28zPx_7AzvG3MYvWHh1XVYqvLY8FpYW_4vQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mvG3-TT2YG28zPx_7AzvG3MYvWHh1XVYqvLY8FpYW_4vQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 04/03, Steve French wrote:
>SMB2.1 or later is probably fine (and we note SMB2.1 or 3) for most
>cases in our mount warning message.
>
>But this FIPS compliance issue reminds me that we should get the other
>auth mechanisms working that are 'peer to peer' (so not forced to be
>domain joined).   krb5 is great, but Macs support 'peer-to-peer
>kerberos' and also SCRAM (RFC 7677) so we could also presumably get
>FIPS compliant login for peer-to-peer cases if we implement on or both
>of those other auth mechanisms.

Thanks, Steve. AFAIK, as I mentioned earlier, I don't see FIPS
disapproving particular auth mechanisms, but if those you mention uses
algorithms that are not on FIPS-validated crypto modules, we're out of
luck there as well.

(full disclosure: I'm not yet familiar with "peer-to-peer kerberos")

On-topic: I'd just like to have this patch merged for informational
purposese only. I then can start working on your's and Tom's
suggestions.

>Anyone have some Macs or Mac VMs to test against ...?

Yes. But let's move this one privately please.


Cheers,

Enzo
