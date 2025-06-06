Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3C0D283FE6
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 07:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749193841; cv=none; b=BkjA8S6THJ9KMp7zlE3+w8Dx2Yqh2scuKF7065diN/7xPcyUID+RSpLzKUbdLJB5UbMNM18vrglXnWZeQsOAqjX3KqihlsNo+zaWsxoRASwug9pzWRYNWKWYaoTXAadorozxcCh9tnt1nMsSnijE29zjE/2qn6omhbDMBR8dbRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749193841; c=relaxed/simple;
	bh=UiDqCiYupZchjvUWUfD2xitU5eq4IlyPeM7J5hk1gQc=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=Kl4c4uJ7Do9NsHlLlfRDqvT58CWKK5lvv/i0EyWZuJkPjtFNxH5d75dnvnrZ6PDgfLslPzSyZSXgDIHwkH9IwxzoacpZf/knwCywp9eB1SnWWAJar0t655JnpTSGyKLnAJnDcsl4TxRyh526qWbeewi+q0F2JZQWJqdLTMLKC90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4bDBjv6B4SzRk3f
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 14:48:51 +0800 (CST)
Received: from kwepemg500010.china.huawei.com (unknown [7.202.181.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BEAD41402FC
	for <linux-cifs@vger.kernel.org>; Fri,  6 Jun 2025 14:53:02 +0800 (CST)
Received: from [10.174.178.209] (10.174.178.209) by
 kwepemg500010.china.huawei.com (7.202.181.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 6 Jun 2025 14:53:02 +0800
Message-ID: <35a57e9c-e5d5-4e78-93d7-83fc147080fb@huawei.com>
Date: Fri, 6 Jun 2025 14:53:01 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] smb: client: find_cifs_entry() suppresses some
 errors
To: Maxim Suhanov <dfirblog@gmail.com>, <linux-cifs@vger.kernel.org>
References: <CAKeu6dXUhLP2cjagz_+YB2Esf-rnj3RQHWaX96R2bEBOk0C6dg@mail.gmail.com>
From: Wang Zhaolong <wangzhaolong1@huawei.com>
In-Reply-To: <CAKeu6dXUhLP2cjagz_+YB2Esf-rnj3RQHWaX96R2bEBOk0C6dg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemg500010.china.huawei.com (7.202.181.71)

Hi Maxim,

The behavior you observed—returning -ENOENT instead of the original error
code—is likely intentional. In the Linux kernel, the readdir system call
(documented in man 2 readdir) expects specific error codes to signal certain
conditions to userspace programs. For example:

ERRORS
        EBADF  Invalid file descriptor fd.

        EFAULT Argument points outside the calling process's address space.

        EINVAL Result buffer is too small.

        ENOENT No such directory.

        ENOTDIR
               File descriptor does not refer to a directory.

CONFORMING TO
        This system call is Linux-specific.

If the original error (e.g., -512/ERESTARTSYS) were propagated directly,
it might result in unexpected behavior in userspace applications, as
these programs typically do not handle raw SMB-level errors.

Let me know your thoughts on this. I'm happy to explore further if needed.

Best regards,
Wang Zhaolong

> Hello.
> 
>  From fs/smb/client/readdir.c, in find_cifs_entry():
> 
> 
> cifs_dbg(FYI, "calling findnext2\n");
> rc = server->ops->query_dir_next(xid, tcon, &cfile->fid,
>                                                        search_flags,
>                                                        &cfile->srch_inf);
> if (rc)
>    return -ENOENT;
> 
> 
> If 'rc' is non-zero (e.g., EIO), the error is turned into ENOENT. This
> means that:
> - If the SMB server encounters an error while querying a directory,
> the corresponding error code (i.e., STATUS_FILE_CORRUPT_ERROR) is
> delivered to the client.
> - But the client "translates" that error into ENOENT, which
> effectively suppresses it.
> - A userspace reader is left unaware of this error condition on the
> server while listing the directory.
> 
> I suppose that we can change 'return -ENOENT;' to 'return rc;', but
> I'm not sure.
> 

