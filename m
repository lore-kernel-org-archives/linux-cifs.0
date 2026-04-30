Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D48E3FBEA3;
	Thu, 30 Apr 2026 08:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777536968; cv=none; b=NFRyn2EBL36r5oLdsKRrmUQHdQkzbZ8RUoL2NgIRrrCIi4Hm9ntl2wPM7Uv9HtnXhguINZfkwvy4RAe3/aVN2cUlm+i8RM7gl+jcJsy9QXm5R/zOpI/VQbgz8h+UA9WHVHf+78OcwRIsEahFsX19bz5RazwqHBo252pg3525NJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777536968; c=relaxed/simple;
	bh=nNc09jnoJHgCs8XfAA6jn5DCZcc//vq0Xyqf8q+70sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZgtWJxbteT013aXfWyeyDj6GWaCKxGWQRZw8P+/NpRpP72TVxPVFdcRle7nWta5WGpcyjEXD+0Yvr2dgi+7sNhX1zac5Ekl3zwwR3Bw4GnVoRXKJyvbOtU8pxkDFDEQSD58nMC+caenQdxhAaMVGXS70EXFi7KCJYp1tvpRGQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CYkl67TU; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CYkl67TU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777536967; x=1809072967;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=nNc09jnoJHgCs8XfAA6jn5DCZcc//vq0Xyqf8q+70sw=;
  b=CYkl67TUG7gpEZ+zm39jrJJdpKbAoJTIBO52F3dwM1hQ7f6FrU/8/8Ha
   C00IIJ40hz5OaRQ7pVjGj4O4/zgUa2sEGoYUMwiAfkju4LfNNvGsA5r5I
   +BgvExsqe3KrwVCm+4WqQGm4aAC8bOuA3NJ7WbnUfvaihOr7GLZhXM0XT
   4qHSebP2HJ1XRfuwdvsRuw65XoQ+ECqw1dRqGvYg25KyptiJNt1QjjyR8
   SGCapFk5maDvl715ckSC52NRRIDvwDJe0FMzCavrsfSAjgpBweGRBZMCe
   7iKm3OB+5C4EVQw0QkE0ND7GIfxZlj4eRet/Kejx7s1xKsQUa4xs9HP8A
   w==;
X-CSE-ConnectionGUID: 0AFoqdILSG+npfnKTCJ4hg==
X-CSE-MsgGUID: KwIjnpHeROi8W/NXbJ2W7A==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="103934138"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="103934138"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 01:16:06 -0700
X-CSE-ConnectionGUID: UwlkE/3zT8mSpHkl5lpyBg==
X-CSE-MsgGUID: hqfwesjfQaWrJS/8diNheQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="239503745"
Received: from lkp-server01.sh.intel.com (HELO aa799cca880d) ([10.239.97.150])
  by fmviesa005.fm.intel.com with ESMTP; 30 Apr 2026 01:16:03 -0700
Received: from kbuild by aa799cca880d with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1wIMYy-00000000C9Q-3S0W;
	Thu, 30 Apr 2026 08:16:00 +0000
Date: Thu, 30 Apr 2026 16:15:48 +0800
From: kernel test robot <lkp@intel.com>
To: Yi Kuo <yi@yikuo.dev>, smfrench@gmail.com, linkinjeon@kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, metze@samba.org,
	tom@talpey.com, linux-cifs@vger.kernel.org,
	samba-technical@lists.samba.org, linux-kernel@vger.kernel.org,
	Yi Kuo <yi@yikuo.dev>
Subject: Re: [PATCH] smb: smbdirect: fix MR registration for coalesced SG
 lists
Message-ID: <202604301612.XQrb9dxs-lkp@intel.com>
References: <4bf423bb.AU4AAJbgzlAAAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8Ww0@mailjet.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bf423bb.AU4AAJbgzlAAAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8Ww0@mailjet.com>

Hi Yi,

kernel test robot noticed the following build warnings:

[auto build test WARNING on v7.1-rc1]
[also build test WARNING on linus/master next-20260429]
[cannot apply to brauner-vfs/vfs.all]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yi-Kuo/smb-smbdirect-fix-MR-registration-for-coalesced-SG-lists/20260429-221606
base:   v7.1-rc1
patch link:    https://lore.kernel.org/r/4bf423bb.AU4AAJbgzlAAAAAAAAAABAMtJJMAAYKKIjQAAAAAAC-ZZgBp8Ww0%40mailjet.com
patch subject: [PATCH] smb: smbdirect: fix MR registration for coalesced SG lists
config: x86_64-rhel-9.4-rust (https://download.01.org/0day-ci/archive/20260430/202604301612.XQrb9dxs-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260430/202604301612.XQrb9dxs-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202604301612.XQrb9dxs-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/smb/smbdirect/mr.c:304:6: warning: variable 'ret' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
     304 |         if (!num_mapped) {
         |             ^~~~~~~~~~~
   fs/smb/smbdirect/mr.c:361:40: note: uninitialized use occurs here
     361 |         smbdirect_socket_schedule_cleanup(sc, ret);
         |                                               ^~~
   fs/smb/smbdirect/internal.h:63:23: note: expanded from macro 'smbdirect_socket_schedule_cleanup'
      63 |                 __func__, __LINE__, __error, NULL)
         |                                     ^~~~~~~
   fs/smb/smbdirect/mr.c:304:2: note: remove the 'if' if its condition is always false
     304 |         if (!num_mapped) {
         |         ^~~~~~~~~~~~~~~~~~
     305 |                 smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
         |                 ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     306 |                         "ib_dma_map_sg num_pages=%u dir=%x num_mapped=%d\n",
         |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     307 |                         num_pages, mr->dir, num_mapped);
         |                         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     308 |                 goto dma_map_error;
         |                 ~~~~~~~~~~~~~~~~~~~
     309 |         }
         |         ~
   fs/smb/smbdirect/mr.c:272:9: note: initialize the variable 'ret' to silence this warning
     272 |         int ret, num_pages, num_mapped;
         |                ^
         |                 = 0
   1 warning generated.


vim +304 fs/smb/smbdirect/mr.c

   256	
   257	/*
   258	 * Register memory for RDMA read/write
   259	 * iter: the buffer to register memory with
   260	 * writing: true if this is a RDMA write (SMB read), false for RDMA read
   261	 * need_invalidate: true if this MR needs to be locally invalidated after I/O
   262	 * return value: the MR registered, NULL if failed.
   263	 */
   264	struct smbdirect_mr_io *
   265	smbdirect_connection_register_mr_io(struct smbdirect_socket *sc,
   266					    struct iov_iter *iter,
   267					    bool writing,
   268					    bool need_invalidate)
   269	{
   270		const struct smbdirect_socket_parameters *sp = &sc->parameters;
   271		struct smbdirect_mr_io *mr;
   272		int ret, num_pages, num_mapped;
   273		struct ib_reg_wr *reg_wr;
   274	
   275		num_pages = iov_iter_npages(iter, sp->max_frmr_depth + 1);
   276		if (num_pages > sp->max_frmr_depth) {
   277			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
   278				"num_pages=%d max_frmr_depth=%d\n",
   279				num_pages, sp->max_frmr_depth);
   280			WARN_ON_ONCE(1);
   281			return NULL;
   282		}
   283	
   284		mr = smbdirect_connection_get_mr_io(sc);
   285		if (!mr) {
   286			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
   287				"smbdirect_connection_get_mr_io returning NULL\n");
   288			return NULL;
   289		}
   290	
   291		mutex_lock(&mr->mutex);
   292	
   293		mr->dir = writing ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
   294		mr->need_invalidate = need_invalidate;
   295		mr->sgt.nents = 0;
   296		mr->sgt.orig_nents = 0;
   297	
   298		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_INFO,
   299			"num_pages=%u count=%zu depth=%u\n",
   300			num_pages, iov_iter_count(iter), sp->max_frmr_depth);
   301		smbdirect_iter_to_sgt(iter, &mr->sgt, sp->max_frmr_depth);
   302	
   303		num_mapped = ib_dma_map_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
 > 304		if (!num_mapped) {
   305			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
   306				"ib_dma_map_sg num_pages=%u dir=%x num_mapped=%d\n",
   307				num_pages, mr->dir, num_mapped);
   308			goto dma_map_error;
   309		}
   310	
   311		ret = ib_map_mr_sg(mr->mr, mr->sgt.sgl, num_mapped, NULL, PAGE_SIZE);
   312		if (ret != num_mapped) {
   313			smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
   314				"ib_map_mr_sg failed ret = %d num_mapped = %u\n",
   315				ret, num_mapped);
   316			goto map_mr_error;
   317		}
   318	
   319		ib_update_fast_reg_key(mr->mr, ib_inc_rkey(mr->mr->rkey));
   320		reg_wr = &mr->wr;
   321		reg_wr->wr.opcode = IB_WR_REG_MR;
   322		mr->cqe.done = smbdirect_connection_mr_io_register_done;
   323		reg_wr->wr.wr_cqe = &mr->cqe;
   324		reg_wr->wr.num_sge = 0;
   325		reg_wr->wr.send_flags = IB_SEND_SIGNALED;
   326		reg_wr->mr = mr->mr;
   327		reg_wr->key = mr->mr->rkey;
   328		reg_wr->access = writing ?
   329				IB_ACCESS_REMOTE_WRITE | IB_ACCESS_LOCAL_WRITE :
   330				IB_ACCESS_REMOTE_READ;
   331	
   332		/*
   333		 * There is no need for waiting for complemtion on ib_post_send
   334		 * on IB_WR_REG_MR. Hardware enforces a barrier and order of execution
   335		 * on the next ib_post_send when we actually send I/O to remote peer
   336		 */
   337		ret = ib_post_send(sc->ib.qp, &reg_wr->wr, NULL);
   338		if (!ret) {
   339			/*
   340			 * smbdirect_connection_get_mr_io() gave us a reference
   341			 * via kref_get(&mr->kref), we keep that and let
   342			 * the caller use smbdirect_connection_deregister_mr_io()
   343			 * to remove it again.
   344			 */
   345			mutex_unlock(&mr->mutex);
   346			return mr;
   347		}
   348	
   349		smbdirect_log_rdma_mr(sc, SMBDIRECT_LOG_ERR,
   350			"ib_post_send failed ret=%d (%1pe) reg_wr->key=0x%x\n",
   351			ret, SMBDIRECT_DEBUG_ERR_PTR(ret), reg_wr->key);
   352	
   353	map_mr_error:
   354		ib_dma_unmap_sg(sc->ib.dev, mr->sgt.sgl, mr->sgt.nents, mr->dir);
   355	
   356	dma_map_error:
   357		mr->sgt.nents = 0;
   358		mr->state = SMBDIRECT_MR_ERROR;
   359		atomic_dec(&sc->mr_io.used.count);
   360	
   361		smbdirect_socket_schedule_cleanup(sc, ret);
   362	
   363		/*
   364		 * smbdirect_connection_get_mr_io() gave us a reference
   365		 * via kref_get(&mr->kref), we need to remove it again
   366		 * on error.
   367		 *
   368		 * No kref_put_mutex() as it's already locked.
   369		 *
   370		 * If smbdirect_mr_io_free_locked() is called
   371		 * and the mutex is unlocked and mr is gone,
   372		 * in that case kref_put() returned 1.
   373		 *
   374		 * If kref_put() returned 0 we know that
   375		 * smbdirect_mr_io_free_locked() didn't
   376		 * run. Not by us nor by anyone else, as we
   377		 * still hold the mutex, so we need to unlock.
   378		 */
   379		if (!kref_put(&mr->kref, smbdirect_mr_io_free_locked))
   380			mutex_unlock(&mr->mutex);
   381		return NULL;
   382	}
   383	__SMBDIRECT_EXPORT_SYMBOL__(smbdirect_connection_register_mr_io);
   384	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
