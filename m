Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B53BC433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 14:17:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbiI2ORD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 10:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235588AbiI2ORC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 10:17:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21CBD153EE5
        for <linux-cifs@vger.kernel.org>; Thu, 29 Sep 2022 07:17:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D89371F8B2;
        Thu, 29 Sep 2022 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1664461019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x5G7UV4tY5ehGtPouBby1F0SMmv2Q2ZTj/FG2kYGxuY=;
        b=BP2zInzQrvy1S4hGRAzvFe5m5JDedpg0FTNt1YaKt0l+YfkpMCruedr3UVK1SgsVjAMATE
        g2o087RW9njTj8oebTfCtLvX/52nS2I/nFUBaeDVa4wLKfDefav1NAQnC6YaNuzVCEtl4A
        2d7n1x3bOvx/dDYZDckt1dPTTnJlxzM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1664461019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=x5G7UV4tY5ehGtPouBby1F0SMmv2Q2ZTj/FG2kYGxuY=;
        b=rFYXMzwE58FO1KySRyiR6bWCiayT3aLwmou12Rq0pY600r+oNxlJlzMrts4akK/sDndylP
        yBvxHfYfxMghTzDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5487C13A71;
        Thu, 29 Sep 2022 14:16:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id k3JtBduoNWNbPQAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Thu, 29 Sep 2022 14:16:59 +0000
Date:   Thu, 29 Sep 2022 11:16:56 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     Stefan Metzmacher <metze@samba.org>
Cc:     linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@cjr.nz,
        ronniesahlberg@gmail.com, nspmangalore@gmail.com, tom@talpey.com
Subject: Re: [PATCH v3 5/8] cifs: introduce AES-GMAC signing support for SMB
 3.1.1
Message-ID: <20220929141656.z77h2f5notu6qzyc@suse.de>
References: <20220929015637.14400-1-ematsumiya@suse.de>
 <20220929015637.14400-6-ematsumiya@suse.de>
 <1ec4803d-e367-96f5-855d-8d48fc40260b@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1ec4803d-e367-96f5-855d-8d48fc40260b@samba.org>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi metze,

On 09/29, Stefan Metzmacher wrote:
>
>Hi Enzo,
>
>>+/*
>>+ * This function implements AES-GMAC signing for SMB2 messages as described in MS-SMB2
>>+ * specification.  This algorithm is only supported on SMB 3.1.1.
>>+ *
>>+ * Note: even though Microsoft mentions RFC4543 in MS-SMB2, the mechanism used_must_  be the "raw"
>>+ * AES-128-GCM ("gcm(aes)"); RFC4543 is designed for IPsec and trying to use "rfc4543(gcm(aes)))"
>>+ * will fail the signature computation.
>>+ *
>>+ * MS-SMB2 3.1.4.1
>>+ */
>>+int
>>+smb311_calc_signature(struct smb_rqst *rqst, struct TCP_Server_Info *server, bool verify)
>>+{
>
>Can you please add aes_gmac to the function name?

Sure.  Should I also change smb2_calc_signature to smb2_calc_shash or
something similar, since it fits now for SMB[2.x,3.0.x]?

>>+	union {
>>+		struct {
>>+			/* for MessageId (8 bytes) */
>>+			__le64 mid;
>>+			/* for role (client or server) and if SMB2 CANCEL (4 bytes) */
>>+			__le32 role;
>>+		};
>>+		u8 buffer[12];
>>+	} __packed nonce;
>
>Can you use SMB3_AES_GCM_NONCE instead of '12'?

I was going to submit a follow up series replacing the defines we use
with the crypto ones to clarify meanings, e.g. SMB3_AES_GCM_NONCE made
me wonder at first sight if it was different from GCM_AES_IV_SIZE.
But sure I can change it for the time being.

>metze

Cheers,

Enzo
