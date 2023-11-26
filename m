Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bDDDedsa"
Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 474C3E4
	for <linux-cifs@vger.kernel.org>; Sat, 25 Nov 2023 16:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700957702; x=1732493702;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=BxkeV4UVJIMT3JGg5wMp4/DRheO7sVldnNmLGPQGs4U=;
  b=bDDDedsaY82QFb3x4RaLaQyT608bj14KMZSkamWWN3k54zuTAPQk48OO
   ACE/vbpfoOa4HUcyuOwkiZ4yZvIukpOoCF5uSGkl2QX/N7ZNs6t0FooBA
   rtzdc1XFXrUZSG/Zh9Uq4Gd2AMBaJ+syMARjOx8BTLdcalCtYIQk6VRW9
   MO58YCdwb4lEuJWWY5/PFTS3ptwM2vE+mw57phSyKCO6RX3UG75VwMO3c
   Q8ZAjqcKxyjgj6Br13XlOq3mlrLsS4NuDRnu77kpaCmPxwZF68eqT43xk
   dCMN2M0dlqqrHK366m3mzkojqedD3MBFhmwSSoJc0EaQuPw8fArW1XNTu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10905"; a="423679237"
X-IronPort-AV: E=Sophos;i="6.04,227,1695711600"; 
   d="scan'208";a="423679237"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Nov 2023 16:15:01 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10905"; a="744198509"
X-IronPort-AV: E=Sophos;i="6.04,227,1695711600"; 
   d="scan'208";a="744198509"
Received: from lkp-server01.sh.intel.com (HELO d584ee6ebdcc) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 25 Nov 2023 16:15:00 -0800
Received: from kbuild by d584ee6ebdcc with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r72nZ-0004an-2l;
	Sun, 26 Nov 2023 00:14:57 +0000
Date: Sun, 26 Nov 2023 08:14:00 +0800
From: kernel test robot <lkp@intel.com>
To: Paulo Alcantara <pc@manguebit.com>, smfrench@gmail.com
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	linux-cifs@vger.kernel.org, Paulo Alcantara <pc@manguebit.com>
Subject: Re: [PATCH 2/8] smb: client: allow creating special files via
 reparse points
Message-ID: <202311260746.HOJ039BV-lkp@intel.com>
References: <20231125220813.30538-3-pc@manguebit.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231125220813.30538-3-pc@manguebit.com>

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
patch link:    https://lore.kernel.org/r/20231125220813.30538-3-pc%40manguebit.com
patch subject: [PATCH 2/8] smb: client: allow creating special files via reparse points
config: x86_64-rhel-8.3-rust (https://download.01.org/0day-ci/archive/20231126/202311260746.HOJ039BV-lkp@intel.com/config)
compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231126/202311260746.HOJ039BV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311260746.HOJ039BV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> fs/smb/client/inode.c:1320:6: warning: variable 'rc' is used uninitialized whenever 'if' condition is false [-Wsometimes-uninitialized]
           if (!data) {
               ^~~~~
   fs/smb/client/inode.c:1331:10: note: uninitialized use occurs here
           switch (rc) {
                   ^~
   fs/smb/client/inode.c:1320:2: note: remove the 'if' if its condition is always true
           if (!data) {
           ^~~~~~~~~~~
   fs/smb/client/inode.c:1310:8: note: initialize the variable 'rc' to silence this warning
           int rc;
                 ^
                  = 0
   1 warning generated.


vim +1320 fs/smb/client/inode.c

  1297	
  1298	static int smb311_posix_get_fattr(struct cifs_open_info_data *data,
  1299					  struct cifs_fattr *fattr,
  1300					  const char *full_path,
  1301					  struct super_block *sb,
  1302					  const unsigned int xid)
  1303	{
  1304		struct cifs_open_info_data tmp_data = {};
  1305		struct cifs_sb_info *cifs_sb = CIFS_SB(sb);
  1306		struct cifs_tcon *tcon;
  1307		struct tcon_link *tlink;
  1308		struct cifs_sid owner, group;
  1309		int tmprc;
  1310		int rc;
  1311	
  1312		tlink = cifs_sb_tlink(cifs_sb);
  1313		if (IS_ERR(tlink))
  1314			return PTR_ERR(tlink);
  1315		tcon = tlink_tcon(tlink);
  1316	
  1317		/*
  1318		 * 1. Fetch file metadata if not provided (data)
  1319		 */
> 1320		if (!data) {
  1321			rc = smb311_posix_query_path_info(xid, tcon, cifs_sb,
  1322							  full_path, &tmp_data,
  1323							  &owner, &group);
  1324			data = &tmp_data;
  1325		}
  1326	
  1327		/*
  1328		 * 2. Convert it to internal cifs metadata (fattr)
  1329		 */
  1330	
  1331		switch (rc) {
  1332		case 0:
  1333			if (cifs_open_data_reparse(data)) {
  1334				rc = reparse_info_to_fattr(data, sb, xid, tcon,
  1335							   full_path, fattr,
  1336							   &owner, &group);
  1337			} else {
  1338				smb311_posix_info_to_fattr(fattr, data,
  1339							   &owner, &group, sb);
  1340			}
  1341			break;
  1342		case -EREMOTE:
  1343			/* DFS link, no metadata available on this server */
  1344			cifs_create_junction_fattr(fattr, sb);
  1345			rc = 0;
  1346			break;
  1347		case -EACCES:
  1348			/*
  1349			 * For SMB2 and later the backup intent flag
  1350			 * is already sent if needed on open and there
  1351			 * is no path based FindFirst operation to use
  1352			 * to retry with so nothing we can do, bail out
  1353			 */
  1354			goto out;
  1355		default:
  1356			cifs_dbg(FYI, "%s: unhandled err rc %d\n", __func__, rc);
  1357			goto out;
  1358		}
  1359	
  1360		/*
  1361		 * 3. Tweak fattr based on mount options
  1362		 */
  1363		/* check for Minshall+French symlinks */
  1364		if (cifs_sb->mnt_cifs_flags & CIFS_MOUNT_MF_SYMLINKS) {
  1365			tmprc = check_mf_symlink(xid, tcon, cifs_sb, fattr, full_path);
  1366			cifs_dbg(FYI, "check_mf_symlink: %d\n", tmprc);
  1367		}
  1368	
  1369	out:
  1370		cifs_put_tlink(tlink);
  1371		cifs_free_open_info(data);
  1372		return rc;
  1373	}
  1374	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
