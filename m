Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E3BC43217
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 18:43:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64BD061371
	for <linux-cifs@archiver.kernel.org>; Tue,  5 Oct 2021 18:43:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbhJESpZ (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 5 Oct 2021 14:45:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229679AbhJESpT (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 5 Oct 2021 14:45:19 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4F4C061755
        for <linux-cifs@vger.kernel.org>; Tue,  5 Oct 2021 11:43:28 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id n8so33412445lfk.6
        for <linux-cifs@vger.kernel.org>; Tue, 05 Oct 2021 11:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a3v8+7mcxakgcu6iqhRh7yX2YanMuoqusRTO03KUrto=;
        b=hS//apZ7g0C9Z8pUha3zUycy8VY0L2vLb4jy/O9/T1tRKdQV0kz/AhgmIFFQgIHEUj
         MOY3D2YR7uS9g3ZKoytDbRZ89ePT57s7h9B6i9vUFRh3/GmepQ/zCVEqWtu4UVQSVXOU
         6c3ZZhElJzWHWkNj4B+fKaq7FBXnj4+rScV3/mwiJuR5bNz7AH+56hrGMFJQfcIFCR4D
         ZRGQweaxuvJ/irmFjK/Bq6euo4T2B2EfMDn49aToaSptXmJysXYPuJailywIdANrM6sn
         t4lccglH/aibhK+8xvci8S/B0yPHTl+zhB1o/MEvrbu0DAfx59GEskFJyJfOptE5Aqnn
         t4Pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a3v8+7mcxakgcu6iqhRh7yX2YanMuoqusRTO03KUrto=;
        b=8G5tO57jkdtYjaUqa0yhm4NLqY5/OEbSYbJrI7e894o//rRRiXZkeSL673EaSmeyKW
         1/5mRLcVjIbSmhokgIDxJBwoW3+kcgN9qlPcXnFwXG9KBUTKtGLnSloSJux2ShIL2gKX
         MfEcvB3OkLnfAn2qCV64fu4bv9glk0l3mjeMUGcZ5jlHiMNP8DljeDc21n3pakMgpikG
         AcMiPyWfmlvXef4gamoYMsHYFEGeUBcDl00cdn9BVkxiV937qcJBu6l397jFczexAQ5K
         OmKivQNbctTFwMQQ+zNL+vPjGYxF9cgxVBBtoCzRr8wLioSeqyIDurzUfwIhBs/b9U/j
         id5w==
X-Gm-Message-State: AOAM532BcMgXB0xgMsU57Z28HBicepJaBnAjSHMTdHfv6Ezq7ap2EYHq
        zaRVzbQeAwVsp4npke/fhUEB6Uea+SD22fBKW10T/Fcq
X-Google-Smtp-Source: ABdhPJxlcJsZKVx279QuyZQKDQt6fXpas3m87B1EJ1ojcTfeseuvCYvCVRKWbutsnpRZ79ehKC5izkj+LdCTWWlc1L0=
X-Received: by 2002:a05:651c:4c9:: with SMTP id e9mr24176049lji.229.1633459406964;
 Tue, 05 Oct 2021 11:43:26 -0700 (PDT)
MIME-Version: 1.0
References: <20211002131212.130629-1-slow@samba.org> <20211002131212.130629-8-slow@samba.org>
 <CAKYAXd_jYHCnUbOoBGpsAPo_=H3wsbXcE8LOaAgvZT+dXzpPEA@mail.gmail.com> <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
In-Reply-To: <84fca1c3-2ee2-2a13-d367-6878b56f200a@samba.org>
From:   Steve French <smfrench@gmail.com>
Date:   Tue, 5 Oct 2021 13:43:16 -0500
Message-ID: <CAH2r5mukpkfuf951rVC97EBA8KLVPc3chF2+33Ms31uR_ty5dg@mail.gmail.com>
Subject: Re: [PATCH v6 07/14] ksmbd: use ksmbd_req_buf_next() in ksmbd_smb2_check_message()
To:     Ralph Boehme <slow@samba.org>
Cc:     Namjae Jeon <linkinjeon@kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>, Tom Talpey <tom@talpey.com>,
        Ronnie Sahlberg <ronniesahlberg@gmail.com>,
        Hyunchul Lee <hyc.lee@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Typically kernel style encourages even a brief description in all
changesets (even trivial ones) e.g.

"Simplifies message parsing slightly.  No change in behavior"

On Mon, Oct 4, 2021 at 11:29 PM Ralph Boehme <slow@samba.org> wrote:
>
> Am 03.10.21 um 02:59 schrieb Namjae Jeon:
> > 2021-10-02 22:12 GMT+09:00, Ralph Boehme <slow@samba.org>:
> >> No change in behaviour.
> > It is better to add patch subject here if there is nothing to write
> > patch description.
> > i.e. "Use ksmbd_req_buf_next() in ksmbd_smb2_check_message()"
> See the mail subject, that's the patch subject.
>
> In Samba we often help reviewers reviewing large patchsets that may
> include a lot of small preparational/cleanup patches with a sentence
> like "No change in behaviour" to give a hint which patches are critical
> and need extra care when reviewing (ie all others) and which may not
> require this.
>
> -slow
>
> --
> Ralph Boehme, Samba Team                 https://samba.org/
> SerNet Samba Team Lead      https://sernet.de/en/team-samba



-- 
Thanks,

Steve
