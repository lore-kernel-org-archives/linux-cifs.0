Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212483D1CD7
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 09:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786093390; cv=none; b=m8D+Ei0ZEPuMVp9Lo5I16IYalH+T3utx6eoEUSVIFjaKx+cE8OC5gmhsptc0zeBorwB/1xtOfjzDRIey6ueIJoDwWg593gq6/nIdQPkIICKRSmHoXF6mhps0yguYY7jtOF9J17nALDtS4xnuq09TsWEBLPHj4wM5wmneToZhxO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786093390; c=relaxed/simple;
	bh=zvfqjZMtwsjKgqSPaqIbulwXLT4ELKr5o/XUiKnrE28=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ECpKMWnxuLszz/YYoMsRwRc4MLYSpC2AMzZKssJntdILVwAU3vWndqQZrjm6Z5vi0ynLzv9LFFgyTa1pXkOtHu4xum7badcXQN7JGV2JFHp1SLRHO494CcG3BzcdXOXUgyG7JnjE27AalJEZxwaFWZFTSCaP9D3pKIYfs/j91BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com; spf=pass smtp.mailfrom=chenxiaosong.com; dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b=F6k6b64Z; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chenxiaosong.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=chenxiaosong.com header.i=@chenxiaosong.com header.b="F6k6b64Z"
Message-ID: <f875564a-a000-40a3-a43a-888d7c6649ab@chenxiaosong.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=chenxiaosong.com;
	s=key1; t=1786093382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tMeKzo6fuVIHSnOxogw31AvgKt3K57f03PNt6Jt4zM4=;
	b=F6k6b64Zbgp2d1GJ9IjVkK1W45ub52ILrDe57izFTMyWnvSvrNYamBaE2VuTIJsr6BdwZ7
	0JY1yoyKGIpVEPQE9oOTE0S3+mYbRmHlogfpRW+bC5P8uChyP1xD/OuRITwMTiWhd9h2AN
	Z2zzw2LVwGM/5MPqzyAEaGCWJ75g0gfccn/JbzLdUQinvLNKeej0PqYBqO2wUCbO0qH83j
	zjc0QIaqswMifc99gPbc0mC3yAxUKQAZ6sT2Imlr+MLDPYhPzk17BTiJpGxyGlR44YjngI
	InJDEhoGhimV1ictTlCcGb7hBSNVZqoy5R9Z4+qK8WLnG/DCE3k4Qjn4trXKVg==
Date: Fri, 7 Aug 2026 17:01:58 +0800
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [REGRESSION] cifs: openat with O_TMPFILE returns -1 ENOENT
 (STATUS_OBJECT_NAME_NOT_FOUND)
To: Mikhail Stefantsev <mikhail@mstefan99.com>, linux-cifs@vger.kernel.org
Cc: regressions@lists.linux.dev, sfrench@samba.org, jforbes@redhat.com
References: <75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: ChenXiaoSong <chenxiaosong@chenxiaosong.com>
In-Reply-To: <75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Hi Mikhail,

I have submitted a fix patch, please test it and check whether it fixes 
the issue you encountered:
https://lore.kernel.org/linux-cifs/20260807085806.725742-1-chenxiaosong@chenxiaosong.com/

On 8/7/26 14:00, Mikhail Stefantsev wrote:
> Hello,
> 
> I have run into a kernel regression where openat() with O_TMPFILE fails with ENOENT on CIFS/SMB3 mounts, breaking atomic file saving in applications like Krita. According to the open() manual page, the ENOENT error is supposed to be returned when the path (a target directory in this case) does not exist, while a lack of support of O_TMPFILE by the target file system should be indicated by EOPNOTSUPP. Applications receiving ENOENT wrongly assume that the parent directory of an unnamed temporary file is itself missing or inaccessible, aborting the save process.
> 
> Downstream bug report: https://bugzilla.redhat.com/show_bug.cgi?id=2499750
> 
> [REGRESSION DETAILS]
> - Broken in: v7.1.3-200.fc44.x86_64 / upstream v7.2.0-rc2
> - Servers: Synology (Samba 4.15.13), Windows 11 Pro (25H2)
> 
> [STRACE EVIDENCE]
> openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies/6.07.26.kra", O_RDONLY|O_CLOEXEC) = 37
> openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies", O_RDWR|O_CLOEXEC|O_TMPFILE, 0600) = -1 ENOENT (No such file or directory)
> 
> [DETAILED LOGS]
> [  106.251673] CIFS: fs/smb/client/dir.c: VFS: in cifs_tmpfile as Xid: 2886 with uid: 1000
> [  106.252152] CIFS: Status code returned 0xc0000034 STATUS_OBJECT_NAME_NOT_FOUND
> [  106.252154] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code 0xc0000034 to POSIX err -2
> [  106.252157] CIFS: fs/smb/client/dir.c: cifs_create returned 0xfffffffe
> [  106.252159] CIFS: fs/smb/client/dir.c: VFS: leaving cifs_tmpfile (xid = 2886) rc = -2
> 
> [MOUNT OPTIONS]
> //vault/home on /mnt/vault/home type cifs (rw,relatime,vers=3.1.1,cache=strict,upcall_target=app,username=MStefan99,uid=1000,forceuid,gid=1000,forcegid,addr=192.168.1.10,file_mode=0755,dir_mode=0755,iocharset=utf8,soft,nounix,serverino,mapposix,reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,closetimeo=1,_netdev)
> 
> Please let me know if you need any additional information.
> 
> 
> Regards,
> Mikhail
> 

-- 
ChenXiaoSong <chenxiaosong@chenxiaosong.com>
Chinese Homepage: https://chenxiaosong.com
English Homepage: https://chenxiaosong.com/en

