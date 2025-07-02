Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639B223371F
	for <linux-cifs@vger.kernel.org>; Wed,  2 Jul 2025 11:32:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751455935; cv=none; b=cTdIAZTm9UmYEaz590FARJsCYJNCLHkY85ec5WaFYTxDgJxgC7ysv+efBDaWP5xvoE9viBKPQ99CuK2uXXyNquzUft+nai65ENDitTdcMsVMGlhgTiavK7jzpZ4yxhNqRBrpLm+vlCtNFn5nU7GB+9fVaA60o68jjxxnzKge4Zg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751455935; c=relaxed/simple;
	bh=8c3aao5B5d5K3zl9VsbOpHueQYawZS5TIDF4gkLkUUw=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=EqfjPP6OO4yoDM+/ESZGXzSaNGL8d+YdIvjdoa8SACvZOVrm/BJEUYd20euOt3bld2uGvihzfYFLixsA7yLBdRMR5AIqrD+VD5jJFgEgPRMAs9R8E0qcESGJ4vfCYcqtz3weQ9gdEwcDpx5jk9uTidzXG/TBAYkkPPXee4hyWxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g4uRBGuN; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g4uRBGuN"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-407a3913049so3500527b6e.2
        for <linux-cifs@vger.kernel.org>; Wed, 02 Jul 2025 04:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751455932; x=1752060732; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=x4Y1y13yCkRHmnRCrDrrhpA7TeCfFXTgGMfjT0ToZ9I=;
        b=g4uRBGuNkRF0zRwJH4+iZ0XfFUP9fDg83r9AS2B1EfV1XcxDiubPuU3nc/bL/EIkKu
         PpuY88HTBslyYd8lB9JACPRN4HQmekLq8337x1IvVyMm2lR4dAuVymVEtgOZOv3QWks2
         Vvv1BqtGU7dm/eqgF8pgbcBOmgTgWtsHLzWKgw3QFpRfsZm+vsyw9G/ztT5F5ILJVjhB
         4a5/KNXpDcVQe6YBwQmV23dj+Oz5Mpf5xUd0Pv7fAiNNCeBCd6qWN9AVbEPNfBFaxipx
         5BRASSDStAUF2eRwWngPGnbPqDsUuYU62enz4oBV9ZH6EhvUmHXQ6RezKMaFAF0AM/oI
         IHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751455932; x=1752060732;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=x4Y1y13yCkRHmnRCrDrrhpA7TeCfFXTgGMfjT0ToZ9I=;
        b=j/Rnu69iqB7VjAg8PxykUepo/YimHgQTcm68uLXUBBj1FsKs3XNy/Cs4XaOixTjxHX
         14n9r7jKTPH0J+mJVeByMaERZGlwahSOnIGkWBshkd9f2aGrrXuQKqUhSiRT+pk6c0PG
         Uc5M3xi8YA9C+gkIa7zzVf6PiCmBsNXtnXBefojQPLycfI/+LtBg6WOHTzjxOSDbxHYc
         JJzRVFigkqdW+fQ2nWUlFuHJWCBxqWHbu4apVWUv2Ik9FpIs1Q1u/YKreYwVux7HheBn
         S9vfgrVyat9CfFy5XiPZiKcYtDXY0Wk2Vwa7aRfZta9D1H7ZUVrJ7fcvjdc3UopmRCkZ
         11Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXcjwDGHgsCvvmg/gE0AD1a5DXcOmZ1w5JHKotCIJRVDK5E9NsOrGL7l8r+rHbIU/DHhWJ5INoBdOSJ@vger.kernel.org
X-Gm-Message-State: AOJu0YxxQ4ZhcnwslzncPIb9E/SGx7H3x9g7ZDPplTdMkH9IJBwiunb5
	eyvBjgy2echtEWjVjJAWBpT7xb/bHoao9GuJwt/RxhQBDlEHRzTxVtExP0LIzEij7QI=
X-Gm-Gg: ASbGnctwPODQtjfLF+SWG1XptTuKNiwWohNv2pTfk7H33ORNmqJaS4TCCof7FcPj9Fy
	qSqimvG7+ZPz4g+/ksqNQsxmergGkpKi1M2fq7vyKyYjUSlTimU2nr9DY27vNtMJ3PTLBExbnDh
	LjtF5Qww3nIs5IjdD9s6uVqoE878/6g9tbvH1tQqmYdx+gu+a4NNeLTDLe9o+/iUBQ3wLpINKoi
	U5wJmkXcQqQhDyGgoYk/NbXxc6/Djq+qUs2A4+ycRE81dPHmf2jjqA8qP5DqresXVGAkYLqrYiS
	s0V3g1smSuMLBY32dSQk0CmcM6MRuX8yf1bctdsndrWaaiCWk4fzwNHDXoWw8oo0vr2HsQ==
X-Google-Smtp-Source: AGHT+IFyKq5rEMVPtEgavLoBwXpcrYM8Qxn2pfFz3SJi1lLjb8ePns26Q87Mc61H6XXCimZfAyibnw==
X-Received: by 2002:a05:6808:1b24:b0:404:8e:69c2 with SMTP id 5614622812f47-40b883e942emr1659326b6e.0.1751455932236;
        Wed, 02 Jul 2025 04:32:12 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:8ebc:82eb:65f7:565e])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-40b324054a2sm2535930b6e.31.2025.07.02.04.32.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 04:32:10 -0700 (PDT)
Date: Wed, 2 Jul 2025 14:32:08 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Bharath SM <bharathsm.hsk@gmail.com>,
	linux-cifs@vger.kernel.org, smfrench@gmail.com, pc@manguebit.com,
	sprasad@microsoft.com, paul@darkrain42.org,
	henrique.carvalho@suse.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Bharath SM <bharathsm@microsoft.com>
Subject: Re: [PATCH 2/2] smb: invalidate and close cached directory when
 creating child entries
Message-ID: <eebd401c-4e31-4282-af33-7dff1503c937@suswa.mountain>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250630185303.12087-1-bharathsm@microsoft.com>

Hi Bharath,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Bharath-SM/smb-invalidate-and-close-cached-directory-when-creating-child-entries/20250701-025420
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
patch link:    https://lore.kernel.org/r/20250630185303.12087-1-bharathsm%40microsoft.com
patch subject: [PATCH 2/2] smb: invalidate and close cached directory when creating child entries
config: i386-randconfig-141-20250702 (https://download.01.org/0day-ci/archive/20250702/202507021119.3IUZ9mSr-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202507021119.3IUZ9mSr-lkp@intel.com/

smatch warnings:
fs/smb/client/dir.c:361 cifs_do_create() warn: iterator used outside loop: 'parent_cfid'

vim +/parent_cfid +361 fs/smb/client/dir.c

67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  310  	/*
67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  311  	 * if we're not using unix extensions, see if we need to set
67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  312  	 * ATTR_READONLY on the create call
67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  313  	 */
f818dd55c4a8b3 fs/cifs/dir.c       Steve French      2009-01-19  314  	if (!tcon->unix_ext && (mode & S_IWUGO) == 0)
67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  315  		create_options |= CREATE_OPTION_READONLY;
67750fb9e07940 fs/cifs/dir.c       Jeff Layton       2008-05-09  316  
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  317  
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  318  retry_open:
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  319  	if (tcon->cfids && direntry->d_parent && server->dialect >= SMB30_PROT_ID) {
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  320  		parent_cfid = NULL;

This assignment should be removed because the parent_cfid pointer will
be set again inside the list_for_each_entry() loop.

037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  321  		spin_lock(&tcon->cfids->cfid_list_lock);
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  322  		list_for_each_entry(parent_cfid, &tcon->cfids->entries, entry) {
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  323  			if (parent_cfid->dentry == direntry->d_parent) {
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  324  				cifs_dbg(FYI, "found a parent cached file handle\n");
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  325  				if (parent_cfid->has_lease && parent_cfid->time) {
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  326  					lease_flags
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  327  						|= SMB2_LEASE_FLAG_PARENT_LEASE_KEY_SET_LE;
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  328  					memcpy(fid->parent_lease_key,
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  329  					       parent_cfid->fid.lease_key,
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  330  					       SMB2_LEASE_KEY_SIZE);
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  331  					parent_cfid->dirents.is_valid = false;
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  332  				}
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  333  				break;
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  334  			}
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  335  		}

After the loop if we don't hit a break then parent_cfid will point to
invalid memory.  (It won't be NULL).

037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  336  		spin_unlock(&tcon->cfids->cfid_list_lock);
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  337  	}
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  338  
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  339  	oparms = (struct cifs_open_parms) {
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  340  		.tcon = tcon,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  341  		.cifs_sb = cifs_sb,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  342  		.desired_access = desired_access,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  343  		.create_options = cifs_create_options(cifs_sb, create_options),
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  344  		.disposition = disposition,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  345  		.path = full_path,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  346  		.fid = fid,
037e1bae588eac fs/smb/client/dir.c Henrique Carvalho 2025-05-28  347  		.lease_flags = lease_flags,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  348  		.mode = mode,
de036dcaca65cf fs/cifs/dir.c       Volker Lendecke   2023-01-11  349  	};
226730b4d8adae fs/cifs/dir.c       Pavel Shilovsky   2013-07-05  350  	rc = server->ops->open(xid, &oparms, oplock, buf);
^1da177e4c3f41 fs/cifs/dir.c       Linus Torvalds    2005-04-16  351  	if (rc) {
f96637be081141 fs/cifs/dir.c       Joe Perches       2013-05-04  352  		cifs_dbg(FYI, "cifs_create returned 0x%x\n", rc);
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  353  		if (rc == -EACCES && rdwr_for_fscache == 1) {
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  354  			desired_access &= ~GENERIC_READ;
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  355  			rdwr_for_fscache = 2;
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  356  			goto retry_open;
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  357  		}
d2c127197dfc0b fs/cifs/dir.c       Miklos Szeredi    2012-06-05  358  		goto out;
c3b2a0c640bff7 fs/cifs/dir.c       Steve French      2009-02-20  359  	}
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  360  
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01 @361  	if (parent_cfid && !parent_cfid->dirents.is_valid)
                                                                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
So this check is reading from invalid memory.

129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  362  		close_cached_dir(parent_cfid);
129f2ba6d160a9 fs/smb/client/dir.c Bharath SM        2025-07-01  363  
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  364  	if (rdwr_for_fscache == 2)
e9e62243a3e232 fs/smb/client/dir.c David Howells     2024-04-02  365  		cifs_invalidate_cache(inode, FSCACHE_INVAL_DIO_WRITE);
c3b2a0c640bff7 fs/cifs/dir.c       Steve French      2009-02-20  366  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

