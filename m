Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="BpbaqW3Z"
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07FF5DB
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 16:58:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700960328; x=1732496328;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZbZINUI83zaCyKvdHCdtELLli1ssnufDX6rUkcbtuKQ=;
  b=BpbaqW3ZugPInp06B7mohRRVP/CvAr1kBF+Vc9hexozw67tPVF5dBHgY
   iYcy9t/7JQniCqivwF+xbBEJrqhZz/cU9ckiywFhXrPs8nr3Nzqfy8QCi
   U+UGSzf4xhImiY+lW0psNo4tPAifFBFijCFky4oT+po8+eIM8XDblhu7t
   aQo7rOpaVdEn5viIY0phumtGeLeDbZyqVuLIQmDJOrQpBzgCjdx0qh/T4
   4ooLTUAo78+d0WqtensW7I38Ass7k981g4s5u9pkvbj0Ay9Wc99yiYDzH
   fiszyqk0jjO9OWri+AF7XJnER2MW90frpL9HlTgH8rrdZ7mgXCWqGhuUF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10905"; a="396445982"
X-IronPort-AV: E=Sophos;i="6.04,227,1695711600"; 
   d="scan'208";a="396445982"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2023 16:58:47 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10905"; a="767801033"
X-IronPort-AV: E=Sophos;i="6.04,227,1695711600"; 
   d="scan'208";a="767801033"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 Nov 2023 16:58:45 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r73Tv-0004c4-2V;
	Sun, 26 Nov 2023 00:58:43 +0000
Date: Sun, 26 Nov 2023 08:56:25 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: [PATCH 3/8] smb: client: allow creating symlinks via reparse
 points
Message-ID: <202311260838.nx5mkj1j-lkp@intel.com>
References: <20231125220813.30538-4-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125220813.30538-4-pc@manguebit.com>

Hi Paulo,

kernel test robot noticed the following build warnings:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on next-20231124]
[cannot apply to linus/master v6.7-rc2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Paulo-Alcantara/smb-client-extend-smb2_compound_op-to-accept-more-commands/20231126-061137
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20231125220813.30538-4-pc%40manguebit.com
patch subject: [PATCH 3/8] smb: client: allow creating symlinks via reparse points
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231126/202311260838.nx5mkj1j-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231126/202311260838.nx5mkj1j-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311260838.nx5mkj1j-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/smb/client/smb2ops.c:5267:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
           if (!IS_ERR(new))
               ^~~~~~~~~~~~
   fs/smb/client/smb2ops.c:5275:9: note: uninitialized use occurs here
           return rc;
                  ^~
   fs/smb/client/smb2ops.c:5267:2: note: remove the 'if' if its condition is always false
           if (!IS_ERR(new))
           ^~~~~~~~~~~~~~~~~
   fs/smb/client/smb2ops.c:5227:8: note: initialize the variable 'rc' to silence this warning
           int rc;
                 ^
                  = 0
   1 warning generated.


vim +5267 fs/smb/client/smb2ops.c

  5211	
  5212	static int smb2_create_reparse_symlink(const unsigned int xid,
  5213					       struct inode *inode,
  5214					       struct dentry *dentry,
  5215					       struct cifs_tcon *tcon,
  5216					       const char *full_path,
  5217					       const char *symname)
  5218	{
  5219		struct reparse_symlink_data_buffer *buf = NULL;
  5220		struct cifs_open_info_data data;
  5221		struct cifs_sb_info *cifs_sb = CIFS_SB(inode->i_sb);
  5222		struct inode *new;
  5223		struct kvec iov;
  5224		__le16 *path;
  5225		char *sym;
  5226		u16 len, plen;
  5227		int rc;
  5228	
  5229		sym = kstrdup(symname, GFP_KERNEL);
  5230		if (!sym)
  5231			return -ENOMEM;
  5232	
  5233		data = (struct cifs_open_info_data) {
  5234			.reparse_point = true,
  5235			.reparse = { .tag = IO_REPARSE_TAG_SYMLINK, },
  5236			.symlink_target = sym,
  5237		};
  5238	
  5239		path = cifs_convert_path_to_utf16(symname, cifs_sb);
  5240		if (!path) {
  5241			rc = -ENOMEM;
  5242			goto out;
  5243		}
  5244	
  5245		plen = 2 * UniStrnlen((wchar_t *)path, PATH_MAX);
  5246		len = sizeof(*buf) + plen * 2;
  5247		buf = kzalloc(len, GFP_KERNEL);
  5248		if (!buf) {
  5249			rc = -ENOMEM;
  5250			goto out;
  5251		}
  5252	
  5253		buf->ReparseTag = cpu_to_le32(IO_REPARSE_TAG_SYMLINK);
  5254		buf->ReparseDataLength = cpu_to_le16(len - sizeof(struct reparse_data_buffer));
  5255		buf->SubstituteNameOffset = cpu_to_le16(plen);
  5256		buf->SubstituteNameLength = cpu_to_le16(plen);
  5257		memcpy((u8 *)buf->PathBuffer + plen, path, plen);
  5258		buf->PrintNameOffset = 0;
  5259		buf->PrintNameLength = cpu_to_le16(plen);
  5260		memcpy(buf->PathBuffer, path, plen);
  5261		buf->Flags = cpu_to_le32(*symname != '/' ? SYMLINK_FLAG_RELATIVE : 0);
  5262	
  5263		iov.iov_base = buf;
  5264		iov.iov_len = len;
  5265		new = smb2_get_reparse_inode(&data, inode->i_sb, xid,
  5266					     tcon, full_path, &iov);
> 5267		if (!IS_ERR(new))
  5268			d_instantiate(dentry, new);
  5269		else
  5270			rc = PTR_ERR(new);
  5271	out:
  5272		kfree(path);
  5273		cifs_free_open_info(&data);
  5274		kfree(buf);
  5275		return rc;
  5276	}
  5277	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
