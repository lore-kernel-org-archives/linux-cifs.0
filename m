From: Long Li <longli@microsoft.com>
Subject: RE: [PATCH 5/7] cifs: smbd: Protect memory registration using RCU
Date: Tue, 8 May 2018 22:16:23 +0000
Message-ID: <MWHPR2101MB0729D64EBD5E4BAE67C26E7CCE9A0@MWHPR2101MB0729.namprd21.prod.outlook.com>
References: <20180507222006.20781-5-longli@linuxonhyperv.com>
 <201805081349.MX5qQDch%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "kbuild-all@01.org" <kbuild-all@01.org>,
        Steve French <sfrench@samba.org>,
        "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
To: kbuild test robot <lkp@intel.com>,
        Long Li <longli@linuxonhyperv.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201805081349.MX5qQDch%fengguang.wu@intel.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

Hi Steve

Please drop this patch. I will find another solution.

The other patches in the series can be reviewed and applied.

Long

> -----Original Message-----
> From: kbuild test robot <lkp@intel.com>
> Sent: Monday, May 7, 2018 11:36 PM
> To: Long Li <longli@linuxonhyperv.com>
> Cc: kbuild-all@01.org; Steve French <sfrench@samba.org>; linux-
> cifs@vger.kernel.org; samba-technical@lists.samba.org; linux-
> kernel@vger.kernel.org; linux-rdma@vger.kernel.org; Long Li
> <longli@microsoft.com>
> Subject: Re: [PATCH 5/7] cifs: smbd: Protect memory registration using RC=
U
>=20
> Hi Long,
>=20
> Thank you for the patch! Perhaps something to improve:
>=20
> [auto build test WARNING on cifs/for-next] [also build test WARNING on
> v4.17-rc4 next-20180507] [if your patch is applied to the wrong git tree,
> please drop us a note to help improve the system]
>=20
> url:
> https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fgithub
> .com%2F0day-ci%2Flinux%2Fcommits%2FLong-Li%2Fcifs-smbd-Make-upper-
> layer-decide-when-to-destroy-the-transport%2F20180508-
> 110150&data=3D02%7C01%7Clongli%40microsoft.com%7C56045b01aeae4e53b1
> 9408d5b4ae0502%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C6366
> 13581873868980&sdata=3Da1Ds3qI7sRrLCE77Eoasifonm1rUQYi7rdUEnLnGOB4%
> 3D&reserved=3D0
> base:   git://git.samba.org/sfrench/cifs-2.6.git for-next
> reproduce:
>         # apt-get install sparse
>         make ARCH=3Dx86_64 allmodconfig
>         make C=3D1 CF=3D-D__CHECK_ENDIAN__
>=20
>=20
> sparse warnings: (new ones prefixed by >>)
>=20
>    fs/cifs/smb2pdu.c:110:47: sparse: expression using sizeof(void)
>    fs/cifs/smb2pdu.c:681:26: sparse: expression using sizeof(void)
> >> fs/cifs/smb2pdu.c:2613:17: sparse: incompatible types in comparison
> >> expression (different address spaces)
>    fs/cifs/smb2pdu.c:2993:17: sparse: incompatible types in comparison
> expression (different address spaces)
>    fs/cifs/smb2pdu.c:3251:23: sparse: expression using sizeof(void)
>    fs/cifs/smb2pdu.c:3251:23: sparse: expression using sizeof(void)
>    fs/cifs/smb2pdu.c:3252:23: sparse: expression using sizeof(void)
>    fs/cifs/smb2pdu.c:3713:17: sparse: expression using sizeof(void)
>    fs/cifs/smb2pdu.c:3713:17: sparse: expression using sizeof(void)
>=20
> vim +2613 fs/cifs/smb2pdu.c
>=20
>   2565
>   2566	/*
>   2567	 * To form a chain of read requests, any read requests after the f=
irst
> should
>   2568	 * have the end_of_chain boolean set to true.
>   2569	 */
>   2570	static int
>   2571	smb2_new_read_req(void **buf, unsigned int *total_len,
>   2572		struct cifs_io_parms *io_parms, struct cifs_readdata *rdata,
>   2573		unsigned int remaining_bytes, int request_type)
>   2574	{
>   2575		int rc =3D -EACCES;
>   2576		struct smb2_read_plain_req *req =3D NULL;
>   2577		struct smb2_sync_hdr *shdr;
>   2578		struct TCP_Server_Info *server;
>   2579
>   2580		rc =3D smb2_plain_req_init(SMB2_READ, io_parms->tcon, (void
> **) &req,
>   2581					 total_len);
>   2582		if (rc)
>   2583			return rc;
>   2584
>   2585		server =3D io_parms->tcon->ses->server;
>   2586		if (server =3D=3D NULL)
>   2587			return -ECONNABORTED;
>   2588
>   2589		shdr =3D &req->sync_hdr;
>   2590		shdr->ProcessId =3D cpu_to_le32(io_parms->pid);
>   2591
>   2592		req->PersistentFileId =3D io_parms->persistent_fid;
>   2593		req->VolatileFileId =3D io_parms->volatile_fid;
>   2594		req->ReadChannelInfoOffset =3D 0; /* reserved */
>   2595		req->ReadChannelInfoLength =3D 0; /* reserved */
>   2596		req->Channel =3D 0; /* reserved */
>   2597		req->MinimumCount =3D 0;
>   2598		req->Length =3D cpu_to_le32(io_parms->length);
>   2599		req->Offset =3D cpu_to_le64(io_parms->offset);
>   2600	#ifdef CONFIG_CIFS_SMB_DIRECT
>   2601		/*
>   2602		 * If we want to do a RDMA write, fill in and append
>   2603		 * smbd_buffer_descriptor_v1 to the end of read request
>   2604		 */
>   2605		if (server->rdma && rdata && !server->sign &&
>   2606			rdata->bytes >=3D server->smbd_conn-
> >rdma_readwrite_threshold) {
>   2607
>   2608			struct smbd_buffer_descriptor_v1 *v1;
>   2609			bool need_invalidate =3D
>   2610				io_parms->tcon->ses->server->dialect =3D=3D
> SMB30_PROT_ID;
>   2611
>   2612			rcu_read_lock();
> > 2613			rcu_dereference(server->smbd_conn);
>   2614			rdata->mr =3D smbd_register_mr(
>   2615					server->smbd_conn, rdata->pages,
>   2616					rdata->nr_pages, rdata->tailsz,
>   2617					true, need_invalidate);
>   2618			rcu_read_unlock();
>   2619			if (!rdata->mr)
>   2620				return -ENOBUFS;
>   2621
>   2622			req->Channel =3D
> SMB2_CHANNEL_RDMA_V1_INVALIDATE;
>   2623			if (need_invalidate)
>   2624				req->Channel =3D SMB2_CHANNEL_RDMA_V1;
>   2625			req->ReadChannelInfoOffset =3D
>   2626				cpu_to_le16(offsetof(struct
> smb2_read_plain_req, Buffer));
>   2627			req->ReadChannelInfoLength =3D
>   2628				cpu_to_le16(sizeof(struct
> smbd_buffer_descriptor_v1));
>   2629			v1 =3D (struct smbd_buffer_descriptor_v1 *) &req-
> >Buffer[0];
>   2630			v1->offset =3D cpu_to_le64(rdata->mr->mr->iova);
>   2631			v1->token =3D cpu_to_le32(rdata->mr->mr->rkey);
>   2632			v1->length =3D cpu_to_le32(rdata->mr->mr->length);
>   2633
>   2634			*total_len +=3D sizeof(*v1) - 1;
>   2635		}
>   2636	#endif
>   2637		if (request_type & CHAINED_REQUEST) {
>   2638			if (!(request_type & END_OF_CHAIN)) {
>   2639				/* next 8-byte aligned request */
>   2640				*total_len =3D DIV_ROUND_UP(*total_len, 8) *
> 8;
>   2641				shdr->NextCommand =3D
> cpu_to_le32(*total_len);
>   2642			} else /* END_OF_CHAIN */
>   2643				shdr->NextCommand =3D 0;
>   2644			if (request_type & RELATED_REQUEST) {
>   2645				shdr->Flags |=3D
> SMB2_FLAGS_RELATED_OPERATIONS;
>   2646				/*
>   2647				 * Related requests use info from previous
> read request
>   2648				 * in chain.
>   2649				 */
>   2650				shdr->SessionId =3D 0xFFFFFFFF;
>   2651				shdr->TreeId =3D 0xFFFFFFFF;
>   2652				req->PersistentFileId =3D 0xFFFFFFFF;
>   2653				req->VolatileFileId =3D 0xFFFFFFFF;
>   2654			}
>   2655		}
>   2656		if (remaining_bytes > io_parms->length)
>   2657			req->RemainingBytes =3D
> cpu_to_le32(remaining_bytes);
>   2658		else
>   2659			req->RemainingBytes =3D 0;
>   2660
>   2661		*buf =3D req;
>   2662		return rc;
>   2663	}
>   2664
>=20
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Ce=
nter
> https://na01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flists.=
01
> .org%2Fpipermail%2Fkbuild-
> all&data=3D02%7C01%7Clongli%40microsoft.com%7C56045b01aeae4e53b19408
> d5b4ae0502%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C63661358
> 1873868980&sdata=3Dy3BYFeKEayhIfrs6hodamCPCyz8n3YQdN1yX3yXKs80%3D
> &reserved=3D0                   Intel Corporation
