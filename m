Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793117283;
	b=xBmXD15K9U82juWMk+AlREa2BKyWhj8X5GJUEcwZGf357KegIMSHHxp9007UcKsk82iC
	 xtKKQstIqTZvL59m68QRi6BeAXQhrX/PFNOXR+XaiSul6tXtokcsaD8C3YfaRCjJ5CuZx
	 K6AG+FGz/URisyYZAWY4u07JZJabyJdCC6UhdSvkmGeLXYwkGZvVGW3S9042qYbMp1jRa
	 IK/SsoI8PMdVlVKW7CSm/G52EOoVnGMlryFhS7iVSZCnvy0mnf4DS4poC8s8bFlmf+/C0
	 Iq5vK0+OyG58+2CeAbUuYCz7Yey9QQ+z/jI5K6qyXrGuzmNJAvOqAMg7CdCjNreo5pg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793117283;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:From:Date:X-Gm-Features:Message-ID:Subject:To:
	 Content-Type;
	bh=ffMBajTL6Nz8q6evxLu9k4sljfzvWuKzldEDv2c+7M0=;
	b=VSQPUZhPw4Tez9Bhcz2wOlrqEE5e4iz4k/m27vzSPKvlNNrgsunCF8y5NMYutZ3dDGh+
	 MJ6Hr5yaotkid7F6ReKu1fueTqGI3aTnomauo0Nbw/a0I01dXlrfF6JX01s+8RU56MHB+
	 NbJlkuRSDLEdpN7XNB9dlUw+MYpTUGiokzLQLJEstzjGDbCI7c/+gdf709/RkUPaTIYdj
	 d1XJY9JtZhntjj6MbwTBV0jmDvHtgRFN6EAQiCvItFyjRGJcY0wbFt95K40vxJ5v1BVnL
	 VLAlXn480vM2CbNXQJslMujNkdk8oA8YTGr2BFl0+Myl4NdOmyOnbZAM39uBUswPuSQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A18zgnQw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491FF606A322
	for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 16:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 491FF606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A18zgnQw
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6aa8d04fcddso24949a12.0
        for <linux-cifs@vger.kernel.org>; Tue, 27 Oct 2026 09:08:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793117282; cv=none;
        d=google.com; s=arc-20260327;
        b=Ox+DiKLPliLyzuJR1r3i6Gtxp2goyAQwmEUF318jkwsLpC6Z86l+hi9tEbGx8nkb5j
         y9SWTze01Va8E8/7xh4tq2NyeY4HUFH+IQtItXPjhodzsW3RdAShExSscTF8B0ZSHwDN
         KCpWS6bu60j38T9WsCsukfsTXfeb1YUgEYaxGmAmWS1exnbYagUgT3GzOtaigVyjH1py
         C4ssiIZM0Mp4+Qc9WPll6tICGmiC9FLXkA1RCXemEezIYBAX9cC0+zJoWtL2MFncqInW
         RJ8x/uvjitjL5qKxzAijovqMwj0TBLwzkko0IzlRn2tmDYTHxKKvMSR82k2TBsL5THv4
         xh1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=ffMBajTL6Nz8q6evxLu9k4sljfzvWuKzldEDv2c+7M0=;
        fh=J8KTvsTrv1zFjsh2mwfSZJqXOFWhjUMO94F6iRfu6bs=;
        b=YVpb/C1+ZPdmyYcv5Dl2Yx0GrisjL/Zj3BRvoAXoC8Tzz1XNiOIz6Ep20g60icDV7q
         qfY1VuiULIl3MXZ8dXTrp3tlUdwIQhgf9UBHtf/Y2nz8/NPWzfSCyo8J9D7QSZcpKOKs
         qpbr8wvVurw/aGoGvaj7b0MBVDt3sLTjpv1EKFvGUVVwRyuJGGGVSJa1nl56URxkDX/y
         1k+3mgoMrUVyNjZIEhXf00VZcYz3Pragr9YRV5pt4mhDeMarq3zGFRfmfpnAh4CufyfZ
         x0nxiOrVFPqc5+b7bAyoLH1ADE5PQDzj6I517LspLu8PBiOkJTl1o9NWeW8IUn4GGbMx
         lVVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117282; x=1793722082; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ffMBajTL6Nz8q6evxLu9k4sljfzvWuKzldEDv2c+7M0=;
        b=A18zgnQwuwZSWVntRFknw0mMD++F9+U2h5FcxIhXsikfrofj8fyjTSXeFkL5wNyweM
         BL5ne5/cNi8QZMmEsNlGhYwpfSFLsabbFhAoupZvZKqhflVr7MwIqflEEVOpp2L5rHG8
         h8GNrnMQdOm21g3WzHwSOA4s45ynsDrHLLOMSuKBPWUD/viVy05Zpg3JJE/Fu06iBUnD
         29eodM/XcBK89NIxV8vXs6nsm6o/iTLExhe0iDWyyFYRFt7orDzm/n8tSrrv8B29jVDk
         ySLKmJtmFSYwbIOCy/mogYbptpm/hr2ejktgu778NWx0FGy8lojgfCGXktLP352Iav2e
         GpjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117282; x=1793722082;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ffMBajTL6Nz8q6evxLu9k4sljfzvWuKzldEDv2c+7M0=;
        b=1coS+uv5BmXlwQcQgqDHR0vb04Wix2Pm2PMfqsD3P0ufu2jv67mWHfMsDLnfkpl9HM
         4EvyNslBDqhrBnO2KCwEhBv9RRkFatvw2EgycHmtKbA8NauhIAMkogcAY15iE8ve3254
         rVvF1z8PeCp9ZInJyDCFDThOC7TMEC8Mynx9Uq1Iva7/48HBDZI5kLUIztZUAz6Yes4D
         nurrNCBqLWVpBebIVHDfyZld9HCZ01t1fAR9rsdYX848rpZsDMWZt+iKtrf4MJCoavpK
         WkzTj2zWBvMurfyKVI1PSjRaMOH+QtWWoIvVzg0nv+mfjrVE1ufstBCxXK4RbPog1aqh
         00lw==
X-Forwarded-Encrypted: i=1; AKwUvBz37RGar+B6OGyhB4W9ulE723pm6ifKL+1CPWOPyCZYYgN4QCptVkw8kUvkSuCfQbk0iXtuwgRBLkhF@vger.kernel.org
X-Gm-Message-State: AFq9FYK4p2OBWH7vn4xvmpCnlFc+RyZVUn4wWl0b8L4rSpnVowkCLe77
	cVy3lR0uEA+0KrWb0w3nc14wbbjUqvQgViKp/Hm7BKXrToCQBsQUw/8NvcdeS6ku0ihMpLF2p9e
	YgcD22rWFx9VtnRSBg17nJTTBthvLkiGfuuuA
X-Gm-Gg: AYBFou1OmCUh3aMCr2B3HXJaLzJuFrtYpH+syDbGq78D9oXpBdYGVUiXZKZZlRzqTkl
	NuIky6SVhZAybflhOd9LxI40lxvPov2u8Dt3HmqTLrUmmUF+pNV/e5+3bClqY98YESXpJ+CFqz9
	6td7fovYTFDI2h9bKk+01GKMWCejPJI0LW3qGDopiTNsHU1/Bd2iuSOuh3t7IoTgLjM8iwwkcBi
	bBOXiVryAme/jS6xOtkv3a1tii18Gn4XqtOpAukaLTMOx1oulSClwNNcHy23LZpROrl+C4gP860
	q1xiwi4ZjWLlrk1k3UpPpEpBe4C9rIBeHgwRgGACwIRCKHKkze3AJdMRCAsjQEUVLHdfhKIN9l+
	/6GTyGBAxpneaIe/vP4ufzxpGmR6S5P2Nb14DQTrK7DIbzoLWnh12mREUl24fuV+RYl8XXZ+LEf
	XJjzGHVWr3wG4kZQ23/DP/E3iJxGtIWy23YAZjuTU=
X-Received: by 2002:a05:6402:a6c3:10b0:6b3:d0a0:39c9 with SMTP id
 4fb4d7f45d1cf-6b47bb19003mr1959908a12.6.1793117281425; Tue, 27 Oct 2026
 09:08:01 -0700 (PDT)
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: =?UTF-8?B?7J207ISx7ZiE?= <ihopenre@gmail.com>
Date: Tue, 27 Oct 2026 23:07:48 +0700
X-Gm-Features: AclHuK8vEWhEfLJm_6w4F6_smp7IV3SZemLFoGqvJivCEaGtkqcRTQMAWDLPr_c
Message-ID: <CANTrAmxiBn6GT+N5qivdf=xtGg6yFksK5qN_PhpoNdxXDSpikA@mail.gmail.com>
Subject: Backport request: ksmbd and smbdirect fixes merged in 7.4-rc
To: stable@vger.kernel.org, Namjae Jeon <linkinjeon@kernel.org>, 
	Stefan Metzmacher <metze@samba.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

```
Hi,

Please consider the following fixes, all merged into mainline during
the 7.4 merge window, for the stable trees listed. None of them
carried a Cc: stable tag.

1) 4ca76b89917a ("smb: smbdirect: don't wait for
RDMA_CM_EVENT_DISCONNECTED in smbdirect_socket_destroy_sync()")
   328c7e307e84 ("smb: smbdirect: release failed pending sockets of a listener")
   5c171c90c446 ("smb: smbdirect: don't hand out already failed
sockets in smbdirect_socket_accept()")

   Trees: 7.3.y and 7.2.y (Fixes: dc691b91ad16, first released in 7.1).
   Please apply the three in this order; they were posted as one series.

   Without 328c7e307e84 an unauthenticated peer can permanently stop
   ksmbd from accepting SMB-Direct connections: every connection that
   fails before negotiation completes stays on the listener's pending
   list and counts against the backlog of 10, after which every new
   connection is rejected with -EBUSY until the listener is destroyed.
   I reported this and reproduced it on 7.3-rc2 with a small rdmacm
   client; about eleven connect-then-disconnect cycles are enough.

2) 68f410faedaf ("ksmbd: wait for negotiation before receiving another PDU")

   Trees: all supported stable trees that contain dc8289f91238
   (Fixes: dc8289f91238, "ksmbd: fix slab-out-of-bounds in init_smb2_rsp_hdr").

   The receive thread can read and dispatch the next PDU while the
   negotiation worker is still running, so a pipelined SMB2 NEGOTIATE
   after an SMB1 negotiate replaces conn->ops under the worker and the
   worker reads past the shorter SMB1 request buffer. This is reachable
   before authentication and leaks adjacent heap bytes in the response.
   I reported this to Namjae and reviewed the fix.

3) ef85bad39cf2 ("ksmbd: reject FSCTL_SET_ZERO_DATA on a directory handle")

   Tree: 7.3.y (Fixes: 25e414db7033, first released in 7.3).

   An authenticated client can open a directory with FILE_WRITE_DATA
   and send FSCTL_SET_ZERO_DATA on it; ksmbd_vfs_zero_data() then calls
   kernel_write() on a directory file without FMODE_WRITE, which hits
   WARN_ON_ONCE in __kernel_write_iter() and panics a panic_on_warn
   kernel. I wrote this fix.

I cherry-picked all five commits in this order on top of v7.3 and v7.2.9
and they apply cleanly without changes.

Thanks,
Lee Seong Hyeon
```
