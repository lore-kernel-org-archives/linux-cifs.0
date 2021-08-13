Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B33BC4338F
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38B27610EA
	for <linux-cifs@archiver.kernel.org>; Fri, 13 Aug 2021 20:19:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbhHMUUZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 13 Aug 2021 16:20:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233743AbhHMUUZ (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 13 Aug 2021 16:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0B9AA610CC;
        Fri, 13 Aug 2021 20:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628885998;
        bh=xcRKD6cavQDiPz0SFq1rvbp5fqwrvQU7hDAgltipPwA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ml/q/3lXKx7gElVGI2Ljug3HcTmzV+RE0Jhl5ZotLDdseeFGB8RpHh5vepQHXuwXM
         OF9DT8GUz8L+dJgCzWf9Naq+qmxc/IVklF60cR8GFCorGC4b73ah1zHYE1KQGF0g6p
         jk4T6aV04j9Sxy8AUWZDpq5MfVDKIIEe8oLpkXwMJAD8qSheHkHibyQff6KVKDs1KA
         gpRldNf9AGbzSgjEncjqqsOzuCICYp9mFiPwzyXhbP1La0+sRC+GyCrgKh2NKISn1E
         wCTeZ1OFxYBxAsf6ZEYQuBph7wjFOFf160nGqC47CsRqLhDGf6AmS9bhgK+1Z03dbr
         k53htSs5eL6lg==
Date:   Fri, 13 Aug 2021 13:19:56 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <sfrench@samba.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        linux-crypto@vger.kernel.org
Subject: Re: Building cifs.ko without any support for insecure crypto?
Message-ID: <YRbT7IbSCXo4Dl0u@sol.localdomain>
References: <YRXlwDBfQql36wJx@sol.localdomain>
 <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN05THSm5fEcnLKxcsidKPRUC6PVLCkWMBZUW05KNm4uMJNHWw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Aug 13, 2021 at 02:46:21PM +1000, ronnie sahlberg wrote:
> On Fri, Aug 13, 2021 at 1:34 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > Hi!
> >
> > We should be working to eliminate any uses of insecure crypto algorithms (e.g.
> > DES, ARC4, MD4, MD5) from the kernel.  In particular, it should be possible to
> > build a kernel for a modern system without including any such algorithms.
> >
> > Currently, CONFIG_CIFS is problematic because it selects all these algorithms
> > (kconfig options: CONFIG_CRYPTO_LIB_DES, CONFIG_CRYPTO_LIB_ARC4,
> > CONFIG_CRYPTO_MD4, CONFIG_CRYPTO_MD5).
> >
> > It looks like these algorithms might only be used by SMB2.0 and earlier, and the
> > more modern SMB versions don't use them.  Is that the case?  It mostly looks
> > like that, but there's one case I'm not sure about -- there's a call chain which
> > appears to use ARC4 and HMAC-MD5 even with the most recent SMB version:
> >
> >     smb311_operations.sess_setup()
> >       SMB2_sess_setup()
> >         SMB2_sess_auth_rawntlmssp_authenticate()
> >           build_ntlmssp_auth_blob()
> >             setup_ntlmv2_rsp()
> 
> md4 and md5 are used with the NTLMSSP authentication for all dialects,
> including the latest 3.1.1.

That's unfortunate.  Surely Microsoft knows that md4 has been severely
compromised for over 25 years?  And md5 for 15 years.

> The only other authentication mechanism for SMB is krb5.

Is the long-term plan to have everyone migrate to kerberos?  Currently kerberos
doesn't appear to be the default, so not many people actually use it -- right?

> This means that if we build a kernel without md4/md5 then we can no
> longer use NTLMSSP user/password
> style authentication, only kerberos.
>
> I guess that the use cases where a kernel without these algorithms are
> present are ok with kerberos as the
> only authentication mech.

Well, maybe.  Even without kerberos, would it still be possible to use SMB with
a "guest" user only?

> 
> Afaik arc4 is only used for signing in the smb1 case.
> 
> >
> > Also, there's already an option CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n which
> > disables support for SMB2.0 and earlier.  However, it doesn't actually compile
> > out the code but rather just prevents it from being used.  That means that the
> > DES and ARC4 library interfaces are still depended on at link time, so they
> > can't be omitted.  Have there been any considerations towards making
> > CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n compile out the code for SMB2.0 and earlier?
> 
> I think initially we just wanted to disable its use. If we want to
> compile a kernel completely without arc4/md4/md5 I think we would need
> to:
> 
> 1, Change CONFIG_CIFS_ALLOW_INSECURE_LEGACY=n to compile out the code
> as you suggests.
> This should remove the dependency for arc4. I think this would be a
> good thing to do.
> 
> 2, Have a different CONFIG_... to compile out the use of NTLMSSP
> authentication. This must be a different define
> since md4/md5 are also used for non-legacy dialects.
> And this should remove the dependency of md4/5.
> 
> For the latter, I guess we would need a global, i.e. not
> cifs-specific, config option for this. I assume other users of
> rc4/md4/md5
> would also want this.
> A new CONFIG_INSECURE_CRYPTO=n ?

There is already an option CRYPTO_USER_API_ENABLE_OBSOLETE that could be
renamed and reused if we wanted to expand its scope to all insecure crypto.

Although a one-size-fits all kernel-wide option controlling "insecure" crypto
could be controversial, as there is no consensus whether some crypto algorithms
are secure or not, and different subsystems have different constraints.

- Eric
