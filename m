Received: from mx.manguebit.com (mx.manguebit.com [167.235.159.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4279374D1
	for <linux-cifs@vger.kernel.org>; Tue, 29 Apr 2025 21:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=167.235.159.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745963821; cv=none; b=P9PLeOuWAOfjx5jEq/OE5S2Xh58q9EKL5/rD6YTeNAEcI38Sk8v1FLviDxPUGZgNT3r+pzasv+gutYoijUoCbJl+OKb1lxXHTTcDNXpe1xfGcd9L6Uw4LlTTfEcBNVGgBpH7eoF4kIdAg/xNnriRroKqd/fAhWmJVFYC58I9I00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745963821; c=relaxed/simple;
	bh=Wnek8+x61ZxSsKd8jG3dQLS9ihnAtgd/iBK2HPtIpJs=;
	h=Message-ID:From:To:Cc:Subject:In-Reply-To:References:Date:
	 MIME-Version:Content-Type; b=tKs1ueTCVU7y5lEsK70RgUKHJtiP/LuOJvNqI8eKi1OY9eNK4eBCDcMJwvhwu+jMnSTO/rykiTNgpYvWuLlUH855yELCBDcY2yC7qX65MisrYx2gwfhMjXORvLt8q+/YKvIQ/VAWHWtLbNAl12LOjRChuRkvCi2tlXiwkko7NPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com; spf=pass smtp.mailfrom=manguebit.com; dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b=f+fd7Ilu; arc=none smtp.client-ip=167.235.159.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.com header.i=@manguebit.com header.b="f+fd7Ilu"
Message-ID: <820638980904f9bdf9f67602d89ef4c8@manguebit.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manguebit.com;
	s=dkim; t=1745963817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pBczkKxlj9aqiz/Zo+4W3t9byhCdIwRY6WhxituGAqg=;
	b=f+fd7Ilu6eA7FMNT0/sWQgTdEMZqVRiCwyavf2Ggh60B6UJ5l1CHdsqJATwV0K35Q+4XUX
	VEZqpmUeZ+ux5lkJl2z/8ZhdIWMHtsh5mBoi4eCC6L9DEM9nbVUdcVebilEObHNNKFCB/7
	GE41H0A1mVTTPoBdRAoGDzy/fOpWYuWtCGuZFloYgSQtWzUcjO0Q/RBoTDBgtJgICsnxMs
	JVWHhGMOP4WTqG2KNwVfw7K4AIdbFSkk/IqnaAhCy7t687yYD1AF/knGiImbQV6yyy77r4
	iyEhO6qhItqsm3WoMTHQh1QlW5uW38k1sDnTeQ300emM29EnaLYMl3FvXUTdXw==
From: Paulo Alcantara <pc@manguebit.com>
To: Steve French <smfrench@gmail.com>
Cc: linux-cifs@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] smb: client: ensure aligned IO sizes
In-Reply-To: <CAH2r5mt_jzayXwXG6R5P1cPv5McSKATW6va6Ei=xghD-swB=Rw@mail.gmail.com>
References: <20250429151827.1677612-1-pc@manguebit.com>
 <CAH2r5mt_jzayXwXG6R5P1cPv5McSKATW6va6Ei=xghD-swB=Rw@mail.gmail.com>
Date: Tue, 29 Apr 2025 18:56:53 -0300
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Steve French <smfrench@gmail.com> writes:

> Do you have a repro example?

---8<---
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>

#define die(s) perror(s), exit(1)

int main(int argc, char *argv[])
{
	void *buf;
	int ret;
	int fd;

	if (argc < 2) {
		fprintf(stderr, "%s: [file]\n", argv[0]);
		exit(1);
	}

	fd = open(argv[1], O_CREAT|O_WRONLY|O_TRUNC);
	if (fd == -1 && errno != EEXIST)
		die("open");
	close(fd);

	buf = malloc(8*1024*1024);
	fd = open(argv[1], O_DIRECT|O_RDONLY);
	if (fd == -1) {
		free(buf);
		die("open");
	}
	ret = read(fd, buf, 8*1024*1024);
	free(buf);
	if (ret < 0)
		die("read");
	close(fd);
	return 0;
}
---8<---

$ mount.cifs //win-srv/share /mnt/1 -o ...,rsize=65535
$ ./test /mnt/1/foo
read: Invalid argument
$ umount /mnt/1
$ mount.cifs //win-srv/share /mnt/1 -o ...,rsize=65536
$ ./test /mnt/1/foo
$

> Could this have negative performance impact to some servers?

I don't see how this would impact performance.  The default values for
rsize, wsize and bsize remain the same.  We just want to make sure that
those values, either passed through mount options or negotiated by the
server are multiple of page size.  Otherwise it will break IO to files
opened with O_DIRECT which require offsets and lengths to be multiple of
block size.
