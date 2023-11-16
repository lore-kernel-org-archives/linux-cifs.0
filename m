Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="ERaDCuRO"
Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910C8D52
	for <linux-cifs@vger.kernel.org>; Thu, 16 Nov 2023 11:35:15 -0800 (PST)
Message-ID: <a7e0a3d3599122b09e78f354bf368794.pc@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700163313;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bcOgaiOKrLYD2m46GSy2Gn7lGCmuGlfK3O3RhsUk/IA=;
	b=ERaDCuROS0ZlLngH38K8cQ3D90439/8mAtnuYicyPFa3nwA97xGViX3VH/xz9uKEIv5f40
	K3uDYohNCks9do5/PUOkKR6RbfPqfEgQGEHiG/bBh/IR1VuCLme3zs8vNZhyw/A20Ea7p4
	CYscU7sGgqvhqkjAltItdyGoBqyqt9tBcRLUn+9irWHvmoRKGU8pn4PcWRemvWL5Dw/XRw
	PgCLwoyY1ZusPTxYRGEVduNdgee4ZIqUIk4FuFrmO78ZueNyC2oGKfEtg9s+Lkyl7OKbUf
	5R318nGMrPkfjOvBAw4/N1L3WoC5yROvbUPRKt5OFlmJmD8zs/3F7+GZbhqJCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700163313; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bcOgaiOKrLYD2m46GSy2Gn7lGCmuGlfK3O3RhsUk/IA=;
	b=R6e74aJUQ1JwbVGwd3Qx7XOqjewMBWn0I3ZnqREY3leUTelR1ogJX17AECkUF9DcC6kfc7
	BWsxa3NabCwzOJRegV2pQebQbIHD2CHELs+t3R5fnFSNX7I26KoEZkTRYPN+dBB3XBXmqP
	Nu561MjLPZrAg0e2YeUaz88BU4I4FRVGXCNr9DrS1ZLn91aeEC339pMO6gNzNcuDiE/QX+
	2mDmKgwJL1+dyZpJd1RjoeoOCXnFsV+lgs7PbU3NpM/lLsvGaPCXUjugjMH0OR/Qkef5xu
	OcA/8IdW/Uf3ZBmCpyARztfKMqDEVHwXbB0JGDlcgEqGaR6mWkmRDeYf8gDGfQ==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700163313; a=rsa-sha256;
	cv=none;
	b=KPGYL+GfRfcVh24zFSyozuV4FlO5ivb1SHRr2Sx0E2BRbocE7ahZHd130Jo5fLElZRwYZO
	JOUZE8p/qcveRYFHivgEBAJb6hKw62b2wkuUibnoT1NDdoOOEQAv4DxxxtzMNWHvyyR9YC
	nBOBJeD/jhDKTBmFb0zjD7PCK9yTrSixHVah9uy+X2URsklg9x7RRLfuP95cVQTAW9RTel
	lOnsvmoCGPuqJGXw7uqo7xspiDznRKwmbngiHtOi7NUS6cEyX0VmaSDiKdcohoAhw8V1Sw
	LS+bBcXUg1E0Mbr468iWM2Bj5VPbis9uYdGtA0HQAyUqpvN1wN99PJIyohn+Qw==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: nspmangalore@gmail.com, bharathsm.hsk@gmail.com,
 linux-cifs@vger.kernel.org, Shyam Prasad N <sprasad@microsoft.com>
Subject: Re: [PATCH 10/14] cifs: reconnect work should have reference on
 server struct
In-Reply-To: <CAH2r5mtDeP323Z8=9WjCCYVVb9B2AmO5Q4PDtcMz8wxVUCVRBA@mail.gmail.com>
References: <20231030110020.45627-1-sprasad@microsoft.com>
 <20231030110020.45627-10-sprasad@microsoft.com>
 <7fe9a29a4df9c00e91c7d9eafe588f1c.pc@manguebit.com>
 <CAH2r5mtDeP323Z8=9WjCCYVVb9B2AmO5Q4PDtcMz8wxVUCVRBA@mail.gmail.com>
Date: Thu, 16 Nov 2023 16:35:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> I haven't seen the use after free you see - but I do see the mount/umount
> failure around tests generic/044 and generic/045 with and without
> multichannel (which predates 6.6, probably introduced in 6.3 or 6.4).  I
> also have seen some refcount warning in code paths called from query
> interfaces - but it hits it only a few of the tests in the full test run.

You haven't seen it because xfstests don't excercise reconnect or DFS
failover code paths.  It will only if client looses connection to server
while tests are running.

> Any thoughts on this warning?
>
> "[18326.477305] workqueue: smb2_deferred_work_close [cifs] hogged CPU for
>>10000us 8 times, consider switching to WQ_UNBOUND" (e.g. I saw it in test
> generic/048 without multichannel)

Never saw this one.  Can you bisect it?
