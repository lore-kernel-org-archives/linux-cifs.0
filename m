Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF2F14A85
	for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 08:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732610242; cv=none; b=K/wqIY58fi26S0vAmgEQZwUWHuoyp4Cl+TIythAMJFvxhPfHaEZ9kibSXUC/E8Yb/uUDJnV0PCAS/VhIQ38qSXPeYgo8vgc2j3riHtaFW14l9DYt3dz3ew0Ut7fHg7D6yfgUnpyCiEj/p8wm2ATY06TGoJR8QtbU7EBbpG/5e3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732610242; c=relaxed/simple;
	bh=QKc45+S8ys9Iu/H5PdBQCFaYBYAOanQzZFv2h3MFDHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G/p0wU15qJQXPOm+AT9sflzDUyhQs/es+ablBTCFnXQ6CEU20Xlw4ek9pyKN4K1LMKWWsmAIBk0xh/TSO6o1qRRll5CGRqjui021e9TVEq6Kr8nTMppBWfZ1DfOuqXF8wfeQ93ZXUKMmdJCw9i9Vg4ErIzCKcSQJGC+/yYR/tGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ZVdXnsZb; arc=none smtp.client-ip=209.85.167.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ZVdXnsZb"
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-53de035ea13so2147765e87.0
        for <linux-cifs@vger.kernel.org>; Tue, 26 Nov 2024 00:37:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1732610238; x=1733215038; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=22jR0XBhI2E9c5FkIFrqUGsHT0bkN1pI5hofWrMAXOw=;
        b=ZVdXnsZbGFab+me24bYw0WtPSMXLKenLhTYjv1felzbcpZzwmOfTsE6TX6+TMor+wX
         BB3JGHWejS2o6Q3FVn29woscHFU/7GErvyR9o1NhclL+xc0RlZPTdvlRQTxfNCO/wZyH
         PUs4OFNfCzmSHLkxJ13l3w1HdLHtug6/zwIVlPxVModMbkaNrGX6irh1oX3RsDMiVvyf
         I6u90t+vRNQE5rp3DmzQktEMKiKLptllP+OUY2Ao+KIIOsd67P7biZQCxtPREjeAkHUr
         IA1PW4TwhYAjATnZ3y1SGETh1WMTxTZR/iu2gFf0onX2rEQ+YB9FtPSukEW8fyMfhMPy
         QCFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732610238; x=1733215038;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=22jR0XBhI2E9c5FkIFrqUGsHT0bkN1pI5hofWrMAXOw=;
        b=Kgs0kFxpav7+pMtIszvW7FlyhQdLSf5ZbQgxpw0DdAaALzQBr7S0oYo8luvuLjlbd9
         oRA1Z4zogZcG6PPYoBdBqUmz949WatxiQNM9ON+9B9JdtyQyk3YOE3jaVgdfM96IX8sT
         lrLCYs0L8UpmvZqA5ZVVeoOfapt835HP1bq4Y052yqP6xftELYK/mtXJgrh8qHjs/u9d
         8tMQiE7siYP8Fl+Lv8WdFUaU1PrDIwItCDQ+00I+JsiOZQ4V+1ImVKz8U/hAWPcOxVZ+
         HmpnlN5ENSZ/KNflQGbD9MnDBJbyZGgbZeIcYsr60Z6x+qTl8H5heeR4LBi8hIYZV4lQ
         L+fg==
X-Forwarded-Encrypted: i=1; AJvYcCXoy6Xue4WKqd7MWu4TtinXMkcRn358y2T6baxg4do0uEWbHtskZUThD1pQ541Ztwa+y8K6HZeIkfPy@vger.kernel.org
X-Gm-Message-State: AOJu0YwOhOtqqOGbskQG8UutGiN6EVMFSZVx5t3tK54YknIate2HurKM
	xGTyvYqeIx5R8yw3eJy2z5SYG2MhcTBNxB5kuInADPMDMgXDJ+UglBRKGh3DWWJaGdki0UTvaUV
	3n+BljK4nIJ6Xu+kkYa80UgKCrFLat2OWXSj6ZA==
X-Gm-Gg: ASbGncuq5lbnb7OhYk6kEH98cba/xncdqpIktWu1+hMNtvppzbETXqkvtge2JKByPZU
	eQHphGu0NqlXQOPC6sC99zpaygoMs/oDD7qWCsO7Mw+Mn4mJoDhJ6uMlFy+5WEIre
X-Google-Smtp-Source: AGHT+IF6n0DQov5U2UgZPQN0AL+TGZYLiETID7ErOo+8LH+/8Nlb2B7zs4RPo2VVCUZpnsrEpaPp5Y+H+OzaKCiK/9Q=
X-Received: by 2002:a05:6512:b22:b0:53d:e50a:7031 with SMTP id
 2adb3069b0e04-53de50a7229mr3799409e87.3.1732610237879; Tue, 26 Nov 2024
 00:37:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107164029.322205-1-marco.crivellari@suse.com>
 <ubfww55cebjyaur47o2s34qkpcqdmck4zvdx7q47e2tk4bvkwe@xvefnpedopnf> <CAH2r5mvkxTUbYYRtqVD9_byuXfiST+Gg1HOXpuz-rgVK8eY=Eg@mail.gmail.com>
In-Reply-To: <CAH2r5mvkxTUbYYRtqVD9_byuXfiST+Gg1HOXpuz-rgVK8eY=Eg@mail.gmail.com>
From: Marco Crivellari <marco.crivellari@suse.com>
Date: Tue, 26 Nov 2024 09:37:07 +0100
Message-ID: <CAAofZF75rLSv+uehm3qdjdNL8Xv8X4KA7+Zhym34+VmOgxmkHA@mail.gmail.com>
Subject: Re: [PATCH] Update misleading comment in cifs_chan_update_iface
To: Steve French <smfrench@gmail.com>
Cc: Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org, pc@manguebit.com, 
	ronniesahlberg@gmail.com, sprasad@microsoft.com, tom@talpey.com, 
	bharathsm@microsoft.com, henrique.carvalho@suse.com, ematsumiya@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thank you,

Marco

On Mon, Nov 25, 2024 at 9:07=E2=80=AFPM Steve French <smfrench@gmail.com> w=
rote:
>
> added to cifs-2.6.git for-next (and added the RB to the other three a wel=
l)
>
> On Mon, Nov 25, 2024 at 9:58=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.d=
e> wrote:
> >
> > On 11/07, Marco Crivellari wrote:
> > >Since commit 8da33fd11c05 ("cifs: avoid deadlocks while updating iface=
")
> > >cifs_chan_update_iface now takes the chan_lock itself, so update the
> > >comment accordingly.
> > >
> > >Signed-off-by: Marco Crivellari <marco.crivellari@suse.com>
> > >---
> > > fs/smb/client/sess.c | 5 +----
> > > 1 file changed, 1 insertion(+), 4 deletions(-)
> > >
> > >diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
> > >index 3216f786908f..51614a36a100 100644
> > >--- a/fs/smb/client/sess.c
> > >+++ b/fs/smb/client/sess.c
> > >@@ -359,10 +359,7 @@ cifs_disable_secondary_channels(struct cifs_ses *=
ses)
> > >       spin_unlock(&ses->chan_lock);
> > > }
> > >
> > >-/*
> > >- * update the iface for the channel if necessary.
> > >- * Must be called with chan_lock held.
> > >- */
> > >+/* update the iface for the channel if necessary. */
> > > void
> > > cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *=
server)
> > > {
> > >--
> >
> > Reviewed-by: Enzo Matsumiya <ematsumiya@suse.de>
> >
> >
> > Cheers
>
>
>
> --
> Thanks,
>
> Steve
