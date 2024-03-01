Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C548C70CD6;
	Fri,  1 Mar 2024 16:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=167.235.159.17
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709310323; cv=pass; b=TBHmp/CQaMSKLo4XeOKe5xaNS8M4VV8Zu7sL/WFMxf7ikBf8kd/J6xQe4pjVb6563ft9Q7eWUEZFsdgvI6sjxoZoExd6/vVtwjCF3SA9wwXH4sOgVtsmBxD/uJIjkUAPCN6gJJI+jke0hO3Dzk+x1L6SppnBB5JKEuWuUs8xyOw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709310323; c=relaxed/simple;
	bh=vp9j+n7oHAMzhQAPDZrdwUi+rl+SJYuXuVX9dsC9oD8=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=EfhpVVyjJBFmdBwrqAtzZSe86KmPUfgEzVUe/I2qa9n+dstksas5Drb+RwiuAuavaSSQ7glczze+g8TNh2DlZoNT3QJY9oQQAYsT58BgP+Wy7mmB/zmqXDg1UzvANtQByIII443elsw0hhPUn9Pr01G+BtPTm6/cyN7EX3AefbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=o9HD4HyZ; arc=pass smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="o9HD4HyZ"
Message-ID: <a5eb6c3a2de1b959117d49c436b81904@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709310314;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwOTFlXkv+q9d5OsMsOmpSMt8s2dJvrQ+Z2Vcq62GTU=;
	b=o9HD4HyZmGs9XwXYz5e5oGYG4BH6LlgEskS33m0mawinQjvy0l2XtXcNNDIZY3w3SS463w
	+Y1ms5gHVPBUipTHOZd5L2PPC0h65kYp7Edp5YmFVRTG2yGvQJGPH9/jUWrBDOu3Ij0x2Y
	oqtFdHeFkE8EEWIvL/sa+LiM/LYEgPSAfwUizXwj02yfC97AS6kaFe2lZIHVw7eEAVYyiF
	8nle3eUj5SChg2i1HMkChK4wpO91xX1O6LehuiNZEbaI3UAUn6skxHuVM2DNyf9Y8QNrbg
	6UrT214vsjv1BYi/X/OBAIATRmeQm/2TfdAox+MRUvDykOu0PNz28DrPNuY0WQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1709310314; h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fwOTFlXkv+q9d5OsMsOmpSMt8s2dJvrQ+Z2Vcq62GTU=;
	b=SSknn35ORpMzxneG5O72CYo0v/GtE2cx66WHdDyR+/qc27O8GS4h5cU/uablmq46e4qHHo
	QvnRax5IAvbCSC4Ia7Ol5ezRxif/iVSnlpVi1tfcI3TqgcdJsFK3vrTiC9StxKu5M3laAV
	hWwrJuG+mczcyUujDrlXT8N6hPlOfZcEl51zF9uRAWFG25lj3pLpHqkeXWeARBzsJZE8nG
	w1zCeuow1uCjepGYahPpu8MpndkYSR6o7L1WIqJwyzOlOpRhtivmiOEFJL/7fMv9VCJrc2
	X5UyNJuPTv3z3LGCRIkupLuoCNHLliu6Ejhs6Wp474nw0Ua4/1p+ADAq4FCn6A==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.mailfrom=pc@manguebit.com
ARC-Seal: i=1; s=dkim; d=manguebit.com; t=1709310314; a=rsa-sha256;
	cv=none;
	b=GZgh/jErm3xYjyFqOQuAOip0khNaolhZSBKhcSMMNsDDhD5DMopTl20x2KuEvieE0GERi5
	aAWrPVyhyUhTB6eq0v8GywKB2HDAmsZvm+R5BUYY7pZ9JuIAnjrsG+VeyJVuOrwKX3PYGl
	F7SToTWGDKdiRA8o/HDmD4BLPL1cuJhGKBVQO1CP7313X6dQLUUz/I0sXvuxu4hMtSHGpQ
	5wtAiFlYCDJGiZRp0kCPtpk04pRWRcsCpGamiNrQ+UadFHHhYI40ItnLX71Sw9ORnTsHT3
	3nSNNnqtT7GoWxwWF+iiveLFi+aDRZHXPs7FhlaN33rtdt9aE3pRiMSXWhTtbQ==
From: Paulo Alcantara <pc@manguebit.com>
To: Alexander Aring <aahringo@redhat.com>, Zorro Lang <zlang@kernel.org>
Cc: Zorro Lang <zlang@redhat.com>, Steve French <smfrench@gmail.com>,
 fstests@vger.kernel.org, gfs2@lists.linux.dev, jlayton@kernel.org,
 linux-cifs@vger.kernel.org
Subject: Re: [PATCHv2] generic: add fcntl corner cases tests
In-Reply-To: <CAK-6q+jZVfK2=Z6RCCU+K+TLYuHgC4ynqOBz3K-nhcypCoN3ww@mail.gmail.com>
References: <20230925201827.1703857-1-aahringo@redhat.com>
 <20240209052631.wfbjveicfosubwns@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAH2r5msWwX7QdXrzmR3tapU85WMga9Y-waNOHm+hMWmWPUF=tQ@mail.gmail.com>
 <20240209114310.c4ny2dptikr24wx5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <20240301103835.gylf2lzud2azgvx7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
 <CAK-6q+jZVfK2=Z6RCCU+K+TLYuHgC4ynqOBz3K-nhcypCoN3ww@mail.gmail.com>
Date: Fri, 01 Mar 2024 13:25:10 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Zorro,

The problem is that cifs.ko is returning -EACCES from fcntl(2) called
in do_test_equal_file_lock() but it is expecting -EAGAIN to be
returned, so it hangs in wait4(2):

...
[pid 14846] fcntl(3, F_SETLK, {l_type=3DF_WRLCK, l_whence=3DSEEK_SET, l_sta=
rt=3D0, l_len=3D1}) =3D -1 EACCES (Permission denied)
[pid 14846] wait4(-1,

The man page says:

      F_SETLK (struct flock *)
              Acquire a lock (when l_type is F_RDLCK or F_WRLCK) or release=
  a
              lock  (when  l_type  is  F_UNLCK)  on the bytes specified by =
the
              l_whence, l_start, and l_len fields of lock.  If  a  conflict=
ing
              lock  is  held by another process, this call returns -1 and s=
ets
              errno to EACCES or EAGAIN.  (The error  returned  in  this  c=
ase
              differs across implementations, so POSIX requires a portable =
ap=E2=80=90
              plication to check for both errors.)

so fcntl_lock_corner_tests should also handle -EACCES.
