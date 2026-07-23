Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813C230D41E
	for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 21:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784842113; cv=none; b=nPFh93ygJKy60nkQdmBxwWDsnhqVuknvEVXGK838enF1SVdNE7rLmKqQhcgBQ15jCibfZDWRA1ld0v9U8umFBvilNBHKaD/6MH7SWPmbxH92Ps9aWbuOdhg3j+jzeBU0s/K5BR7mdCqC2pjDxJjJnoViXQZ1GL0Xn+SaeqQi4kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784842113; c=relaxed/simple;
	bh=G9l9yrHRU8RIPj3q/bEU/y6USdqkYeWcb3FQPqXO8Po=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:Cc:To; b=N0s00ZppcrH0weYKeHxOhZzoB1Cr7keeiFsaF6HNxfkNXBkPBvVokbnLfOscm5/TYdjIaPqnJHYYlG0tDfJc4dMyX9Zf+6W1sSB8sdBq7+dsB52ABeuZ7/zPwVZ06fubKnLU3guhxLD+sqWr6JWYmPqJm0NUg8XHlJWqPiNVIug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Kl9L+Zmi; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Kl9L+Zmi"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so5565255e9.2
        for <linux-cifs@vger.kernel.org>; Thu, 23 Jul 2026 14:28:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784842110; x=1785446910; darn=vger.kernel.org;
        h=to:cc:from:subject:message-id:date:content-type
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=glSIW7v0xrw8eyDkdSCCW5mmpVQtFuMr6hihXCd3/sM=;
        b=Kl9L+ZmiscGFOlRbNoBfoLQWwqfZ9pSPah0u+yBum33zfdgk6BcD1O4KC0P3pBJask
         Efauwmpo7pIlOiQz5tqLAAldPk0Q+as4ILCBN0U+jXTPcJBij0oxDziptmXPGksQhoct
         IHC6uw6nfKvHhYiuA1nzkWsrevJonHNOoVCS6Y4AQE5d+2Nwbt2ujG/gHr6ZR2hTan+O
         Wt+hx3FQ3XyiZEqUl9imIG4KxIPHstdZ1esBNhrJnlQ0nXbQhICHHt7SE9luEY7aKhv+
         Eu1rPnJVSnC9L9NI8MHzD39nVjlcsi1SsCRR+oUB/B4Jrrk0J+oYHHvkCSOxJJhLOqir
         avFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784842110; x=1785446910;
        h=to:cc:from:subject:message-id:date:content-type
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=glSIW7v0xrw8eyDkdSCCW5mmpVQtFuMr6hihXCd3/sM=;
        b=hQez7U8KOLd7Zc4UFFZLH+wCV42rF6R9CpBD2x4Fn74hl0fEdXB1Wgyise6+lhgQrm
         2ScIpKrSCNP/uXy5z1bL2JebxZ54bE6TPnlmXEdrJorbvQgNQI6vGW9MBl+AhicD9h+s
         ad2pzILUVKqpqZldS/ko47i4u1lTsIUHm8hr5pWIOiPWyZCdc+ZJNcLHFE0rQga++9Jk
         M+mYOu142DgaLOed7gNtY61w0TlWP/qpjJSufJVJiBY4D6zSOiSqU92Hp8pAXCDoz7gg
         53EK5qpMu/zTaTugCpG8gPHmxVBb3LSZ4Zlw/RG7SfhPNyH8S9/ITa3QmOcILeEWppdk
         ewew==
X-Forwarded-Encrypted: i=1; AHgh+RqXft82hWUpSjhisVqznVQ5BGe159BDM8H8TZPfCMZHkoUjVGB22Dm6LXFD+KPA1lfS5E6pIu1zWASl@vger.kernel.org
X-Gm-Message-State: AOJu0YyycVBj+MI9EXCf5BiV3tMYWJDOpyk36urLbTlDluajyjGP7s9d
	3Fg7uIRNYlDOgy6Mk7MO3O+WLlglTjm4escY46MFS+S/jxI0Vxivdj08AQtMy/tWhUI=
X-Gm-Gg: AR+sD12AkwuNDfVyxqq6xurw2vfRbPLXGRGko3I9q6Kg2TO85VWZ4kIWbC5MzAk3mkN
	m+gFRZlWFlSZ4j70VOcGDpi7LexVj4nGhhG+HN9s79iyDyt32wdPKSAPWg2B3iULX5JYf8aYBAl
	9udKtle0SfJX7Fo/sS8rCTlUF8BuzHuttWGxFpuxET2IFcPSIPK+ZUJyG6FCPTj34dfxPoAwC1q
	Lm8VeQS50XqPZDABB0OsGa3ZY7Xb+K1t8kjnpgjvo+LBe/l/j6cf1P7bc1zB8UqOawYO7jDNHgt
	t/KNvb2YJCSIP7J6M3w8C7SqLHAgMySgunr10DmecronkH2f06vK4MEnpBKiHmyRWZJ95o1HNbH
	ojQdRbhAl5v+K7SJn3Pd26Ix2fn+qvSJVVYKNM5z9EzfgQ3uFPpnack/Xbe6folmxts297GCY40
	uX+CfmxRZ9
X-Received: by 2002:a05:600c:4f86:b0:495:6a24:a92d with SMTP id 5b1f17b1804b1-49573cd8af8mr52814295e9.22.1784842109551;
        Thu, 23 Jul 2026 14:28:29 -0700 (PDT)
Received: from localhost ([2804:1b2:1845:f014:8b06:2b8:298a:5312])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3147df0686fsm22941554eec.14.2026.07.23.14.28.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 14:28:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Thu, 23 Jul 2026 18:28:25 -0300
Message-Id: <DK69PZKFFBA3.K1SE3ARGE0K2@suse.com>
Subject: [BUG netfs] folio changes during io results in CIFS send failures
From: "Henrique Carvalho" <henrique.carvalho@suse.com>
Cc: "Paulo Alcantara" <pc@manguebit.org>, "Shyam Prasad N"
 <nspmangalore@gmail.com>, "Bharath SM" <bharathsm.hsk@gmail.com>, "Enzo
 Matsumiya" <ematsumiya@suse.de>, <linux-cifs@vger.kernel.org>
To: "David Howells" <dhowells@redhat.com>, "Steve French"
 <smfrench@gmail.com>
X-Mailer: aerc 0.21.0

Hi David and Steve,

When running the fio write workload

	fio --name=3Dsmb-fio \
	--directory=3D/mnt \
	--rw=3Dwrite \
	--bs=3D4k \
	--size=3D4k \
	--ioengine=3Dio_uring \
	--direct=3D0 \
	--numjobs=3D1 \
	--iodepth=3D1 \
	--time_based=3D1 \
	--runtime=3D500 \
	--unlink=3D0 \
	--group_reporting=3D1 \
	--filename_format=3D"$file_fmt" \
	--output-format=3Djson \
	--output=3Dsmb-fio.json

on a mounted CIFS share I saw the messages

	CIFS: VFS: sign fail cmd 0x9 message id 0x49127
	CIFS: VFS: \\win22.bira.test SMB signature verification returned error =3D=
 -13

After debugging the signed request, sent request, signature and
recalculated signature on sent request I found out that a folio content
change is happening between signature and sending the data, while the
signature is not changing. Some debug messages for reference:

	CIFS: sign-write-req-sig-changed conn=3D1 mid=3D0x49127 hdr_mid=3D0x49127
	flags=3D0x8 cc=3D64 cr=3D72 tid=3D0x5 sid=3D0x2880074000071 iter_1=3D41943=
04 iter_2=3D4194304
	sig_1=3D92eeb2b661423fc65c86401a4c14888f
	sig_2=3D8e53f3f500d42122183c8c74227520e7

	CIFS: sign-write-req-delta conn=3D3 mid=3D0xccb4 first_diff=3D168
	last_diff=3D3754 diff_bytes=3D24 diff_ranges=3D8 len_1=3D4208
	len_2=3D4208 iter_1=3D4096 iter_2=3D4096

	CIFS: sign-write-req-delta-range conn=3D3 mid=3D0xccb4 range=3D0 off=3D168
	len=3D3
	buf_1=3D1d5e730f000000000000000000000000b62c7d9d5f374dcc11c33b6c0fd37332
	buf_2=3D9db87c0f000000000000000000000000b62c7d9d5f374dcc11c33b6c0fd37332
	      ^^^^^^

`first_diff` above shows the first changed byte is payload offset 56
(112 byte header) and we can see a 3-byte change there. This same 3-byte
change repeats every 512 bytes in the payload.

After digging into netfs code, I noticed the folios are not kept locked
while a subrequest is being filled, and maybe this allows changes to
this folio even though it has not been marked as ended writeback.

In my case, the subrequest can be much larger than a single folio, so
netfs accumulates several 4k folios before issuing the network write.

So a minimal change that prevented this unwanted change during write is
the following -- *although I'm likely missing something*.

If you think this makes sense I can send a formal patch.

diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 210eb8f3958d..bce1f2b80a9c 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -63,6 +63,8 @@ int netfs_folio_written_back(struct folio *folio)
 	struct netfs_group *group =3D NULL;
 	int gcount =3D 0;
=20
+	folio_unlock(folio);
+
 	if ((finfo =3D netfs_folio_info(folio))) {
 		/* Streaming writes cannot be redirtied whilst under writeback,
 		 * so discard the streaming record.
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index f2761c99795a..cf4e39d593ce 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -347,7 +347,6 @@ static int netfs_write_folio(struct netfs_io_request *w=
req,
 		/* mmap beyond eof. */
 		_debug("beyond eof");
 		folio_start_writeback(folio);
-		folio_unlock(folio);
 		wreq->nr_group_rel +=3D netfs_folio_written_back(folio);
 		netfs_put_group_many(wreq->group, wreq->nr_group_rel);
 		wreq->nr_group_rel =3D 0;
@@ -415,7 +414,6 @@ static int netfs_write_folio(struct netfs_io_request *w=
req,
 		netfs_issue_write(wreq, cache);
=20
 	folio_start_writeback(folio);
-	folio_unlock(folio);
=20
 	if (fgroup =3D=3D NETFS_FOLIO_COPY_TO_CACHE) {
 		if (!cache->avail) {


--=20
Henrique
