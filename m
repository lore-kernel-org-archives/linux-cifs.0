Return-Path: <SRS0=C9ZR=YM=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFC8ECA9EAC
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 11:10:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C84F222BD
	for <linux-cifs@archiver.kernel.org>; Sat, 19 Oct 2019 11:10:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725792AbfJSLKS convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 19 Oct 2019 07:10:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725535AbfJSLKR (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 19 Oct 2019 07:10:17 -0400
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 16174C057E9F
        for <linux-cifs@vger.kernel.org>; Sat, 19 Oct 2019 11:10:17 +0000 (UTC)
Received: by mail-qk1-f199.google.com with SMTP id b143so8345148qkg.9
        for <linux-cifs@vger.kernel.org>; Sat, 19 Oct 2019 04:10:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mJjfcSTnrbt+bKhfd+LllkRMAcAfzSPwfgV72TVZmdM=;
        b=OhTl5YGxav4kyoSLj6lzYp8f/Pkkv2UkjMfMtrUm816g0PlA0aOOsJC/Nagi0nnXZL
         BR9fG3PPBmfRlTmV/jjQzy78NRBuYOGuzNsjLrY9mv/IxAp8FF3wEsYN7SQ+nGj969Po
         Fj58AO3D/02qmPCzsyM/vHmFkq1KqEJ6IbB+oU+9brIjMUt4tGsQyzTmzThfi3KXbaIM
         HJxOdfAHH/J5oPaccs7FumH4rClyqBzUN8/VeY9L7WOuq/rnbJLqxEsTSA66PtpGgLT2
         oqbFpaFswT4SxoPm+Tg7sH9nOOCqZAoPbwAYeaEQWmIF/N9hLfvDijo2OCwG+iA6yYCc
         9fUg==
X-Gm-Message-State: APjAAAWyolKTQkBULy2Dl2F+vnnqSs71hT5DF/ElSyCPlsjXTiKSI2Ql
        l/EsdzeFELjS6h2skPRI4Zs2hkiFdO1cT1oOR/ZvGeGrGMdGQ87PqJU0RvkziX8kiALNRPumCmN
        ePeOVcs84Sw1dTDsuVt7XeDfqBrXO+bskPnExvA==
X-Received: by 2002:ae9:f404:: with SMTP id y4mr13180628qkl.225.1571483416228;
        Sat, 19 Oct 2019 04:10:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxqLsMxfmnpYdFM/aXlKkEg0lAz0LKbu36odddm3Jpm0Q8n8ik7+JgMWDKfmRMJNnKhBjUd8ioHZGuaIWkJA6w=
X-Received: by 2002:ae9:f404:: with SMTP id y4mr13180604qkl.225.1571483415912;
 Sat, 19 Oct 2019 04:10:15 -0700 (PDT)
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
 <CALF+zO=BUC2pCcz=n6hBx7ZPsL8gABLqx_hBQXVC=OOLJ-DDig@mail.gmail.com> <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
In-Reply-To: <DM5PR21MB01851871D57ABCF685712C76B66C0@DM5PR21MB0185.namprd21.prod.outlook.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Sat, 19 Oct 2019 07:09:39 -0400
Message-ID: <CALF+zOkTwetUsL0he3nqjvTO4QPJm6bgk2CnEbcjihW2h4CZNw@mail.gmail.com>
Subject: Re: list_del corruption while iterating retry_list in cifs_reconnect
 still seen on 5.4-rc3
To:     Pavel Shilovskiy <pshilov@microsoft.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>,
        Frank Sorenson <sorenson@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 18, 2019 at 6:45 PM Pavel Shilovskiy <pshilov@microsoft.com> wrote:
>
> On Fri, Oct 18, 2019 at 5:21 PM David Wysochanski <dwysocha@redhat.com> wrote:
> >
> > On Fri, Oct 18, 2019 at 4:59 PM Pavel Shilovskiy <pshilov@microsoft.com> wrote:
> > >
> > > Thanks for the good news that the patch is stable in your workload!
> > >
> > The attached patch I ran on top of 5.4-rc3 for over 5 hrs today on the
> > reboot test - before it would crash after a few minutes tops.
>
> This is great! Thanks for verifying the fix.
>
> > > The extra flag may not be necessary and we may rely on a MID state but we would need to handle two states actually: MID_RETRY_NEEDED and MID_SHUTDOWN - see clean_demultiplex_info() which is doing the same things with mid as cifs_reconnect(). Please add ref counting to both functions since they both can race with system call threads.
> > >
>
> > I agree that loop has the same problem.  I can add that you're ok with the mid_state approach.  I think the only other option is probably a flag like Ronnie
> > suggested.
> > I will have to review the state machine more when I am more alert if you are concerned about possible subtle regressions.
>
> I am ok with both approaches as long as the stable patch is minimal. Thinking about this conditional assignment of the mid retry state: I don't think there is any case in the current code base where the WARN_ON you proposed would fire but I can't be sure about all possible stable kernel that the stable patch is going to be applied.
>

Right but look at it this way.  If we conditionally set the state,
then what is preventing a duplicate list_del_init call?  Let's say we
get into the special case that you're not sure it could happen
(mid_entry->mid_state == MID_REQUEST_SUBMITTED is false), and so the
mid_state does not get set to MID_RETRY_NEEDED inside cifs_reconnect
but yet the mid gets added to retry_list.  In that case both the
cifs_reconnect code path will call list_del_init as well as the other
code paths which we're adding the conditional tests and that will
cause a blowup again because cifs_reconnect retry_list loop will end
up in a singleton list and exhaust the refcount, leading to the same
crash.  This is exactly why the refcount only patch crashed again -
it's erroneous to think it's ok to modify mid_entry->qhead without a)
taking globalMid_Lock and b) checking mid_state is what you think it
should be.  But if you're really concerned about that 'if' condition
and want to leave it, and you want a stable patch, then the extra flag
seems like the way to go.  But that has the downside that it's only
being done for stable, so a later patch will likely remove it
(presumably).  I am not sure what such policy is or if that is even
acceptable or allowed.

> Another more general thought: we have cifs_delete_mid -> DeleteMidQEntry -> _cifs_mid_q_entry_release chain of calls and every function frees its own part of the mid entry. I think we should merge the last two at least. It would allow us to guarantee that holding a reference to the mid means:
>
> 1) the mid itself is valid;
> 2) the mid response buffer is valid;
> 3) the mid is in a list if it is REQUEST_SUBMITTED, RETRY_NEEDED or SHUTDOWN and is not in a list if it is ALLOCATED, RESPONSE_RECEIVED, RESPONSE_MALFORMED or FREE; the release function should remove the mid from the list or warn appropriately depending on a state of the mid.
>
> The mid state and list location are changed only when the GlobalMid_Lock is held. In this case cifs_delete_mid is not needed too because all what it does will be done in the release function. I think this would allow to avoid all the problems discussed in this thread but looks too risky for stable.
>
> --
> Best regards,
> Pavel Shilovsky
