Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 225AEC433FE
	for <linux-cifs@archiver.kernel.org>; Mon,  3 Oct 2022 19:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiJCTO2 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 3 Oct 2022 15:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiJCTO1 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 3 Oct 2022 15:14:27 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8D172FC39
        for <linux-cifs@vger.kernel.org>; Mon,  3 Oct 2022 12:14:26 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0886B1F88F;
        Mon,  3 Oct 2022 19:14:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664824464; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnZiQvDRJ7lyYl48LlVfZjDOLU0/yDn3y6Q5R+hUSGI=;
        b=sg6ccVmT9/UnZAClKgk2UvzeiLYn9Q/MDxUK4vCHIoidORFtEDEj9aDM1naZS1QPysA71Z
        dUeqUGl8F3Q4fB803EI4A9I9lvd3fMRmPfZX45b4jPblZ8x5+m1JZABj7iyz5x2ipMddlC
        Z251Ajka3d1Izuqs+6DNCtelf9aJ+Yo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664824464;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LnZiQvDRJ7lyYl48LlVfZjDOLU0/yDn3y6Q5R+hUSGI=;
        b=AZtVux7QAm8M2D2C63XeoEliN56Qv7MPUkjSp27xl5aXYB6/Mo63TIDLt5opK40dRMcRI4
        syqD7LDaR2Nm+gDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8111113522;
        Mon,  3 Oct 2022 19:14:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Lm1qEY80O2PdSgAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Mon, 03 Oct 2022 19:14:23 +0000
Date:   Mon, 3 Oct 2022 16:14:20 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Tom Talpey <tom@talpey.com>
Cc:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: [PATCH][smb311 client] fix oops in smb3_calc_signature
Message-ID: <20221003191420.q2n46lah4qdulz4z@suse.de>
References: <CAH2r5mtzWgXbod2tdZsRvZuhBZsv=H9Vf2GA3Q_bQe0nHhjfiQ@mail.gmail.com>
 <93bf9e29-32b6-7def-3595-598e59c8c46e@talpey.com>
 <20221003145326.nx2hjsugeiweb2uy@suse.de>
 <50e0c130-8836-8463-ec8f-fb7cfa6cd7ab@talpey.com>
 <20221003152043.6skowwnlwoidi3yl@suse.de>
 <026fba64-073d-fd2c-644e-1b53c77abc92@talpey.com>
 <20221003163936.ztb7ysxvvka7mzex@suse.de>
 <5c6757cc-7983-c6ca-e651-bb62a71a5b66@talpey.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <5c6757cc-7983-c6ca-e651-bb62a71a5b66@talpey.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 10/03, Tom Talpey wrote:
>On 10/3/2022 12:39 PM, Enzo Matsumiya wrote:
>>On 10/03, Tom Talpey wrote:
>>>On 10/3/2022 11:20 AM, Enzo Matsumiya wrote:
>>>>On 10/03, Tom Talpey wrote:
>>>>>On 10/3/2022 10:53 AM, Enzo Matsumiya wrote:
>>>>>>On 10/03, Tom Talpey wrote:
>>>>>>>On 10/2/2022 11:54 PM, Steve French wrote:
>>>>>>>>shash was not being initialized in one place in smb3_calc_signature
>>>>>>>>
>>>>>>>>Suggested-by: Enzo Matsumiya <ematsumiya@suse.de>
>>>>>>>>Signed-off-by: Steve French <stfrench@microsoft.com>
>>>>>>>>
>>>>>>>
>>>>>>>I don't see the issue. The shash pointer is initialized in both
>>>>>>>arms of the "if (allocate_crypto)" block.
>>>>>>
>>>>>>True, but cifs_alloc_hash() returns 0 if *sdesc is not NULL, so
>>>>>>crypto_shash_setkey() got stack garbage as sdesc.
>>>>>
>>>>>Sorry, I still don't get it.
>>>>>
>>>>>=A0=A0=A0=A0if (allocate_crypto) {
>>>>>=A0=A0=A0=A0=A0=A0=A0 rc =3D cifs_alloc_hash("cmac(aes)", &hash, &sdes=
c);
>>>>
>>>>I think you're looking at an old HEAD.=A0 We've hit this bug after my
>>>>patch 10c6c7b0f060 "cifs: secmech: use shash_desc directly,=20
>>>>remove sdesc"
>>>
>>>Aha. But I'm looking at Steve's current cifs-2.6. Where should
>>>I be looking?
>>
>>It's in cifs-2.6 for-next branch, HEAD 11b1c98d0986 (already has the fix
>>for smb2_calc_signature).
>
>I can't see branches from the git.samba.org web interface.

https://git.samba.org/?p=3Dsfrench/cifs-2.6.git;a=3Dshortlog;h=3Drefs/heads=
/for-next

The branches are in the 'heads' section down below the summary page.
Unintuitive, I'd say...


Enzo

>Are there any browsing alternatives to pulling a full repo? Using
>git on WSL is really, really slow.
>
>Tom.
>
>>
>>
>>>Tom.
>>
>>Cheers,
>>
>>Enzo
>>
>>>>which changes the above line to:
>>>>
>>>>=A0=A0=A0=A0=A0=A0=A0 rc =3D cifs_alloc_hash("cmac(aes)", &shash);
>>>>
>>>>In that patch, shash is the only struct to be initialized.
>>>>cifs_alloc_hash() is:
>>>>
>>>>cifs_alloc_hash(const char *name, struct shash_desc **sdesc)
>>>>{
>>>>=A0=A0=A0=A0=A0=A0 int rc =3D 0;
>>>>=A0=A0=A0=A0=A0=A0 struct crypto_shash *alg =3D NULL;
>>>>
>>>>=A0=A0=A0=A0=A0=A0 if (*sdesc)
>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return 0;
>>>>...
>>>>
>>>>Hence, sdesc having the stack garbage, cifs_alloc_hash returns 0 and
>>>>crypto_shash_setkey crashes.
>>>>
>>>>>=A0=A0=A0=A0=A0=A0=A0 if (rc)
>>>>>=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 return rc;
>>>>>
>>>>>=A0=A0=A0=A0=A0=A0=A0 shash =3D &sdesc->shash;
>>>>>=A0=A0=A0=A0} else {
>>>>>=A0=A0=A0=A0=A0=A0=A0 hash =3D server->secmech.cmacaes;
>>>>>=A0=A0=A0=A0=A0=A0=A0 shash =3D &server->secmech.sdesccmacaes->shash;
>>>>>=A0=A0=A0=A0}
>>>>>
>>>>>The "shash" pointer is initialized one line later.
>>>>>And, "sdesc" is already initilized to NULL.
>>>>>
>>>>>Steve's patch initializes "shash", but now you're referring to
>>>>>sdesc, and it still looks correct to me. Confused...
>>>>>
>>>>>>>But if you do want to add this, them smb2_calc_signature has
>>>>>>>the same code.
>>>>>>
>>>>>>True.=A0 Steve will you add it to this patch please?
>>>>>
>>>>>FYI, smb2_calc_signature() also initializes sdesc, and not shash.
>>>>>Does it not oops? Same code.
>>>>>
>>>>>Tom.
>>>>
>>
