Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A5F2F7F0E
	for <linux-cifs@vger.kernel.org>; Sat, 25 Jul 2026 13:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784985158; cv=none; b=f6/jwvgp3LPRu9P9fXv9Yb/YG6txmMtj8d0adQ3QtBFzNjPY60Sueufx3zkErgs30MP8pPtIEjd3Wijm/5uFiMUFNp33HLrRlye2so4aGdA3/vOl9fIeVBLxvGtSU/fJNjnUl3PBnkbnKrmfvbivW0Y13bDMONqFRDIjfFmczl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784985158; c=relaxed/simple;
	bh=PqJkjy9OIurrNC6F/g8qyFUoIprDkhnbyxhvzckpZuE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6GY1uOckvCqTAnCbIsMIS1yqtw6xkZrNa/x7sqJJcg9NdYjb6yGXUyMjGqE/ZUe+IJvB2WmqV8mUc4vjLI/bb8+i6B0Lo1WitCSNZyi9aqEalpMIf0H1pkM6JuFZSXdUXDbLIwyCHkFGTsXnWYQzyMIhxVXpgDMfOD13hZe/LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=r591D5vy; arc=none smtp.client-ip=95.215.58.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="r591D5vy"
Message-ID: <6813f121-5fe0-4542-85fa-7f06e093c24a@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1784985150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWNR5tyIqCf7zsAHaLdxX7WNOfsY0KvvC6852qrLhsg=;
	b=r591D5vyLoKbKxaANMQr9CT79/6cOashKUp3cXfGIMzSt2THKwxf/rr9yfm43bkpdu9ALM
	+qqpwKs5NXn0ZVw3z7tlaHKdM8AojAmA8bkNO0eC8Au6lmYWzDJ2iWJWOZT0z1HHmWFP9l
	qc0RJPcpfItq7t/Oo/VeRQVEprrfheIYgAeyPNlB4TeQDObNUzGxxAO40vqmB3xpQ72SXj
	6Z/J7a3OHQxNxgljY/UtCa154mD+rjICmT+jdlzX0c7dgNFpvNIXLMb5WEr3Vlv/AJjYCz
	KKfbswenQAi4dX7iRpfuocgS6egkqjOY0whQ6QXO46ztqz/oKpyP38PQX15jTA==
Date: Sat, 25 Jul 2026 21:12:19 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] ksmbd: refactor smb2_notify() to a blocking wait,
 matching smb2_lock()
To: =?UTF-8?Q?Ga=C3=ABl_Blivet-Bailly?= <gael.blivet@gmail.com>,
 linkinjeon@kernel.org
Cc: linux-cifs@vger.kernel.org, chenxiaosong@kylinos.cn,
 Steve French <smfrench@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey <tom@talpey.com>
References: <20260725102737.33616-1-g.blivet@me.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260725102737.33616-1-g.blivet@me.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

When Windows is used as the client, this check must be removed because 
Windows sends a compound request:
   CREATE dir; CHANGE_NOTIFY, fid = compound fid (FFFF...FFFF)

However, I am not yet sure whether skipping this check could cause any 
issues when macOS is used as the client. I will test it with a macOS 
client tomorrow.

在 2026/7/25 18:26, Gaël Blivet-Bailly 写道:
> @@ -10967,56 +10908,17 @@ int smb2_notify(struct ksmbd_work *work)
>   	}
...> +	 * macOS backupd sends CHANGE_NOTIFY with FileId=FFFF...FFFF
> +	 * (share-root sentinel) to watch for changes on the share root
> +	 * without holding an open handle.
>   	 */
>   	if (req->VolatileFileId == SMB2_NO_FID &&
>   	    req->PersistentFileId == SMB2_NO_FID) {
...> +		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
> +		smb2_set_err_rsp(work);
>   		return 0;
>   	}

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

