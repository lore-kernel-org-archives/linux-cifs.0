Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07D5DC636D6
	for <linux-cifs@archiver.kernel.org>; Mon, 20 Feb 2023 19:57:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231514AbjBTT52 (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 20 Feb 2023 14:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjBTT51 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 20 Feb 2023 14:57:27 -0500
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940841DB9D
        for <linux-cifs@vger.kernel.org>; Mon, 20 Feb 2023 11:57:26 -0800 (PST)
Message-Id: <0e234e29fff5806ffe45046cc9cd6327@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676923044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JMdjscrM/0ogSOR/FGLzk9SBCJpuiUqNf9Rs1k46CwE=;
        b=C+5IWXV9mg8xQ6Szyym/UF3oyYnYFST4Yjn/x8SPa2WkDKnTxT3k9OmumqCrSTFx6TJ1Sb
        y7N4DKQnjtZwnW4g/rRc5UBVaLk6kDjSg8FhY/qY75bzC8f1WEBLEhMqzn0M4NjEg1rWh6
        tZqn3/FhwaMPfnw9u9g9sKbHtwvTSXBR+KXysRrLVnzzRpErYTXPiePLsEeoYte9BqXs28
        +J04xlKJUmoCK5GZO2ZIhfnnBC62i++ce7W0A/uljrQPLY7iy+kwj8dfb7Ux2B1DD/+Rwa
        TH8kJ9JrTdztk71jkXQoeUGJoRVLTzJ7Wzl2wTXDf+V7RDq5YRrNoxA/dDkM+Q==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1676923044; a=rsa-sha256;
        cv=none;
        b=tA09XS4Tt1egy2bPehaSRrihi3duhYbXl4Fw+22+t5bYahcKuOCYHPnqS/Djj+ahdMlYC9
        Ds543nA+dW5t2NfjmDlFDMuTiiaOccl74ze1fQkfffZ1b0XaVfS7HSJUkgmi2uWwfAl8rQ
        JvL6be6cSQco/gdGu8jgAbnh+Wb7QoFPxb5FovBTpJkinxG//kcka6GSJSm1/qB9Ec2JC3
        Zy1htig7U3vT0280ifLnDizz6qXuVGxeHl3ikeIGeF+CNrhx+XfXt47+dUZjwGdlsPdguJ
        gq3aplduykQB7ftUUecAiQ9BCQ34QeAylyrex8hP08kBm28EVgnc78ERSHOlIw==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1676923044;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JMdjscrM/0ogSOR/FGLzk9SBCJpuiUqNf9Rs1k46CwE=;
        b=NeiuPbhsQi4/oCApAQHqRmmIL/B5Ox96mpsRNN8iVwSV3zjtgW45bbRkAPxQFMn/WDfgwK
        FNVYQNFBLjz34SuhZYC3+pkTAwYYxweQVqftljMT8z4jVxy+hrmEYn1uO1R6476z5QHu8C
        e1itsdpL8oQqJ7tsU4txHH7zbfxstH/naJMi24gEOfoWOJ0faxC21FlDh8iY7rXxO3jgMZ
        iCQb94NpZoBMknmxv9pS7R8PoXqzcCmhP9xoL0Tpd5zS6iOXc8ShNhsVHyPE+DvxLKuyAF
        qiMsTHKo8467Rm1pu/3U+ypWgWcVTMAdZQbxruem4L2RTIFl31qNO03287VAtQ==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Shyam Prasad N <nspmangalore@gmail.com>,
        Steve French <smfrench@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        Bharath S M <bharathsm@microsoft.com>
Subject: Re: Fixes to multichannel reconnects
In-Reply-To: <CANT5p=pOGn4Gc3T1FOQCmhFxM=-Wn_0GcV9owty8NELjQ1r0vA@mail.gmail.com>
References: <CANT5p=pOGn4Gc3T1FOQCmhFxM=-Wn_0GcV9owty8NELjQ1r0vA@mail.gmail.com>
Date:   Mon, 20 Feb 2023 16:57:20 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Shyam Prasad N <nspmangalore@gmail.com> writes:

> Stress testing of multichannel reconnect in Microsoft uncovered a few
> bugs in multichannel reconnect codepath (particularly when reconnects
> happen in parallel).
>
> I have fixed those in the following commits:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/a87bb308b7d126b522d4390dbf37f63e743133ac.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0a95e989840d2617940ad4670c52b43646b491ad.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/5640b4cd537b70a690e3c1a6aa22afced71c8c87.patch
>
> Also fixed a couple of regressions:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/30a563a20e00f99899b703f32feb30793b04bfcb.patch
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/0c1c85c0720ef8fa3bac3819315e8d9311926915.patch
>
> All the above are critical fixes that we should probably CC stable.
>
> And a minor fix:
> https://github.com/sprasad-microsoft/smb3-kernel-client/commit/be94b055601c48f4156e48da7b282d51970bad07.patch

Please, post the patches to the mailing list so we can properly comment
them.
