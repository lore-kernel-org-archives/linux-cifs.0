Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M8GqgQRO"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B275119
	for <linux-cifs@vger.kernel.org>; Sat,  2 Dec 2023 14:14:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701555267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7BZGe+TPrlfWd1S6/u7LLwr3ySv8gzThnlXBLe63uMQ=;
	b=M8GqgQROIcAVmZKWu6gfWoaom3VapHwP/2R1og3rz/GwkFMx0F2qMWuji+FJNLLRbijN9J
	XQeY0Il4aNLrg5aJiY/ue9fp0G8bNsBctONTsI2cIRWQ+by2gXTtRbd00GO4Z+Z8cWrrfa
	ciu8gvDf+eOOiCQlq3L3nvFsViXyIMI=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-627-yH4nyWjONmKN2JyVuMEYYw-1; Sat,
 02 Dec 2023 17:14:22 -0500
X-MC-Unique: yH4nyWjONmKN2JyVuMEYYw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B9F0E3C027BD;
	Sat,  2 Dec 2023 22:14:21 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.42.28.161])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E8261492BE8;
	Sat,  2 Dec 2023 22:14:20 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
To: fstests@vger.kernel.org, darrick.wong@oracle.com
cc: dhowells@redhat.com, Steve French <sfrench@samba.org>,
    linux-cifs@vger.kernel.org
Subject: generic/304 doesn't seem terminable for cifs
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 02 Dec 2023 22:14:20 +0000
Message-ID: <3876191.1701555260@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9


I've been running "-g quick" on a CIFS mount and it got to generic/304... a=
nd
is still there nearly 30 hours later.  The kernel isn't stuck - userspace is
cranking out BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE at a great rate.

The ps tree looks like:

S+     0:03       \_ /bin/bash ./check -E .exclude -g quick
S+     0:00           \_ /bin/bash /root/xfstests-dev/tests/generic/304
S+     0:00               \_ /bin/bash /root/xfstests-dev/tests/generic/304
Dl+  316:55               |   \_ /usr/sbin/xfs_io -i -f -c dedupe /xfstest.=
test/test-304/file0 0 0 9223372036854775807 /xfstest.test/test-
S+     0:00               \_ /bin/bash /root/xfstests-dev/tests/generic/304
S+     0:00                   \_ sed -e s/^dedupe:/XFS_IOC_FILE_EXTENT_SAME=
:/g

The xfs_io command strace is an endlessly repeated:

ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=3D3894380=
53887770624, src_length=3D8833933982967005183, dest_count=3D1, info=3D[{des=
t_fd=3D3, dest_offset=3D389438053887770624}]} =3D> {info=3D[{bytes_deduped=
=3D1073741824, status=3D0}]}) =3D 0
ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=3D3894380=
54961512448, src_length=3D8833933981893263359, dest_count=3D1, info=3D[{des=
t_fd=3D3, dest_offset=3D389438054961512448}]} =3D> {info=3D[{bytes_deduped=
=3D1073741824, status=3D0}]}) =3D 0
ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=3D3894380=
56035254272, src_length=3D8833933980819521535, dest_count=3D1, info=3D[{des=
t_fd=3D3, dest_offset=3D389438056035254272}]} =3D> {info=3D[{bytes_deduped=
=3D1073741824, status=3D0}]}) =3D 0
ioctl(4, BTRFS_IOC_FILE_EXTENT_SAME or FIDEDUPERANGE, {src_offset=3D3894380=
57108996096, src_length=3D8833933979745779711, dest_count=3D1, info=3D[{des=
t_fd=3D3, dest_offset=3D389438057108996096}]}^Cstrace: Process 105030 detac=
he

with the dest_offset increasing a bit each time.  The log so far is:

wrote 1/1 bytes at offset 9223372036854775806
1.000000 bytes, 1 ops; 0.0000 sec (97.656 KiB/sec and 100000.0000 ops/sec)
wrote 1/1 bytes at offset 9223372036854775806
1.000000 bytes, 1 ops; 0.0000 sec (97.656 KiB/sec and 100000.0000 ops/sec)
wrote 1/1 bytes at offset 1048575
1.000000 bytes, 1 ops; 0.0000 sec (139.509 KiB/sec and 142857.1429 ops/sec)

Looking in the protocol dump, it's endlessly repeating:

  190 0.007930488  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 174 SetInfo Requ=
est FILE_INFO/SMB2_FILE_ENDOFFILE_INFO
  191 0.007962785  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 136 SetInfo Resp=
onse
  192 0.007974644  192.168.6.2 =E2=86=92 192.168.6.1  SMB2 230 Ioctl Reques=
t FILE_SYSTEM Function:0x00d1
  193 0.008069283  192.168.6.1 =E2=86=92 192.168.6.2  SMB2 182 Ioctl Respon=
se FILE_SYSTEM Function:0x00d1

It's advancing the EOF marker each time and then doing some ioctl function
that wireshark can't decode.

Is this a bug in "xfs_io dedupe"?

David

