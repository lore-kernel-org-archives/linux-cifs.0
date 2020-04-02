Return-Path: <SRS0=T25Y=5S=vger.kernel.org=linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=FAKE_REPLY_C,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 766F9C43331
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 01:07:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 37C1E20721
	for <linux-cifs@archiver.kernel.org>; Thu,  2 Apr 2020 01:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732664AbgDBBHT (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Wed, 1 Apr 2020 21:07:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:62092 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732660AbgDBBHT (ORCPT <rfc822;linux-cifs@vger.kernel.org>);
        Wed, 1 Apr 2020 21:07:19 -0400
IronPort-SDR: PS303TcWdioA7fwItdVTosdmWTfgCTKvS96VIlBBbOE8SkvHvp2JUdvqoxUTMXkjs4bDThyd12
 zcbLWAMcBP4g==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Apr 2020 18:07:18 -0700
IronPort-SDR: zdMm2iTMvJMf3K6FtDon3xVWmZmDMwcok3utaJCCDmCTaJMz/GWzaVWuuIhOsxBU0cySDZ0V0b
 vO6b3MUtX3fA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,333,1580803200"; 
   d="scan'208";a="450757299"
Received: from shao2-debian.sh.intel.com (HELO localhost) ([10.239.13.3])
  by fmsmga006.fm.intel.com with ESMTP; 01 Apr 2020 18:07:15 -0700
Date:   Thu, 2 Apr 2020 09:06:55 +0800
From:   kbuild test robot <lkp@intel.com>
To:     longli@linuxonhyperv.com
Cc:     kbuild-all@lists.01.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>
Subject: Re: [PATCH] cifs: smbd: Update receive credits before sending and
 deal with credits roll back on failure before sending
Message-ID: <20200402010655.GA8179@shao2-debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1585639101-117035-1-git-send-email-longli@linuxonhyperv.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-cifs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

Hi,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on v5.6 next-20200331]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/longli-linuxonhyperv-com/cifs-smbd-Update-receive-credits-before-sending-and-deal-with-credits-roll-back-on-failure-before-sending/20200331-152104
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-187-gbff9b106-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'
:::::: branch date: 10 hours ago
:::::: commit date: 10 hours ago

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

>> fs/cifs/smbdirect.c:856:26: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected int i @@    got restricted __le16 [usertyint i @@
>> fs/cifs/smbdirect.c:856:26: sparse:    expected int i
>> fs/cifs/smbdirect.c:856:26: sparse:    got restricted __le16 [usertype] credits_granted
>> fs/cifs/smbdirect.c:905:35: sparse: sparse: invalid assignment: +=
>> fs/cifs/smbdirect.c:905:35: sparse:    left side has type int
>> fs/cifs/smbdirect.c:905:35: sparse:    right side has type restricted __le16
   fs/cifs/smbdirect.c:907:26: sparse: sparse: incorrect type in argument 1 (different base types) @@    expected int i @@    got restricted __le16 [usertyint i @@
   fs/cifs/smbdirect.c:907:26: sparse:    expected int i
   fs/cifs/smbdirect.c:907:26: sparse:    got restricted __le16 [usertype] credits_granted

# https://github.com/0day-ci/linux/commit/e5b2c129dd7cb9db51cd025f988ff5bc2b0990a9
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout e5b2c129dd7cb9db51cd025f988ff5bc2b0990a9
vim +856 fs/cifs/smbdirect.c

f198186aa9bbd6 Long Li 2017-11-04  806  
f198186aa9bbd6 Long Li 2017-11-04  807  /*
f198186aa9bbd6 Long Li 2017-11-04  808   * Build and prepare the SMBD packet header
f198186aa9bbd6 Long Li 2017-11-04  809   * This function waits for avaialbe send credits and build a SMBD packet
f198186aa9bbd6 Long Li 2017-11-04  810   * header. The caller then optional append payload to the packet after
f198186aa9bbd6 Long Li 2017-11-04  811   * the header
f198186aa9bbd6 Long Li 2017-11-04  812   * intput values
f198186aa9bbd6 Long Li 2017-11-04  813   * size: the size of the payload
f198186aa9bbd6 Long Li 2017-11-04  814   * remaining_data_length: remaining data to send if this is part of a
f198186aa9bbd6 Long Li 2017-11-04  815   * fragmented packet
f198186aa9bbd6 Long Li 2017-11-04  816   * output values
f198186aa9bbd6 Long Li 2017-11-04  817   * request_out: the request allocated from this function
f198186aa9bbd6 Long Li 2017-11-04  818   * return values: 0 on success, otherwise actual error code returned
f198186aa9bbd6 Long Li 2017-11-04  819   */
f198186aa9bbd6 Long Li 2017-11-04  820  static int smbd_create_header(struct smbd_connection *info,
f198186aa9bbd6 Long Li 2017-11-04  821  		int size, int remaining_data_length,
f198186aa9bbd6 Long Li 2017-11-04  822  		struct smbd_request **request_out)
f198186aa9bbd6 Long Li 2017-11-04  823  {
f198186aa9bbd6 Long Li 2017-11-04  824  	struct smbd_request *request;
f198186aa9bbd6 Long Li 2017-11-04  825  	struct smbd_data_transfer *packet;
f198186aa9bbd6 Long Li 2017-11-04  826  	int header_length;
f198186aa9bbd6 Long Li 2017-11-04  827  	int rc;
f198186aa9bbd6 Long Li 2017-11-04  828  
f198186aa9bbd6 Long Li 2017-11-04  829  	/* Wait for send credits. A SMBD packet needs one credit */
f198186aa9bbd6 Long Li 2017-11-04  830  	rc = wait_event_interruptible(info->wait_send_queue,
f198186aa9bbd6 Long Li 2017-11-04  831  		atomic_read(&info->send_credits) > 0 ||
f198186aa9bbd6 Long Li 2017-11-04  832  		info->transport_status != SMBD_CONNECTED);
f198186aa9bbd6 Long Li 2017-11-04  833  	if (rc)
f198186aa9bbd6 Long Li 2017-11-04  834  		return rc;
f198186aa9bbd6 Long Li 2017-11-04  835  
f198186aa9bbd6 Long Li 2017-11-04  836  	if (info->transport_status != SMBD_CONNECTED) {
f198186aa9bbd6 Long Li 2017-11-04  837  		log_outgoing(ERR, "disconnected not sending\n");
62fdf6707ebd46 Long Li 2019-04-05  838  		return -EAGAIN;
f198186aa9bbd6 Long Li 2017-11-04  839  	}
f198186aa9bbd6 Long Li 2017-11-04  840  	atomic_dec(&info->send_credits);
f198186aa9bbd6 Long Li 2017-11-04  841  
f198186aa9bbd6 Long Li 2017-11-04  842  	request = mempool_alloc(info->request_mempool, GFP_KERNEL);
f198186aa9bbd6 Long Li 2017-11-04  843  	if (!request) {
f198186aa9bbd6 Long Li 2017-11-04  844  		rc = -ENOMEM;
e5b2c129dd7cb9 Long Li 2020-03-31  845  		goto err_alloc;
f198186aa9bbd6 Long Li 2017-11-04  846  	}
f198186aa9bbd6 Long Li 2017-11-04  847  
f198186aa9bbd6 Long Li 2017-11-04  848  	request->info = info;
f198186aa9bbd6 Long Li 2017-11-04  849  
f198186aa9bbd6 Long Li 2017-11-04  850  	/* Fill in the packet header */
f198186aa9bbd6 Long Li 2017-11-04  851  	packet = smbd_request_payload(request);
f198186aa9bbd6 Long Li 2017-11-04  852  	packet->credits_requested = cpu_to_le16(info->send_credit_target);
f198186aa9bbd6 Long Li 2017-11-04  853  	packet->credits_granted =
f198186aa9bbd6 Long Li 2017-11-04  854  		cpu_to_le16(manage_credits_prior_sending(info));
f198186aa9bbd6 Long Li 2017-11-04  855  	info->send_immediate = false;
e5b2c129dd7cb9 Long Li 2020-03-31 @856  	atomic_add(packet->credits_granted, &info->receive_credits);
f198186aa9bbd6 Long Li 2017-11-04  857  
f198186aa9bbd6 Long Li 2017-11-04  858  	packet->flags = 0;
f198186aa9bbd6 Long Li 2017-11-04  859  	if (manage_keep_alive_before_sending(info))
f198186aa9bbd6 Long Li 2017-11-04  860  		packet->flags |= cpu_to_le16(SMB_DIRECT_RESPONSE_REQUESTED);
f198186aa9bbd6 Long Li 2017-11-04  861  
f198186aa9bbd6 Long Li 2017-11-04  862  	packet->reserved = 0;
f198186aa9bbd6 Long Li 2017-11-04  863  	if (!size)
f198186aa9bbd6 Long Li 2017-11-04  864  		packet->data_offset = 0;
f198186aa9bbd6 Long Li 2017-11-04  865  	else
f198186aa9bbd6 Long Li 2017-11-04  866  		packet->data_offset = cpu_to_le32(24);
f198186aa9bbd6 Long Li 2017-11-04  867  	packet->data_length = cpu_to_le32(size);
f198186aa9bbd6 Long Li 2017-11-04  868  	packet->remaining_data_length = cpu_to_le32(remaining_data_length);
f198186aa9bbd6 Long Li 2017-11-04  869  	packet->padding = 0;
f198186aa9bbd6 Long Li 2017-11-04  870  
f198186aa9bbd6 Long Li 2017-11-04  871  	log_outgoing(INFO, "credits_requested=%d credits_granted=%d "
f198186aa9bbd6 Long Li 2017-11-04  872  		"data_offset=%d data_length=%d remaining_data_length=%d\n",
f198186aa9bbd6 Long Li 2017-11-04  873  		le16_to_cpu(packet->credits_requested),
f198186aa9bbd6 Long Li 2017-11-04  874  		le16_to_cpu(packet->credits_granted),
f198186aa9bbd6 Long Li 2017-11-04  875  		le32_to_cpu(packet->data_offset),
f198186aa9bbd6 Long Li 2017-11-04  876  		le32_to_cpu(packet->data_length),
f198186aa9bbd6 Long Li 2017-11-04  877  		le32_to_cpu(packet->remaining_data_length));
f198186aa9bbd6 Long Li 2017-11-04  878  
f198186aa9bbd6 Long Li 2017-11-04  879  	/* Map the packet to DMA */
f198186aa9bbd6 Long Li 2017-11-04  880  	header_length = sizeof(struct smbd_data_transfer);
f198186aa9bbd6 Long Li 2017-11-04  881  	/* If this is a packet without payload, don't send padding */
f198186aa9bbd6 Long Li 2017-11-04  882  	if (!size)
f198186aa9bbd6 Long Li 2017-11-04  883  		header_length = offsetof(struct smbd_data_transfer, padding);
f198186aa9bbd6 Long Li 2017-11-04  884  
f198186aa9bbd6 Long Li 2017-11-04  885  	request->num_sge = 1;
f198186aa9bbd6 Long Li 2017-11-04  886  	request->sge[0].addr = ib_dma_map_single(info->id->device,
f198186aa9bbd6 Long Li 2017-11-04  887  						 (void *)packet,
f198186aa9bbd6 Long Li 2017-11-04  888  						 header_length,
7f46d23e1b14f0 Long Li 2019-05-13  889  						 DMA_TO_DEVICE);
f198186aa9bbd6 Long Li 2017-11-04  890  	if (ib_dma_mapping_error(info->id->device, request->sge[0].addr)) {
f198186aa9bbd6 Long Li 2017-11-04  891  		mempool_free(request, info->request_mempool);
f198186aa9bbd6 Long Li 2017-11-04  892  		rc = -EIO;
e5b2c129dd7cb9 Long Li 2020-03-31  893  		goto err_dma;
f198186aa9bbd6 Long Li 2017-11-04  894  	}
f198186aa9bbd6 Long Li 2017-11-04  895  
f198186aa9bbd6 Long Li 2017-11-04  896  	request->sge[0].length = header_length;
f198186aa9bbd6 Long Li 2017-11-04  897  	request->sge[0].lkey = info->pd->local_dma_lkey;
f198186aa9bbd6 Long Li 2017-11-04  898  
f198186aa9bbd6 Long Li 2017-11-04  899  	*request_out = request;
f198186aa9bbd6 Long Li 2017-11-04  900  	return 0;
f198186aa9bbd6 Long Li 2017-11-04  901  
e5b2c129dd7cb9 Long Li 2020-03-31  902  err_dma:
e5b2c129dd7cb9 Long Li 2020-03-31  903  	/* roll back receive credits */
e5b2c129dd7cb9 Long Li 2020-03-31  904  	spin_lock(&info->lock_new_credits_offered);
e5b2c129dd7cb9 Long Li 2020-03-31 @905  	info->new_credits_offered += packet->credits_granted;
e5b2c129dd7cb9 Long Li 2020-03-31  906  	spin_unlock(&info->lock_new_credits_offered);
e5b2c129dd7cb9 Long Li 2020-03-31  907  	atomic_sub(packet->credits_granted, &info->receive_credits);
e5b2c129dd7cb9 Long Li 2020-03-31  908  
e5b2c129dd7cb9 Long Li 2020-03-31  909  err_alloc:
e5b2c129dd7cb9 Long Li 2020-03-31  910  	/* roll back send credits */
f198186aa9bbd6 Long Li 2017-11-04  911  	atomic_inc(&info->send_credits);
e5b2c129dd7cb9 Long Li 2020-03-31  912  
f198186aa9bbd6 Long Li 2017-11-04  913  	return rc;
f198186aa9bbd6 Long Li 2017-11-04  914  }
f198186aa9bbd6 Long Li 2017-11-04  915  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
