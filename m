Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CD2BC433ED
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 00:17:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3246E61164
	for <linux-cifs@archiver.kernel.org>; Fri,  7 May 2021 00:17:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233548AbhEGASr (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 6 May 2021 20:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbhEGASq (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 6 May 2021 20:18:46 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6644C061574
        for <linux-cifs@vger.kernel.org>; Thu,  6 May 2021 17:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=+Xb6LUWWimtpN6a48OnLoHgp+9IeaOCqomZ5Wb9GXnU=; b=Gb8MesWPCZ4XcWs+6ENGJYwPMz
        weY28YCc17JLKFwAGAcYfpWaBbFf+ugaeYvwDD7mTfVErnnIHJIANoCinvE2wDgAZH9nZR88NHe1h
        dMGb+oz/8ujv2WFSMOLaBnqafPIr31p1YuDS+q6KTnQmndWaSNKW8+tfDyJ/tQWnNLvYChPyMkid5
        +5Cj7lDN7fNm9CyVFJxf5ssLVj2xMzY7jbEPS4K1Wj79GBxW867J4WQBdMI3rxh48QdRp6z2P5avt
        GAg6OLeX4tQiqUJNszmKuZDj+22y6YdETVEkBqci8gX8wkgldWtjc8yuUbsZQR9f5Un+XfsfO4dby
        UuWww5q0U317EVRy/p/UGViTJtZTwpTgYeGvvbzeHTmTObi1ZOF0KfOKRnHZJd1dUrKFSr4kqLGyx
        gjFvGpxXWJjJPah8lSigR2xMd3zI3OF84ISWpwqLC7o0I1p0QelkqUDcrFr2qIa395k5av4XqQuzB
        lBQe3F4qWuBSDqTVI4o2L+Uj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1leoBd-0004dX-GC; Fri, 07 May 2021 00:17:45 +0000
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     samba-technical <samba-technical@lists.samba.org>,
        linux-cifsd-devel@lists.sourceforge.net
References: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH] smb3.1.1: allow dumping GCM256 keys to improve debugging
 of encrypted shares
Message-ID: <c2b84e56-87c6-469d-c272-02731cb0937c@samba.org>
Date:   Fri, 7 May 2021 02:17:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5muN3rpUur8jSav=fJfnt_vuJhgOXxMeGmXvT3KvxbBU5w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Steve,

> +/*
> + * Dump full key (32 byte encrypt/decrypt keys instead of 16 bytes)
> + * is needed if GCM256 (stronger encryption) negotiated
> + */
> +struct smb3_full_key_debug_info {
> + __u64 Suid;
> + __u16 cipher_type;
> + __u8 auth_key[16]; /* SMB2_NTLMV2_SESSKEY_SIZE */

Why this? With kerberos the authentication key can be 32 bytes too.

Why are you exporting it at all?

> + __u8 smb3encryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> + __u8 smb3decryptionkey[SMB3_ENC_DEC_KEY_SIZE];
> +} __packed;
> +

As encryption and decryption is relative wouldn't

something like smb3_s2c_cipherkey and smb3_c2s_cipherkey be better names?

They are derived with SMBS2CCipherKey and SMBC2SCipherKey as labels.

metze
