Return-Path: <SRS0=r/yF=XE=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C027AC4740A
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 10:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A107C21920
	for <linux-cifs@archiver.kernel.org>; Mon,  9 Sep 2019 10:50:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfIIKuM convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 9 Sep 2019 06:50:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:52658 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726141AbfIIKuM (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Mon, 9 Sep 2019 06:50:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 8D54EB052;
        Mon,  9 Sep 2019 10:50:10 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Murphy Zhou <jencce.kernel@gmail.com>, linux-cifs@vger.kernel.org
Subject: Re: Are the xfstests exclusion files on wiki.samba.org up to date?
In-Reply-To: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
References: <20190909104127.nsdxptzxcf5a6b72@XZHOUW.usersys.redhat.com>
Date:   Mon, 09 Sep 2019 12:50:09 +0200
Message-ID: <87mufdiw0u.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

"Murphy Zhou" <jencce.kernel@gmail.com> writes:
> As $subject. Is this wiki being maintained ?
>
> Looks like the last update was in January 2019.
>
> https://wiki.samba.org/index.php/Xfstesting-cifs#Exclusion_files

We have a buildbot running xfstests relatively often here

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/

Each group has slightly different tests run, you can see which one gets
run by clicking on a build:

http://smb3-test-rhel-75.southcentralus.cloudapp.azure.com/#/builders/2/builds/249

Overall xfstests+cifs is very finicky and frustrating to get working
reliably. Not to mention long. So good luck :)

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
