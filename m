Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF46623505B
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748474947; cv=none; b=JbZbduKmMWobsvb+vW7ucOQyXPTjceEuLEcuMaqphU0okBSqZNaQELVgT++OEw7bN1KykWPqQGg2VlFVAaGGWfZXKbzVDWN32XlMsoWvd7yEUsIblIKVprHdTjauOqKfXrz1CRjkd7fv9+y4cx7Czm/3zXY/CNJLEfQu6aiVWJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748474947; c=relaxed/simple;
	bh=zneln3AVy9GzuOLcazXpnBiKXS/mH1mKIHA9Be7pcss=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jBlO8nG5C0jzIMFH6vcfQxCE9M6tkw8HhDq2IUhQS4kX6Su7tidhWgv/EfBo5U6KmcEZi5tqhzVRM9g2VJOI64UfRY8ie8NlnlUStqv8hTSRXSl93IQfiSO8J/JScLG7f6r433qM5RVQhXOj8R2ODkKpz9ccs1dV2GQBS+Ncr+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dOrRZSAM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dOrRZSAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55918C4CEE3
	for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 23:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748474946;
	bh=zneln3AVy9GzuOLcazXpnBiKXS/mH1mKIHA9Be7pcss=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dOrRZSAMqZhXxwF/jsjqg2S2ZiDgJDft1w1k6clZhNEJ80+/9lvW9zuHT3Ggbgk+0
	 iKujcHg2pozwS+1IP6pgAYa47s5vPAU5rVLrG0e4ZzLRrVLa+MHvWr1QK+lKoFDFsu
	 unFKAZBVX685o5K6iV6nt189f4EhyXK4E/+Ci7Vbtw8i7q4I/C6v+0+0yczIrYdkV3
	 kpBsWvP7SspXrsyL2Ghl5UDiQagPG18QVfXIpJeTgJ4LJOHcKWXiT29CRpovp/bZrg
	 x0gUBGpHJCU7PjEjAQgVDebf/u0Ob/rj/YUCx+CmxcTHmDcLDPo677Csyd4CMjLxUQ
	 2e7xhPocfMqaw==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-602346b1997so565727a12.3
        for <linux-cifs@vger.kernel.org>; Wed, 28 May 2025 16:29:06 -0700 (PDT)
X-Gm-Message-State: AOJu0YwEQNL/EfCaxiMwRB0y+Q7W30xtDF/F5NgfboAohmcTUwK6w27k
	OoOsDu6lmn9QjewAgGNq3JqgYPNpN8uIgow4HsjS2ObLHERwJ8V66OR9LsQ61syYWu+i5MRjpsH
	WbJm/FHCFzsi60uGnjCSK1AQ31lwy7tY=
X-Google-Smtp-Source: AGHT+IEe0cGbFuMCZiSElYdmz+9UTowYbCcQ62DFXujgMwP14Iy1+SUnvNmkiO1XCPczAw0xZDfrFjwA+UtQRNVKYtI=
X-Received: by 2002:a17:907:9715:b0:ad8:8841:b393 with SMTP id
 a640c23a62f3a-ad88841b3a0mr868768166b.6.1748474944920; Wed, 28 May 2025
 16:29:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1748446473.git.metze@samba.org> <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
In-Reply-To: <b43ee94c3db13291156e70d37a3e843ad7d08b31.1748446473.git.metze@samba.org>
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Thu, 29 May 2025 08:28:53 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
X-Gm-Features: AX0GCFvWJS9sSOn1SBVoAK4aYtA1DkpHP2uL3fZYfwzQcuj0g5JuU1qeWnftKHQ
Message-ID: <CAKYAXd_df0mwgAbJb3w_r_8JmJOAZjPfhjoFpWgTkWJFdMWUMA@mail.gmail.com>
Subject: Re: [PATCH v2 01/12] smb: smbdirect: add smbdirect_pdu.h with
 protocol definitions
To: Stefan Metzmacher <metze@samba.org>
Cc: linux-cifs@vger.kernel.org, Steve French <smfrench@gmail.com>, 
	Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>, Hyunchul Lee <hyc.lee@gmail.com>, 
	Meetakshi Setiya <meetakshisetiyaoss@gmail.com>, samba-technical@lists.samba.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 29, 2025 at 1:02=E2=80=AFAM Stefan Metzmacher <metze@samba.org>=
 wrote:
>
> This is just a start moving into a common smbdirect layer.
>
> It will be used in the next commits...
>
> Cc: Steve French <smfrench@gmail.com>
> Cc: Tom Talpey <tom@talpey.com>
> Cc: Long Li <longli@microsoft.com>
> Cc: Namjae Jeon <linkinjeon@kernel.org>
> Cc: Hyunchul Lee <hyc.lee@gmail.com>
> Cc: Meetakshi Setiya <meetakshisetiyaoss@gmail.com>
> Cc: linux-cifs@vger.kernel.org
> Cc: samba-technical@lists.samba.org
> Signed-off-by: Stefan Metzmacher <metze@samba.org>
> ---
>  fs/smb/common/smbdirect/smbdirect_pdu.h | 55 +++++++++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 fs/smb/common/smbdirect/smbdirect_pdu.h
>
> diff --git a/fs/smb/common/smbdirect/smbdirect_pdu.h b/fs/smb/common/smbd=
irect/smbdirect_pdu.h
> new file mode 100644
> index 000000000000..ae9fdb05ce23
> --- /dev/null
> +++ b/fs/smb/common/smbdirect/smbdirect_pdu.h
> @@ -0,0 +1,55 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *   Copyright (c) 2017 Stefan Metzmacher
Isn't it 2025? It looks like a typo.

And why do you split the existing one into multiple header
files(smbdirect_pdu.h, smbdirect_socket.h, smbdirect.h)?

> + */
> +
> +#ifndef __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__
> +#define __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__
> +
> +#define SMBDIRECT_V1 0x0100
> +
> +/* SMBD negotiation request packet [MS-SMBD] 2.2.1 */
> +struct smbdirect_negotiate_req {
> +       __le16 min_version;
> +       __le16 max_version;
> +       __le16 reserved;
> +       __le16 credits_requested;
> +       __le32 preferred_send_size;
> +       __le32 max_receive_size;
> +       __le32 max_fragmented_size;
> +} __packed;
> +
> +/* SMBD negotiation response packet [MS-SMBD] 2.2.2 */
> +struct smbdirect_negotiate_resp {
> +       __le16 min_version;
> +       __le16 max_version;
> +       __le16 negotiated_version;
> +       __le16 reserved;
> +       __le16 credits_requested;
> +       __le16 credits_granted;
> +       __le32 status;
> +       __le32 max_readwrite_size;
> +       __le32 preferred_send_size;
> +       __le32 max_receive_size;
> +       __le32 max_fragmented_size;
> +} __packed;
> +
> +#define SMBDIRECT_DATA_MIN_HDR_SIZE 0x14
> +#define SMBDIRECT_DATA_OFFSET       0x18
> +
> +#define SMBDIRECT_FLAG_RESPONSE_REQUESTED 0x0001
> +
> +/* SMBD data transfer packet with payload [MS-SMBD] 2.2.3 */
> +struct smbdirect_data_transfer {
> +       __le16 credits_requested;
> +       __le16 credits_granted;
> +       __le16 flags;
> +       __le16 reserved;
> +       __le32 remaining_data_length;
> +       __le32 data_offset;
> +       __le32 data_length;
> +       __le32 padding;
> +       __u8 buffer[];
> +} __packed;
> +
> +#endif /* __FS_SMB_COMMON_SMBDIRECT_SMBDIRECT_PDU_H__ */
> --
> 2.34.1
>
>
