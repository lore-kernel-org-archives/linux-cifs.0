Return-Path: <SRS0=6ipX=YT=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBFFCA9EB9
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Oct 2019 10:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57FFC214DA
	for <linux-cifs@archiver.kernel.org>; Sat, 26 Oct 2019 10:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbfJZKP1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Sat, 26 Oct 2019 06:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726098AbfJZKP1 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Sat, 26 Oct 2019 06:15:27 -0400
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 56879859FB
        for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2019 10:15:27 +0000 (UTC)
Received: by mail-qk1-f200.google.com with SMTP id d127so4897631qkc.1
        for <linux-cifs@vger.kernel.org>; Sat, 26 Oct 2019 03:15:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=o3rl8efQYJom/qxi1rTiqdn4jSf1xXtg6yJb9O7vzcQ=;
        b=Ei0y6kcxWKWDy/cGpc233acNp2SgjXRNKxDp42fLVuSyGjCjK5zm5EqG5Y1VekpYT5
         +6rnxxbNZlCGAeUcTcQybHagnK3jfJizoB4h4oLueGxfmYExbAK7Ss+YcbotffurgBhl
         TntTAs8ldFVK0LnPQG4PxR5PZTZA7Xj8ilXFciSetT/tu40GyykoTXD73XAtDeRcm+kh
         8WcRp5LO0te/syN70onITsp7O4gEBYWe7aIyI2+qofWhcN7qOBu8gEv4e4HLtccohJ1V
         RQoZswJIcQuyJWxJxLTwWL9L057O3FfejmNl/rJ4BYbOuNpB+wRWirVa0m6yKSL3CBEI
         bWcg==
X-Gm-Message-State: APjAAAXdnKXsqvz4g6e3dE2bRiH2KFc9tvKCvx5E5mO4Sq5ZBu+ROOse
        xU4c6OgaIB17ct1eFz40tU6qMQ1U+lzLpIEWZHZYZU0tC/cbkqVZfqLBOJky8TXPcYb0yl4Z1Y0
        8fW9a+b881xXX8wfp6fbizuqrpEnujUgs6zSEmQ==
X-Received: by 2002:ac8:66cd:: with SMTP id m13mr7621947qtp.389.1572084926713;
        Sat, 26 Oct 2019 03:15:26 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxehh63Xh7CZiSOyVcw5TidqLMlEBn5gAg3EzVVKv8Ay3iQ4BqESAs2sgx7xNOKR5kfgPPUc/3hTJLWkLvMVNo=
X-Received: by 2002:ac8:66cd:: with SMTP id m13mr7621936qtp.389.1572084926533;
 Sat, 26 Oct 2019 03:15:26 -0700 (PDT)
MIME-Version: 1.0
References: <20191024235120.8059-1-lsahlber@redhat.com> <878sp8yera.fsf@suse.com>
In-Reply-To: <878sp8yera.fsf@suse.com>
From:   David Wysochanski <dwysocha@redhat.com>
Date:   Sat, 26 Oct 2019 06:14:50 -0400
Message-ID: <CALF+zOnNFSD2jsaGD1Ben1J3NBN=9TkgUUpgQkekK1jCAGwnhw@mail.gmail.com>
Subject: Re: Updated patch for the the lock_sem deadlock
To:     =?UTF-8?Q?Aur=C3=A9lien_Aptel?= <aaptel@suse.com>
Cc:     Ronnie Sahlberg <lsahlber@redhat.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Fri, Oct 25, 2019 at 12:24 PM Aurélien Aptel <aaptel@suse.com> wrote:
>
> Ronnie Sahlberg <lsahlber@redhat.com> writes:
> > This is a small update to Dave's patch to address Pavels recommendation
> > that we use a helper function for the trylock/sleep loop.
>
> Disclamer: I have not read all the emails regarding this patch but it
> is not obvious to me how replacing
>
>     lock()
>
> by
>
>     while (trylock())
>         sleep()
>
> is fixing things, but I'm sure I'm missing something :(
>

Let me try to explain better.

The deadlock occurs because of how rw_semaphores work in Linux.

The deadlock occurred because we had:
1. thread1: down_read() and obtained the semaphore
2. thread2: down_write() blocked due to thread1
3. thread1: down_read (a second time), blocked due to thread2

Note that it is normally benign for a single thread to call down_read
twice.  However, in this case, another thread called down_write in
between the two calls.  Once one thread calls down_write, any callers
of down_read will block, that is the rw_semaphore implementation in
Linux.  If this was not the case, we could have callers of down_read
continually streaming in and starving out callers of down_write.

The patch removes thread2 from blocking, so #3 will never occur, hence
removing the deadlock.
