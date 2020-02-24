Return-Path: <SRS0=Mxq5=4M=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C772CC11D2F
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:09:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EA5120732
	for <linux-cifs@archiver.kernel.org>; Mon, 24 Feb 2020 18:09:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="DhHRxFr/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBXSJ1 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 24 Feb 2020 13:09:27 -0500
Received: from hr2.samba.org ([144.76.82.148]:42750 "EHLO hr2.samba.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727438AbgBXSJ1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 24 Feb 2020 13:09:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Message-ID:Date:Cc:To:From;
        bh=dncC1+AIXe5x8YkL6TV20WMQHP5QGqaKfz8buJ2SUcw=; b=DhHRxFr/SwFyJ5j+CzE/pFPJFP
        QtqfjQObJMINEMpwzwx7t67DAI2xPFq2nn32l/pn6JsqBkguXbGBA7klxpRPuyUJXBs1OtWK+cigC
        w5qbpj8QF2RoriNBKoIZdNzSRY34TcKrww0/M+D0xmiMdUmkqyq+gBEA90tKgMO4E3lLbFqjaVM16
        28CkYozSCP5qwYuSX0BbYX0SqlWOA8e1PuKVcrLkwf1JQKR+PesZONVpnleZid6dzNfR1sY03ooHQ
        uJeZnfYMW5ekcd5ZajrralzkvvPS67zozZjAXTF7UCm1KDoDJyR72W+DGDw3/pJs85R39ILQANNlU
        1RFtH+TfZTFALtRN5hrP40SyxYaazITMBlU3vJgi1m+dJnR6UvDtzJ4Ik7LOZXIpi+MCCBQiDHsh5
        waETlpkxgWzFdbOQ8dJgafvGDOTMkj+fp5kqdwEvJimJOhgyuJyVwtrH5DWsMH8GJMBkTkprTm5Hc
        Y7fPgXsqJWSdCjiohL+ZHXLj;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.2:ECDHE_ECDSA_AES_256_GCM_SHA384:256)
        (Exim)
        id 1j6IAW-0000W9-Pg; Mon, 24 Feb 2020 18:09:24 +0000
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@samba.org>
To:     Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: Re: [PATCH v1 13/13] cifs: introduce the CifsInvalidCredentials
 session state
In-Reply-To: <20200224131510.20608-14-metze@samba.org>
References: <20200224131510.20608-1-metze@samba.org>
 <20200224131510.20608-14-metze@samba.org>
Date:   Mon, 24 Feb 2020 19:09:22 +0100
Message-ID: <87sgiz5031.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Stefan Metzmacher <metze@samba.org> writes:
> A future addition would be an upcall to get new credentials from
> userspace, or a way to use a magic file per session under /proc/fs/cifs/
> to provide new credentials.

I've looked into this recently. cifscreds from cifs-utils can already
store/update credentials in keyrings.

I believe this is only used in multiuser mode (-o multiuser).  In that
mode, when a process does a syscall, cifs.ko will try to use a cifs_ses
matching the uid of that process, potentially opening a new one.

To open a new session for that user, cifs.ko looks at the current
process session keyring for that uid credentials. Take a look at
cifs_set_cifscreds(), it's the function that sets the credentials in the
volume about to be connected to.

* the key is of type "logon",
* description is "cifs:<mode>:<host>" where mode determines what host is
  ('a' for an ip address, 'd' for a domain).
* value is "<user>:<password>"

[ side-note on that keyring: it is the process session keyring. So you
need to make sure the keyring is created when the user first logs in the
system (i.e. via pam), otherwise cifscreds will create it, and since it
is the only user, will destroy it when cifscreds exits (refcount reaches
zero).  I don't know why it was decided to use the session keyring, I
feel like we should make this keyring "global" instead of per session,
it would be easier to setup and update but I don't know the security
implications. (If anyone knows please share) ]

In any case, I think we should try to update
cifs_ses->{user_name,password} before re-opening a session by looking at
this keyring.

Cheers,
--=20
Aur=C3=A9lien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg, DE
GF: Felix Imend=C3=B6rffer, Mary Higgins, Sri Rasiah HRB 247165 (AG M=C3=BC=
nchen)
