Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6DA5C433F5
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 16:40:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbiJCQkJ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 12:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiJCQjn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 12:39:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1657A625E
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 09:39:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7974E2195D;
        Mon,  3 Oct 2022 16:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664815179; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0XhTp6KPqDcPUoSqBkK1534WSAUBS7ptfk2WI4eMy4=;
        b=Qu9xTXa1x/BKb2BasdV7kj+IJm+dpO1BDAYfRmRm8yDdaYfLDCwmITcWM2y7DQkypCPlmB
        OnhKEs32xAHhCugZKiTp8kbRA6hG4yibN6fZmZpBABrgmKfLOkDs2K4V1wdXZo0FiY/Jqv
        hWfWa7cQmEDZOjy6Y8yH9qY/MlPUgBU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664815179;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e0XhTp6KPqDcPUoSqBkK1534WSAUBS7ptfk2WI4eMy4=;
        b=gRbQVfPIR/wiYlQAsDHbWjByRUojDB473DK6euIjuqQNu4w8zzPF7YXowpE5zTFrbuWiBS
        YNsEjPENXVVbNOAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE0F213522;
        Mon,  3 Oct 2022 16:39:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id YiJXK0oQO2OPGAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 03 Oct 2022 16:39:38 +0000
Date:   Mon, 3 Oct 2022 13:39:36 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Message-ID: <20221003163936.ztb7ysxvvka7mzex@suse.de>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
 <20221003152043.6skowwnlwoidi3yl@suse.de>
 <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/03, Tom Talpey wrote:
>On 10/3/2022 11:20 AM, Enzo Matsumiya wrote:
>>On 10/03, Tom Talpey wrote:
>>>On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
>>>>On 10/03, Tom Talpey wrote:
>>>>>On 10/2/2022 11:54 PM, Steve French wrote:
>>>>>>shash was not being initialized in one place in smb3_calc_signature
>>>>>>
>>>>>>Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>>>Signed-off-by: Steve French <stfrench@microsoft.com>
>>>>>>
>>>>>
>>>>>I don't see the issue. The shash pointer is initialized in both
>>>>>arms of the "if (allocate_crypto)" block.
>>>>
>>>>True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
>>>>crypto_shash_setkey() got stack garbage as sdesc.
>>>
>>>Sorry, I still don't get it.
>>>
>>>=A0=A0=A0=A0if (allocate_crypto) {
>>>=A0=A0=A0=A0=A0=A0=A0 rc =3D cifs_alloc_hash("cmac(aes)", &hash, &sdesc);
>>
>>I think you're looking at an old HEAD.=A0 We've hit this bug after my
>>patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly, remove sdesc"
>
>Aha. But I'm looking at Steve's current cifs-2.6. Where should
>I be looking?

It's in cifs-2.6 for-next branch, HEAD 11b1c98d0986 (already has the fix
for smb2_calc_signature).


>Tom.

Cheers,

Enzo

>>which changes the above line to:
>>
>> =A0=A0=A0=A0=A0=A0=A0 rc =3D cifs_alloc_hash("cmac(aes)", &shash);
>>
>>In that patch, shash is the only struct to be initialized.
>>cifs_alloc_hash() is:
>>
>>cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
>>{
>> =A0=A0=A0=A0=A0=A0 int rc =3D 0;
>> =A0=A0=A0=A0=A0=A0 struct crypto_shash *alg =3D NULL;
>>
>> =A0=A0=A0=A0=A0=A0 if (*sdesc)
>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>...
>>
>>Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
>>crypto_shash_setkey crashes.
>>
>>>=A0=A0=A0=A0=A0=A0=A0 if (rc)
>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>>>
>>>=A0=A0=A0=A0=A0=A0=A0 shash =3D &sdesc->shash;
>>>=A0=A0=A0=A0} else {
>>>=A0=A0=A0=A0=A0=A0=A0 hash =3D server->secmech.cmacaes;
>>>=A0=A0=A0=A0=A0=A0=A0 shash =3D &server->secmech.sdesccmacaes->shash;
>>>=A0=A0=A0=A0}
>>>
>>>The "shash" pointer is initialized one line later.
>>>And, "sdesc" is already initilized to NULL.
>>>
>>>Steve's patch initializes "shash", but now you're referring to
>>>sdesc, and it still looks correct to me. Confused...
>>>
>>>>>But if you do want to add this, them smb2_calc_signature has
>>>>>the same code.
>>>>
>>>>True.=A0 Steve will you add it to this patch please?
>>>
>>>FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>>>Does it not oops? Same code.
>>>
>>>Tom.
>>
