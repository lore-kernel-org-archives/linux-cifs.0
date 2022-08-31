Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B21ECAAD1
	for <linux-cifs@archiver.kernel.org>; Wed, 31 Aug 2022 13:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiHaN3o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiHaN3n (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 31 Aug 2022 09:29:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB773CE30D
        for <linux-cifs@vger.kernel.org>; Wed, 31 Aug 2022 06:29:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 551BF1F85D;
        Wed, 31 Aug 2022 13:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661952581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Hn5jPN99Vyzp/7SB9fNmjLNvmomBcnJJ88qzd018Bg=;
        b=h2ULOko6OcjgflffoosUDGFnV6fmLDHWnVNILhcQuQNYcLc2onkMTmfH5tLeYuDSf1VpDS
        nwCeNXPTXfzB3R46mAOcTSCARsHTA39yDxz8JwpJ3urG6lQwLdKKzVKpQf2s66PGBjDknA
        nov9qTcba82lLEECIt8LZSiObn/qCFU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661952581;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4Hn5jPN99Vyzp/7SB9fNmjLNvmomBcnJJ88qzd018Bg=;
        b=yscEGPKQOL0hNr/+FsDCfadBG9PI/xOU9P19bx9mqrBHf47u3uKN3GRZ5zPosDK/iQcBfA
        625xwUCGOS7eiYDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CBCA913A7C;
        Wed, 31 Aug 2022 13:29:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SZ6oI0RiD2MxOAAAMHmgww
        (envelope-from <ematsumiya@suse.de>); Wed, 31 Aug 2022 13:29:40 +0000
Date:   Wed, 31 Aug 2022 10:29:38 -0300
From:   Enzo Matsumiya <ematsumiya@suse.de>
To:     linux-cifs@vger.kernel.org
Cc:     smfrench@gmail.com, pc@cjr.nz, ronniesahlberg@gmail.com,
        nspmangalore@gmail.com, zhangxiaoxu5@huawei.com
Subject: Re: [PATCH] smb3: remove ->validate_negotiate server op
Message-ID: <20220831132938.ozlqsyw3x6777sq2@cyberdelia>
References: <20220830235119.16991-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220830235119.16991-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 08/30, Enzo Matsumiya wrote:
>Since only SMB 3.0 and 3.0.2 uses it, and they use the same operations
>struct, remove the ->validate_negotiate server op and just check for
>server->dialect on the only caller (SMB2_tcon()).
>
>- rename smb3_validate_negotiate() to smb30_validate_negotiate() to be
>  more explict
>- remove check for SMB311_PROT_ID since it's unreachable anyway
>- simplify dialect counting by using a counter
>
>Signed-off-by: Enzo Matsumiya <ematsumiya@suse.de>
>---
> fs/cifs/cifsglob.h  |  1 -
> fs/cifs/smb2ops.c   |  2 --
> fs/cifs/smb2pdu.c   | 62 ++++++++++++++++++++++-----------------------
> fs/cifs/smb2proto.h |  1 -
> 4 files changed, 30 insertions(+), 36 deletions(-)
> 
> ... snip ...
> 
>@@ -1143,35 +1145,30 @@ int smb3_validate_negotiate(const unsigned int xid, struct cifs_tcon *tcon)
> 	else
> 		pneg_inbuf->SecurityMode = 0;
>
>-
>-	if (strcmp(server->vals->version_string,
>-		SMB3ANY_VERSION_STRING) == 0) {
>-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB30_PROT_ID);
>-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB302_PROT_ID);
>-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB311_PROT_ID);
>-		pneg_inbuf->DialectCount = cpu_to_le16(3);
>-		/* SMB 2.1 not included so subtract one dialect from len */
>-		inbuflen = sizeof(*pneg_inbuf) -
>-				(sizeof(pneg_inbuf->Dialects[0]));
>-	} else if (strcmp(server->vals->version_string,
>-		SMBDEFAULT_VERSION_STRING) == 0) {
>-		pneg_inbuf->Dialects[0] = cpu_to_le16(SMB21_PROT_ID);
>-		pneg_inbuf->Dialects[1] = cpu_to_le16(SMB30_PROT_ID);
>-		pneg_inbuf->Dialects[2] = cpu_to_le16(SMB302_PROT_ID);
>-		pneg_inbuf->Dialects[3] = cpu_to_le16(SMB311_PROT_ID);
>-		pneg_inbuf->DialectCount = cpu_to_le16(4);
>+	i = 0;
>+	if (!strcmp(server->vals->version_string, SMB3ANY_VERSION_STRING)) {
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB30_PROT_ID);
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB302_PROT_ID);
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB311_PROT_ID);
>+		/* SMB 2.1 not included */
>+	} else if (!strcmp(server->vals->version_string, SMBDEFAULT_VERSION_STRING)) {
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB21_PROT_ID);
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB30_PROT_ID);
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB302_PROT_ID);
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(SMB311_PROT_ID);
> 		/* structure is big enough for 4 dialects */
>-		inbuflen = sizeof(*pneg_inbuf);
> 	} else {
> 		/* otherwise specific dialect was requested */
>-		pneg_inbuf->Dialects[0] =
>-			cpu_to_le16(server->vals->protocol_id);
>-		pneg_inbuf->DialectCount = cpu_to_le16(1);
>-		/* structure is big enough for 3 dialects, sending only 1 */
>-		inbuflen = sizeof(*pneg_inbuf) -
>-				sizeof(pneg_inbuf->Dialects[0]) * 2;
>+		pneg_inbuf->Dialects[i++] = cpu_to_le16(server->vals->protocol_id);
> 	}
>
>+	pneg_inbuf->DialectCount = cpu_to_le16(i);
>+	/*
>+	 * The structure holds 4 dialects at most, so subtract the number of dialects not added,
>+	 * if any.
>+	 */
>+	inbuflen = sizeof(*pneg_inbuf) - (sizeof(pneg_inbuf->Dialects[0]) * (4 - i));
>+
> 	rc = SMB2_ioctl(xid, tcon, NO_FILE_ID, NO_FILE_ID,
> 		FSCTL_VALIDATE_NEGOTIATE_INFO,
> 		(char *)pneg_inbuf, inbuflen, CIFSMaxBufSize,

The hunk above will conflict with Zhang's patch
"[PATCH v2 1/3] cifs: Fix the error length of VALIDATE_NEGOTIATE_INFO message",
but this way is, IMHO, safer for future modifications because it doesn't use
hardcoded values.

It might actually make sense to even define a "SMB2_MAX_DIALECTS" to 4
here. Let me know what you think.


Cheers,

Enzo
