Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF42C433EF
	for <linux-cifs@archiver.kernel.org>; Mon,  4 Apr 2022 03:23:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241965AbiDDDZA (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Sun, 3 Apr 2022 23:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238989AbiDDDYw (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Sun, 3 Apr 2022 23:24:52 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 688CC344E9
        for <linux-cifs@vger.kernel.org>; Sun,  3 Apr 2022 20:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649042576; x=1680578576;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oRil+Yo9z6BYRj1Uw0Elzso2MdS9Z+4lyr/UfIto4uo=;
  b=YOUP8i8yQVDhXfMnYO7xdpYwPMPhggmkdqJJNfBZwj/B1YWihPbLnGIc
   1eIX44+UlFp2oeYj6ojglu81cv6ts1+a6/AR8ezN9zhewG7zX77CYh+07
   xOQHn5/iPXSLh0SjilsFPD4vYTrRHhYBY5ItrnQu76cf0ApVjAOe4v5xk
   0lrjgzcvVNvxnwtCPvUkOJdOJEuzsCxZOuBYPXaho6EaOqR+h9IOKidtI
   NyoULgSwvAZtH0woh7e6+dTc5rEFYiTB0/5R3zceaebat2xKwCsifWFAA
   mz9CAppwjpUjIvyjckbE4I1/1AGZs0O7bi8EExwD6LI56gzPyhjOGT+CH
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10306"; a="285377453"
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="285377453"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2022 20:22:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,233,1643702400"; 
   d="scan'208";a="657341441"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 03 Apr 2022 20:22:54 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nbDIr-0001Pv-BH;
        Mon, 04 Apr 2022 03:22:53 +0000
Date:   Mon, 4 Apr 2022 11:22:04 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hyunchul Lee <hyc.lee@gmail.com>, linux-cifs@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Namjae Jeon <linkinjeon@kernel.org>,
        Steve French <sfrench@samba.org>,
        Sergey Senozhatsky <senozhatsky@chromium.org>,
        Hyunchul Lee <hyc.lee@gmail.com>
Subject: Re: [PATCH] ksmbd: smbd: handle multiple Buffer Decriptors
Message-ID: <202204041107.rehlU2wE-lkp@intel.com>
References: <20220403233056.12693-1-hyc.lee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220403233056.12693-1-hyc.lee@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi Hyunchul,

I love your patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc1 next-20220401]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Hyunchul-Lee/ksmbd-smbd-handle-multiple-Buffer-Decriptors/20220404-073255
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git be2d3ecedd9911fbfd7e55cc9ceac5f8b79ae4cf
config: mips-randconfig-s032-20220404 (https://download.01.org/0day-ci/archive/20220404/202204041107.rehlU2wE-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/3b3063c454ee836c82afc4a47004165038971cc4
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hyunchul-Lee/ksmbd-smbd-handle-multiple-Buffer-Decriptors/20220404-073255
        git checkout 3b3063c454ee836c82afc4a47004165038971cc4
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=mips SHELL=/bin/bash fs/ksmbd/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
   command-line: note: in included file:
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_ACQUIRE redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_SEQ_CST redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_ACQ_REL redefined
   builtin:0:0: sparse: this was the original definition
   builtin:1:9: sparse: sparse: preprocessor token __ATOMIC_RELEASE redefined
   builtin:0:0: sparse: this was the original definition
>> fs/ksmbd/smb2pdu.c:6193:40: sparse: sparse: cast to restricted __le32
>> fs/ksmbd/smb2pdu.c:6193:40: sparse: sparse: cast from restricted __le16
   fs/ksmbd/smb2pdu.c:6195:21: sparse: sparse: cast to restricted __le32
   fs/ksmbd/smb2pdu.c:6195:21: sparse: sparse: cast from restricted __le16

vim +6193 fs/ksmbd/smb2pdu.c

  6164	
  6165	/**
  6166	 * smb2_read() - handler for smb2 read from file
  6167	 * @work:	smb work containing read command buffer
  6168	 *
  6169	 * Return:	0 on success, otherwise error
  6170	 */
  6171	int smb2_read(struct ksmbd_work *work)
  6172	{
  6173		struct ksmbd_conn *conn = work->conn;
  6174		struct smb2_read_req *req;
  6175		struct smb2_read_rsp *rsp;
  6176		struct ksmbd_file *fp = NULL;
  6177		loff_t offset;
  6178		size_t length, mincount;
  6179		ssize_t nbytes = 0, remain_bytes = 0;
  6180		int err = 0;
  6181	
  6182		WORK_BUFFERS(work, req, rsp);
  6183	
  6184		if (test_share_config_flag(work->tcon->share_conf,
  6185					   KSMBD_SHARE_FLAG_PIPE)) {
  6186			ksmbd_debug(SMB, "IPC pipe read request\n");
  6187			return smb2_read_pipe(work);
  6188		}
  6189	
  6190		if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
  6191		    req->Channel == SMB2_CHANNEL_RDMA_V1) {
  6192			struct smb2_buffer_desc_v1 *descs = (struct smb2_buffer_desc_v1 *)
> 6193				((char *)req + le32_to_cpu(req->ReadChannelInfoOffset));
  6194	
  6195			if (le32_to_cpu(req->ReadChannelInfoOffset) <
  6196			    offsetof(struct smb2_read_req, Buffer)) {
  6197				err = -EINVAL;
  6198				goto out;
  6199			}
  6200	
  6201			err = smb2_validate_rdma_buffer_descs(work,
  6202							      descs,
  6203							      req->Channel,
  6204							      req->ReadChannelInfoOffset,
  6205							      req->ReadChannelInfoLength);
  6206			if (err)
  6207				goto out;
  6208		}
  6209	
  6210		fp = ksmbd_lookup_fd_slow(work, req->VolatileFileId, req->PersistentFileId);
  6211		if (!fp) {
  6212			err = -ENOENT;
  6213			goto out;
  6214		}
  6215	
  6216		if (!(fp->daccess & (FILE_READ_DATA_LE | FILE_READ_ATTRIBUTES_LE))) {
  6217			pr_err("Not permitted to read : 0x%x\n", fp->daccess);
  6218			err = -EACCES;
  6219			goto out;
  6220		}
  6221	
  6222		offset = le64_to_cpu(req->Offset);
  6223		length = le32_to_cpu(req->Length);
  6224		mincount = le32_to_cpu(req->MinimumCount);
  6225	
  6226		if (length > conn->vals->max_read_size) {
  6227			ksmbd_debug(SMB, "limiting read size to max size(%u)\n",
  6228				    conn->vals->max_read_size);
  6229			err = -EINVAL;
  6230			goto out;
  6231		}
  6232	
  6233		ksmbd_debug(SMB, "filename %pd, offset %lld, len %zu\n",
  6234			    fp->filp->f_path.dentry, offset, length);
  6235	
  6236		work->aux_payload_buf = kvmalloc(length, GFP_KERNEL | __GFP_ZERO);
  6237		if (!work->aux_payload_buf) {
  6238			err = -ENOMEM;
  6239			goto out;
  6240		}
  6241	
  6242		nbytes = ksmbd_vfs_read(work, fp, length, &offset);
  6243		if (nbytes < 0) {
  6244			err = nbytes;
  6245			goto out;
  6246		}
  6247	
  6248		if ((nbytes == 0 && length != 0) || nbytes < mincount) {
  6249			kvfree(work->aux_payload_buf);
  6250			work->aux_payload_buf = NULL;
  6251			rsp->hdr.Status = STATUS_END_OF_FILE;
  6252			smb2_set_err_rsp(work);
  6253			goto out;
  6254		}
  6255	
  6256		ksmbd_debug(SMB, "nbytes %zu, offset %lld mincount %zu\n",
  6257			    nbytes, offset, mincount);
  6258	
  6259		if (req->Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE ||
  6260		    req->Channel == SMB2_CHANNEL_RDMA_V1) {
  6261			/* write data to the client using rdma channel */
  6262			remain_bytes = smb2_read_rdma_channel(work, req,
  6263							      work->aux_payload_buf,
  6264							      nbytes);
  6265			kvfree(work->aux_payload_buf);
  6266			work->aux_payload_buf = NULL;
  6267	
  6268			nbytes = 0;
  6269			if (remain_bytes < 0) {
  6270				err = (int)remain_bytes;
  6271				goto out;
  6272			}
  6273		}
  6274	
  6275		rsp->StructureSize = cpu_to_le16(17);
  6276		rsp->DataOffset = 80;
  6277		rsp->Reserved = 0;
  6278		rsp->DataLength = cpu_to_le32(nbytes);
  6279		rsp->DataRemaining = cpu_to_le32(remain_bytes);
  6280		rsp->Flags = 0;
  6281		inc_rfc1001_len(work->response_buf, 16);
  6282		work->resp_hdr_sz = get_rfc1002_len(work->response_buf) + 4;
  6283		work->aux_payload_sz = nbytes;
  6284		inc_rfc1001_len(work->response_buf, nbytes);
  6285		ksmbd_fd_put(work, fp);
  6286		return 0;
  6287	
  6288	out:
  6289		if (err) {
  6290			if (err == -EISDIR)
  6291				rsp->hdr.Status = STATUS_INVALID_DEVICE_REQUEST;
  6292			else if (err == -EAGAIN)
  6293				rsp->hdr.Status = STATUS_FILE_LOCK_CONFLICT;
  6294			else if (err == -ENOENT)
  6295				rsp->hdr.Status = STATUS_FILE_CLOSED;
  6296			else if (err == -EACCES)
  6297				rsp->hdr.Status = STATUS_ACCESS_DENIED;
  6298			else if (err == -ESHARE)
  6299				rsp->hdr.Status = STATUS_SHARING_VIOLATION;
  6300			else if (err == -EINVAL)
  6301				rsp->hdr.Status = STATUS_INVALID_PARAMETER;
  6302			else
  6303				rsp->hdr.Status = STATUS_INVALID_HANDLE;
  6304	
  6305			smb2_set_err_rsp(work);
  6306		}
  6307		ksmbd_fd_put(work, fp);
  6308		return err;
  6309	}
  6310	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
