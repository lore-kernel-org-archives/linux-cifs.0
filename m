Return-Path: <SRS0=wwpQ=7K=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: **
X-Spam-Status: No, score=2.1 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6C7C433DF
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 15:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 238FC20897
	for <linux-cifs@archiver.kernel.org>; Thu, 28 May 2020 15:29:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404466AbgE1P3o convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Thu, 28 May 2020 11:29:44 -0400
Received: from mx2.suse.de ([195.135.220.15]:48348 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404272AbgE1P3n (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Thu, 28 May 2020 11:29:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 44B86B145;
        Thu, 28 May 2020 15:29:41 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Paulo Alcantara <pc@cjr.nz>, linux-cifs@vger.kernel.org,
        smfrench@gmail.com
Cc:     Paulo Alcantara <pc@cjr.nz>
Subject: Re: [PATCH 1/3] cifs: set up next DFS target before generic_ip_connect()
In-Reply-To: <20200519183829.5512-1-pc@cjr.nz>
References: <20200519183829.5512-1-pc@cjr.nz>
Date:   Thu, 28 May 2020 17:29:40 +0200
Message-ID: <87tv00jcwr.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org


Reviewed-by: Aurelien Aptel <aaptel@suse.com>

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg, DE
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah HRB 247165 (AG München)
