Return-Path: <SRS0=36sk=AU=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D103C433DF
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 14:54:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EDFE20767
	for <linux-cifs@archiver.kernel.org>; Thu,  9 Jul 2020 14:54:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728200AbgGIOy6 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 9 Jul 2020 10:54:58 -0400
Received: from mx2.suse.de ([195.135.220.15]:46732 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728097AbgGIOy6 (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 9 Jul 2020 10:54:58 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id B1B52AAC5;
        Thu,  9 Jul 2020 14:54:56 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>, Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH v2 1/7] cifs: merge __{cifs,smb2}_reconnect[_tcon]()
 into cifs_tree_connect()
In-Reply-To: <20200706181609.19480-2-pc@cjr.nz>
References: <20200706181609.19480-1-pc@cjr.nz>
 <20200706181609.19480-2-pc@cjr.nz>
Date:   Thu, 09 Jul 2020 16:54:51 +0200
Message-ID: <87a70868n8.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


This seems OK to me, but maybe Stefan can double-check too.

Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
