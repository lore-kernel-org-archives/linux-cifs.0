Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B7F22126C
	for <linux-cifs@vger.kernel.org>; Fri, 17 Oct 2025 06:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.76.82.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760683486; cv=none; b=TQA3PW7rPTEZBF/kjLTKTEAt2wWfUiSBQlkQElIUsmFiuNGwWFNEZNXGpqexCKnbQazfDkBi5W81Pn7PADsl/dXkqfTbdK2+vAB/aASBXdoDfQ1+Q7UlcFuEyAKww7QxUgMaSs5ZAnQrZP0V024Qp3b0YnuG4uZG+9gvXhuuIXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760683486; c=relaxed/simple;
	bh=bKdenSgPtqtvDENXBlweLTmt45SekdIGbAgagjiPFDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/zDB0rUSJAsLZKjPvLbKSJgjqxPpZ6F5yfVjoOZUrsACgf4UxTR/CVzhDROC+VoTncA/JTwGEdkh22ZTbntZZbRB1Q/+oVWJOZgiIkM0VDcdyimTN4TCAdHLJ7waWyaCcFT9mJ3Yw+JWYzjRHu6OKdR/1evLTwEf85hpUyabC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org; spf=pass smtp.mailfrom=samba.org; dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b=1AB/WKti; arc=none smtp.client-ip=144.76.82.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="1AB/WKti"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=AmwiwEpF7XT64Zpb+qYiYLYIgm3tDbGaM51BDaeEyzc=; b=1AB/WKtib3TneeQ+qw7zRFdi0C
	G1AZDhk3qGusmkqZCAOxnuhFxFpk7imH0lSGijFNQw9xRRnyw1XSGuzqaoGDrqgJBKr8mTwuOFtPh
	FZJTGPF3rldscOPM6V9IDah3r5UjsArqFnkeUGypm/C/dkZozEO4FfjnsBOlBud3bevJx7/6BoI1Z
	bjItn+AVd0nJTxZJycVRUw/B4c8nui9lI4Ff4J5L5oWZtbpBLPYlM4CoD8jfO+tn+wUEu/baFPlSX
	xsE19liyzrzHkPvmFGGUDBxQVrSXfvwj7ZLDvMj84000juUtNMhGVULEas46ATT7SFXDTkO5/hGQ3
	bEifCLO80a0QwqXdsSaPG/xkum5P1VtPv9HC5F3gaEOr96kaxpRN3dY81zyvr9zMt8d+QAq7ix1dz
	XPi3YcZ+tqkwA8205WqzPcEqVsBiOwKduiCBadgM5qMVLeqpDKp27n/gDN7sbcyl9urDssLfpabZB
	FppYjOiADm4ktEguZSetWnkx;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1v9eCg-009h3V-0F;
	Fri, 17 Oct 2025 06:44:42 +0000
Message-ID: <330fe831-4f29-4327-b737-d2c9f03c33c5@samba.org>
Date: Fri, 17 Oct 2025 08:44:41 +0200
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] smb: server: allocate enough space for RW WRs and
 ib_drain_qp()
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
 Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>
References: <20251016142109.1278810-1-metze@samba.org>
 <CAKYAXd95632J0h1-Hp339LgTRdNhXTfwpcrS90-QcEGn3UfX-w@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd95632J0h1-Hp339LgTRdNhXTfwpcrS90-QcEGn3UfX-w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.10.25 um 08:34 schrieb Namjae Jeon:
> On Thu, Oct 16, 2025 at 11:21 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Make use of rdma_rw_mr_factor() to calculate the number of rw
>> credits and the number of pages per RDMA RW operation.
>>
>> We get the same numbers for iWarp connections, tested
>> with siw.ko and irdma.ko (in iWarp mode).
>>
>> siw:
>>
>> CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 256
>> CIFS: max_sgl_rd=0, max_sge_rd=1
>> CIFS: responder_resources=32 max_frmr_depth=256 mr_io.type=0
>> CIFS: max_send_wr 384, device reporting max_cqe 3276800 max_qp_wr 32768
>> ksmbd: max_fast_reg_page_list_len = 256, max_sgl_rd=0, max_sge_rd=1
>> ksmbd: device reporting max_cqe 3276800 max_qp_wr 32768
>> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
>> ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
>> ksmbd: Info: rdma_send_wr 27 + max_send_wr 256 = 283
>>
>> irdma (in iWarp mode):
>>
>> CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144
>> CIFS: max_sgl_rd=0, max_sge_rd=13
>> CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
>> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
>> ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
>> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
>> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
>> ksmbd: New sc->rw_io.credits: max = 9, num_pages = 256, maxpages=2048
>> ksmbd: rdma_send_wr 27 + max_send_wr 256 = 283
>>
>> This means that we get the different correct numbers for ROCE,
>> tested with rdma_rxe.ko and irdma.ko (in RoCEv2 mode).
>>
>> rxe:
>>
>> CIFS: max_qp_rd_atom=128, max_fast_reg_page_list_len = 512
>> CIFS: max_sgl_rd=0, max_sge_rd=32
>> CIFS: responder_resources=32 max_frmr_depth=512 mr_io.type=0
>> CIFS: max_send_wr 384, device reporting max_cqe 32767 max_qp_wr 1048576
>> ksmbd: max_fast_reg_page_list_len = 512, max_sgl_rd=0, max_sge_rd=32
>> ksmbd: device reporting max_cqe 32767 max_qp_wr 1048576
>> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256
>> ksmbd: New sc->rw_io.credits: max = 65, num_pages = 32, maxpages=2048
>> ksmbd: rdma_send_wr 65 + max_send_wr 256 = 321
>>
>> irdma (in RoCEv2 mode):
>>
>> CIFS: max_qp_rd_atom=127, max_fast_reg_page_list_len = 262144,
>> CIFS: max_sgl_rd=0, max_sge_rd=13
>> CIFS: responder_resources=32 max_frmr_depth=2048 mr_io.type=0
>> CIFS: max_send_wr 384, device reporting max_cqe 1048574 max_qp_wr 4063
>> ksmbd: max_fast_reg_page_list_len = 262144, max_sgl_rd=0, max_sge_rd=13
>> ksmbd: device reporting max_cqe 1048574 max_qp_wr 4063
>> ksmbd: Old sc->rw_io.credits: max = 9, num_pages = 256,
>> ksmbd: New sc->rw_io.credits: max = 159, num_pages = 13, maxpages=2048
>> ksmbd: rdma_send_wr 159 + max_send_wr 256 = 415
>>
>> And rely on rdma_rw_init_qp() to setup ib_mr_pool_init() for
>> RW MRs. ib_mr_pool_destroy() will be called by rdma_rw_cleanup_mrs().
>>
>> It seems the code was implemented before the rdma_rw_* layer
>> was fully established in the kernel.
>>
>> While there also add additional space for ib_drain_qp().
>>
>> This should make sure ib_post_send() will never fail
>> because the submission queue is full.
>>
>> Fixes: ddbdc861e37c ("ksmbd: smbd: introduce read/write credits for RDMA read/write")
>> Fixes: 4c564f03e23b ("smb: server: make use of common smbdirect_socket")
>> Fixes: 177368b99243 ("smb: server: make use of common smbdirect_socket_parameters")
>> Fixes: 95475d8886bd ("smb: server: make use smbdirect_socket.rw_io.credits")
>> Cc: Namjae Jeon <linkinjeon@kernel.org>
>> Cc: Steve French <smfrench@gmail.com>
>> Cc: Tom Talpey <tom@talpey.com>
>> Cc: linux-cifs@vger.kernel.org
>> Cc: samba-technical@lists.samba.org
>> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> Have you run checkpatch.pl before submitting the patch ?

No, sorry, I only have it in my script that submits more than
one patch, I need to add to the send one patch script.

> WARNING: quoted string split across lines
> #337: FILE: fs/smb/server/transport_rdma.c:2046:
> + pr_err("Possible CQE overrun: max_send_wr %d, "
> +        "device reporting max_cqe %d max_qp_wr %d\n",
> 
> WARNING: quoted string split across lines
> #350: FILE: fs/smb/server/transport_rdma.c:2059:
> + pr_err("Possible CQE overrun: rdma_send_wr %d + max_send_wr %d = %d, "
> +        "device reporting max_cqe %d max_qp_wr %d\n",
> 
> WARNING: quoted string split across lines
> #362: FILE: fs/smb/server/transport_rdma.c:2071:
> + pr_err("Possible CQE overrun: max_recv_wr %d, "
> +        "device reporting max_cpe %d max_qp_wr %d\n",
> 
> total: 0 errors, 3 warnings, 305 lines checked
I'll update these.
metze
