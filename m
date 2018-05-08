From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 5/7] cifs: smbd: Protect memory registration using RCU
Date: Tue, 8 May 2018 14:35:56 +0800
Message-ID: <201805081349.MX5qQDch%fengguang.wu@intel.com>
References: <20180507222006.20781-5-longli@linuxonhyperv.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kbuild-all@01.org, Steve French <sfrench@samba.org>,
        linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        Long Li <longli@microsoft.com>
To: Long Li <longli@linuxonhyperv.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180507222006.20781-5-longli@linuxonhyperv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Long,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on cifs/for-next]
[also build test WARNING on v4.17-rc4 next-20180507]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Long-Li/cifs-smbd-Make-upper-layer-decide-when-to-destroy-the-transport/20180508-110150
base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   fs/cifs/smb2pdu.c:110:47: sparse: expression using sizeof(void)
   fs/cifs/smb2pdu.c:681:26: sparse: expression using sizeof(void)
>> fs/cifs/smb2pdu.c:2613:17: sparse: incompatible types in comparison expression (different address spaces)
   fs/cifs/smb2pdu.c:2993:17: sparse: incompatible types in comparison expression (different address spaces)
   fs/cifs/smb2pdu.c:3251:23: sparse: expression using sizeof(void)
   fs/cifs/smb2pdu.c:3251:23: sparse: expression using sizeof(void)
   fs/cifs/smb2pdu.c:3252:23: sparse: expression using sizeof(void)
   fs/cifs/smb2pdu.c:3713:17: sparse: expression using sizeof(void)
   fs/cifs/smb2pdu.c:3713:17: sparse: expression using sizeof(void)

vim +2613 fs/cifs/smb2pdu.c

  2565	
  2566	/*
  2567	 * To form a chain of read requests, any read requests after the first should
  2568	 * have the end_of_chain boolean set to true.
  2569	 */
  2570	static int
  2571	smb2_new_read_req(void **buf, unsigned int *total_len,
  2572		struct cifs_io_parms *io_parms, struct cifs_readdata *rdata,
  2573		unsigned int remaining_bytes, int request_type)
  2574	{
  2575		int rc = -EACCES;
  2576		struct smb2_read_plain_req *req = NULL;
  2577		struct smb2_sync_hdr *shdr;
  2578		struct TCP_Server_Info *server;
  2579	
  2580		rc = smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void **) &req,
  2581					 total_len);
  2582		if (rc)
  2583			return rc;
  2584	
  2585		server = io_parms->tcon->ses->server;
  2586		if (server == NULL)
  2587			return -ECONNABORTED;
  2588	
  2589		shdr = &req->sync_hdr;
  2590		shdr->ProcessId = cpu_to_le32(io_parms->pid);
  2591	
  2592		req->PersistentFileId = io_parms->persistent_fid;
  2593		req->VolatileFileId = io_parms->volatile_fid;
  2594		req->ReadChannelInfoOffset = 0; /* reserved */
  2595		req->ReadChannelInfoLength = 0; /* reserved */
  2596		req->Channel = 0; /* reserved */
  2597		req->MinimumCount = 0;
  2598		req->Length = cpu_to_le32(io_parms->length);
  2599		req->Offset = cpu_to_le64(io_parms->offset);
  2600	#ifdef CONFIG_CIFS_SMB_DIRECT
  2601		/*
  2602		 * If we want to do a RDMA write, fill in and append
  2603		 * smbd_buffer_descriptor_v1 to the end of read request
  2604		 */
  2605		if (server->rdma && rdata && !server->sign &&
  2606			rdata->bytes >= server->smbd_conn->rdma_readwrite_threshold) {
  2607	
  2608			struct smbd_buffer_descriptor_v1 *v1;
  2609			bool need_invalidate =
  2610				io_parms->tcon->ses->server->dialect == SMB30_PROT_ID;
  2611	
  2612			rcu_read_lock();
> 2613			rcu_dereference(server->smbd_conn);
  2614			rdata->mr = smbd_register_mr(
  2615					server->smbd_conn, rdata->pages,
  2616					rdata->nr_pages, rdata->tailsz,
  2617					true, need_invalidate);
  2618			rcu_read_unlock();
  2619			if (!rdata->mr)
  2620				return -ENOBUFS;
  2621	
  2622			req->Channel = SMB2_CHANNEL_RDMA_V1_INVALIDATE;
  2623			if (need_invalidate)
  2624				req->Channel = SMB2_CHANNEL_RDMA_V1;
  2625			req->ReadChannelInfoOffset =
  2626				cpu_to_le16(offsetof(struct smb2_read_plain_req, Buffer));
  2627			req->ReadChannelInfoLength =
  2628				cpu_to_le16(sizeof(struct smbd_buffer_descriptor_v1));
  2629			v1 = (struct smbd_buffer_descriptor_v1 *) &req->Buffer[0];
  2630			v1->offset = cpu_to_le64(rdata->mr->mr->iova);
  2631			v1->token = cpu_to_le32(rdata->mr->mr->rkey);
  2632			v1->length = cpu_to_le32(rdata->mr->mr->length);
  2633	
  2634			*total_len += sizeof(*v1) - 1;
  2635		}
  2636	#endif
  2637		if (request_type & CHAINED_REQUEST) {
  2638			if (!(request_type & END_OF_CHAIN)) {
  2639				/* next 8-byte aligned request */
  2640				*total_len = DIV_ROUND_UP(*total_len, 8) * 8;
  2641				shdr->NextCommand = cpu_to_le32(*total_len);
  2642			} else /* END_OF_CHAIN */
  2643				shdr->NextCommand = 0;
  2644			if (request_type & RELATED_REQUEST) {
  2645				shdr->Flags |= SMB2_FLAGS_RELATED_OPERATIONS;
  2646				/*
  2647				 * Related requests use info from previous read request
  2648				 * in chain.
  2649				 */
  2650				shdr->SessionId = 0xFFFFFFFF;
  2651				shdr->TreeId = 0xFFFFFFFF;
  2652				req->PersistentFileId = 0xFFFFFFFF;
  2653				req->VolatileFileId = 0xFFFFFFFF;
  2654			}
  2655		}
  2656		if (remaining_bytes > io_parms->length)
  2657			req->RemainingBytes = cpu_to_le32(remaining_bytes);
  2658		else
  2659			req->RemainingBytes = 0;
  2660	
  2661		*buf = req;
  2662		return rc;
  2663	}
  2664	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
