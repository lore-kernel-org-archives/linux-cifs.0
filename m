Return-Path: <SRS0=4GOt=RW=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30E8BC43381
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 15:26:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08AAD20811
	for <linux-cifs@archiver.kernel.org>; Tue, 19 Mar 2019 15:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbfCSP0i convert rfc822-to-8bit (ORCPT
        <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 19 Mar 2019 11:26:38 -0400
Received: from mx2.suse.de ([195.135.220.15]:39408 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726466AbfCSP0i (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 19 Mar 2019 11:26:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2CFFCB11B;
        Tue, 19 Mar 2019 15:26:37 +0000 (UTC)
From:   =?utf-8?Q?Aur=C3=A9lien?= Aptel <aaptel@suse.com>
To:     Dominik Brodowski <linux@dominikbrodowski.net>, sfrench@samba.org
Cc:     linux-cifs@vger.kernel.org
Subject: Re: v5.1-rc1 cifs bug: underflow; use-after-free.
In-Reply-To: <20190319115151.GA2092@light.dominikbrodowski.net>
References: <20190319115151.GA2092@light.dominikbrodowski.net>
Date:   Tue, 19 Mar 2019 16:26:33 +0100
Message-ID: <87mulq6g2e.fsf@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Dominik Brodowski <linux@dominikbrodowski.net> writes:
> when mounting a cifs (vers=2.0, unfortunately...) volume on v5.1-rc1, I get
> the following warning (slightly edited to avoid information leaks):

The cached root can be closed 2 ways:
- from the cifs_get_inode_info()
- from a lease break while it is open

So here's my theory:

in the mount task:
=> mount()
   ...
  => cifs_get_inode_info()
    => open_shroot()
       (at this point root has open handle with lease)
 

in the receive loop task:
         <==== LEASE BREAK arrives (root modified from another smb
                                    client)
               queues & call cached root lease break callback
               smb2_cached_lease_break()
               => close_shroot()
                  refcount reaches 0, we release the cached fid

back in the mount task:
    => we are done with the handle time to call
      => close_shroot()
          refcount already 0, releasing again

----

Now, since the release function doesn't actually frees the cached_fid
struct but closes the handle sets an invalid flag instead I think this
message can be ignored, because the release function checks for the flag
anyway. i.e. second time we call smb2_close_cached_fid, it is a no-op.

See:

static void
smb2_close_cached_fid(struct kref *ref)
{
	struct cached_fid *cfid = container_of(ref, struct cached_fid,
					       refcount);

	if (cfid->is_valid) {
		cifs_dbg(FYI, "clear cached root file handle\n");
		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
			   cfid->fid->volatile_fid);
		cfid->is_valid = false;
		cfid->file_all_info_is_valid = false;
	}
}

void close_shroot(struct cached_fid *cfid)
{
	mutex_lock(&cfid->fid_mutex);
	kref_put(&cfid->refcount, smb2_close_cached_fid);
	mutex_unlock(&cfid->fid_mutex);
}

If you enable verbose debugging [1], if my theory is correct you should
see a lease break messsage followed by "clear cached root file handle"
message before the warning.

Since we take a mutex before and after the kref, it kind of defeats the
purpose of the atomic kref i.e. we could use a regular integer as
refcount and simply do this: 

void close_shroot(struct cached_fid *cfid)
{
	mutex_lock(&cfid->fid_mutex);
	if (cfid->refcount-- && cfid->is_valid) {
		cifs_dbg(FYI, "clear cached root file handle\n");
		SMB2_close(0, cfid->tcon, cfid->fid->persistent_fid,
			   cfid->fid->volatile_fid);
		cfid->is_valid = false;
		cfid->file_all_info_is_valid = false;
	}
	mutex_unlock(&cfid->fid_mutex);
}

(we need to replace other usage of the kref and check they are all
protected by taking the mutex as well)

1: https://wiki.samba.org/index.php/Bug_Reporting#cifs.ko
-- 
Aurélien Aptel / SUSE Labs Samba Team
GPG: 1839 CB5F 9F5B FB9B AA97  8C99 03C8 A49B 521B D5D3
SUSE Linux GmbH, Maxfeldstraße 5, 90409 Nürnberg, Germany
GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
