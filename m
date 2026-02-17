Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E70361DC9
	for <linux-cifs@vger.kernel.org>; Tue, 17 Feb 2026 14:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771338088; cv=none; b=hCYK0Mkw09rDY9xQU9ESVUDxFDv2JgKZf/+VdBN29FgDRQjGkm6kk//v1tlQ6FLf/oKUBA7wHVA2b8OUUtBeInVMNqsIFz3A+7y1DFvQwfnEW5yDAnYJZgsX+CzURKiwNj07i50Ga5gfDLredj/G6ELcDHbZ8a75XYolbsnr8GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771338088; c=relaxed/simple;
	bh=yh8yI0pA2IC49VM1mkQGE9oegUnSGDSBb9jbcHkmXR4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gDgk4jBbp48kDqydQE3vQwJ1SJs09skiCBauIssBfg4wyXjH058PPyzKSNMjsxi3b2hSNYD0NU29VlVDjDFKB5IUYYX+f11+AKR1iEY/azdCa7it2lDGdsP+p/KYSCNleq3OWOy00EQvAix6JaJIgHhK4CPDq9ktqD/3euo645Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SJX14wxJ; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SJX14wxJ"
Message-ID: <db00bf7d-7c48-48be-8c82-f4de18dab0cb@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771338074;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kyNZFDzhoTu4AT90j02RmeG2oMbrc5FDBUSzxGrR/V4=;
	b=SJX14wxJalSD1OwWT/S238N3eIKTcQLNKwA8C20MBgc6/EkhEqjHJrvjzdWPTFico+ueCE
	+FqPVTY/Kt44VXk2+Ft9SBh+3QNUx7mzonvj/l6DVVkDoenRQpfoyQBezmtIhu0n8ePrC/
	cf1+1fZAS1hR2f/CJxbqGiITonOU3e8=
Date: Tue, 17 Feb 2026 22:20:59 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v3 4/5] smb: introduce struct create_posix_ctxt_rsp
To: kernel test robot <lkp@intel.com>, smfrench@gmail.com,
 linkinjeon@kernel.org, chenxiaosong@kylinos.cn,
 chenxiaosong.chenxiaosong@linux.dev
Cc: oe-kbuild-all@lists.linux.dev, linux-cifs@vger.kernel.org,
 ZhangGuoDong <zhangguodong@kylinos.cn>
References: <20260216082018.156695-5-zhang.guodong@linux.dev>
 <202602170244.C33LgPOh-lkp@intel.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ZhangGuoDong <zhang.guodong@linux.dev>
In-Reply-To: <202602170244.C33LgPOh-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

For patch 01 and patch 04, I followed these steps and did not observe 
any build warnings.

On 2026/2/17 02:22, kernel test robot wrote:
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on cifs/for-next]
> [also build test WARNING on brauner-vfs/vfs.all linus/master next-20260216]
> [cannot apply to v6.19]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:https://github.com/intel-lab-lkp/linux/commits/zhang-guodong-linux-dev/smb-move-smb3_fs_vol_info-into-common-fscc-h/20260216-162407
> base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> patch link:https://lore.kernel.org/r/20260216082018.156695-5-zhang.guodong%40linux.dev
> patch subject: [PATCH v3 4/5] smb: introduce struct create_posix_ctxt_rsp
> config: i386-randconfig-r123-20260216 (https://download.01.org/0day-ci/archive/20260217/202602170244.C33LgPOh-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project  87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260217/202602170244.C33LgPOh-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot<lkp@intel.com>
> | Closes:https://lore.kernel.org/oe-kbuild-all/202602170244.C33LgPOh-lkp@intel.com/
