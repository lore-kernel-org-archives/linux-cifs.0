Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFA8CC04A95
	for <linux-cifs@archiver.kernel.org>; Thu, 29 Sep 2022 05:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234340AbiI2Fpx (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 29 Sep 2022 01:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233495AbiI2Fpw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 29 Sep 2022 01:45:52 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A9C10AB29
        for <linux-cifs@vger.kernel.org>; Wed, 28 Sep 2022 22:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=From:Cc:To:Date:Message-ID;
        bh=0l2sDerpxuSc+ZTsHi/PZfg9g+PSHeLVtarHJOv0XVk=; b=1mZPNuI8CyhpYowzzR7w4OksO+
        rlq8gsrI2bI4F6QpkkORFkegsc2uEjVCbfqdUwGZNB708QJECc400ce8dX/JutxWVZ6tYNEvKnAP0
        bBNLncQePsuYg1J4q3X/vYy061OKzJysfgVIZCRCFwwEBATQcfucDxkUlpRWYsPzOgkQYl45ffcBi
        2HvY/kURg9o6Qd7Hj+E1YoXXK3dEGh9LZ3kqU8fH1pGmZcYZ0t93UdvYQADgsnHPmqxiEAJa2dQ+O
        8TbhSJ0Q7iMsNteqBANER6blIq9MSMZV8FQhw8Y6K0hkvubgPjq5klJ+bBIuNBpv8Utjyf+4E+uKd
        j9mfMywjW/BU4PMPZsAFgCTmu3FLqOoFdGytnlPjTuAtYnJOx2HBkygx6BpHPnyEbd2BrAsLAKkly
        OhEFt0kST7iVzadUrcVsFIhnCuFuTphhMQlidEIEO5HpI+Nf3J7xIpY9Xk0OVDwVHLjE/HU8eJHTZ
        VQlusKKZ60Tid7hHIuz8jwHi;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1odmMn-002JFK-0F; Thu, 29 Sep 2022 05:45:49 +0000
Message-ID: <c35302ad-af6b-9036-0a41-213c3d23d222@samba.org>
Date:   Thu, 29 Sep 2022 07:45:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, tom@talpey.com
References: <20220929015637.14400-1-ematsumiya@suse.de>
 <20220929015637.14400-9-ematsumiya@suse.de>
From:   Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v3 8/8] cifs: use MAX_CIFS_SMALL_BUFFER_SIZE-8 as padding
 buffer
In-Reply-To: <20220929015637.14400-9-ematsumiya@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Am 29.09.22 um 03:56 schrieb Enzo Matsumiya:
> AES-GMAC is more picky about buffers locality, alignment, and size, so
> we can't use a stack-allocated buffer as padding (smb2_padding).
> 
> This commit drops smb2_padding and "reserves" the 8 last bytes of each
> small buffer, which are slab-allocated, as the padding buffer space.
> 
> Introduce SMB2_PADDING_BUF(buf) macro to easily grab the padding buffer.
> For now, only used in smb2_set_next_command().
> 
> Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
> ---
>   fs/cifs/smb2ops.c | 7 +++++--
>   fs/cifs/smb2pdu.c | 9 +++++----
>   fs/cifs/smb2pdu.h | 2 --
>   3 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index 22b40d181bba..0b8497e1c747 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -2323,7 +2323,10 @@ smb2_set_related(struct smb_rqst *rqst)
>   	shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
>   }
>   
> -char smb2_padding[7] = {0, 0, 0, 0, 0, 0, 0};
> +/*
> + * Use the last 8 bytes of the small buf as the padding buffer, when necessary
> + */
> +#define SMB2_PADDING_BUF(buf) (buf + MAX_CIFS_SMALL_BUFFER_SIZE - 8)

Do we need to expend the size of MAX_CIFS_SMALL_BUFFER_SIZE
in order to avoid reusing parts of the buffer used otherwise.

(But MAX_CIFS_SMALL_BUFFER_SIZE is confusing magic I don't really
understand, for me it's really hard to prove we never overflow
MAX_CIFS_SMALL_BUFFER_SIZE).

>   void
>   smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
> @@ -2352,7 +2355,7 @@ smb2_set_next_command(struct cifs_tcon *tcon, struct smb_rqst *rqst)
>   		 * If we do not have encryption then we can just add an extra
>   		 * iov for the padding.
>   		 */
> -		rqst->rq_iov[rqst->rq_nvec].iov_base = smb2_padding;
> +		rqst->rq_iov[rqst->rq_nvec].iov_base = SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base);
>   		rqst->rq_iov[rqst->rq_nvec].iov_len = num_padding;
>   		rqst->rq_nvec++;
>   		len += num_padding;
> diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
> index 6c22ead51feb..fca1b580d57d 100644
> --- a/fs/cifs/smb2pdu.c
> +++ b/fs/cifs/smb2pdu.c
> @@ -362,6 +362,9 @@ fill_small_buf(__le16 smb2_command, struct cifs_tcon *tcon,
>   	/*
>   	 * smaller than SMALL_BUFFER_SIZE but bigger than fixed area of
>   	 * largest operations (Create)
> +	 *
> +	 * Note that the last 8 bytes of the small buffer are reserved for padding when required
> +	 * (see SMB2_PADDING_BUF in smb2ops.c)
>   	 */
>   	memset(buf, 0, 256);
>   
> @@ -2993,8 +2996,7 @@ SMB2_open_free(struct smb_rqst *rqst)
>   	if (rqst && rqst->rq_iov) {
>   		cifs_small_buf_release(rqst->rq_iov[0].iov_base);
>   		for (i = 1; i < rqst->rq_nvec; i++)
> -			if (rqst->rq_iov[i].iov_base != smb2_padding)
> -				kfree(rqst->rq_iov[i].iov_base);
> +			kfree(rqst->rq_iov[i].iov_base);
>   	}
>   }
>   
> @@ -3187,8 +3189,7 @@ SMB2_ioctl_free(struct smb_rqst *rqst)
>   	if (rqst && rqst->rq_iov) {
>   		cifs_small_buf_release(rqst->rq_iov[0].iov_base); /* request */
>   		for (i = 1; i < rqst->rq_nvec; i++)
> -			if (rqst->rq_iov[i].iov_base != smb2_padding)
> -				kfree(rqst->rq_iov[i].iov_base);
> +			kfree(rqst->rq_iov[i].iov_base);

Don't we need to check against SMB2_PADDING_BUF(rqst->rq_iov[0].iov_base) here
and avoid passing an invalid pointer to kfree()?

metze
