Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7378EC433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 15:20:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiJCPUt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 11:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiJCPUs (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 11:20:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F024B2F1
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 08:20:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B03271F90C;
        Mon,  3 Oct 2022 15:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664810446; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0nqRSp3H0Fzq4JDsYJug85Bo5I+eFhUlPL39xIsSnXY=;
        b=A8EmTtxwTJrUo3jQGwPAE39BVvDGIe6NVRm2lFGvn2ChcHhlaG8NhauYGlgVbx0mWz5buW
        3EbzPUur8T0O2E8n6+IQGP+ufRR97XpkUqH7UZaNvxzZWf1rcYumJQrrtk2j29gZnwc2Dw
        IG16MFys4OH7/+IT3LXg950bKFoQdRU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664810446;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0nqRSp3H0Fzq4JDsYJug85Bo5I+eFhUlPL39xIsSnXY=;
        b=DN4Ph62VQOG5PaK7Fp2poVq/4u5UQYA7eXzy/wiWzUxEsiJEnSBkxhERt8pd2z36oqSjsr
        amxxUV73xvn6ezCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2B60B1332F;
        Mon,  3 Oct 2022 15:20:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0x4DN839OmNbewAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 03 Oct 2022 15:20:45 +0000
Date:   Mon, 3 Oct 2022 12:20:43 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Message-ID: <20221003152043.6skowwnlwoidi3yl@suse.de>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/03, Tom Talpey wrote:
>On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
>>On 10/03, Tom Talpey wrote:
>>>On 10/2/2022 11:54 PM, Steve French wrote:
>>>>shash was not being initialized in one place in smb3_calc_signature
>>>>
>>>>Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>Signed-off-by: Steve French <stfrench@microsoft.com>
>>>>
>>>
>>>I don't see the issue. The shash pointer is initialized in both
>>>arms of the "if (allocate_crypto)" block.
>>
>>True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
>>crypto_shash_setkey() got stack garbage as sdesc.
>
>Sorry, I still don't get it.
>
>	if (allocate_crypto) {
>		rc =3D cifs_alloc_hash("cmac(aes)", &hash, &sdesc);

I think you're looking at an old HEAD.  We've hit this bug after my
patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove sdesc"
which changes the above line to:

		rc =3D cifs_alloc_hash("cmac(aes)", &shash);

In that patch, shash is the only struct to be initialized.
cifs_alloc_hash() is:

cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
{
        int rc =3D 0;
        struct crypto_shash *alg =3D NULL;

        if (*sdesc)
                return 0;
=2E..

Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
crypto_shash_setkey crashes.

>		if (rc)
>			return rc;
>
>		shash =3D &sdesc->shash;
>	} else {
>		hash =3D server->secmech.cmacaes;
>		shash =3D &server->secmech.sdesccmacaes->shash;
>	}
>
>The "shash" pointer is initialized one line later.
>And, "sdesc" is already initilized to NULL.
>
>Steve's patch initializes "shash", but now you're referring to
>sdesc, and it still looks correct to me. Confused...
>
>>>But if you do want to add this, them smb2_calc_signature has
>>>the same code.
>>
>>True.=A0 Steve will you add it to this patch please?
>
>FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>Does it not oops? Same code.
>
>Tom.
