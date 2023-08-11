Return-Path: <linux-cifs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9078AEB64DD
	for <linux-cifs@archiver.kernel.org>; Fri, 11 Aug 2023 17:06:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235947AbjHKRGt (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 11 Aug 2023 13:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235405AbjHKRGt (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Fri, 11 Aug 2023 13:06:49 -0400
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CAD1E5B
        for <linux-cifs@vger.kernel.org>; Fri, 11 Aug 2023 10:06:49 -0700 (PDT)
Message-ID: <334a928253fb6b5275b57df318e00480.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691773607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5O0YhD98bhCNXNVCBGni4YAKuh5EKHkr8rxrE7qrYjw=;
        b=XedRG0BGrHWLhUmzwEopcUaTG5EDr5ePSI/3ywiSdvUBUkJ/b3tQMc4ODkbz470ZzLDMRz
        RsEuuNaYvcNyZjlG81gR/dukyUfdsSJ493vt/+M2FSxs7dqoUt+WbZTmwkj3BDMAyIUj3x
        Kw+jASFXB1iDthpZdsoGikv7ZGQhVLZKD2g61Z+J31w8QBHEqxcpKpJpHhWvxcz0OSw5NZ
        2Fi/wNeNBkrLJLLc1R0MAqu7P5YHDEvsBbL4iTOzySUTEhNKsUjUxlfw2qcXJwd/Cq0rVq
        zb+0tUVfZwv1kP+mcKtoV3YzpzvPZ0Z8XWRceMzBpLZ/6EynOOuO0/4BkCfPKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
        s=dkim; t=1691773607;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5O0YhD98bhCNXNVCBGni4YAKuh5EKHkr8rxrE7qrYjw=;
        b=nAqmzhYFux9C0BoBgzaowU5WaWqhhuinXmYlq+3U0bXjvMxOwoSSeeESNMBQB3wfRfvU3J
        FgblhKIoxL+3cP17P0/N9OvNc6+ch3OPZk0jLMf0wFDGfaWtmCEzA00cNNVP6363W6Nr6Q
        qd0jbSWtcqTgf8gfNxDygdizCRGFSYX+AGllZySdF6BnOrXxHi4rRyq6U3UA3IMck9UayK
        f1ZdxvWkBkKlQlwqdN8WoWkqth9OEoXZW6aQ4RV210UqgiIx2cry5TP1H5qkCo+eU9TAJr
        za1iYf6R9B5k2tx3qVEl8s7c9dJ1KktCvUYZ28x4zQzbrzMbT3xS9lBJF/vG9A==
ARC-Authentication-Results: i=1;
        ORIGINATING;
        auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1691773607; a=rsa-sha256;
        cv=none;
        b=ANi2kpxw/Ju4Y60u4pP3QYPkI8ngSBqVystuUvQR2mtaBnJuil6Jh/yFr/9n+BZPd/xcLL
        4l1k+MUiynS9LLM4chDexLBaG1n7KrBDLIyjVGhjiE7So5XlC2VpJc0rPXnwKt9mXazF5k
        2OhtAjDPVAlmaLH4TiWnxqzomMLTG9uSVnSgXYS3vCeuDvR3VxdNS7eLzkuaYntW0Bkn16
        S6ae4nKnF2W5BhMaFMgHmLkQQhf4A4q/d2XqxB1YR4u6QtTq7nxc7zxD8bz5fzCcQGfmdy
        5MNJFcWAMGnm36Ji6RRMrQy1bv5KLbizh/mrzPMj/W8rRoKmR//jNBggX9l7Cw==
From:   Paulo Alcantara <pc@manguebit.com>
To:     Jeff Layton <jlayton@kernel.org>, Steve French <smfrench@gmail.com>
Cc:     =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        ronnie sahlberg <ronniesahlberg@gmail.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Jay Shin <jaeshin@redhat.com>,
        Roberto Bergantinos Corpas <rbergant@redhat.com>
Subject: Re: [PATCH] cifs: missing null pointer check in cifs_mount
In-Reply-To: <a3a8f7a3e90541f20ef93e7f02f0a877661d8999.camel@kernel.org>
References: <CAH2r5mvxp8OZthKPQGCv82xEkNW+z7SN_QhdRUMnHJ2Fm4pJqA@mail.gmail.com>
 <875yy4red3.fsf@suse.com> <B3F6DE12-CA6D-47BD-9383-B4BD2F73FCBC@cjr.nz>
 <CAH2r5mspWoea04K3Veuy9b-4k_TOLvuA13Xxnc8o0c=8g8zJrg@mail.gmail.com>
 <84c22724edac345b01e1e4b5527426e00b0be3e7.camel@kernel.org>
 <169d12e72d7d732d32051d22f255c5df.pc@manguebit.com>
 <7f1c7940764425cbcf6f6585d138ef38e6618581.camel@kernel.org>
 <cca8280bb933aa149de1bb9115d2fb3a.pc@manguebit.com>
 <a3a8f7a3e90541f20ef93e7f02f0a877661d8999.camel@kernel.org>
Date:   Fri, 11 Aug 2023 14:06:41 -0300
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Jeff Layton <jlayton@kernel.org> writes:

> On Fri, 2023-08-11 at 13:49 -0300, Paulo Alcantara wrote:
>> > In any case, we'll plan to fix this up with a one-off in RHEL/Centos.
>> > Thanks again for the sanity check!
>> 
>> Would you mind to propose a patch that fixes the above and mark it for
>> v5.14..v5.15?
>
> Sounds good. One of us will make sure that happens too.

Thanks!
