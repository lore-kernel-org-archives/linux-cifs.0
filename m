Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1C928EA;
	Mon,  7 Oct 2024 21:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728336848; cv=none; b=HsENCbmQpLwsm2YFeSTWWxsQ1PbBVPszcBczR16N8uuEQ5vEyPA8+tiGX0CEjM0lHb9TYM9ihBA+ghn60PHspHYgadO5w0+r2blwJdVa0bVdvNb+ArXGCPSUqU3VRPvuXRJJ2oUWsO5Cht82yLMlKPgrpiRvuM6wrDvBZ2j1b+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728336848; c=relaxed/simple;
	bh=8P+cQjNG1zDXxIBlXpZLQl5scVg2urlD+SFpAccQZQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKpKz4jD8wE39+BJZ7xvtbtLOoO2QoduyI5rvsEl26rsIaqzihtFZBCL3Aqz50atm4g9oIXODrW8qL7PWEBkQYOYuoo4C0lLT0+uEhP1eeR7DaW9AzBGUvJqII6SOsBJUbDshqsixKFsp4uz70CTb4bAbT/mUTZbYUbGYwteRfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QYc9b1Oc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QYc9b1Oc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40C3C4CEC6;
	Mon,  7 Oct 2024 21:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728336848;
	bh=8P+cQjNG1zDXxIBlXpZLQl5scVg2urlD+SFpAccQZQ4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QYc9b1OcjaDA60SlFCUkGi+lVXSVzy57zYyPq055TqUAlheoG3cV0MKeH/lEgk6+G
	 EyiYLt7vxITDEiYgFFo7K8CRaA1QLO0yZgm6aVOyBqz+IL+JRnQLSrly8/Rm7kFS8A
	 fnkYlbBfPbtUzTcFqQB/kVoFUpkM3wTEjAyeNepzenEZ2FJpoMMmjiK2RCas1t4pQH
	 veJe7Br81K7JzNArlYbHWG8/7pUgCg2rO8QDRPgaVKFQ0qbQYBwXC5REPmSGQ0BKS8
	 bWixn/JcFy9mgoqOGCFgF9K2smfjBWfltiRkuIB/yU57cpSviySmsIL5A2BhZ+HPbz
	 l5er/UQd0Dydg==
Received: by pali.im (Postfix)
	id AE1BF792; Mon,  7 Oct 2024 23:34:01 +0200 (CEST)
Date: Mon, 7 Oct 2024 23:34:01 +0200
From: Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, Steve French <sfrench@samba.org>,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH] cifs: Add support for parsing WSL-style symlinks
Message-ID: <20241007213401.bsfqwlb4c2k6ynlr@pali>
References: <20241006090548.30053-1-pali@kernel.org>
 <202410080458.o4vvmJkR-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202410080458.o4vvmJkR-lkp@intel.com>
User-Agent: NeoMutt/20180716

On Tuesday 08 October 2024 04:21:30 kernel test robot wrote:
> Hi Pali,
> 
> kernel test robot noticed the following build warnings:
> 
> [auto build test WARNING on cifs/for-next]
> [also build test WARNING on linus/master v6.12-rc2 next-20241004]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Pali-Roh-r/cifs-Add-support-for-parsing-WSL-style-symlinks/20241006-170802
> base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> patch link:    https://lore.kernel.org/r/20241006090548.30053-1-pali%40kernel.org
> patch subject: [PATCH] cifs: Add support for parsing WSL-style symlinks
> config: x86_64-randconfig-122-20241008 (https://download.01.org/0day-ci/archive/20241008/202410080458.o4vvmJkR-lkp@intel.com/config)
> compiler: clang version 18.1.8 (https://github.com/llvm/llvm-project 3b5b5c1ec4a3095ab096dd780e84d7ab81f3d7ff)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241008/202410080458.o4vvmJkR-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202410080458.o4vvmJkR-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
> >> fs/smb/client/reparse.c:676:45: sparse: sparse: incorrect type in argument 4 (different base types) @@     expected unsigned short [usertype] *pwcs @@     got restricted __le16 [usertype] *[assigned] symname_utf16 @@
>    fs/smb/client/reparse.c:676:45: sparse:     expected unsigned short [usertype] *pwcs
>    fs/smb/client/reparse.c:676:45: sparse:     got restricted __le16 [usertype] *[assigned] symname_utf16
> 
> vim +676 fs/smb/client/reparse.c
> 
>    646	
>    647	static int parse_reparse_wsl_symlink(struct reparse_wsl_symlink_data_buffer *buf,
>    648					     struct cifs_sb_info *cifs_sb,
>    649					     struct cifs_open_info_data *data)
>    650	{
>    651		int len = le16_to_cpu(buf->ReparseDataLength);
>    652		int symname_utf8_len;
>    653		__le16 *symname_utf16;
>    654		int symname_utf16_len;
>    655	
>    656		if (len <= sizeof(buf->Flags)) {
>    657			cifs_dbg(VFS, "srv returned malformed wsl symlink buffer\n");
>    658			return -EIO;
>    659		}
>    660	
>    661		/* PathBuffer is in UTF-8 but without trailing null-term byte */
>    662		symname_utf8_len = len - sizeof(buf->Flags);
>    663		/*
>    664		 * Check that buffer does not contain null byte
>    665		 * because Linux cannot process symlink with null byte.
>    666		 */
>    667		if (strnlen(buf->PathBuffer, symname_utf8_len) != symname_utf8_len) {
>    668			cifs_dbg(VFS, "srv returned null byte in wsl symlink target location\n");
>    669			return -EIO;
>    670		}
>    671		symname_utf16 = kzalloc(symname_utf8_len * 2, GFP_KERNEL);
>    672		if (!symname_utf16)
>    673			return -ENOMEM;
>    674		symname_utf16_len = utf8s_to_utf16s(buf->PathBuffer, symname_utf8_len,
>    675						    UTF16_LITTLE_ENDIAN,
>  > 676						    symname_utf16, symname_utf8_len * 2);

Hello, I'm not sure if there is a real problem or it is just a
false-positive report. Please look at it.

I saw that in cifs code is common pattern to use __le16* type for
UTF-16-LE string.

Kernel nls library function utf8s_to_utf16s for output buffer is
expecting wchar_t* type, also for the case when it is encoding to
UTF-16-LE (requested by UTF16_LITTLE_ENDIAN).

And cifs_strndup_from_utf16 for input UTF-16-LE string is using u8*
type.

So what kind of type for symname_utf16 buffer should be used? It stores
UTF-16-LE string. Type u8*, u16*, __le16*, wchar_t* or short*?

I guess that it should be possible to mute this report by adding another
explicit cast and call utf8s_to_utf16s() with "(wchar_t*)symname_utf16"
as 4th parameter.

>    677		if (symname_utf16_len < 0) {
>    678			kfree(symname_utf16);
>    679			return symname_utf16_len;
>    680		}
>    681		symname_utf16_len *= 2; /* utf8s_to_utf16s() returns number of u16 items, not byte length */
>    682	
>    683		data->symlink_target = cifs_strndup_from_utf16((u8 *)symname_utf16,
>    684							       symname_utf16_len, true,
>    685							       cifs_sb->local_nls);
>    686		kfree(symname_utf16);
>    687		if (!data->symlink_target)
>    688			return -ENOMEM;
>    689	
>    690		return 0;
>    691	}
>    692	
> 
> -- 
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki
