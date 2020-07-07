Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 908FFC433DF
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 07:03:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 71A9D20702
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 07:03:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728215AbgGGHDV convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 03:03:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:44826 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726788AbgGGHDU (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 7 Jul 2020 03:03:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8809FAC79;
        Tue,  7 Jul 2020 07:03:19 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paul Aurich <paul@darkrain42.org>
Cc:     linux-cifs@vger.kernel.org, linux-sparse@vger.kernel.org,
        sfrench@samba.org, Ronnie Sahlberg <lsahlber@redhat.com>
Subject: lock checking issues (was: Re: [PATCH v3] cifs: Fix leak when
 handling lease break for cached root fid)
In-Reply-To: <20200706192642.GA110607@haley.home.arpa>
References: <20200702164411.108672-1-paul@darkrain42.org>
 <878sfx6o64.fsf@suse.com> <20200706192642.GA110607@haley.home.arpa>
Date:   Tue, 07 Jul 2020 09:03:17 +0200
Message-ID: <87tuyj6c3u.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


CC-ing linux-sparse

We are seeing a lock context imbalance warning which we can't get rid
of after applying a patch moving locking around across function boundaries.

For context see:
https://lore.kernel.org/linux-cifs/20200702164411.108672-1-paul@darkrain42.org/T/#u

Paul Aurich <paul@darkrain42.org> writes:
> On 2020-07-06 10:30:27 +0200, Aurélien Aptel wrote:
>>Paul Aurich <paul@darkrain42.org> writes:
>>> Changes since v2:
>>>    - address sparse lock warnings by inlining smb2_tcon_has_lease and
>>>      hardcoding some return values (seems to help sparse's analysis)
>>
>>Ah, I think the issue is not the inlining but rather you need to
>>instruct sparse that smb2_tcon_hash_lease is expected to release the
>>lock.
>>
>>https://www.kernel.org/doc/html/v4.12/dev-tools/sparse.html#using-sparse-for-lock-checking
>>
>>Probably with __releases somewhere in the func prototype.
>
> I tried various iterations of that without finding one that seems to work. 
> I suspect it's because the unlocking is _conditional_.

Hm could be it...

> w/o the inline and with __releases(&cifs_tcp_ses_lock):
>
> fs/cifs/smb2misc.c:508:1: warning: context imbalance in 'smb2_tcon_has_lease' 
> - different lock contexts for basic block
> fs/cifs/smb2misc.c:612:25: warning: context imbalance in 
> 'smb2_is_valid_lease_break'- different lock contexts for basic block
>
>
> Digging further, I found __acquire and __release (not plural), which can be 
> used in individual blocks. The following seems to silence the sparse warnings 
> - does this seem valid?

To be honnest I'm not sure, these seem counterproductive. If you are
indicating you are acquiring X but lock Y the next line it feels like we
are fighting the tool instead of letting it help us.

> @@ -504,7 +504,7 @@ cifs_ses_oplock_break(struct work_struct *work)
>   	kfree(lw);
>   }
>   
> -static inline bool
> +static bool
>   smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>   {
>   	bool found;
> @@ -521,6 +521,7 @@ smb2_tcon_has_lease(struct cifs_tcon *tcon, struct smb2_lease_break *rsp)
>   
>   	lease_state = le32_to_cpu(rsp->NewLeaseState);
>   
> +	__acquire(cifs_tcp_ses_lock);

Should it have a "&" here?

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
