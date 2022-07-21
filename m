Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83692C43334
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Jul 2022 21:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbiGUVCa (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Jul 2022 17:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbiGUVC0 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 21 Jul 2022 17:02:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ADF190D85
        for <linux-cifs@vger.kernel.org>; Thu, 21 Jul 2022 14:02:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1C3DB1FDC9;
        Thu, 21 Jul 2022 21:02:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1658437344; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pL5PpBTQmGNcS6y8ZtTSB5O3tSOErdFXGPqbN3eq3r8=;
        b=v8ER8cpPejTLTFT7adyuEsdHKW57YbApVnq3OmQUDqy/1hKkWtcy4kosC+GUtdlZtkPDmZ
        vX2D///E9KuPEg2D/3Iss1TWLgi7QAo4HvCfRFJL/WRpZCiuGq7eIgYAcgA3KeR7EaFNyX
        tHqew1yf/gqstMUtps3PUsSC9UDdFhQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1658437344;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pL5PpBTQmGNcS6y8ZtTSB5O3tSOErdFXGPqbN3eq3r8=;
        b=CcwW16swrDx3ZsUxiRjDgNXxWe8lOSGxCcWiyZX2EeUBwKvDwwGdIg2Ze2ND82vnv56Cwp
        MGhFtruHA7VZI/DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 907C313A1B;
        Thu, 21 Jul 2022 21:02:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id od6rFN++2WL3WQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 21 Jul 2022 21:02:23 +0000
Date:   Thu, 21 Jul 2022 18:02:21 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Steve French <smfrench@gmail.com>
Cc:     rohiths msft <rohiths.msft@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH] smb2: simplify mid handling/dequeueing code
Message-ID: <20220721210221.aazvt57zrbwz4v45@cyberdelia>
References: <20220719173151.12068-1-ematsumiya@suse.de>
 <CAH2r5mtgMdFqqopgKDXOnGR0zAEcOB-wW_1OxZRmix78WTdfkQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAH2r5mtgMdFqqopgKDXOnGR0zAEcOB-wW_1OxZRmix78WTdfkQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 07/20, Steve French wrote:
>Can you give some context as to why only smb2_find_dequeue_mid()
>set the "dequeue" flag to true and why it doesn't need to be
>distinguished from the other find_mid cases?
>I think Rohith wrote this - Rohith does the change make sense to you? Thoughts?

The way I see it, it's better to be explicit and do a find_mid()
followed by a dequeue_mid(), than to have a function that do both,
especially when that function is used only in one place
(smb2_decrypt_offload()).
Tho @Rohith please clarify if I missed something here.

>Also Enzo can you explain a little what the callers were who set
>"malformed" (and why it now no longer needs to be used)?

This is, again, to be explicit. It makes no sense to me to have a
"malformed" parameter in a function named "dequeue_mid", e.g. when
reading the code I stumbled upon:

dequeue_mid(mid, false);
and
dequeue_mid(mid, rdata->result);

Let me know if this doesn't make sense to you.


Cheers,

Enzo
