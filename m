Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F22326CE28
	for <linux-cifs@vger.kernel.org>; Wed, 23 Jul 2025 21:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753306121; cv=none; b=FY8K5g5uaSZVHG7vwVVa7UFdr9P8quWoxS1qFkEAxSg/+gEkqwpnkknLzmgH3DuhOTMiY2sIQ9GjfmddOvIDJAcsX+0fQlwpQz/l6HYp4COttRbGXRG/Q/mGubDSFKE6OSqPVCz1aMODDYMJpPBS882DUIvIVxBDrCntj03g9yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753306121; c=relaxed/simple;
	bh=RK40e9cWOTLzuKZU3c7gO/nzgGBIY1wLr+lO5lVfUi4=;
	h=From:To:cc:Subject:MIME-Version:Content-Type:Date:Message-ID; b=Vo1nNtoBWyOdWtdC6O19NEsQxXseWD/K02rcfO5fjsdbLLacAQ/1/3/MSAb+W/Zs6EidIIiS7L3hcbmgQTdgsmTt7RU4NjSuBMzorQKlDR2LlSaRUjxbAO8lKjZaLccsXMJMd4jgBfzp8bGsvyvFZ/f2wCmbXwJzoQddzFVZszM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GF9tUqyE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GF9tUqyE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753306118;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=GN7k9/itngbw1cdkbniNR6CYtStGF3ZBNnPAXdahFQQ=;
	b=GF9tUqyEtxd/eeHn7fpyyEGYt4gaqU+SAI/dNmnhQiD2gta3zLV6W7O3P6VzgBWtHyFeT6
	PCvQaK0ehw6K+ecWYio7HYvB67f3P65JBojMKocGAusmdO2qDDq426TabcheM/aqhSvxme
	hguYiYw/fF1I1bc21CQQrGPW5JhdFqU=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-29-lSeVHNPUMFKgyUaQ3G-5jQ-1; Wed,
 23 Jul 2025 17:28:34 -0400
X-MC-Unique: lSeVHNPUMFKgyUaQ3G-5jQ-1
X-Mimecast-MFC-AGG-ID: lSeVHNPUMFKgyUaQ3G-5jQ_1753306113
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9DA9C195608B;
	Wed, 23 Jul 2025 21:28:32 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.8])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6B51630001A4;
	Wed, 23 Jul 2025 21:28:31 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: Namjae Jeon <linkinjeon@kernel.org>
cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    linux-cifs@vger.kernel.org
Subject: Probable ksmbd bug causing Create Response to show bad timestamps
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Date: Wed, 23 Jul 2025 22:28:30 +0100
Message-ID: <317462.1753306110@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

--=-=-=
Content-Type: text/plain


Hi Namjae,

I think I've found a bug in ksmbd.  Using the attached program to create a
file, stat it, do a DIO write to it and stat it again:

	~/write /xfstest.test/foo 0 4K
	sleep 1
	stat /xfstest.test/foo
	~/write -d /xfstest.test/foo 0 4K
	stat /xfstest.test/foo

and having mounted a ksmbd share with cache=strict and actimeo=1, I see mtime
and ctime getting corrupted:

  File: /xfstest.test/foo
  Size: 4096            Blocks: 8          IO Block: 1048576 regular file
Device: 0,65    Inode: 2033391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:cifs_t:s0
Access: 2025-07-23 22:15:30.136051900 +0100
Modify: 2025-07-23 22:15:30.136051900 +0100
Change: 2025-07-23 22:15:30.136051900 +0100
 Birth: 2025-07-23 22:15:30.136051900 +0100
  File: /xfstest.test/foo
  Size: 4096            Blocks: 8          IO Block: 1048576 regular file
Device: 0,65    Inode: 2033391     Links: 1
Access: (0755/-rwxr-xr-x)  Uid: (    0/    root)   Gid: (    0/    root)
Context: system_u:object_r:cifs_t:s0
Access: 2025-07-23 22:15:30.136051900 +0100
Modify: 1970-01-01 01:00:00.000000000 +0100
Change: 1970-01-01 01:00:00.000000000 +0100
 Birth: 2025-07-23 22:15:30.136051900 +0100

I've also attached a PCAP file.  Frames 16 and 19 show Create Response
messages with bad Last Write and Last Change timestamps and I think this is
being reflected in the stat output, possibly due to deferred close.  Doing
another stat a bit later shows the correct timestamps:

Access: 2025-07-23 22:15:32.279094100 +0100
Modify: 2025-07-23 22:15:32.279094100 +0100
Change: 2025-07-23 22:15:32.279094100 +0100
 Birth: 2025-07-23 22:15:30.136051900 +0100

I've also added a kernel trace as requested by Steve.

David


--=-=-=
Content-Type: text/x-c
Content-Disposition: attachment; filename=write.c
Content-Description: Simple file writing program

#define _GNU_SOURCE
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <sys/fcntl.h>
#include <sys/mman.h>

#define OSERROR(X, Y) do { if ((long)(X) == -1) { perror(Y); exit(1); } } while(0)

static unsigned long parseval(char *p)
{
	unsigned long val;
	char *end;

	val = strtoul(p, &end, 0);
	switch (*end) {
	case 0: break;
	case 'k': case 'K': val *= 1024; break;
	case 'm': case 'M': val *= 1024 * 1024; break;
	case 'p': case 'P': val *= 4096; break;
	}
	return val;
}

static void format(void)
{
	printf("Format: write [-dD] <file> <off> <len> [<off> <len>]*\n");
	exit(2);
}

int main(int argc, char *argv[])
{
	const char *filename;
	unsigned int flags = O_CREAT|O_WRONLY;
	ssize_t wrote;
	size_t size;
	off_t pos;
	void *buf = NULL;
	int fd, opt;

	while ((opt = getopt(argc, argv, "dD")) && opt != -1) {
		switch (opt) {
		case 'd':
			flags |= O_DIRECT;
			break;
		case 'D':
			flags |= O_DSYNC;
			break;
		}
	}

	argc -= optind;
	argv += optind;
	if (argc < 3)
		format();
	filename = argv[0];
	argc--;
	argv++;

	if (argc & 1)
		format();

	fd = open(filename, flags, 0666);
	OSERROR(fd, filename);

	do {
		pos = parseval(argv[0]);
		size = parseval(argv[1]);
		if (size) {
			buf = mmap(NULL, size, PROT_READ|PROT_WRITE,
				   MAP_PRIVATE|MAP_ANON, -1, 0);
			OSERROR(buf, "mmap");
		} else {
			buf = "";
		}

		wrote = pwrite(fd, buf, size, pos);
		argv += 2;
		argc -= 2;

		OSERROR(wrote, filename);
		if (wrote < size)
			fprintf(stderr, "Wrote %zx not %zx\n", wrote, size);

		if (size)
			OSERROR(munmap(buf, size), "munmap");
	} while (argc >= 2);

	OSERROR(close(fd), "close");
	return 0;
}

--=-=-=
Content-Type: application/gzip
Content-Disposition: attachment; filename=pcap.gz
Content-Transfer-Encoding: base64

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
AA==
--=-=-=
Content-Type: application/x-bzip2
Content-Disposition: attachment; filename=trace.bz2
Content-Transfer-Encoding: base64

QlpoOTFBWSZTWfV2p4wACXzfgHzQQAP/8gEgEA6////gYAb/b5YBti2BkNAAALxjQ0NABkNAAAAA
BKBMkTImgAAAAAANKekEwJhMRgBGmmhpgQMaGhoAMhoAAAAAIpRpqZoQQaAAaNGgAPUCoogQEI9R
PU0E09I0PUD1PUeU3CTqWRKSwidu/ljR6ey5znx7s3RjbfPjjW5LxA63UZBahnVlWXByD0drw7Oz
PbERBEGQ1jxK74MIDCizW4YEtFnWNqs02F3UqBCi2EyChcoSS+kU2HwbiZqtJ69ebFrFnjPLOpuw
5MiqWKOPrECS5iIXLjsNDlbhi6c8Yxm9MHRs6MSlYYa5t5TfNu2y8IZ1Zy3bbttc+ySDnA9Bgqwq
/mcktSl9IPak+hLJPm/6r3DvEeUngh2k0ieQdfO4xfPXS4zjNxicJWs1dzGX2K0bENTBkn7SQY0i
TayJUnE55kmSYKG8xVtRjXEFuvTb9UsSckkTai2G84TjLHjRWHxOqG7xE3MnCaprGg6+yMAxZIrE
XC+y7c9rz9+NcZ5xqUdIOInSDTDSSvQIUKYV4SRzJOQyprVgbOkZ0AhxlSKL2iy0zLg+QiROBsOY
bsLW/MkYk3rlU9ZIPbiNNzEzWJWcTLN53Nx0umuLJP7SQac98XQnQ6aFYNGruqm0wcpi6ZmD+URe
2TGSyy4OjWzgoqQRiiIBDhcVMNWjOsZMmGcZnREWps3rImXomgYWzEYIQghBvqamcyUqoTlXDVTR
vJoZcKVXLVnpJtnFkgqOl7MLnGzhtyd0ZyQ34LZHKDO+U4ddLqiWyS85tdWOuGluE3LvjHLbpnZr
eGHeBxJ+hma85OW+104yxMRFksmFIWWSy2riMWxzrbbTGmJbO410g33kzuLWN8Zzrj/z1WRVPupc
W1LCksmI89216Y6h87GWipKKdlyuq2JMKWZwu+E3utS7vhUJUk4TEOqsLU/RxaV0jK47rmJoEmEP
UUsicgw75E0NEOCyI9BYGX0Wrbattw3KDTRiMYVVRVMNGmcyQwpuwwYfOdUNWr8I99i/gn7FqxCp
ZJy1tttqvWeZ6VFi0KngxUWLgxRaBWpBkaBDcSVNpWbbxiHID6TEbE97WRkwxDiS2MIdFQ6NkPo0
angw6ssKOSyVThD6HxWFV2k/+9UPkdUOxPJmbn2kg8I+T6vVD/RzN0PgK+/5y2rUMHo0kMRF/H8m
LbLcVivnhJNESkPN6werukkVYh6KiWJgp6JrDCPusLq85HJyOEkmTKR8HuiT9UcRGLf4ofF2TJ3V
XNwiHqbFMIc5I8mE+0TiSPwQ5IfBsbH3mWhlxH6RxH8D2o8DVD2H2mGYk3PzGqGUOJ1RPCH3OEOE
awO0DSIf4RPDsOUSYQ+rKHmhzfk9qHwco1kGIyExE/Em/ceB6Mm7RDsnlJBUhs1dasqrKqUqyrMP
vJwh7UKh72iRh9nRDKG0iLOhyMDw6PJIqGs+A7E+MT3GXmdDpOgo973OTQ6YNnJzGJB2WQ1O5Ug7
PCHc/26nRuhzkHWJ7UOiGo6sKSeZSNOrQsibHmhgvx+ttq1VVbcERqPcr7E5ujsTHS38ZNiyN4T1
Q1JiSTZTMkWMTlAru0aInsKISJn5BkGo1iGZwNYjoXsRzgeCLWPmCIgSBD6MhSZgkGZBBrkFwP4u
5IpwoSHq7U8Y
--=-=-=--

