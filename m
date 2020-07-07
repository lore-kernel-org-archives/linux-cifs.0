Return-Path: <SRS0=GU4v=AS=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BECC433E0
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 13:05:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 926C920771
	for <linux-cifs@archiver.kernel.org>; Tue,  7 Jul 2020 13:05:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SjortJSC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727886AbgGGNFN (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 7 Jul 2020 09:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgGGNFM (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 7 Jul 2020 09:05:12 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86E06C061755;
        Tue,  7 Jul 2020 06:05:12 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id f12so20251053eja.9;
        Tue, 07 Jul 2020 06:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8ihsa4wisx2/fQzjIgKSUs8291Cnzw+hSUCayAqvQ7U=;
        b=SjortJSCbVliT7MjOyUFq8Kwh8gc2s6+cficB+Nz2+NaQASghiJZOfLWNbg5cFqJKS
         T3nLCS5SEowN4ldwW39C6XxzyqfZTGWAzQNu1mhxoO2fMmNXjewaM/V++7G50YceV3oH
         J1MtT74Kk33CNCZo06VtjELiUawmLtaCJkzISAhjO3ZHSVXZD2jqmf5VDkRAQNR4AjsE
         fA+SfQLPnUL2o9AUJtgO9tJGqGFgN/IPV5GOs0ZgMbzxiyDWxgskXcm5RUxJ1UeFP2A0
         qsYUD7sgnLmFs28XzN/yTfUwDXwsdqMOVHWbclQTa4C5myy8YsB2VIUFiUPePuJ7W084
         3Ppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8ihsa4wisx2/fQzjIgKSUs8291Cnzw+hSUCayAqvQ7U=;
        b=ipkU6BietZMhG4LuGSBnnQdOq5KaLkzKDgDulkrfJH+xfYZfCwd4a7EzrdKxKWOajr
         r+id1j8rCpoOKXKrX69NN3tu2Yp5tzetuE4doOe7Y50/OK7lmN7oT9CGf5E4gyxP1cPF
         HEJIOGGLLsfQB/1QqVvJGe81CES4+6JBLiuMYw2dUNJ5/p894hA5sN+5AKG+0NGjutUo
         7cd5SThCjH2rlsAsaMNgGOR19jgRsNkqJLWQpIoOcaRa0vE+NUAf3Ysw2mqcxjI8gFLg
         +64bmNJV7S0ceUQxn3oai1MJHJENzqkbTSB/P3WkI8/HpGyOOl10KcrTaKNmWdD1CkrW
         D5DQ==
X-Gm-Message-State: AOAM531g3UVSWf8VBkQPU8DHYos/H0qAZ134rneyJ6QfydQad2aXm5Fl
        4G5zyPz8X0JWuIv5GAUqjRA=
X-Google-Smtp-Source: ABdhPJw/F2SGydTnxifIHLKT+7x7fn3znm1Cg9vmHJAXBIDmBt2umwoM4QNOQtFksU4sks5AeJZlUA==
X-Received: by 2002:a17:906:4356:: with SMTP id z22mr31300485ejm.414.1594127111220;
        Tue, 07 Jul 2020 06:05:11 -0700 (PDT)
Received: from ltop.local ([2a02:a03f:b7f9:7600:e5b5:b6c3:ee51:c994])
        by smtp.gmail.com with ESMTPSA id n9sm356792ejk.21.2020.07.07.06.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:05:10 -0700 (PDT)
Date:   Tue, 7 Jul 2020 15:05:09 +0200
From:   Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
To:     =?utf-8?B?QXVyw6lsaWVu?= Aptel <aaptel@suse.com>
Cc:     Paul Aurich <paul@darkrain42.org>, linux-cifs@vger.kernel.org,
        linux-sparse@vger.kernel.org, sfrench@samba.org,
        Ronnie Sahlberg <lsahlber@redhat.com>
Subject: Re: lock checking issues (was: Re: [PATCH v3] cifs: Fix leak when
 handling lease break for cached root fid)
Message-ID: <20200707130509.om7rgkm75baszqye@ltop.local>
References: <20200702164411.108672-1-paul@darkrain42.org>
 <878sfx6o64.fsf@suse.com>
 <20200706192642.GA110607@haley.home.arpa>
 <87tuyj6c3u.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87tuyj6c3u.fsf@suse.com>
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Jul 07, 2020 at 09:03:17AM +0200, Aurélien Aptel wrote:
> 
> CC-ing linux-sparse
> 
> We are seeing a lock context imbalance warning which we can't get rid
> of after applying a patch moving locking around across function boundaries.
> 
> For context see:
> https://lore.kernel.org/linux-cifs/20200702164411.108672-1-paul@darkrain42.org/T/#u
> 
> Paul Aurich <paul@darkrain42.org> writes:
> > On 2020-07-06 10:30:27 +0200, Aurélien Aptel wrote:
> >>Paul Aurich <paul@darkrain42.org> writes:
> >>> Changes since v2:
> >>>    - address sparse lock warnings by inlining smb2_tcon_has_lease and
> >>>      hardcoding some return values (seems to help sparse's analysis)
> >>
> >>Ah, I think the issue is not the inlining but rather you need to
> >>instruct sparse that smb2_tcon_hash_lease is expected to release the
> >>lock.
> >>
> >>https://www.kernel.org/doc/html/v4.12/dev-tools/sparse.html#using-sparse-for-lock-checking
> >>
> >>Probably with __releases somewhere in the func prototype.

Could be both:
 * if it's inlined, then its users can deduce its locking signature.
 * if it's not inlined, then the locking signature must be given in
   in the prototype (with __acquires(), __releases() or __must_hold()).

> > I tried various iterations of that without finding one that seems to work. 
> > I suspect it's because the unlocking is _conditional_.
> 
> Hm could be it...

It's possible indeed. In general, conditional locking can't be statically
checked. The problem is undecidable and sparse doesn't try to check.
What sparse is checking is that all paths are 'balanced.

So, with code like:
	if (cond)
		lock();
	do_stuff;
	if (cond)
		unlock();

sparse will probably have problems. It's possible that everything id fine
if the condition is known and the remaining of the code is simple enough
but most often you will have a warning about context imbalance.

The way to avoid any problem is to write instead:

	if (cond) {
		lock();
		do_stuff;
		unlock();
	} else {
		do_stuff;
	}

which is not too bad when do_stuff can be put in a separate function,
inlined or not.

> > w/o the inline and with __releases(&cifs_tcp_ses_lock):
> >
> > fs/cifs/smb2misc.c:508:1: warning: context imbalance in 'smb2_tcon_has_lease' 
> > - different lock contexts for basic block
> > fs/cifs/smb2misc.c:612:25: warning: context imbalance in 
> > 'smb2_is_valid_lease_break'- different lock contexts for basic block
> >
> >
> > Digging further, I found __acquire and __release (not plural), which can be 
> > used in individual blocks. The following seems to silence the sparse warnings 
> > - does this seem valid?
> 
> To be honnest I'm not sure, these seem counterproductive. If you are
> indicating you are acquiring X but lock Y the next line it feels like we
> are fighting the tool instead of letting it help us.

__acquire() & __release() should only be used by locking primitives.

> > +	__acquire(cifs_tcp_ses_lock);
> 
> Should it have a "&" here?

In truth, it won't matter because the 'context' argument is only used
as a kind of documentation. The general use is to use it like the
argument to one of the lock function: as a pointer.


If needed, I can look more concretely at the problems here later
this evening but it will help a lot if would have:
* a tree with the code in question
* the config that is used (but I suspect it doesn't matter much here).

Cheers,
-- Luc
