Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="JC99lz1L"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F87CAB
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 11:32:18 -0800 (PST)
Message-ID: <65d6d76197069e56b472bbfead425913@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701804736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Sy2exrWwdWVk8Ud1LmuEfA2+4tiGS4R+0EFqPn5NA38=;
	b=JC99lz1LXy9+tdDxydJkvT/WNm46ipwZUXDD+xEFJ17k37dp6nOfkPm1Z+89L2zyCTp34H
	YVEYnDL3eBE9KZS+yDRGyNuJbYhTaHLKkJdy4aqPeJUC1Td8VB5I0BFqxKfFH0JmM2jJUX
	4XbTYxZOESyQSuuoyuJ6tm4JRmaupqioxIOQiLqQQHPkzsnxypIe8p3+myOSdNZ4Z9IVLE
	WHV4KR28Lcu4HWTCB2TtX8/YDbXtOF3u0Hvif/gJquSum1Lo6S/EHTFSYZz/n5WPQ+jU8u
	/+9aCSMqy7FMrmEN5S4VvrL4yPy1mX5T1qLj8NicikGfWRPUYk2t4kco5w+yJg==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1701804736; a=rsa-sha256;
	cv=none;
	b=YB2qTvz6XEvF1+6InuRQBKCzbO3HFRIPMhyrtOtuPudV90Hu89EwgK31qlkP2pvOOuoFxz
	PtzDJerDd2gHxC1/XEm8bmbGbiyVXSdgP+Xl6lC7gQJWCg9AQinkAVI1aI6/mSIWvZTjDq
	eiOP4bPiVaa7MT1sIISo7S0eX6h1sle+pho3P5rukZllIahuhJGjcyVW6VH8+Udqd8iQyf
	QFGTll4kqaltQ2qfSwd8KHCWaEnPUZ8YSUyFsqEcDFWr6YeykPsGyt34LHdHPAYO2Thm4s
	jtAYrVgFwQw+AWMb33d7mYQcf8yGBaoxgIBStGV6qxcbROpqL0rKewaftT7XfQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1701804736; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sy2exrWwdWVk8Ud1LmuEfA2+4tiGS4R+0EFqPn5NA38=;
	b=j53u5Lglp8uYH/BOctoFuoOeAUc0feRMhof7JzNXkfwOSKLmX0Ixi0NY4+QzST+wl5S6Cy
	FkfHIfRmo2RBvNFJELDJGMPDlbRM4U00UR370QNjxqhhCat+6UC4vUTRM+AkhcFMOHyFoj
	RS03snAljjSNKNoiAdEn5JghlYG6q4Ayo+Xw0++kOW9qe/9MB3DdZdLycvyo8v7ZAUoYy/
	h+ztFA+5cK54G8MSh1dhCv4XHxClqYtpjjDbsDi0JX6PxfOx6RHTmZX1Wyt5DaTUlnaiPh
	qkUkg0gtgvYxCeXCCGBWvtnuQfpQCiimsaMT2F3o3w1U49b9qQPAI5Y6lBcDLQ==
From: Paulo Alcantara <pc@manguebit.com>
To: meetakshisetiyaoss@gmail.com, linux-cifs@vger.kernel.org,
 smfrench@gmail.com, nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 lsahlber@redhat.com, tom@talpey.com
Cc: Meetakshi Setiya <msetiya@microsoft.com>
Subject: Re: [PATCH] cifs: Reuse file lease key in compound operations
In-Reply-To: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
References: <20231204045632.72226-1-meetakshisetiyaoss@gmail.com>
Date: Tue, 05 Dec 2023 16:32:13 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

meetakshisetiyaoss@gmail.com writes:

> From: Meetakshi Setiya <msetiya@microsoft.com>
>
> Lock contention during unlink operation causes cifs lease break ack
> worker thread to block and delay sending lease break acks to server.
> This case occurs when multiple threads perform unlink, write and lease
> break acks on the same file. Thhis patch fixes the problem by reusing
> the existing lease keys for rename, unlink and set path size compound
> operations so that the client does not break its own lease.
>
> Signed-off-by: Meetakshi Setiya <msetiya@microsoft.com>
> ---
>  fs/smb/client/cifsglob.h  |  6 ++---
>  fs/smb/client/cifsproto.h |  8 +++----
>  fs/smb/client/cifssmb.c   |  6 ++---
>  fs/smb/client/inode.c     | 12 +++++-----
>  fs/smb/client/smb2inode.c | 49 +++++++++++++++++++++++++--------------
>  fs/smb/client/smb2proto.h |  8 +++----
>  6 files changed, 51 insertions(+), 38 deletions(-)

NAK.  This patch broke some xfstests.

Consider this reproducer:

$ cat repro.sh
#!/bin/sh

umount /mnt/1 &>/dev/null
mount.cifs //srv/share /mnt/1 -o ...,vers=3.1.1
rm /mnt/1/* &>/dev/null
pushd /mnt/1 >/dev/null
touch foo
ln -v foo bar
rm -v bar
popd >/dev/null
umount /mnt/1 &>/dev/null
$ ./repro.sh
'bar' => 'foo'
rm: cannot remove 'bar': Invalid argument

This is what going on

- client creates 'foo' with RHW lease granted.
- client creates hardlink file 'bar'.

At this point, we have two positive dentries (foo & bar) which share
same inode.

- The client then attempts to remove 'bar' by re-using lease key from
'foo' through compound request CREATE(DELETE)+CLOSE, which fails with
STATUS_INVALID_PARAMETER.
