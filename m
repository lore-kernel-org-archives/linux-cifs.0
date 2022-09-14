Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1AA4ECAAD3
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 04:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiINEIH (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 00:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbiINEID (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 00:08:03 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B80F54CAF
        for <linux-cifs@vger.kernel.org>; Tue, 13 Sep 2022 21:08:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=XtX3yBWAlb1hGNaQK/OcEY/Uge+XSnK0hHm/abdfTkQ=; b=wJnbxrejla946/uHiOLgCpsCr0
        sM5hFUoFiaONCZ1zzyqIXDVZStTaUPaDGNfAdkrOe3lBwGMYNqVbAC0opGvuS5Yg5q0F3VNKZIRtS
        bOP16ku3iVqy1nfGQ8t3PWKNSR3a+qpmK6AJEPr9hwD4DVhJT3xoh7QyhRYOQQagTG1wX7YCz/VdZ
        zzMs7CpjOCAgN8xZokAa5IPTU9Af4+dhNF4/AuA/f7GVe9Gihy79fFQJA6gxV1n/9RffzcwPoJTJx
        llpnDunxW0TGeXdIed66yQh4DHuVTmn+fLeF+4AyTRg380nUehMSRiVWs04OFBrVQyc+S9obR8Y1P
        dJjS5CpHtZBy8rqGiG6QG/BqsiG1jLjwMpki2CmWodQ25jCuLqr4x5ZGrZE2bZ1wCfiuDFnFVAKmj
        ++G8i/gBcGLkqkLsMaOY0/hnG/xE6xLBwk6BU4R9Efwb6RbI6iY0YAJAgOl96KmAQa33QlNpLDW4B
        /Zg79wCzCDFrQ8RkFnHWm2D4;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oYJgt-000IBU-1E; Wed, 14 Sep 2022 04:07:59 +0000
Message-ID: <0f2d41bf-f0da-aa10-76a3-ced2a3cebba3@samba.org>
Date:   Wed, 14 Sep 2022 06:07:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com
References: <20220829213354.2714-1-ematsumiya@suse.de>
 <20220829213354.2714-2-ematsumiya@suse.de>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [RFC PATCH v2 1/3] cifs: introduce AES-GMAC signing support for
 SMB 3.1.1
In-Reply-To: <20220829213354.2714-2-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Enzo,

 > +static int smb311_crypt_sign(struct smb_rqst *rqst, int num_rqst, int enc,
 > +			     bool sign_only, struct crypto_aead *tfm, u8 *key,
 > +			     unsigned int keylen, u8 *iv, unsigned int assoclen,
 > +			     unsigned int cryptlen)
 > +{
 > +	struct smb2_hdr *shdr = (struct smb2_hdr *)rqst[0].rq_iov[0].iov_base;
 > +	struct smb2_transform_hdr *tr_hdr =
 > +		(struct smb2_transform_hdr *)rqst[0].rq_iov[0].iov_base;
 > +	u8 sig[SMB2_SIGNATURE_SIZE] = { 0 };
 > +	struct aead_request *aead_req;
 > +	DECLARE_CRYPTO_WAIT(wait);
 > +	struct scatterlist *sg;

I'd propose to keep the encryption and signing cases separate
as pdu layout of an encrypted TRANSFORM is completely different
from the signing an SMB2 message. So having them in one function
is just confusing.

> +static int smb311_aes_gmac_nonce(struct smb2_hdr *shdr, bool is_server,
> +				 u8 **out_nonce)
> +{
> +	struct {
> +		/* for MessageId (8 bytes) */
> +		__le64 mid;
> +		/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
> +		__le32 role;
> +	} __packed nonce;
> +
> +	if (!shdr || !out_nonce)
> +		return -EINVAL;
>   
> -	if (!rc && enc)
> -		memcpy(&tr_hdr->Signature, sign, SMB2_SIGNATURE_SIZE);
> +	*out_nonce = kzalloc(SMB3_AES_GCM_NONCE, GFP_KERNEL);
> +	if (!*out_nonce)
> +		return -ENOMEM;

Why wasting time to allocate/free a 12 byte buffer for every pdu?

Can't we have a named structure and pass in a reference from the
caller, which has it on the stack?

metze
