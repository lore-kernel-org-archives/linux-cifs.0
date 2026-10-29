Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793269198;
	b=N0eUr2QGhdcMAgKLUnyhXLw0Ys6ufLO6W5NRlU2GRrY2Kif1vYB82cxlPZCM10jVihF7
	 MbDN7RjdrJfF/21YSN1r5Zg0j+pSYxvCh4te+2Kn6mGc4T4FVrX/UQZxoB286Y8VVRiyF
	 pCaaXQVO8qwOcsN/EHIh9NCUwQCCEfJQF44qXfzDNnmgVin5VzklonqR53jicw7l3iHEJ
	 vQWF1jLQMHsPe0y5jmJBhbrnUDHgtm+PZauldzmM/T+FtYHd/D7dzNpzc5FSxb8p+CsNz
	 ltjxO2V5SK9Hq7QJ9Oa6H9rsqGrLrEOszn+1nL3joR23XVhgPviYKJUdMB/MRdwA4aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793269198;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Received:Date:From:To:
	 Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=zfY9oMoIW/0okd9xFFx3UCLsKMsJOADfA+RNZfH9SM0=;
	b=cyKSQQNIvmiRrmL6FsNJXYwWuYH0/o0EBJuU5+BwvWWUmVlmeneFiG6xlLZh2QM157r5
	 STxcSxUJ+9YLyIGkhV2avgXBD4SMZDz0hjutuPC1aUIuY4Nb6gJfG0hfV29tqQfE17aut
	 k+I2bLnXt1qh2U4A3IU5mEVZaMj/LHjHhMJBF9xREiOSLZZ6xRylhFr/cZQcdBA1WKMaj
	 gf89p1gi+prmX3YsaAnCRBO4Jdl/LYWvlN8kYpdz2NRnuViiLsY5bbkF8KvMS6oa+cam+
	 C2KQM/Ld6mc5/42GfR/W0SlE3R7WiqwUNS9ZQvyxV2wY5kg9PEtLFjiXEoqcMGJ+4EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cM9IhEPC;
	arc=none smtp.remote-ip=192.198.163.17
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150CE606A326;
	Thu, 29 Oct 2026 10:19:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 150CE606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=cM9IhEPC
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793269196; x=1824805196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Qt6D4YLPwSHv5zAOxXUaLkXyrpRhNSrHIbMspXroy44=;
  b=cM9IhEPCqBq+zO7PeJUhczV/19F6tI12u0jw53S/+D2fKqJGrpIGVm1z
   sCeYg5JBVb5AK4SAA2UBqDf9+dqs2t9BqOAnaE30XbY2g6NI2t6qjvFhw
   /G1ZgmIohvQTQr48h4qNxt2hvWgm/cQHOR/cTqpzAkDEiTpme3Ax8wFdc
   UsLIBM4g4eTpWHa3SOhjTqzHaTj8T9CYIB8slqBmyjrhrSO8hxmQwx830
   /2s+mW3PllCCvdZcCtZ5x5VOxEuzR4bz+NrCzVUxCAls5P/Gkyow9gLag
   o9HcRcPNKA4ePzT4fkiM0GmWCK4xCs7TCfhsbCjQNq/JLinjhRe2tchF3
   g==;
X-CSE-ConnectionGUID: egnb8z4LSd2/K1izSh96DQ==
X-CSE-MsgGUID: XECEAa4RQj+E97eRMg7oMA==
X-IronPort-AV: E=McAfee;i="6800,10657,11949"; a="2024005"
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="2024005"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2026 03:19:47 -0700
X-CSE-ConnectionGUID: H6ANZahERZeuR9ZW3Z4ybA==
X-CSE-MsgGUID: Iq/Jf3wIQGmkAMGQYBYpXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,184,1787036400"; 
   d="scan'208";a="4986684"
Received: from lkp-server01.sh.intel.com (HELO 0caa9d2d175c) ([10.239.97.150])
  by orviesa008.jf.intel.com with ESMTP; 29 Oct 2026 03:19:45 -0700
Received: from kbuild by 0caa9d2d175c with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1xMNEU-00000000ZxU-25rj;
	Thu, 29 Oct 2026 10:19:42 +0000
Date: Thu, 29 Oct 2026 18:19:34 +0800
From: kernel test robot <lkp@intel.com>
To: =?iso-8859-1?Q?Iv=E1n?= Ezequiel Rodriguez <ivanrwcm25@gmail.com>,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>, netfs@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Shyam Prasad N <sprasad@microsoft.com>,
	Steve French <stfrench@microsoft.com>,
	linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH netfs v1 2/2] netfs: add KUnit coverage for reissue
 prepare_write errno
Message-ID: <202610291753.Jr3HECY2-lkp@intel.com>
References: <20261028181229.1408342-3-ivanrwcm25@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261028181229.1408342-3-ivanrwcm25@gmail.com>

Hi Iván,

kernel test robot noticed the following build warnings:

[auto build test WARNING on brauner-vfs/vfs.all]
[also build test WARNING on linus/master v7.3 next-20261028]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Iv-n-Ezequiel-Rodriguez/netfs-preserve-prepare_write-errno-on-reissue/20261028-151228
base:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git vfs.all
patch link:    https://lore.kernel.org/r/20261028181229.1408342-3-ivanrwcm25%40gmail.com
patch subject: [PATCH netfs v1 2/2] netfs: add KUnit coverage for reissue prepare_write errno
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20261029/202610291753.Jr3HECY2-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 16.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261029/202610291753.Jr3HECY2-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202610291753.Jr3HECY2-lkp@intel.com/

All warnings (new ones prefixed by >>):

   fs/netfs/write_reissue_kunit.c: In function 'reissue_preserves_prep_error':
>> fs/netfs/write_reissue_kunit.c:61:1: warning: the frame size of 1400 bytes is larger than 1280 bytes [-Wframe-larger-than=]
      61 | }
         | ^


vim +61 fs/netfs/write_reissue_kunit.c

    25	
    26	/*
    27	 * prepare_write_failed() sets FAILED + errno, then write_retry still calls
    28	 * reissue_write().  Before the fix, reissue wiped error to 0 so terminated
    29	 * reported success and mapping_set_error(0) was a no-op.
    30	 */
    31	static void reissue_preserves_prep_error(struct kunit *test)
    32	{
    33		struct term_capture cap = {};
    34		struct netfs_io_request wreq = {};
    35		struct netfs_io_stream stream = {
    36			.source = NETFS_UPLOAD_TO_SERVER,
    37		};
    38		struct netfs_io_subrequest subreq = {
    39			.rreq = &wreq,
    40			.len = 1,
    41			.transferred = 0,
    42			.error = -EIO,
    43			.source = NETFS_UPLOAD_TO_SERVER,
    44		};
    45		char buf[1] = { 0 };
    46		struct kvec kvec = { .iov_base = buf, .iov_len = 1 };
    47		struct iov_iter source;
    48	
    49		__set_bit(NETFS_SREQ_FAILED, &subreq.flags);
    50		iov_iter_kvec(&source, ITER_SOURCE, &kvec, 1, 1);
    51	
    52		test->priv = &cap;
    53		kunit_activate_static_stub(test, netfs_write_subrequest_terminated,
    54					   capture_terminated);
    55	
    56		netfs_reissue_write(&stream, &subreq, &source);
    57	
    58		KUNIT_EXPECT_TRUE(test, cap.called);
    59		KUNIT_EXPECT_EQ(test, cap.transferred_or_error, -EIO);
    60		KUNIT_EXPECT_EQ(test, subreq.error, -EIO);
  > 61	}
    62	

--
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
