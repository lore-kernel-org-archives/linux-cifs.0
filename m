Return-Path: <SRS0=KUb6=YP=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92695CA9EA0
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 18:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62A962184C
	for <linux-cifs@archiver.kernel.org>; Tue, 22 Oct 2019 18:40:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731436AbfJVSkQ convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 22 Oct 2019 14:40:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54356 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729666AbfJVSkP (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 22 Oct 2019 14:40:15 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 01E8D859FF
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 18:40:15 +0000 (UTC)
Received: by mail-qk1-f197.google.com with SMTP id h4so17539035qkd.18
        for <linux-cifs@vger.kernel.org>; Tue, 22 Oct 2019 11:40:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=T968YqkoqVPwsfYrtiZUniacudH+qXATPaqw260KTuo=;
        b=MwaFx86ASTu3muw9h2waJwSRE7MeSHlW8o3J0V4nj73K0c70awXyNSX+ik4cQbjfe/
         KrphLU8IYFiOEKQm4OM5jV9ykT88B18uD8ez76MKcL/sfKjm+No8V5lCRba2m91zzhCr
         sMQjj2Ky869zGjboS68OaOT3EMxQ6FG3to8QAU9cENUuiG4CUYLAd+6VSpTWyJCxmcFb
         qLrht0wQKp9uFm++bY5jL+P6ICkDl0X9IQ3cQWN9Dhn16G8vUugdcCG/k8uawlFqTSQt
         5GIxjw3SRteMJVsrFIOI/wKnb178mXz4gts8UqbVE9negPcgIhEPPh73oYc8zWSaD9oj
         9PUw==
X-Gm-Message-State: APjAAAVAa1SUD4zJ3GoRjG69RTAmjS5L8h364as3L2n0q74gyYffnH94
        ik6TFQZTqo7SOuzcO2Fu5NEKmkujsx2M4bUjL5zUP2Lc9pEtwHUpXkAHbyFl5kuEq+FuKIrY1Mo
        aO+Ho18WIX6BM14IsFwK7EWSNml77amCn+RK+YA==
X-Received: by 2002:ae9:e90e:: with SMTP id x14mr2492505qkf.229.1571769614096;
        Tue, 22 Oct 2019 11:40:14 -0700 (PDT)
X-Google-Smtp-Source: APXvYqw9MZWDhj2lujQxe/Bi0gMMg7QVDcbkcNZ+Fc33+Ul38pvIDmfVF7eW30T0OiGszQ0JkNYmPsAu/WacKzq9hl8=
X-Received: by 2002:ae9:e90e:: with SMTP id x14mr2492470qkf.229.1571769613780;
 Tue, 22 Oct 2019 11:40:13 -0700 (PDT)
MIME-Version: 1.0
References: <CALF+zOkugWpn6aCApqj8dF+AovgbQ8zgC-Hf8_0uvwqwHYTPiw@mail.gmail.com>
 <CALF+zO=8ZJkqR951NsxOf4hDDyUZzMfyiEN-j8DgA+i+FzcfGw@mail.gmail.com>
 <DM5PR21MB018515AFDDDE766D318BC489B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOmz5LFkzHrLpLGWcfwkOD7s-VhVz39pFgMNAFRT9_-KYg@mail.gmail.com>
 <58429039.7213410.1571348691819.JavaMail.zimbra@redhat.com>
 <DM5PR21MB0185FD6A138A5682BB9DE310B66D0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <106934753.7215598.1571352823170.JavaMail.zimbra@redhat.com>
 <CALF+zOn-J9KyDDTL6dJ23RbQ9Gh+V3ti+4-O051zqOur6Fv-PA@mail.gmail.com>
 <1884745525.7250940.1571390858862.JavaMail.zimbra@redhat.com>
 <CALF+zOkmFMtxsnrUR-anXOdMzUFxtAWG+VYLAQuq3DJuH=eDMw@mail.gmail.com>
 <DM5PR21MB0185857761946DBE12AEB3ADB66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zO=heBJSLW4ELPAwKegL3rJQiSebCLAh=4syEtPYoaevgA@mail.gmail.com>
 <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com>
 <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
 <CALF+zOkTwetUsL0he3nqjvTO4QPJm6bgk2CnEbcjihW2h4CZNw@mail.gmail.com> <CAKywueRjL=Ob1jKFyV+ApxZPXWM91aQRD8UJxe0h6kLi-iDmpA@mail.gmail.com>
In-Reply-To: <CAKywueRjL=Ob1jKFyV+ApxZPXWM91aQRD8UJxe0h6kLi-iDmpA@mail.gmail.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Tue, 22 Oct 2019 14:39:37 -0400
Message-ID: <CALF+zOkji2d7=WJcSmPKhFgm53aCb3Qxy4t1O4=W+4fOR5Qa7A@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovsky <piastryyy@gmail.com>
Cc:     Pavel Shilovskiy <pshilov@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Mon, Oct 21, 2019 at 5:55 PM Pavel Shilovsky <piastryyy@gmail.com> wrote:
>
> сб, 19 окт. 2019 г. в 04:10, David Wysochanski <dwysocha@redhat.com>:
> > Right but look at it this way.  If we conditionally set the state,
> > then what is preventing a duplicate list_del_init call?  Let's say we
> > get into the special case that you're not sure it could happen
> > (mid_entry->mid_state == MID_REQUEST_SUBMITTED is false), and so the
> > mid_state does not get set to MID_RETRY_NEEDED inside cifs_reconnect
> > but yet the mid gets added to retry_list.  In that case both the
> > cifs_reconnect code path will call list_del_init as well as the other
> > code paths which we're adding the conditional tests and that will
> > cause a blowup again because cifs_reconnect retry_list loop will end
> > up in a singleton list and exhaust the refcount, leading to the same
> > crash.  This is exactly why the refcount only patch crashed again -
> > it's erroneous to think it's ok to modify mid_entry->qhead without a)
> > taking globalMid_Lock and b) checking mid_state is what you think it
> > should be.  But if you're really concerned about that 'if' condition
> > and want to leave it, and you want a stable patch, then the extra flag
> > seems like the way to go.  But that has the downside that it's only
> > being done for stable, so a later patch will likely remove it
> > (presumably).  I am not sure what such policy is or if that is even
> > acceptable or allowed.
>
> This is acceptable and it is a good practice to fix the existing issue
> with the smallest possible patch and then enhance the code/fix for the
> current master branch if needed. This simplify backporting a lot.
>
> Actually looking at the code:
>
> cifsglob.h:
>
> 1692 #define   MID_DELETED            2 /* Mid has been dequeued/deleted */
>
>                     ^^^
> Isn't "deqeueued" what we need? It seems so because it serves the same
> purpose: to indicate that a request has been deleted from the pending
> queue. So, I think we need to just make use of this existing flag and
> mark the mid with MID_DELETED every time we remove the mid from the
> pending list. Also assume moving mids from the pending lists to the
> local lists in cleanup_demultiplex_info and cifs_reconnect as a
> deletion too because those lists are not exposed globally and mids are
> removed from those lists before the functions exit.
>
> I made a patch which is using MID_DELETED logic and merging
> DeleteMidQEntry and cifs_mid_q_entry_release into one function to
> avoid possible use-after free of mid->resp_buf.
>
> David, could you please test the attached patch in your environment? I
> only did sanity testing of it.
>
I ran 5.4-rc4 plus this patch with the reproducer, and it ran fine for
over 6 hours.
I verified 5.4-rc4 would still crash too - at first I wasn't sure
since it took about 30 mins to crash, but it definitely crashes too
(not surprising).

Your patch seems reasonable to me and is in the spirit of the existing
code and the flag idea that Ronnie had.

To be honest when I look at the other flag (unrelated to this problem)
I am also not sure if it should be a state or a flag, but you probably
know the history on mid_state vs flag better than me.  For purposes of
this bug, I think your patch is fine and if you're wanting a stable
patch and this looks better, FWIW this is fine with me.  I think
probably as your comments earlier there is probably more refactoring
or work that can be done in this area, but is beyond the scope of a
stable patch.

Thanks!
