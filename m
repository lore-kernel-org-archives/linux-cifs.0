Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A33E0C43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 15:47:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E33520854
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 15:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbfCSPrW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:47:22 -0400
Received: from mx2.suse.de ([195.135.220.15]:43484 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727572AbfCSPrW (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Mar 2019 11:47:22 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E6CFEACE1;
        Tue, 19 Mar 2019 15:47:20 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Subject: Re: v5.1-rc1 cifs bug: underflow; use-after-free.
In-Reply-To: <87mulq6g2e.fsf@suse.com>
References: <20190319115151.GA2092@light.dominikbrodowski.net> <87mulq6g2e.fsf@suse.com>
Date:   Tue, 19 Mar 2019 16:47:17 +0100
Message-ID: <87k1gu6f3u.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Aurélien Aptel <aaptel@suse.com> writes:
> 	if (cfid->refcount-- && cfid->is_valid) {

Actually, let's not decrement in the condition :)

void close_shroot(struct cached_fid *cfid)
{
	mutex_lock(&cfid->fid_mutex);
	if (cfid->refcount > 0 && cfid->is_valid) {
		cifs_dbg(FYI, "clear cached root file handle\n");
		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
			   cfid->fid->volatile_fid);
		cfid->is_valid = false;
		cfid->file_all_info_is_valid = false;
                cfid->refcount--;
	}
	mutex_unlock(&cfid->fid_mutex);
}

-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
