Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE68191F93
	for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 14:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789138724; cv=none; b=UYn75W2etqHwOXlZTEVPBvM+J494pxA1raiSylWNhi3/b7rygUKuVVKPyScebly2xrVOKx+T3G34ZYw0pHswZrQpo3qrbnCTS7f7grHr41rL1039bcF8u4zdvh2IXHZDEq8VpDSIY8eAILxCj+c/8UvEoQ5VOBYl5yz12cl+ndg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789138724; c=relaxed/simple;
	bh=zIF97xRDmxkrD7RZY7qKo2721jxUukhbQbBdSokpQrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=dqKVqo9OYK0IH+t8lAbjG28C9poHHfpB+4sbZLj1is3zGwInIguIhzRip5761slQyyghRQ5gvbkxUHa2BHffJhC26gtqRIATUOBE1caie/LRJB2P5ka1KTeR2XhAegvjBAI9AslhZ4ZTdHVTOvQPiRvsRuQjp8JKA1iFCXRHATQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=K4hhc/jD; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="K4hhc/jD"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49e651e83dfso5773655e9.0
        for <linux-cifs@vger.kernel.org>; Fri, 11 Sep 2026 07:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1789138718; x=1789743518; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=/Tb7W5kgVkqc6kpeWvHH9IYSVovfvNchO4WGzcDWuCo=;
        b=K4hhc/jDzZIO5QyGsO9brAwG+QgEI/tlq2jcQLnZXorv1DXZoWpkoDzoQMmYgi6jom
         mlvvb/eaFX1qSoqxlxwiW1ecJkiGvTGspIwO6RhywsKZyNZB7HVl/15aatuLhW4foR/2
         UdRkqwJVemLnybuzsG9+cAquLiaSeFuyDQvRmCxWr42LIE1mYsawdi0DfQksAb1sf0if
         ly904pnQUjw/4aeM2FI/6qmnokXtJ5bN+XxtH0qApw/LqI+0Cc2V6A102rNLTC2P8tHD
         RPTBJ/BFSskf3KptmxdY21b5eFW1Kzj79aFZWAXeVAQ7Rq3Zo5tyKH5XSvryqrbuMiAx
         U2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789138718; x=1789743518;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/Tb7W5kgVkqc6kpeWvHH9IYSVovfvNchO4WGzcDWuCo=;
        b=QOcGMY8zMOHN615HglqjKXRy+IuyNDq8oeJvmCA6DaH0oU9jkSsRH0OtO9VGFE0RaS
         72c3Y98uohCFhW0lE/TkSfvhCghsbjkOmq5876Ct4uuwWaWw8wjQa1T38WQkc9jVSH+E
         lkfTMmpiUuKZXizxFin2dZ5BebLD5ACeN1nVB3h+JX1f+66Do0qBX1UE73ln+3PD6LSi
         kq4Qas9UyPijyJHnP3nKQWZ/3cuwIBa/8rI4pCRb8gezsRUZFRy0HwHpsUkYDBx6K/fa
         oX4TajtORkrgmJnq3ruuQHEyStcOOVyPhnwL51h5BOHTuWJihtBch9MQ/8MmLRF27Xfx
         AJaw==
X-Forwarded-Encrypted: i=1; AKwUvBw3kvPDnPMEmi9IvcxMUC/aAdZ8aA8aCI7NS9B2UjiNswPz9K7LeYduu25El/k7OK/BVmqvx2V/40qI@vger.kernel.org
X-Gm-Message-State: AFuF++nJ0ifyLe75l0grixsEqEjNB71QNr4P5yKfM22eCJeaXxWhLXlV
	WW3j8W0GEyHQNtD4EYUD/V45qYQQSH7YYMDPrCrG1KG13tiJtfKxSOIEFQ6Lw1+GcKbMaCtrMz3
	d94gCGRFT1ko=
X-Gm-Gg: AYBFou10o6NwO9lQe5sa4Q9yyv7xHkcklg2up/MtF2uOPFPgbNckOemhcn5WriJqGal
	LOUAmiaSvJDtBlP/FGeb4CZSCwLv1XMZ92DMvjt3cdje7FCTeOEt4AGKwGe0AE3taaWSpGt9/iV
	iwALtBBBWjGxwNN5kynGSuI+66rub80PCkAEOAueaxSCdw/voZzQeIP18xt96toLpux7gcPikQN
	n98VJ3sqmFm0qF2rij7MheiMqF2i/fqbnT6wFgaGEdFSMMtla40rb35w4BNTTL9EpUFe8vxHT35
	wsuj0lbQcTMp0OWiyqVv+KmmwrMnT0DwEY3mHdjHtsBp0AO+sERqo6sXVtI6HDTPKM04I1NL6mC
	TaKRicvOf0NrIlONIBQCH+ehkERqJQB+UygW1iFAINPYaXDGeq5aH7GwrUBf/XSiVSPOsVQqh0/
	IiZZu3P7cVIV9WuggifjJ5xG+DLcJsdDmNks89lVmDmEqOdpCXqnmssEWshd9XJWbPAmtp+1xUq
	WkOU0PprwXPEd/sxykC7XrIQsmahZ83qja12Yg=
X-Received: by 2002:a05:600c:1d08:b0:49b:8f18:714a with SMTP id 5b1f17b1804b1-49e619acfe0mr57704205e9.12.1789138718643;
        Fri, 11 Sep 2026 07:58:38 -0700 (PDT)
Received: from debian12.ucl.ac.uk (eduroam-int-pat-8-79.ucl.ac.uk. [144.82.8.79])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e61a81943sm50432915e9.1.2026.09.11.07.58.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 07:58:37 -0700 (PDT)
From: Diego Oliva <diego@bynar.io>
To: Paulo Alcantara <pc@manguebit.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	linux-cifs@vger.kernel.org
Cc: Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	David Howells <dhowells@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	samba-technical@lists.samba.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] smb: client: validate SMB1 write and query response lengths
Date: Fri, 11 Sep 2026 15:57:55 +0100
Message-Id: <20260911145758.3833254-1-diego@bynar.io>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Three fixes for SMB1 reply parsers that dereference a response struct
without first establishing that the response was long enough to hold
it. They are the same class of defect as the recent "smb: client:
reject short READ responses in CIFSSMBRead()", generalised to the
write and legacy query paths.

checkSMB() only requires the RFC1002 length to agree with WordCount
and the byte count; it does not check either against what the command
in question requires. Every fixed-layout SMB1 response struct is
therefore unguarded unless its own parser checks: a reply carrying a
smaller WordCount than the command expects is accepted and handed to
the parser with rc == 0, and the smallest such reply is 35 bytes, a
header with WordCount and ByteCount both zero.

Patch 1 adds the missing minimum-length check to the three WRITE_RSP
parsers, and patch 3 does the same for SMBQueryInformation(). In each
case the size required is exactly the smallest reply a conforming
server can send for the word count the response is documented to
carry, so no legitimate server can be rejected:

  sizeof(WRITE_RSP)              wct = 6    33 + 2*6  + 2 = 47
  sizeof(QUERY_INFORMATION_RSP)  wct = 10   33 + 2*10 + 2 = 55

where 33 is sizeof(struct smb_hdr) and the trailing 2 is ByteCount.

Patch 2 is a different bug in one of the same parsers.
cifs_writev_callback() accepts a byte count larger than the length it
asked to write - the existing OS/2 workaround only masks off the high
16 bits - and hands it to netfs, which answers with a WARN() from
netfs_write_subrequest_terminated(). Before netfs clamps the value,
cifs_write_subrequest_terminated() has already used it to grow the
client's idea of the file size. Reject the reply instead.

All three use smb_EIO2(), introduced in v6.19, so they do not apply to
older stable trees as-is, and substituting plain -EIO is not enough on
its own: older trees shape struct smb_hdr and struct mid_q_entry
differently, so both the sizeof() bounds these patches test against and
the response length patch 1 reads out of the mid need reworking.

Diego Oliva (3):
  smb: client: reject short WRITE responses in the SMB1 write paths
  smb: client: reject over-long write counts in cifs_writev_callback()
  smb: client: reject short responses in SMBQueryInformation()

 fs/smb/client/cifssmb.c | 36 ++++++++++++++++++++++++++++++++++++
 fs/smb/client/trace.h   |  3 +++
 2 files changed, 39 insertions(+)


base-commit: 0a96d0d726cd380423ac38e2c28f538db2940a1d
-- 
2.39.5

