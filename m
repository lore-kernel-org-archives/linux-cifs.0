Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C566F3161AD
	for <linux-cifs@vger.kernel.org>; Tue, 17 Mar 2026 09:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773738157; cv=none; b=KQ+oJiIJDXrRDYuN9Pf/Mw65kZDBETtpMQGRGgaykZ2zKX8OZey5SZToNyH/JN+zrypLt62sovaxPAU4JVwlOj8FgB2jA7TN2MvEj2+xLkdTKy/AMH5pp1DLpDRADridz5IMxBOvOLN5ardMjoIJ/411Loffve76+7YGUKZtrh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773738157; c=relaxed/simple;
	bh=yqTJ23dKSy6Nh/uIVMWFKumxKskfHqIYpyxcji9osxs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fCthGC5pg/NkolvW4NqUokeEIAQj7dEgMsUcHno6mcax+s2U1nQ/VHjNNccmu5++9/LNbUsLmuyn/JPqzJQwRmwBknIyw8h5oKm7co27vOPCknc5HOO/JfyNRCuJ8wxa2wyfDOh11I05ftk8ZjAcnqcVfeWWqAoqyQ1Nkkfj7FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=MZsZKApG; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="MZsZKApG"
Message-ID: <308acd9f-58d9-4519-aaa6-be96f140177d@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1773738142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZqUY9RnKKpOusO8pFUS3/6tqJB0ZpbCTtFL2PSpto4E=;
	b=MZsZKApG/PvzuJAetbjZnAC3redAkZl/JYEl/TdCxjpmQrnTBZPp0pgHP0Ztz4RGblAWmT
	uV1dWL1mfrt4wZ/vA+XdOHQZ4kldYGwkIvQGpha77Ao29EsesFI97LvG2W/K/dxmS+3E2r
	U2Nh2wik3oDg+leXdzi5iY9oMgZ0iQN/rzrDrvoVlBb9G1UYDSDURzlkzhiOp8hV+kMGlN
	WHAOlzsV6WeI/0jZ6crOVvFZj1FgAawrP74YeuqtKOt4NDcKsZXH4O/+69XJj06D5Ki2L/
	p/JOoXagOAAeB9VwrLQnZlqcBQAwhn3iR2BJn1mI9Ev5mHM0ePuf5quWLv7wvg==
Date: Tue, 17 Mar 2026 17:01:31 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] ksmbd: fix memory leaks and NULL deref in smb2_lock()
To: Werner Kasselman <werner@verivus.ai>, Namjae Jeon
 <linkinjeon@kernel.org>, Steve French <smfrench@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, Tom Talpey
 <tom@talpey.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20260317080835.1947664-1-werner@verivus.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <20260317080835.1947664-1-werner@verivus.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Werner,

It might be better to move `locks_free_lock()` and `kfree()` to before 
`if (!rc)` statement.

```
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7579,14 +7579,15 @@ int smb2_lock(struct ksmbd_work *work)
                 rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
  skip:
                 if (smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) {
+                       locks_free_lock(flock);
+                       kfree(smb_lock);
                         if (!rc) {
                                 ksmbd_debug(SMB, "File unlocked\n");
                         } else if (rc == -ENOENT) {
                                 rsp->hdr.Status = STATUS_NOT_LOCKED;
+                               err = rc;
                                 goto out;
                         }
-                       locks_free_lock(flock);
-                       kfree(smb_lock);
                 } else {
                         if (rc == FILE_LOCK_DEFERRED) {
                                 void **argv;
```

Thanks,
ChenXiaoSong <chenxiaosong@kylinos.cn>

On 3/17/26 16:08, Werner Kasselman wrote:
> --- a/fs/smb/server/smb2pdu.c
> +++ b/fs/smb/server/smb2pdu.c
> @@ -7583,6 +7583,9 @@ int smb2_lock(struct ksmbd_work *work)
>   				ksmbd_debug(SMB, "File unlocked\n");
>   			} else if (rc == -ENOENT) {
>   				rsp->hdr.Status = STATUS_NOT_LOCKED;
> +				locks_free_lock(flock);
> +				kfree(smb_lock);
> +				err = -ENOENT;
>   				goto out;
>   			}
>   			locks_free_lock(flock);

