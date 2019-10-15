Return-Path: <SRS0=LgxW=YI=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64327C10F14
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 15:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 402CC20640
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Oct 2019 15:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733265AbfJOPdL convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:33:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:39682 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732659AbfJOPdK (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 15 Oct 2019 11:33:10 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 5C973B279;
        Tue, 15 Oct 2019 15:33:09 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com>,
        linux-cifs@vger.kernel.org
Subject: Re: Kernel hangs in cifs_reconnect
In-Reply-To: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
References: <56d13db4-62ed-99c0-90b8-bb332143cece@prodrive-technologies.com>
Date:   Tue, 15 Oct 2019 17:33:08 +0200
Message-ID: <871rveaurv.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Martijn de Gouw <martijn.de.gouw@prodrive-technologies.com> writes:
> Our Linux VMs reports call traces about processes being stuck.
> I've attached the full dmesg of one of the call traces below.
>
> The machine is running kernel 5.3.1 SMP. All mounts are mounted via the
> dfs shares on our domain controller and have the following options in fstab:
> nohandlecache,multiuser,sec=krb5,noperm,user=xxxx,file_mode=0600,dir_mode=0700,vers=3.0

It looks like its DFS related. The DFS cache code takes the reconnect
mutex and crashes with no chance to give back the mutex, making all
other process hang while waiting for it.

Cheers,
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
