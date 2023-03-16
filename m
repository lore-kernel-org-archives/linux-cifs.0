Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 713C1C7618A
	for <linux-cifs@archiver.kernel.org>; Thu, 16 Mar 2023 20:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCPU7o (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 16 Mar 2023 16:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCPU7m (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Thu, 16 Mar 2023 16:59:42 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BA263CE07
        for <linux-cifs@vger.kernel.org>; Thu, 16 Mar 2023 13:59:40 -0700 (PDT)
Message-ID: <ee7ad068976dcf1a7356fb6cd230fb69.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679000377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KgfFYgVYRuV9H/LhOhDKXcUikWwmoPB/HxvQLN/UyyM=;
        b=F0dOXtdKqKkQjeOBT+ofS8d33r6TJtVe6r8bYjg/4lflmooSlA6JogtI6vp01+cq4RET3X
        WgkBIRd1ssPIYMu+K8uHHQVr6BeEwkTtsAsW6YQXn8qqAOxut2yVGvKJIVPkT3eao+bMd5
        g/Ejg3KZ4oWMyJNRNVgQzYTyyFpMLjC7+o1zyquDfGtexFzLkIAs8rvHU1ondyYSdPIE/H
        2vMWSWfj94Z6/4snXYXRHjG/SthPX4tAuqsLcNp7Q6o++YVKvLZ89bQ0+4mL2sAGA8ZoO6
        fj2BZaiJ/eeg/nUggo6vgsYZr+HD2DQStuzPwCZ2qxmH5hXGEkeDcwdm5eMDPA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1679000377; a=rsa-sha256;
        cv=none;
        b=FtZeXzxhoSZiKXDvGaZfMRhbZdEw+dWfuaa5aTeO2Yvk9wiBbt3xRbVWnMxEVPDAmEIJ2d
        Y8FmCe6LVan5is+xfZ8Tc34nxuDxwAlkTAvmPNtUa5Dh9nUCmjuICH4d3eWmzrTIL+M67q
        zlgUQh845IhF8DR4jYuvj4A2nhcsdPzxsdzsMT3kNTTxYNYm+JL/CJz/UuOoz3RdP3KR5z
        VCg4z8I8AbqYlJYF9jOTJuvicDYD+G0DqnxG6ojZ6OQhqbyLk7uwyD33rHqvzbVBvWJNjY
        IxsgKPrA6gYO+jBLR6iIlGHYEiEISHbQycjI26FTa5yKzhFFFFXrK12Rh0c4rA==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1679000377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KgfFYgVYRuV9H/LhOhDKXcUikWwmoPB/HxvQLN/UyyM=;
        b=FYOxzgcRzyLyEPdZOCJ9t95HphTIjDzGpFBF14AaKVRD0Ew97BgiVtfxQYgt77FWpWEoTh
        VUDYLAM9RGi+PXuWpviH/QfwUh4O/6aZCtZoJhy9yYAAdE/stNykT+b3vucjAYyrRvzZ1b
        0svufDLwOk8/Y/6J9K79JfMeBDjeLb3ffwPVuXgwNJEwddnWxNTlsQlFELNdaClS7qie+Z
        etOFuzyi5YMmYFNvC5+Z5K7GaoOwaMxN5PGm/L5wUnExUaBzIwrGQWmefv4aB+hLccrTcM
        9aMj8Nwe6B9MuxBwcNSFcY+Hqn0OzJrl256xnN9EAeo+uTQe+vd1jhyeddFl9g==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>
Cc:     smfrench@gmail.com, bharathsm.hsk@gmail.com, tom@talpey.com,
        linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 01/11] cifs: fix tcon status change after tree connect
In-Reply-To: <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com>
References: <20230310153211.10982-1-sprasad@microsoft.com>
 <95f468756e26ebfb41f00b01f13d09da.pc.crab@mail.manguebit.com>
 <CANT5p=pfZNefhzGSytg9tuGXhNgvesVecTGoZFhWnUmnLxb-9g@mail.gmail.com>
Date:   Thu, 16 Mar 2023 17:59:32 -0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> On Wed, Mar 15, 2023 at 3:49=E2=80=AFAM Paulo Alcantara <pc@manguebit.com=
> wrote:
>> Shyam Prasad N <nspmangalore@gmail.com> writes:
>>
>> > After cifs_tree_connect, tcon status should not be
>> > set to TID_GOOD. There could still be files that need
>> > reopen. The status should instead be changed to
>> > TID_NEED_FILES_INVALIDATE. That way, after reopen of
>> > files, the status can be changed to TID_GOOD.
>> >
>> > Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
>> > ---
>> >  fs/cifs/cifsglob.h |  2 +-
>> >  fs/cifs/connect.c  | 14 ++++++++++----
>> >  fs/cifs/dfs.c      | 16 +++++++++++-----
>> >  fs/cifs/file.c     | 10 +++++-----
>> >  4 files changed, 27 insertions(+), 15 deletions(-)
>>
>> With this patch, the status of TID_GOOD is no longer set after
>> reconnecting tcons.  I've noticed that when the DFS cache refresher
>> attempted to get a new referral for updating a cached entry but the IPC
>> tcon status was still set to TID_NEED_FILES_INVALIDATE, therefore
>> skipping the I/O as it thought the IPC tcon was disconnected.
>>
>> IOW, the TID_NEED_FILES_INVALIDATE status remains set for both types of
>> tcons after reconnect.
>>
>> Besides, could you please split this patch into two?  The first one
>> would fix the checking of tcon statuses by using the appropriate spin
>> lock, and the second would make use of TID_NEED_FILES_INVALIDATE on
>> non-IPC tcons and set the TID_GOOD status afterwards.
>
> Good point. The tcon status were indeed messed up after this patch.
> Should have checked it earlier. My bad.
>
> Let me revert this one and include only the checking of tcon status
> with the right lock.
>
> Attached the patch for that.

Thanks for the patch!  Looks good to me.

BTW, don't you think we need to get rid of unnecessary ses status check
in __refresh_tcon() as well

        ...
	spin_lock(&ipc->tc_lock);
	if (ses->ses_status !=3D SES_GOOD || ipc->status !=3D TID_GOOD) {
