Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4418C07E9D
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 05:15:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234775AbiI2FO7 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 01:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiI2FO6 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 01:14:58 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EF83BC4A
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=0uS0YutwO6c8hGrXCpjx0AMFIRj6CKQwOO9LhNz9dzg=; b=Lscv2xdwml9Lbv/Uj//6J4tYCH
        jfzHrsipRbwlGs3JMjLKKyR2/3VohbXgulgBvt8WBa7fmsB2HVdjBa98n2Jm65NwpXOQRmkhLaj/n
        BmB0kH3f8mgGJNVHKLE2nEE7zTjaflIcHLYx/w6wtS90fSJsQc0OwPwL5LfPIWJefEMQdidsW88Md
        96lRQcnuPb5JG3aJOFU3El1e7H8q+iuqDr4kzK2/5WBxZIfDYWTBxq4BMEUhnxCORz4reX1hQ+4Gk
        X5o/PVICFPQ6WuH0lB2bLSWehuHslxrBJIV2HQzYRz1gI1s5RDjNQ5XTvCAtkvfzthRxy+ZTf2Wo0
        S8ToX0mXH1VQBxpB6Ul3dN8XhEbOaW3nZZBrnYiak//XhSZUWwwB9ACBxNuv3vJ6Vz1qsL7BOD5Ul
        6hnbA0PT4j5rioqa096LKnaGJcoPrz7rYUCt4S3VvAkYLwoy5XjjQUlGiT0LFBtj4qxa93/k37h2J
        s/rH8aaAiSQujkDn7aHq4P4W;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odlsm-002J7X-Jc; Thu, 29 Sep 2022 05:14:48 +0000
Message-ID: <1ec4803d-e367-96f5-855d-8d48fc40260b@samba.org>
Date:   Thu, 29 Sep 2022 07:14:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v3 5/8] cifs: introduce AES-GMAC signing support for SMB
 3.1.1
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com
References: <20220929015637.14400-1-ematsumiya@suse.de>
 <20220929015637.14400-6-ematsumiya@suse.de>
From:   Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20220929015637.14400-6-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Hi Enzo,

> +/*
> + * This function implements AES-GMAC signing for SMB2 messages as described in MS-SMB2
> + * specification.  This algorithm is only supported on SMB 3.1.1.
> + *
> + * Note: even though Microsoft mentions RFC4543 in MS-SMB2, the mechanism used_must_  be the "raw"
> + * AES-128-GCM ("gcm(aes)"); RFC4543 is designed for IPsec and trying to use "rfc4543(gcm(aes)))"
> + * will fail the signature computation.
> + *
> + * MS-SMB2 3.1.4.1
> + */
> +int
> +smb311_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool verify)
> +{

Can you please add aes_gmac to the function name?

> +	union {
> +		struct {
> +			/* for MessageId (8 bytes) */
> +			__le64 mid;
> +			/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
> +			__le32 role;
> +		};
> +		u8 buffer[12];
> +	} __packed nonce;

Can you use SMB3_AES_GCM_NONCE instead of '12'?

metze
