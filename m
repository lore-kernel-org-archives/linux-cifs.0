Return-Path: <SRS0=ZOHs=XF=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7836AC3A5A2
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 11:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5906720872
	for <linux-cifs@archiver.kernel.org>; Tue, 10 Sep 2019 11:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730707AbfIJLlt convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 10 Sep 2019 07:41:49 -0400
Received: from mx2.suse.de ([195.135.220.15]:58596 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728639AbfIJLls (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 10 Sep 2019 07:41:48 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70C09B66C;
        Tue, 10 Sep 2019 11:41:47 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     ronnie sahlberg <ronniesahlberg@gmail.com>,
        Steve French <smfrench@gmail.com>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        CIFS <linux-cifs@vger.kernel.org>
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
In-Reply-To: <CAN05THREAX12uBdWULEQnP+Ko52uDzTjry3dYKM3ZFiB2cYaJw@mail.gmail.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
 <87mufdiw0u.fsf@suse.com>
 <CAH2r5mt9etVvg5jFk5jXRV6FadGz=qcqgG+JBhojKwVKmvRPZw@mail.gmail.com>
 <CAN05THREAX12uBdWULEQnP+Ko52uDzTjry3dYKM3ZFiB2cYaJw@mail.gmail.com>
Date:   Tue, 10 Sep 2019 13:41:46 +0200
Message-ID: <87h85kidj9.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"ronnie sahlberg" <ronniesahlberg@gmail.com> writes:
> Lets get rid of the list of tests from the wiki and let the buildbot
> be the single canonical source of truth.

Sounds good to me. Ideally this list should be exportable (perhaps
automatically from the buildbot script) in a format that can be used
directly by the check script for others to use.

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
