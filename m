Return-Path: <SRS0=O53D=RY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AF47C43381
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 11:46:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3075F218FD
	for <linux-cifs@archiver.kernel.org>; Thu, 21 Mar 2019 11:46:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728001AbfCULqf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:46:35 -0400
Received: from mx2.suse.de ([195.135.220.15]:42662 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727829AbfCULqf (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 21 Mar 2019 07:46:35 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 3A125AE3B;
        Thu, 21 Mar 2019 11:46:34 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Cc:     Steve French <smfrench@gmail.com>, Stable <stable@vger.kernel.org>,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: [PATCH] cifs: allow guest mounts to work for smb3.11
In-Reply-To: <20190321045902.14326-1-lsahlber@redhat.com>
References: <20190321045902.14326-1-lsahlber@redhat.com>
Date:   Thu, 21 Mar 2019 12:46:32 +0100
Message-ID: <87imwc4fhj.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Ronnie Sahlberg <lsahlber@redhat.com> writes:

> Fix Guest/Anonymous sessions so that they work with SMB 3.11.
>
> In git commit 6188f28 tightened the conditions and forced signing for
> the SMB2-TreeConnect commands as per MS-SMB2.

We could add a

    Fixes: 6188f28bf608 ("Tree connect for SMB3.1.1 must be signed for non-encrypted shares")

tag in the commit message.
>  
> -	/* 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1 */
> +	/*
> +	 * 3.11 tcon req must be signed if not encrypted. See MS-SMB2 3.2.4.1.1
> +	 * unless it is guest or anonymous user. See MS-SMB2 3.2.5.3.1
> +	 */
>  	if ((ses->server->dialect == SMB311_PROT_ID) &&
> -	    !smb3_encryption_required(tcon))
> +	    !smb3_encryption_required(tcon) &&
> +	    !(ses->session_flags & (SMB2_SESSION_FLAG_IS_GUEST|SMB2_SESSION_FLAG_IS_NULL)))
>  		req->sync_hdr.Flags |= SMB2_FLAGS_SIGNED;
>  
>  	memset(&rqst, 0, sizeof(struct smb_rqst));

I suspect there might more (and/or better) places to check. If you grep for
SMB2_FLAGS_SIGNED there are a couple of other places that should be
considered:

smb2_hdr_assemble() { ...
	if (tcon->ses && tcon->ses->server && tcon->ses->server->sign &&
	    !smb3_encryption_required(tcon))
		shdr->Flags |= SMB2_FLAGS_SIGNED;
...
}

cifs_get_smb_ses() { ...
	ses->sectype = volume_info->sectype;
	ses->sign = volume_info->sign;

	mutex_lock(&ses->session_mutex);
	rc = cifs_negotiate_protocol(xid, ses);
	if (!rc)
		rc = cifs_setup_session(xid, ses, volume_info->local_nls);
	mutex_unlock(&ses->session_mutex);
	if (rc)
		goto get_ses_fail;
...
}

After negprot and before sess setup we already know the protocol version so I guess there
could be some patch there as well.

See also SMB2_logoff(), SMB2_ioctl_init(), cifs_enable_signing()

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
