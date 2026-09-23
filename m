Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B23334688
	for <linux-cifs@vger.kernel.org>; Wed, 23 Sep 2026 01:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790125758; cv=none; b=Hr0/5dU5Bg2W/x0cyXjW0WalGaWZemLdUlC9P/bONUyFmW0s75xySwaAv30s9HumXILRL51Q0a0s29P4Yiq827fqiaNnyEcSvZ6k/0p82/thNMY5CRvR0HRNs19fPsF5g5U7nkFvltjsjGLInBLHjKOOWl3VUETIcNCOFcoXCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790125758; c=relaxed/simple;
	bh=DTAJlfxCsSem3nEzsCc/232BrhjvWFWM7o4pGMVGfiU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=YMaDcyrFbYrdTLuw1PoRE6Fg8K7JIIGFvEnWHGaMjGpie+el9tohZZ7BXBwfOHrBzYF9NZdxD77FY1RpwDlMiMC4RHSKq3vFEyok+V8KwLDcOQsvYB+ABWeYxN4e0isCtdZBBbcuGNqjGzKmk2isLvX46lJ96mtXP/RZpkOnTzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=aXDPDKUt; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="aXDPDKUt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=DTAJlfxCsSem3nEzsCc/232BrhjvWFWM7o4pGMVGfiU=; b=aXDPDKUt7rApyaDF76W95cfqSv
	PXMwNsXEgSW8t5Ea27MTr6fzuQGNos8+CsiBunwTY7xJmVYGNyiDVSy3MTkezj0CZpgIeoQnFOcZF
	puTYMMrx7mzdZT18m+3GN78jPpjgJ0qgYx4fGv6lxMDZ6fcUnUsIjjo9QVLEIx5fGe+kHUTWqryK2
	iK/XHJKz9meaeWsguZqHnpxpUpsJEkKM6k8ESWuKT13P2gIoPu6Jl1zfITwDnFWW2O8thaGyejm4J
	eGzk+t6sWuO0Q6klcnhhw+LLrwYm+4bXB9naZq6axBlxNtvpmisjK/AxljjFH4uHvwYGGYTbFF1N1
	gy2DUVbw==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1x9BTu-000000023gx-2XSm;
	Tue, 22 Sep 2026 22:09:06 -0300
Message-ID: <a75ae01d9203c1903569b2fc9706715c@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Zihan Xi <zihanx@nebusec.ai>
Cc: linkinjeon@kernel.org, zihanx@nebusec.ai, linux-cifs@vger.kernel.org,
 samba-technical@lists.samba.org
Subject: Re: [PATCH v4 0/6] smb: client: fix create context out-of-bounds reads
In-Reply-To: <cover.1789478666.git.zihanx@nebusec.ai>
References: <cover.1789478666.git.zihanx@nebusec.ai>
Date: Tue, 22 Sep 2026 22:09:06 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zihan Xi <zihanx@nebusec.ai> writes:

> Hi Linux kernel maintainers,
>
> We found and validated an issue in fs/smb/client/smb2pdu.c. A malicious
> SMB server can send a malformed SMB2 CREATE response to a CIFS client and
> trigger an out-of-bounds read. We validated this with an Impacket server on
> the QEMU host and a root CIFS client in the guest; CIFS does not set
> FS_USERNS_MOUNT, so the mount must run as root. For valid SMB responses,
> the series preserves existing request handling. No impact was observed in
> the tested CIFS mount/read path; a full filesystem regression suite was not
> run.
>
> We will provide detailed information about the bug
> in this email, along with a PoC to trigger it.
>
> ---- details below ----
>
> Bug details:
>
> smb2_parse_contexts() validates the complete create-context area but does
> not limit each context record to its Next field before dispatching it. A
> malformed chain can therefore allow a handler to read bytes beyond the
> current context. The QFid handler also cast the context to a full response
> structure without verifying that DataLength covered DiskFileId, so a
> truncated QFid context could read past the response allocation. A
> non-terminal Next that does not leave a complete following context header
> is rejected as malformed.
>
> The parser rejects NameOffset and DataOffset values before the context
> header, bounds the name range by the current record with checked arithmetic,
> and dispatches known handlers only when DataLength is non-zero.
>
> The SMB2/SMB3 lease parsers also read LeaseState and LeaseFlags at
> canonical offsets rather than from DataOffset. Patch 1 limits each record
> to Next, reads QFid data only when its payload covers DiskFileId, and
> parses lease data from DataOffset with the exact v1/v2 lease payload sizes.
> A size mismatch skips lease parsing without failing the open. These sizes
> match the fixed payload sizes used by the CIFS request builders and
> ksmbd; a future extension must update the parser explicitly.
>
> parse_posix_ctxt() reads nlink, reparse_tag, and mode before checking that
> the POSIX data contains them. The in-tree smb2_open_file() path passes a
> NULL posix pointer, so ordinary opens do not reach this handler. Patch 2
> still checks the handler's minimum data length and preserves soft failure
> for malformed optional metadata.
>
> Tracing the parser callers and compound error paths through cleanup and
> return-value handling also exposed the additional independent issues fixed
> by patches 3 through 6.
>
> After a successful CREATE, SMB2_open() increments num_remote_opens before
> parsing its contexts. Patch 3 calls SMB2_close() after a parsing failure.
> SMB2_close() decrements num_remote_opens only after a confirmed successful
> close response. If a close is interrupted or transport fails, the existing
> best-effort behavior retains conservative accounting when the remote result
> is unknown.
>
> open_cached_dir() sends CREATE and QUERY_INFO as a compound request. Patch
> 4 validates the CREATE response before using its fields, records the CREATE
> FIDs, marks the handle open, and increments the remote-open count before
> processing later-command errors. It also handles -EREMCHG before response
> validation, so a missing response does not hide the reconnect request.
> Patch 5 marks earlier completed mids as cancelled when a later compound
> wait is interrupted or MID synchronization or state validation fails. It
> keeps their response buffers attached until synchronization is complete, so
> the existing cancelled-mid cleanup can inspect each successful CREATE and
> queue SMB2_close(). The remote-open count is incremented only after close
> work allocation succeeds and before queueing it, so an OOM does not leave
> an unmatched count. It marks smb2_unlink()'s create+close compound so it
> is not closed again. Non-CREATE responses and compounds with a close keep
> their existing behavior.
>
> Patch 6 preserves a create-context parsing error in the
> SMB2_OP_OPEN_QUERY compound path while later responses are processed.
>
> The series keeps separate Fixes tags for the independent root causes, with
> each tag pointing to the earliest commit that introduced its root cause.
>
> The parser changes overlap with Frank Sorenson's related bounds-checking
> patch for smb2_parse_contexts():
> https://lore.kernel.org/all/20260826153147.4112943-12-sorenson@redhat.com/
> This series incorporates the NameOffset, Next, and zero-data dispatch checks
> while retaining the stricter per-record successor-header validation and the
> handler-specific payload checks.
>
> The reproducer uses an Impacket SMB server that modifies the SMB2 CREATE
> response. packetdrill is not used because it cannot implement the required
> stateful SMB server or rewrite this response.
> ...

Applied.
