Return-Path: <SRS0=9U06=D6=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0602C388F9
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9EF5D207F7
	for <linux-cifs@archiver.kernel.org>; Fri, 23 Oct 2020 18:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S465673AbgJWSmp (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 23 Oct 2020 14:42:45 -0400
Received: from p3plsmtpa07-09.prod.phx3.secureserver.net ([173.201.192.238]:54349
        "EHLO p3plsmtpa07-09.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S465667AbgJWSmp (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 23 Oct 2020 14:42:45 -0400
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id W21UkDr0CS7GKW21Uk5CxN; Fri, 23 Oct 2020 11:42:44 -0700
X-CMAE-Analysis: v=2.4 cv=P/3/OgMu c=1 sm=1 tr=0 ts=5f932424
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=MzRL57FGyejjtg-XPSQA:9 a=QEXdDO2ut3YA:10
X-SECURESERVER-ACCT: tom@talpey.com
To:     "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>
From:   Tom Talpey <tom@talpey.com>
Subject: AES CCM/GCM nonce generation possible issue
Message-ID: <0ff7a5c9-d016-b480-ed10-0634316b00ca@talpey.com>
Date:   Fri, 23 Oct 2020 14:42:44 -0400
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfCDEIkl5ttRsNAwRPx7+JU9t6ghhkhRm24BpRer4oqDbvYFdYgttymKwquNFpDl6j7KRoOJsz3h0nBj5jkKhCCUVKmvCYwSM67e2G3RfixpjaGyHtpE3
 iL+gvSzXWxuT8OQR5CY4fJ69PeRpqV1Z+3RgCAEifeLWfhFb29NcFvkHvEFwze4sXu7NZJLDi4/gbg==
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

In the recent changeset I spotted a concern in the existing
nonce generation. The code appears to be using a randomly
generated value for each new op. This runs the risk of reusing
a nonce, should the RNG produce a cycle, or if enough requests
are generated (not an impossibility with high-bandwidth RDMA).

It's a critical security issue to never reuse a nonce for a
new data pattern encrypted with the same key, because the cipher
is compromised if this occurs. There is no need for the nonce
to be random, only different. With 11+ bytes of nonce, it
is possible to partition the field and manage this with a
simple counter. The session encryption can be rekeyed prior
to the counter wrap. The nonce field can then be a property
of the session.

Or, am I incorrect in my understanding of the following?

In fs/cifs/smb2ops.c:

3793 static void
3794 fill_transform_hdr(struct smb2_transform_hdr *tr_hdr, unsigned int 
orig_len,
3795                    struct smb_rqst *old_rq, __le16 cipher_type)
3796 {
3797         struct smb2_sync_hdr *shdr =
3798                         (struct smb2_sync_hdr 
*)old_rq->rq_iov[0].iov_base;
3799
3800         memset(tr_hdr, 0, sizeof(struct smb2_transform_hdr));
3801         tr_hdr->ProtocolId = SMB2_TRANSFORM_PROTO_NUM;
3802         tr_hdr->OriginalMessageSize = cpu_to_le32(orig_len);
3803         tr_hdr->Flags = cpu_to_le16(0x01);
--\
3804         if (cipher_type == SMB2_ENCRYPTION_AES128_GCM)
3805                 get_random_bytes(&tr_hdr->Nonce, SMB3_AES128GCM_NONCE);
3806         else
3807                 get_random_bytes(&tr_hdr->Nonce, SMB3_AES128CCM_NONCE);
--/
3808         memcpy(&tr_hdr->SessionId, &shdr->SessionId, 8);
3809 }

In MS-SMB2 section 2.2.41:

AES_CCM_Nonce (11 bytes): An implementation-specific value assigned for 
every encrypted message. This MUST NOT be reused for all encrypted 
messages within a session.

[several other similar statements throughout document]
