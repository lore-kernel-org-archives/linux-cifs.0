Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A61258EFB
	for <linux-cifs@vger.kernel.org>; Thu,  6 Nov 2025 15:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762444327; cv=none; b=YLPMpexSG8i3+uwsR0roFOkOiKvs2k5FwjuHIhNKP06hUCEtvussbnrdup4t0kYjXmqfEXjab3qnyG4EWsysa15YpZssIg+egSspxwdl+/GXYis3QwX0/pqUOKtnJOhWf8bSLe00qL/OFLN23cDKb1HPF5q5TM7ufdtqgbPoqb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762444327; c=relaxed/simple;
	bh=81qwQOE45Yf+gCsqP9Hrilr48RTwAW+p9n+kSvU2isY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kkNK/wCVI6D6VTsmqgh7B5k9WI9FtEzdFTMkNUt+h+b98oSZARYvqlEhkT/mFbEXI6lVUw8GoTRe+UzRX55wTacH02ZSmFcbMtmS56o6mVtRgMarPJBrdPtKyOVqZGDBbeQdMGoYroVZd1aXzNbrfNAODHHaxbWbp3zAv/QQ1kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SD4IYEt0; arc=none smtp.client-ip=209.85.128.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SD4IYEt0"
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-71d71bcac45so10495457b3.0
        for <linux-cifs@vger.kernel.org>; Thu, 06 Nov 2025 07:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762444323; x=1763049123; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LcBB+747MUpevaj2u+V3sTU8tEdPzEglr2bpJT2/Sf8=;
        b=SD4IYEt0WHW7ZTXpQxQi+no8C/8dT27wt4AUDM5m2shRykIFgifEnKAhEvSZonvk5O
         JMT4Ozuig1kIYrGQOlY+USq16i8IwPK1p7wcyTTDe1J/JGLjOQer3ocE/ARP2ciIJPvK
         5q/dCbZEa0eLe3hpNQ1Fk3oBR2xpiRyNEXq5QTEYitKqhdprHFE6C7q5Y6rGMr5TITXu
         UzQtJsB0Pxx18Cg76Wg7Iv87QBsdZTpEjpZF/Maqr2CwSyg1PpF51FaAoAZcEMY4h+1w
         vLhqkThk5mRBiKJBtiVCYkeO3mw3zVdUFvRcEB8e+YGi7B68gr4FrtREUS+2CMzmzkx+
         teaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762444323; x=1763049123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LcBB+747MUpevaj2u+V3sTU8tEdPzEglr2bpJT2/Sf8=;
        b=rsDsY0EgerkYX0XT+eCb+nUnpaKRjy2S/IDg/RyWEP/7fheXkJw04kEsUDUISuEUPI
         HfWQAsOOgCXdxOJN7K1DWkyLWrvIJa7uL3e1k9rDlWa3Z4doYBlAMRpLFZPaFrS4LEN+
         Kn4uiofbxLqXXLnkrk1dYIf+ow8w6JlwELmK41UEQtNGMkDmQp9eY3UUUm8r37fg/Pn7
         T6LBnazWdebTtUCZ9FTCkSn6n5Cn2kXiHC6twKOhcieMIIezsl8WTZQi6J00YCr1NBXr
         v+5y2DpnZ5Aa61bNFuZ/WD8mVf/WBos/k1r0mS5WLBL8T3R+Jr6eSSO55NR3faWFkXT2
         KLog==
X-Forwarded-Encrypted: i=1; AJvYcCU3vD/Fd5h189m6KyGO6ywlbvTeHLOD/9Dm+pYKVrdqahMfx28ieMOohAwegQrGwv49769ZMAbzBU0U@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb2CTFICZ6ZPH/auEVhVQtkr4QoWOt3NDzLbiNw/LIxsYfCrOP
	c99mK3ms68LiImcHDvk8UX9TaIqcX3LkFAuQLkdFzmqCmq8cD/qUnQjXnRWYdc+tcfUR68e39mf
	eznPm8vUxzSC8ifXcegQQ3kqY6anIFEQ=
X-Gm-Gg: ASbGncu2ZYOa1MXbGOZl+bvA3TPPCfUwHNJ8dKWFiq5y0cjdFmaw6IOojvoY73khDKV
	h7nPFZ2+fwz0Og7Rhm5o9km2mC5mLZZLG6Or11mbIu+TRGpkoRtqw7GF9lI/2KS9ephfUHZrEV1
	mAVO9zFX3Ws7IXKwo25l54kDJY2lq25yrbaAFhtqy5gL1ZTqOaSmymDbloIcaqvZBJk+aSd0OuU
	6jy3hQzA7GKedDPH2iJCkBk3kHJTBV5cMUeM18AXJCfv6/Om7/ICFwJU018waw=
X-Google-Smtp-Source: AGHT+IGxU1rbK0w8mhv/ESYDnOZcb7FgkybmDWiyp7thf3eB2s0eHmhuZpcTTEwYhD9KLiDvEA1gB6kTcjN0TV9OGgI=
X-Received: by 2002:a05:690e:1614:b0:63f:9db5:3713 with SMTP id
 956f58d0204a3-63fd359e672mr4843320d50.55.1762444322919; Thu, 06 Nov 2025
 07:52:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <YT1PR01MB9451424C6870795133FB7C96B3A72@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <36fb31bf2c854cdc930a3415f5551dcd@izw-berlin.de> <CAH2r5mtNtyqZBpT8hL2xvZ8QYWAymrPR-5LmpZbeTHr_1ATPWg@mail.gmail.com>
 <uildcjpqxzc5nckupgdeeifkrqwrau2qxuc2df2uxuyys3i2k2@iz2bmi6yojyu>
 <YT1PR01MB945191C652AEE173CEADBA3EB3A12@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <aaloi77h2f5xolhrnegxsxntqp2jopwisunmjfp45idsoockpy@cy5agf2oqjop>
 <YT1PR01MB9451A0F623371F50E77CC1C9B3AD2@YT1PR01MB9451.CANPRD01.PROD.OUTLOOK.COM>
 <CAGypqWw0bnE7_=49HSxgExouk4s5PVFQ6gVH50wrE8_=4b5vAg@mail.gmail.com> <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7>
In-Reply-To: <4yor4cklgnkgiv4na2hl6w2zasp4w4i6zubgtnhedzqc6qreat@l3nyd3zc52k7>
From: Bharath SM <bharathsm.hsk@gmail.com>
Date: Thu, 6 Nov 2025 07:51:51 -0800
X-Gm-Features: AWmQ_bnA19L6IdEVqgUA-48XGBBZVAv8U1yRBuA8-H-eaFlCW4aoT6iPwZTwxK4
Message-ID: <CAGypqWzwT4AbfVPsA0RsvH=sXUsk+oEHAQShSdnYk-bDKHpW=g@mail.gmail.com>
Subject: Re: [[ EXT ]] [BUG REPORT] cifs/smb data corruption when writing,
 x86_64, kernel 6.6.71
To: Enzo Matsumiya <ematsumiya@suse.de>
Cc: Mark A Whiting <whitingm@opentext.com>, henrique.carvalho@suse.com, 
	Steve French <smfrench@gmail.com>, Shyam Prasad <nspmangalore@gmail.com>, 
	David Howells <dhowells@redhat.com>, Paulo Alcantara <pc@manguebit.org>, 
	"Heckmann, Ilja" <heckmann@izw-berlin.de>, 
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, yangerkun@huawei.com, 
	yangerkun@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 6, 2025 at 7:20=E2=80=AFAM Enzo Matsumiya <ematsumiya@suse.de> =
wrote:
>
> Hi Bharath,
>
> That patch is not actually mine, I just posted a rebased version.
>
> The original patch by Yang Erkun (Cc'd) has been resent and Cc stable
> (6.6 to 6.9):
> https://lore.kernel.org/linux-cifs/20250912014150.3057545-1-yangerkun@hua=
wei.com/
> I haven't followed up on its whereabouts though -- you might want to
> ping someone else involved in the process.

This looks to be a different patch for the page leak issue and doesn't
look the same as what you attached here for corruption.
And the page leak patch is already in a stable kernel.


>
>
> On 11/06, Bharath SM wrote:
> >Hi Enzo,
> >
> >We are noticing the similar behavior with the 6.6 kernel, can you
> >please submit a patch to the 6.6 stable kernel.
> >
> >Hi Steve and David,
> >
> >Can you please review the attached patch from Enzo and share your commen=
ts.
> >
> >Thanks,
> >Bharath
> >
> >On Mon, Mar 31, 2025 at 12:48=E2=80=AFPM Mark A Whiting <whitingm@opente=
xt.com> wrote:
> >>
> >> Hi Enzo,
> >>
> >> I now have a couple days of testing done. The good news is that we've =
run several terabytes of data through cifs and haven't had a single failure=
 with the patch you provided.
> >>
> >> Now for the not as good news. Even though we aren't seeing any data co=
rruption or failures. We are regularly and very frequently hitting a WARN_O=
N in cifs_extend_writeback() on line 2866.
> >>
> >> >for (i =3D 0; i < folio_batch_count(&batch); i++) {
> >> >       folio =3D batch.folios[i];
> >> >       /* The folio should be locked, dirty and not undergoing
> >> >        * writeback from the loop above.
> >> >        */
> >> >       if (!folio_clear_dirty_for_io(folio))
> >> >               WARN_ON(1);
> >>
> >> Reading through the folio_clear_dirty_for_io() function it appears the=
 only way this would happen is if the folio is clean, i.e., the dirty flag =
is not set.
> >>
> >> >if (folio_test_writeback(folio)) {
> >> >       /*
> >> >        * For data-integrity syscalls (fsync(), msync()) we must wait=
 for
> >> >        * the I/O to complete on the page.
> >> >        * For other cases (!sync), we can just skip this page, even i=
f
> >> >        * it's dirty.
> >> >        */
> >> >       if (!sync) {
> >> >               stop =3D false;
> >> >               goto unlock_next;
> >> >       } else {
> >> >               folio_wait_writeback(folio);
> >>
> >> Reading through your patch, unless I missed something, this folio_wait=
_writeback() call is the only addition that could affect the dirty flag ind=
irectly. I'm assuming that when the current writeback is complete it would =
mark the folio clean. Then when it's added to the current batch and later c=
hecked, it's clean instead of the dirty flag being set as expected.
> >>
> >> Since you wrote the patch, is this expected behavior and that WARN_ON =
isn't valid anymore? Or is this something I should be worried about?
>
> @Mark sorry I totally missed that reply of yours.
>
> I could never observe that WARN_ON() being triggered.
> That code path was mid-migration throughout the affected versions, so I
> think it depends a lot of which version you used with the patch.
>
> I Cc'd Yang (original patch author), maybe he knows more about that.
>
>
> Cheers,
>
> Enzo
