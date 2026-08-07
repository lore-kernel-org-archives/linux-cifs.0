Received: from fout-b7-smtp.messagingengine.com (fout-b7-smtp.messagingengine.com [202.12.124.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5035A2848A7
	for <linux-cifs@vger.kernel.org>; Fri,  7 Aug 2026 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786122948; cv=none; b=JyWxY12DsbyxAs0QtDKjvg5QvDDhoSzQEInMSqL9zAG9EIZxaROYamggCEQwVJZPfHy6+XU7ty4LTKyzwu8WbhnikP22g9123I5FCOjXRpgJLOmiKLIwQdWjJZPsKQiXv4rG9Mc5wyoaqnL8Y1/rcRqfxArWE0TXqxn8kManeN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786122948; c=relaxed/simple;
	bh=BV35DpPMvCTBX00oluqLm0xUBVyuUnc/1OZ8M3NMtvE=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=ZKnumw8YOEjWJvRydrDa6WBYGoXKlLp2NheQqx6HPenrFHkSW1e42l8TfJ8tcZ1o3dGYCj80NxZhXWY2fA3TnqGsWQ+qJD/4vsB560+HTP2fnefPKIoh8XqdE/mZ7QWJvYMlaARm0BASN8/g7ZHgdWHiPlIV1pLyFtC7X5sEpHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mstefan99.com; spf=pass smtp.mailfrom=mstefan99.com; dkim=pass (2048-bit key) header.d=mstefan99.com header.i=@mstefan99.com header.b=ANxYa2HP; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=lwM1/lyx; arc=none smtp.client-ip=202.12.124.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mstefan99.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mstefan99.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mstefan99.com header.i=@mstefan99.com header.b="ANxYa2HP";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="lwM1/lyx"
Received: from ams-compute-01.internal (ams-compute-01.internal [10.64.2.61])
	by mailfout.stl.internal (Postfix) with ESMTP id 0D4D21D000B3;
	Fri,  7 Aug 2026 13:15:44 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-01.internal (MEProxy); Fri, 07 Aug 2026 13:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mstefan99.com;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1786122944; x=1786209344; bh=PmjYsESVn/MALyEV65UlrjSE7BuyKZSt
	JN3zR6ppM/o=; b=ANxYa2HP6p4HQtg/yp8HMQ/u/zbdBa8izHBSX9vfWhtO7+kd
	PXX54Wpu/M0Ure7qqazBD6r3Dozu8MqQkNYr15tRpbnfouFkWdPrJaRI5werTDCp
	K16O5df4s9fm85emIupGa3AbX6R7imA5l2Sxwf/XCIPNSyKFug2jlH5KspDhD8yO
	6bRJS7qOMbXW7s28M17Xn3MvRdeKHikLiCfvQbWvfM8QN3+lbUpCar2mjVmedL+M
	JDbjqv4M8puiUqxw3xvAyooLEM6H/xImREJY+xIXtR1ssSxtgYtaf7rF1wnm8NRn
	c59aDSHwCYVTOdcYztN6Hz5IRv7RxFY/wMbr4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1786122944; x=
	1786209344; bh=PmjYsESVn/MALyEV65UlrjSE7BuyKZStJN3zR6ppM/o=; b=l
	wM1/lyxDEFH6d4IgPvDGPvNbOzB38F2TGPmYcL1vUUYVa9vbBAPOencLdlj6X44v
	p0BEdh6XPUlgJ8fBstB0lzkLGcabQ16arPfhZyEsrFMljgXOh8eYaumX/1vKfPIZ
	Vg2nrHoqU8pCwKASDZjPGautW2FUhatyHwLWv6mNwkJEYTBVOhcDjARjS9yPs39X
	trQu0I3Y4vbwqStXYw5TyKpEtsTHWS3b8sCSCQB1vbHxoERgWg10T4s+y1uOfpEj
	zAbWuvv88yOIqt3dlfu4Bu3GuqfPnQ4FEV7U+Tyo773RWE5fyRfcqsssyIOLrRo2
	hRLjPX/HLIdKSFsKaqkNQ==
X-ME-Sender: <xms:uxJ2akBhwkCWbmP1Nu-pzU42F7d9Rm--ZzEcEvYlEvh0EkWE-3U3bQ>
    <xme:uxJ2ahW8sTjF27kQX5F0mBIOCzH9ZB3TlD5-JfjwDqww1w-RELU7l2KMmzt-f3UB4
    1R3Rn4p3gb9HBeY3biFGINAzZl6rLTEQGvRZz6fXJRc64PTkAXpyqk>
X-ME-Proxy-Cause: dmFkZTFgkW4aJ/9dWIpVHRY163vhkHIAGvUL9vseAIlMpTntBfH5PutFgVb+8pVQc0vWly
    jNbcWvZbHjT2gcQxOyugBLi3P1ndAEsm5//Fnzldcz4YStf4r+qGfz7F3PYrRBPlDiN6Jw
    CNwVaHaqDMEqF3I3xP/UNLnnh2QR9IDOXczgKnelASADkpujsKESf+slyHYyu5Z+tRCp6s
    aWip3doWePMuBZ9lKdBOCMkFwdsWTVjepLrfY8k6zg0iV+shrJOSTRNSt06qvMcsUw8qH2
    oIczhXaa22mBdcT4Bw6roYcKHQOWHJPAZyytjGHJQNfmq8L+aqn1YA1EBhGNNcfApYtrZ/
    ULqwXPnGQgT2z1McrfWylLUUB4vo54qHCj2tbX0ny4xso+JphejvCtd2Iz81ZAD8gQIJHN
    T4wpocDLBSRPjZemv/GAIKWcTOh3g0Ts/ym0hodc0KhyivjnMsk1AiBZKel0kwmPG8PbWG
    Nj+l+hx7IlcjZz4SzOx6UHGNo+YX5hjOxMMQMxjn4RxJHMB9cZvtJR27oOcsCJZFa4R2T6
    txsv5QMuQVi7bGWcvRWJBMvoK0heLdIVOq5OL917fkbR8GKXH2sgbt9qteqMh6QGylHJSk
    7/v6U8KilMZTKhza04cFsduV2J9w3/eeJ+OO41H0EBLDiJmxTYLwG/BbRf0g
X-ME-Proxy: <xmx:vBJ2arM2e9g4VjdDkc7MjE1KcfvEciMFeUjwxwtaatYl6D9UxkEjLg>
    <xmx:vBJ2au51m4oNbolmEKR8LIGWWyXaUr3AtleLmBVk1A8SfL3Iq-rqhg>
    <xmx:vBJ2al1SxiG23ihW6eEcWHFdHpVUQKKUCUDPzFcgvjfc1EkeSLCFHg>
    <xmx:vBJ2avzgnRpknxaqJRvYoEav0oEh1lFxkjy_4ndvCIrD0aBwun5jCw>
    <xmx:wBJ2aqTMTDus9hyC1cVeXEOy2EJkBMOsp8jv6ZzQS94wx7o6iPC0iYLH>
Feedback-ID: ie31c46c3:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 24D5232A0065; Fri,  7 Aug 2026 13:15:39 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 07 Aug 2026 19:15:38 +0200
From: "Mikhail Stefantsev" <mikhail@mstefan99.com>
To: ChenXiaoSong <chenxiaosong@chenxiaosong.com>, linux-cifs@vger.kernel.org
Cc: regressions@lists.linux.dev, sfrench@samba.org, jforbes@redhat.com
Message-Id: <61a34e6d-df1e-4a0f-93ce-ef79ef8170a7@app.fastmail.com>
In-Reply-To: <f875564a-a000-40a3-a43a-888d7c6649ab@chenxiaosong.com>
References: <75fb5359-b268-492d-8d4a-504d1af60f2a@app.fastmail.com>
 <f875564a-a000-40a3-a43a-888d7c6649ab@chenxiaosong.com>
Subject: Re: [REGRESSION] cifs: openat with O_TMPFILE returns -1 ENOENT
 (STATUS_OBJECT_NAME_NOT_FOUND)
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi ChenXiaoSong,

I have tested the patch, it works on my machine. EOPNOTSUPP is returned and apps fall back to saving without relying on O_TMPFILE.

Thank you
Regards, Mikhail

On Fri, Aug 7, 2026, at 11:01, ChenXiaoSong wrote:
> Hi Mikhail,
>
> I have submitted a fix patch, please test it and check whether it fixes 
> the issue you encountered:
> https://lore.kernel.org/linux-cifs/20260807085806.725742-1-chenxiaosong@chenxiaosong.com/
>
> On 8/7/26 14:00, Mikhail Stefantsev wrote:
>> Hello,
>> 
>> I have run into a kernel regression where openat() with O_TMPFILE fails with ENOENT on CIFS/SMB3 mounts, breaking atomic file saving in applications like Krita. According to the open() manual page, the ENOENT error is supposed to be returned when the path (a target directory in this case) does not exist, while a lack of support of O_TMPFILE by the target file system should be indicated by EOPNOTSUPP. Applications receiving ENOENT wrongly assume that the parent directory of an unnamed temporary file is itself missing or inaccessible, aborting the save process.
>> 
>> Downstream bug report: https://bugzilla.redhat.com/show_bug.cgi?id=2499750
>> 
>> [REGRESSION DETAILS]
>> - Broken in: v7.1.3-200.fc44.x86_64 / upstream v7.2.0-rc2
>> - Servers: Synology (Samba 4.15.13), Windows 11 Pro (25H2)
>> 
>> [STRACE EVIDENCE]
>> openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies/6.07.26.kra", O_RDONLY|O_CLOEXEC) = 37
>> openat(AT_FDCWD, "/mnt/vault/home/Drive/Sketchbook/Studies", O_RDWR|O_CLOEXEC|O_TMPFILE, 0600) = -1 ENOENT (No such file or directory)
>> 
>> [DETAILED LOGS]
>> [  106.251673] CIFS: fs/smb/client/dir.c: VFS: in cifs_tmpfile as Xid: 2886 with uid: 1000
>> [  106.252152] CIFS: Status code returned 0xc0000034 STATUS_OBJECT_NAME_NOT_FOUND
>> [  106.252154] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2 status code 0xc0000034 to POSIX err -2
>> [  106.252157] CIFS: fs/smb/client/dir.c: cifs_create returned 0xfffffffe
>> [  106.252159] CIFS: fs/smb/client/dir.c: VFS: leaving cifs_tmpfile (xid = 2886) rc = -2
>> 
>> [MOUNT OPTIONS]
>> //vault/home on /mnt/vault/home type cifs (rw,relatime,vers=3.1.1,cache=strict,upcall_target=app,username=MStefan99,uid=1000,forceuid,gid=1000,forcegid,addr=192.168.1.10,file_mode=0755,dir_mode=0755,iocharset=utf8,soft,nounix,serverino,mapposix,reparse=nfs,nativesocket,symlink=native,rsize=4194304,wsize=4194304,bsize=1048576,echo_interval=60,actimeo=1,closetimeo=1,_netdev)
>> 
>> Please let me know if you need any additional information.
>> 
>> 
>> Regards,
>> Mikhail
>> 
>
> -- 
> ChenXiaoSong <chenxiaosong@chenxiaosong.com>
> Chinese Homepage: https://chenxiaosong.com
> English Homepage: https://chenxiaosong.com/en
