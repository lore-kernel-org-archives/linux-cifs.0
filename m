Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=144.76.82.148
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792753338;
	b=gKiXdQs//EKkRKg4KAmHm0/I34QUyAkM6IWMtVvQMsmfYqWYfT0Q5lKXCvNigcNFpMNO
	 v2El4/KLV1SigXYUO8MnaGsedbyfKHna6YbnMXhyIWZhZiKpKBh4pSSzMvqx6jguVP8m7
	 fBtG4lgdrG3bBRu/c8AnT5aCvTWaPcxC6PfJT5rVMx2+oA4fMP6Q9toU6eUAK9/3kjnSH
	 JQanmqeep2Dp1jLT5nkC/gUBoqpFjGMr9ZKoKYwq7suZAs7bb+7GGqUvjeaBekXUTBa9D
	 ey29Y/Nk/h+uIESwLH7r9VGHCUYLnDonbxf+loOe3ksCJO0bxOB4y2F3/hDS/zAbCjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792753338;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=xrChMC+6X31tfEovrmOoBciz6x6vzuAWl0EBL+kMq8Q=;
	b=D5usPIcMKEfFIt12lMT3kwqFfuC7ock6okLNgfq3LPY9kQCgEMmsDWe5RHzz/DQVbR14
	 xsBvIci6TMXdXYNJmBF+9+TdBOux+TfoejJ7Koi+Bhu1690oXQQTcT8qxQKhzydFPZPBu
	 cGLQI9jAkpeDGKhMjJ1IFzapZv+PDfI3raQFK1cIdJmTxf9Tk0X35LgNCZXUereOriD38
	 WgxHruBZSqZjWrCfkGFXJcA06KO+feH+T9IibsTXHkkDthTRSEdQ09Fs+5AQ7APmd37EO
	 sBJNowGf/3bXWHZBY8FHGbEDqn4+dr2krdHusC0O4ojLqlHr5dhIMNMYWmNaqgQrWpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=samba.org;
	spf=pass smtp.mailfrom=samba.org;
	dkim=pass header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=BCAdVLAs;
	arc=none smtp.remote-ip=144.76.82.148
Received: from hr2.samba.org (hr2.samba.org [144.76.82.148])
	(using TLSv1.3 with cipher TLS_CHACHA20_POLY1305_SHA256 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7199606A31B;
	Fri, 23 Oct 2026 11:02:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7199606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=samba.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samba.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key, unprotected) header.d=samba.org header.i=@samba.org header.a=rsa-sha256 header.s=42 header.b=BCAdVLAs
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=From:Cc:To:Date:Message-ID;
	bh=xrChMC+6X31tfEovrmOoBciz6x6vzuAWl0EBL+kMq8Q=; b=BCAdVLAshNHA+MB/VWhOmHnbhk
	cCyAYdCJLQ+YozoABdq0OZlB4oLwj6Jevv/sBdEaChq7zTx77hKws1RoXCSel8ojyqAl6LY7ZfHa7
	W70SPgJCpTlnOofZtn0PvD77lv0ACtEIPBhFUXOBnuEvakb1za5F9dSsm4RdLvgwViVZgqcOWoI7t
	C7qg4jIE3IJfI3JsyqMnd16E/tWTaNjocf/D8dBbcYdw21LyCnDbjyWvtYzYaO4gd179pUOYjiix1
	vx7lJYAw7V2wxXlH1MN4I7g4EI0MXazlHsmUtExn+ZcrfBrccGis3UvcPUD9ogL9ZGEtgbIcONW87
	2q8WVqI9tFEJ/v3MVaTmqbTvrP3jnPyBm9og6AXBe6qpgEJEdocHmXwdfutaeVBcXIz2aZD21dTAV
	OkxhvBIkExqoi3iNSp3u4SWUtdi1XTY86Wsfb4WJaiCZia4AG6eWuNSBeQBT1RfNkS3qbk28u1Ksk
	1xQN5EWOV9aM5xz6sN3qtqn9;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1xKD2N-00000004gmN-3PKe;
	Fri, 23 Oct 2026 11:02:15 +0000
Message-ID: <08f2aebc-a45b-489d-ab31-d7f65b5c35cf@samba.org>
Date: Fri, 23 Oct 2026 13:02:15 +0200
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ZDI-CAN-33549: New Vulnerability Report
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>,
 "security@kernel.org" <security@kernel.org>,
 "open list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <linux-cifs@vger.kernel.org>, Paulo Alcantara <pc@manguebit.org>,
 "moderated list:SMBDIRECT (RDMA Stream Transport with Read/Writ..."
 <samba-technical@lists.samba.org>, open list <linux-kernel@vger.kernel.org>,
 Tom Talpey <tom@talpey.com>
References: <BYAPR01MB3830472B5702C089B0BBB77D80662@BYAPR01MB3830.prod.exchangelabs.com>
 <bd43bd47-688e-45ba-9fd3-e32da2bb691a@samba.org>
 <dec5c659-a8bd-43db-a5b4-55d78fa37db0@samba.org>
 <CAKYAXd__odzY0tuTu3mNgjmYibc3Js+zgNGYb9q0ywms7L9j+w@mail.gmail.com>
Content-Language: en-US
From: Stefan Metzmacher <metze@samba.org>
In-Reply-To: <CAKYAXd__odzY0tuTu3mNgjmYibc3Js+zgNGYb9q0ywms7L9j+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.10.26 um 12:36 schrieb Namjae Jeon:
> On Fri, Oct 23, 2026 at 6:04 PM Stefan Metzmacher <metze@samba.org> wrote:
>>
>> Am 22.10.26 um 00:16 schrieb Stefan Metzmacher via samba-technical:
>>> Hi HYEONTAE LEE,
>>>
>>> would you be able to test if this is reproducable on this branch:
>>> https://git.samba.org/?p=metze/linux/wip.git;a=shortlog;h=refs/heads/for-7.5/smbdirect
>>> git clone -b for-7.5/smbdirect  https://git.samba.org/metze/linux/wip.git for-7.5-smbdirect
>>>
>>> I guess it's already fixed with that.
>>>
>>> Thanks!
>>> metze
>>>
>>> Am 21.10.26 um 23:16 schrieb zdi-disclosures@trendmicro.com:
>>>> ZDI-CAN-33549: Linux Kernel KSMBD SMB Direct Integer Underflow Remote Code Execution Vulnerability
>>>>
>>>> -- CVSS -----------------------------------------
>>>>
>>>> 9.0: AV:N/AC:H/PR:N/UI:N/S:C/C:H/I:H/A:H
>>>>
>>>> -- ABSTRACT -------------------------------------
>>>>
>>>> Trend Micro's Zero Day Initiative has identified a vulnerability affecting the following products:
>>>> Linux - Kernel KSMBD
>>>>
>>>> -- VULNERABILITY DETAILS ------------------------
>>>> * Version Tested:7.3-rc3
>>>> * Platform Tested:debian trixie
>>>>
>>>> ---
>>>>
>>>> ### Analysis
>>>>
>>>> integer underflow in smbdirect_connection_rdma_xmit()
>>>> The reproduce kernel built with CONFIG_SMB_SERVER_SMBDIRECT=y + CONFIG_RDMA_RXE=y
>>>> Here is the target requirement
>>>> 1) RDMA device
>>>> 2) writable share
>>>> 3) smb direct (ubuntu only)
>>>>
>>>> ~~~C++
>>>> int smbdirect_connection_rdma_xmit(struct smbdirect_socket *sc,
>>>>                     void *buf, size_t buf_len,
>>>>                     struct smbdirect_buffer_descriptor_v1 *desc,
>>>>                     size_t desc_len,
>>>>                     bool is_read)
>>>> {
>>>> ...
>>>>      for (i = 0; i < desc_len / sizeof(*desc); i++) {
>>>>          if (!buf_len)
>>>>              break;
>>>>
>>>>          desc_buf_len = le32_to_cpu(desc[i].length);
>>>>          if (!desc_buf_len)
>>>>              return -EINVAL;
>>>>
>>>>          if (desc_buf_len > buf_len) {
>>>>              desc_buf_len = buf_len;
>>>>              desc[i].length = cpu_to_le32(desc_buf_len);
>>>>              buf_len = 0;                                            // (1)
>>>>          }
>>>>
>>>>          credits_needed += smbdirect_connection_calc_rw_credits(sc,
>>>>                                         desc_buf,
>>>>                                         desc_buf_len);
>>>>          desc_buf += desc_buf_len;
>>>>          buf_len -= desc_buf_len;                                    // (2) integer underflow, and leads to heap overflow within rxe_mr_copy()
>>>>          desc_num++;
>>>>      }
>>
>> As far as I can see the problem is solved in by patches,
>> but we should have a simple fix first.
>>
>> I think removing ' buf_len = 0;' should be enough for a quick fix,
>> then 'buf_len -= desc_buf_len;' will result in buf_len == 0 and the next
>> iteration will break with if (!buf_len).
>>
>> Namjae, do you agree? Can you create such a quick fix?
> Agreed, Please check the attached patch.
> Thanks for checking this issue!

Thanks, looks good.
metze
