Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE3F3C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 21:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiAGVVT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 16:21:19 -0500
Received: from mga18.intel.com ([134.134.136.126]:65045 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229504AbiAGVVT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 7 Jan 2022 16:21:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641590479; x=1673126479;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZL87D5+MkhP7YBVzAQ1i5Bw8Dr5C7yowJOzzOxLI7Ns=;
  b=GylpZpUfGXnh/GYXkNh0gDXKahY4PbG0z4KenE/vZ2xbVEkTfPq8oJbk
   JFDRFu1N2t0oqb+wO4rhxjUN7hnO0E8KiuKgyDWxYO9Tlh94ieGcuS1BR
   tQsyBdni34oF2xMHWrKilSDAQJ2N+u+bIB1GKGmVpggDvsj56TI6QV6nl
   HMdX5mJRrDJxT9Ua2Iyg+xDT2pkInVdvPRDIbA+QUVeFH6D5ynhrKKUXK
   QDxZo0uFMEwUYU35EbpVs/udylz74rvPk11WC/SXPM5PsZgY4LLOkRpIf
   g8vRqyvlczQjz7OQ6qY/4S+wrw8W+5PNQbPFdeB2rxfu/hwtpjQr6asbw
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="229751023"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="229751023"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 13:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471430143"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 07 Jan 2022 13:21:16 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n5wfj-000J3I-P6; Fri, 07 Jan 2022 21:21:15 +0000
Date:   Sat, 8 Jan 2022 05:20:16 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>, smfrench@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: [PATCH 3/3] cifs: Eliminate cifs_readdata::pages
Message-ID: <202201080540.7GY9DVWv-lkp@intel.com>
References: <164149195200.2867367.8652749735914667514.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164149195200.2867367.8652749735914667514.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi David,

I love your patch! Yet something to improve:

[auto build test ERROR on next-20220105]
[cannot apply to cifs/for-next linus/master v5.16-rc8 v5.16-rc7 v5.16-rc6 v5.16-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Howells/cifs-Use-netfslib/20220107-025845
base:    7a769a3922d81cfc74ab4d90a9cc69485f260976
config: x86_64-randconfig-r021-20220107 (https://download.01.org/0day-ci/archive/20220108/202201080540.7GY9DVWv-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project f3a344d2125fa37e59bae1b0874442c650a19607)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/ed7e6fa413c08f7992992e2282f64df2a6894f10
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review David-Howells/cifs-Use-netfslib/20220107-025845
        git checkout ed7e6fa413c08f7992992e2282f64df2a6894f10
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All error/warnings (new ones prefixed by >>):

>> fs/cifs/file.c:2435:7: warning: variable 'len' is uninitialized when used here [-Wuninitialized]
                   if (len < max_len)
                       ^~~
   include/linux/compiler.h:56:47: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                                                 ^~~~
   include/linux/compiler.h:58:52: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                      ^~~~
   fs/cifs/file.c:2385:30: note: initialize the variable 'len' to silence this warning
           unsigned int xid, wsize, len, max_len;
                                       ^
                                        = 0
   1 warning generated.
--
>> fs/cifs/cifsencrypt.c:66:24: error: no member named 'rq_npages' in 'struct smb_rqst'
           for (i = 0; i < rqst->rq_npages; i++) {
                           ~~~~  ^
>> fs/cifs/cifsencrypt.c:70:3: error: implicit declaration of function 'rqst_page_get_length' [-Werror,-Wimplicit-function-declaration]
                   rqst_page_get_length(rqst, i, &len, &offset);
                   ^
>> fs/cifs/cifsencrypt.c:72:31: error: no member named 'rq_pages' in 'struct smb_rqst'
                   kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;
                                         ~~~~  ^
   fs/cifs/cifsencrypt.c:78:17: error: no member named 'rq_pages' in 'struct smb_rqst'
                           kunmap(rqst->rq_pages[i]);
                                  ~~~~  ^
   fs/cifs/cifsencrypt.c:82:16: error: no member named 'rq_pages' in 'struct smb_rqst'
                   kunmap(rqst->rq_pages[i]);
                          ~~~~  ^
   5 errors generated.
--
>> fs/cifs/smb2ops.c:4437:39: error: no member named 'rq_npages' in 'struct smb_rqst'
                   sg_len += rqst[i].rq_nvec + rqst[i].rq_npages;
                                               ~~~~~~~ ^
   fs/cifs/smb2ops.c:4456:27: error: no member named 'rq_npages' in 'struct smb_rqst'
                   for (j = 0; j < rqst[i].rq_npages; j++) {
                                   ~~~~~~~ ^
>> fs/cifs/smb2ops.c:4459:4: error: implicit declaration of function 'rqst_page_get_length' [-Werror,-Wimplicit-function-declaration]
                           rqst_page_get_length(&rqst[i], j, &len, &offset);
                           ^
>> fs/cifs/smb2ops.c:4460:36: error: no member named 'rq_pages' in 'struct smb_rqst'
                           sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, offset);
                                                   ~~~~~~~ ^
>> fs/cifs/smb2ops.c:4663:4: error: must use 'struct' tag to refer to type 'page'
                           page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
                           ^
                           struct 
>> fs/cifs/smb2ops.c:4663:9: error: expected identifier or '('
                           page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
                                ^
>> fs/cifs/smb2ops.c:4664:29: error: use of undeclared identifier 'page'
                           if (!xa_store(buffer, j, page, gfp))
                                                    ^
>> fs/cifs/smb2ops.c:4664:35: error: use of undeclared identifier 'gfp'
                           if (!xa_store(buffer, j, page, gfp))
                                                          ^
>> fs/cifs/smb2ops.c:4664:29: error: use of undeclared identifier 'page'
                           if (!xa_store(buffer, j, page, gfp))
                                                    ^
>> fs/cifs/smb2ops.c:4664:35: error: use of undeclared identifier 'gfp'
                           if (!xa_store(buffer, j, page, gfp))
                                                          ^
>> fs/cifs/smb2ops.c:4664:29: error: use of undeclared identifier 'page'
                           if (!xa_store(buffer, j, page, gfp))
                                                    ^
>> fs/cifs/smb2ops.c:4664:35: error: use of undeclared identifier 'gfp'
                           if (!xa_store(buffer, j, page, gfp))
                                                          ^
   fs/cifs/smb2ops.c:4668:28: error: use of undeclared identifier 'page'; did you mean 'pages'?
                           if (copy_page_from_iter(page, 0, seg, &old->rq_iter) != seg) {
                                                   ^~~~
                                                   pages
   include/linux/compiler.h:56:47: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                                                 ^
   include/linux/compiler.h:58:52: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                      ^
   fs/cifs/smb2ops.c:4644:16: note: 'pages' declared here
           struct page **pages;
                         ^
   fs/cifs/smb2ops.c:4668:28: error: use of undeclared identifier 'page'; did you mean 'pages'?
                           if (copy_page_from_iter(page, 0, seg, &old->rq_iter) != seg) {
                                                   ^~~~
                                                   pages
   include/linux/compiler.h:56:47: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                                                 ^
   include/linux/compiler.h:58:61: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                               ^
   fs/cifs/smb2ops.c:4644:16: note: 'pages' declared here
           struct page **pages;
                         ^
   fs/cifs/smb2ops.c:4668:28: error: use of undeclared identifier 'page'; did you mean 'pages'?
                           if (copy_page_from_iter(page, 0, seg, &old->rq_iter) != seg) {
                                                   ^~~~
                                                   pages
   include/linux/compiler.h:56:47: note: expanded from macro 'if'
   #define if(cond, ...) if ( __trace_if_var( !!(cond , ## __VA_ARGS__) ) )
                                                 ^
   include/linux/compiler.h:58:86: note: expanded from macro '__trace_if_var'
   #define __trace_if_var(cond) (__builtin_constant_p(cond) ? (cond) : __trace_if_value(cond))
                                                                                        ^
   include/linux/compiler.h:69:3: note: expanded from macro '__trace_if_value'
           (cond) ?                                        \
            ^
   fs/cifs/smb2ops.c:4644:16: note: 'pages' declared here
           struct page **pages;
                         ^
   fs/cifs/smb2ops.c:4718:7: error: no member named 'rq_pages' in 'struct smb_rqst'
           rqst.rq_pages = pages;
           ~~~~ ^
   fs/cifs/smb2ops.c:4719:7: error: no member named 'rq_npages' in 'struct smb_rqst'
           rqst.rq_npages = npages;
           ~~~~ ^
>> fs/cifs/smb2ops.c:4720:7: error: no member named 'rq_pagesz' in 'struct smb_rqst'
           rqst.rq_pagesz = PAGE_SIZE;
           ~~~~ ^
>> fs/cifs/smb2ops.c:4721:7: error: no member named 'rq_tailsz' in 'struct smb_rqst'
           rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
           ~~~~ ^
   19 errors generated.


vim +66 fs/cifs/cifsencrypt.c

^1da177e4c3f41 Linus Torvalds     2005-04-16  26  
16c568efff82e4 Al Viro            2015-11-12  27  int __cifs_calc_signature(struct smb_rqst *rqst,
16c568efff82e4 Al Viro            2015-11-12  28  			struct TCP_Server_Info *server, char *signature,
16c568efff82e4 Al Viro            2015-11-12  29  			struct shash_desc *shash)
84afc29b185334 Steve French       2005-12-02  30  {
e9917a000fcc37 Steve French       2006-03-31  31  	int i;
307fbd31b61623 Shirish Pargaonkar 2010-10-21  32  	int rc;
bf5ea0e2f29b00 Jeff Layton        2012-09-18  33  	struct kvec *iov = rqst->rq_iov;
bf5ea0e2f29b00 Jeff Layton        2012-09-18  34  	int n_vec = rqst->rq_nvec;
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  35  	int is_smb2 = server->vals->header_preamble_size == 0;
84afc29b185334 Steve French       2005-12-02  36  
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  37  	/* iov[0] is actual data and not the rfc1002 length for SMB2+ */
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  38  	if (is_smb2) {
83ffdeadb46b61 Paulo Alcantara    2018-06-15  39  		if (iov[0].iov_len <= 4)
83ffdeadb46b61 Paulo Alcantara    2018-06-15  40  			return -EIO;
83ffdeadb46b61 Paulo Alcantara    2018-06-15  41  		i = 0;
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  42  	} else {
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  43  		if (n_vec < 2 || iov[0].iov_len != 4)
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  44  			return -EIO;
83ffdeadb46b61 Paulo Alcantara    2018-06-15  45  		i = 1; /* skip rfc1002 length */
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  46  	}
c713c8770fa5bf Ronnie Sahlberg    2018-06-12  47  
83ffdeadb46b61 Paulo Alcantara    2018-06-15  48  	for (; i < n_vec; i++) {
745542e210b3b1 Jeff Layton        2007-11-03  49  		if (iov[i].iov_len == 0)
745542e210b3b1 Jeff Layton        2007-11-03  50  			continue;
e9917a000fcc37 Steve French       2006-03-31  51  		if (iov[i].iov_base == NULL) {
f96637be081141 Joe Perches        2013-05-04  52  			cifs_dbg(VFS, "null iovec entry\n");
e9917a000fcc37 Steve French       2006-03-31  53  			return -EIO;
745542e210b3b1 Jeff Layton        2007-11-03  54  		}
83ffdeadb46b61 Paulo Alcantara    2018-06-15  55  
16c568efff82e4 Al Viro            2015-11-12  56  		rc = crypto_shash_update(shash,
307fbd31b61623 Shirish Pargaonkar 2010-10-21  57  					 iov[i].iov_base, iov[i].iov_len);
14cae3243b555a Shirish Pargaonkar 2011-06-20  58  		if (rc) {
f96637be081141 Joe Perches        2013-05-04  59  			cifs_dbg(VFS, "%s: Could not update with payload\n",
14cae3243b555a Shirish Pargaonkar 2011-06-20  60  				 __func__);
14cae3243b555a Shirish Pargaonkar 2011-06-20  61  			return rc;
14cae3243b555a Shirish Pargaonkar 2011-06-20  62  		}
14cae3243b555a Shirish Pargaonkar 2011-06-20  63  	}
84afc29b185334 Steve French       2005-12-02  64  
fb308a6f22f7f4 Jeff Layton        2012-09-18  65  	/* now hash over the rq_pages array */
fb308a6f22f7f4 Jeff Layton        2012-09-18 @66  	for (i = 0; i < rqst->rq_npages; i++) {
4c0d2a5a64332c Long Li            2018-05-30  67  		void *kaddr;
4c0d2a5a64332c Long Li            2018-05-30  68  		unsigned int len, offset;
16c568efff82e4 Al Viro            2015-11-12  69  
4c0d2a5a64332c Long Li            2018-05-30 @70  		rqst_page_get_length(rqst, i, &len, &offset);
4c0d2a5a64332c Long Li            2018-05-30  71  
4c0d2a5a64332c Long Li            2018-05-30 @72  		kaddr = (char *) kmap(rqst->rq_pages[i]) + offset;
16c568efff82e4 Al Viro            2015-11-12  73  
a12d0c590cc7ae Paulo Alcantara    2018-06-23  74  		rc = crypto_shash_update(shash, kaddr, len);
a12d0c590cc7ae Paulo Alcantara    2018-06-23  75  		if (rc) {
a12d0c590cc7ae Paulo Alcantara    2018-06-23  76  			cifs_dbg(VFS, "%s: Could not update with payload\n",
a12d0c590cc7ae Paulo Alcantara    2018-06-23  77  				 __func__);
a12d0c590cc7ae Paulo Alcantara    2018-06-23  78  			kunmap(rqst->rq_pages[i]);
a12d0c590cc7ae Paulo Alcantara    2018-06-23  79  			return rc;
a12d0c590cc7ae Paulo Alcantara    2018-06-23  80  		}
fb308a6f22f7f4 Jeff Layton        2012-09-18  81  
fb308a6f22f7f4 Jeff Layton        2012-09-18  82  		kunmap(rqst->rq_pages[i]);
fb308a6f22f7f4 Jeff Layton        2012-09-18  83  	}
fb308a6f22f7f4 Jeff Layton        2012-09-18  84  
16c568efff82e4 Al Viro            2015-11-12  85  	rc = crypto_shash_final(shash, signature);
14cae3243b555a Shirish Pargaonkar 2011-06-20  86  	if (rc)
16c568efff82e4 Al Viro            2015-11-12  87  		cifs_dbg(VFS, "%s: Could not generate hash\n", __func__);
84afc29b185334 Steve French       2005-12-02  88  
307fbd31b61623 Shirish Pargaonkar 2010-10-21  89  	return rc;
84afc29b185334 Steve French       2005-12-02  90  }
84afc29b185334 Steve French       2005-12-02  91  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
