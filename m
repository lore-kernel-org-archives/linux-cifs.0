Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 305E0C433F5
	for <linux-cifs@archiver.kernel.org>; Fri,  7 Jan 2022 21:00:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiAGVAS (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Fri, 7 Jan 2022 16:00:18 -0500
Received: from mga04.intel.com ([192.55.52.120]:49486 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229486AbiAGVAS (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Fri, 7 Jan 2022 16:00:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641589218; x=1673125218;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j6VO1WYtmm2unFIVNrzNjDUk4iO7/jjuRqisic4oG6o=;
  b=jbBC+HNvQ8UIFAd78SJ2Rt6OSGvFMqOVEQBWYwT5qhhkvlZ144jdUrKn
   4q2k5EwumitDvp+ccffIWMWPtqnIVX6h8U5VkQK6RV+PpePrAFAaD5I8V
   2fT2tHqGMun+b2g38xJmCN8ocLVXghDUhUyL2SH4I/D85Av1TE6q+h3ke
   IZXOQn/Zsn1ghpG18vHDd2815zumyLVRTrzsKAtDzsjS6ThabGPcwTOJJ
   PqoJlD7W7yUDSflElKfv/hNINpnKInjtx9C8PLImvnR/pm3fAcrPLxf/V
   PEzl2f63eLWqxx0dGjzVpkIHxk6lbK2pmEn2ixGJhLMrAjSdsHbFYsjme
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10220"; a="241756671"
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="241756671"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2022 13:00:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,271,1635231600"; 
   d="scan'208";a="471425315"
Received: from lkp-server01.sh.intel.com (HELO e357b3ef1427) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 07 Jan 2022 13:00:15 -0800
Received: from kbuild by e357b3ef1427 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1n5wLP-000J20-2s; Fri, 07 Jan 2022 21:00:15 +0000
Date:   Sat, 8 Jan 2022 04:59:43 +0800
From:   kernel test robot <lkp@intel.com>
To:     David Howells <dhowells@redhat.com>, smfrench@gmail.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        nspmangalore@gmail.com, dhowells@redhat.com, jlayton@kernel.org,
        linux-cifs@vger.kernel.org, linux-cachefs@redhat.com
Subject: Re: [PATCH 3/3] cifs: Eliminate cifs_readdata::pages
Message-ID: <202201080434.84lhmayM-lkp@intel.com>
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

I love your patch! Perhaps something to improve:

[auto build test WARNING on next-20220105]
[cannot apply to cifs/for-next linus/master v5.16-rc8 v5.16-rc7 v5.16-rc6 v5.16-rc8]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/David-Howells/cifs-Use-netfslib/20220107-025845
base:    7a769a3922d81cfc74ab4d90a9cc69485f260976
config: hexagon-randconfig-r023-20220107 (https://download.01.org/0day-ci/archive/20220108/202201080434.84lhmayM-lkp@intel.com/config)
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
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash fs/cifs/ kernel/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   fs/cifs/smb2ops.c:4437:39: error: no member named 'rq_npages' in 'struct smb_rqst'
                   sg_len += rqst[i].rq_nvec + rqst[i].rq_npages;
                                               ~~~~~~~ ^
   fs/cifs/smb2ops.c:4456:27: error: no member named 'rq_npages' in 'struct smb_rqst'
                   for (j = 0; j < rqst[i].rq_npages; j++) {
                                   ~~~~~~~ ^
   fs/cifs/smb2ops.c:4459:4: error: implicit declaration of function 'rqst_page_get_length' [-Werror,-Wimplicit-function-declaration]
                           rqst_page_get_length(&rqst[i], j, &len, &offset);
                           ^
   fs/cifs/smb2ops.c:4460:36: error: no member named 'rq_pages' in 'struct smb_rqst'
                           sg_set_page(&sg[idx++], rqst[i].rq_pages[j], len, offset);
                                                   ~~~~~~~ ^
   fs/cifs/smb2ops.c:4663:4: error: must use 'struct' tag to refer to type 'page'
                           page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
                           ^
                           struct 
   fs/cifs/smb2ops.c:4663:9: error: expected identifier or '('
                           page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
                                ^
   fs/cifs/smb2ops.c:4664:29: error: use of undeclared identifier 'page'
                           if (!xa_store(buffer, j, page, gfp))
                                                    ^
   fs/cifs/smb2ops.c:4664:35: error: use of undeclared identifier 'gfp'
                           if (!xa_store(buffer, j, page, gfp))
                                                          ^
>> fs/cifs/smb2ops.c:4667:10: warning: comparison of distinct pointer types ('typeof (size) *' (aka 'unsigned int *') and 'typeof ((1UL << 18)) *' (aka 'unsigned long *')) [-Wcompare-distinct-pointer-types]
                           seg = min(size, PAGE_SIZE);
                                 ^~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:45:19: note: expanded from macro 'min'
   #define min(x, y)       __careful_cmp(x, y, <)
                           ^~~~~~~~~~~~~~~~~~~~~~
   include/linux/minmax.h:36:24: note: expanded from macro '__careful_cmp'
           __builtin_choose_expr(__safe_cmp(x, y), \
                                 ^~~~~~~~~~~~~~~~
   include/linux/minmax.h:26:4: note: expanded from macro '__safe_cmp'
                   (__typecheck(x, y) && __no_side_effects(x, y))
                    ^~~~~~~~~~~~~~~~~
   include/linux/minmax.h:20:28: note: expanded from macro '__typecheck'
           (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
                      ~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~
   fs/cifs/smb2ops.c:4668:28: error: use of undeclared identifier 'page'; did you mean 'pages'?
                           if (copy_page_from_iter(page, 0, seg, &old->rq_iter) != seg) {
                                                   ^~~~
                                                   pages
   fs/cifs/smb2ops.c:4644:16: note: 'pages' declared here
           struct page **pages;
                         ^
   fs/cifs/smb2ops.c:4718:7: error: no member named 'rq_pages' in 'struct smb_rqst'
           rqst.rq_pages = pages;
           ~~~~ ^
   fs/cifs/smb2ops.c:4719:7: error: no member named 'rq_npages' in 'struct smb_rqst'
           rqst.rq_npages = npages;
           ~~~~ ^
   fs/cifs/smb2ops.c:4720:7: error: no member named 'rq_pagesz' in 'struct smb_rqst'
           rqst.rq_pagesz = PAGE_SIZE;
           ~~~~ ^
   fs/cifs/smb2ops.c:4721:7: error: no member named 'rq_tailsz' in 'struct smb_rqst'
           rqst.rq_tailsz = (page_data_size % PAGE_SIZE) ? : PAGE_SIZE;
           ~~~~ ^
   1 warning and 13 errors generated.


vim +4667 fs/cifs/smb2ops.c

  4626	
  4627	/*
  4628	 * This function will initialize new_rq and encrypt the content.
  4629	 * The first entry, new_rq[0], only contains a single iov which contains
  4630	 * a smb2_transform_hdr and is pre-allocated by the caller.
  4631	 * This function then populates new_rq[1+] with the content from olq_rq[0+].
  4632	 *
  4633	 * The end result is an array of smb_rqst structures where the first structure
  4634	 * only contains a single iov for the transform header which we then can pass
  4635	 * to crypt_message().
  4636	 *
  4637	 * new_rq[0].rq_iov[0] :  smb2_transform_hdr pre-allocated by the caller
  4638	 * new_rq[1+].rq_iov[*] == old_rq[0+].rq_iov[*] : SMB2/3 requests
  4639	 */
  4640	static int
  4641	smb3_init_transform_rq(struct TCP_Server_Info *server, int num_rqst,
  4642			       struct smb_rqst *new_rq, struct smb_rqst *old_rq)
  4643	{
  4644		struct page **pages;
  4645		struct smb2_transform_hdr *tr_hdr = new_rq[0].rq_iov[0].iov_base;
  4646		unsigned int npages;
  4647		unsigned int orig_len = 0;
  4648		int i, j;
  4649		int rc = -ENOMEM;
  4650	
  4651		for (i = 1; i < num_rqst; i++) {
  4652			struct smb_rqst *old = &old_rq[i - 1];
  4653			struct smb_rqst *new = &new_rq[i];
  4654			struct xarray *buffer = &new->rq_buffer;
  4655			unsigned int npages;
  4656			size_t size = iov_iter_count(&old->rq_iter), seg;
  4657	
  4658			orig_len += size;
  4659			xa_init(buffer);
  4660	
  4661			npages = DIV_ROUND_UP(size, PAGE_SIZE);
  4662			for (j = 0; j < npages; j++) {
  4663				page = alloc_page(GFP_KERNEL|__GFP_HIGHMEM);
  4664				if (!xa_store(buffer, j, page, gfp))
  4665					goto err_free;
  4666	
> 4667				seg = min(size, PAGE_SIZE);
  4668				if (copy_page_from_iter(page, 0, seg, &old->rq_iter) != seg) {
  4669					rc = -EFAULT;
  4670					goto err_free;
  4671				}
  4672			}
  4673	
  4674			new->rq_iov = old->rq_iov;
  4675			new->rq_nvec = old->rq_nvec;
  4676		}
  4677	
  4678		/* fill the 1st iov with a transform header */
  4679		fill_transform_hdr(tr_hdr, orig_len, old_rq, server->cipher_type);
  4680	
  4681		rc = crypt_message(server, num_rqst, new_rq, 1);
  4682		cifs_dbg(FYI, "Encrypt message returned %d\n", rc);
  4683		if (rc)
  4684			goto err_free;
  4685	
  4686		return rc;
  4687	
  4688	err_free:
  4689		smb3_free_compound_rqst(num_rqst - 1, &new_rq[1]);
  4690		return rc;
  4691	}
  4692	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
