Return-Path: <SRS0=wfZ6=BY=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D069C433E1
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 09:52:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D7E0208A9
	for <linux-cifs@archiver.kernel.org>; Fri, 14 Aug 2020 09:52:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgHNJwq convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 14 Aug 2020 05:52:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:37486 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727039AbgHNJwp (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 14 Aug 2020 05:52:45 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EFDE8ACB0;
        Fri, 14 Aug 2020 09:53:06 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org,
        Pavel Shilovsky <piastryyy@gmail.com>,
        Steve French <smfrench@gmail.com>, sribhat.msa@outlook.com
Subject: Re: [PATCH][SMB3] mount.cifs integration with PAM
In-Reply-To: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
References: <CANT5p=pxPsBwAv3oJX6Ae9wjpZoEjLvyfGM1sM9DEhS11RNgog@mail.gmail.com>
Date:   Fri, 14 Aug 2020 11:52:42 +0200
Message-ID: <87pn7t4kr9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Shyam,

Shyam Prasad N <nspmangalore@gmail.com> writes:
> Currently, for sec=krb5, mount.cifs assumes that the kerberos TGT is
> already downloaded and stored in krb5 cred cache file. If an AD user
> is logged in through ssh or su, those utilities authenticate with PAM
> (winbind or sssd), and winbind/sssd can be configured to perform
> krbtgt house-keeping (like refreshing the tickets). However, if the AD
> user is not logged in, and the local root user wants to mount the
> share using the credentials for an AD user, he/she will need to resort
> to manual kinit, and this does not go through winbind/sssd.

That is correct, I think. Note that using when login in the system PAM
also sets up KRB5CCNAME variable that points to the credential cache
(e.g. "FILE:/tmp/krb5cc_0") and is then inherited in all processes in
the session.

> Attached patch will introduce PAM authentication in mount.cifs. If
> sec=krb5 is specified, mount.cifs will attempt to authenticate with
> PAM as the username mentioned in mount options. If the authentication
> fails, we fall back to the old behavior and proceed with the mount
> nevertheless.

Shouldn't we do it the other way around? i.e. try to use any existing
credential cache, and if that fails auth again with PAM. I think we
might end up overwriting an existing cache or logging in twice
otherwise.

> @linux-cifs: Please review the overall flow, and let me know if there
> are any issues/suggestions. The feature is enabled by default in a
> configure parameter (krb5pam), and can be disabled. Do we also need a
> new mount option to trigger this new behavior? (try-pam-auth?)

> @samba-technical: Please review the overall flow of PAM
> authentication. Currently, I'm mainly doing pam_authenticate and
> pam_setcreds. Is there any added benefit opening and closing session?
> Is it possible to call pam_open_session from mount.cifs, and then call
> pam_close_session in another binary (umount.cifs)?

I am not 100% sure about this but I think the session should be opened
in the context of the parent shell process to be able to be persistent,
otherwise the session will close when mount.cifs exits. Maybe there is a
way to pin the session on a different processes... But most likely there
is an existing session opened by PAM when the user initially logged in
the system (regardless of the PAM backend/params).

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
