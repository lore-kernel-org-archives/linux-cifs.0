Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C04AC3DC850
	for <linux-cifs@vger.kernel.org>; Thu,  9 Jul 2026 07:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783580665; cv=none; b=thbWS11om0do9iekTPyL9Qj60Wl8JJ+DOVzXI/iN4FxQpwO97dG4f7uK5frq1/URn9p4zcgCOo+7VemWHmI2RYUqHjxSdWgkKqwU3NLiHRWrms2ScoW4jK1WgzrCynu1O2W6J/Sahcs2kT4gBXtYEeRunZNR1vktB+tNQnsjWBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783580665; c=relaxed/simple;
	bh=0qaGup6mrcRK8QafA2Ie4DTDq+qi2iiyp8otUT5uIRk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q71ferJkG3jmjMJl5tVd6rVzYpfua6YIDSbX/kZ3VEgM4QTCz6VOoZxXW9MXzID96svxij9EQ1Q8FFF5aWr/rCF7bXyTN0gOLttwDjjde/++7OLql0hyziPRSPygXgCINSnjwOVd97JJHnqKxJOypPBvf6VUNhF75lpwMJ4abK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=hY9dlgvT; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="hY9dlgvT"
Message-ID: <276aedb5-dc9c-42f6-8e49-4dde6e253761@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1783580659;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m7BFnfQKj7FoY4xCNO7X//r/R80GQPbVo/u4kdcamCE=;
	b=hY9dlgvT3h9D8eG7ZuqchUjd2EizBKIqmN8Nus9oh+Ro822Ns0fjCbabQepwVxhoULn2yQ
	q2b/DgYtvJhcbuBxSmTRw69AeEX+JVK+HKLkqpYh5LOk9VPlTGLTAxf/GhTXvhCNDd4XbC
	UkHMuCYAayNAtjUyyVgd8vb+6Lid54p1cre0f/QM0aV5DnlIdRAOu9FtCufe96kvZvGmL6
	JFZeccQJR0757Vlh29k/Gefrfk4l2nk5Ny4Tq9BLjtrNEidJQZMH+y1wHi/ZVvhJLkdiFC
	X1PsnbEly1kBifxFM4URYhggUsyp5ktrY4Yr2LSGQZ65LEbLpVaKFrOAF38+Nw==
Date: Thu, 9 Jul 2026 15:03:27 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/6] ksmbd: defer CHANGE_NOTIFY completion instead of
 STATUS_NOT_IMPLEMENTED
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 Namjae Jeon <linkinjeon@kernel.org>
Cc: linux-cifs@vger.kernel.org
References: <20260709000618.66534-1-g.blivet@me.com>
 <20260709000618.66534-5-g.blivet@me.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260709000618.66534-5-g.blivet@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

It looks like this patch from Gaël has already implemented notify 
pending and cancel support. I will rebase on this patch.

I will send the remaining ksmbd notify patches soon.

On 7/9/26 08:06, Gaël Blivet-Bailly wrote:
> From: Gael Blivet<gael.blivet@gmail.com>
> 
> smb2_notify() currently returns STATUS_NOT_IMPLEMENTED synchronously
> for every CHANGE_NOTIFY request. Genuine SMB2 servers never complete a
> CHANGE_NOTIFY spontaneously -- it's satisfied only by a real directory
> change or with STATUS_NOTIFY_CLEANUP when the watched handle is
> closed. macOS smbfs.kext depends on this deferred-completion contract:
> receiving STATUS_NOT_IMPLEMENTED instead makes it hard-freeze on
> unmount, since it never sees the cleanup it's waiting for.
> 
> Add a notify_pendings list on struct ksmbd_file (protected by the
> existing f_lock) and a notify_entry list_head on struct ksmbd_work to
> link onto it. smb2_notify() now replies STATUS_PENDING immediately and
> queues a deferred STATUS_NOTIFY_CLEANUP response on the watched
> handle; __ksmbd_close_fd() drains and sends any pending notifications
> when the handle is actually closed. The drain splices the list out
> under fp->f_lock first, then processes the detached copy without the
> lock -- smb2_notify() on another connection can be adding to the same
> list at the same time a close happens on this one, and
> ksmbd_conn_write() can sleep (it takes the connection's write mutex),
> so it must not be called while the spinlock is held.
> 
> Also handle the FileId=FFFF...FFFF share-root sentinel that macOS
> backupd sends to watch for changes without holding an open handle --
> without an immediate STATUS_PENDING/STATUS_NOTIFY_CLEANUP reply here,
> backupd aborts Time Machine setup with STATUS_FILE_CLOSED.
> 
> Signed-off-by: Gael Blivet<gael.blivet@gmail.com>

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

