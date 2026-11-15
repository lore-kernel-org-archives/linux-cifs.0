Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.140
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794712037;
	b=S/meFLsy5Mof0PjsnOQvf2cNwmbOl4Xy7dAM+D5ExaMcuL/oQFFaf5axqz+RlN4YLMKQ
	 9v77Irv8Li6KfwhgZpL/z1wyHuum8iqn1MbiAK2ec+VWBXhHTj585rOGbOcGOOhOplA5e
	 6fmSmqzQukbDxcnlHPBXT21UZ0dq4qWQ6ovQqiu68Gby/tSGw2N+jl29G5w58Ozo734vv
	 1zkIPGTS3VjbDIkaQz707Vj/1gUaLDrIVLy1qi1yDxr7lwMBNXmn3tI+bTy4Qy50FQB04
	 7QbDzzoFoFH3wfQVOmmhPYHWFJmQGQBYIDTz6KenIgWVzaQq+2GwMJvSMZ9snybdsAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794712037;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
	 References:MIME-Version:Content-Transfer-Encoding;
	bh=gKN6VwWTajjvlUFrRVGdiB8bfxUd1ncQwyi3goNdenM=;
	b=gS51bftevSKX7Fth3D/n/UcCS/AvHh7xPA3oUVVEtVC29OEn28QxjewcdGQDTH4Y0jUX
	 ie0Cb6cVfftd44l6K5zxhJuSCQ0nsXQ/32jsg4gkJ8FjbxI5d9R2CA9QkkKxQsh0Dfn7B
	 K0AH6zxck+tgANfLuV7FTcb016B6vrWdfgcdz7Jevfq1u1KMtUOS4qhK5EsxSPAzGYaKF
	 U+vcM2iFVAGlqKF536kuzZ7zb1FxORhZJndM/CUEMBNhlHBbjQlQ0Rc2nuOqnMuPRxbXj
	 4cY0uUEItvHQq7CaMTv3PmQnYK8HfolNl29EwprI3G+/iiLsxjxke9q1MGCL+JywZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=KJABPBQL;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=C+T1zwq7;
	arc=none smtp.remote-ip=103.168.172.140
Received: from flow-a5-smtp.messagingengine.com (flow-a5-smtp.messagingengine.com [103.168.172.140])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5630606A327
	for <linux-cifs@vger.kernel.org>; Sun, 15 Nov 2026 03:07:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5630606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm3 header.b=KJABPBQL;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=C+T1zwq7
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailflow.phl.internal (Postfix) with ESMTP id 192F81381CA9
	for <linux-cifs@vger.kernel.org>; Sat, 14 Nov 2026 22:07:16 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Sat, 14 Nov 2026 22:07:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1794712036; x=
	1794719236; bh=gKN6VwWTajjvlUFrRVGdiB8bfxUd1ncQwyi3goNdenM=; b=K
	JABPBQLg5NoVSoqI5rAeD+skAVRekxAf+DU/sDQcSDo/hJFgvZ95P/eANzp9iQLF
	UAZ2B9xkDcsQY8iO/CYdG5kbEG/g8ahFsvSXdH9Yt3zkKI5EduBmZwdie/PwJuYN
	pr1nB0wwaTyAblHINm1kduiiToh1n4/j/pmnDr6jrVEOL7vuhvQtnl4HrOD0i+Qz
	VJNI9Qs7Z7g/sV1OgO+07SQFs26pkiTSP3Vs60Gkl3NfIhLPjnQ+GIU3l5ZcSMYY
	6BUrfLEmvcHATBcpnr0Sd/AgOFMyv61EQ6sM1H/SQz550508xTh/pdmQHOStFSC0
	jPBnhFmy4QnsJpm+0UlzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1794712036; x=1794719236; bh=g
	KN6VwWTajjvlUFrRVGdiB8bfxUd1ncQwyi3goNdenM=; b=C+T1zwq7icCIFknb3
	BIG4jj7WX4TMmdwIUWJHKWSC5MP5FgSOyj6ns0HOXIH2T5YPfN1pXKHLvRJTcCXF
	4RAfPlQFyaDVvKQjalvWxA4LjJ/6qVhuc95J9QdhnzKhyqGYbskG4iu3zE191pxw
	WwDwbbTMZ9727IA7maRC0f7969JGpM6O0GDPLjigmcmkhji8OdG0q35gF+hW194f
	3C6eO2tZZstn27vPqTyWBu8Kl65YabNpMXiXmJOgt3UinjDRAwVd6HRY84Qb8gEy
	JCXoIx71tjY+5Gw+8DNq279NyDAebk1uTlroKTom4Wr16JwSv/Q0lnbxelj1fm4V
	PzmoA==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794712036; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:O/DQ594bSQ9OaWJ4UUhUZcdp+zhmdLgZju3akyyZofcl6tz
	qD+2rBXcQYV5PWWr3Rq0M0wXivREseEl54CLuBju6dIdj5L5a6ibHm85yATvpyYH
	x1Ex08sWQVApeDLe++PSy0tY0sNqX1T8fP1aVDOuYCZZvi6An1k0j2PVvZCnQmt3
	NfpOLHOPEb7cJ81xQIB9iHVuH+kHAK3G3HLjsGLeGSyuBwfxx0jiaIKchm5pXTc2
	ALzsSl+aw40ysBDTAfoB76nnJR0zARufmdma5az4c/M+hhDaG8GDSIninuvP5g/h
	w0wpUs6LeiBGfDOTlGDFIP/JYAUbYNpZa3RNL1g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=11;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	in-reply-to,message-id,mime-version,references,subject,to;
Message-Instance: m=1; h=sha256:qU66T9RqzEc/y2kIWw23BwyWdGtBWvSxZnwtdXiF8Ss=:hXDVL1qdwuzv6gV0BtJj9GTi8M/VnQk4yRzSODQdsqo=;
X-ME-Sender: <xms:4yH5aoOSUaVeymwqj7UWvMp8iXIBRkho5J6ZLAlSRXzcZUXwLs4FGA>
    <xme:4yH5aplDodm1QFOwYsvjA4WZNJuXuztd29NqToRt-R13Q_sveAw5_a4KN3ywR5Ebe
    NTAdG5j9iksa7k5vda7q-8yBjABUPMAdPYWLVanFRcolBhJIEN_bLSR>
X-ME-Received: <xmr:4yH5alT0Ep0DPq8_3aiYw54l-eB5XCtJJ-cKgoZ0JVbPkeFnYyYMqwcf9oERuDa5>
X-ME-Proxy-Cause: dmFkZTEmAQAs53JP0iZyMPv0h/fG6Xq16Gu2IYoashXOzhNO9jFCRsH4vMrd+HZz7QG80G
    9XhEriyQdLjPfnGHNVzSfRbiMNADgBJkGTmYdzQg/vxpb/wvvP8bfHkAzsiuWXXygOlWkf
    8yOfk8yvUc+0YjzWoLH9/Y/8zqLIw2ufdO6YEWSAdyodgZOLx1g4CdK1+4TLpE0P7nlmK4
    YmfuypoXYRoTraxv4pu5WGIiIJVVDtZCpbG5ixSkiq56zVHcMIL1lQANdEtfF5W/6s9fpr
    KuRExUlT6YMw/i1oNIayOom1b2SOCwpnP0D6f9fOqlX7BbTtzJEemPUPG/IXd/S/3ht8bb
    4Kk1LQ3R5/ChSaxB7RUpXQG8F/Df1I8fcwi5XBzV7C5p1dthAuiFkypzNAvOqUeX2Yu30H
    x0IJW2SjmJ0UdRDEmXGeHv0ciT8o4l14rVtyczokKTn9rHM01YyZCof+AKxfKXjiAd1bPR
    92kXs7krOYyB1KFSiURKrzduMoxwwFgOECrDphX48ku432g25T3pxzoycmc16eaxW+V2Hl
    mAkJ3oWwm+xaXPEv9Rfkvgenmd9S7R8B3hJB00qhe2ACWUKTOST0tlo3bp8XeeJjQ7lK8e
    SULpw6jkvdhidJl/Xz4D4u+Edd0y7FY0FJaNbHTS0eDKJp864MJPY5cRxbYg
X-ME-Proxy: <xmx:4yH5agV8DMdFQnScn6NlqNzWlsRKU67NfRpY0PE0zpW_jvAAF01mmQ>
    <xmx:4yH5ahIzJRpf-0wwKglGpNRoup8eKEkDkTn78uJ5Ygk8KNM2h9ByQQ>
    <xmx:4yH5ao0j97GyAMMP1Pjo8J6lHU4sCTefoDZD4Uun3rXoXkY-9-mGJw>
    <xmx:4yH5amLSmwxD7h-26U445Nrgbi0wG60LkqQ15yxCXbpPo06xdlu3wQ>
    <xmx:5CH5akwoD7N5qymM2ghAkpUWD0beaUABhW3qf1drfNLSMUmDg7Y5Rsl3>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 14 Nov 2026 22:07:13 -0500 (EST)
From: Ian Bridges <icb@fastmail.org>
To: koray.fra@gmail.com,
	linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	hyc.lee@gmail.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>
Subject: Re: [PATCH v2] ksmbd: decode and honor DOS attribute validity flags
Date: Sat, 14 Nov 2026 21:07:07 -0600
Message-ID: <20261115030707.2275633-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <DMVECM7B14I1.3GF2HZB9KRUX@gmail.com>
References: <20261114012736.639171-1-koray.fra@gmail.com> <20261114160332.2228435-1-icb@fastmail.org> <CAKYAXd_qe-dLq6o7XdJzG8orYiKRioAtfEsLjxj33Ca3=PzGjw@mail.gmail.com> <DMVECM7B14I1.3GF2HZB9KRUX@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sun Nov 15, 2026 at 2:34 AM CET, koraynilay wrote:
> Hello, so I should include the legacy handling in this same patch and
> separate the bugfix for sparse/compression in another one?

One option might be to keep it all in this patch, with a few changes
so that it stays compatible with the xattrs older ksmbd has already
stored.

When sparse or compression updates an existing xattr, it keeps the
creation time, but ndr_decode_dos_attr() discards the flags. The
writer then stores the time with only XATTR_DOSINFO_ATTRIB set.
Checking CREATE_TIME on read would hide creation times that ksmbd
reports today.

Your changes to decode the flags and keep the existing fields are
useful. On top of those, something like this might work.

- Read the stored attributes unconditionally, including a value of 0.
  Samba also reads the attributes without checking ATTRIB.

- Use a non-zero stored creation time even when CREATE_TIME is clear,
  and fall back to the filesystem timestamp when it is 0. A comment
  could explain that older ksmbd writers lost the flag.

- When rewriting an xattr, preserve the other fields and flags, set
  ATTRIB, and restore CREATE_TIME if the time being written is non-zero.

> The problem I had found when trying this approach (I originally wanted
> to send PATCH 1/2 to fix sparse/compression and 2/2 for the decode/read
> fixes) is that with only the sparse/compression patch applied, ksmbd
> clobbers the time on reading by reporting 0, since it doesn't check
> the flags and reads the timestamp anyway.

With the reader change in the same patch, a creation time of 0 would
select the filesystem timestamp. That handles attribute-only xattrs,
but it would not make the writer change safe to apply on its own.

> Please tell me if I wasn't clear, this patch/bug is quite confusing for
> me since it touches a few bugs and they all depend on each other.
> (And one fix introduces another bug fixed by the next fix).

Keeping the current no-xattr initialization would avoid that ordering
problem altogether. We could fix preservation of existing xattrs here
and consider changing newly written xattrs separately.

It might also be best to leave changes to ITIME validity policy out of
this fix. I don't think ksmbd uses the itime for anything it reports, so
those changes would not affect this bug.

Namjae, would accepting a non-zero creation time despite a missing
flag be a reasonable compatibility rule for existing ksmbd xattrs?

Thanks,
Ian
