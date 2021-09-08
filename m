Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52DBC433EF
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 14:27:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C8E60E94
	for <linux-cifs@archiver.kernel.org>; Wed,  8 Sep 2021 14:27:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351904AbhIHO2j (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:28:39 -0400
Received: from smtp1.axis.com ([195.60.68.17]:11649 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhIHO2j (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 8 Sep 2021 10:28:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1631111251;
  x=1662647251;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ugl/3fZjTq1MAbdm7p9tbvGhoiUfJnboZoK5ayOnx3Q=;
  b=LZwABOvfs2trWAvoSVYLl7CU9PT7pPsNiz6kOrKdLjv5UpHBAzNGVRlf
   q+gjUq8GdKKmBMCCoPN7lDjfmSjcrbHqyX7NZKOLrM8qHFDud6DywPwFZ
   Ou/oET2Fvs6jQPi4EsYBpBJ9m9vZLiC+wkGRu7w7I2i64QtzFGuQ3xAqo
   zQurfCFPHwXGDRwfZ0GqZ9DPOQgA3F0OLAVHvodbPDKdX0Jd+lrase5RR
   YRvgzZaIE/K6eugGr433ESfKmTauMmoTki0kVneWwl17RugcFhtazwR0V
   U/rdLFBQgQIe45QzF2A/p3cyHQmgKgyYoGJyeJXbP7uaIP/x+T3Pmz76q
   g==;
Date:   Wed, 8 Sep 2021 16:27:29 +0200
From:   Vincent Whitchurch <vincent.whitchurch@axis.com>
To:     Hillf Danton <hdanton@sina.com>, <sfrench@samba.org>
CC:     Bruno Goncalves <bgoncalv@redhat.com>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiong Zhou <xzhou@redhat.com>,
        Eric Biggers <ebiggers@google.com>
Subject: Re: possible circular locking dependency detected:
 compound_send_recv+0x189/0x910 [cifs] vm_mmap_pgoff+0x85/0x160
Message-ID: <20210908142729.GA6873@axis.com>
References: <CA+QYu4rS+UkLUS-BDwNAOaMW2nQ4JY3V0OqdnLe3=zNoTrDDYQ@mail.gmail.com>
 <20210827082746.2490-1-hdanton@sina.com>
 <20210828020236.2679-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210828020236.2679-1-hdanton@sina.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Sat, Aug 28, 2021 at 04:02:36AM +0200, Hillf Danton wrote:
> On Fri, 27 Aug 2021 15:27:24 +0200 Vincent Whitchurch wrote:
> > On Fri, Aug 27, 2021 at 10:27:46AM +0200, Hillf Danton wrote:
> > > 
> > > Only if it is too difficult to fix 05946d4b7a73 ("cifs: Fix preauth hash
> > > corruption") within cifs then fix the deadlock by replacing kthread_run()
> > > with queue_work().
> > 
> > Perhaps I'm missing something, but would the lockdep complaint really go
> > away without 05946d4b7a73?  cifs_alloc_hash() is called under the
> > srv_mutex in other places (for example setup_ntlmv2_rsp()), so the
> > 
> > 	&tcp_ses->srv_mutex --> &cpuset_rwsem --> &mm->mmap_lock
> > 
> > chain would still exist, and compound_send_recv() takes srv_mutex before
> > 05946d4b7a73 too, so &mm->mmap_lock -> srv_mutex would exist too.
> 
> Yes you are right. The key is mmap_lock here.
> > 
> > For cifs_alloc_hash() to be able to be called without the srv_mutex I
> > guess it would have to be done when the tcp_ses is allocated.  That
> > however would essentially be a revert of commit 95dc8dd14e2e84cc3ada
> > ("Limit allocation of crypto mechanisms to dialect which requires").
> 
> It is more appreciated to have a fix within cifs.

Yes.  I'm hoping someone else with more insight into the cifs code can
see if there's another way to fix this in cifs or if it's safe to try
and revert 95dc8dd14e2e84cc3ada.  Steve?
