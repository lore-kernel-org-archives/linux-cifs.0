Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9C3C433FE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 14:43:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14BD922EBE
	for <linux-cifs@archiver.kernel.org>; Thu, 10 Dec 2020 14:43:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391452AbgLJOmx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 10 Dec 2020 09:42:53 -0500
Received: from p3plsmtpa07-05.prod.phx3.secureserver.net ([173.201.192.234]:55822
        "EHLO p3plsmtpa07-05.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388998AbgLJOmn (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 10 Dec 2020 09:42:43 -0500
X-Greylist: delayed 541 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Dec 2020 09:42:42 EST
Received: from [192.168.0.116] ([71.184.94.153])
        by :SMTPAUTH: with ESMTPSA
        id nN01kfDMeHJb8nN01kmRUX; Thu, 10 Dec 2020 07:32:54 -0700
X-CMAE-Analysis: v=2.4 cv=KdIXDSUD c=1 sm=1 tr=0 ts=5fd23196
 a=vbvdVb1zh1xTTaY8rfQfKQ==:117 a=vbvdVb1zh1xTTaY8rfQfKQ==:17
 a=IkcTkHD0fZMA:10 a=VwQbUJbxAAAA:8 a=yMhMjlubAAAA:8 a=zQPnsYOnZOmdsViGIoYA:9
 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
X-SECURESERVER-ACCT: tom@talpey.com
Subject: Re: [PATCH] SMB3.1.1: do not log warning message if server doesn't
 populate salt
To:     Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Cc:     Pavel Shilovsky <piastryyy@gmail.com>,
        Tom Talpey <ttalpey@microsoft.com>
References: <CAH2r5mvdtdzFBMTUCk6DwK1zHW-fP-G9k3DpchD2bqnboooq8g@mail.gmail.com>
From:   Tom Talpey <tom@talpey.com>
Message-ID: <3aeefd61-8376-66b4-6e2d-20dcb1e53bb8@talpey.com>
Date:   Thu, 10 Dec 2020 09:32:53 -0500
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <CAH2r5mvdtdzFBMTUCk6DwK1zHW-fP-G9k3DpchD2bqnboooq8g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfMMsDpELD7/jR4IY52NSS73UwvesUC0D77XqVIjhwZzTf+QYk2IkrnLiGnemMs1S4aIHghFIw29ehRtJRmRLT/tcc1cdF+EKAql3o2WTIsT4jUwbBSR2
 ZUaBXyhagCU7bCJ9P77tKbE2R1XIWuRXXiiBKd+hyj2uKyPVnWFyOXRwTZV+ZFAt88zsFGSx8pR4kWVkKyusrw0/mpuhuTBOv8ANcuMrWGVJ5v4eGStoZwYS
 ycckl1yYzq5iTkB8gb8M3lpHJG7W92oH2Whu6yCIbbHOltVb3GIlvj3xIN61KiX7
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tl;dr - the issue here goes deeper than Salt length

On 12/9/2020 11:24 PM, Steve French wrote:
> In the negotiate protocol preauth context, the server is not required
> to populate the salt (although it is recommended, and done by most

I don't think "recommended" is correct. The salt is optional, and that's
because not all hashes use salt. Of course, the protocol currently
only defines one hash algorithm, which does. But that could change.
So delete "it is recommended,", and "most".

> servers) so do not warn on mount if the salt is not 32 bytes, but
> instead simply check that the preauth context is the minimum size
> and that the salt would not overflow the buffer length.

Suggest ending at "so do not warn.", see following.

> CC: Stable <stable@vger.kernel.org>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> ---
>   fs/cifs/smb2pdu.c |  7 +++++--
>   fs/cifs/smb2pdu.h | 14 +++++++++++---
>   2 files changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index acb72705062d..8d572dcf330a 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -427,8 +427,8 @@ build_preauth_ctxt(struct smb2_preauth_neg_context
> *pneg_ctxt)
>    pneg_ctxt->ContextType = SMB2_PREAUTH_INTEGRITY_CAPABILITIES;
>    pneg_ctxt->DataLength = cpu_to_le16(38);
>    pneg_ctxt->HashAlgorithmCount = cpu_to_le16(1);
> - pneg_ctxt->SaltLength = cpu_to_le16(SMB311_SALT_SIZE);
> - get_random_bytes(pneg_ctxt->Salt, SMB311_SALT_SIZE);
> + pneg_ctxt->SaltLength = cpu_to_le16(SMB311_CLIENT_SALT_SIZE);
> + get_random_bytes(pneg_ctxt->Salt, SMB311_CLIENT_SALT_SIZE);

Changing the salt size define is ok, but it's important to keep clear
that "32" is not specified by the protocol, it just happens to be
what Windows chose, for SHA512. I think it's a fine idea to do the
same, since we're all using the same hash algorithm.

Why not simply code a constant 32? Or, make the define something
like LINUX_SMB3_SHA512_SALT_LENGTH_CHOICE?

>    pneg_ctxt->HashAlgorithms = SMB2_PREAUTH_INTEGRITY_SHA512;
>   }
> 
> @@ -566,6 +566,9 @@ static void decode_preauth_context(struct
> smb2_preauth_neg_context *ctxt)
>    if (len < MIN_PREAUTH_CTXT_DATA_LEN) {
>    pr_warn_once("server sent bad preauth context\n");
>    return;
> + } else if (len < MIN_PREAUTH_CTXT_DATA_LEN + le16_to_cpu(ctxt->SaltLength)) {
> + pr_warn_once("server sent invalid SaltLength\n");
> + return;
>    }
>    if (le16_to_cpu(ctxt->HashAlgorithmCount) != 1)
>    pr_warn_once("Invalid SMB3 hash algorithm count\n");

This comment applies to all three pr_warn's.

Why are these here? The server is busted, sure, but the client is being
a protocol validation test suite. And the information is really not very
useful. How is a sysadmin supposed to respond? Finally, why are they 
pr_warn_once? If this server is broken, what about all the other ones,
for which it suppresses the next warning?

I say, if the negotiate response is invalid, abort the negotiate and
forget throwing the book at it. No pr_warn's, or a simple generic one.

> diff --git a/fs/cifs/smb2pdu.h b/fs/cifs/smb2pdu.h
> index fa57b03ca98c..de3127a6fc34 100644
> --- a/fs/cifs/smb2pdu.h
> +++ b/fs/cifs/smb2pdu.h
> @@ -333,12 +333,20 @@ struct smb2_neg_context {
>    /* Followed by array of data */
>   } __packed;
> 
> -#define SMB311_SALT_SIZE 32
> +#define SMB311_CLIENT_SALT_SIZE 32
>   /* Hash Algorithm Types */
>   #define SMB2_PREAUTH_INTEGRITY_SHA512 cpu_to_le16(0x0001)
>   #define SMB2_PREAUTH_HASH_SIZE 64
> 
> -#define MIN_PREAUTH_CTXT_DATA_LEN (SMB311_SALT_SIZE + 6)
> +/*
> + * SaltLength that the server send can be zero, so the only three required

It can be "any value", including zero.

> + * fields (all __le16) end up six bytes total, so the minimum context data len
> + * in the response is six.
> + * The three required are: HashAlgorithmCount, SaltLength, and 1 HashAlgorithm
> + * Although most servers send a SaltLength of 32 bytes, technically it is
> + * optional.

"Required" is ambiguous. All three of these fields are in the header,
so they're all required. It's their value that's important. Obviously
HashAlgorithmCount must be >0. SaltLength can be any value. Suggest
removing this last sentence entirely.

> + */
> +#define MIN_PREAUTH_CTXT_DATA_LEN 6
>   struct smb2_preauth_neg_context {
>    __le16 ContextType; /* 1 */
>    __le16 DataLength;
> @@ -346,7 +354,7 @@ struct smb2_preauth_neg_context {
>    __le16 HashAlgorithmCount; /* 1 */
>    __le16 SaltLength;
>    __le16 HashAlgorithms; /* HashAlgorithms[0] since only one defined */
> - __u8 Salt[SMB311_SALT_SIZE];
> + __u8 Salt[SMB311_CLIENT_SALT_SIZE];

Incorrect! The protocol does not define this value. 32 is only an
implementation behavior. This field is not constant, and may be 0.

Tom.

>   } __packed;
> 
>   /* Encryption Algorithms Ciphers */
> 
> 
