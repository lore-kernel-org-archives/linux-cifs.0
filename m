Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA1DEC6FA82
	for <linux-cifs@archiver.kernel.org>; Tue, 27 Sep 2022 23:24:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbiI0XYV (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 27 Sep 2022 19:24:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiI0XYU (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 27 Sep 2022 19:24:20 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977A31A38D
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 16:24:18 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1278a61bd57so15273142fac.7
        for <linux-cifs@vger.kernel.org>; Tue, 27 Sep 2022 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=KfB+fJnhHE2zNulRQQ9KUqULi3PBY5621b0zSJ+rRiI=;
        b=eau9HmKWyfvAuZEwtj7QmoK1HfJjCFwMuGix17udzmlKEuY9lkpqohrD8wt66JHwRT
         KSb6sLNqwfRowI6r24gS+Zlb3hfVff9y/t86iE4vRCCd8Wu4+5O/4s5NeMKfgSdL25d0
         4q4wxZ2TkMP/C5fgo0cocvMGfHF7nF9wQ5WEh4m8G54JES3Snsl8aJtJX6AiVdZoZ69k
         IECpUZuksJFAsF+Ji9+YHOxewd0pA+3uj9PaBBYcuJS8D/yxcIYLdlq5cCO6Nsork0j7
         s23g1jmzUfjyYTlhzE9TD+j0pK3IuZNVK8zklyluBLFDWDfKjz0yKU+N1f+nCKoAf8DG
         ksoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=KfB+fJnhHE2zNulRQQ9KUqULi3PBY5621b0zSJ+rRiI=;
        b=YMMkF7x9lRkwgWPccjuQ+pq69jLyDb3z/e1O2bUcDbNnH6T1dbHsVQlptnu0CIL797
         Z22ZnATqv4HcnjRbuLfRlYraM7mz4JPxBOaCbZJlH7P2QsLfzuYQtOoBCpg/cuLQj9sn
         FmC/qVkzyh3V8u+z8yMz58AcCQr/ZovR0OrMu+4G7cPVy/PT6EOJy92faDUAHxewn6MU
         CWj6p3C+EXt428Zk/QfQ7iG+SlbDzBiUCdcMfNePfLqP+2bNEs6QbFWlAmlPP1i2M/Lz
         fxwNnyMEAy6OC0M3+E1+jBu8u6SqXGarUz/mZ2h5uHAIRHW0T/9zNRPp0KXDnq9PU84E
         OrEA==
X-Gm-Message-State: ACrzQf15UN/Wt6zLihx5fu3yu1Kbdxdclcy1vYvAgS/NX0pmge4tzTYR
        sOzwN2NeBfuqY98fxnH6FI4cyuNC6iZSPtQBbAuu
X-Google-Smtp-Source: AMsMyM6wd85jvS0PvhSbxvF1obwpMq99dFhlTudrpP66jnQIV+3XyzCJE77VYyMHZTqUd1kmc1lJlvv3EpWrA2BlTrM=
X-Received: by 2002:a05:6870:a916:b0:131:9361:116a with SMTP id
 eq22-20020a056870a91600b001319361116amr2006434oab.172.1664321057952; Tue, 27
 Sep 2022 16:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <20220926140827.142806-1-brauner@kernel.org> <99173046-ab2e-14de-7252-50cac1f05d27@schaufler-ca.com>
 <20220927074101.GA17464@lst.de> <a0cf3efb-dea1-9cb0-2365-2bcc2ca1fdba@schaufler-ca.com>
In-Reply-To: <a0cf3efb-dea1-9cb0-2365-2bcc2ca1fdba@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 27 Sep 2022 19:24:07 -0400
Message-ID: <CAHC9VhToUZici98r10UJOQhE48j-58hUheT0P8GE9nC38p=ijQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/30] acl: add vfs posix acl api
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Christian Brauner <brauner@kernel.org>,
        linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        v9fs-developer@lists.sourceforge.net, linux-cifs@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, Sep 27, 2022 at 10:13 AM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> On 9/27/2022 12:41 AM, Christoph Hellwig wrote:
> > On Mon, Sep 26, 2022 at 05:22:45PM -0700, Casey Schaufler wrote:
> >> I suggest that you might focus on the acl/evm interface rather than the entire
> >> LSM interface. Unless there's a serious plan to make ima/evm into a proper LSM
> >> I don't see how the breadth of this patch set is appropriate.
> > Umm. The problem is the historically the Linux xattr interface was
> > intended for unstructured data, while some of it is very much structured
> > and requires interpretation by the VFS and associated entities.  So
> > splitting these out and add proper interface is absolutely the right
> > thing to do and long overdue (also for other thing like capabilities).
> > It might make things a little more verbose for LSM, but it fixes a very
> > real problem.
>
> Here's the problem I see. All of the LSMs see xattrs, except for their own,
> as opaque objects. Introducing LSM hooks to address the data interpretation
> issues between VFS and EVM, which is not an LSM, adds to an already overlarge
> and interface. And the "real" users of the interface don't need the new hook.
> I'm not saying that the ACL doesn't have problems. I'm not saying that the
> solution you've proposed isn't better than what's there now. I am saying that
> using LSM as a conduit between VFS and EVM at the expense of the rest of the
> modules is dubious. A lot of change to LSM for no value to LSM.

Let's take a step back and look not just at the LSM changes, but the
patchset as a whole.  Forgive my paraphrasing, but what Christian is
trying to do here is introduce a proper ACL API in the kernel to
remove a lot of kludges, special-cases, etc. in the VFS layer,
enabling better type checking, code abstractions, and all the nice
things you get when you have nice APIs.  This is admirable work, even
if it does result in some duplication at the LSM layer (and below).

It is my opinion that the impact to the LSM, both at the LSM layer,
and in the individual affected LSMs is not significant enough to
outweigh the other advantages offered by this patchset.

-- 
paul-moore.com
