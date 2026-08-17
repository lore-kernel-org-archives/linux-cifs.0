Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1143F8A5
	for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 17:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786987027; cv=none; b=YbVRRsVS3gpNn5AT1ldDIsJACVMHJohFJ2rIDfn1X29lcMJu2sPp4dDAETmUDyJ4sbvgm1rjK+aB11CwZibm4idDZZxkRJ5mlCeZK7jzWMwY41ZbKJwvGjh344vQcVsAZSscQtOWEWwKb1V6KK6QNrPbdc7db/oLVBsH6TdKfG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786987027; c=relaxed/simple;
	bh=VOYBcWp6KT9RjVqAljI/2F80dW9AyMNG+ttnL2o0FGc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IodqVLxMOuigsu/VcHd64acLXOkbkH+JJnaTZxYXTHO+F+KbanXSlK7degP90atnAbXFgCHmH15rYcTj+nlVydyuwAl6999hBVk48HZteqpLUDKQYXduyACIisLH11mBRm7Lhtcr/ibnL2mmep1eZgsLzzCgdeVUDL8iODmBxpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxowYMzc; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UI3SLxnH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxowYMzc";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UI3SLxnH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1786987024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4T7mX9cnhbGB7nWaJdtialUlOAZYcjHgRRlL56OYGnk=;
	b=HxowYMzcWhmSF1wtXChVKe+D0xNJuHvHlHKBdxowZ7R5ilxbxnb9tmp44MjxMsodpMJV+i
	nBStPE/J2SYK58vz72yHPY+shpEgFi0FwBDg4VreB7knCIWHVncP18KoXRoPZpN+/YLoEA
	42bujLqmKmVCOG93FCYDbBqMCvHqQx4=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-130-gBeH8mEjPhOpe_qUmFOLDQ-1; Mon, 17 Aug 2026 13:17:00 -0400
X-MC-Unique: gBeH8mEjPhOpe_qUmFOLDQ-1
X-Mimecast-MFC-AGG-ID: gBeH8mEjPhOpe_qUmFOLDQ_1786987020
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e9dee2f7b5so6446361a34.1
        for <linux-cifs@vger.kernel.org>; Mon, 17 Aug 2026 10:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1786987020; x=1787591820; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=4T7mX9cnhbGB7nWaJdtialUlOAZYcjHgRRlL56OYGnk=;
        b=UI3SLxnHNrcvdTpUbws+Khi+A58djtykKdbrtO0Hpw1EzCHWjGDpxlEbZwjkvSe9IG
         kPkeLyO6HTCOQlhYfLnnAs6rtIAdu/15K4eyfJLPqg2G/bHd9E+9SYOk16aZzEZO+rDD
         veMpTR7LH4h7DdsEoUHuSH4DAmisOXvztY854DxBJQ+xDqpIZ14AbZJkaPn4uh21IEZV
         pqSE8BY6I99bSBkfKXEBp698vsIjUdbtvppJo1dHrr4ECIPhcWBALWK3dav7im4bKHuR
         JddM+H4v1igCUPbIp1zjeLFVrHNuQ1VOR51lulrWKjyIz87tGZyBa9qzxNPHENLt/iRn
         0iCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786987020; x=1787591820;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4T7mX9cnhbGB7nWaJdtialUlOAZYcjHgRRlL56OYGnk=;
        b=aa/D6zQPL88ZzLE5HRlE3FdzXaisHI5ku4Mu2PYWAfwJ7U8p0cuJq2zGXLsoC3klnV
         L6q77KCOaJRgXSIfMiXIFgGoNqJJn2yVPsLfHXAWjV/SHIkVIy69QGXXNErQ2sgY5jr3
         E7FghorXTk99Nn0ddSufAhXxKrPOW+Y8HjuQn2BpR4Sa0YpTJGJLcJJoJO371/x6axdh
         b+B8WYxPKJ6iQ9Un21HxAntzHr53+VFb215Tl5RozIwyJ7Mbvhzdhmv88hHbe/nDrHBN
         bEFv/BZeR7NbHAobl/d98s4um5j3jtNyQbdk5WYsEjSG7/rZzF6XZaqmY3Wtj/N0JPxd
         lwyw==
X-Gm-Message-State: AOJu0YwxyQNddo6CHXsLbSSCmQF38WGIc+GhhBzJbfPu/Ppoft60LgM5
	yL/6foC14CbX0kck9kVPzFEMYobew5cJJJbQVKsZrpxlInMo+5cCY9jDajEk/5x0koHSFdY6Kzg
	JLrE+QU0fKkbGlV4IWCctyb8e0SN3YoEtwdChj+ehYUEnroGXmWiH3eMJAL+exfdC+l2L/OB4Sq
	JlJPu9k3vcRC01XEL/R+B6Zt55U56eEd1+UINzjOoVw+wXs0E=
X-Gm-Gg: AR+sD11rYWR3Tz5OfI2hhVURtXKMframCrlctwB8DESoEEhRpgfV0kT8K6RErTvfweg
	iTRdPLt8A0NKqBfJL0ZbbgFTLPvPQWravkfLUb6R9tT0NcDENMKnQMFyOp3odfttdohcbjT+lno
	VOenlMpfqRKLbPFo8gZCJuK0fmUCd1lqJOmMgkYyEhWSO84PePChvUVyuK7U3YCH2pliHOGxPS0
	6kN3x4z+i+n1D2IgYXUvVVpB3GuT8LqEu5jBGIIYTZilYeXlcjjaypxSlxer/z5zysHCdIaTAxY
	HLwt4E63VxU+ctOF/NQ46M0oeQDfvXLxDuVfLIj5YUSasto84qDjEHi7b/yjp3HDbvJpdjRyjiu
	1QNA02wWtFREuwwhf/JgwwGHMTW1PnBvhZdsZorjcur+H+162kMqH0PCCEseVjVPKuA==
X-Received: by 2002:a05:6830:2b09:b0:7e9:e8ae:7049 with SMTP id 46e09a7af769-7f3de3de1b1mr26667582a34.7.1786987019687;
        Mon, 17 Aug 2026 10:16:59 -0700 (PDT)
X-Received: by 2002:a05:6830:2b09:b0:7e9:e8ae:7049 with SMTP id 46e09a7af769-7f3de3de1b1mr26667500a34.7.1786987019136;
        Mon, 17 Aug 2026 10:16:59 -0700 (PDT)
Received: from bearskin.sorenson.redhat.com.com (c-98-227-24-213.hsd1.il.comcast.net. [98.227.24.213])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f41c0b93b3sm1891451a34.13.2026.08.17.10.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 10:16:58 -0700 (PDT)
From: Frank Sorenson <sorenson@redhat.com>
To: linux-cifs@vger.kernel.org,
	stfrench@microsoft.com
Cc: stable@vger.kernel.org
Subject: [PATCH] smb: client: fix use-before-check of ReparseDataLength in reparse_buf_ptr()
Date: Mon, 17 Aug 2026 12:16:57 -0500
Message-ID: <20260817171657.212776-1-sorenson@redhat.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

reparse_buf_ptr() reads buf->ReparseDataLength before checking that
count covers the full fixed header:

    buf = (struct reparse_data_buffer *)((u8 *)io + off);
    len = sizeof(*buf);                          /* 8 bytes */
    rdlen = le16_to_cpu(buf->ReparseDataLength); /* offset 4, 2 bytes */

    if (count < len || count < rdlen + len)      /* check comes after */

struct reparse_data_buffer has ReparseDataLength at offset 4.  If a
server returns OutputCount < 6, the read at offset 4-5 reaches past
the end of the received data.  The off+count bounds against iov_len
were already validated, but that does not protect against count being
smaller than sizeof(*buf).

Split the check: verify count >= sizeof(*buf) before reading
ReparseDataLength, then verify count covers the data region.

Fixes: a158bb66b137 ("smb: client: optimise reparse point querying")
Cc: stable@vger.kernel.org
Signed-off-by: Frank Sorenson <sorenson@redhat.com>
---
 fs/smb/client/smb2inode.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2inode.c b/fs/smb/client/smb2inode.c
index 213bc298cdf2..2946391bb992 100644
--- a/fs/smb/client/smb2inode.c
+++ b/fs/smb/client/smb2inode.c
@@ -40,9 +40,11 @@ static struct reparse_data_buffer *reparse_buf_ptr(struct kvec *iov)
 
 	buf = (struct reparse_data_buffer *)((u8 *)io + off);
 	len = sizeof(*buf);
-	rdlen = le16_to_cpu(buf->ReparseDataLength);
+	if (count < len)
+		return ERR_PTR(smb_EIO2(smb_eio_trace_reparse_rdlen, count, 0));
 
-	if (count < len || count < rdlen + len)
+	rdlen = le16_to_cpu(buf->ReparseDataLength);
+	if (count < rdlen + len)
 		return ERR_PTR(smb_EIO2(smb_eio_trace_reparse_rdlen, count, rdlen));
 	return buf;
 }
-- 
2.55.0

