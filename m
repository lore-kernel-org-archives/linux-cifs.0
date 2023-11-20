Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="iqUsgEZo"
Received: from mx.manguebit.com (mx.manguebit.com [IPv6:2a01:4f8:1c1e:a2ae::2])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D73710C
	for <linux-cifs@vger.kernel.org>; Mon, 20 Nov 2023 06:17:20 -0800 (PST)
Message-ID: <14fd545cbbdfda52300ad19b66a02f5a@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700489839;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yeWz9dMmT3kXFwsoJmvSMIEdb5dMKxqNgOpQDS6W/hk=;
	b=iqUsgEZogrqn32BHpe7in7OfS8RicmTUUq21xEFCeNzVmrG/PKzOCZKNtnDilpNCYff7s/
	aWMAARzpChaJdLGfFbzcO/oHD2iK/kA0AhgZm0iMBtHxbfrTb1nnMaI585T5NJJn2NTZHZ
	yxWJ2JVFZJo309zaiyDzFD33y8qxxxgGDsZgQ385G/WKSKsw3eCpufVU7K6bibna63IKkC
	nfwQAQRVgQw7njzOTh3025Eqa22tsEQx/AmBlV7v/IGDA1kcKD1i8bk+e7AMJNN0BEBDv5
	7bllSdtVmqzopO0Q5S+TDcmJNebYg4alB9C3YDPeg1ObfS+erFaHcSl+aQ7MhA==
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1700489839; a=rsa-sha256;
	cv=none;
	b=Ct/4LinmzNQd7zlVlo8mMUIeGIITek1OgyBO1QemKB4iOLCycZ5w78kt6XtLaLV7RkTjSr
	JamryE8a0dv/2S5BgfXEsmENECH3pOAyJ9781XLgYLIO8p7sPo1TA2Y06XpbCNSV7ck+Bl
	+pPJrQm+pPy1mvQ+Gc9zQQrTVkdDhuJF8pvNx53g8xNnbkKqVjFsxmr0PzWQUlebf+3q42
	1yxM84HhkhyibmnphfSzh4j61w5Wle1Q/3Jf0MItEzoBmNKzB7tukHLQfDNIKLZq6D9R2J
	LI9wiOcdhxDjFHwPfG+Z0zJsZV2DSMhCX1pN7RhgswTtZ0odb+hsg7lGWZ3fsw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=pc@manguebit.com smtp.mailfrom=pc@manguebit.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1700489839; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yeWz9dMmT3kXFwsoJmvSMIEdb5dMKxqNgOpQDS6W/hk=;
	b=koX+sr/hsDiUUXaF5eRo2tafZApxalVG4zr9sVMBce0wNzfmJGrteg0EtlIRoFKrA09nRX
	KRG+lTtJ+4DJxhrT3jqGPTkoBILloJdJjirr3qBmtrF3U9oIRkpwF0zlUIGuANDMCY6hdP
	XBYkPOxS/C/OcwpLYZuzUFTLrLAQOB6U5f8wGkjWonW/ySnsOYBKSkXRz0ko0Z5qdYP3Tp
	c/QC0+x1crsYQ91UwnR1FhaX6bJj+PpQjAW73Xk1OsiwYhpu5aw4MxgjNa7Q/1PjC0UCDY
	WgB+jApUmW0VcugO4aEQY/g1iF+XNWt1BqOLLNTKJCOXcw9j4Sw5W1Jt9a6rKw==
From: Paulo Alcantara <pc@manguebit.com>
To: Ralph Boehme <slow@samba.org>, smfrench@gmail.com
Cc: linux-cifs@vger.kernel.org
Subject: Re: [PATCH v2 3/3] smb: client: set correct file type from NFS
 reparse points
In-Reply-To: <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
References: <20231119182209.5140-1-pc@manguebit.com>
 <20231119214450.23779-1-pc@manguebit.com>
 <20231119214450.23779-3-pc@manguebit.com>
 <ebade998-7c7e-422f-a1fe-680571b1310e@samba.org>
Date: Mon, 20 Nov 2023 11:17:14 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Hi Ralph,

Ralph Boehme <slow@samba.org> writes:

> On 11/19/23 22:44, Paulo Alcantara wrote:
>> Handle all file types in NFS reparse points as specified in MS-FSCC
>> 2.1.2.6 Network File System (NFS) Reparse Data Buffer.
>> 
>> The client is now able to set all file types based on the parsed NFS
>> reparse point, which used to support only symlinks.  This works for
>> SMB1+.
> any plans to also implement this for SMB3 UNIX Extensions?

Absolutely.  Just wanted to make sure that these worked only in the code
paths where we actually handle reparse points.

I also plan sending patches to support creating special files via NFS
reparse points and make it default when not using SFU via mount option.
