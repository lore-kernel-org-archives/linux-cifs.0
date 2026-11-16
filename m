Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794801986;
	b=WD6g9YtHPeENZkHXzIFAp+8ic3OgTu/dD3OvxNXFlHs1elsvFusTKRIU8LSe1jClSt7K
	 9u9R7BGi0q0h3RFyxZcZrBvmB7VixN62RLphqT88zmc5jl2A6MEP5Jd8AOMZxW4Y5WHMN
	 1v4qUYXiFwl99OMkL9uUWMngAxfCp7KGueRzlZ8PZukSn4hGaC8LxnkGF3JzfNWF+NJCi
	 3SDiWZojO/O0havL5tOF4gQeNJ0QVFMRMEi6B8FRzQTOyJDtcZjc0fzyJV7a1NtmUZJgH
	 PEmNUZxvWkv2fKT0k1eddpDvh/gnnu1ivHePluDm/rm2s6Gsd6o/kyKodIc6vJWmYFg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794801986;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:
	 X-Endpoint-Received:X-Original-From:Reply-To;
	bh=kkXF95v78V6NT2W0cL+mMJFbayxBiiMJay7E30PymP8=;
	b=uG7COnmCuKPT3hIMXJC16otTwg089qqOnmwIKanZQAIkukm2q1Vpf9qEQFBprQV1edu+
	 expDqnCYgGlyaZbZyO/exNIj70uxUgT+hPuGGGddbL/YtVDx0ba1Zztt9X+bzn3vs8sRR
	 iCI6mury8gXxjBPeNOnAMcOUVXS9nMMQfTuA8/rRSW+FZLgdoKRJ5QWOJN2UdwvIXk7us
	 hAmlrXLJf43UjRacYFr2b0/0t6sUnKZzpekQsG1RS01n0CY3FoCtdX/NXktE0a4VP9JOY
	 FlWOtIZetHgyOFjx5C3ooSBElV3pkf5GWVSiG33ugsvgG3NSY0Pejxx/v7hSrObd4/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idcO17AW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1B6606A334;
	Mon, 16 Nov 2026 04:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=idcO17AW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794801985;
	b=L+TMboFjgNztjye11Sw+5ljl4b3yKE2lolRCMTp/nGBTaXv2gt2lDEf+zlpPEGZU/Nnt
	 L/Uw0KKbqCjXsaibnmG74ZT89HiyTRMbWyQg3rtVCZgEuVSJrzmgyBMdzKDlOsDcKnMxU
	 DkD9DetlKATXnc6+lTIYkYvNnsKeOsoff8unYd5Mjl90PY9GeGQ7FQrAhAh8wPdhBPDIR
	 tIkh7U2JJHRL45z/wfrUqoLHLFzHVkCm4GI4izlTgkAXERH3AsuxPDtTdeZGihk1bfhBb
	 jBEzOswG2FSw4CyZzsFKGLx9HICyRz80eMDj6wN/UMp2S77eyys/5RRMTvf3+l1QGeA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794801985;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:X-Change-ID:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=kkXF95v78V6NT2W0cL+mMJFbayxBiiMJay7E30PymP8=;
	b=BTeLRzVip+rjKQJSKnS1gOLY4/fFBksxeMWp9gV1opci/A/AY3Addb5OG4BYtj56c5Nw
	 GZqA77liJ+GF9dEdw+bThgQPKHlH+dRmsOi2YunY5RTQjCPssqzvXl0sAi+zTIBT2+6Fs
	 y7JUdXiVNuzl0VTeVRbVB94VDajGnkuyDo6MfTm7DZjD77vMmNnKKI8UmkADxmI2cb+Kh
	 rw098d9OCLcCczPXHn4tgAHMaVmuSnPXfr4T4+YAavC4lC74bquPGgos+1wNNs9isWG/y
	 pItDou3rNcQvLr2e3tvgRKgivDGhXz6bgXSv08RkRajr00VmUxFBZYEW2Kr2Mi+KHjA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A40991F000C4;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794801985;
	bh=kkXF95v78V6NT2W0cL+mMJFbayxBiiMJay7E30PymP8=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=idcO17AWMTurw4i3lkMNo4uygyBQhtRVNt9Ffzs444o226KdefSi4bUTqzFwO54d1
	 YQGD2/dWcLGXCUklQ3c9r77TiguAhVRb/6taFdMMejOaiJwbZpmqJSkVXAdinhZuVj
	 kU5WKjwI5KPnRasCNw23/OgReNWg+PPlkhRgIvkMCbxJaRgAZXhZWPw3HG95Ts0Htf
	 g8dF7tU0ckC1UfuPpnuue285zjJ+GgdDZdtd8t28NBSeE/FemgonGuu2w5lJHIXgzH
	 JG1FviTeKz6gMW3rKbWOK+fN8T4fDpyGoUSHSjhmdQ9pPMGlFQw26ZYhODk0ZnKxl/
	 kLfiqpx+QS6mQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 045934A30B;
	Mon, 16 Nov 2026 04:06:24 +0000 (UTC)
From: Suyuan Wang via B4 Relay <devnull+shyckless.gmail.com@kernel.org>
Subject: [PATCH v2 0/2] smb: client: don't use SMB2 responses that fail
 signature verification
Date: Mon, 16 Nov 2026 04:06:22 +0000
Message-Id: <20261116-smb2-sign-v2-0-a823a90d0db4@gmail.com>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD6B+moC/yXM0QpAQBBA0V/RPNuyI0t+RR4Wg1GWdpCSf7d4P
 HW7Fwh5JoEyusDTwcKLC8A4gna0biDFXTBggkZrbZTMDSrhwSlrcp32mS0wKSD0q6eez+9V1b9
 lbyZqt3cA9/0AsUjSwm0AAAA=
X-Change-ID: 20261116-smb2-sign-a6713f5a8208
To: linkinjeon@kernel.org, pc@manguebit.org
Cc: ematsumiya@suse.de, sprasad@microsoft.com, linux-cifs@vger.kernel.org, 
 bharathsm@microsoft.com, ronniesahlberg@gmail.com, 
 samba-technical@lists.samba.org, daniel.birtwhistle@gehealthcare.com, 
 linux-kernel@vger.kernel.org, smfrench@gmail.com, dhowells@redhat.com, 
 tom@talpey.com
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794801982; l=1914;
 i=shyckless@gmail.com; s=default; h=from:subject:message-id;
 bh=jv43A/FOzigTsfPh9FQ0sEdXgmP8WzQQw9ldjxq27kc=;
 b=4EDtA5z7ciZwNK6tzRVSqKlnejoLxWKJVtSj8MvLLr+1y/mYQh/Bdge9RLn/lI6/tqc1ZeiCD
 VeDC8ldJYcwAneMLrwPgvJFFirU9LAkKeqFTVTUzaiu2hb6q5jiG1Pe
X-Developer-Key: i=shyckless@gmail.com; a=ed25519;
 pk=pMtccVGiWES3bV+7YBFuBclkvq2n2HBHQ5azaBrK2lY=
X-Endpoint-Received: by B4 Relay for shyckless@gmail.com/default with
 auth_id=1498
X-Original-From: Suyuan Wang <shyckless@gmail.com>
Reply-To: shyckless@gmail.com

v1 made smb2_check_receive() return the error when a response signature
doesn't verify. Sashiko pointed out that this isn't enough:
compound_send_recv() still passes the response buffer to the caller, and
smb2_compound_op() parses it anyway. It also found that
smb2_readv_callback() can drop the error when the read reaches EOF.

Patch 1 is v1 plus not passing the response on in compound_send_recv().
Patch 2 fixes the read path.

I tested this in QEMU (x86_64, next-20261109, PROVE_LOCKING on) against
Samba 4.15 with "server signing = mandatory", through a proxy that
changes responses without fixing the signature:

- EndOfFile in the QUERY_INFO response of the open/query/close compound
  (stat): with v1 the forged size is copied into the open info, and stat
  only shows the right size because the caller takes -EACCES for
  STATUS_ACCESS_DENIED and opens the file again. With v2 stat fails with
  EACCES.
- READ data, cache=none: without patch 2, cat prints the modified data.
  With it, the read fails with EACCES.
- A file name in QUERY_DIRECTORY (the v1 test): still EACCES, and the
  handle from the CREATE in that compound is closed ("Close unmatched
  open").
- Without the proxy, stat, read, write, ls and rm work as before.

Enzo's point about SMB 3.1.1 tree connect responses is not covered here,
that can be a follow-up.

Changes in v2:
- Patch 1: also don't hand the response to the caller in
  compound_send_recv() (Sashiko)
- Patch 2: new
- v1: https://lore.kernel.org/all/20261113-smb2-sign-v1-1-937ee7c20f08@gmail.com/

---
Suyuan Wang (2):
      smb: client: fail SMB2 responses with a bad signature
      smb: client: don't use read data that failed signature verification

 fs/smb/client/smb2pdu.c       | 2 ++
 fs/smb/client/smb2transport.c | 6 +++++-
 fs/smb/client/transport.c     | 6 ++++++
 3 files changed, 13 insertions(+), 1 deletion(-)


