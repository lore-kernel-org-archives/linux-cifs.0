Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02DA3ECAAD8
	for <linux-cifs@archiver.kernel.org>; Wed, 14 Sep 2022 11:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiINLQD (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 14 Sep 2022 07:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiINLQC (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Wed, 14 Sep 2022 07:16:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E184212097
        for <linux-cifs@vger.kernel.org>; Wed, 14 Sep 2022 04:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663154160; x=1694690160;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=Ve5G6RljcZi3XkeCt8l/DuL0KRRa2YhWnruA2f2BVsc=;
  b=bqbsAyg36SYAGh5kBCEP4xpqmuSwf3xteNxx9LSn4v637/2AsbBIQzQl
   bGLld2Hbb8i/mfoIdgGn8m84Yfh8BoEEBxTUCocKBuFUiP8kSN/mJ61Pl
   JmoIXoEYlEj1cF+fp+Wx2HB0bPWMw6Jo6YG7RdTsp9I09cEskLqlVSqGC
   fzQZnHeljuadIfTLAcnQ0AluS0yoEFCsaZp4dWYE/grIFFHXsQ6ux0aPD
   Rl3geCc1KBi//93FssS3hrzoUB+EK7NszgZVpMs0KDzok2TQlewYEzt8D
   GwnKs2QAt3jEyhFuFUUFWyJOOdqkFaXHl9OLSxRStNFPRKwcIwiTEDx1x
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10469"; a="360141698"
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="360141698"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Sep 2022 04:16:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,315,1654585200"; 
   d="scan'208";a="945475342"
Received: from lkp-server01.sh.intel.com (HELO d6e6b7c4e5a2) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 14 Sep 2022 04:15:58 -0700
Received: from kbuild by d6e6b7c4e5a2 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oYQN3-00008O-2x;
        Wed, 14 Sep 2022 11:15:57 +0000
Date:   Wed, 14 Sep 2022 19:15:21 +0800
From:   kernel test robot <lkp@intel.com>
To:     Steve French <stfrench@microsoft.com>
Cc:     kbuild-all@lists.01.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org
Subject: [cifs:gmac-signing-access-denied 14/16] fs/cifs/smb2transport.c:772:
 warning: expecting prototype for smb311_crypt_sign(). Prototype was for
 smb311_gmac_sign() instead
Message-ID: <202209141918.88hEOscp-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

tree:   git://git.samba.org/sfrench/cifs-2.6.git gmac-signing-access-denied
head:   2192d9439564a639ab2e9bc5d6c6ee64cb34283c
commit: 320f9b7ac776d203158be1d06147e94ca8fa794b [14/16] part2
config: m68k-allyesconfig (https://download.01.org/0day-ci/archive/20220914/202209141918.88hEOscp-lkp@intel.com/config)
compiler: m68k-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git remote add cifs git://git.samba.org/sfrench/cifs-2.6.git
        git fetch --no-tags cifs gmac-signing-access-denied
        git checkout 320f9b7ac776d203158be1d06147e94ca8fa794b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=m68k SHELL=/bin/bash fs/cifs/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> fs/cifs/smb2transport.c:772: warning: expecting prototype for smb311_crypt_sign(). Prototype was for smb311_gmac_sign() instead


vim +772 fs/cifs/smb2transport.c

a7ecf7c2064db8 Steve French 2022-09-14  734  
a7ecf7c2064db8 Steve French 2022-09-14  735  /**
a7ecf7c2064db8 Steve French 2022-09-14  736   * smb311_crypt_sign() - Encrypts, decrypts, or sign an SMB2 message using AES-GCM algorithm.
a7ecf7c2064db8 Steve French 2022-09-14  737   *
a7ecf7c2064db8 Steve French 2022-09-14  738   * @rqst: SMB2 request to transform.
a7ecf7c2064db8 Steve French 2022-09-14  739   * @num_rqst: Number of requests to transform.  Must be 1 if @sign_only is true.
a7ecf7c2064db8 Steve French 2022-09-14  740   * @enc: True for an encryption operation, false for decryption.  If both @enc and @sign_only are
a7ecf7c2064db8 Steve French 2022-09-14  741   *	 true, assumes an encryption operation and set @sign_only to false.
a7ecf7c2064db8 Steve French 2022-09-14  742   * @sign_only: True if the request must only have the signature computed.
a7ecf7c2064db8 Steve French 2022-09-14  743   * @tfm: AES-GCM crypto transformation object.  Must be allocated and freed by the caller.
a7ecf7c2064db8 Steve French 2022-09-14  744   * @key: The private key to be used for the operation.  Must be allocated and freed by the caller.
a7ecf7c2064db8 Steve French 2022-09-14  745   * @keylen: The size of @key.  Must be 16 for AES-128-GCM crypt ops and AES-GMAC, or 32 for
a7ecf7c2064db8 Steve French 2022-09-14  746   *	    AES-256-GCM.
a7ecf7c2064db8 Steve French 2022-09-14  747   * @iv: The Initialization Vector, a.k.a. nonce.  Must be allocated and freed by the caller.
a7ecf7c2064db8 Steve French 2022-09-14  748   * @assoclen: Size of the Additional Authenticated Data (AAD) (or Associated Data (AD)).  Must be
a7ecf7c2064db8 Steve French 2022-09-14  749   *	      size of smb2_transform_hdr - 20 for encryption/decryption, and the size of the whole
a7ecf7c2064db8 Steve French 2022-09-14  750   *	      SMB2 message for signing (e.g gotten from smb_rqst_len()).
a7ecf7c2064db8 Steve French 2022-09-14  751   * @cryptlen: Size of the plain/cipher text buffer.  Must be 0 if @sign_only is true.
a7ecf7c2064db8 Steve French 2022-09-14  752   *
a7ecf7c2064db8 Steve French 2022-09-14  753   * This function is shared between the SMB 3.1.1 AES-GCM encryption/decryption operations
a7ecf7c2064db8 Steve French 2022-09-14  754   * (crypt_message()), and AES-GMAC signing operation (smb311_calc_aes_gmac()).
a7ecf7c2064db8 Steve French 2022-09-14  755   *
a7ecf7c2064db8 Steve French 2022-09-14  756   * This function will perform the core operations (encrypt and decrypt) using the parameters passed
a7ecf7c2064db8 Steve French 2022-09-14  757   * by the callers, which is what differ encrypt/decrypt ops from signing ops.
a7ecf7c2064db8 Steve French 2022-09-14  758   *
a7ecf7c2064db8 Steve French 2022-09-14  759   * Note that signing functionality (@sign_only == true) must only be used when the request must NOT
a7ecf7c2064db8 Steve French 2022-09-14  760   * be encrypted, as encrypted requests will have their own signatures, but computed differently.
a7ecf7c2064db8 Steve French 2022-09-14  761   *
a7ecf7c2064db8 Steve French 2022-09-14  762   * References:
a7ecf7c2064db8 Steve French 2022-09-14  763   * MS-SMB2 3.2.4.1.1 "Signing the Message"
a7ecf7c2064db8 Steve French 2022-09-14  764   *
a7ecf7c2064db8 Steve French 2022-09-14  765   * Return: 0 on success, negative errno otherwise.
a7ecf7c2064db8 Steve French 2022-09-14  766   */
a7ecf7c2064db8 Steve French 2022-09-14  767  static int smb311_gmac_sign(struct smb_rqst *rqst, int num_rqst,
320f9b7ac776d2 Steve French 2022-09-14  768  			    unsigned long assoclen,
a7ecf7c2064db8 Steve French 2022-09-14  769  			    struct crypto_aead *tfm,
a7ecf7c2064db8 Steve French 2022-09-14  770  			    const u8 *key, unsigned int keylen,
a7ecf7c2064db8 Steve French 2022-09-14  771  			    u8 *iv)
a7ecf7c2064db8 Steve French 2022-09-14 @772  {
a7ecf7c2064db8 Steve French 2022-09-14  773  	struct smb2_hdr *shdr = (struct smb2_hdr *)rqst[0].rq_iov[0].iov_base;
a7ecf7c2064db8 Steve French 2022-09-14  774  	u8 sig[SMB2_SIGNATURE_SIZE] = { 0 };
a7ecf7c2064db8 Steve French 2022-09-14  775  	struct aead_request *aead_req;
a7ecf7c2064db8 Steve French 2022-09-14  776  	DECLARE_CRYPTO_WAIT(wait);
a7ecf7c2064db8 Steve French 2022-09-14  777  	struct scatterlist *sg;
a7ecf7c2064db8 Steve French 2022-09-14  778  	int rc = 0;
a7ecf7c2064db8 Steve French 2022-09-14  779  
a7ecf7c2064db8 Steve French 2022-09-14  780  	/* basic checks */
a7ecf7c2064db8 Steve French 2022-09-14  781  	if (!rqst || !tfm || !key || !iv)
a7ecf7c2064db8 Steve French 2022-09-14  782  		return -EINVAL;
a7ecf7c2064db8 Steve French 2022-09-14  783  
a7ecf7c2064db8 Steve French 2022-09-14  784  	if (unlikely(!rqst))
a7ecf7c2064db8 Steve French 2022-09-14  785  		return -ENODATA;
a7ecf7c2064db8 Steve French 2022-09-14  786  
a7ecf7c2064db8 Steve French 2022-09-14  787  	/* signing is done on single requests only */
a7ecf7c2064db8 Steve French 2022-09-14  788  	if (num_rqst > 1) {
a7ecf7c2064db8 Steve French 2022-09-14  789  		cifs_dbg(VFS, "%s: invalid number of requests to sign '%u', expected 1\n",
a7ecf7c2064db8 Steve French 2022-09-14  790  			 __func__, num_rqst);
a7ecf7c2064db8 Steve French 2022-09-14  791  		return -EINVAL;
a7ecf7c2064db8 Steve French 2022-09-14  792  	}
a7ecf7c2064db8 Steve French 2022-09-14  793  
a7ecf7c2064db8 Steve French 2022-09-14  794  	/*
a7ecf7c2064db8 Steve French 2022-09-14  795  	 * Set the Additional Authenticated Data (AAD)/Associated Data (AD) length to the SMB
a7ecf7c2064db8 Steve French 2022-09-14  796  	 * request length, which corresponds to the part of the buffer we want to sign/authenticate.
a7ecf7c2064db8 Steve French 2022-09-14  797  	 */
a7ecf7c2064db8 Steve French 2022-09-14  798  	if (unlikely(assoclen == 0)) {
a7ecf7c2064db8 Steve French 2022-09-14  799  		cifs_dbg(FYI, "%s: assoclen is 0 for signing operation\n", __func__);
a7ecf7c2064db8 Steve French 2022-09-14  800  		return -ENODATA;
a7ecf7c2064db8 Steve French 2022-09-14  801  	}
a7ecf7c2064db8 Steve French 2022-09-14  802  
a7ecf7c2064db8 Steve French 2022-09-14  803  	if (keylen != SMB3_GCM128_CRYPTKEY_SIZE) { /* 16 bytes, for AES-GMAC */
a7ecf7c2064db8 Steve French 2022-09-14  804  		cifs_dbg(FYI, "%s: invalid key size '%u'\n", __func__, keylen);
a7ecf7c2064db8 Steve French 2022-09-14  805  		return -EINVAL;
a7ecf7c2064db8 Steve French 2022-09-14  806  	}
a7ecf7c2064db8 Steve French 2022-09-14  807  
a7ecf7c2064db8 Steve French 2022-09-14  808  	rc = crypto_aead_setkey(tfm, key, keylen);
a7ecf7c2064db8 Steve French 2022-09-14  809  	if (rc) {
a7ecf7c2064db8 Steve French 2022-09-14  810  		cifs_dbg(VFS, "%s: Failed to set AEAD key, rc=%d\n", __func__, rc);
a7ecf7c2064db8 Steve French 2022-09-14  811  		return rc;
a7ecf7c2064db8 Steve French 2022-09-14  812  	}
a7ecf7c2064db8 Steve French 2022-09-14  813  
a7ecf7c2064db8 Steve French 2022-09-14  814  	rc = crypto_aead_setauthsize(tfm, SMB2_SIGNATURE_SIZE);
a7ecf7c2064db8 Steve French 2022-09-14  815  	if (rc) {
a7ecf7c2064db8 Steve French 2022-09-14  816  		cifs_dbg(VFS, "%s: Failed to set AEAD authsize, rc=%d\n",
a7ecf7c2064db8 Steve French 2022-09-14  817  			 __func__, rc);
a7ecf7c2064db8 Steve French 2022-09-14  818  		return rc;
a7ecf7c2064db8 Steve French 2022-09-14  819  	}
a7ecf7c2064db8 Steve French 2022-09-14  820  
a7ecf7c2064db8 Steve French 2022-09-14  821  	aead_req = aead_request_alloc(tfm, GFP_KERNEL);
a7ecf7c2064db8 Steve French 2022-09-14  822  	if (!aead_req) {
a7ecf7c2064db8 Steve French 2022-09-14  823  		cifs_dbg(VFS, "%s: Failed to alloc AEAD request\n", __func__);
a7ecf7c2064db8 Steve French 2022-09-14  824  		return -ENOMEM;
a7ecf7c2064db8 Steve French 2022-09-14  825  	}
a7ecf7c2064db8 Steve French 2022-09-14  826  
a7ecf7c2064db8 Steve French 2022-09-14  827  	sg = init_sg_gmac(num_rqst, rqst, sig);
a7ecf7c2064db8 Steve French 2022-09-14  828  	if (IS_ERR(sg)) {
a7ecf7c2064db8 Steve French 2022-09-14  829  		rc = PTR_ERR(sg);
a7ecf7c2064db8 Steve French 2022-09-14  830  		cifs_dbg(VFS, "%s: Failed to init SG, rc=%d\n", __func__, rc);
a7ecf7c2064db8 Steve French 2022-09-14  831  
a7ecf7c2064db8 Steve French 2022-09-14  832  		/* if -EIO, sg has been allocated */
a7ecf7c2064db8 Steve French 2022-09-14  833  		if (rc == -EIO)
a7ecf7c2064db8 Steve French 2022-09-14  834  			goto out_free_sg;
a7ecf7c2064db8 Steve French 2022-09-14  835  
a7ecf7c2064db8 Steve French 2022-09-14  836  		goto out_free_req;
a7ecf7c2064db8 Steve French 2022-09-14  837  	}
a7ecf7c2064db8 Steve French 2022-09-14  838  
a7ecf7c2064db8 Steve French 2022-09-14  839  	aead_request_set_crypt(aead_req, sg, sg, 0, iv);
a7ecf7c2064db8 Steve French 2022-09-14  840  	aead_request_set_ad(aead_req, assoclen);
a7ecf7c2064db8 Steve French 2022-09-14  841  	aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_BACKLOG,
a7ecf7c2064db8 Steve French 2022-09-14  842  				  crypto_req_done, &wait);
a7ecf7c2064db8 Steve French 2022-09-14  843  
a7ecf7c2064db8 Steve French 2022-09-14  844  	/*
a7ecf7c2064db8 Steve French 2022-09-14  845  	 * Note for AES-GMAC (@sign_only): whether signing or verifying a signature, we must
a7ecf7c2064db8 Steve French 2022-09-14  846  	 * always use the encrypt function, as AES-GCM decrypt will internally try to match the
a7ecf7c2064db8 Steve French 2022-09-14  847  	 * authentication codes, which were computed based on the ciphertext, and fail (-EBADMSG),
a7ecf7c2064db8 Steve French 2022-09-14  848  	 * as expected.
a7ecf7c2064db8 Steve French 2022-09-14  849  	 */
a7ecf7c2064db8 Steve French 2022-09-14  850  	rc = crypto_wait_req(crypto_aead_encrypt(aead_req), &wait);
a7ecf7c2064db8 Steve French 2022-09-14  851  	if (!rc) {
a7ecf7c2064db8 Steve French 2022-09-14  852  		memcpy(&shdr->Signature, sig, SMB2_SIGNATURE_SIZE);
a7ecf7c2064db8 Steve French 2022-09-14  853  	}
a7ecf7c2064db8 Steve French 2022-09-14  854  
a7ecf7c2064db8 Steve French 2022-09-14  855  out_free_sg:
a7ecf7c2064db8 Steve French 2022-09-14  856  	kfree(sg);
a7ecf7c2064db8 Steve French 2022-09-14  857  out_free_req:
a7ecf7c2064db8 Steve French 2022-09-14  858  	kfree(aead_req);
a7ecf7c2064db8 Steve French 2022-09-14  859  
a7ecf7c2064db8 Steve French 2022-09-14  860  	return rc;
a7ecf7c2064db8 Steve French 2022-09-14  861  }
a7ecf7c2064db8 Steve French 2022-09-14  862  

:::::: The code at line 772 was first introduced by commit
:::::: a7ecf7c2064db88102d9bc6080325078ee5ffad6 part1

:::::: TO: Steve French <stfrench@microsoft.com>
:::::: CC: Steve French <stfrench@microsoft.com>

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
