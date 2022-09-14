Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F26CC6FA82
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 14:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiINOc0 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiINOcT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 10:32:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F6165801
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 07:32:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 741291FAB1;
        Wed, 14 Sep 2022 14:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663165937; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Bs1ZWUcKZrEvLgTn81wdULv+gPBE3+TM73vOK/RLj4=;
        b=jUOFQL2IFA24utd3tAVxanrpO0Xj2hxuMH7ehzyGdkgJtMGrzW3w5g52ixabfAqZlSH5bN
        BE949d9vqBdgTbNfW9UO1hfvzeOyWtdLYr38dLtStBolEV9Aa1KCm7uIhiQ1C+yeoZ6bZI
        gW6sIvMk+8J9T95B0z0jYI0LmkV5X50=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663165937;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1Bs1ZWUcKZrEvLgTn81wdULv+gPBE3+TM73vOK/RLj4=;
        b=hH49ak2BdyN/Ngbll1Ou2yX3Knb3R+Mj0G+ueFMocTdHVXeaZJkvANfJubsj6Xj2xlwDSb
        Y99ofNSkZX811aBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E7C51134B3;
        Wed, 14 Sep 2022 14:32:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id npj3KfDlIWNUNwAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 14 Sep 2022 14:32:16 +0000
Date:   Wed, 14 Sep 2022 11:32:14 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [RFC PATCH v2 1/3] cifs: introduce AES-GMAC signing support for
 SMB 3.1.1
Message-ID: <20220914143214.nsrssywog7xwtfv5@suse.de>
References: <20220829213354.2714-1-ematsumiya@suse.de>
 <20220829213354.2714-2-ematsumiya@suse.de>
 <0f2d41bf-f0da-aa10-76a3-ced2a3cebba3@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <0f2d41bf-f0da-aa10-76a3-ced2a3cebba3@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi metze,

On 09/14, Stefan Metzmacher wrote:
>
>Hi Enzo,
>
>> +static int smb311_crypt_sign(struct smb_rqst *rqst, int num_rqst, int enc,
>> +			     bool sign_only, struct crypto_aead *tfm, u8 *key,
>> +			     unsigned int keylen, u8 *iv, unsigned int assoclen,
>> +			     unsigned int cryptlen)
>> +{
>> +	struct smb2_hdr *shdr = (struct smb2_hdr *)rqst[0].rq_iov[0].iov_base;
>> +	struct smb2_transform_hdr *tr_hdr =
>> +		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
>> +	u8 sig[SMB2_SIGNATURE_SIZE] = { 0 };
>> +	struct aead_request *aead_req;
>> +	DECLARE_CRYPTO_WAIT(wait);
>> +	struct scatterlist *sg;
>
>I'd propose to keep the encryption and signing cases separate
>as pdu layout of an encrypted TRANSFORM is completely different
>from the signing an SMB2 message. So having them in one function
>is just confusing.

You mean as copying crypt_message() and adapt for AES-GMAC signing,
instead of having the common parts in a separate function? I'll change
that on v3, I just thought it'd be better to have less duplicate code.

>>+static int smb311_aes_gmac_nonce(struct smb2_hdr *shdr, bool is_server,
>>+				 u8 **out_nonce)
>>+{
>>+	struct {
>>+		/* for MessageId (8 bytes) */
>>+		__le64 mid;
>>+		/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
>>+		__le32 role;
>>+	} __packed nonce;
>>+
>>+	if (!shdr || !out_nonce)
>>+		return -EINVAL;
>>-	if (!rc && enc)
>>-		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
>>+	*out_nonce = kzalloc(SMB3_AES_GCM_NONCE, GFP_KERNEL);
>>+	if (!*out_nonce)
>>+		return -ENOMEM;
>
>Why wasting time to allocate/free a 12 byte buffer for every pdu?
>
>Can't we have a named structure and pass in a reference from the
>caller, which has it on the stack?

Got it. I'll fix this for v3.

>
>metze

Cheers,

Enzo
