Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A65339B41
	for <linux-cifs@vger.kernel.org>; Fri,  9 Oct 2026 21:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.255.12.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582457; cv=none; b=imwnjvBpWWI1K1Xqz3EWKKbDXXu6v3JiLZynceLd4LUCl8HEL1TsoMd7jEfR/g1uj1QFx6DdjcEOuLI1j/TYKSrdHrYS0EcPi3w0BBYhxdK+pDEuGkdOaW+TLxN+wW+RQzfuA2Dny4keMVnUFqZfoQY9x5JB+kcFhcWFPX0HkWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582457; c=relaxed/simple;
	bh=8mPnDGa/zLS7KZ97sK2x9yxY0IaDEGN90QUOguHrJAU=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=joQXNAwvvumeWzEkTyk8gGgaj6/zUssuc1UnNYcAdGiTGcE3DxtOc6yjumczqNwk6OXYMDRwfxkRCB2OFXinQQPx3+0pu0S7H+8O0hUFdG8tkzABaWbbDOyKDpfeiFUoCjWAbCwVsBf/W4SLqSV/VUPzGRedYNROzk60sfbnk3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org; spf=pass smtp.mailfrom=manguebit.org; dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b=ivYGxUeQ; arc=none smtp.client-ip=143.255.12.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.b="ivYGxUeQ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Type:MIME-Version:Date:References:
	In-Reply-To:Subject:Cc:To:From:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FVxPMhIqSRcRpSrm2HKV9COm9nSnkjYObGK8q7MnSNA=; b=ivYGxUeQztYwaYf/YuexweJTdg
	Sfy0y1sh2EICJSX3yR5Yq/IqcotSr2MjOOM5FODi/m3qIL3BWUavRv/nCNNgtXv9jN3IyQ+hx1SMr
	heghSwBNjyQa/nEF6maVjoYHx/00lwoL7znmk0c9yZhqAaYS8dvP+tqiOri+69y0srcQK6+6wBHwP
	Px/tqqjU4wli1QrHYnWBbw38/jNAG0migqqKOI29IhhaewZPkZ/5A/zVkfs05FVsKaLyOf7ItH5b9
	Y13qx6HqlbAoBJ6R4uWuDs8sjg86VBme53eJ+MtQq1LNR5EbEzj4pq+0FHCoQSPgcRGc5P0znzH34
	5gyNs2tA==;
Received: from pc by mx1.manguebit.org with local (Exim 4.99.5)
	id 1xFIRA-00000003IEn-1ijU;
	Fri, 09 Oct 2026 18:47:32 -0300
Message-ID: <a1f01a79550cee4083c792847d3daf49@manguebit.org>
From: Paulo Alcantara <pc@manguebit.org>
To: Sung Byeongchan <tjdqudcks0424@naver.com>, Namjae Jeon
 <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2] smb: client: hold TCP session for async decrypt work
In-Reply-To: <20261009135400.722291-1-tjdqudcks0424@naver.com>
References: <20261007062936.25827-1-tjdqudcks0424@naver.com>
 <20261009135400.722291-1-tjdqudcks0424@naver.com>
Date: Fri, 09 Oct 2026 18:47:32 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Sung Byeongchan <tjdqudcks0424@naver.com> writes:

> Large encrypted reads may be queued to the global decrypt workqueue.  The
> work item stores a TCP_Server_Info pointer, but does not hold a server
> reference while queued.
>
> If a multichannel mount removes a secondary channel before the worker runs,
> the final reference can be dropped and the demultiplex thread can free the
> server.  smb2_decrypt_offload() then accesses the freed server object.
>
> Acquire a reference only while srv_count is nonzero under
> cifs_tcp_ses_lock, which serializes the acquisition against the final put
> without resurrecting a server already being torn down.  Do not queue the
> work if acquisition fails.  Let each queued worker own one reference
> until its final server use, and release the transferred small buffer and
> reference if queue_work() unexpectedly rejects the work item.

This solution seems fragile to me and may lead to another use-after-free
bug, as pointed out by sashiko [1].

I really suggest you to fix this with something like

diff --git a/fs/smb/client/connect.c b/fs/smb/client/connect.c
index ff8637301fa9..832ea3281b76 100644
--- a/fs/smb/client/connect.c
+++ b/fs/smb/client/connect.c
@@ -1095,6 +1095,7 @@ clean_demultiplex_info(struct TCP_Server_Info *server)
 
 	cancel_delayed_work_sync(&server->echo);
 	cancel_delayed_work_sync(&server->reconnect);
+	flush_workqueue(decrypt_wq);
 
 	spin_lock(&server->srv_lock);
 	server->tcpStatus = CifsExiting;

I know that @decrypt_wq is a global, shared workqueue, so this will wait
on every CIFS mount's decrypt work.  Not good for performance, but IMO,
that's the safer path to take while we still don't a better option to
i.e. track per-server dw worker items and then flush_work() them
instead.

The above will guarantee that no more work will be queued as cifsd
thread already exited.

If you have any other suggessions, then please me know.

[1] https://sashiko.dev/#/patchset/20261009135400.722291-1-tjdqudcks0424%40naver.com
