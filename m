Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,BIGNUM_EMAILS,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 054E2C4361B
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 16:52:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABA49225A9
	for <linux-cifs@archiver.kernel.org>; Tue, 15 Dec 2020 16:52:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731151AbgLOQwM (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 15 Dec 2020 11:52:12 -0500
Received: from mx2.suse.de ([195.135.220.15]:58556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgLOQwF (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Tue, 15 Dec 2020 11:52:05 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 22DDAAD12;
        Tue, 15 Dec 2020 16:51:24 +0000 (UTC)
Message-ID: <e810556b1f7688a1af5f84f0e7c717792c35cf0f.camel@suse.de>
Subject: Re: [bug report] cifs: Send witness register and unregister
 commands to userspace daemon
From:   Samuel Cabrero <scabrero@suse.de>
Reply-To: scabrero@suse.com
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-cifs@vger.kernel.org
Date:   Tue, 15 Dec 2020 17:51:23 +0100
In-Reply-To: <X9jL7XurwuwzmIsm@mwanda>
References: <X9jL7XurwuwzmIsm@mwanda>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

On Tue, 2020-12-15 at 17:45 +0300, Dan Carpenter wrote:
> Hello Samuel Cabrero,
> 
> The patch bf80e5d4259a: "cifs: Send witness register and unregister
> commands to userspace daemon" from Nov 30, 2020, leads to the
> following static checker warning:
> 
>         fs/cifs/cifs_swn.c:265 cifs_find_swn_reg()
>         warn: passing a valid pointer to 'PTR_ERR'
> 
> fs/cifs/cifs_swn.c
>    254  static struct cifs_swn_reg *cifs_find_swn_reg(struct
> cifs_tcon *tcon)
>    255  {
>    256          struct cifs_swn_reg *swnreg;
>    257          int id;
>    258          const char *share_name;
>    259          const char *net_name;
>    260  
>    261          net_name = extract_hostname(tcon->treeName);
>    262          if (IS_ERR_OR_NULL(net_name)) {
>    263                  int ret;
>    264  
>    265                  ret = PTR_ERR(net_name);
>                         ^^^^^^^^^^^^^^^^^^^^^^^
> 
> When a function returns *both* error pointers and NULL then NULL is
> not
> an error.  Probably it's an optional feature which has been disabled.
> If the function returns an error pointer then the function needs to
> clean up and fail in the proper way.  Maybe print an error message. 
> If
> it returns NULL then that means the feature has been diliberately
> disabled.  Don't print an error code.
> 
> The extract_hostname() is not optional and never returns NULL
> pointers.
> 
>    266                  cifs_dbg(VFS, "%s: failed to extract host
> name from target '%s': %d\n",
>    267                                  __func__, tcon->treeName,
> ret);
>    268                  return NULL;
>                         ^^^^^^^^^^^^
> 
> I guess probably the intention was to return an error pointer here
> and
> a NULL if we were able to search for the existing swn reg.  But
> probably
> it's simpler to just return either error pointers or NULLs on error
> and
> be consistent about it.  There is no point in optimizing for the
> failure
> case because that's not a fast path and it will just lead to bugs.
> 
> This function has two callers and one checks for both NULL and error
> pointers and the other only checks for NULLs so returning an error
> pointer would lead to bugs.
> 
>    269          }
>    270  
>    271          share_name = extract_sharename(tcon->treeName);
>    272          if (IS_ERR_OR_NULL(share_name)) {
>    273                  int ret;
>    274  
>    275                  ret = PTR_ERR(net_name);
>    276                  cifs_dbg(VFS, "%s: failed to extract share
> name from target '%s': %d\n",
>    277                                  __func__, tcon->treeName,
> ret);
>    278                  kfree(net_name);
>    279                  return NULL;
>    280          }
>    281  
>    282          idr_for_each_entry(&cifs_swnreg_idr, swnreg, id) {
>    283                  if (strcasecmp(swnreg->net_name, net_name) !=
> 0
>    284                      || strcasecmp(swnreg->share_name,
> share_name) != 0) {
>    285                          continue;
>    286                  }
>    287  
>    288                  mutex_unlock(&cifs_swnreg_idr_mutex);
>    289  
>    290                  cifs_dbg(FYI, "Existing swn registration for
> %s:%s found\n", swnreg->net_name,
>    291                                  swnreg->share_name);
>    292  
>    293                  kfree(net_name);
>    294                  kfree(share_name);
>    295  
>    296                  return swnreg;
>    297          }
>    298  
>    299          kfree(net_name);
>    300          kfree(share_name);
>    301  
>    302          return NULL;
>    303  }
> 
> [ snip ]
> 
>    309  static struct cifs_swn_reg *cifs_get_swn_reg(struct cifs_tcon
> *tcon)
>    310  {
>    311          struct cifs_swn_reg *reg = NULL;
>    312          int ret;
>    313  
>    314          mutex_lock(&cifs_swnreg_idr_mutex);
>    315  
>    316          /* Check if we are already registered for this
> network and share names */
>    317          reg = cifs_find_swn_reg(tcon);
>    318          if (IS_ERR(reg)) {
>    319                  return reg;
> 
> This code checks for errors but the cifs_find_swn_reg() function only
> returns NULL or valid pointers.
> 
>    320          } else if (reg != NULL) {
>    321                  kref_get(&reg->ref_count);
>    322                  mutex_unlock(&cifs_swnreg_idr_mutex);
>    323                  return reg;
>    324          }
>    325  
>    326          reg = kmalloc(sizeof(struct cifs_swn_reg),
> GFP_ATOMIC);
>    327          if (reg == NULL) {
>    328                  mutex_unlock(&cifs_swnreg_idr_mutex);
>    329                  return ERR_PTR(-ENOMEM);
>    330          }
> 
> regards,
> dan carpenter

Hello Dan,

thank you for the feedback and the detailed analysis. I wanted to refer
to this email in the patch I have just send to the list but I have to
improve my git send-email knowledge first.

Regards,

-- 
Samuel Cabrero / SUSE Labs Samba Team
GPG: D7D6 E259 F91C F0B3 2E61 1239 3655 6EC9 7051 0856
scabrero@suse.com
scabrero@suse.de

