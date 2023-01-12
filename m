Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74822C54EBC
	for <linux-cifs@archiver.kernel.org>; Thu, 12 Jan 2023 13:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbjALNYS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 12 Jan 2023 08:24:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjALNYQ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 12 Jan 2023 08:24:16 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647253AB06
        for <linux-cifs@vger.kernel.org>; Thu, 12 Jan 2023 05:24:15 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 82C203F446;
        Thu, 12 Jan 2023 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673529853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1P5xPlImJQe6a+tUby75iDc51Plfo1n74E+VREAZxNY=;
        b=wJwtHl7KNMCNG5MXUOh/w6v2dWKb9NJ9XI9WRUPeviIa8KU76RMthwhjQV8Tny1BN+kH0n
        onNY/rpNmmoAtir5iA4yKW0jO02t+GCrlXyyUeDuNrjyrYiwbRwvCZnyN6HXjt1/ykrFX0
        N23FGFfgJ9SYu8UjMbo0l5jI/FklECo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673529853;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1P5xPlImJQe6a+tUby75iDc51Plfo1n74E+VREAZxNY=;
        b=TIJJnoaZDQ3tfcrILkohAC0S2W5z+U552D4iOVz3TyACuq4ns/3Gw875m/pTzhOyyaKL+q
        R8sdwOKvzsHSpXDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 62D3F13776;
        Thu, 12 Jan 2023 13:24:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 6N/JFv0JwGPnYwAAMHmgww
        (envelope-from <ddiss@suse.de>); Thu, 12 Jan 2023 13:24:13 +0000
Date:   Thu, 12 Jan 2023 14:25:17 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Volker Lendecke <Volker.Lendecke@sernet.de>
Cc:     linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>
Subject: Re: Fix posix 311 symlink creation mode
Message-ID: <20230112142517.7ea551e7@echidna.fritz.box>
In-Reply-To: <Y76gvH9ADxSgAxSw@sernet.de>
References: <Y76gvH9ADxSgAxSw@sernet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Volker,

On Wed, 11 Jan 2023 12:42:52 +0100, Volker Lendecke wrote:

> If smb311 posix is enabled, we send the intended mode for file
> creation in the posix create context. Instead of using what's there on
> the stack, create the mfsymlink file with 0644.
> 
> Signed-off-by: Volker Lendecke <vl@samba.org>

Good catch. I think this deserves a Fixes tag as per
https://www.kernel.org/doc/html/latest/process/submitting-patches.html#using-reported-by-tested-by-reviewed-by-suggested-by-and-fixes
E.g.
Fixes: ce558b0e17f8a ("smb3: Add posix create context for smb3.11 posix mounts")
Preferably also with "Cc: stable@vger.kernel.org" for applicable
backports.

oparms.mode appears to be uninitialized in cifs_create_mf_symlink()
(#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY) and various other codepaths
but isn't currently used further down the call chain... This looks like
an accident waiting to happen.

Cheers, David
