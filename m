Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68EF52E03E6
	for <linux-cifs@vger.kernel.org>; Thu, 16 Oct 2025 12:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760617124; cv=none; b=OX9BoR9cTRjSaE/8+5ScnS0NrIh9k5lRv2qJVhWllXBSZy15DglVFenxEBAF1bnhNpM27eaYZmN4McRcEb1OVpLgfeaegW1l0Cy79BQtKfHhGSLKZN6fAhnG9EUUq0pfjowWthVT20Tri3d9iNDCN6Xy3QGC8wdJHPaT/MuZTWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760617124; c=relaxed/simple;
	bh=5ZRg0Le669yP1Ro8q2k+3OQh/xf2crWvEGRZaGhuDmY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tmE+AxPOigLq1EccvlgOC8PTLksdSLa8PcVhEzwCvwhisDvTOmXvj1mVA9ZbXrl1QMt+AULFhMUU1GG+ZUSMFUJoMI0eKF47CcO6sFB3VIgOa2BzBHx52kDiiqG9x4COt5Ni3ESYnf3E6Pl98gwRAGAMDK2DUsy7HVdziGgYQZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=hh0QNNrg; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="hh0QNNrg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=gZa86p/xVAkShf20tbImDiTdqdY6C4ZnG4ne4nm4HcM=; b=hh0QNNrgSGGC+oi9aGPLXlUanY
	B/TYno8N82vBCoAZy8VhotpWhRuzyuHTYcDy15umbkUC+4GdjoXgDkU21YRQcrHGN1t0q+pP3mc6w
	peql5nenxQVuB5RUJmGIJHuvJWlIBp6qhrdBEVxqAGkDmyRKUXxtHGhBcfWLZYoaP3AWyFoJWczVh
	xD5R1/jXAd4DpzCLtaZZR16fMmRkV7DKRXLvUI61lVGD5dWEHMgbn8oCSAo+emy8xv2m+UBmRuboh
	Aja5PlvHfSqeFcyFMwM7fBbQD1D+LLFatRAEl4cNXwdy7SKjYFtt/2MNaLRG7bTfHkdeCC84nU+kE
	Hh5K8ExfvqJZmCkgB4I8aszGK1o2P6wvS1bzAMibacOpRFKKoVVsYt1j5QVGBSej+pvPqhRDx72Ul
	rzEIpln19aw2owRqpCO2xXmCSxk2M3j7Mx9tXhzfPr1mS3A7JuspI9+kpO5f/DD2rEw1RwjMSxzLK
	PZDagBbATJZvgW5VgBNOg4vl;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v9MwK-009YAo-0T;
	Thu, 16 Oct 2025 12:18:40 +0000
Message-ID: <6f725634-dad5-4408-80f8-aeec04ea3d32@samba.org>
Date: Thu, 16 Oct 2025 14:18:39 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] smb: server: allocate enough space for RW WRs and
 ib_drain_qp()
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Cc: Namjae Jeon <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>,
 Tom Talpey <tom@talpey.com>
References: <20251016112041.1241820-1-metze@samba.org>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <20251016112041.1241820-1-metze@samba.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Sorry for the spam!

I'll send a v3 that avoids passing struct ib_qp_cap *cap
from smb_direct_init_params() to smb_direct_create_qpair().

We can do everything in smb_direct_create_qpair(),
which simplify my further changes in order to use common
code in 6.19.

metze

Am 16.10.25 um 13:20 schrieb Stefan Metzmacher:
> Make use of rdma_rw_mr_factor() to calculate the number of rw
> credits and the number of pages per RDMA RW operation.
> 
> We get the same numbers for iWarp connections, tested
> with siw.ko and irdma.ko (in iWarp mode).
> 
> siw:
> 
> CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 256
> CIFS: max_sgl_rd=0, max_sge_rd=1
> CIFS: responder_resources=32 max_frmr_depth=256 mr_io.type=0
> CIFS: max_send_wr 384, device reporting max_cqe 3276800 max_qp_wr 32768
> ksmbd: max_fast_reg_page_list_len = 256, max_sgl_rd=0, max_sge_rd=1
> ksmbd: device reporting max_cqe 3276800 max_qp_wr 32768
> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
> ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
> ksmbd: Info: rdma_send_wr 27 + max_send_wr 256 = 283
> 
> irdma (in iWarp mode):
> 
> CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144
> CIFS: max_sgl_rd=0, max_sge_rd=13
> CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
> ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
> ksmbd: rdma_send_wr 27 + max_send_wr 256 = 283
> 
> This means that we get the different correct numbers for ROCE,
> tested with rdma_rxe.ko and irdma.ko (in RoCEv2 mode).
> 
> rxe:
> 
> CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 512
> CIFS: max_sgl_rd=0, max_sge_rd=32
> CIFS: responder_resources=32 max_frmr_depth=512 mr_io.type=0
> CIFS: max_send_wr 384, device reporting max_cqe 32767 max_qp_wr 1048576
> ksmbd: max_fast_reg_page_list_len = 512, max_sgl_rd=0, max_sge_rd=32
> ksmbd: device reporting max_cqe 32767 max_qp_wr 1048576
> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
> ksmbd: New sc->rw_io.credits: max = 65, num_pages = 32, maxpages=2048
> ksmbd: rdma_send_wr 65 + max_send_wr 256 = 321
> 
> irdma (in RoCEv2 mode):
> 
> CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144,
> CIFS: max_sgl_rd=0, max_sge_rd=13
> CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256,
> ksmbd: New sc->rw_io.credits: max = 159, num_pages = 13, maxpages=2048
> ksmbd: rdma_send_wr 159 + max_send_wr 256 = 415
> 
> And rely on rdma_rw_init_qp() to setup ib_mr_pool_init() for
> RW MRs.
> 
> It seems the code was implemented before the rdma_rw_* layer
> was fully established in the kernel.
> 
> While there also add additional space for ib_drain_qp().
> 
> This should make sure ib_post_send() will never fail
> because the submission queue is full.
> 
> Fixes: ddbdc861e37c ("ksmbd: smbd: introduce read/write credits for RDMA read/write")
> Fixes: 4c564f03e23b ("smb: server: make use of common smbdirect_socket")
> Fixes: 177368b99243 ("smb: server: make use of common smbdirect_socket_parameters")
> Fixes: 95475d8886bd ("smb: server: make use smbdirect_socket.rw_io.credits")
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>   fs/smb/server/transport_rdma.c | 204 ++++++++++++++++++++-------------
>   1 file changed, 126 insertions(+), 78 deletions(-)
> 
> diff --git a/fs/smb/server/transport_rdma.c b/fs/smb/server/transport_rdma.c
> index 94851ff25a02..3c0719777891 100644
> --- a/fs/smb/server/transport_rdma.c
> +++ b/fs/smb/server/transport_rdma.c
> @@ -1870,20 +1870,12 @@ static int smb_direct_prepare_negotiation(struct smbdirect_socket *sc)
>   	return ret;
>   }
>   
> -static unsigned int smb_direct_get_max_fr_pages(struct smbdirect_socket *sc)
> -{
> -	return min_t(unsigned int,
> -		     sc->ib.dev->attrs.max_fast_reg_page_list_len,
> -		     256);
> -}
> -
>   static int smb_direct_init_params(struct smbdirect_socket *sc,
>   				  struct ib_qp_cap *cap)
>   {
>   	struct smbdirect_socket_parameters *sp = &sc->parameters;
> -	struct ib_device *device = sc->ib.dev;
> -	int max_send_sges, max_rw_wrs, max_send_wrs;
> -	unsigned int max_sge_per_wr, wrs_per_credit;
> +	int max_send_sges;
> +	unsigned int maxpages;
>   
>   	/* need 3 more sge. because a SMB_DIRECT header, SMB2 header,
>   	 * SMB2 response could be mapped.
> @@ -1894,63 +1886,29 @@ static int smb_direct_init_params(struct smbdirect_socket *sc,
>   		return -EINVAL;
>   	}
>   
> -	/* Calculate the number of work requests for RDMA R/W.
> -	 * The maximum number of pages which can be registered
> -	 * with one Memory region can be transferred with one
> -	 * R/W credit. And at least 4 work requests for each credit
> -	 * are needed for MR registration, RDMA R/W, local & remote
> -	 * MR invalidation.
> -	 */
> -	sc->rw_io.credits.num_pages = smb_direct_get_max_fr_pages(sc);
> -	sc->rw_io.credits.max = DIV_ROUND_UP(sp->max_read_write_size,
> -					 (sc->rw_io.credits.num_pages - 1) *
> -					 PAGE_SIZE);
> -
> -	max_sge_per_wr = min_t(unsigned int, device->attrs.max_send_sge,
> -			       device->attrs.max_sge_rd);
> -	max_sge_per_wr = max_t(unsigned int, max_sge_per_wr,
> -			       max_send_sges);
> -	wrs_per_credit = max_t(unsigned int, 4,
> -			       DIV_ROUND_UP(sc->rw_io.credits.num_pages,
> -					    max_sge_per_wr) + 1);
> -	max_rw_wrs = sc->rw_io.credits.max * wrs_per_credit;
> -
> -	max_send_wrs = sp->send_credit_target + max_rw_wrs;
> -	if (max_send_wrs > device->attrs.max_cqe ||
> -	    max_send_wrs > device->attrs.max_qp_wr) {
> -		pr_err("consider lowering send_credit_target = %d\n",
> -		       sp->send_credit_target);
> -		pr_err("Possible CQE overrun, device reporting max_cqe %d max_qp_wr %d\n",
> -		       device->attrs.max_cqe, device->attrs.max_qp_wr);
> -		return -EINVAL;
> -	}
> -
> -	if (sp->recv_credit_max > device->attrs.max_cqe ||
> -	    sp->recv_credit_max > device->attrs.max_qp_wr) {
> -		pr_err("consider lowering receive_credit_max = %d\n",
> -		       sp->recv_credit_max);
> -		pr_err("Possible CQE overrun, device reporting max_cpe %d max_qp_wr %d\n",
> -		       device->attrs.max_cqe, device->attrs.max_qp_wr);
> -		return -EINVAL;
> -	}
> -
> -	if (device->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE) {
> -		pr_err("warning: device max_send_sge = %d too small\n",
> -		       device->attrs.max_send_sge);
> -		return -EINVAL;
> -	}
> -	if (device->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
> -		pr_err("warning: device max_recv_sge = %d too small\n",
> -		       device->attrs.max_recv_sge);
> -		return -EINVAL;
> -	}
> +	maxpages = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE);
> +	sc->rw_io.credits.max = rdma_rw_mr_factor(sc->ib.dev,
> +						  sc->rdma.cm_id->port_num,
> +						  maxpages);
> +	sc->rw_io.credits.num_pages = DIV_ROUND_UP(maxpages, sc->rw_io.credits.max);
> +	/* add one extra in order to handle unaligned pages */
> +	sc->rw_io.credits.max += 1;
>   
>   	sc->recv_io.credits.target = 1;
>   
>   	atomic_set(&sc->rw_io.credits.count, sc->rw_io.credits.max);
>   
> -	cap->max_send_wr = max_send_wrs;
> -	cap->max_recv_wr = sp->recv_credit_max;
> +	/*
> +	 * Note that {rdma,ib}_create_qp() will call
> +	 * rdma_rw_init_qp() if cap->max_rdma_ctxs is not 0.
> +	 * It will adjust cap->max_send_wr to the required
> +	 * number of additional WRs for the RDMA RW operations.
> +	 * It will cap cap->max_send_wr to the device limit.
> +	 *
> +	 * +1 for ib_drain_qp
> +	 */
> +	cap->max_send_wr = sp->send_credit_target + 1;
> +	cap->max_recv_wr = sp->recv_credit_max + 1;
>   	cap->max_send_sge = SMBDIRECT_SEND_IO_MAX_SGE;
>   	cap->max_recv_sge = SMBDIRECT_RECV_IO_MAX_SGE;
>   	cap->max_inline_data = 0;
> @@ -2028,13 +1986,108 @@ static int smb_direct_create_pools(struct smbdirect_socket *sc)
>   	return -ENOMEM;
>   }
>   
> +static u32 smb_direct_rdma_rw_send_wrs(struct ib_device *dev, struct ib_qp_init_attr *attr)
> +{
> +	/*
> +	 * This could be split out of rdma_rw_init_qp()
> +	 * and be a helper function next to rdma_rw_mr_factor()
> +	 *
> +	 * We can't check unlikely(rdma_rw_force_mr) here,
> +	 * but that is most likely 0 anyway.
> +	 */
> +	u32 factor;
> +
> +	WARN_ON_ONCE(attr->port_num == 0);
> +
> +	/*
> +	 * Each context needs at least one RDMA READ or WRITE WR.
> +	 *
> +	 * For some hardware we might need more, eventually we should ask the
> +	 * HCA driver for a multiplier here.
> +	 */
> +	factor = 1;
> +
> +	/*
> +	 * If the device needs MRs to perform RDMA READ or WRITE operations,
> +	 * we'll need two additional MRs for the registrations and the
> +	 * invalidation.
> +	 */
> +	if (rdma_protocol_iwarp(dev, attr->port_num) || dev->attrs.max_sgl_rd)
> +		factor += 2;	/* inv + reg */
> +
> +	return factor * attr->cap.max_rdma_ctxs;
> +}
> +
>   static int smb_direct_create_qpair(struct smbdirect_socket *sc,
>   				   struct ib_qp_cap *cap)
>   {
>   	struct smbdirect_socket_parameters *sp = &sc->parameters;
>   	int ret;
>   	struct ib_qp_init_attr qp_attr;
> -	int pages_per_rw;
> +	u32 max_send_wr;
> +	u32 rdma_send_wr;
> +
> +	/*
> +	 * Find out the number of max_send_wr
> +	 * after rdma_rw_init_qp() adjusted it.
> +	 *
> +	 * We only do it on a temporary variable,
> +	 * as rdma_create_qp() will trigger
> +	 * rdma_rw_init_qp() again.
> +	 */
> +	memset(&qp_attr, 0, sizeof(qp_attr));
> +	qp_attr.cap = *cap;
> +	qp_attr.port_num = sc->rdma.cm_id->port_num;
> +	rdma_send_wr = smb_direct_rdma_rw_send_wrs(sc->ib.dev, &qp_attr);
> +	max_send_wr = qp_attr.cap.max_send_wr + rdma_send_wr;
> +
> +	if (cap->max_send_wr > sc->ib.dev->attrs.max_cqe ||
> +	    cap->max_send_wr > sc->ib.dev->attrs.max_qp_wr) {
> +		pr_err("Possible CQE overrun: max_send_wr %d, "
> +		       "device reporting max_cqe %d max_qp_wr %d\n",
> +		       cap->max_send_wr,
> +		       sc->ib.dev->attrs.max_cqe,
> +		       sc->ib.dev->attrs.max_qp_wr);
> +		pr_err("consider lowering send_credit_target = %d\n",
> +		       sp->send_credit_target);
> +		return -EINVAL;
> +	}
> +
> +	if (cap->max_rdma_ctxs &&
> +	    (max_send_wr >= sc->ib.dev->attrs.max_cqe ||
> +	     max_send_wr >= sc->ib.dev->attrs.max_qp_wr)) {
> +		pr_err("Possible CQE overrun: rdma_send_wr %d + max_send_wr %d = %d, "
> +		       "device reporting max_cqe %d max_qp_wr %d\n",
> +		       rdma_send_wr, cap->max_send_wr, max_send_wr,
> +		       sc->ib.dev->attrs.max_cqe,
> +		       sc->ib.dev->attrs.max_qp_wr);
> +		pr_err("consider lowering send_credit_target = %d, max_rdma_ctxs = %d\n",
> +		       sp->send_credit_target, cap->max_rdma_ctxs);
> +		return -EINVAL;
> +	}
> +
> +	if (cap->max_recv_wr > sc->ib.dev->attrs.max_cqe ||
> +	    cap->max_recv_wr > sc->ib.dev->attrs.max_qp_wr) {
> +		pr_err("Possible CQE overrun: max_recv_wr %d, "
> +		       "device reporting max_cpe %d max_qp_wr %d\n",
> +		       cap->max_recv_wr,
> +		       sc->ib.dev->attrs.max_cqe,
> +		       sc->ib.dev->attrs.max_qp_wr);
> +		pr_err("consider lowering receive_credit_max = %d\n",
> +		       sp->recv_credit_max);
> +		return -EINVAL;
> +	}
> +
> +	if (sc->ib.dev->attrs.max_send_sge < SMBDIRECT_SEND_IO_MAX_SGE) {
> +		pr_err("warning: device max_send_sge = %d too small\n",
> +		       sc->ib.dev->attrs.max_send_sge);
> +		return -EINVAL;
> +	}
> +	if (sc->ib.dev->attrs.max_recv_sge < SMBDIRECT_RECV_IO_MAX_SGE) {
> +		pr_err("warning: device max_recv_sge = %d too small\n",
> +		       sc->ib.dev->attrs.max_recv_sge);
> +		return -EINVAL;
> +	}
>   
>   	sc->ib.pd = ib_alloc_pd(sc->ib.dev, 0);
>   	if (IS_ERR(sc->ib.pd)) {
> @@ -2045,8 +2098,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
>   	}
>   
>   	sc->ib.send_cq = ib_alloc_cq_any(sc->ib.dev, sc,
> -					 sp->send_credit_target +
> -					 cap->max_rdma_ctxs,
> +					 max_send_wr,
>   					 IB_POLL_WORKQUEUE);
>   	if (IS_ERR(sc->ib.send_cq)) {
>   		pr_err("Can't create RDMA send CQ\n");
> @@ -2056,7 +2108,7 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
>   	}
>   
>   	sc->ib.recv_cq = ib_alloc_cq_any(sc->ib.dev, sc,
> -					 sp->recv_credit_max,
> +					 cap->max_recv_wr,
>   					 IB_POLL_WORKQUEUE);
>   	if (IS_ERR(sc->ib.recv_cq)) {
>   		pr_err("Can't create RDMA recv CQ\n");
> @@ -2065,6 +2117,14 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
>   		goto err;
>   	}
>   
> +	/*
> +	 * We reset completely here!
> +	 * As the above use was just temporary
> +	 * to calc max_send_wr and rdma_send_wr.
> +	 *
> +	 * rdma_create_qp() will trigger rdma_rw_init_qp()
> +	 * again if max_rdma_ctxs is not 0.
> +	 */
>   	memset(&qp_attr, 0, sizeof(qp_attr));
>   	qp_attr.event_handler = smb_direct_qpair_handler;
>   	qp_attr.qp_context = sc;
> @@ -2084,18 +2144,6 @@ static int smb_direct_create_qpair(struct smbdirect_socket *sc,
>   	sc->ib.qp = sc->rdma.cm_id->qp;
>   	sc->rdma.cm_id->event_handler = smb_direct_cm_handler;
>   
> -	pages_per_rw = DIV_ROUND_UP(sp->max_read_write_size, PAGE_SIZE) + 1;
> -	if (pages_per_rw > sc->ib.dev->attrs.max_sgl_rd) {
> -		ret = ib_mr_pool_init(sc->ib.qp, &sc->ib.qp->rdma_mrs,
> -				      sc->rw_io.credits.max, IB_MR_TYPE_MEM_REG,
> -				      sc->rw_io.credits.num_pages, 0);
> -		if (ret) {
> -			pr_err("failed to init mr pool count %zu pages %zu\n",
> -			       sc->rw_io.credits.max, sc->rw_io.credits.num_pages);
> -			goto err;
> -		}
> -	}
> -
>   	return 0;
>   err:
>   	if (sc->ib.qp) {

