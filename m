Received: from va-2-53.ptr.blmpb.com (va-2-53.ptr.blmpb.com [209.127.231.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA23036E47E
	for <linux-cifs@vger.kernel.org>; Mon, 13 Jul 2026 07:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783926725; cv=none; b=OENSEFqYijC1TmyrjpedfffsTnlj8Phhqw+SjTp607LKYAFczNvl0RQ2UWrlSKoiXcUwAChculwDamFhAnEraa5etQ+252oZluHMEGxKQjvx4xZ5iqGRduK1h9A3RHNbmvANNkPcPWMnyCho9YsQQa59aeJqsKNn/FlqBvNRG4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783926725; c=relaxed/simple;
	bh=zEZyABfGaPnuW48e7R4SOWlwu8C0EAVXqhOio0xjmCY=;
	h=Subject:Date:Content-Type:Mime-Version:Cc:Message-Id:To:From; b=WqT1h6qvjnlUUUmNIZUHboVNDAEbStyqRoM9yXbs9hhFBffdCt4BMU5cZS1Vr+LKXomAMjXBYdzfL3t8P73OH0DBcXBJXuex+e889z9tMzcQRaWRXepBAKCm+/hF7EhlgDU6hfr9Zma4siGmY+37R3wz2Q1obNb0hU3gO1NVigw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=KMo7LiLK; arc=none smtp.client-ip=209.127.231.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="KMo7LiLK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783926713;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QRAANdtfgJ2fZU/J241w6K44fMcXQvEuBw5qdzmSajE=;
 b=KMo7LiLKpPO3qVy8ty2GuAym8TfHoH3fAXJ0IGTrsoIeoj4EQdioKeWDNmKGINMmPediNW
 8CAFEEOWbwME4qbNlM+cx2Ij7GICnZPe0w5S/aCe9YB/7PXapfmdFs7YGRD+cNOfXUBuJ4
 YWfL1AzeqrezqEMTU2J3H0sFO3QzoZj28+/PkEtD6zuXkd+VTqoUMnlzxEVcWtzVapltiZ
 MJ16KCBmaDJi7vlJ+pYL68qTgm6xz4S9VPFL1XBWei4Qoyc6MTGYu5fE/U0DQjGU0I9SSX
 YMABcEQipqeeGvc5EX5ablmivktaGhpMwgLJD3FH55YFZszcnw/4tgLV32kt+Q==
X-Mailer: git-send-email 2.47.3
Content-Transfer-Encoding: 7bit
Subject: [RFC 0/3] ksmbd: use splice for SMB2 READ responses
Date: Mon, 13 Jul 2026 15:11:37 +0800
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from localhost.localdomain ([183.34.174.151]) by smtp.feishu.cn with ESMTPS; Mon, 13 Jul 2026 15:11:50 +0800
Cc: <linkinjeon@kernel.org>, <smfrench@gmail.com>, 
	<senozhatsky@chromium.org>, <tom@talpey.com>, 
	<linux-kernel@vger.kernel.org>, "Wang Zhaolong" <wangzhaolong@fnnas.com>
Message-Id: <20260713071141.3909087-1-wangzhaolong@fnnas.com>
X-Original-From: wang zhaolong <wangzhaolong@fnnas.com>
X-Lms-Return-Path: <lba+26a548fb7+71e642+vger.kernel.org+wangzhaolong@fnnas.com>
To: <linux-cifs@vger.kernel.org>
From: "wang zhaolong" <wangzhaolong@fnnas.com>

From: Wang Zhaolong <wangzhaolong@fnnas.com>

SMB2 READ currently copies file data into an allocated auxiliary buffer
before sending the response. This series adds a page-backed payload,
collects page-cache data with splice_direct_to_actor(), and sends it after
the SMB response header with MSG_SPLICE_PAGES.

This RFC deliberately limits the new path to plain TCP reads of at least
64 KiB. Signed, encrypted, compressed, compound, RDMA, stream, non-regular,
O_DIRECT and DAX reads continue to use the buffered path. Unsupported
splice collection also falls back before the response owns the payload. If
a socket error occurs after part of a PDU has been sent, the connection is
shut down rather than reusing a corrupted byte stream.

I would particularly appreciate feedback on the work-owned bio_vec payload,
the transport hook, and whether splice_direct_to_actor() is an appropriate
interface for this path.

I tested the series in QEMU with ksmbd and the SMB client in the same
guest. The smb2.read.eof tests passed, including zero-length and
MinimumCount cases. Reads of 65535 bytes used the buffered path, while
65536-byte and 1 MiB reads used the splice payload path. Forced signed and
encrypted 1 MiB reads stayed on the buffered path. All data checks matched
and no kernel warning was observed.

For an exploratory performance comparison, I used a warm 4 GiB file over
SMB 3.1.1 with cache=none, 1 MiB synchronous reads and one job. Median
results across eight valid 60-second samples per kernel were:

                            baseline    patched     delta
  bandwidth                 1.728 GB/s  2.246 GB/s  +30.0%
  mean completion latency   604.1 us    464.5 us    -23.1%
  median sample P99 latency 794.6 us    606.2 us    -23.7%

One patched-kernel sample with TCP retransmissions was discarded by the
validity gate and replaced. These are loopback results; an independent
client is still needed to measure network-path and server CPU effects. The
benchmark candidate preceded the final zero-length READ ordering fix, which
did not change the positive-length payload path exercised here.

Compression, large compound READ, RDMA, stream, non-regular, DAX and
O_DIRECT exclusions, and the unsupported-splice fallback, were not
exercised by this lab.

Wang Zhaolong (3):
  ksmbd: add read payload infrastructure
  ksmbd: add splice-based read payload helper
  ksmbd: use splice payloads for simple SMB2 READ

 fs/smb/server/connection.c    |  25 ++++-
 fs/smb/server/connection.h    |   4 +
 fs/smb/server/ksmbd_work.c    |  45 ++++++++
 fs/smb/server/ksmbd_work.h    |  12 +++
 fs/smb/server/smb2pdu.c       |  67 ++++++++++++
 fs/smb/server/transport_tcp.c |  58 ++++++++++
 fs/smb/server/vfs.c           | 195 ++++++++++++++++++++++++++++++----
 fs/smb/server/vfs.h           |   4 +
 8 files changed, 382 insertions(+), 28 deletions(-)

-- 
2.47.3
