Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C99AEC00140
	for <linux-cifs@archiver.kernel.org>; Tue,  2 Aug 2022 04:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiHBEsK (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Tue, 2 Aug 2022 00:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiHBEsJ (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Tue, 2 Aug 2022 00:48:09 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90B5E010
        for <linux-cifs@vger.kernel.org>; Mon,  1 Aug 2022 21:48:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1659415687; x=1690951687;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=cmvWDelvajwuS0R/wan8vHLEblYgIj33UX79yEux5lg=;
  b=CEOnYQBRLxAubebDY49Tbnz7GFBO/FQ0UTrk3bI0shQv2Kbx3ozwmmHH
   D2Jky1zfrUpQZ6U8/vywQTyhmDsHNpnMphphCZZ1SfLE2jvcL3AQx4MkU
   NSg4uP00OFdmf+pqS6ajiP9UAHbzOWYxqkdt4+TfCPn3+PbI5bb59lasx
   7QhDAbtHfTznwQG3fZieJFmumZ7dJYPOT+viXqmVtIT7uz5KWB4QvrsQg
   ONjR+6FhM3NTmABy5iDEYyH9ySkZclsm+jx+Zy3AeJAfbyIY/nGqr3lO1
   Iz8QGzw/JCtPw92DBQVZEG40N4cBXW5UM/QwxK9BX7dVsalW6T6GmiG9w
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10426"; a="272362596"
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="272362596"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Aug 2022 21:48:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,210,1654585200"; 
   d="scan'208";a="578065396"
Received: from lkp-server01.sh.intel.com (HELO e0eace57cfef) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 01 Aug 2022 21:48:04 -0700
Received: from kbuild by e0eace57cfef with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oIjp6-000FhP-0T;
        Tue, 02 Aug 2022 04:48:04 +0000
Date:   Tue, 2 Aug 2022 12:47:11 +0800
From:   kernel test robot <lkp@intel.com>
To:     Enzo Matsumiya <ematsumiya@suse.de>, linux-cifs@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, smfrench@gmail.com,
        pc@cjr.nz, ronniesahlberg@gmail.com, nspmangalore@gmail.com
Subject: Re: [PATCH] cifs: move some bloat out of cifsfs.c to
 inode.c/file.c/dir.c
Message-ID: <202208021251.F3onzjl6-lkp@intel.com>
References: <20220801213622.18805-1-ematsumiya@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801213622.18805-1-ematsumiya@suse.de>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Enzo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on linus/master v5.19 next-20220728]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Enzo-Matsumiya/cifs-move-some-bloat-out-of-cifsfs-c-to-inode-c-file-c-dir-c/20220802-053657
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
config: i386-randconfig-r031-20220801 (https://download.01.org/0day-ci/archive/20220802/202208021251.F3onzjl6-lkp@intel.com/config)
compiler: clang version 16.0.0 (https://github.com/llvm/llvm-project 52cd00cabf479aa7eb6dbb063b7ba41ea57bce9e)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/d7e7fe7f0c75e89b86ce07dfb26774fc11330b61
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Enzo-Matsumiya/cifs-move-some-bloat-out-of-cifsfs-c-to-inode-c-file-c-dir-c/20220802-053657
        git checkout d7e7fe7f0c75e89b86ce07dfb26774fc11330b61
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=i386 SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/cifs/file.c:5375:8: warning: no previous prototype for function 'cifs_remap_file_range' [-Wmissing-prototypes]
   loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
          ^
   fs/cifs/file.c:5375:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
   ^
   static 
>> fs/cifs/file.c:5502:9: warning: no previous prototype for function 'cifs_copy_file_range' [-Wmissing-prototypes]
   ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
           ^
   fs/cifs/file.c:5502:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
   ^
   static 
   2 warnings generated.
--
>> fs/cifs/inode.c:3087:15: warning: no previous prototype for function 'cifs_alloc_inode' [-Wmissing-prototypes]
   struct inode *cifs_alloc_inode(struct super_block *sb)
                 ^
   fs/cifs/inode.c:3087:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   struct inode *cifs_alloc_inode(struct super_block *sb)
   ^
   static 
>> fs/cifs/inode.c:3123:6: warning: no previous prototype for function 'cifs_free_inode' [-Wmissing-prototypes]
   void cifs_free_inode(struct inode *inode)
        ^
   fs/cifs/inode.c:3123:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void cifs_free_inode(struct inode *inode)
   ^
   static 
>> fs/cifs/inode.c:3128:6: warning: no previous prototype for function 'cifs_evict_inode' [-Wmissing-prototypes]
   void cifs_evict_inode(struct inode *inode)
        ^
   fs/cifs/inode.c:3128:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void cifs_evict_inode(struct inode *inode)
   ^
   static 
>> fs/cifs/inode.c:3137:5: warning: no previous prototype for function 'cifs_write_inode' [-Wmissing-prototypes]
   int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
       ^
   fs/cifs/inode.c:3137:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int cifs_write_inode(struct inode *inode, struct writeback_control *wbc)
   ^
   static 
>> fs/cifs/inode.c:3143:5: warning: no previous prototype for function 'cifs_drop_inode' [-Wmissing-prototypes]
   int cifs_drop_inode(struct inode *inode)
       ^
   fs/cifs/inode.c:3143:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int cifs_drop_inode(struct inode *inode)
   ^
   static 
>> fs/cifs/inode.c:3161:12: warning: no previous prototype for function 'cifs_init_inodecache' [-Wmissing-prototypes]
   int __init cifs_init_inodecache(void)
              ^
   fs/cifs/inode.c:3161:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   int __init cifs_init_inodecache(void)
   ^
   static 
>> fs/cifs/inode.c:3174:6: warning: no previous prototype for function 'cifs_destroy_inodecache' [-Wmissing-prototypes]
   void cifs_destroy_inodecache(void)
        ^
   fs/cifs/inode.c:3174:1: note: declare 'static' if the function is not intended to be used outside of this translation unit
   void cifs_destroy_inodecache(void)
   ^
   static 
   7 warnings generated.


vim +/cifs_remap_file_range +5375 fs/cifs/file.c

  5374	
> 5375	loff_t cifs_remap_file_range(struct file *src_file, loff_t off,
  5376				     struct file *dst_file, loff_t destoff, loff_t len,
  5377				     unsigned int remap_flags)
  5378	{
  5379		struct inode *src_inode = file_inode(src_file);
  5380		struct inode *target_inode = file_inode(dst_file);
  5381		struct cifsFileInfo *smb_file_src = src_file->private_data;
  5382		struct cifsFileInfo *smb_file_target;
  5383		struct cifs_tcon *target_tcon;
  5384		unsigned int xid;
  5385		int rc;
  5386	
  5387		if (remap_flags & ~(REMAP_FILE_DEDUP | REMAP_FILE_ADVISORY))
  5388			return -EINVAL;
  5389	
  5390		cifs_dbg(FYI, "clone range\n");
  5391	
  5392		xid = get_xid();
  5393	
  5394		if (!src_file->private_data || !dst_file->private_data) {
  5395			rc = -EBADF;
  5396			cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
  5397			goto out;
  5398		}
  5399	
  5400		smb_file_target = dst_file->private_data;
  5401		target_tcon = tlink_tcon(smb_file_target->tlink);
  5402	
  5403		/*
  5404		 * Note: cifs case is easier than btrfs since server responsible for
  5405		 * checks for proper open modes and file type and if it wants
  5406		 * server could even support copy of range where source = target
  5407		 */
  5408		lock_two_nondirectories(target_inode, src_inode);
  5409	
  5410		if (len == 0)
  5411			len = src_inode->i_size - off;
  5412	
  5413		cifs_dbg(FYI, "about to flush pages\n");
  5414		/* should we flush first and last page first */
  5415		truncate_inode_pages_range(&target_inode->i_data, destoff,
  5416					   PAGE_ALIGN(destoff + len)-1);
  5417	
  5418		if (target_tcon->ses->server->ops->duplicate_extents)
  5419			rc = target_tcon->ses->server->ops->duplicate_extents(xid,
  5420				smb_file_src, smb_file_target, off, len, destoff);
  5421		else
  5422			rc = -EOPNOTSUPP;
  5423	
  5424		/* force revalidate of size and timestamps of target file now
  5425		   that target is updated on the server */
  5426		CIFS_I(target_inode)->time = 0;
  5427		/* although unlocking in the reverse order from locking is not
  5428		   strictly necessary here it is a little cleaner to be consistent */
  5429		unlock_two_nondirectories(src_inode, target_inode);
  5430	out:
  5431		free_xid(xid);
  5432		return rc < 0 ? rc : len;
  5433	}
  5434	
  5435	ssize_t cifs_file_copychunk_range(unsigned int xid,
  5436					struct file *src_file, loff_t off,
  5437					struct file *dst_file, loff_t destoff,
  5438					size_t len, unsigned int flags)
  5439	{
  5440		struct inode *src_inode = file_inode(src_file);
  5441		struct inode *target_inode = file_inode(dst_file);
  5442		struct cifsFileInfo *smb_file_src;
  5443		struct cifsFileInfo *smb_file_target;
  5444		struct cifs_tcon *src_tcon;
  5445		struct cifs_tcon *target_tcon;
  5446		ssize_t rc;
  5447	
  5448		cifs_dbg(FYI, "copychunk range\n");
  5449	
  5450		if (!src_file->private_data || !dst_file->private_data) {
  5451			rc = -EBADF;
  5452			cifs_dbg(VFS, "missing cifsFileInfo on copy range src file\n");
  5453			goto out;
  5454		}
  5455	
  5456		rc = -EXDEV;
  5457		smb_file_target = dst_file->private_data;
  5458		smb_file_src = src_file->private_data;
  5459		src_tcon = tlink_tcon(smb_file_src->tlink);
  5460		target_tcon = tlink_tcon(smb_file_target->tlink);
  5461	
  5462		if (src_tcon->ses != target_tcon->ses) {
  5463			cifs_dbg(VFS, "source and target of copy not on same server\n");
  5464			goto out;
  5465		}
  5466	
  5467		rc = -EOPNOTSUPP;
  5468		if (!target_tcon->ses->server->ops->copychunk_range)
  5469			goto out;
  5470	
  5471		/*
  5472		 * Note: cifs case is easier than btrfs since server responsible for
  5473		 * checks for proper open modes and file type and if it wants
  5474		 * server could even support copy of range where source = target
  5475		 */
  5476		lock_two_nondirectories(target_inode, src_inode);
  5477	
  5478		cifs_dbg(FYI, "about to flush pages\n");
  5479		/* should we flush first and last page first */
  5480		truncate_inode_pages(&target_inode->i_data, 0);
  5481	
  5482		rc = file_modified(dst_file);
  5483		if (!rc)
  5484			rc = target_tcon->ses->server->ops->copychunk_range(xid,
  5485				smb_file_src, smb_file_target, off, len, destoff);
  5486	
  5487		file_accessed(src_file);
  5488	
  5489		/* force revalidate of size and timestamps of target file now
  5490		 * that target is updated on the server
  5491		 */
  5492		CIFS_I(target_inode)->time = 0;
  5493		/* although unlocking in the reverse order from locking is not
  5494		 * strictly necessary here it is a little cleaner to be consistent
  5495		 */
  5496		unlock_two_nondirectories(src_inode, target_inode);
  5497	
  5498	out:
  5499		return rc;
  5500	}
  5501	
> 5502	ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
  5503				     struct file *dst_file, loff_t destoff,
  5504				     size_t len, unsigned int flags)
  5505	{
  5506		unsigned int xid = get_xid();
  5507		ssize_t rc;
  5508		struct cifsFileInfo *cfile = dst_file->private_data;
  5509	
  5510		if (cfile->swapfile)
  5511			return -EOPNOTSUPP;
  5512	
  5513		rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
  5514						len, flags);
  5515		free_xid(xid);
  5516	
  5517		if (rc == -EOPNOTSUPP || rc == -EXDEV)
  5518			rc = generic_copy_file_range(src_file, off, dst_file,
  5519						     destoff, len, flags);
  5520		return rc;
  5521	}
  5522	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
