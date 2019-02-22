Return-Path: <SRS0=FePp=Q5=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23578C43381
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 20:31:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB76120700
	for <linux-cifs@archiver.kernel.org>; Fri, 22 Feb 2019 20:31:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725900AbfBVUbc (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 22 Feb 2019 15:31:32 -0500
Received: from ishtar.tlinx.org ([173.164.175.65]:44196 "EHLO
        Ishtar.sc.tlinx.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbfBVUbc (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 22 Feb 2019 15:31:32 -0500
Received: from [192.168.3.12] (Athenae [192.168.3.12])
        by Ishtar.sc.tlinx.org (8.14.7/8.14.4/SuSE Linux 0.8) with ESMTP id x1MKVSrV006296;
        Fri, 22 Feb 2019 12:31:30 -0800
Message-ID: <5C705C20.6080301@tlinx.org>
Date:   Fri, 22 Feb 2019 12:31:28 -0800
From:   L A Walsh <cifs@tlinx.org>
User-Agent: Thunderbird
MIME-Version: 1.0
To:     Steve French <smfrench@gmail.com>
CC:     Pavel Shilovsky <piastryyy@gmail.com>,
        linux-cifs <linux-cifs@vger.kernel.org>
Subject: Re: upcalls seem to have problems with symlinks, junctions et al.
References: <5C6B997B.8050203@tlinx.org> <CAKywueSgMhDzKOx04_C8X3HEhn_0w6cwM43c3=FXdjCsZ3x9UA@mail.gmail.com> <5C6DAEFC.2060909@tlinx.org> <5C6F3167.7090402@tlinx.org> <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
In-Reply-To: <CAH2r5mskDv3ZB8gUpRDN6iPzaZaGeXuN-uHikGvj+5K4epN2Xg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 2/21/2019 8:30 PM, Steve French wrote:
> I have wanted to change this code and improve it for a while - one
> thing which is tricky is showing mode bits when no permissions to read
> permissions though,
>   
---
    How often would it be the case that you could read the content
of a directory, but not be able to read the permissions? 

    While that can happen on Windows... and not so much on linux
what is the content of the link considered?  I.e. where it is pointing?
Is that something that would usually be readable because it is
pointing to the next item in the path and most people have
the privilege to "Bypass Traverse Checking"?

    I.e. -- is the access to the path information in a symlink controlled
by read permissions to item content, or is it considered part of the
information needed for Traverse Checking?

    I think my issue I had in Feb 2017 had to do with getting
different results depending on the type of the redirect -- junctions,
mountd/vol, and symlink/symlinkd's -- and perhaps that might be
related to how they store store the meta-information?  I suppose
there is similar redirect information at a DFS mount point?

    Part of what I expect, "as a user", to be available to a remote
user, is based on how things look from a user perspective using the
POSIXish-designed-Cygwin.  If I'm signed in with the same
domain-credential (and same SID), remotely, vs. locally, my
expectation is that I should see the same access.  That forms my
expectations with CIFS.






