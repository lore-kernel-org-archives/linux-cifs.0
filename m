Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3970BC4332F
	for <linux-cifs@archiver.kernel.org>; Mon, 28 Nov 2022 16:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbiK1Qea (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 28 Nov 2022 11:34:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232344AbiK1Qe3 (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 28 Nov 2022 11:34:29 -0500
Received: from mx.cjr.nz (mx.cjr.nz [51.158.111.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1229D20F64
        for <linux-cifs@vger.kernel.org>; Mon, 28 Nov 2022 08:34:28 -0800 (PST)
Received: from authenticated-user (mx.cjr.nz [51.158.111.142])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pc)
        by mx.cjr.nz (Postfix) with ESMTPSA id EC0977FD02;
        Mon, 28 Nov 2022 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cjr.nz; s=dkim;
        t=1669653266;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PQ66SAavGXhVahKTZGrBT/M7IZ6efH47DI7t1FxbCWs=;
        b=aFtXdLb38+pdn8n4sBaQpnpqwBtUSCa5hZAgbiwSwhhVOq22+I1Zdo4HN1IhAVWE9dhwVR
        7MPIeKKDaj5TmMA8UAzI+IPoqwi9eXS6I8qzU2m+hYaWYMhXswLTkqgW2vfhHfjxePnC2D
        sDQX/QcAV1zafmMCydF7OWs+KbYXTAOuaXk84WIVRGfolyKssDikyoG0ybutRb/kUX4UyO
        scCLnB1ER5SajkiziyPHQN7h9+uaHlQa+YtdYZxFNW2ZUhj0jp8NJLshWPkvrsiz+l3Pn5
        G6Mu3IXJxbueZa/kVOzctRBubugjBtaLydiTVq01ix2U45Aqouv/RsZBBZYXXA==
Date:   Mon, 28 Nov 2022 13:34:15 -0300
From:   Paulo Alcantara <pc@cjr.nz>
To:     Volker.Lendecke@sernet.de,
        Volker Lendecke <Volker.Lendecke@sernet.de>,
        Steve French <smfrench@gmail.com>
CC:     linux-cifs@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_Parse_owner_and_group_sids_from_?= =?US-ASCII?Q?smb311_posix_extension_qfileinfo_call?=
In-Reply-To: <Y4TNnusYnxfwYN0s@sernet.de>
References: <Y4DJ2o6w+SxIH7Yl@sernet.de> <CAH2r5mscUWuAbsSjw1DOFT=yG3dDZhcmCtAVLNhoH-5hrby-tg@mail.gmail.com> <Y4TNnusYnxfwYN0s@sernet.de>
Message-ID: <E31C913A-BDF3-4F7C-BF3C-562D4FB4BF78@cjr.nz>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On 28 November 2022 12:02:54 GMT-03:00, Volker Lendecke <Volker=2ELendecke@=
sernet=2Ede> wrote:
>Am Sat, Nov 26, 2022 at 06:31:51PM -0600 schrieb Steve French:
>> Looks like this does help the group information returned by stat, but
>> will need to make it easier to translate the owner sid to UID (GID was
>> an easier mapping since gid was returned as "S-1-22-"=2E=2E=2E but SID =
for
>> uid owner has to be looked up)
>
>Next version=2E I have to learn that -EINVAL and not EINVAL is the right
>error return in the kernel=2E

LGTM=2E  Thanks Volker!  Rb+
